NexusSecurity = {
    rateLimits = {}
}

local function getCoordsVector(coords)
    if not coords then
        return nil
    end

    if type(coords) == "vector3" or type(coords) == "vector4" then
        return vector3(coords.x, coords.y, coords.z)
    end

    if type(coords) == "table" and coords.x and coords.y and coords.z then
        return vector3(coords.x, coords.y, coords.z)
    end

    return nil
end

function NexusSecurity.GetPlayerCoords(source)
    local ped = GetPlayerPed(source)
    if not ped or ped == 0 then
        return nil
    end

    return GetEntityCoords(ped)
end

function NexusSecurity.IsNearCoords(source, coords, radius)
    local playerCoords = NexusSecurity.GetPlayerCoords(source)
    local target = getCoordsVector(coords)

    if not playerCoords or not target then
        return false
    end

    return #(playerCoords - target) <= (radius or 3.0)
end

function NexusSecurity.IsNearZone(source, zone)
    if type(zone) ~= "table" then
        return false
    end

    return NexusSecurity.IsNearCoords(source, zone.coords, zone.radius or 3.0)
end

function NexusSecurity.GetDistanceBetweenPlayers(source, targetSource)
    local coordsA = NexusSecurity.GetPlayerCoords(source)
    local coordsB = NexusSecurity.GetPlayerCoords(targetSource)

    if not coordsA or not coordsB then
        return 9999.0
    end

    return #(coordsA - coordsB)
end

function NexusSecurity.IsNearPlayer(source, targetSource, maxDistance)
    return NexusSecurity.GetDistanceBetweenPlayers(source, targetSource) <= (maxDistance or 3.0)
end

function NexusSecurity.CheckRateLimit(source, key, cooldownSeconds)
    if not source or source <= 0 or type(key) ~= "string" then
        return false
    end

    cooldownSeconds = tonumber(cooldownSeconds) or 1
    local now = os.time()
    NexusSecurity.rateLimits[source] = NexusSecurity.rateLimits[source] or {}
    local last = NexusSecurity.rateLimits[source][key] or 0

    if now - last < cooldownSeconds then
        return false
    end

    NexusSecurity.rateLimits[source][key] = now
    return true
end

function NexusSecurity.CheckCallbackRateLimit(source)
    return NexusSecurity._countCallbacks(source)
end

NexusSecurity._callbackCounts = {}

function NexusSecurity._countCallbacks(source)
    local now = os.time()
    local bucket = NexusSecurity._callbackCounts[source]

    if not bucket or bucket.resetAt <= now then
        NexusSecurity._callbackCounts[source] = { count = 1, resetAt = now + 10 }
        return true
    end

    bucket.count = bucket.count + 1
    return bucket.count <= 30
end

function NexusSecurity.ClearSource(source)
    NexusSecurity.rateLimits[source] = nil
    NexusSecurity._callbackCounts[source] = nil
end

function NexusSecurity.IsOnDuty(source, jobName)
    local player = GetNexusPlayer(source)
    if not player then
        return false
    end

    if jobName and player.job.name ~= jobName then
        return false
    end

    return player.job.onduty == true
end

function NexusSecurity.IsPoliceOnDuty(source)
    return NexusSecurity.IsOnDuty(source, "police")
end

function NexusSecurity.IsMedicOnDuty(source)
    return NexusSecurity.IsOnDuty(source, "ambulance")
end

function NexusSecurity.IsStaff(source)
    local group = NexusPermissions.GetGroup(source)
    return NexusConfig.Permissions[group] >= NexusConfig.Permissions.staff
end

function NexusSecurity.IsBossOfJob(source, jobName)
    local player = GetNexusPlayer(source)
    if not player or player.job.name ~= jobName then
        return false
    end

    local job = NexusConfig.Jobs[jobName]
    local grade = job and job.grades[player.job.grade]
    return grade and grade.isboss == true
end

function NexusSecurity.GetBanForSource(source)
    local license, discord

    for _, identifier in ipairs(GetPlayerIdentifiers(source)) do
        if identifier:find("license:", 1, true) == 1 then
            license = identifier
        elseif identifier:find("discord:", 1, true) == 1 then
            discord = identifier
        end
    end

    if not license then
        return { banned = true, reason = "Missing license identifier." }
    end

    local ban = NexusDatabase.FetchSingle([[
        SELECT * FROM nexus_bans
        WHERE active = 1
        AND (expire_at IS NULL OR expire_at > NOW())
        AND (license = ? OR (discord IS NOT NULL AND discord = ?))
        ORDER BY id DESC
        LIMIT 1
    ]], { license, discord })

    if ban then
        return { banned = true, reason = ban.reason or "You are banned from this server." }
    end

    return { banned = false }
end

AddEventHandler("playerDropped", function()
    NexusSecurity.ClearSource(source)
end)

exports("SecurityIsNearCoords", function(source, coords, radius)
    return NexusSecurity.IsNearCoords(source, coords, radius)
end)

exports("SecurityIsNearZone", function(source, zone)
    return NexusSecurity.IsNearZone(source, zone)
end)

exports("SecurityIsNearPlayer", function(source, targetSource, maxDistance)
    return NexusSecurity.IsNearPlayer(source, targetSource, maxDistance)
end)

exports("SecurityCheckRateLimit", function(source, key, cooldownSeconds)
    return NexusSecurity.CheckRateLimit(source, key, cooldownSeconds)
end)

exports("SecurityIsOnDuty", function(source, jobName)
    return NexusSecurity.IsOnDuty(source, jobName)
end)

exports("SecurityIsStaff", function(source)
    return NexusSecurity.IsStaff(source)
end)

function NexusSecurity.IsNearAnyAtm(source)
    for _, coords in ipairs(NexusConfig.Banking.atms or {}) do
        if NexusSecurity.IsNearCoords(source, coords, NexusConfig.Banking.atmRadius or 1.5) then
            return true
        end
    end
    return false
end

exports("SecurityIsNearAnyAtm", function(source)
    return NexusSecurity.IsNearAnyAtm(source)
end)
