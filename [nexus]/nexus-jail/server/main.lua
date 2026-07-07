local jailedPlayers = {}

local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:jail:jail", function(targetSource, minutes)
    local source = source
    targetSource = tonumber(targetSource)
    minutes = math.floor(tonumber(minutes) or 5)

    if not NexusSecurity.IsPoliceOnDuty(source) or not targetSource or minutes <= 0 or minutes > 120 then
        return
    end

    if not GetNexusPlayer(targetSource) then
        return
    end

    if not NexusSecurity.IsNearPlayer(source, targetSource, NexusConfig.Police.cuffDistance or 2.5) then
        return
    end

    local target = GetNexusPlayer(targetSource)
    target.injail = minutes
    target:Save()

    jailedPlayers[targetSource] = os.time() + (minutes * 60)
    TriggerClientEvent("nexus:jail:client:jail", targetSource, NexusConfig.Jail.coords)
    notify(source, "jail.jailed", minutes)
end)

CreateThread(function()
    while true do
        Wait(5000)
        local now = os.time()
        for source, releaseAt in pairs(jailedPlayers) do
            if now >= releaseAt then
                jailedPlayers[source] = nil
                local player = GetNexusPlayer(source)
                if player then
                    player.injail = 0
                    player:Save()
                end
                TriggerClientEvent("nexus:jail:client:release", source, NexusConfig.Jail.releaseCoords)
                notify(source, "jail.released")
            end
        end
    end
end)
