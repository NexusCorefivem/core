CreateThread(function()
    Wait(1000)
    local shop = NexusConfig.JobLocations.mechanic.shop
    exports["nexus-target"]:RegisterZone("job:mechanic", {
        coords = shop.coords,
        radius = shop.radius or 4.0,
        label = shop.label or "Mechanic Shop"
    })
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if zoneId ~= "job:mechanic" then
        return
    end

    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 6.0, 0, 70)
    end

    if vehicle == 0 then
        return
    end

    TriggerServerEvent("nexus:mechanic:repair")
end)

RegisterNetEvent("nexus:mechanic:client:repair", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 6.0, 0, 70)
    end

    if vehicle ~= 0 then
        SetVehicleFixed(vehicle)
        SetVehicleEngineHealth(vehicle, 1000.0)
        SetVehicleBodyHealth(vehicle, 1000.0)
    end
end)
