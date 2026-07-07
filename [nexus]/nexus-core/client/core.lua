Nexus = {
    PlayerData = {},
    Functions = {},
    Config = NexusConfig,
    Shared = NexusShared,
    Items = NexusItems,
    Gangs = NexusGangs,
    Events = NexusEvents
}

function Nexus.Functions.GetPlayerData()
    return Nexus.PlayerData
end

function Nexus.Functions.IsLoggedIn()
    return Nexus.PlayerData and Nexus.PlayerData.citizenid ~= nil
end

function Nexus.Functions.Notify(message)
    TriggerEvent(NexusEvents.notify, message)
end

function GetCoreObject()
    return Nexus
end

local function applyPlayerData(playerData, key)
    Nexus.PlayerData = playerData or {}

    local playerState = LocalPlayer.state
    if playerState then
        playerState:set("isLoggedIn", playerData.citizenid ~= nil, true)
        playerState:set("citizenid", playerData.citizenid, true)
        playerState:set("job", playerData.job, true)
        playerState:set("gang", playerData.gang, true)
    end

    if not key or key == "job" then
        TriggerEvent(NexusEvents.clientOnJobUpdate, Nexus.PlayerData.job)
    end

    if not key or key == "money" then
        TriggerEvent(NexusEvents.clientOnMoneyChange, Nexus.PlayerData.money)
    end

    if not key or key == "gang" then
        TriggerEvent(NexusEvents.clientOnGangUpdate, Nexus.PlayerData.gang)
    end
end

RegisterNetEvent(NexusEvents.clientSetPlayerData, function(playerData, key)
    applyPlayerData(playerData, key)
end)

RegisterNetEvent(NexusEvents.clientOnPlayerUnload, function()
    Nexus.PlayerData = {}
    LocalPlayer.state:set("isLoggedIn", false, true)
end)

RegisterNetEvent(NexusEvents.clientSetDeathStatus, function(isDead)
    Nexus.PlayerData.isdead = isDead == true
end)

exports("GetCoreObject", GetCoreObject)
exports("GetPlayerData", function()
    return Nexus.PlayerData
end)
