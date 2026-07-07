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
    local route = NexusConfig.JobLocations.garbage.route

    CreateThread(function()
        while routeActive and stopIndex <= #route do
            local stop = route[stopIndex]
            SetNewWaypoint(stop.x, stop.y)

            while routeActive do
                Wait(1000)
                if #(GetEntityCoords(PlayerPedId()) - stop) <= 10.0 then
                    TriggerServerEvent("nexus:garbage:completeStop")
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
    local depot = NexusConfig.JobLocations.garbage.depot
    exports["nexus-target"]:RegisterZone("job:garbage", {
        coords = depot.coords,
        radius = depot.radius or 4.0,
        label = depot.label or "Garbage Depot"
    })
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if zoneId ~= "job:garbage" then
        return
    end
    startRoute()
end)
