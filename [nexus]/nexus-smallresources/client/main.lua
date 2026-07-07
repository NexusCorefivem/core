local seatbeltOn = false
local handsUp = false

local function notify(key)
    TriggerEvent(NexusEvents.notify, NexusTranslate(NexusConfig.Framework.defaultLocale, key))
end

local function toggleSeatbelt()
    seatbeltOn = not seatbeltOn
    notify(seatbeltOn and "smallresources.seatbelt_on" or "smallresources.seatbelt_off")
end

local function toggleHandsUp()
    local ped = PlayerPedId()
    handsUp = not handsUp

    if handsUp then
        RequestAnimDict("missminuteman_1ig_2")
        while not HasAnimDictLoaded("missminuteman_1ig_2") do
            Wait(10)
        end
        TaskPlayAnim(ped, "missminuteman_1ig_2", "handsup_base", 8.0, -8.0, -1, 49, 0, false, false, false)
        notify("smallresources.handsup")
    else
        ClearPedTasks(ped)
    end
end

CreateThread(function()
    while true do
        if seatbeltOn and IsPedInAnyVehicle(PlayerPedId(), false) then
            DisableControlAction(0, 75, true)
            Wait(0)
        else
            Wait(500)
        end
    end
end)

RegisterCommand("seatbelt", toggleSeatbelt, false)
RegisterKeyMapping("seatbelt", "Toggle seatbelt", "keyboard", NexusConfig.SmallResources.seatbeltKey or "B")

RegisterCommand("handsup", toggleHandsUp, false)
RegisterKeyMapping("handsup", "Toggle hands up", "keyboard", NexusConfig.SmallResources.handsupKey or "X")
