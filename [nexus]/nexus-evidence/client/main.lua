RegisterCommand("collectevidence", function(_, args)
    TriggerServerEvent("nexus:evidence:collect", table.concat(args, " "))
end, false)
