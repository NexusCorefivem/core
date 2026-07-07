local phoneOpen = false

local function setPhoneOpen(visible)
    phoneOpen = visible
    SetNuiFocus(visible, visible)
    SendNUIMessage({ action = visible and "open" or "close" })
end

RegisterCommand("phone", function()
    setPhoneOpen(not phoneOpen)
end, false)

RegisterNUICallback("phone:close", function(_, cb)
    setPhoneOpen(false)
    cb({ ok = true })
end)

RegisterNUICallback("phone:send", function(data, cb)
    TriggerServerEvent("nexus:phone:send", tonumber(data.target), data.message)
    cb({ ok = true })
end)

RegisterNetEvent("nexus:phone:receive", function(payload)
    SendNUIMessage({ action = "message", payload = payload })
    TriggerEvent(NexusEvents.notify, ("%s: %s"):format(payload.from or "Unknown", payload.message or ""))
end)
