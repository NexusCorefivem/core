local cooldowns = {}

local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:drugs:harvest", function(fieldId)
    local source = source
    local field = NexusConfig.Drugs[fieldId]
    if not field or not NexusSecurity.IsNearZone(source, field) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "drugs:" .. fieldId, 5) then
        return
    end

    local key = ("%s:%s"):format(source, fieldId)
    if cooldowns[key] and cooldowns[key] > os.time() then
        return
    end

    local amount = math.random(field.amount.min, field.amount.max)
    if exports["nexus-inventory"]:AddItem(source, field.item, amount) then
        cooldowns[key] = os.time() + math.floor((field.cooldown or 60000) / 1000)
        notify(source, "drugs.harvested", amount, field.item)
    end
end)
