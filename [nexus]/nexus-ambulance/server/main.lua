local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:ambulance:heal", function(targetSource)
    local source = source
    targetSource = tonumber(targetSource)
    if not targetSource or not GetNexusPlayer(targetSource) then
        return
    end

    if not NexusSecurity.IsMedicOnDuty(source) then
        return
    end

    local maxDistance = NexusConfig.Ambulance.reviveDistance or 3.0
    if not NexusSecurity.IsNearPlayer(source, targetSource, maxDistance) then
        return
    end

    TriggerClientEvent("nexus:ambulance:client:heal", targetSource, NexusConfig.Ambulance.healAmount)
    notify(source, "ambulance.healed")
end)

RegisterNetEvent("nexus:ambulance:revive", function(targetSource)
    local source = source
    targetSource = tonumber(targetSource)
    if not NexusSecurity.IsMedicOnDuty(source) or not targetSource or not GetNexusPlayer(targetSource) then
        return
    end

    local maxDistance = NexusConfig.Ambulance.reviveDistance or 3.0
    if not NexusSecurity.IsNearPlayer(source, targetSource, maxDistance) then
        return
    end

    exports["nexus-core"]:SetPlayerDeathStatus(targetSource, false)
    TriggerClientEvent("nexus:ambulance:client:revive", targetSource)
    notify(source, "ambulance.revived")
end)
