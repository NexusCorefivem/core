NexusShared = {}

function NexusShared.GenerateCitizenId()
    local charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = "NX-"

    for _ = 1, 8 do
        local index = math.random(1, #charset)
        result = result .. charset:sub(index, index)
    end

    return result
end

function NexusShared.DeepCopy(source)
    if type(source) ~= "table" then
        return source
    end

    local copy = {}
    for key, value in pairs(source) do
        copy[key] = NexusShared.DeepCopy(value)
    end

    return copy
end

function NexusShared.Clamp(value, minValue, maxValue)
    return math.max(minValue, math.min(maxValue, value))
end

function NexusShared.Trim(value)
    if type(value) ~= "string" then
        return ""
    end

    return value:gsub("^%s+", ""):gsub("%s+$", "")
end

function NexusShared.SanitizeShortString(value, fallback, maxLength)
    value = NexusShared.Trim(value)
    if value == "" then
        return fallback or ""
    end

    maxLength = tonumber(maxLength) or 64
    return value:sub(1, maxLength)
end

function NexusShared.IsAllowedKey(value, maxLength)
    if type(value) ~= "string" then
        return false
    end

    maxLength = tonumber(maxLength) or 64
    if #value == 0 or #value > maxLength then
        return false
    end

    return value:match("^[%w_%-]+$") ~= nil
end

if not IsDuplicityVersion() then
    function NexusShared.CreateProximityLoop(getEntries, onInteract)
        CreateThread(function()
            while true do
                local waitMs = 1000
                local ped = PlayerPedId()
                local position = GetEntityCoords(ped)

                for entryId, entry in pairs(getEntries()) do
                    local coords = entry.coords
                    if coords then
                        local target = vector3(coords.x, coords.y, coords.z)
                        if #(position - target) <= (entry.radius or 2.0) then
                            waitMs = 0
                            BeginTextCommandDisplayHelp("STRING")
                            AddTextComponentSubstringPlayerName(entry.label or "[E]")
                            EndTextCommandDisplayHelp(0, false, true, -1)

                            if IsControlJustReleased(0, 38) then
                                onInteract(entryId, entry)
                            end
                        end
                    end
                end

                Wait(waitMs)
            end
        end)
    end
end
