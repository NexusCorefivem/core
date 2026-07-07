CreateThread(function()
    Wait(1000)
    local spot = NexusConfig.Laundering.spot
    exports["nexus-target"]:RegisterZone("laundering:spot", {
        coords = spot.coords,
        radius = spot.radius or 2.5,
        label = spot.label or "Launder money"
    })
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if zoneId ~= "laundering:spot" then
        return
    end

    TriggerServerEvent("nexus:laundering:wash", 1000)
end)
