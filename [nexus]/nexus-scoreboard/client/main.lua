local scoreboardOpen = false

local function setScoreboardOpen(visible, payload)
    scoreboardOpen = visible
    SetNuiFocus(visible, visible)
    SendNUIMessage({
        action = visible and "open" or "close",
        payload = payload or {}
    })
end

RegisterCommand("scoreboard", function()
    if scoreboardOpen then
        setScoreboardOpen(false)
        return
    end

    TriggerNexusCallback("nexus:scoreboard:list", {}, function(players)
        setScoreboardOpen(true, { players = players or {} })
    end)
end, false)

RegisterKeyMapping("scoreboard", "Open scoreboard", "keyboard", "F10")

RegisterNUICallback("scoreboard:close", function(_, cb)
    setScoreboardOpen(false)
    cb({ ok = true })
end)
