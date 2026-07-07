RegisterNetEvent("nexus:phone:send", function(targetSource, message)
    local source = source
    targetSource = tonumber(targetSource)
    message = NexusShared.SanitizeShortString(message, "", 200)

    if not targetSource or targetSource == source or message == "" then
        return
    end

    if not NexusSecurity.CheckRateLimit(source, "phone:send", 3) then
        return
    end

    local sender = GetNexusPlayer(source)
    local receiver = GetNexusPlayer(targetSource)
    if not sender or not receiver then
        return
    end

    TriggerClientEvent("nexus:phone:receive", targetSource, {
        from = sender:GetName(),
        message = message
    })

    local locale = sender.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, "phone.sent"))
end)
