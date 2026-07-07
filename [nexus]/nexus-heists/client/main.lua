CreateThread(function()
    Wait(1000)
    for heistId, heist in pairs(NexusConfig.Heists) do
        exports["nexus-target"]:RegisterZone("heist:" .. heistId, {
            coords = heist.coords,
            radius = heist.radius or 5.0,
            label = heist.label or "Heist"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^heist:") then
        return
    end

    TriggerServerEvent("nexus:heists:start", zoneId:gsub("^heist:", ""))
end)
