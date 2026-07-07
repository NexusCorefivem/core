CreateThread(function()
    Wait(1000)
    for marketId, market in pairs(NexusConfig.Blackmarket) do
        exports["nexus-target"]:RegisterZone("blackmarket:" .. marketId, {
            coords = market.coords,
            radius = market.radius or 2.5,
            label = market.label or "Black Market"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^blackmarket:") then
        return
    end

    local marketId = zoneId:gsub("^blackmarket:", "")
    local market = NexusConfig.Blackmarket[marketId]
    if not market then
        return
    end

    local items = {}
    for _, entry in ipairs(market.items or {}) do
        items[#items + 1] = {
            label = ("%s - $%s (%s)"):format(entry.name, entry.price, entry.account or "dirty"),
            onSelect = function()
                TriggerServerEvent("nexus:blackmarket:buy", marketId, entry.name)
            end
        }
    end

    exports["nexus-menu"]:OpenSimpleMenu(market.label, items)
end)
