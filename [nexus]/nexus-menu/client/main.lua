local menuOpen = false
local pendingMenuItems = {}

local function setMenuOpen(visible, payload)
    menuOpen = visible
    SetNuiFocus(visible, visible)
    SendNUIMessage({
        action = visible and "menu:open" or "menu:close",
        payload = payload or {}
    })
end

RegisterNUICallback("menu:close", function(_, cb)
    setMenuOpen(false)
    pendingMenuItems = {}
    cb({ ok = true })
end)

RegisterNUICallback("menu:select", function(data, cb)
    local item = pendingMenuItems[tonumber(data.index)]
    setMenuOpen(false)

    if item and item.onSelect then
        item.onSelect()
    end

    pendingMenuItems = {}
    cb({ ok = true })
end)

exports("OpenSimpleMenu", function(title, items)
    pendingMenuItems = items or {}
    local serializable = {}

    for index, item in ipairs(pendingMenuItems) do
        serializable[index] = { label = item.label or ("Item " .. index) }
    end

    setMenuOpen(true, {
        title = title or "Nexus Menu",
        items = serializable
    })
end)
