local function openRadial()
    local locale = NexusConfig.Framework.defaultLocale
    local items = {
        {
            label = "Inventory",
            onSelect = function()
                ExecuteCommand("inventory")
            end
        },
        {
            label = "Phone",
            onSelect = function()
                ExecuteCommand("phone")
            end
        },
        {
            label = "ID",
            onSelect = function()
                exports["nexus-identity"]:ShowIdentity()
            end
        },
        {
            label = "Vehicle Lock",
            onSelect = function()
                exports["nexus-vehiclekeys"]:ToggleLock()
            end
        },
        {
            label = "Toggle Duty",
            onSelect = function()
                TriggerNexusCallback("nexus:jobs:get", {}, function(job)
                    if not job then
                        return
                    end
                    TriggerServerEvent("nexus:jobs:setDuty", not job.onduty)
                end)
            end
        }
    }

    exports["nexus-menu"]:OpenSimpleMenu(NexusTranslate(locale, "radial.title"), items)
end

RegisterCommand("nexusradial", openRadial, false)
RegisterKeyMapping("nexusradial", "Open Nexus radial menu", "keyboard", NexusConfig.Radial.key or "F1")
