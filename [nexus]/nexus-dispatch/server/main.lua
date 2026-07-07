local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

local function notifyEmergencyServices(message, coords)
    for source, player in pairs(GetNexusPlayers()) do
        if player.job.name == "police" or player.job.name == "ambulance" then
            TriggerClientEvent("nexus:dispatch:client:alert", source, message, coords)
        end
    end
end

RegisterNetEvent("nexus:dispatch:create", function(callType, message)
    local source = source
    if not NexusSecurity.CheckRateLimit(source, "dispatch:create", 15) then
        return
    end

    callType = NexusShared.SanitizeShortString(callType, "general", 50)
    message = NexusShared.SanitizeShortString(message, "", 200)
    if message == "" then
        return
    end

    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local encoded = json.encode({ x = coords.x, y = coords.y, z = coords.z })

    NexusDatabase.Insert("INSERT INTO nexus_dispatch (call_type, message, coords) VALUES (?, ?, ?)", {
        callType, message, encoded
    })

    notifyEmergencyServices(("%s: %s"):format(callType, message), coords)
    notify(source, "dispatch.created")
end)

RegisterNexusCallback("nexus:dispatch:list", function(source)
    local player = GetNexusPlayer(source)
    if not player or (player.job.name ~= "police" and player.job.name ~= "ambulance") then
        return {}
    end

    return NexusDatabase.FetchAll("SELECT * FROM nexus_dispatch WHERE status = 'open' ORDER BY id DESC LIMIT 20", {})
end)

RegisterNetEvent("nexus:dispatch:close", function(callId)
    local source = source
    local player = GetNexusPlayer(source)
    callId = tonumber(callId)
    if not NexusSecurity.IsPoliceOnDuty(source) or not callId then
        return
    end

    NexusDatabase.Execute("UPDATE nexus_dispatch SET status = 'closed' WHERE id = ?", { callId })
    notify(source, "dispatch.closed")
end)
