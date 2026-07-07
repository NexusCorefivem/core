local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:carwash:wash", function(washId)
    local source = source
    local wash = NexusConfig.Carwash[washId]
    if not wash or not NexusSecurity.IsNearZone(source, wash) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "carwash:" .. washId, 10) then
        return
    end

    if not exports["nexus-economy"]:RemoveMoney(source, "cash", wash.price) then
        notify(source, "shops.no_money")
        return
    end

    TriggerClientEvent("nexus:carwash:client:clean", source)
    notify(source, "carwash.cleaned", wash.price)
end)
