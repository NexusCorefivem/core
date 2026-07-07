NexusPlayers = {}
NexusPlayersByCitizenId = {}

NexusPlayer = {}
NexusPlayer.__index = NexusPlayer

local function generatePhone()
    return ("06%08d"):format(math.random(10000000, 99999999))
end

function NexusPlayer.new(source, accountId, characterData, license)
    local self = setmetatable({}, NexusPlayer)
    self.source = source
    self.accountId = accountId
    self.license = license
    self.characterId = characterData.id
    self.citizenId = characterData.citizenid
    self.firstname = characterData.firstname
    self.lastname = characterData.lastname
    self.dateofbirth = characterData.dateofbirth
    self.gender = characterData.gender
    self.nationality = characterData.nationality or "NL"
    self.phone = characterData.phone or generatePhone()
    self.job = {
        name = characterData.job_name or "unemployed",
        grade = characterData.job_grade or 0,
        onduty = characterData.job_duty == 1
    }
    self.gang = {
        name = characterData.gang_name or "none",
        grade = characterData.gang_grade or 0
    }
    self.money = {
        cash = characterData.cash or NexusConfig.Money.defaultCash,
        bank = characterData.bank or NexusConfig.Money.defaultBank,
        dirty = characterData.dirty_money or NexusConfig.Money.defaultDirty
    }
    self.spawn = characterData.spawn or "{}"
    self.lastLocation = characterData.last_location or self.spawn
    self.appearance = characterData.appearance or "{}"
    self.metadata = characterData.metadata or "{}"
    self.locale = NexusNormalizeLocale(characterData.locale or NexusConfig.Framework.defaultLocale)
    self.isdead = characterData.is_dead == 1
    self.injail = characterData.injail or 0
    self.permissions = "player"
    return self
end

function NexusPlayer:GetName()
    return ("%s %s"):format(self.firstname, self.lastname)
end

function NexusPlayer:GetAppearance()
    local ok, data = pcall(json.decode, self.appearance or "{}")
    if ok and type(data) == "table" then
        return data
    end
    return {}
end

function NexusPlayer:GetPlayerData()
    return NexusShared.BuildPlayerData(self)
end

function NexusPlayer:SetMoney(account, amount)
    amount = tonumber(amount) or 0
    self.money[account] = math.max(0, math.floor(amount))
end

function NexusPlayer:AddMoney(account, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then
        return false
    end

    self:SetMoney(account, (self.money[account] or 0) + amount)
    SyncPlayerData(self.source, "money", self.money)
    return true
end

function NexusPlayer:RemoveMoney(account, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then
        return false
    end

    if (self.money[account] or 0) < amount then
        return false
    end

    self:SetMoney(account, self.money[account] - amount)
    SyncPlayerData(self.source, "money", self.money)
    return true
end

function NexusPlayer:SetJob(jobName, grade, onduty)
    self.job.name = jobName
    self.job.grade = grade or 0
    self.job.onduty = onduty == true
    SyncPlayerData(self.source, "job", self.job)
end

function NexusPlayer:SetGang(gangName, grade)
    self.gang.name = gangName or "none"
    self.gang.grade = grade or 0
    SyncPlayerData(self.source, "gang", self.gang)
end

function NexusPlayer:GetMetadata(key)
    local ok, data = pcall(json.decode, self.metadata or "{}")
    if not ok or type(data) ~= "table" then
        data = {}
    end

    if key ~= nil then
        return data[key]
    end

    return data
end

function NexusPlayer:SetMetadata(key, value)
    local data = self:GetMetadata() or {}
    data[key] = value
    self.metadata = json.encode(data)
    SyncPlayerData(self.source, "metadata", data)
end

function NexusPlayer:SetDeathStatus(isDead)
    self.isdead = isDead == true
    TriggerClientEvent(NexusEvents.clientSetDeathStatus, self.source, self.isdead)
    TriggerEvent(NexusEvents.serverSetDeathStatus, self.source, self.isdead)
end

function NexusPlayer:Save()
    local position = {}
    local ok, decoded = pcall(json.decode, self.lastLocation or "{}")
    if ok and type(decoded) == "table" then
        position = decoded
    end

    NexusDatabase.Execute([[
        UPDATE nexus_characters
        SET cash = ?, bank = ?, dirty_money = ?, job_name = ?, job_grade = ?, job_duty = ?,
            gang_name = ?, gang_grade = ?, phone = ?, spawn = ?, appearance = ?, metadata = ?,
            locale = ?, last_location = ?, position_x = ?, position_y = ?, position_z = ?, position_h = ?,
            is_dead = ?, injail = ?, last_played = CURRENT_TIMESTAMP
        WHERE id = ?
    ]], {
        self.money.cash,
        self.money.bank,
        self.money.dirty,
        self.job.name,
        self.job.grade,
        self.job.onduty and 1 or 0,
        self.gang.name,
        self.gang.grade,
        self.phone,
        self.spawn,
        self.appearance,
        self.metadata,
        self.locale,
        self.lastLocation,
        position.x,
        position.y,
        position.z,
        position.w,
        self.isdead and 1 or 0,
        self.injail or 0,
        self.characterId
    })
end

function GetNexusPlayer(source)
    return NexusPlayers[source]
end

function GetNexusPlayerByCitizenId(citizenId)
    return NexusPlayersByCitizenId[citizenId]
end

function SetNexusPlayer(source, player)
    NexusPlayers[source] = player
    if player and player.citizenId then
        NexusPlayersByCitizenId[player.citizenId] = player
    end
end

function SyncPlayerData(source, key, value)
    local player = GetNexusPlayer(source)
    if not player then
        return
    end

    local playerData = player:GetPlayerData()
    TriggerClientEvent(NexusEvents.clientSetPlayerData, source, playerData, key)

    if key == "job" then
        TriggerClientEvent(NexusEvents.clientOnJobUpdate, source, playerData.job)
        TriggerEvent(NexusEvents.serverOnJobUpdate, source, playerData.job)
    elseif key == "money" then
        TriggerClientEvent(NexusEvents.clientOnMoneyChange, source, playerData.money)
        TriggerEvent(NexusEvents.serverOnMoneyChange, source, playerData.money)
    elseif key == "gang" then
        TriggerClientEvent(NexusEvents.clientOnGangUpdate, source, playerData.gang)
        TriggerEvent(NexusEvents.serverOnGangUpdate, source, playerData.gang)
    elseif key == "metadata" then
        TriggerClientEvent(NexusEvents.clientOnMetadataUpdate, source, playerData.metadata)
        TriggerEvent(NexusEvents.serverOnMetadataUpdate, source, playerData.metadata)
    end
end

function RemoveNexusPlayer(source)
    local player = NexusPlayers[source]
    if player then
        TriggerEvent(NexusEvents.serverOnPlayerUnload, source, player)
        TriggerEvent(NexusEvents.serverPlayerUnloaded, source, player)
        player:Save()

        if player.citizenId then
            NexusPlayersByCitizenId[player.citizenId] = nil
        end

        local playerState = Player(source)
        if playerState and playerState.state then
            playerState.state:set("isLoggedIn", false, true)
            playerState.state:set("citizenid", nil, true)
        end

        TriggerClientEvent(NexusEvents.clientOnPlayerUnload, source)
        TriggerClientEvent(NexusEvents.playerUnloaded, source)
        NexusPlayers[source] = nil
    end
end
