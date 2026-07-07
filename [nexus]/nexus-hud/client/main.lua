CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        SendNUIMessage({
            action = "hud:update",
            payload = {
                health = math.max(0, GetEntityHealth(ped) - 100),
                armor = GetPedArmour(ped)
            }
        })
    end
end)
