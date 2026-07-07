RegisterCommand("crafting", function()
    local items = {}
    for recipeId, recipe in pairs(NexusConfig.Crafting) do
        items[#items + 1] = {
            label = NexusTranslate(NexusConfig.Framework.defaultLocale, recipe.labelKey or recipeId),
            onSelect = function()
                TriggerServerEvent("nexus:crafting:craft", recipeId)
            end
        }
    end

    exports["nexus-menu"]:OpenSimpleMenu("Crafting", items)
end, false)
