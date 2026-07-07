RegisterNetEvent("nexus:dispatch:client:alert", function(message, coords)
    TriggerEvent(NexusEvents.notify, message or "Dispatch alert")
    if coords then
        SetNewWaypoint(coords.x, coords.y)
    end
end)

RegisterCommand("911", function(_, args)
    TriggerServerEvent("nexus:dispatch:create", "911", table.concat(args, " "))
end, false)

RegisterCommand("dispatch", function()
    TriggerNexusCallback("nexus:dispatch:list", {}, function(calls)
        for _, call in ipairs(calls or {}) do
            TriggerEvent(NexusEvents.notify, ("#%s %s"):format(call.id, call.message))
        end
    end)
end, false)
