local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:trucker:completeDelivery", function()
    local source = source
    if not NexusSecurity.IsOnDuty(source, "trucker") then
        notify(source, "trucker.not_on_duty")
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "trucker:delivery", 60) then
        return
    end

    if not NexusSecurity.IsNearZone(source, NexusConfig.JobLocations.trucker.delivery) then
        return
    end

    local payout = NexusConfig.JobLocations.trucker.payout
    exports["nexus-economy"]:AddMoney(source, "cash", payout)
    notify(source, "trucker.delivery_complete", payout)
end)
