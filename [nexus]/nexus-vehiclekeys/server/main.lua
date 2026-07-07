local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

local function normalizePlate(plate)
    if type(plate) ~= "string" then
        return nil
    end
    return plate:gsub("^%s+", ""):gsub("%s+$", "")
end

local function getVehicleByPlate(plate)
    return NexusDatabase.FetchSingle("SELECT * FROM nexus_vehicles WHERE plate = ?", { plate })
end

local function playerHasKeys(source, plate)
    local player = GetNexusPlayer(source)
    if not player then
        return false
    end

    plate = normalizePlate(plate)
    if not plate then
        return false
    end

    local vehicle = getVehicleByPlate(plate)
    if not vehicle then
        return false
    end

    if vehicle.character_id == player.characterId then
        return true
    end

    local keys = json.decode(vehicle.keys_json or "{}") or {}
    return keys[player.citizenId] == true
end

local function setKeysForCitizen(plate, citizenId, hasKeys)
    local vehicle = getVehicleByPlate(plate)
    if not vehicle then
        return false
    end

    local keys = json.decode(vehicle.keys_json or "{}") or {}
    if hasKeys then
        keys[citizenId] = true
    else
        keys[citizenId] = nil
    end

    NexusDatabase.Execute("UPDATE nexus_vehicles SET keys_json = ? WHERE plate = ?", {
        json.encode(keys),
        plate
    })

    return true
end

RegisterNexusCallback("nexus:vehiclekeys:hasKeys", function(source, payload)
    if type(payload) ~= "table" then
        return false
    end
    return playerHasKeys(source, payload.plate)
end)

RegisterNexusCallback("nexus:vehiclekeys:toggle", function(source, payload)
    if type(payload) ~= "table" then
        return nil
    end

    local plate = normalizePlate(payload.plate)
    if not plate or not playerHasKeys(source, plate) then
        notify(source, "vehiclekeys.no_keys")
        return nil
    end

    return { plate = plate }
end)

exports("HasKeys", playerHasKeys)

exports("GiveKeys", function(source, plate, targetSource)
    local player = GetNexusPlayer(source)
    local target = GetNexusPlayer(targetSource)
    plate = normalizePlate(plate)

    if not player or not target or not plate then
        return false
    end

    if not playerHasKeys(source, plate) then
        return false
    end

    if not NexusSecurity.IsNearPlayer(source, targetSource, 5.0) then
        return false
    end

    return setKeysForCitizen(plate, target.citizenId, true)
end)
