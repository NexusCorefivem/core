local routeActive = false
local stopIndex = 1

local function clearRoute()
    routeActive = false
    stopIndex = 1
    SetWaypointOff()
end

local function startRoute()
    if routeActive then
        return
    end

    routeActive = true
    stopIndex = 1
    local stops = NexusConfig.JobLocations.bus.stops

    CreateThread(function()
        while routeActive and stopIndex <= #stops do
            local stop = stops[stopIndex]
            SetNewWaypoint(stop.x, stop.y)

            while routeActive do
                Wait(1000)
                if #(GetEntityCoords(PlayerPedId()) - stop) <= 12.0 then
                    TriggerServerEvent("nexus:bus:completeStop")
                    stopIndex = stopIndex + 1
                    break
                end
            end
        end

        clearRoute()
    end)
end

CreateThread(function()
    Wait(1000)
    local depot = NexusConfig.JobLocations.bus.depot
    exports["nexus-target"]:RegisterZone("job:bus", {
        coords = depot.coords,
        radius = depot.radius or 3.0,
        label = depot.label or "Bus Depot"
    })
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if zoneId ~= "job:bus" then
        return
    end
    startRoute()
end)
