local vehicleFuel = {}

local function getFuel(vehicle)
    if not DoesEntityExist(vehicle) then
        return 0.0
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    if vehicleFuel[plate] == nil then
        vehicleFuel[plate] = NexusConfig.Fuel.maxFuel
    end

    return vehicleFuel[plate]
end

local function setFuel(vehicle, amount)
    local plate = GetVehicleNumberPlateText(vehicle)
    vehicleFuel[plate] = NexusShared.Clamp(amount, 0.0, NexusConfig.Fuel.maxFuel)
    SetVehicleFuelLevel(vehicle, vehicleFuel[plate])
end

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                local speed = GetEntitySpeed(vehicle) * 3.6
                if speed > 5.0 then
                    local fuel = getFuel(vehicle) - (NexusConfig.Fuel.consumptionRate * (speed / 100))
                    setFuel(vehicle, fuel)
                end
            end
        end
    end
end)

local function getStationEntries()
    local entries = {}
    for index, station in ipairs(NexusConfig.Fuel.stations) do
        entries["station_" .. index] = {
            coords = station.coords,
            radius = station.radius,
            label = station.label or "Gas Station"
        }
    end
    return entries
end

NexusShared.CreateProximityLoop(getStationEntries, function()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        vehicle = GetClosestVehicle(GetEntityCoords(ped), 5.0, 0, 70)
    end

    if vehicle == 0 then
        TriggerEvent(NexusEvents.notify, NexusTranslate(NexusConfig.Framework.defaultLocale, "fuel.no_vehicle"))
        return
    end

    setFuel(vehicle, NexusConfig.Fuel.maxFuel)
    TriggerEvent(NexusEvents.notify, NexusTranslate(NexusConfig.Framework.defaultLocale, "fuel.refueled"))
end)
