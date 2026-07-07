exports("Write", function(category, message, source)
    category = NexusShared.SanitizeShortString(category, "general", 50)
    message = NexusShared.SanitizeShortString(message, "", 500)
    if message == "" then
        return false
    end

    local citizenid = nil
    if source and GetNexusPlayer(source) then
        citizenid = GetNexusPlayer(source).citizenId
    end

    NexusDatabase.Insert("INSERT INTO nexus_logs (category, message, citizenid) VALUES (?, ?, ?)", {
        category, message, citizenid
    })

    if NexusConfig.Framework.debug then
        print(("[nexus-logs] [%s] %s"):format(category, message))
    end

    return true
end)

RegisterNetEvent(NexusEvents.characterSelected, function()
    local source = source
    CreateThread(function()
        Wait(1000)
        local player = GetNexusPlayer(source)
        if player then
            exports["nexus-logs"]:Write("character", ("Selected character %s"):format(player.citizenId), source)
        end
    end)
end)
