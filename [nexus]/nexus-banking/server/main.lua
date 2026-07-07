local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

local function requireAtm(source)
    return NexusSecurity.IsNearAnyAtm(source)
end

RegisterNexusCallback("nexus:banking:getBalances", function(source)
    if not requireAtm(source) then
        return nil
    end

    return {
        bank = exports["nexus-economy"]:GetMoney(source, "bank"),
        cash = exports["nexus-economy"]:GetMoney(source, "cash")
    }
end)

RegisterNetEvent("nexus:banking:withdraw", function(amount)
    local source = source
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 or amount > 100000 or not requireAtm(source) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "banking:withdraw", 2) then
        return
    end

    if not exports["nexus-economy"]:RemoveMoney(source, "bank", amount) then
        notify(source, "economy.insufficient_bank")
        return
    end

    exports["nexus-economy"]:AddMoney(source, "cash", amount)
    notify(source, "banking.withdraw", amount)
end)

RegisterNetEvent("nexus:banking:deposit", function(amount)
    local source = source
    amount = math.floor(tonumber(amount) or 0)
    if amount <= 0 or amount > 100000 or not requireAtm(source) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "banking:deposit", 2) then
        return
    end

    if not exports["nexus-economy"]:RemoveMoney(source, "cash", amount) then
        notify(source, "shops.no_money")
        return
    end

    exports["nexus-economy"]:AddMoney(source, "bank", amount)
    notify(source, "banking.deposit", amount)
end)
