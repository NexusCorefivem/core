RegisterNexusCallback("nexus:spawn:getChoices", function(source)
    local player = GetNexusPlayer(source)
    if not player then
        return {}
    end

    local lastLocation = json.decode(player.lastLocation or "{}") or {}
    return {
        default = {
            label = "Default Spawn",
            coords = NexusConfig.Framework.defaultSpawn
        },
        last = {
            label = "Last Location",
            coords = vector4(
                tonumber(lastLocation.x) or NexusConfig.Framework.defaultSpawn.x,
                tonumber(lastLocation.y) or NexusConfig.Framework.defaultSpawn.y,
                tonumber(lastLocation.z) or NexusConfig.Framework.defaultSpawn.z,
                tonumber(lastLocation.w) or NexusConfig.Framework.defaultSpawn.w
            )
        }
    }
end)
