RegisterNetEvent("nexus:evidence:collect", function(label)
    local source = source
    if not NexusSecurity.IsPoliceOnDuty(source) then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "evidence:collect", 10) then
        return
    end

    exports["nexus-inventory"]:AddItem(source, "evidence_bag", 1, {
        label = NexusShared.SanitizeShortString(label, "Evidence", 64),
        collectedAt = os.time()
    })
end)
