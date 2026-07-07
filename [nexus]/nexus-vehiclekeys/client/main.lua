local lockedPlates = {}

local function getNearbyVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    if vehicle ~= 0 then
        return vehicle
    end

    local coords = GetEntityCoords(ped)
    return GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 70)
end

local function applyLockState(vehicle, locked)
    if not DoesEntityExist(vehicle) then
        return
    end

    SetVehicleDoorsLocked(vehicle, locked and 2 or 1)
    SetVehicleDoorsLockedForAllPlayers(vehicle, locked)
end

local function toggleLock()
    local vehicle = getNearbyVehicle()
    if vehicle == 0 then
        return
    end

    local plate = GetVehicleNumberPlateText(vehicle)
    TriggerNexusCallback("nexus:vehiclekeys:toggle", { plate = plate }, function(result)
        if not result then
            return
        end

        local locked = not lockedPlates[plate]
        lockedPlates[plate] = locked or nil
        applyLockState(vehicle, locked)

        local locale = NexusConfig.Framework.defaultLocale
        TriggerEvent(NexusEvents.notify, NexusTranslate(locale, locked and "vehiclekeys.locked" or "vehiclekeys.unlocked"))
    end)
end

RegisterCommand("lock", toggleLock, false)
RegisterKeyMapping("lock", "Toggle vehicle lock", "keyboard", "L")

exports("ToggleLock", toggleLock)
