RegisterNexusCallback("nexus:identity:get", function(source)
    local player = GetNexusPlayer(source)
    if not player then
        return nil
    end

    return {
        citizenid = player.citizenId,
        firstname = player.firstname,
        lastname = player.lastname,
        name = player:GetName()
    }
end)

exports("GetIdentity", function(source)
    local player = GetNexusPlayer(source)
    if not player then
        return nil
    end

    return {
        citizenid = player.citizenId,
        firstname = player.firstname,
        lastname = player.lastname,
        name = player:GetName()
    }
end)
