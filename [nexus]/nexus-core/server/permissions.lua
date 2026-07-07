NexusPermissions = {}

local aceMap = {
    owner = "nexus.owner",
    admin = "nexus.admin",
    staff = "nexus.staff"
}

function NexusPermissions.GetGroup(source)
    if IsPlayerAceAllowed(source, aceMap.owner) then
        return "owner"
    end

    if IsPlayerAceAllowed(source, aceMap.admin) then
        return "admin"
    end

    if IsPlayerAceAllowed(source, aceMap.staff) then
        return "staff"
    end

    return "player"
end

function NexusPermissions.HasGroup(source, requiredGroup)
    local playerGroup = NexusPermissions.GetGroup(source)
    return NexusConfig.Permissions[playerGroup] >= NexusConfig.Permissions[requiredGroup]
end
