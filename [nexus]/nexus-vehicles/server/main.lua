local validStates = {
    stored = true,
    out = true,
    impounded = true,
    impound = true
}

local function generatePlate()
    return ("NX%s"):format(math.random(10000, 99999))
end

local function isValidVehicleModel(model)
    return type(model) == "string" and #model > 0 and #model <= 60 and model:match("^[%w_]+$") ~= nil
end

local function clampVehicleStats(fuel, engine, body)
    return
        NexusShared.Clamp(tonumber(fuel) or 100, 0, 100),
        NexusShared.Clamp(tonumber(engine) or 1000, 0, 1000),
        NexusShared.Clamp(tonumber(body) or 1000, 0, 1000)
end

exports("CreateVehicleRecord", function(source, model, garage)
    local player = GetNexusPlayer(source)
    if not player or not isValidVehicleModel(model) then
        return nil
    end

    local plate
    local attempts = 0

    repeat
        attempts = attempts + 1
        plate = generatePlate()
    until not NexusDatabase.FetchSingle("SELECT id FROM nexus_vehicles WHERE plate = ?", { plate }) or attempts >= 10

    if not plate or attempts >= 10 then
        return nil
    end

    local vehicleId = NexusDatabase.Insert([[
        INSERT INTO nexus_vehicles (character_id, plate, model, garage, state, fuel, engine, body, mods, keys_json)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    ]], {
        player.characterId,
        plate,
        model,
        garage or "pillbox",
        "stored",
        100,
        1000,
        1000,
        "{}",
        json.encode({ [player.citizenId] = true })
    })

    return { id = vehicleId, plate = plate }
end)

exports("GetOwnedVehicles", function(source)
    local player = GetNexusPlayer(source)
    if not player then
        return {}
    end

    return NexusDatabase.FetchAll("SELECT * FROM nexus_vehicles WHERE character_id = ?", { player.characterId })
end)

exports("GetOwnedVehicleByPlate", function(source, plate)
    local player = GetNexusPlayer(source)
    if not player or type(plate) ~= "string" then
        return nil
    end

    return NexusDatabase.FetchSingle("SELECT * FROM nexus_vehicles WHERE character_id = ? AND plate = ?", {
        player.characterId, plate
    })
end)

RegisterNexusCallback("nexus:vehicles:updateState", function(source, payload)
    local player = GetNexusPlayer(source)
    if not player or type(payload) ~= "table" then
        return false
    end

    if not NexusSecurity.CheckRateLimit(source, "vehicles:update", 2) then
        return false
    end

    local plate = payload.plate
    if type(plate) ~= "string" or #plate > 20 then
        return false
    end

    local state = payload.state or "stored"
    if not validStates[state] then
        return false
    end

    local garage = payload.garage or "pillbox"
    if not NexusConfig.Garages[garage] then
        garage = "pillbox"
    end

    local fuel, engine, body = clampVehicleStats(payload.fuel, payload.engine, payload.body)
    local mods = type(payload.mods) == "table" and json.encode(payload.mods) or "{}"

    local updated = NexusDatabase.Execute([[
        UPDATE nexus_vehicles
        SET state = ?, garage = ?, fuel = ?, engine = ?, body = ?, mods = ?
        WHERE plate = ? AND character_id = ?
    ]], {
        state,
        garage,
        fuel,
        engine,
        body,
        mods,
        plate,
        player.characterId
    })

    return updated and updated > 0
end)

RegisterNexusCallback("nexus:vehicles:list", function(source)
    return exports["nexus-vehicles"]:GetOwnedVehicles(source)
end)
