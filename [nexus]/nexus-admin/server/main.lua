local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

RegisterNetEvent("nexus:admin:teleport", function(x, y, z)
    local source = source
    if not NexusPermissions.HasGroup(source, "staff") then
        notify(source, "admin.no_permission")
        return
    end

    TriggerClientEvent("nexus:admin:client:teleport", source, x, y, z)
    notify(source, "admin.teleport")
end)

RegisterCommand("kick", function(source, args)
    if source ~= 0 and not NexusPermissions.HasGroup(source, "admin") then
        notify(source, "admin.no_permission")
        return
    end

    local target = tonumber(args[1])
    if target then
        DropPlayer(target, args[2] or "Kicked by staff.")
    end
end, false)
