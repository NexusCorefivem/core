NexusConfig.Shops = {
    twentyfourseven_1 = {
        label = "24/7",
        coords = vector3(25.74, -1347.32, 29.50),
        radius = 2.5,
        items = {
            { name = "water", price = 5 },
            { name = "sandwich", price = 10 },
            { name = "bandage", price = 25 },
            { name = "phone", price = 500 }
        }
    },
    liquorshop = {
        label = "Liquor Store",
        coords = vector3(1135.66, -982.76, 46.42),
        radius = 2.5,
        items = {
            { name = "water", price = 4 },
            { name = "sandwich", price = 8 }
        }
    }
}

NexusConfig.Fuel = {
    consumptionRate = 0.08,
    stations = {
        { label = "Gas Station", coords = vector3(49.42, 2778.79, 58.04), radius = 6.0 },
        { label = "Gas Station", coords = vector3(263.89, -1261.30, 29.29), radius = 6.0 }
    },
    refuelCostPerLiter = 2,
    maxFuel = 100.0
}

NexusConfig.Banking = {
    atms = {
        vector3(147.44, -1035.74, 29.34),
        vector3(-386.73, 6045.95, 31.50),
        vector3(-3040.72, 593.11, 7.91)
    },
    atmRadius = 1.5
}

NexusConfig.CraftingStations = {
    main = {
        coords = vector3(1087.42, -2001.92, 30.88),
        radius = 3.0
    }
}

NexusConfig.Crafting = {
    bandage = {
        labelKey = "crafting.bandage",
        station = "main",
        requires = { water = 1 },
        gives = { bandage = 1 }
    },
    lockpick = {
        labelKey = "crafting.lockpick",
        station = "main",
        requires = { water = 2 },
        gives = { lockpick = 1 }
    }
}

NexusConfig.Housing = {
    grove_st_1 = {
        label = "Grove St House",
        coords = vector3(125.93, -1929.86, 21.38),
        radius = 2.5,
        price = 75000,
        interior = vector4(151.37, -1007.87, -99.00, 0.0)
    },
    mirror_park_1 = {
        label = "Mirror Park Apt",
        coords = vector3(1220.48, -725.84, 60.80),
        radius = 2.5,
        price = 95000,
        interior = vector4(151.37, -1007.87, -99.00, 180.0)
    }
}

NexusConfig.Businesses = {
    burgershot = {
        label = "Burger Shot",
        coords = vector3(-1193.15, -894.13, 13.99),
        radius = 2.5,
        payout = 150,
        ownerPrice = 25000
    }
}

NexusConfig.Robberies = {
    store_1 = {
        label = "Store Robbery",
        coords = vector3(28.29, -1339.14, 29.50),
        radius = 3.0,
        reward = { min = 500, max = 2500 },
        cooldown = 30 * 60000
    }
}

NexusConfig.Heists = {
    jewelry = {
        label = "Jewelry Heist",
        coords = vector3(-622.25, -230.74, 38.06),
        radius = 5.0,
        reward = { min = 5000, max = 15000 },
        cooldown = 60 * 60000,
        requiredItem = "lockpick"
    }
}

NexusConfig.Blackmarket = {
    alley = {
        label = "Black Market",
        coords = vector3(892.35, -2172.77, 32.29),
        radius = 2.5,
        items = {
            { name = "lockpick", price = 250, account = "dirty" },
            { name = "weed", price = 100, account = "dirty" }
        }
    }
}

NexusConfig.Laundering = {
    spot = {
        label = "Money Laundering",
        coords = vector3(1122.35, -3194.62, -40.40),
        radius = 2.5,
        fee = 0.15
    }
}

NexusConfig.Drugs = {
    weed_field = {
        label = "Weed Field",
        coords = vector3(2224.22, 5577.03, 53.85),
        radius = 8.0,
        item = "weed",
        amount = { min = 1, max = 3 },
        cooldown = 60000
    }
}

NexusConfig.Gangs = {
    families = { label = "Families" },
    ballas = { label = "Ballas" },
    vagos = { label = "Vagos" }
}

NexusConfig.Jail = {
    coords = vector4(1691.38, 2565.96, 45.56, 270.0),
    releaseCoords = vector4(1847.91, 2586.26, 45.67, 270.0)
}

NexusConfig.Police = {
    cuffDistance = 2.5,
    fineMax = 10000
}

NexusConfig.Ambulance = {
    healAmount = 50,
    reviveDistance = 3.0
}

NexusConfig.Interactions = {
    bench = {
        label = "Sit",
        coords = vector3(-1037.72, -2737.88, 20.17),
        radius = 2.0,
        scenario = "PROP_HUMAN_SEAT_BENCH"
    }
}

NexusConfig.CityHall = {
    coords = vector3(-551.38, -202.35, 38.22),
    radius = 2.5,
    idPrice = 50,
    licensePrice = 250
}

NexusConfig.Customs = {
    bennys = {
        label = "Benny's Customs",
        coords = vector3(-212.55, -1324.55, 30.89),
        radius = 8.0,
        repairPrice = 500,
        tunePrice = 1500
    },
    lsc = {
        label = "Los Santos Customs",
        coords = vector3(-337.38, -136.92, 39.01),
        radius = 8.0,
        repairPrice = 750,
        tunePrice = 2000
    }
}

NexusConfig.Carwash = {
    strawberry = {
        label = "Carwash",
        coords = vector3(25.29, -1391.96, 29.36),
        radius = 6.0,
        price = 50
    }
}

NexusConfig.Dealership = {
    pdm = {
        label = "Premium Deluxe Motorsport",
        coords = vector3(-56.79, -1096.63, 26.42),
        radius = 3.0,
        spawn = vector4(-31.12, -1090.79, 26.42, 340.0),
        vehicles = {
            { model = "blista", price = 12000 },
            { model = "asea", price = 9000 },
            { model = "sultan", price = 35000 },
            { model = "buffalo", price = 42000 }
        }
    }
}

NexusConfig.JobLocations = {
    taxi = {
        depot = { label = "Taxi Depot", coords = vector3(909.5, -177.35, 74.22), radius = 3.0 },
        fareMin = 75,
        fareMax = 250
    },
    bus = {
        depot = { label = "Bus Depot", coords = vector3(462.02, -605.83, 28.50), radius = 3.0 },
        stops = {
            vector3(304.36, -764.56, 29.31),
            vector3(114.31, -784.07, 31.41),
            vector3(-505.84, 23.00, 44.78)
        },
        payoutPerStop = 100
    },
    trucker = {
        depot = { label = "Trucker Depot", coords = vector3(1240.83, -3257.43, 5.53), radius = 4.0 },
        delivery = { label = "Delivery Point", coords = vector3(89.89, 6360.29, 31.23), radius = 6.0 },
        payout = 500
    },
    garbage = {
        depot = { label = "Garbage Depot", coords = vector3(-322.25, -1545.87, 31.02), radius = 4.0 },
        route = {
            vector3(-168.07, -1662.02, 33.31),
            vector3(117.06, -1463.47, 29.30),
            vector3(295.53, -201.78, 61.57)
        },
        payoutPerStop = 80
    },
    mechanic = {
        shop = { label = "Mechanic Shop", coords = vector3(-347.29, -133.37, 39.01), radius = 4.0 },
        repairPayout = 150
    }
}

NexusConfig.Management = {
    police = { coords = vector3(447.87, -973.38, 30.69), radius = 2.0, minGrade = 2 },
    ambulance = { coords = vector3(311.21, -599.36, 43.29), radius = 2.0, minGrade = 2 },
    mechanic = { coords = vector3(-347.29, -133.37, 39.01), radius = 2.0, minGrade = 1 }
}

NexusConfig.Radial = {
    key = "F1",
    categories = {
        general = { "inventory", "phone", "id", "emotes" },
        vehicle = { "engine", "lock", "trunk" },
        job = { "duty" }
    }
}

NexusConfig.SmallResources = {
    seatbeltKey = "B",
    handsupKey = "X",
    pointKey = "Y"
}
