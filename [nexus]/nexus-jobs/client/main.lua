RegisterCommand("duty", function()
    TriggerServerEvent("nexus:jobs:setDuty", true)
end, false)

RegisterCommand("offduty", function()
    TriggerServerEvent("nexus:jobs:setDuty", false)
end, false)
