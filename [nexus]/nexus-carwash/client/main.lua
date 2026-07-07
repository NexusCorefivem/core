CreateThread(function()
    Wait(1000)
    for washId, wash in pairs(NexusConfig.Carwash) do
        exports["nexus-target"]:RegisterZone("carwash:" .. washId, {
            coords = wash.coords,
            radius = wash.radius or 6.0,
            label = wash.label or "Carwash"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^carwash:") then
        return
    end

    local washId = zoneId:gsub("^carwash:", "")
    TriggerServerEvent("nexus:carwash:wash", washId)
end)

RegisterNetEvent("nexus:carwash:client:clean", function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 6.0, 0, 70)
    end

    if vehicle ~= 0 then
        SetVehicleDirtLevel(vehicle, 0.0)
        WashDecalsFromVehicle(vehicle, 1.0)
    end
end)
