local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:mechanic:repair", function()
    local source = source
    if not NexusSecurity.IsOnDuty(source, "mechanic") then
        notify(source, "mechanic.not_on_duty")
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "mechanic:repair", 15) then
        return
    end

    if not NexusSecurity.IsNearZone(source, NexusConfig.JobLocations.mechanic.shop) then
        return
    end

    local payout = NexusConfig.JobLocations.mechanic.repairPayout
    exports["nexus-economy"]:AddMoney(source, "cash", payout)
    TriggerClientEvent("nexus:mechanic:client:repair", source)
    notify(source, "mechanic.repair_complete", payout)
end)
