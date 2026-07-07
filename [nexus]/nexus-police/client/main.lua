local isCuffed = false

RegisterNetEvent("nexus:police:client:cuff", function(state)
    isCuffed = state == true
end)

CreateThread(function()
    while true do
        if isCuffed then
            DisableAllControlActions(0)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

RegisterCommand("cuff", function(_, args)
    TriggerServerEvent("nexus:police:cuff", tonumber(args[1]))
end, false)

RegisterCommand("fine", function(_, args)
    TriggerServerEvent("nexus:police:fine", tonumber(args[1]), tonumber(args[2]))
end, false)

RegisterCommand("impound", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    end

    if vehicle ~= 0 then
        TriggerServerEvent("nexus:police:impound", GetVehicleNumberPlateText(vehicle))
    end
end, false)

RegisterNetEvent("nexus:police:client:deleteVehicle", function(plate)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 8.0, 0, 70)
    end

    if vehicle ~= 0 and GetVehicleNumberPlateText(vehicle) == plate then
        DeleteVehicle(vehicle)
    end
end)
