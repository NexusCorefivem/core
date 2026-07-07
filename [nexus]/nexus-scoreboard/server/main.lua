RegisterNexusCallback("nexus:scoreboard:list", function(source)
    local entries = {}
    for playerSource, player in pairs(GetNexusPlayers()) do
        entries[#entries + 1] = {
            id = playerSource,
            name = player:GetName(),
            job = player.job.name,
            grade = player.job.grade
        }
    end
    table.sort(entries, function(a, b) return a.id < b.id end)
    return entries
end)
