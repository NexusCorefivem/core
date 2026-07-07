local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

local function isValidVehicleModel(model)
    return type(model) == "string" and #model > 0 and #model <= 60 and model:match("^[%w_]+$") ~= nil
end

RegisterNetEvent("nexus:dealership:buy", function(dealerId, model)
    local source = source
    if type(dealerId) ~= "string" or type(model) ~= "string" then
        return
    end

    local dealer = NexusConfig.Dealership[dealerId]
    if not dealer or not NexusSecurity.IsNearZone(source, dealer) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "dealership:buy", 10) then
        return
    end

    if not isValidVehicleModel(model) then
        return
    end

    local vehicleConfig
    for _, entry in ipairs(dealer.vehicles or {}) do
        if entry.model == model then
            vehicleConfig = entry
            break
        end
    end

    if not vehicleConfig then
        return
    end

    if not exports["nexus-economy"]:RemoveMoney(source, "bank", vehicleConfig.price) then
        notify(source, "dealership.no_money")
        return
    end

    local record = exports["nexus-vehicles"]:CreateVehicleRecord(source, model, "pillbox")
    if not record then
        exports["nexus-economy"]:AddMoney(source, "bank", vehicleConfig.price)
        return
    end

    TriggerClientEvent("nexus:dealership:client:spawn", source, dealerId, model, record.plate)
    notify(source, "dealership.bought", model, vehicleConfig.price)
end)
