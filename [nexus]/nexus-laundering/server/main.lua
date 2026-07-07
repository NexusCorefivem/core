local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:laundering:wash", function(amount)
    local source = source
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 or amount > 500000 then
        return
    end

    if not NexusSecurity.IsNearZone(source, NexusConfig.Laundering.spot) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "laundering:wash", 10) then
        return
    end

    if not exports["nexus-economy"]:RemoveMoney(source, "dirty", amount) then
        notify(source, "shops.no_money")
        return
    end

    local fee = NexusConfig.Laundering.spot.fee or 0.15
    local cleaned = math.floor(amount * (1.0 - fee))
    exports["nexus-economy"]:AddMoney(source, "bank", cleaned)
    notify(source, "launder.success", cleaned)
end)
