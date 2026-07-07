function NexusShared.GetJobConfig(jobName)
    return NexusConfig.Jobs[jobName]
end

function NexusShared.BuildJobObject(playerJob, locale)
    local jobName = playerJob.name or "unemployed"
    local gradeLevel = playerJob.grade or 0
    local jobConfig = NexusShared.GetJobConfig(jobName) or NexusShared.GetJobConfig("unemployed")
    local gradeConfig = jobConfig.grades[gradeLevel] or jobConfig.grades[0] or {}

    return {
        name = jobName,
        label = NexusTranslate(locale, jobConfig.labelKey),
        type = jobConfig.type or "none",
        onduty = playerJob.onduty == true,
        isboss = gradeConfig.isboss == true,
        payment = gradeConfig.paycheck or 0,
        grade = {
            level = gradeLevel,
            name = NexusTranslate(locale, gradeConfig.labelKey or "jobs.unemployed.grade_0"),
            payment = gradeConfig.paycheck or 0,
            isboss = gradeConfig.isboss == true
        }
    }
end

function NexusShared.BuildGangObject(gangName, gangGrade, locale)
    gangName = gangName or "none"
    gangGrade = gangGrade or 0
    local gangConfig = NexusShared.GetGangConfig(gangName)
    local gradeConfig = gangConfig.grades[gangGrade] or gangConfig.grades[0] or {}

    return {
        name = gangName,
        label = NexusTranslate(locale, gangConfig.labelKey),
        grade = {
            level = gangGrade,
            name = NexusTranslate(locale, gradeConfig.labelKey or "gangs.none.grade_0"),
            isboss = gradeConfig.isboss == true
        }
    }
end

function NexusShared.BuildPlayerData(player)
    if not player then
        return nil
    end

    local locale = player.locale or NexusConfig.Framework.defaultLocale
    local spawn = {}
    local ok, decoded = pcall(json.decode, player.lastLocation or player.spawn or "{}")
    if ok and type(decoded) == "table" then
        spawn = decoded
    end

    return {
        source = player.source,
        citizenid = player.citizenId,
        cid = player.characterId,
        license = player.license,
        name = player:GetName(),
        charinfo = {
            firstname = player.firstname,
            lastname = player.lastname,
            birthdate = player.dateofbirth or "1990-01-01",
            gender = player.gender or "m",
            phone = player.phone or "",
            nationality = player.nationality or "NL",
            account = player.accountId
        },
        job = NexusShared.BuildJobObject(player.job, locale),
        gang = NexusShared.BuildGangObject(player.gang and player.gang.name, player.gang and player.gang.grade, locale),
        money = {
            cash = player.money.cash or 0,
            bank = player.money.bank or 0,
            dirty = player.money.dirty or 0
        },
        metadata = player:GetMetadata(),
        position = vector4(
            spawn.x or NexusConfig.Framework.defaultSpawn.x,
            spawn.y or NexusConfig.Framework.defaultSpawn.y,
            spawn.z or NexusConfig.Framework.defaultSpawn.z,
            spawn.w or NexusConfig.Framework.defaultSpawn.w
        ),
        locale = locale,
        permissions = player.permissions or "player",
        isdead = player.isdead == true,
        injail = player.injail or 0,
        appearance = player:GetAppearance and player:GetAppearance() or nil
    }
end
