RegisterNetEvent("nexus:admin:client:teleport", function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x + 0.0, y + 0.0, z + 0.0, false, false, false, false)
end)

RegisterCommand("tp", function(_, args)
    TriggerServerEvent("nexus:admin:teleport", tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
end, false)

RegisterCommand("tpm", function()
    local waypoint = GetFirstBlipInfoId(8)
    if waypoint == 0 then
        return
    end

    local coords = GetBlipInfoIdCoord(waypoint)
    TriggerServerEvent("nexus:admin:teleport", coords.x, coords.y, coords.z)
end, false)
