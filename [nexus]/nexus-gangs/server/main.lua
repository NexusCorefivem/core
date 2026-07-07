local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

exports("SetPlayerGang", function(source, gangName, gangGrade)
    local player = GetNexusPlayer(source)
    gangGrade = tonumber(gangGrade) or 0

    if not player or not NexusGangs[gangName] or not NexusGangs[gangName].grades[gangGrade] then
        return false
    end

    player:SetGang(gangName, gangGrade)
    player:Save()
    return true
end)

RegisterNexusCallback("nexus:gangs:get", function(source)
    local player = GetNexusPlayer(source)
    if not player then
        return nil
    end

    return player.gang
end)
