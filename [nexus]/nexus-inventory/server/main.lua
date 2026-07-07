local NexusUseableItems = {}

local function notify(source, key, ...)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    TriggerClientEvent(NexusEvents.notify, source, NexusTranslate(locale, key, ...))
end

local function getInventoryWeight(items)
    local total = 0
    for _, item in ipairs(items or {}) do
        local definition = NexusItems[item.name]
        local weight = definition and definition.weight or 0
        total = total + (weight * (tonumber(item.count) or 1))
    end
    return total
end

local function getInventory(ownerType, ownerId)
    if not NexusShared.IsAllowedKey(ownerType, 30) then
        return {}
    end

    ownerId = tostring(ownerId or "")
    if ownerId == "" or #ownerId > 80 then
        return {}
    end

    local row = NexusDatabase.FetchSingle("SELECT items FROM nexus_inventories WHERE owner_type = ? AND owner_id = ?", {
        ownerType, ownerId
    })

    if not row then
        NexusDatabase.Insert("INSERT INTO nexus_inventories (owner_type, owner_id, items) VALUES (?, ?, ?)", {
            ownerType, ownerId, "[]"
        })
        return {}
    end

    return json.decode(row.items or "[]") or {}
end

local function hydrateItemsForLocale(items, locale)
    local hydrated = {}

    for index, item in ipairs(items) do
        local definition = NexusItems[item.name]
        local copy = NexusShared.DeepCopy(item)
        if definition and definition.labelKey then
            copy.label = NexusTranslate(locale, definition.labelKey)
        elseif definition and definition.label then
            copy.label = definition.label
        else
            copy.label = item.name
        end

        hydrated[index] = copy
    end

    return hydrated
end

local function saveInventory(ownerType, ownerId, items)
    if not NexusShared.IsAllowedKey(ownerType, 30) then
        return false
    end

    ownerId = tostring(ownerId or "")
    if ownerId == "" or #ownerId > 80 then
        return false
    end

    NexusDatabase.Execute("UPDATE nexus_inventories SET items = ? WHERE owner_type = ? AND owner_id = ?", {
        json.encode(items), ownerType, ownerId
    })
    return true
end

local function removeItemBySlot(ownerType, ownerId, slot, count)
    local items = getInventory(ownerType, ownerId)
    count = tonumber(count) or 0
    slot = tonumber(slot)

    if not slot or count <= 0 then
        return false, items
    end

    for index, item in ipairs(items) do
        if tonumber(item.slot) == slot then
            if (tonumber(item.count) or 0) < count then
                return false, items
            end

            item.count = item.count - count
            if item.count <= 0 then
                table.remove(items, index)
            end

            for itemIndex, entry in ipairs(items) do
                entry.slot = itemIndex
            end

            return saveInventory(ownerType, ownerId, items), items
        end
    end

    return false, items
end

local function canFitItem(items, itemName, count)
    if #items >= NexusConfig.Inventory.maxSlots then
        return false
    end

    local definition = NexusItems[itemName]
    if not definition then
        return false
    end

    local addedWeight = (definition.weight or 0) * count
    return (getInventoryWeight(items) + addedWeight) <= NexusConfig.Inventory.maxWeight
end

exports("GetPlayerInventory", function(source)
    local player = GetNexusPlayer(source)
    if not player then
        return {}
    end

    return getInventory("character", tostring(player.characterId))
end)

exports("AddItem", function(source, itemName, count, metadata)
    local player = GetNexusPlayer(source)
    count = tonumber(count) or 0

    if not player or not NexusItems[itemName] or count <= 0 or count > 1000 then
        return false
    end

    if metadata ~= nil and type(metadata) ~= "table" then
        return false
    end

    local items = getInventory("character", tostring(player.characterId))
    if not canFitItem(items, itemName, count) then
        return false
    end

    items[#items + 1] = {
        slot = #items + 1,
        name = itemName,
        count = math.floor(count),
        metadata = metadata or {}
    }
    return saveInventory("character", tostring(player.characterId), items)
end)

exports("RegisterUseableItem", function(itemName, handler)
    if type(itemName) ~= "string" or type(handler) ~= "function" then
        return false
    end

    NexusUseableItems[itemName] = handler
    return true
end)

exports("RemoveItem", function(source, itemName, count)
    local player = GetNexusPlayer(source)
    count = tonumber(count) or 0

    if not player or not NexusItems[itemName] or count <= 0 then
        return false
    end

    local items = getInventory("character", tostring(player.characterId))
    local remaining = count

    for index = #items, 1, -1 do
        local item = items[index]
        if item.name == itemName then
            local itemCount = tonumber(item.count) or 0
            if itemCount > remaining then
                item.count = itemCount - remaining
                remaining = 0
            else
                remaining = remaining - itemCount
                table.remove(items, index)
            end

            if remaining <= 0 then
                break
            end
        end
    end

    if remaining > 0 then
        return false
    end

    for index, item in ipairs(items) do
        item.slot = index
    end

    return saveInventory("character", tostring(player.characterId), items)
end)

RegisterNexusCallback("nexus:inventory:get", function(source)
    local player = GetNexusPlayer(source)
    local locale = player and player.locale or NexusConfig.Framework.defaultLocale
    local items = exports["nexus-inventory"]:GetPlayerInventory(source)
    return hydrateItemsForLocale(items, locale)
end)

RegisterNexusCallback("nexus:inventory:use", function(source, payload)
    local player = GetNexusPlayer(source)
    if not player or type(payload) ~= "table" then
        return false
    end

    if not NexusSecurity.CheckRateLimit(source, "inventory:use", 1) then
        return false
    end

    local items = getInventory("character", tostring(player.characterId))
    local selected
    for _, item in ipairs(items) do
        if tonumber(item.slot) == tonumber(payload.slot) then
            selected = item
            break
        end
    end

    if not selected then
        return false
    end

    local useHandler = NexusUseableItems[selected.name]
    if useHandler then
        useHandler(source, selected)
        local success = removeItemBySlot("character", tostring(player.characterId), payload.slot, 1)
        if success and NexusItems[selected.name] then
            notify(source, "inventory.used_item", NexusTranslate(player.locale, NexusItems[selected.name].labelKey or selected.name))
        end
        return success
    end

    local success = removeItemBySlot("character", tostring(player.characterId), payload.slot, 1)
    if success and NexusItems[selected.name] then
        notify(source, "inventory.used_item", NexusTranslate(player.locale, NexusItems[selected.name].labelKey or selected.name))
    end

    return success
end)

RegisterNexusCallback("nexus:inventory:drop", function(source, payload)
    local player = GetNexusPlayer(source)
    if not player or type(payload) ~= "table" then
        return false
    end

    local count = tonumber(payload.count) or 1
    if count <= 0 or count > 100 then
        return false
    end

    local items = getInventory("character", tostring(player.characterId))
    local selected
    for _, item in ipairs(items) do
        if tonumber(item.slot) == tonumber(payload.slot) then
            selected = item
            break
        end
    end

    local success = removeItemBySlot("character", tostring(player.characterId), payload.slot, count)
    if success and selected and NexusItems[selected.name] then
        notify(source, "inventory.dropped_item", count, NexusTranslate(player.locale, NexusItems[selected.name].labelKey or selected.name))
    end

    return success
end)

RegisterNexusCallback("nexus:inventory:give", function(source, payload)
    local player = GetNexusPlayer(source)
    if not player or type(payload) ~= "table" then
        return false
    end

    local targetSource = tonumber(payload.target)
    local count = tonumber(payload.count) or 1
    if not targetSource or count <= 0 or count > 100 or targetSource == source then
        return false
    end

    if not NexusSecurity.IsNearPlayer(source, targetSource, 3.0) then
        return false
    end

    local targetPlayer = GetNexusPlayer(targetSource)
    if not targetPlayer then
        return false
    end

    local items = getInventory("character", tostring(player.characterId))
    local selected
    for _, item in ipairs(items) do
        if tonumber(item.slot) == tonumber(payload.slot) then
            selected = item
            break
        end
    end

    if not selected then
        return false
    end

    local removed = removeItemBySlot("character", tostring(player.characterId), payload.slot, count)
    if not removed then
        return false
    end

    local given = exports["nexus-inventory"]:AddItem(targetSource, selected.name, count, selected.metadata or {})
    if not given then
        exports["nexus-inventory"]:AddItem(source, selected.name, count, selected.metadata or {})
        return false
    end

    if NexusItems[selected.name] then
        notify(source, "inventory.given_item", count, NexusTranslate(player.locale, NexusItems[selected.name].labelKey or selected.name))
        local targetLocale = targetPlayer.locale or NexusConfig.Framework.defaultLocale
        TriggerClientEvent(NexusEvents.notify, targetSource, NexusTranslate(targetLocale, "inventory.received_item", count, NexusTranslate(targetLocale, NexusItems[selected.name].labelKey or selected.name)))
    end

    return true
end)
