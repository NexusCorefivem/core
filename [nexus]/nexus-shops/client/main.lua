CreateThread(function()
    Wait(1000)
    for shopId, shop in pairs(NexusConfig.Shops) do
        exports["nexus-target"]:RegisterZone("shop:" .. shopId, {
            coords = shop.coords,
            radius = shop.radius or 2.5,
            label = shop.label or "Shop"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^shop:") then
        return
    end

    local shopId = zoneId:gsub("^shop:", "")
    local shop = NexusConfig.Shops[shopId]
    if not shop then
        return
    end

    local menuItems = {}
    for _, entry in ipairs(shop.items or {}) do
        menuItems[#menuItems + 1] = {
            label = ("%s - $%s"):format(entry.name, entry.price),
            onSelect = function()
                TriggerServerEvent("nexus:shops:buy", shopId, entry.name, 1)
            end
        }
    end

    exports["nexus-menu"]:OpenSimpleMenu(shop.label or "Shop", menuItems)
end)
