Config = {}

Config.UseTokens = false

Config.Cooldown = 1 --- Cooldown until next allowed meth run
Config.DefaultValues = {
    armor = 10,
    accuracy = 40,
}

Config.DropoffLocations = {
    vector4(447.17, 3523.33, 33.21, 20),
    vector4(202.23, 2456.97, 55.71, 20),
    vector4(1901.19, 4918.38, 48.71, 158.37),
    vector4(2906.07, 4343.47, 50.3, 252.46),
    vector4(278.51, -1740.11, 29.38, 137.99),
    vector4(1091.85, -789.64, 58.26, 175.75),
    vector4(475.37, -1329.48, 29.12, 31.79)
    
}

Config.Boss = {
    coords = vector4(-194.01, 6250.71, 31.49, 316.8),
    model = 's_m_y_xmech_02',
    missionTitle = "Accept ElegyRetro theft job",
    animation = 'CODE_HUMAN_MEDIC_KNEEL', -- OPTIONAL https://pastebin.com/6mrYTdQv
}

local locations = {
    lafuenta = {
        Guards = {
            { model = 'g_m_y_mexgang_01', weapon = 'weapon_pistol' },
            { model = 'g_m_y_mexgang_01', weapon = 'weapon_pistol' },
        },
        GuardPositions = {
            vector4(1381.07, 1149.81, 114.33, 87.54),
            vector4(1386.84, 1126.88, 114.33, 89.23),
            vector4(1414.17, 1138.47, 114.33, 278.73)
        },
        Civilians = {
            { model = 's_m_m_marine_02', animation = 'WORLD_HUMAN_BINOCULARS' }
        },
        CivilianPositions = {
            vector4(1415.4, 1161.45, 114.67, 3.26)
        },
        GuardCars = { 
            { model = 'baller4', coords = vector4(1335.64, 1137.98, 110.81, 99.93) },
            { model = 'baller4', coords = vector4(1337.75, 1149.41, 112.36, 167.32) }
         },
        VehiclePosition = vector4(1410.11, 1117.26, 114.48, 91.92)
    },
    lakevinewood = {
        Guards = {
            { model = 'g_m_y_armgoon_02', weapon = 'weapon_pistol' },
            { model = 'g_m_y_armgoon_02', weapon = 'weapon_pistol' },
            { model = 'g_m_y_armgoon_02', weapon = 'weapon_machinepistol', accuracy = 5 },
        },
        GuardPositions = {
            vector4(-113.27, 983.92, 235.76, 108.41),
            vector4(-105.51, 974.53, 235.76, 200.63),
            vector4(-102.46, 975.78, 235.76, 199.94),
            vector4(-91.7, 944.77, 233.03, 338.29),
            vector4(-83.68, 944.54, 233.03, 40.37),
            vector4(-103.18, 1011.38, 235.76, 103.97),
            vector4(-97.14, 1017.25, 235.82, 289.04)
        },
        Civilians = {
            { model = 'a_m_o_genstreet_01', animation = 'WORLD_HUMAN_PARTYING' }
        },
        CivilianPositions = {
            vector4(-122.49, 1008.29, 235.73, 114.33)
        },
        GuardCars = { 
            { model = 'landstalker2', coords = vector4(-136.02, 977.28, 235.27, 219.36) },
            { model = 'landstalker2', coords = vector4(-129.89, 978.94, 235.25, 147.02) },
            { model = 'entityxf', coords = vector4(-123.52, 1007.19, 235.13, 200.9) }
         },
        VehiclePosition = vector4(-130.68, 1005.67, 235.13, 197.34)
    },
    lakevinewood2 = {
        Guards = {
            { model = 'mp_m_securoguard_01', weapon = 'weapon_pistol' },
            { model = 'mp_m_securoguard_01', weapon = 'weapon_pistol' },
        },
        GuardPositions = {
            vector4(-135.76, 899.35, 235.66, 283.48),
            vector4(-139.0, 881.63, 233.48, 133.12),
            vector4(-160.7, 925.8, 239.94, 291.47)
        },
        Civilians = {
            { model = 'a_f_y_beach_01', animation = 'WORLD_HUMAN_DRINKING' }
        },
        CivilianPositions = {
            vector4(-161.97, 880.79, 237.14, 161.28)
        },
        GuardCars = { 
            { model = 'baller4', coords = vector4(-141.67, 910.2, 235.8, 243.79) },
            { model = 'granger', coords = vector4(-120.49, 910.81, 235.43, 19.1) }
         },
        VehiclePosition = vector4(-167.6, 918.7, 234.99, 316.02)
    },
    burroHeights = {
        Guards = {
            { model = 'a_m_m_soucent_01', weapon = 'weapon_pistol' },
            { model = 'g_m_m_armlieut_01', weapon = 'weapon_pistol' },
            { model = 'g_m_importexport_01', weapon = 'weapon_machinepistol', accuracy = 5 },
        },
        GuardPositions = {
            vector4(1455.68, -2592.61, 48.63, 308.67),
            vector4(1437.89, -2587.03, 48.11, 105.84),
            vector4(1425.79, -2581.05, 47.98, 23.34),
            vector4(1437.89, -2591.51, 48.13, 67.2),
        },
        Civilians = {
            { model = 'a_f_y_soucent_02', animation = 'WORLD_HUMAN_AA_COFFEE' },
            { model = 'a_m_m_beach_01', animation = 'WORLD_HUMAN_AA_COFFEE' },
            { model = 'g_m_m_korboss_01', animation = 'WORLD_HUMAN_DRINKING' },
            { model = 'a_f_y_soucent_03', animation = 'WORLD_HUMAN_STAND_MOBILE' },
            { model = 's_m_y_strvend_01', animation = 'WORLD_HUMAN_STAND_MOBILE' },
            { model = 'mp_m_weapexp_01', animation = 'WORLD_HUMAN_AA_SMOKE' },
            { model = 'a_m_y_smartcaspat_01', animation = 'WORLD_HUMAN_LEANING', coords = vector4(1450.54, -2622.54, 48.68, 339.93)},
        },
        CivilianPositions = {
            vector4(1450.23, -2615.93, 48.48, 351.78),
            vector4(1450.61, -2613.47, 48.47, 169.65),
            vector4(1447.17, -2606.22, 48.35, 90.46),
            vector4(1445.33, -2606.25, 48.32, 268.93),
            vector4(1436.39, -2613.77, 48.21, 184.89),
            vector4(1436.69, -2615.56, 48.22, 2.8),
        },
        GuardCars = { 
            { model = 'dominator8', coords = vector4(1440.42, -2610.3, 48.26, 167.29) },
            { model = 'rapidgt3', coords = vector4(1443.48, -2612.07, 48.32, 164.42) },
            { model = 'landstalker2', coords = vector4(1454.43, -2600.34, 48.46, 18.42) },
            { model = 'cavalcade', coords = vector4(1448.66, -2589.8, 48.27, 58.67) },
            { model = 'burrito', coords = vector4(1441.72, -2593.62, 48.0, 86.87) },
            { model = 'sultan', coords = vector4(1434.61, -2605.74, 47.96, 325.5) },
            { model = 'elegy2', coords = vector4(1433.41, -2593.35, 48.09, 137.91) },
            { model = 'jb7002', coords = vector4(1453.71, -2614.1, 48.53, 163.54) }
         },
        VehiclePosition = vector4(1446.97, -2612.22, 48.39, 164.47)
    },
    sandyDesert = {
        Guards = {
            { model = 'a_m_m_soucent_01', weapon = 'weapon_pistol', },
            { model = 'g_m_m_armlieut_01', weapon = 'weapon_pistol' },
            { model = 'g_m_importexport_01', weapon = 'weapon_machinepistol', accuracy = 5 },
        },
        GuardPositions = {
            vector4(2470.31, 3451.51, 49.83, 30.78),
            vector4(2486.22, 3444.64, 51.07, 238.82),
            vector4(2485.66, 3447.15, 51.07, 10.14),
            vector4(2482.66, 3447.78, 51.07, 108.97),
            vector4(2483.65, 3446.7, 51.07, 223.21),
            vector4(2486.95, 3446.1, 51.07, 271.15),
            vector4(2485.78, 3447.61, 51.07, 330.24),
            vector4(2483.16, 3449.77, 51.07, 43.09),
            vector4(2483.91, 3448.53, 51.07, 217.75)
        },
        GuardCars = { 
            { model = 'ratloader', coords = vector4(2464.06, 3447.82, 49.77, 27.66) },
            { model = 'dune', coords = vector4(2459.66, 3449.5, 49.02, 229.02) }
         },
        VehiclePosition = vector4(2481.28, 3437.69, 49.32 , 225.1)
    },
}
-- ElegyRetro job

local ElegyRetroJob = {
    Model = 'elegy',
    token = 'boostelegyr',
    RunCost = 1000,
    Timer = 30000,
    MissionDescription = "Elegy Retro",
    Messages = {
        First = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "I marked the car n shit "
        },
        Second = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "You got the Elegy? Nice.. I'll send you the gps coordinates for the delivery spot once it's safe. If you bring cops you're done."
        },
        Third = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "Tight. Enjoy the papers."
        }
    },
    MinimumPolice = 0,
    Locations = {
        locations.lafuenta,
        locations.lakevinewood
    }
}

local SultanRSJob = {
    Model = 'sultanrs',
    token = 'boostsultanrs',
    RunCost = 1000,
    Timer = 20000,
    MissionDescription = "Sultan RS",
    Messages = {
        First = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "I marked the car n shit "
        },
        Second = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "You got the car? Wicked.. I'll send you the gps coordinates for the delivery spot once it's safe. If you bring cops you're done."
        },
        Third = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "Tight. Enjoy the papers."
        }
    },
    MinimumPolice = 0,
    Locations = {
        --locations.lafuenta,
        locations.lakevinewood,
        locations.burroHeights
    }
}

local BansheeJob = {
    Model = 'banshee2',
    token = 'boostbanshee',
    RunCost = 1000,
    Timer = 20000,
    MissionDescription = "Banshee 900R",
    Messages = {
        First = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "I marked the car n shit "
        },
        Second = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "You got the Banshee? When it's safe I'll drop you the location of where to leave it. If you bring cops you're done."
        },
        Third = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "Tight. Enjoy the papers."
        }
    },
    MinimumPolice = 0,
    Locations = {
        locations.lafuenta,
        locations.lakevinewood,
        locations.lakevinewood2
    }
}

local VoodooJob = {
    Model = 'voodoo',
    token = 'boostvoodoo',
    RunCost = 1000,
    Timer = 20000,
    MissionDescription = "Voodoo Custom",
    Messages = {
        First = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "I marked the car n shit "
        },
        Second = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "You got the Voodoo?? When it's safe I'll drop you the location of where to leave it. If you bring cops you're done."
        },
        Third = {
            Sender = 'Hector',
            Subject = 'Stuff',
            Message = "Tight. Enjoy the papers."
        }
    },
    MinimumPolice = 0,
    Locations = {
        locations.sandyDesert
    }
}

Config.Jobs = {
    ['ElegyRetroJob'] = ElegyRetroJob,
    ['SultanRSJob'] = SultanRSJob,
    ['BansheeJob'] = BansheeJob,
    ['VoodooJob'] = VoodooJob
}