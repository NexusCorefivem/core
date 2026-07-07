local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNexusCallback("nexus:shops:list", function(source, payload)
    if type(payload) ~= "table" or type(payload.shopId) ~= "string" then
        return nil
    end

    return NexusConfig.Shops[payload.shopId]
end)

RegisterNetEvent("nexus:shops:buy", function(shopId, itemName, count)
    local source = source
    count = math.floor(tonumber(count) or 1)
    if count <= 0 or count > 100 then
        return
    end

    local shop = NexusConfig.Shops[shopId]
    if not shop or not NexusSecurity.IsNearZone(source, shop) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "shops:buy", 2) then
        return
    end

    local itemConfig
    for _, entry in ipairs(shop.items or {}) do
        if entry.name == itemName then
            itemConfig = entry
            break
        end
    end

    if not itemConfig then
        return
    end

    local total = itemConfig.price * count
    if not exports["nexus-economy"]:RemoveMoney(source, "cash", total) then
        notify(source, "shops.no_money")
        return
    end

    if not exports["nexus-inventory"]:AddItem(source, itemName, count) then
        exports["nexus-economy"]:AddMoney(source, "cash", total)
        return
    end

    notify(source, "shops.bought", count, itemName, total)
end)
