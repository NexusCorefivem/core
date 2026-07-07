local isCharacterUiOpen = false
local currentCharacters = {}
local uiSession = 0

local function setPlayerFrozen(frozen)
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, frozen)
end

local function sendUiMessage(action, payload)
    SendNUIMessage({
        action = action,
        payload = payload or {}
    })
end

local function setUiVisible(visible, payload)
    if not visible then
        uiSession = uiSession + 1
    end

    isCharacterUiOpen = visible

    if visible then
        ShutdownLoadingScreen()
        ShutdownLoadingScreenNui()
        setPlayerFrozen(true)
        DisplayRadar(false)
        SetNuiFocus(true, true)
        sendUiMessage("open", payload)
    else
        SetNuiFocus(false, false)
        setPlayerFrozen(false)
        DisplayRadar(true)
        sendUiMessage("close")
    end
end

local function updateCharacterUi(session, payload)
    if session ~= uiSession or not isCharacterUiOpen then
        return
    end

    sendUiMessage("open", payload)
end

local function applyAppearance(data)
    if type(data) ~= "table" then
        return
    end

    local ped = PlayerPedId()
    local modelName = data.model or NexusConfig.Appearance.defaultModelMale
    local model = joaat(modelName)

    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        ped = PlayerPedId()
    end

    local components = data.components or {}
    for componentId, componentData in pairs(components) do
        local componentIndex = tonumber(componentId)
        if componentIndex and type(componentData) == "table" then
            SetPedComponentVariation(
                ped,
                componentIndex,
                tonumber(componentData.drawable) or 0,
                tonumber(componentData.texture) or 0,
                tonumber(componentData.palette) or 0
            )
        end
    end

    local props = data.props or {}
    for propId, propData in pairs(props) do
        local propIndex = tonumber(propId)
        if propIndex and type(propData) == "table" then
            if (tonumber(propData.drawable) or -1) >= 0 then
                SetPedPropIndex(
                    ped,
                    propIndex,
                    tonumber(propData.drawable) or 0,
                    tonumber(propData.texture) or 0,
                    true
                )
            else
                ClearPedProp(ped, propIndex)
            end
        end
    end
end

local function buildCharacterPayload(characters)
    local entries = {}

    for _, character in ipairs(characters or {}) do
        entries[#entries + 1] = {
            id = character.id,
            citizenid = character.citizenid,
            firstname = character.firstname,
            lastname = character.lastname,
            dateofbirth = character.dateofbirth,
            gender = character.gender,
            locale = character.locale
        }
    end

    return {
        characters = entries,
        locales = NexusGetSupportedLocales()
    }
end

local function openCharacterUi()
    uiSession = uiSession + 1
    local session = uiSession

    setUiVisible(true, {
        characters = {},
        locales = NexusGetSupportedLocales(),
        loading = true
    })

    TriggerNexusCallback("nexus:characters:list", {}, function(characters, errorCode)
        if errorCode then
            updateCharacterUi(session, {
                characters = {},
                locales = NexusGetSupportedLocales(),
                loading = false,
                error = errorCode
            })
            return
        end

        currentCharacters = characters or {}
        updateCharacterUi(session, buildCharacterPayload(currentCharacters))
    end)
end

RegisterNetEvent(NexusEvents.playerLoaded, function(playerData)
    setUiVisible(false)

    if playerData.appearance then
        applyAppearance(playerData.appearance)
    end
end)

RegisterNetEvent(NexusEvents.playerUnloaded, function()
    currentCharacters = {}
    setUiVisible(false)
end)

RegisterNUICallback("character:close", function(_, cb)
    setUiVisible(false)
    cb({ ok = true })
end)

RegisterNUICallback("character:create", function(data, cb)
    TriggerNexusCallback("nexus:characters:create", data, function(result, errorCode)
        if errorCode or not result then
            cb({ ok = false, error = errorCode or "create_failed" })
            return
        end

        setUiVisible(false)
        TriggerServerEvent(NexusEvents.characterSelected, result.id)
        cb({ ok = true })
    end)
end)

RegisterNUICallback("character:select", function(data, cb)
    local characterId = tonumber(data.id)
    if not characterId then
        cb({ ok = false, error = "invalid_character" })
        return
    end

    setUiVisible(false)
    TriggerServerEvent(NexusEvents.characterSelected, characterId)
    cb({ ok = true })
end)

RegisterNUICallback("character:delete", function(data, cb)
    TriggerNexusCallback("nexus:characters:delete", { characterId = data.id }, function(result)
        if not result then
            cb({ ok = false, error = "delete_failed" })
            return
        end

        openCharacterUi()
        cb({ ok = true })
    end)
end)

RegisterCommand("characters", function()
    openCharacterUi()
end, false)

exports("OpenCharacterUi", openCharacterUi)

CreateThread(function()
    while true do
        if isCharacterUiOpen then
            SetNuiFocus(true, true)
            DisableAllControlActions(0)
            EnableControlAction(0, 245, true)
            EnableControlAction(0, 249, true)
            EnableControlAction(0, 250, true)
        end

        Wait(0)
    end
end)

CreateThread(function()
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    while not NetworkIsSessionStarted() do
        Wait(100)
    end

    Wait(500)
    openCharacterUi()
end)
