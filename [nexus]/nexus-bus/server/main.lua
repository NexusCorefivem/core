local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:bus:completeStop", function()
    local source = source
    if not NexusSecurity.IsOnDuty(source, "bus") then
        notify(source, "bus.not_on_duty")
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "bus:stop", 20) then
        return
    end

    local payout = NexusConfig.JobLocations.bus.payoutPerStop
    exports["nexus-economy"]:AddMoney(source, "cash", payout)
    notify(source, "bus.stop_complete", payout)
end)
