local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

local function ensurePropertyRow(propertyKey, label)
    local row = NexusDatabase.FetchSingle("SELECT * FROM nexus_properties WHERE property_key = ?", { propertyKey })
    if row then
        return row
    end

    NexusDatabase.Insert("INSERT INTO nexus_properties (property_key, label) VALUES (?, ?)", {
        propertyKey, label
    })

    return NexusDatabase.FetchSingle("SELECT * FROM nexus_properties WHERE property_key = ?", { propertyKey })
end

RegisterNexusCallback("nexus:housing:get", function(source, payload)
    if type(payload) ~= "table" then
        return nil
    end

    local property = ensurePropertyRow(payload.propertyKey, payload.label or payload.propertyKey)
    local player = GetNexusPlayer(source)
    if not property or not player then
        return nil
    end

    return {
        property = property,
        isOwner = property.owner_character_id == player.characterId
    }
end)

RegisterNetEvent("nexus:housing:buy", function(propertyKey)
    local source = source
    local config = NexusConfig.Housing[propertyKey]
    local player = GetNexusPlayer(source)
    if not config or not player then
        return
    end

    local property = ensurePropertyRow(propertyKey, config.label)
    if property.owner_character_id then
        return
    end

    if not exports["nexus-economy"]:RemoveMoney(source, "bank", config.price) then
        notify(source, "shops.no_money")
        return
    end

    NexusDatabase.Execute("UPDATE nexus_properties SET owner_character_id = ? WHERE property_key = ?", {
        player.characterId, propertyKey
    })

    notify(source, "housing.bought", config.label)
end)

RegisterNetEvent("nexus:housing:enter", function(propertyKey)
    local source = source
    local config = NexusConfig.Housing[propertyKey]
    local player = GetNexusPlayer(source)
    if not config or not player then
        return
    end

    local property = ensurePropertyRow(propertyKey, config.label)
    if property.owner_character_id ~= player.characterId then
        notify(source, "housing.not_owner")
        return
    end

    TriggerClientEvent("nexus:housing:client:enter", source, config.interior)
    notify(source, "housing.entered")
end)

RegisterNetEvent("nexus:housing:exit", function()
    local source = source
    TriggerClientEvent("nexus:housing:client:exit", source, NexusConfig.Framework.defaultSpawn)
    notify(source, "housing.exited")
end)
