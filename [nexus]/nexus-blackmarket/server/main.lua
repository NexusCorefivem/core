local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:blackmarket:buy", function(marketId, itemName)
    local source = source
    local market = NexusConfig.Blackmarket[marketId]
    if not market or not NexusSecurity.IsNearZone(source, market) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "blackmarket:buy", 3) then
        return
    end

    local itemConfig
    for _, entry in ipairs(market.items or {}) do
        if entry.name == itemName then
            itemConfig = entry
            break
        end
    end

    if not itemConfig then
        return
    end

    local account = itemConfig.account or "dirty"
    if not exports["nexus-economy"]:RemoveMoney(source, account, itemConfig.price) then
        notify(source, "shops.no_money")
        return
    end

    if not exports["nexus-inventory"]:AddItem(source, itemName, 1) then
        exports["nexus-economy"]:AddMoney(source, account, itemConfig.price)
        return
    end

    notify(source, "shops.bought", 1, itemName, itemConfig.price)
end)
