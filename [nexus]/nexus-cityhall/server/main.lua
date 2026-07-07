local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:cityhall:purchase", function(itemType)
    local source = source
    local player = GetNexusPlayer(source)
    if not player then
        return
    end

    if not NexusSecurity.IsNearZone(source, NexusConfig.CityHall) then
        return
    end

    if itemType ~= "license" and itemType ~= "id" then
        return
    end

    local price = itemType == "license" and NexusConfig.CityHall.licensePrice or NexusConfig.CityHall.idPrice
    if not exports["nexus-economy"]:RemoveMoney(source, "cash", price) then
        notify(source, "shops.no_money")
        return
    end

    if itemType == "license" then
        player:SetMetadata("driver_license", true)
        notify(source, "cityhall.license_bought")
    else
        player:SetMetadata("id_card", true)
        notify(source, "cityhall.id_bought")
    end

    player:Save()
end)
