local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:taxi:completeFare", function()
    local source = source
    if not NexusSecurity.IsOnDuty(source, "taxi") then
        notify(source, "taxi.not_on_duty")
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "taxi:fare", 45) then
        return
    end

    local cfg = NexusConfig.JobLocations.taxi
    local payout = math.random(cfg.fareMin, cfg.fareMax)
    exports["nexus-economy"]:AddMoney(source, "cash", payout)
    notify(source, "taxi.fare_received", payout)
end)
