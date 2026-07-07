local businessOwners = {}

local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:businesses:buy", function(businessId)
    local source = source
    local business = NexusConfig.Businesses[businessId]
    local player = GetNexusPlayer(source)
    if not business or not player or businessOwners[businessId] then
        return
    end

    if not exports["nexus-economy"]:RemoveMoney(source, "bank", business.ownerPrice or 25000) then
        notify(source, "shops.no_money")
        return
    end

    businessOwners[businessId] = player.characterId
    notify(source, "business.bought", business.label)
end)

CreateThread(function()
    while true do
        Wait(15 * 60000)
        for businessId, ownerCharacterId in pairs(businessOwners) do
            local business = NexusConfig.Businesses[businessId]
            if business then
                for source, player in pairs(GetNexusPlayers()) do
                    if player.characterId == ownerCharacterId then
                        exports["nexus-economy"]:AddMoney(source, "bank", business.payout or 100)
                        notify(source, "business.payout", business.payout or 100)
                    end
                end
            end
        end
    end
end)
