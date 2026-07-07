local deliveryActive = false

local function startDelivery()
    if deliveryActive then
        return
    end

    deliveryActive = true
    local delivery = NexusConfig.JobLocations.trucker.delivery.coords
    SetNewWaypoint(delivery.x, delivery.y)

    CreateThread(function()
        while deliveryActive do
            Wait(1000)
            if #(GetEntityCoords(PlayerPedId()) - delivery) <= 15.0 then
                deliveryActive = false
                SetWaypointOff()
                TriggerServerEvent("nexus:trucker:completeDelivery")
                break
            end
        end
    end)
end

CreateThread(function()
    Wait(1000)
    local depot = NexusConfig.JobLocations.trucker.depot
    exports["nexus-target"]:RegisterZone("job:trucker", {
        coords = depot.coords,
        radius = depot.radius or 4.0,
        label = depot.label or "Trucker Depot"
    })
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if zoneId ~= "job:trucker" then
        return
    end
    startDelivery()
end)
