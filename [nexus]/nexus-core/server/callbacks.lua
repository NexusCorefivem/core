NexusCallbacks = {
    handlers = {}
}

function RegisterNexusCallback(name, handler)
    if type(name) ~= "string" or name == "" then
        error("RegisterNexusCallback expected a non-empty callback name")
    end

    if type(handler) ~= "function" then
        error(("RegisterNexusCallback expected function handler for %s"):format(name))
    end

    NexusCallbacks.handlers[name] = handler
end

RegisterNetEvent(NexusEvents.callbackRequest, function(requestId, callbackName, payload)
    local source = source
    if type(requestId) ~= "string" or requestId == "" then
        return
    end

    if type(callbackName) ~= "string" or callbackName == "" then
        TriggerClientEvent(NexusEvents.callbackResponse, source, requestId, nil, "invalid_callback_name")
        return
    end

    if payload ~= nil and type(payload) ~= "table" then
        TriggerClientEvent(NexusEvents.callbackResponse, source, requestId, nil, "invalid_payload")
        return
    end

    local handler = NexusCallbacks.handlers[callbackName]

    if not handler then
        TriggerClientEvent(NexusEvents.callbackResponse, source, requestId, nil, "missing_callback")
        return
    end

    local ok, result = pcall(handler, source, payload)

    if not ok then
        print(("[nexus-core] callback error for %s: %s"):format(callbackName, result))
        TriggerClientEvent(NexusEvents.callbackResponse, source, requestId, nil, "callback_failed")
        return
    end

    TriggerClientEvent(NexusEvents.callbackResponse, source, requestId, result, nil)
end)
