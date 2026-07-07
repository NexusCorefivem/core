RegisterNexusCallback("nexus:clothing:saveAppearance", function(source, payload)
    if type(payload) ~= "table" then
        return false
    end

    local player = GetNexusPlayer(source)
    if not player then
        return false
    end

    player.appearance = json.encode(payload)
    player:Save()
    return true
end)

RegisterNexusCallback("nexus:clothing:getAppearance", function(source)
    local player = GetNexusPlayer(source)
    if not player then
        return nil
    end

    local ok, decoded = pcall(json.decode, player.appearance or "")
    if ok and decoded ~= nil then
        return decoded
    end

    return {}
end)
