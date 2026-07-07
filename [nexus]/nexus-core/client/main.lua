local callbackIndex = 0
local pendingCallbacks = {}
local localPlayerState = {}
local currentLocale = NexusConfig.Framework.defaultLocale

local function showNotification(message)
    BeginTextCommandThefeedPost("STRING")
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandThefeedPostTicker(false, false)
end

local function nextCallbackId()
    callbackIndex = callbackIndex + 1
    return ("cb_%s"):format(callbackIndex)
end

function TriggerNexusCallback(name, payload, cb)
    local requestId = nextCallbackId()
    pendingCallbacks[requestId] = cb
    TriggerServerEvent(NexusEvents.callbackRequest, requestId, name, payload or {})
end

RegisterNetEvent(NexusEvents.callbackResponse, function(requestId, result, errorCode)
    local cb = pendingCallbacks[requestId]
    if not cb then
        return
    end

    pendingCallbacks[requestId] = nil
    cb(result, errorCode)
end)

RegisterNetEvent(NexusEvents.playerLoaded, function(playerData)
    localPlayerState = playerData
    currentLocale = playerData.locale or NexusConfig.Framework.defaultLocale
    local spawn = playerData.spawn or {}

    DoScreenFadeOut(500)
    while not IsScreenFadedOut() do
        Wait(0)
    end

    local ped = PlayerPedId()
    SetEntityCoords(ped, spawn.x or NexusConfig.Framework.defaultSpawn.x, spawn.y or NexusConfig.Framework.defaultSpawn.y, spawn.z or NexusConfig.Framework.defaultSpawn.z, false, false, false, false)
    SetEntityHeading(ped, spawn.w or NexusConfig.Framework.defaultSpawn.w)
    FreezeEntityPosition(ped, false)
    DoScreenFadeIn(500)

    print(("[nexus-core] %s"):format(NexusTranslate(currentLocale, "core.loaded_character", playerData.name)))
end)

RegisterNetEvent(NexusEvents.localeChanged, function(locale)
    currentLocale = locale or NexusConfig.Framework.defaultLocale
    localPlayerState.locale = currentLocale
end)

RegisterNetEvent(NexusEvents.playerUnloaded, function()
    localPlayerState = {}
end)

RegisterCommand("lang", function(_, args)
    if not args[1] then
        showNotification(NexusTranslate(currentLocale, "core.language_current", currentLocale))
        return
    end

    TriggerServerEvent(NexusEvents.setLocale, args[1])
end, false)
