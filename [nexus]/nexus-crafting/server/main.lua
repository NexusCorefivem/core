local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:crafting:craft", function(recipeId)
    local source = source
    local recipe = NexusConfig.Crafting[recipeId]
    if not recipe then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "crafting:" .. recipeId, 3) then
        return
    end

    if recipe.station and NexusConfig.CraftingStations and NexusConfig.CraftingStations[recipe.station] then
        if not NexusSecurity.IsNearZone(source, NexusConfig.CraftingStations[recipe.station]) then
            notify(source, "crafting.failed")
            return
        end
    end

    for itemName, amount in pairs(recipe.requires or {}) do
        if not exports["nexus-inventory"]:RemoveItem(source, itemName, amount) then
            notify(source, "crafting.failed")
            return
        end
    end

    for itemName, amount in pairs(recipe.gives or {}) do
        exports["nexus-inventory"]:AddItem(source, itemName, amount)
    end

    notify(source, "crafting.success")
end)
