local menuOpen = false

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
    cb({ ok = true })
end)

exports("OpenSimpleMenu", function(title, items)
    setMenuOpen(true, {
        title = title or "Nexus Menu",
        items = items or {}
    })
end)
