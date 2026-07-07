NexusItems = {
    water = {
        labelKey = "items.water",
        weight = 500,
        stack = true,
        useable = true,
        description = "Fless water"
    },
    sandwich = {
        labelKey = "items.sandwich",
        weight = 750,
        stack = true,
        useable = true
    },
    bandage = {
        labelKey = "items.bandage",
        weight = 300,
        stack = true,
        useable = true
    },
    phone = {
        labelKey = "items.phone",
        weight = 1000,
        stack = false,
        useable = true
    },
    lockpick = {
        labelKey = "items.lockpick",
        weight = 250,
        stack = true,
        useable = true
    },
    weed = {
        labelKey = "items.weed",
        weight = 50,
        stack = true
    },
    coke = {
        labelKey = "items.coke",
        weight = 50,
        stack = true
    },
    evidence_bag = {
        labelKey = "items.evidence_bag",
        weight = 200,
        stack = true
    },
    id_card = {
        labelKey = "items.id_card",
        weight = 0,
        stack = false,
        useable = true
    },
    driver_license = {
        labelKey = "items.driver_license",
        weight = 0,
        stack = false,
        useable = true
    }
}

function NexusShared.GetItem(itemName)
    return NexusItems[itemName]
end

function NexusShared.GetItemLabel(itemName, locale)
    local item = NexusItems[itemName]
    if not item then
        return itemName
    end

    if item.labelKey then
        return NexusTranslate(locale or NexusConfig.Framework.defaultLocale, item.labelKey)
    end

    return item.label or itemName
end
