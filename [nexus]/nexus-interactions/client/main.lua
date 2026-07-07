CreateThread(function()
    Wait(1000)
    for interactionId, interaction in pairs(NexusConfig.Interactions) do
        exports["nexus-target"]:RegisterZone("interaction:" .. interactionId, {
            coords = interaction.coords,
            radius = interaction.radius or 2.0,
            label = interaction.label or "[E] Interact"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId, zone)
    if type(zoneId) ~= "string" or not zoneId:find("^interaction:") then
        return
    end

    local interactionId = zoneId:gsub("^interaction:", "")
    local interaction = NexusConfig.Interactions[interactionId]
    if not interaction or not interaction.scenario then
        return
    end

    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, interaction.scenario, 0, true)
end)
