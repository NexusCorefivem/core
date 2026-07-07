local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNexusCallback("nexus:management:canOpen", function(source, payload)
    local player = GetNexusPlayer(source)
    if not player or type(payload) ~= "table" then
        return false
    end

    local jobName = payload.jobName
    local config = NexusConfig.Management[jobName]
    if not config then
        return false
    end

    return player.job.name == jobName and player.job.grade >= (config.minGrade or 1)
end)

RegisterNetEvent("nexus:management:hireNearby", function(jobName)
    local source = source
    if not NexusSecurity.CheckRateLimit(source, "management:hire", 5) then
        return
    end
    local player = GetNexusPlayer(source)
    local config = NexusConfig.Management[jobName]

    if not player or not config or player.job.name ~= jobName or player.job.grade < config.minGrade then
        return
    end

    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local hired = false

    for targetSource, target in pairs(GetNexusPlayers()) do
        if targetSource ~= source and target.job.name == "unemployed" then
            local targetPed = GetPlayerPed(targetSource)
            if #(coords - GetEntityCoords(targetPed)) <= 5.0 then
                exports["nexus-jobs"]:SetJob(targetSource, jobName, 0, false)
                notify(targetSource, "management.hired")
                hired = true
                break
            end
        end
    end

    if hired then
        notify(source, "management.hired")
    end
end)

RegisterNetEvent("nexus:management:fireNearby", function(jobName)
    local source = source
    if not NexusSecurity.CheckRateLimit(source, "management:fire", 5) then
        return
    end
    local player = GetNexusPlayer(source)
    local config = NexusConfig.Management[jobName]

    if not player or not config or player.job.name ~= jobName or player.job.grade < config.minGrade then
        return
    end

    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local fired = false

    for targetSource, target in pairs(GetNexusPlayers()) do
        if targetSource ~= source and target.job.name == jobName and target.job.grade < player.job.grade then
            local targetPed = GetPlayerPed(targetSource)
            if #(coords - GetEntityCoords(targetPed)) <= 5.0 then
                exports["nexus-jobs"]:SetJob(targetSource, "unemployed", 0, false)
                notify(targetSource, "management.fired")
                fired = true
                break
            end
        end
    end

    if fired then
        notify(source, "management.fired")
    end
end)
