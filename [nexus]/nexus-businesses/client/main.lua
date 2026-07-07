CreateThread(function()
    Wait(1000)
    for businessId, business in pairs(NexusConfig.Businesses) do
        exports["nexus-target"]:RegisterZone("business:" .. businessId, {
            coords = business.coords,
            radius = business.radius or 2.5,
            label = business.label
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^business:") then
        return
    end

    local businessId = zoneId:gsub("^business:", "")
    local business = NexusConfig.Businesses[businessId]
    if not business then
        return
    end

    exports["nexus-menu"]:OpenSimpleMenu(business.label, {
        {
            label = ("Buy business - $%s"):format(business.ownerPrice or 25000),
            onSelect = function()
                TriggerServerEvent("nexus:businesses:buy", businessId)
            end
        }
    })
end)
