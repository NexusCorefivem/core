CreateThread(function()
    Wait(1000)
    for customsId, customs in pairs(NexusConfig.Customs) do
        exports["nexus-target"]:RegisterZone("customs:" .. customsId, {
            coords = customs.coords,
            radius = customs.radius or 8.0,
            label = customs.label or "Customs"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^customs:") then
        return
    end

    local customsId = zoneId:gsub("^customs:", "")
    local customs = NexusConfig.Customs[customsId]
    if not customs then
        return
    end

    exports["nexus-menu"]:OpenSimpleMenu(customs.label or "Customs", {
        {
            label = ("Repair - $%s"):format(customs.repairPrice),
            onSelect = function()
                TriggerServerEvent("nexus:customs:service", customsId, "repair")
            end
        },
        {
            label = ("Tune - $%s"):format(customs.tunePrice),
            onSelect = function()
                TriggerServerEvent("nexus:customs:service", customsId, "tune")
            end
        }
    })
end)

RegisterNetEvent("nexus:customs:client:apply", function(serviceType)
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 6.0, 0, 70)
    end

    if vehicle == 0 then
        return
    end

    if serviceType == "tune" then
        SetVehicleModKit(vehicle, 0)
        SetVehicleMod(vehicle, 11, GetNumVehicleMods(vehicle, 11) - 1, false)
        SetVehicleMod(vehicle, 12, GetNumVehicleMods(vehicle, 12) - 1, false)
        ToggleVehicleMod(vehicle, 18, true)
    end

    SetVehicleFixed(vehicle)
    SetVehicleEngineHealth(vehicle, 1000.0)
    SetVehicleBodyHealth(vehicle, 1000.0)
    SetVehicleDirtLevel(vehicle, 0.0)
end)
