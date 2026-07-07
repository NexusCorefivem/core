exports("GetCharacters", function(source)
    local identifiers = GetPlayerIdentifiers(source)
    local identifier

    for _, value in ipairs(identifiers) do
        if value:find("license:") == 1 then
            identifier = value
            break
        end
    end

    identifier = identifier or identifiers[1]
    if not identifier then
        return {}
    end

    local account = NexusDatabase.FetchSingle("SELECT id FROM nexus_accounts WHERE license = ?", { identifier })
    if not account then
        return {}
    end

    return NexusDatabase.FetchAll("SELECT * FROM nexus_characters WHERE account_id = ?", { account.id })
end)
