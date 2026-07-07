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
