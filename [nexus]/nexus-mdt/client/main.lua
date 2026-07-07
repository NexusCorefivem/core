RegisterCommand("mdt", function(_, args)
    local citizenid = args[1]
    if not citizenid then
        return
    end

    TriggerNexusCallback("nexus:mdt:lookup", { citizenid = citizenid }, function(result)
        if not result then
            TriggerEvent(NexusEvents.notify, "No record found.")
            return
        end

        TriggerEvent(NexusEvents.notify, ("%s %s | %s grade %s"):format(
            result.firstname, result.lastname, result.job_name, result.job_grade
        ))
    end)
end, false)
