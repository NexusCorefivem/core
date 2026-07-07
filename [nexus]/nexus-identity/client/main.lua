local function showIdentity()
    TriggerNexusCallback("nexus:identity:get", {}, function(data)
        if not data then
            return
        end

        TriggerEvent(NexusEvents.notify, ("ID: %s | %s"):format(data.citizenid, data.name))
    end)
end

RegisterCommand("id", showIdentity, false)
RegisterCommand("identiteit", showIdentity, false)

exports("ShowIdentity", showIdentity)
