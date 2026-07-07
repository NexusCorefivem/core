local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:customs:service", function(customsId, serviceType)
    local source = source
    if type(customsId) ~= "string" or type(serviceType) ~= "string" then
        return
    end

    local customs = NexusConfig.Customs[customsId]
    if not customs or not NexusSecurity.IsNearZone(source, customs) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "customs:" .. customsId, 5) then
        return
    end

    local price = serviceType == "tune" and customs.tunePrice or customs.repairPrice
    if not exports["nexus-economy"]:RemoveMoney(source, "bank", price) then
        notify(source, "customs.no_money")
        return
    end

    TriggerClientEvent("nexus:customs:client:apply", source, serviceType)
    notify(source, serviceType == "tune" and "customs.tuned" or "customs.repaired", price)
end)
