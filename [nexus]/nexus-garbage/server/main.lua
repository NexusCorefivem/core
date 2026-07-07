local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:garbage:completeStop", function()
    local source = source
    if not NexusSecurity.IsOnDuty(source, "garbage") then
        notify(source, "garbage.not_on_duty")
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "garbage:stop", 20) then
        return
    end

    local payout = NexusConfig.JobLocations.garbage.payoutPerStop
    exports["nexus-economy"]:AddMoney(source, "cash", payout)
    notify(source, "garbage.stop_complete", payout)
end)
