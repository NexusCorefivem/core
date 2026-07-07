local clothingUiOpen = false
local currentAppearance = nil

local function setClothingUi(visible, payload)
    clothingUiOpen = visible
    SetNuiFocus(visible, visible)
    SendNUIMessage({
        action = visible and "open" or "close",
        payload = payload or {}
    })
end

local function applyAppearance(data)
    if type(data) ~= "table" then
        return
    end

    currentAppearance = data
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

    for componentId, componentData in pairs(data.components or {}) do
        local index = tonumber(componentId)
        if index and type(componentData) == "table" then
            SetPedComponentVariation(ped, index, tonumber(componentData.drawable) or 0, tonumber(componentData.texture) or 0, tonumber(componentData.palette) or 0)
        end
    end

    for propId, propData in pairs(data.props or {}) do
        local index = tonumber(propId)
        if index and type(propData) == "table" then
            if (tonumber(propData.drawable) or -1) >= 0 then
                SetPedPropIndex(ped, index, tonumber(propData.drawable) or 0, tonumber(propData.texture) or 0, true)
            else
                ClearPedProp(ped, index)
            end
        end
    end
end

RegisterNetEvent(NexusEvents.playerLoaded, function(playerData)
    if playerData.appearance then
        currentAppearance = playerData.appearance
        applyAppearance(playerData.appearance)
    end
end)

RegisterNUICallback("appearance:close", function(_, cb)
    setClothingUi(false)
    cb({ ok = true })
end)

RegisterNUICallback("appearance:preview", function(data, cb)
    applyAppearance(data)
    cb({ ok = true })
end)

RegisterNUICallback("appearance:save", function(data, cb)
    TriggerNexusCallback("nexus:clothing:saveAppearance", data, function(result)
        if result then
            currentAppearance = data
            setClothingUi(false)
        end
        cb({ ok = result == true })
    end)
end)

RegisterCommand("appearance", function()
    TriggerNexusCallback("nexus:clothing:getAppearance", {}, function(appearance)
        currentAppearance = appearance or {
            model = NexusConfig.Appearance.defaultModelMale,
            components = NexusShared.DeepCopy(NexusConfig.Appearance.defaultComponents),
            props = {}
        }
        setClothingUi(true, { appearance = currentAppearance })
    end)
end, false)
