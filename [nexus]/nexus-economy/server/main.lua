local function getPlayerOrError(source)
    local player = GetNexusPlayer(source)
    if not player then
        return nil, "player_not_loaded"
    end

    return player
end

local validAccounts = {
    cash = true,
    bank = true,
    dirty = true
}

local function notifyLocalized(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

exports("AddMoney", function(source, account, amount)
    if not validAccounts[account] then
        return false
    end

    local player = getPlayerOrError(source)
    if not player then
        return false
    end

    player:AddMoney(account, amount)
    return true
end)

exports("RemoveMoney", function(source, account, amount)
    if not validAccounts[account] then
        return false
    end

    local player = getPlayerOrError(source)
    if not player then
        return false
    end

    return player:RemoveMoney(account, amount)
end)

exports("GetMoney", function(source, account)
    if not validAccounts[account] then
        return 0
    end

    local player = getPlayerOrError(source)
    if not player then
        return 0
    end

    return player.money[account] or 0
end)

RegisterNexusCallback("nexus:economy:getBalances", function(source)
    local player = getPlayerOrError(source)
    return player and player.money or nil
end)

RegisterNetEvent("nexus:economy:transferBank", function(targetSource, amount)
    local source = source
    targetSource = tonumber(targetSource)
    amount = tonumber(amount) or 0

    if not targetSource or targetSource == source or amount <= 0 or amount > 1000000 then
        return
    end

    local sender = getPlayerOrError(source)
    local receiver = getPlayerOrError(targetSource)

    if not sender or not receiver then
        return
    end

    if not sender:RemoveMoney("bank", amount) then
        notifyLocalized(source, "economy.insufficient_bank")
        return
    end

    receiver:AddMoney("bank", amount)
    notifyLocalized(source, "economy.transfer_complete", amount)
    notifyLocalized(targetSource, "economy.transfer_received", amount)
end)
