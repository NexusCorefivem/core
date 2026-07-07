RegisterNexusCallback("nexus:clothing:saveAppearance", function(source, payload)
    if type(payload) ~= "table" then
        return false
    end

    return NexusCallbacks.handlers["nexus:characters:updateAppearance"](source, payload)
end)

RegisterNexusCallback("nexus:clothing:getAppearance", function(source)
    return NexusCallbacks.handlers["nexus:characters:getAppearance"](source, {})
end)
