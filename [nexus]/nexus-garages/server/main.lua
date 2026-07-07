local validStates = {
    stored = true,
    out = true,
    impound = true
}

RegisterNexusCallback("nexus:garages:list", function(source)
    local vehicles = exports["nexus-vehicles"]:GetOwnedVehicles(source)
    return {
        garages = NexusConfig.Garages,
        vehicles = vehicles
    }
end)

RegisterNexusCallback("nexus:garages:getVehicle", function(source, payload)
    if type(payload) ~= "table" or type(payload.plate) ~= "string" then
        return nil
    end

    local vehicle = exports["nexus-vehicles"]:GetOwnedVehicleByPlate(source, payload.plate)
    if not vehicle then
        return nil
    end

    return vehicle
end)

RegisterNetEvent("nexus:garages:updateState", function(plate, state, garage)
    local source = source
    local player = GetNexusPlayer(source)
    if not player then
        return
    end

    if type(plate) ~= "string" or #plate > 20 then
        return
    end

    if not validStates[state] then
        return
    end

    if garage and not NexusConfig.Garages[garage] then
        return
    end

    local ownedVehicle = NexusDatabase.FetchSingle("SELECT id FROM nexus_vehicles WHERE plate = ? AND character_id = ?", {
        plate, player.characterId
    })

    if not ownedVehicle then
        return
    end

    NexusDatabase.Execute("UPDATE nexus_vehicles SET state = ?, garage = ? WHERE plate = ? AND character_id = ?", {
        state, garage or "pillbox", plate, player.characterId
    })
end)
