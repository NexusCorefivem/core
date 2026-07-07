CreateThread(function()
    Wait(1000)
    for dealerId, dealer in pairs(NexusConfig.Dealership) do
        exports["nexus-target"]:RegisterZone("dealership:" .. dealerId, {
            coords = dealer.coords,
            radius = dealer.radius or 3.0,
            label = dealer.label or "Dealership"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^dealership:") then
        return
    end

    local dealerId = zoneId:gsub("^dealership:", "")
    local dealer = NexusConfig.Dealership[dealerId]
    if not dealer then
        return
    end

    local menuItems = {}
    for _, entry in ipairs(dealer.vehicles or {}) do
        menuItems[#menuItems + 1] = {
            label = ("%s - $%s"):format(entry.model, entry.price),
            onSelect = function()
                TriggerServerEvent("nexus:dealership:buy", dealerId, entry.model)
            end
        }
    end

    exports["nexus-menu"]:OpenSimpleMenu(dealer.label or "Dealership", menuItems)
end)

RegisterNetEvent("nexus:dealership:client:spawn", function(dealerId, model, plate)
    local dealer = NexusConfig.Dealership[dealerId]
    if not dealer or not dealer.spawn then
        return
    end

    local hash = joaat(model)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(10)
    end

    local spawn = dealer.spawn
    local vehicle = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, spawn.w, true, false)
    SetVehicleNumberPlateText(vehicle, plate)
    SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetModelAsNoLongerNeeded(hash)
end)
