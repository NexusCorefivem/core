local cooldowns = {}

local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:robberies:start", function(robberyId)
    local source = source
    local robbery = NexusConfig.Robberies[robberyId]
    if not robbery or not NexusSecurity.IsNearZone(source, robbery) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "robbery:" .. robberyId, 10) then
        return
    end

    local key = robberyId
    if cooldowns[key] and cooldowns[key] > os.time() then
        notify(source, "robbery.cooldown")
        return
    end

    local reward = math.random(robbery.reward.min, robbery.reward.max)
    exports["nexus-economy"]:AddMoney(source, "dirty", reward)
    cooldowns[key] = os.time() + math.floor((robbery.cooldown or 1800000) / 1000)
    notify(source, "robbery.success", reward)
end)
