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
