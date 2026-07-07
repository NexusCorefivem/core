NexusDatabase = {}

local function ensureMySqlReady()
    if not MySQL or not MySQL.ready then
        error("^1[nexus-core]^7 oxmysql is required but was not found.")
    end
end

function NexusDatabase.OnReady(callback)
    ensureMySqlReady()
    MySQL.ready(callback)
end

function NexusDatabase.FetchAll(query, parameters)
    return MySQL.query.await(query, parameters or {})
end

function NexusDatabase.FetchSingle(query, parameters)
    return MySQL.single.await(query, parameters or {})
end

function NexusDatabase.Execute(query, parameters)
    return MySQL.update.await(query, parameters or {})
end

function NexusDatabase.Insert(query, parameters)
    return MySQL.insert.await(query, parameters or {})
end
