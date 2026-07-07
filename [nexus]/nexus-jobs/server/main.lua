local function getJobConfig(jobName)
    return NexusConfig.Jobs[jobName]
end

local function notifyLocalized(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

exports("SetJob", function(source, jobName, grade, onduty)
    local player = GetNexusPlayer(source)
    if not player then
        return false
    end

    local job = getJobConfig(jobName)
    if not job then
        return false
    end

    grade = tonumber(grade) or 0
    if not job.grades[grade] then
        return false
    end

    player:SetJob(jobName, grade, onduty)
    return true
end)

RegisterNetEvent("nexus:jobs:setDuty", function(onduty)
    local source = source
    local player = GetNexusPlayer(source)
    if not player then
        return
    end

    player.job.onduty = onduty == true
    notifyLocalized(source, onduty and "jobs.duty_on" or "jobs.duty_off")
end)

RegisterNexusCallback("nexus:jobs:get", function(source)
    local player = GetNexusPlayer(source)
    return player and player.job or nil
end)

CreateThread(function()
    while true do
        Wait(30 * 60000)

        for source, player in pairs(NexusPlayers) do
            local job = getJobConfig(player.job.name)
            local grade = job and job.grades[player.job.grade]

            if player.job.onduty and grade and grade.paycheck then
                player:AddMoney("bank", grade.paycheck)
                notifyLocalized(source, "jobs.paycheck_received", grade.paycheck)
            end
        end
    end
end)
