local function openManagement(jobName)
    TriggerNexusCallback("nexus:management:canOpen", { jobName = jobName }, function(allowed)
        if not allowed then
            return
        end

        local locale = NexusConfig.Framework.defaultLocale
        TriggerEvent(NexusEvents.notify, NexusTranslate(locale, "management.opened"))

        exports["nexus-menu"]:OpenSimpleMenu("Management - " .. jobName, {
            {
                label = "Hire nearby",
                onSelect = function()
                    TriggerServerEvent("nexus:management:hireNearby", jobName)
                end
            },
            {
                label = "Fire nearby",
                onSelect = function()
                    TriggerServerEvent("nexus:management:fireNearby", jobName)
                end
            }
        })
    end)
end

CreateThread(function()
    Wait(1000)
    for jobName, config in pairs(NexusConfig.Management) do
        exports["nexus-target"]:RegisterZone("management:" .. jobName, {
            coords = config.coords,
            radius = config.radius or 2.0,
            label = "Boss Menu"
        })
    end
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if type(zoneId) ~= "string" or not zoneId:find("^management:") then
        return
    end

    local jobName = zoneId:gsub("^management:", "")
    openManagement(jobName)
end)
