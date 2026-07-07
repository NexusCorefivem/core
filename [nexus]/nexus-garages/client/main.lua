local garageUiOpen = false
local activeVehiclePlates = {}

local function setGarageUi(visible, payload)
    garageUiOpen = visible
    SetNuiFocus(visible, visible)
    SendNUIMessage({
        action = visible and "open" or "close",
        payload = payload or {}
    })
end

local function openGarageUi()
    TriggerNexusCallback("nexus:garages:list", {}, function(result)
        setGarageUi(true, result or { garages = {}, vehicles = {} })
    end)
end

local function spawnOwnedVehicle(vehicle)
    if activeVehiclePlates[vehicle.plate] then
        return false
    end

    local garage = NexusConfig.Garages[vehicle.garage or "pillbox"]
    if not garage then
        return false
    end

    local model = joaat(vehicle.model)
    if not IsModelInCdimage(model) or not IsModelValid(model) then
        return false
    end

    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    local coords = garage.spawn or garage.coords
    local spawned = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w, true, false)
    activeVehiclePlates[vehicle.plate] = true
    SetVehicleNumberPlateText(spawned, vehicle.plate)
    SetVehicleFuelLevel(spawned, tonumber(vehicle.fuel) or 100.0)
    SetVehicleEngineHealth(spawned, tonumber(vehicle.engine) or 1000.0)
    SetVehicleBodyHealth(spawned, tonumber(vehicle.body) or 1000.0)
    SetPedIntoVehicle(PlayerPedId(), spawned, -1)
    SetModelAsNoLongerNeeded(model)

    TriggerNexusCallback("nexus:vehicles:updateState", {
        plate = vehicle.plate,
        state = "out",
        garage = vehicle.garage or "pillbox",
        fuel = vehicle.fuel,
        engine = vehicle.engine,
        body = vehicle.body,
        mods = {}
    }, function() end)

    TriggerEvent(NexusEvents.notify, NexusTranslate(NexusConfig.Framework.defaultLocale, "garage.vehicle_spawned"))
    return true
end

local function storeCurrentVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle == 0 then
        return false
    end

    local plate = NexusShared.Trim(GetVehicleNumberPlateText(vehicle) or "")
    local coords = GetEntityCoords(vehicle)
    local nearestGarage = "pillbox"
    local nearestDistance = 999999.0

    for garageKey, garageData in pairs(NexusConfig.Garages) do
        local distance = #(coords - vector3(garageData.coords.x, garageData.coords.y, garageData.coords.z))
        if distance < nearestDistance then
            nearestDistance = distance
            nearestGarage = garageKey
        end
    end

    TriggerNexusCallback("nexus:vehicles:updateState", {
        plate = plate,
        state = "stored",
        garage = nearestGarage,
        fuel = GetVehicleFuelLevel(vehicle),
        engine = GetVehicleEngineHealth(vehicle),
        body = GetVehicleBodyHealth(vehicle),
        mods = {}
    }, function(result)
        if result then
            activeVehiclePlates[plate] = nil
            DeleteVehicle(vehicle)
            TriggerEvent(NexusEvents.notify, NexusTranslate(NexusConfig.Framework.defaultLocale, "garage.vehicle_stored"))
        else
            TriggerEvent(NexusEvents.notify, NexusTranslate(NexusConfig.Framework.defaultLocale, "garage.vehicle_not_owned"))
        end
    end)

    return true
end

RegisterNUICallback("garage:close", function(_, cb)
    setGarageUi(false)
    cb({ ok = true })
end)

RegisterNUICallback("garage:spawn", function(data, cb)
    TriggerNexusCallback("nexus:garages:getVehicle", { plate = data.plate }, function(vehicle)
        if vehicle and vehicle.state ~= "out" then
            setGarageUi(false)
            cb({ ok = spawnOwnedVehicle(vehicle) == true })
            return
        end

        cb({ ok = false })
    end)
end)

RegisterNUICallback("garage:refresh", function(_, cb)
    TriggerNexusCallback("nexus:garages:list", {}, function(result)
        cb(result or { garages = {}, vehicles = {} })
    end)
end)

RegisterCommand("garage", function()
    openGarageUi()
end, false)

RegisterCommand("storecar", function()
    storeCurrentVehicle()
end, false)
