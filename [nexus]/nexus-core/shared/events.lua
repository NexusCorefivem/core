--[[
    Nexus Core event catalog
    Native Nexus naming — geen QB/Qbox dependencies.
    Modules luisteren op deze events voor lifecycle en data-sync.
]]

NexusEvents = {
    -- Player lifecycle (server hooks)
    serverOnPlayerLoaded = "nexus:server:onPlayerLoaded",
    serverOnPlayerUnload = "nexus:server:onPlayerUnload",
    serverPlayerLoaded = "nexus:server:internal:playerLoaded",
    serverPlayerUnloaded = "nexus:server:internal:playerUnloaded",

    -- Player lifecycle (client)
    playerLoaded = "nexus:client:playerLoaded",
    clientOnPlayerLoaded = "nexus:client:onPlayerLoaded",
    playerUnloaded = "nexus:client:playerUnloaded",
    clientOnPlayerUnload = "nexus:client:onPlayerUnload",

    -- PlayerData sync (QBCore/Qbox-equivalent pattern)
    clientSetPlayerData = "nexus:client:setPlayerData",
    serverSetPlayerData = "nexus:server:setPlayerData",

    -- Job
    serverOnJobUpdate = "nexus:server:onJobUpdate",
    clientOnJobUpdate = "nexus:client:onJobUpdate",
    jobsSetDuty = "nexus:jobs:setDuty",

    -- Money
    serverOnMoneyChange = "nexus:server:onMoneyChange",
    clientOnMoneyChange = "nexus:client:onMoneyChange",

    -- Gang
    serverOnGangUpdate = "nexus:server:onGangUpdate",
    clientOnGangUpdate = "nexus:client:onGangUpdate",

    -- Metadata / status
    serverOnMetadataUpdate = "nexus:server:onMetadataUpdate",
    clientOnMetadataUpdate = "nexus:client:onMetadataUpdate",
    -- Server-only internal hooks (never TriggerServerEvent from client)
    serverSetDeathStatus = "nexus:server:setDeathStatus",
    clientSetDeathStatus = "nexus:client:setDeathStatus",

    -- Characters
    characterSelected = "nexus:server:characterSelected",
    requestCharacters = "nexus:server:requestCharacters",
    createCharacter = "nexus:server:createCharacter",

    -- Callbacks
    callbackRequest = "nexus:server:callbackRequest",
    callbackResponse = "nexus:client:callbackResponse",

    -- UI / notify
    notify = "nexus:client:notify",
    setLocale = "nexus:server:setLocale",
    localeChanged = "nexus:client:localeChanged",
    uiReady = "nexus:client:uiReady",
    uiOpen = "nexus:client:uiOpen",
    uiClose = "nexus:client:uiClose",

    -- Target (cross-module)
    targetSelected = "nexus:target:selected",

    -- Economy
    economyTransferBank = "nexus:economy:transferBank"
}
