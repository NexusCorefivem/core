local coreResource = "nexus-core"

local currentResource = GetCurrentResourceName()

local callbackCounter = 0



function RegisterNexusCallback(name, handler)

    callbackCounter = callbackCounter + 1

    local exportName = ("__nexus_callback_%d"):format(callbackCounter)



    exports(exportName, function(source, payload)

        return handler(source, payload)

    end)



    TriggerEvent("nexus:internal:registerCallbackRoute", name, currentResource, exportName)

end



function GetNexusPlayer(source)

    return exports[coreResource]:GetNexusPlayer(source)

end



function GetNexusPlayers()

    return exports[coreResource]:GetNexusPlayers()

end



function GetNexusPlayerByCitizenId(citizenId)

    return exports[coreResource]:GetNexusPlayerByCitizenId(citizenId)

end



function SyncPlayerData(source, key, value)

    return exports[coreResource]:SyncPlayerData(source, key, value)

end



function GetCoreObject()

    return exports[coreResource]:GetCoreObject()

end



NexusSecurity = {}



function NexusSecurity.IsNearCoords(source, coords, radius)

    return exports[coreResource]:SecurityIsNearCoords(source, coords, radius)

end



function NexusSecurity.IsNearZone(source, zone)

    return exports[coreResource]:SecurityIsNearZone(source, zone)

end



function NexusSecurity.IsNearPlayer(source, targetSource, maxDistance)

    return exports[coreResource]:SecurityIsNearPlayer(source, targetSource, maxDistance)

end



function NexusSecurity.CheckRateLimit(source, key, cooldownSeconds)

    return exports[coreResource]:SecurityCheckRateLimit(source, key, cooldownSeconds)

end



function NexusSecurity.IsOnDuty(source, jobName)

    return exports[coreResource]:SecurityIsOnDuty(source, jobName)

end



function NexusSecurity.IsStaff(source)

    return exports[coreResource]:SecurityIsStaff(source)

end



function NexusSecurity.IsNearAnyAtm(source)
    return exports[coreResource]:SecurityIsNearAnyAtm(source)
end

NexusDatabase = {}



function NexusDatabase.FetchAll(query, parameters)

    return exports[coreResource]:DatabaseFetchAll(query, parameters)

end



function NexusDatabase.FetchSingle(query, parameters)

    return exports[coreResource]:DatabaseFetchSingle(query, parameters)

end



function NexusDatabase.Execute(query, parameters)

    return exports[coreResource]:DatabaseExecute(query, parameters)

end



function NexusDatabase.Insert(query, parameters)

    return exports[coreResource]:DatabaseInsert(query, parameters)

end



function NexusDatabase.OnReady(callback)

    return exports[coreResource]:DatabaseOnReady(callback)

end

