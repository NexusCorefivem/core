CreateThread(function()
    while true do
        Wait(10000)
        local ped = PlayerPedId()
        if ped and ped > 0 then
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            TriggerNexusCallback("nexus:characters:updateLocation", {
                x = coords.x,
                y = coords.y,
                z = coords.z,
                w = heading
            }, function() end)
        end
    end
end)
