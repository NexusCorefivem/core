if IsDuplicityVersion() then
    return
end

local callbackIndex = 0
local pendingCallbacks = {}

local function nextCallbackId()
    callbackIndex = callbackIndex + 1
    return ("cb_%s_%s"):format(GetCurrentResourceName(), callbackIndex)
end

function TriggerNexusCallback(name, payload, cb)
    local requestId = nextCallbackId()
    pendingCallbacks[requestId] = cb
    TriggerServerEvent(NexusEvents.callbackRequest, requestId, name, payload or {})
end

RegisterNetEvent(NexusEvents.callbackResponse, function(requestId, result, errorCode)
    local cb = pendingCallbacks[requestId]
    if not cb then
        return
    end

    pendingCallbacks[requestId] = nil
    cb(result, errorCode)
end)
