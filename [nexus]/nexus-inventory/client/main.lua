local inventoryOpen = false

local function setInventoryOpen(visible, payload)
    inventoryOpen = visible
    SetNuiFocus(visible, visible)
    SendNUIMessage({
        action = visible and "open" or "close",
        payload = payload or {}
    })
end

local function openInventory()
    TriggerNexusCallback("nexus:inventory:get", {}, function(items)
        setInventoryOpen(true, { items = items or {} })
    end)
end

RegisterNUICallback("inventory:close", function(_, cb)
    setInventoryOpen(false)
    cb({ ok = true })
end)

RegisterNUICallback("inventory:refresh", function(_, cb)
    TriggerNexusCallback("nexus:inventory:get", {}, function(items)
        cb({ ok = true, items = items or {} })
    end)
end)

RegisterNUICallback("inventory:use", function(data, cb)
    TriggerNexusCallback("nexus:inventory:use", data, function(result)
        cb({ ok = result == true })
    end)
end)

RegisterNUICallback("inventory:drop", function(data, cb)
    TriggerNexusCallback("nexus:inventory:drop", data, function(result)
        cb({ ok = result == true })
    end)
end)

RegisterNUICallback("inventory:give", function(data, cb)
    TriggerNexusCallback("nexus:inventory:give", data, function(result)
        cb({ ok = result == true })
    end)
end)

RegisterCommand("inventory", function()
    openInventory()
end, false)
