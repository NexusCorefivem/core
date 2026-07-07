NexusPlayers = {}

local Player = {}
Player.__index = Player

function Player.new(source, accountId, characterData)
    local self = setmetatable({}, Player)
    self.source = source
    self.accountId = accountId
    self.characterId = characterData.id
    self.citizenId = characterData.citizenid
    self.firstname = characterData.firstname
    self.lastname = characterData.lastname
    self.job = {
        name = characterData.job_name or "unemployed",
        grade = characterData.job_grade or 0,
        onduty = characterData.job_duty == 1
    }
    self.money = {
        cash = characterData.cash or NexusConfig.Money.defaultCash,
        bank = characterData.bank or NexusConfig.Money.defaultBank,
        dirty = characterData.dirty_money or NexusConfig.Money.defaultDirty
    }
    self.spawn = characterData.spawn or "{}"
    self.lastLocation = characterData.last_location or "{}"
    self.appearance = characterData.appearance or "{}"
    self.metadata = characterData.metadata or "{}"
    self.locale = NexusNormalizeLocale(characterData.locale or NexusConfig.Framework.defaultLocale)
    return self
end

function Player:GetName()
    return ("%s %s"):format(self.firstname, self.lastname)
end

function Player:SetMoney(account, amount)
    amount = tonumber(amount) or 0
    self.money[account] = math.max(0, math.floor(amount))
end

function Player:AddMoney(account, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then
        return false
    end

    self:SetMoney(account, (self.money[account] or 0) + amount)
    return true
end

function Player:RemoveMoney(account, amount)
    amount = tonumber(amount) or 0
    if amount <= 0 then
        return false
    end

    if (self.money[account] or 0) < amount then
        return false
    end

    self:SetMoney(account, self.money[account] - amount)
    return true
end

function Player:SetJob(jobName, grade, onduty)
    self.job.name = jobName
    self.job.grade = grade or 0
    self.job.onduty = onduty == true
end

function Player:Save()
    NexusDatabase.Execute([[
        UPDATE nexus_characters
        SET cash = ?, bank = ?, dirty_money = ?, job_name = ?, job_grade = ?, job_duty = ?, spawn = ?, appearance = ?, metadata = ?, locale = ?, last_location = ?
        WHERE id = ?
    ]], {
        self.money.cash,
        self.money.bank,
        self.money.dirty,
        self.job.name,
        self.job.grade,
        self.job.onduty and 1 or 0,
        self.spawn,
        self.appearance,
        self.metadata,
        self.locale,
        self.lastLocation,
        self.characterId
    })
end

function GetNexusPlayer(source)
    return NexusPlayers[source]
end

function SetNexusPlayer(source, player)
    NexusPlayers[source] = player
end

function RemoveNexusPlayer(source)
    local player = NexusPlayers[source]
    if player then
        player:Save()
        TriggerClientEvent(NexusEvents.playerUnloaded, source)
        NexusPlayers[source] = nil
    end
end
