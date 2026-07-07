NexusCore = {
    version = NexusConfig.Framework.version
}

math.randomseed(GetGameTimer())

local function notifyPlayer(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

local function getLocaleLabel(locale)
    local labels = {
        nl = "Nederlands",
        en = "English",
        de = "Deutsch",
        fr = "Francais"
    }

    return labels[locale] or locale
end

local function applyPlayerLocale(source, locale)
    local player = GetNexusPlayer(source)
    if not player then
        return false
    end

    local normalized = NexusNormalizeLocale(locale)
    local requested = type(locale) == "string" and locale:lower() or ""

    if normalized ~= requested then
        notifyPlayer(source, "core.language_invalid")
        return false
    end

    player.locale = normalized
    TriggerClientEvent(NexusEvents.localeChanged, source, normalized)
    notifyPlayer(source, "core.language_changed", getLocaleLabel(normalized))
    return true
end

local function getPrimaryIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for _, identifier in ipairs(identifiers) do
        if identifier:find("license:") == 1 then
            return identifier
        end
    end

    return identifiers[1]
end

local function sanitizeName(value, fallback)
    value = NexusShared.SanitizeShortString(value, fallback, 24)
    value = value:gsub("%s+", " ")

    if value == "" then
        return fallback
    end

    return value
end

local function sanitizeGender(value)
    if value == "f" then
        return "f"
    end

    return "m"
end

local function sanitizeDateOfBirth(value)
    if type(value) ~= "string" then
        return "1990-01-01"
    end

    if value:match("^%d%d%d%d%-%d%d%-%d%d$") then
        return value
    end

    return "1990-01-01"
end

local function buildDefaultAppearance(gender)
    local model = gender == "f" and NexusConfig.Appearance.defaultModelFemale or NexusConfig.Appearance.defaultModelMale
    return json.encode({
        model = model,
        components = NexusShared.DeepCopy(NexusConfig.Appearance.defaultComponents),
        props = {},
        headBlend = {
            shapeFirst = 0,
            shapeSecond = 0,
            skinFirst = 0,
            skinSecond = 0,
            shapeMix = 0.5,
            skinMix = 0.5
        }
    })
end

local function decodeJson(value, fallback)
    local ok, decoded = pcall(json.decode, value or "")
    if ok and decoded ~= nil then
        return decoded
    end

    return fallback
end

local function generatePhone()
    return ("06%08d"):format(math.random(10000000, 99999999))
end

local function isCharacterCreateAllowedPayload(payload)
    return type(payload) == "table"
end

local function isPlayerBanned(source)
    return NexusSecurity.GetBanForSource(source)
end

AddEventHandler("playerConnecting", function(_, _, deferrals)
    local source = source
    deferrals.defer()
    Wait(0)
    deferrals.update("Nexus Core: checking ban status...")

    local banResult = isPlayerBanned(source)
    if banResult.banned then
        deferrals.done(banResult.reason or "You are banned from this server.")
        return
    end

    deferrals.done()
end)

local function getOrCreateAccount(source)
    local identifier = getPrimaryIdentifier(source)
    if not identifier then
        return nil, nil
    end

    local account = NexusDatabase.FetchSingle("SELECT * FROM nexus_accounts WHERE license = ?", { identifier })

    if account then
        return account.id, identifier
    end

    local accountId = NexusDatabase.Insert("INSERT INTO nexus_accounts (license, last_name) VALUES (?, ?)", {
        identifier,
        GetPlayerName(source) or "Unknown"
    })

    return accountId, identifier
end

RegisterNexusCallback("nexus:characters:list", function(source)
    local accountId = select(1, getOrCreateAccount(source))
    if not accountId then
        return {}
    end

    return NexusDatabase.FetchAll("SELECT * FROM nexus_characters WHERE account_id = ? AND deleted_at IS NULL ORDER BY id ASC", { accountId })
end)

RegisterNexusCallback("nexus:characters:create", function(source, payload)
    if not isCharacterCreateAllowedPayload(payload) then
        payload = {}
    end

    local accountId = select(1, getOrCreateAccount(source))
    if not accountId then
        return nil
    end

    local existingCharacters = NexusDatabase.FetchSingle("SELECT COUNT(*) as total FROM nexus_characters WHERE account_id = ?", { accountId })
    if existingCharacters and (existingCharacters.total or 0) >= NexusConfig.Framework.maxCharacters then
        return nil
    end

    local citizenId = NexusShared.GenerateCitizenId()
    local spawn = json.encode({
        x = NexusConfig.Framework.defaultSpawn.x,
        y = NexusConfig.Framework.defaultSpawn.y,
        z = NexusConfig.Framework.defaultSpawn.z,
        w = NexusConfig.Framework.defaultSpawn.w
    })

    local characterId = NexusDatabase.Insert([[
        INSERT INTO nexus_characters (
            account_id, citizenid, firstname, lastname, dateofbirth, gender, nationality, phone,
            cash, bank, dirty_money, job_name, job_grade, job_duty, gang_name, gang_grade,
            spawn, appearance, metadata, locale, last_location
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        accountId,
        citizenId,
        sanitizeName(payload.firstname, NexusTranslate(NexusConfig.Framework.defaultLocale, "core.character_firstname")),
        sanitizeName(payload.lastname, NexusTranslate(NexusConfig.Framework.defaultLocale, "core.character_lastname")),
        sanitizeDateOfBirth(payload.dateofbirth),
        sanitizeGender(payload.gender),
        "NL",
        generatePhone(),
        NexusConfig.Money.defaultCash,
        NexusConfig.Money.defaultBank,
        NexusConfig.Money.defaultDirty,
        "unemployed",
        0,
        0,
        "none",
        0,
        spawn,
        buildDefaultAppearance(sanitizeGender(payload.gender)),
        "{}",
        NexusNormalizeLocale(payload.locale or NexusConfig.Framework.defaultLocale),
        spawn
    })

    if not characterId then
        return nil
    end

    return { id = characterId, citizenid = citizenId }
end)

RegisterNexusCallback("nexus:characters:delete", function(source, payload)
    if type(payload) ~= "table" then
        return false
    end

    local accountId = select(1, getOrCreateAccount(source))
    local characterId = tonumber(payload.characterId)
    if not accountId or not characterId then
        return false
    end

    local affected = NexusDatabase.Execute("UPDATE nexus_characters SET deleted_at = CURRENT_TIMESTAMP WHERE id = ? AND account_id = ? AND deleted_at IS NULL", {
        characterId, accountId
    })

    return affected and affected > 0
end)

RegisterNexusCallback("nexus:characters:updateLocation", function(source, payload)
    local player = GetNexusPlayer(source)
    if not player or type(payload) ~= "table" then
        return false
    end

    if not NexusSecurity.CheckRateLimit(source, "location", 30) then
        return false
    end

    player.lastLocation = json.encode({
        x = tonumber(payload.x) or NexusConfig.Framework.defaultSpawn.x,
        y = tonumber(payload.y) or NexusConfig.Framework.defaultSpawn.y,
        z = tonumber(payload.z) or NexusConfig.Framework.defaultSpawn.z,
        w = tonumber(payload.w) or NexusConfig.Framework.defaultSpawn.w
    })
    return true
end)

RegisterNexusCallback("nexus:locale:get", function(source)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    return {
        current = locale,
        supported = NexusGetSupportedLocales()
    }
end)

RegisterNetEvent(NexusEvents.characterSelected, function(characterId)
    local source = source

    local banResult = isPlayerBanned(source)
    if banResult.banned then
        DropPlayer(source, banResult.reason or "Banned.")
        return
    end

    characterId = tonumber(characterId)
    if not characterId then
        DropPlayer(source, NexusTranslate(NexusConfig.Framework.defaultLocale, "core.invalid_character"))
        return
    end

    if GetNexusPlayer(source) then
        RemoveNexusPlayer(source)
    end

    local accountId = select(1, getOrCreateAccount(source))
    if not accountId then
        DropPlayer(source, "Missing player identifier.")
        return
    end

    local character = NexusDatabase.FetchSingle("SELECT * FROM nexus_characters WHERE id = ? AND account_id = ? AND deleted_at IS NULL", {
        characterId, accountId
    })

    if not character then
        DropPlayer(source, NexusTranslate(NexusConfig.Framework.defaultLocale, "core.invalid_character"))
        return
    end

    local license = getPrimaryIdentifier(source)
    local player = NexusPlayer.new(source, accountId, character, license)
    player.permissions = NexusPermissions.GetGroup(source)
    SetNexusPlayer(source, player)

    local playerData = player:GetPlayerData()
    local playerState = Player(source)
    if playerState and playerState.state then
        playerState.state:set("isLoggedIn", true, true)
        playerState.state:set("citizenid", player.citizenId, true)
        playerState.state:set("job", playerData.job, true)
        playerState.state:set("gang", playerData.gang, true)
    end

    TriggerEvent(NexusEvents.serverPlayerLoaded, source, player)
    TriggerEvent(NexusEvents.serverOnPlayerLoaded, source, player, playerData)

    TriggerClientEvent(NexusEvents.playerLoaded, source, playerData)
    TriggerClientEvent(NexusEvents.clientOnPlayerLoaded, source, playerData)
    TriggerClientEvent(NexusEvents.clientSetPlayerData, source, playerData)
end)

RegisterNetEvent(NexusEvents.setLocale, function(locale)
    applyPlayerLocale(source, locale)
end)

RegisterCommand("language", function(source, args)
    if source == 0 then
        print("Usage: /language <nl|en|de|fr>")
        return
    end

    local requested = args[1]
    if not requested then
        local player = GetNexusPlayer(source)
        local current = player and player.locale or NexusConfig.Framework.defaultLocale
        notifyPlayer(source, "core.language_current", getLocaleLabel(current))
        return
    end

    applyPlayerLocale(source, requested)
end, false)

AddEventHandler("playerDropped", function()
    RemoveNexusPlayer(source)
end)

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName ~= GetCurrentResourceName() then
        return
    end

    for source, _ in pairs(NexusPlayers) do
        RemoveNexusPlayer(source)
    end
end)

NexusDatabase.OnReady(function()
    if NexusConfig.Framework.debug then
        print(("[nexus-core] %s v%s initialized."):format(NexusConfig.Framework.name, NexusConfig.Framework.version))
    end
end)
