RegisterNetEvent(NexusEvents.notify, function(message)
    SendNUIMessage({
        action = "notify",
        message = tostring(message or "")
    })
end)
