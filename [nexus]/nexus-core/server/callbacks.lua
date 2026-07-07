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

AddEventHandler("nexus:internal:registerCallbackRoute", function(name, resourceName, exportName)
    if type(name) ~= "string" or name == "" then
        return
    end

    if type(resourceName) ~= "string" or resourceName == "" then
        return
    end

    if type(exportName) ~= "string" or exportName == "" then
        return
    end

    RegisterNexusCallback(name, function(source, payload)
        return exports[resourceName][exportName](source, payload)
    end)
end)

RegisterNetEvent(NexusEvents.callbackRequest, function(requestId, callbackName, payload)
    local source = source

    if not NexusSecurity.CheckCallbackRateLimit(source) then
        TriggerClientEvent(NexusEvents.callbackResponse, source, requestId, nil, "rate_limited")
        return
    end

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
        if NexusConfig.Framework.debug then
            print(("[nexus-core] callback error for %s: %s"):format(callbackName, result))
        end
        TriggerClientEvent(NexusEvents.callbackResponse, source, requestId, nil, "callback_failed")
        return
    end

    TriggerClientEvent(NexusEvents.callbackResponse, source, requestId, result, nil)
end)
