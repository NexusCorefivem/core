local cuffedPlayers = {}

local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

local function isPolice(source)
    return NexusSecurity.IsPoliceOnDuty(source)
end

RegisterNetEvent("nexus:police:cuff", function(targetSource)
    local source = source
    targetSource = tonumber(targetSource)
    if not isPolice(source) or not targetSource or not GetNexusPlayer(targetSource) then
        return
    end

    local maxDistance = NexusConfig.Police.cuffDistance or 2.5
    if not NexusSecurity.IsNearPlayer(source, targetSource, maxDistance) then
        return
    end

    cuffedPlayers[targetSource] = not cuffedPlayers[targetSource]
    TriggerClientEvent("nexus:police:client:cuff", targetSource, cuffedPlayers[targetSource])
    notify(source, cuffedPlayers[targetSource] and "police.cuffed" or "police.uncuffed")
end)

RegisterNetEvent("nexus:police:fine", function(targetSource, amount)
    local source = source
    targetSource = tonumber(targetSource)
    amount = math.floor(tonumber(amount) or 0)
    if not isPolice(source) or not targetSource or amount <= 0 or amount > NexusConfig.Police.fineMax then
        return
    end

    if not NexusSecurity.IsNearPlayer(source, targetSource, NexusConfig.Police.cuffDistance or 2.5) then
        return
    end

    if exports["nexus-economy"]:RemoveMoney(targetSource, "bank", amount) then
        notify(source, "police.fined", amount)
    end
end)

RegisterNetEvent("nexus:police:impound", function(plate)
    local source = source
    if not isPolice(source) or type(plate) ~= "string" then
        return
    end

    plate = plate:gsub("^%s+", ""):gsub("%s+$", "")
    if #plate == 0 or #plate > 20 then
        return
    end

    local vehicle = NexusDatabase.FetchSingle("SELECT * FROM nexus_vehicles WHERE plate = ?", { plate })
    if not vehicle then
        return
    end

    NexusDatabase.Execute("UPDATE nexus_vehicles SET state = ?, garage = ? WHERE plate = ?", {
        "impounded",
        "impound",
        plate
    })

    TriggerClientEvent("nexus:police:client:deleteVehicle", source, plate)
    notify(source, "police.impounded")
end)

exports("IsPlayerCuffed", function(source)
    return cuffedPlayers[source] == true
end)
