NexusGangs = {
    none = {
        labelKey = "gangs.none.label",
        grades = {
            [0] = { labelKey = "gangs.none.grade_0" }
        }
    },
    ballas = {
        labelKey = "gangs.ballas.label",
        grades = {
            [0] = { labelKey = "gangs.ballas.grade_0", isboss = false },
            [1] = { labelKey = "gangs.ballas.grade_1", isboss = false },
            [2] = { labelKey = "gangs.ballas.grade_2", isboss = true }
        }
    },
    families = {
        labelKey = "gangs.families.label",
        grades = {
            [0] = { labelKey = "gangs.families.grade_0", isboss = false },
            [1] = { labelKey = "gangs.families.grade_1", isboss = false },
            [2] = { labelKey = "gangs.families.grade_2", isboss = true }
        }
    },
    vagos = {
        labelKey = "gangs.vagos.label",
        grades = {
            [0] = { labelKey = "gangs.vagos.grade_0", isboss = false },
            [1] = { labelKey = "gangs.vagos.grade_1", isboss = false },
            [2] = { labelKey = "gangs.vagos.grade_2", isboss = true }
        }
    }
}

function NexusShared.GetGangConfig(gangName)
    return NexusGangs[gangName] or NexusGangs.none
end
