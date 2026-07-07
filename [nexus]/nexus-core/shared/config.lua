NexusConfig = {}

NexusConfig.Framework = {
    name = "Nexus Core",
    debug = true,
    defaultSpawn = vector4(-1037.72, -2737.88, 20.17, 329.56),
    maxCharacters = 4,
    defaultLocale = "nl",
    supportedLocales = { "nl", "en", "de", "fr" }
}

NexusConfig.Money = {
    defaultCash = 1500,
    defaultBank = 5000,
    defaultDirty = 0
}

NexusConfig.Permissions = {
    player = 0,
    staff = 1,
    admin = 2,
    owner = 3
}

NexusConfig.Jobs = {
    unemployed = {
        labelKey = "jobs.unemployed.label",
        defaultDuty = false,
        grades = {
            [0] = { labelKey = "jobs.unemployed.grade_0", paycheck = 75 }
        }
    },
    police = {
        labelKey = "jobs.police.label",
        defaultDuty = false,
        grades = {
            [0] = { labelKey = "jobs.police.grade_0", paycheck = 350 },
            [1] = { labelKey = "jobs.police.grade_1", paycheck = 450 },
            [2] = { labelKey = "jobs.police.grade_2", paycheck = 600 }
        }
    },
    ambulance = {
        labelKey = "jobs.ambulance.label",
        defaultDuty = false,
        grades = {
            [0] = { labelKey = "jobs.ambulance.grade_0", paycheck = 300 },
            [1] = { labelKey = "jobs.ambulance.grade_1", paycheck = 425 },
            [2] = { labelKey = "jobs.ambulance.grade_2", paycheck = 550 }
        }
    }
}

NexusConfig.Inventory = {
    maxSlots = 40,
    maxWeight = 50000
}

NexusConfig.Appearance = {
    defaultModelMale = "mp_m_freemode_01",
    defaultModelFemale = "mp_f_freemode_01",
    defaultComponents = {
        [1] = { drawable = 0, texture = 0, palette = 0 },
        [3] = { drawable = 15, texture = 0, palette = 0 },
        [4] = { drawable = 21, texture = 0, palette = 0 },
        [5] = { drawable = 0, texture = 0, palette = 0 },
        [6] = { drawable = 34, texture = 0, palette = 0 },
        [7] = { drawable = 0, texture = 0, palette = 0 },
        [8] = { drawable = 15, texture = 0, palette = 0 },
        [9] = { drawable = 0, texture = 0, palette = 0 },
        [10] = { drawable = 0, texture = 0, palette = 0 },
        [11] = { drawable = 15, texture = 0, palette = 0 }
    }
}

NexusConfig.Garages = {
    pillbox = {
        label = "Pillbox Garage",
        coords = vector4(213.7, -809.1, 30.73, 157.0),
        spawn = vector4(229.5, -800.1, 30.57, 157.0)
    },
    airport = {
        label = "Airport Garage",
        coords = vector4(-980.2, -2993.5, 13.95, 58.0),
        spawn = vector4(-964.4, -2999.2, 13.95, 58.0)
    }
}
