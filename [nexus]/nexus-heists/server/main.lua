local cooldowns = {}

local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:heists:start", function(heistId)
    local source = source
    local heist = NexusConfig.Heists[heistId]
    if not heist or not NexusSecurity.IsNearZone(source, heist) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "heist:" .. heistId, 10) then
        return
    end

    if cooldowns[heistId] and cooldowns[heistId] > os.time() then
        notify(source, "robbery.cooldown")
        return
    end

    if heist.requiredItem and not exports["nexus-inventory"]:RemoveItem(source, heist.requiredItem, 1) then
        notify(source, "crafting.failed")
        return
    end

    local reward = math.random(heist.reward.min, heist.reward.max)
    exports["nexus-economy"]:AddMoney(source, "dirty", reward)
    cooldowns[heistId] = os.time() + math.floor((heist.cooldown or 3600000) / 1000)
    notify(source, "heist.success", reward)
end)
