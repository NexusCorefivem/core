local zones = {}

exports("RegisterZone", function(zoneId, data)
    if type(zoneId) ~= "string" or type(data) ~= "table" or not data.coords then
        return false
    end

    zones[zoneId] = data
    return true
end)

exports("RemoveZone", function(zoneId)
    zones[zoneId] = nil
end)

NexusShared.CreateProximityLoop(function()
    return zones
end, function(zoneId, zone)
    TriggerEvent("nexus:target:selected", zoneId, zone)
end)
