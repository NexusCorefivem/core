local currentLocale = NexusConfig.Framework.defaultLocale

local function showNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end

RegisterNetEvent(NexusEvents.playerLoaded, function(playerData)
    local spawn = playerData.position or playerData.spawn or {}
    currentLocale = playerData.locale or NexusConfig.Framework.defaultLocale

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    local ped = PlayerPedId()
    SetEntityCoords(ped, spawn.x or NexusConfig.Framework.defaultSpawn.x, spawn.y or NexusConfig.Framework.defaultSpawn.y, spawn.z or NexusConfig.Framework.defaultSpawn.z, false, false, false, false)
    SetEntityHeading(ped, spawn.w or NexusConfig.Framework.defaultSpawn.w)
    FreezeEntityPosition(ped, false)
    DoScreenFadeIn(500)

    if NexusConfig.Framework.debug then
        print(("[nexus-core] %s"):format(NexusTranslate(currentLocale, "core.loaded_character", playerData.name)))
    end
end)

RegisterNetEvent(NexusEvents.localeChanged, function(locale)
    currentLocale = locale or NexusConfig.Framework.defaultLocale
    if Nexus.PlayerData then
        Nexus.PlayerData.locale = currentLocale
    end
end)

RegisterNetEvent(NexusEvents.playerUnloaded, function()
    currentLocale = NexusConfig.Framework.defaultLocale
end)

RegisterCommand("lang", function(_, args)
    if not args[1] then
        showNotification(NexusTranslate(currentLocale, "core.language_current", currentLocale))
        return
    end

    TriggerServerEvent(NexusEvents.setLocale, args[1])
end, false)
