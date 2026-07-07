local function getAtmEntries()
    local entries = {}
    for index, coords in ipairs(NexusConfig.Banking.atms) do
        entries["atm_" .. index] = {
            coords = coords,
            radius = NexusConfig.Banking.atmRadius,
            label = NexusTranslate(NexusConfig.Framework.defaultLocale, "banking.open")
        }
    end
    return entries
end

NexusShared.CreateProximityLoop(getAtmEntries, function()
    TriggerNexusCallback("nexus:banking:getBalances", {}, function(data)
        if not data then
            return
        end

        TriggerEvent(NexusEvents.notify, NexusTranslate(NexusConfig.Framework.defaultLocale, "banking.balance", data.bank or 0, data.cash or 0))
    end)
end)
