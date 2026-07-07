CreateThread(function()
    Wait(1000)
    for robberyId, robbery in pairs(NexusConfig.Robberies) do
        exports["nexus-target"]:RegisterZone("robbery:" .. robberyId, {
            coords = robbery.coords,
            radius = robbery.radius or 3.0,
            label = robbery.label or "Rob"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^robbery:") then
        return
    end

    TriggerServerEvent("nexus:robberies:start", zoneId:gsub("^robbery:", ""))
end)
