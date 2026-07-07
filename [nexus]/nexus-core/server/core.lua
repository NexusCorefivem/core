local function notifyPlayer(source, message)
    TriggerClientEvent(NexusEvents.notify, source, message)
end

function SetPlayerDeathStatus(source, isDead)
    local player = GetNexusPlayer(source)
    if not player then
        return false
    end

    player:SetDeathStatus(isDead == true)
    player:Save()
    return true
end

function GetCoreObject()
    return {
        Config = NexusConfig,
        Shared = NexusShared,
        Items = NexusItems,
        Gangs = NexusGangs,
        Events = NexusEvents,
        Functions = {
            GetPlayer = GetNexusPlayer,
            GetPlayerByCitizenId = GetNexusPlayerByCitizenId,
            GetPlayers = function()
                return NexusPlayers
            end,
            CreateCallback = RegisterNexusCallback,
            Notify = notifyPlayer,
            SyncPlayerData = SyncPlayerData,
            SetDeathStatus = SetPlayerDeathStatus,
            GetIdentifier = function(source, idType)
                local identifiers = GetPlayerIdentifiers(source)
                local prefix = (idType or "license") .. ":"
                for _, identifier in ipairs(identifiers) do
                    if identifier:find(prefix, 1, true) == 1 then
                        return identifier
                    end
                end
                return nil
            end
        },
        Player = {
            Save = function(source)
                local player = GetNexusPlayer(source)
                if player then
                    player:Save()
                end
            end
        }
    }
end

exports("GetCoreObject", GetCoreObject)
exports("SyncPlayerData", SyncPlayerData)
exports("GetNexusPlayerByCitizenId", GetNexusPlayerByCitizenId)
exports("SetPlayerDeathStatus", SetPlayerDeathStatus)
