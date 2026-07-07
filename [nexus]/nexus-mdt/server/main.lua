RegisterNexusCallback("nexus:mdt:lookup", function(source, payload)
    local player = GetNexusPlayer(source)
    if not player or player.job.name ~= "police" then
        return nil
    end

    local citizenid = NexusShared.SanitizeShortString(payload and payload.citizenid, "", 24)
    if citizenid == "" then
        return nil
    end

    return NexusDatabase.FetchSingle("SELECT citizenid, firstname, lastname, job_name, job_grade FROM nexus_characters WHERE citizenid = ? AND deleted_at IS NULL", {
        citizenid
    })
end)
