local insideProperty = false
local lastOutside = nil

CreateThread(function()
    Wait(1000)
    for propertyKey, property in pairs(NexusConfig.Housing) do
        exports["nexus-target"]:RegisterZone("housing:" .. propertyKey, {
            coords = property.coords,
            radius = property.radius or 2.5,
            label = property.label
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^housing:") then
        return
    end

    local propertyKey = zoneId:gsub("^housing:", "")
    local property = NexusConfig.Housing[propertyKey]
    if not property then
        return
    end

    TriggerNexusCallback("nexus:housing:get", {
        propertyKey = propertyKey,
        label = property.label
    }, function(data)
        local items = {}

        if data and not data.isOwner then
            items[#items + 1] = {
                label = ("Buy - $%s"):format(property.price),
                onSelect = function()
                    TriggerServerEvent("nexus:housing:buy", propertyKey)
                end
            }
        end

        if data and data.isOwner then
            items[#items + 1] = {
                label = "Enter",
                onSelect = function()
                    lastOutside = GetEntityCoords(PlayerPedId())
                    TriggerServerEvent("nexus:housing:enter", propertyKey)
                end
            }
        end

        exports["nexus-menu"]:OpenSimpleMenu(property.label, items)
    end)
end)

RegisterNetEvent("nexus:housing:client:enter", function(interior)
    insideProperty = true
    local ped = PlayerPedId()
    SetEntityCoords(ped, interior.x, interior.y, interior.z, false, false, false, false)
    SetEntityHeading(ped, interior.w or 0.0)
end)

RegisterNetEvent("nexus:housing:client:exit", function(coords)
    insideProperty = false
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z, false, false, false, false)
    SetEntityHeading(ped, coords.w or 0.0)
end)

RegisterCommand("leavehouse", function()
    if insideProperty then
        TriggerServerEvent("nexus:housing:exit")
    end
end, false)
