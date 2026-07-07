local hudData = {}

RegisterNetEvent(NexusEvents.clientOnMoneyChange, function(money)
    hudData.cash = money and money.cash or hudData.cash
    hudData.bank = money and money.bank or hudData.bank
end)

RegisterNetEvent(NexusEvents.clientOnJobUpdate, function(job)
    hudData.job = job and job.label or hudData.job
end)

RegisterNetEvent(NexusEvents.playerLoaded, function(playerData)
    hudData = {
        name = playerData.name,
        cash = playerData.money and playerData.money.cash or 0,
        bank = playerData.money and playerData.money.bank or 0,
        job = playerData.job and playerData.job.label or "unemployed"
    }
end)

RegisterNetEvent(NexusEvents.playerUnloaded, function()
    hudData = {}
end)

CreateThread(function()
    while true do
        Wait(1000)
        local ped = PlayerPedId()
        SendNUIMessage({
            action = "hud:update",
            payload = {
                health = math.max(0, GetEntityHealth(ped) - 100),
                armor = GetPedArmour(ped),
                name = hudData.name or "",
                cash = hudData.cash or 0,
                bank = hudData.bank or 0,
                job = hudData.job or ""
            }
        })
    end
end)
