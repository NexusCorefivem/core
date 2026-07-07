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
    player:Save()
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

    local removed = player:RemoveMoney(account, amount)
    if removed then
        player:Save()
    end
    return removed
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

RegisterNexusCallback("nexus:economy:transferBank", function(source, payload)
    if type(payload) ~= "table" then
        return false
    end

    local targetSource = tonumber(payload.target)
    local amount = math.floor(tonumber(payload.amount) or 0)

    if not targetSource or targetSource == source or amount <= 0 or amount > 100000 then
        return false
    end

    if not NexusSecurity.CheckRateLimit(source, "economy:transfer", 5) then
        return false
    end

    if not NexusSecurity.IsNearPlayer(source, targetSource, 5.0) then
        return false
    end

    local sender = getPlayerOrError(source)
    local receiver = getPlayerOrError(targetSource)

    if not sender or not receiver then
        return false
    end

    if not sender:RemoveMoney("bank", amount) then
        notifyLocalized(source, "economy.insufficient_bank")
        return false
    end

    receiver:AddMoney("bank", amount)
    sender:Save()
    receiver:Save()
    notifyLocalized(source, "economy.transfer_complete", amount)
    notifyLocalized(targetSource, "economy.transfer_received", amount)
    return true
end)
