local activeFare = false
local fareBlip = nil

local fareDestinations = {
    vector3(213.0, -810.0, 30.7),
    vector3(-1037.0, -2737.0, 20.1),
    vector3(1208.0, -1402.0, 35.2),
    vector3(-2962.0, 483.0, 15.7)
}

local function clearFare()
    activeFare = false
    if fareBlip then
        RemoveBlip(fareBlip)
        fareBlip = nil
    end
    SetWaypointOff()
end

local function startFare()
    if activeFare then
        return
    end

    activeFare = true
    local destination = fareDestinations[math.random(1, #fareDestinations)]
    SetNewWaypoint(destination.x, destination.y)
    fareBlip = AddBlipForCoord(destination.x, destination.y, destination.z)
    SetBlipRoute(fareBlip, true)

    CreateThread(function()
        while activeFare do
            Wait(1000)
            local coords = GetEntityCoords(PlayerPedId())
            if #(coords - destination) <= 15.0 then
                clearFare()
                TriggerServerEvent("nexus:taxi:completeFare")
                break
            end
        end
    end)
end

CreateThread(function()
    Wait(1000)
    local depot = NexusConfig.JobLocations.taxi.depot
    exports["nexus-target"]:RegisterZone("job:taxi", {
        coords = depot.coords,
        radius = depot.radius or 3.0,
        label = depot.label or "Taxi Depot"
    })
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if zoneId ~= "job:taxi" then
        return
    end
    startFare()
end)
