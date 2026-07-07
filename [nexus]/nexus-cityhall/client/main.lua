CreateThread(function()
    Wait(1000)
    exports["nexus-target"]:RegisterZone("cityhall:main", {
        coords = NexusConfig.CityHall.coords,
        radius = NexusConfig.CityHall.radius or 2.5,
        label = "City Hall"
    })
end)

AddEventHandler("nexus:target:selected", function(zoneId)
    if zoneId ~= "cityhall:main" then
        return
    end

    exports["nexus-menu"]:OpenSimpleMenu("City Hall", {
        {
            label = ("ID Card - $%s"):format(NexusConfig.CityHall.idPrice),
            onSelect = function()
                TriggerServerEvent("nexus:cityhall:purchase", "id")
            end
        },
        {
            label = ("Driver License - $%s"):format(NexusConfig.CityHall.licensePrice),
            onSelect = function()
                TriggerServerEvent("nexus:cityhall:purchase", "license")
            end
        }
    })
end)
