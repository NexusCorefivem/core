CreateThread(function()
    Wait(1000)
    for fieldId, field in pairs(NexusConfig.Drugs) do
        exports["nexus-target"]:RegisterZone("drugs:" .. fieldId, {
            coords = field.coords,
            radius = field.radius or 5.0,
            label = field.label or "Harvest"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^drugs:") then
        return
    end

    TriggerServerEvent("nexus:drugs:harvest", zoneId:gsub("^drugs:", ""))
end)
