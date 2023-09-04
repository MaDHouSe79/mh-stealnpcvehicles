--[[ ===================================================== ]]--
--[[        MH Steel Npc Vehicles Script by MaDHouSe       ]]--
--[[ ===================================================== ]]--

Config = {}

Config.CheckForUpdates = true

-- a cooldown timer, so players can't use it the hole time. make sure you add at least more than 3600 
-- (3600 * 60) = 1 min, (230000 * 60) = 1 hour
Config.CoolDownTime = 230000 -- 1 min

Config.DebugPoly = false
Config.DestroyTime = 10000
Config.MinDamage = 950.0
Config.InteractDistance = 1.5

Config.UsePayment = true
Config.FuelPrice = 2 -- count per liter

-- if you use mh-hunters
Config.UseHunters = false
Config.HunterDelay = 25000
Config.AlertCooldown = 10000 -- 10 seconds

-- Items that you get after material scrap
Config.MinItems = 50  -- min total of an item you get returned
Config.MaxItems = 100 -- max total of an item you get returned
Config.ScrapItems = {"metalscrap", "plastic", "copper", "iron", "aluminum", "steel", "glass", "electric_scrap"}
Config.CarItems = {"axleparts", "brakes1", "bumper", "carbattery", "door", "engine1", "exhaust", "headlights", "hood", "roof", "seat", "skirts", "sparkplugs", "spoiler", "stockrim", "suspension1", "tire", "transmission1", "trunk", "turbo", "ducttape"}

-- Needed items to be able to steal or scrap a npc vehicle
Config.NeededItems = {                             
    [1] = {name = "screwdriverset", needed = 1},   -- basic item (does not remove from inventory)
    [2] = {name = "oxycutter", needed = 1},        -- basic item (does not remove from inventory)
    [3] = {name = "oxygen-tank", needed = 1},      -- basic item (does not remove from inventory)
}

-- This jobs will be ignored
Config.IgnoreJobs = {
    ["police"] = true,    -- true is ignore
    ["ambulance"] = true, -- true is ignore
    ["mechanic"] = true,  -- true is ignore
}

Config.JobVehicle = {
    plate = "NPC-C-"..math.random(10, 99),
    model = "flatbed",
    offset = {
        x = -0.5,--[[left/right]] 
        y = -5.0,--[[front/back]] 
        z = 0.90, --[[up/down]]
    },
}

Config.Zones = {
    [1] = {
        -- Vehicle spawn location and heading
        flatbed = { 
            coords = vector3(748.37, -1856.85, 29.38),
            heading = 85.49,
            ground = 0.7,
        },
        -- Location
        coords = vector3(758.4, -1865.72, 29.29), 
        -- Blip
        blip = { 
            show = false,
            label = "NPC Vehicle Scrap",
            sprite = 779,
            color = 3,
            coords = vector3(758.4, -1865.72, 29.29), -- location on the map
        },
        -- Scrap zone
        zone = { 
            name = 'scrap',
            vectors = {
                vector2(754.38610839844, -1867.9006347656),
                vector2(754.82879638672, -1862.8385009766),
                vector2(761.60571289062, -1863.3713378906),
                vector2(761.92034912109, -1868.76953125),
            },
            minZ = 26.293897628784,
            maxZ = 32.293897628784,
        }
    },
    
    [2] = {
        -- Vehicle spawn location and heading
        flatbed = { 
            coords = vector3(-23.11, -1438.88, 30.77),
            heading = 180.54,
            ground = 0.7,
        },
        -- Location
        coords = vector3(-25.3, -1427.43, 30.25), 
        -- Blip
        blip = { 
            show = false,
            label = "NPC Vehicle Scrap",
            sprite = 779,
            color = 3,
            coords = vector3(-25.3, -1427.43, 30.25), -- location on the map
        },
        -- Scrap zone
        zone = { 
            name = 'scrap',
            vectors = {
                vector2(-27.669397354126, -1425.0523681641),
                vector2(-23.001403808594, -1424.9895019531),
                vector2(-22.952098846436, -1430.5535888672),
                vector2(-27.661270141602, -1430.615234375),
            },
            minZ = 27.681180953979,
            maxZ = 33.681180953979,
        }
    }
}

Config.Drops = {
    -- random
    [1] = {
        coords = vector4(505.67, -3386.3, 6.16, 359.76),     -- drop location
        drop = vector4(506.99, -3400.11, 8.27, 1.5),         -- drop location of the stolen vehicle (water)
        heading = 359.76,                                    -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    [2] = {
        coords = vector4(3863.55, 4463.73, 2.81, 90.0),      -- drop location
        drop = vector4(3885.77, 4463.8, 4.07, 98.41),        -- drop location of the stolen vehicle (water)
        heading = 90.0,                                      -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    [3] = {
        coords = vector4(1620.01, 6660.38, 23.33, 202.8390), -- drop location
        drop = vector4(1610.96, 6688.32, 22.75, 193.25),     -- drop location for the stolen vehicle (water)
        heading = 202.8390,                                  -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    -- Havens
    [4] = {
        coords = vector4(1294.95, -3066.22, 6.02, 134.54),   -- drop location
        drop = vector4(1312.02, -3049.63, 6.13, 130.33),     -- drop location for the stolen vehicle (water)
        heading = 134.54,                                    -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    [5] = {
        coords = vector4(236.28, -3339.44, 5.95, 0.26),      -- drop location
        drop = vector4(235.99, -3360.46, 6.3, 359.16),       -- drop location for the stolen vehicle (water)
        heading = 0.26,                                      -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    [6] = {
        coords = vector4(-784.47, -1476.65, 5.09, 290.34),   -- drop location
        drop = vector4(-797.79, -1482.14, 4.87, 288.8),      -- drop location for the stolen vehicle (water)
        heading = 290.34,                                    -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    -- Pier
    [7] = {
        coords = vector4(-1829.48, -1161.54, 13.13, 229.53), -- drop location
        drop = vector4(-1840.32, -1152.18, 13.09, 226.15),   -- drop location for the stolen vehicle (water)
        heading = 229.53,                                    -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    [8] = {
        coords = vector4(-1787.39, -1196.5, 13.1, 49.69),    -- drop location
        drop = vector4(-1774.67, -1206.85, 13.54, 48.73),    -- drop location for the stolen vehicle (water)
        heading = 49.69,                                     -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    -- more random
    [9] = {
        coords = vector4(-1515.96, 5200.08, 26.23, 259.53),  -- drop location
        drop = vector4(-1531.0, 5202.46, 25.63, 254.02),     -- drop location for the stolen vehicle (water)
        heading = 259.53,                                    -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
    [10] = {
        coords = vector4(-902.67, 6044.15, 43.48, 232.55),   -- drop location
        drop = vector4(-914.86, 6053.38, 46.61, 228.76),     -- drop location for the stolen vehicle (water)
        heading = 232.55,                                    -- drop location heading
        ground = 0.7,                                        -- drop location ground
    },
}

-- vehicle classes that will ignored.
Config.IgnoreVehicleClasses = {                    
    --0, --Compacts  
    --1, --Sedans  
    --2, --SUVs  
    --3, --Coupes  
    --4, --Muscle  
    --5, --Sports Classics  
    --6, --Sports  
    --7, --Super  
    8, --Motorcycles  
    --9, --Off-road  
    10, --Industrial  
    11, --Utility
    --12, --Vans  
    13, --Cycles 
    14, --Boats  
    15, --Helicopters  
    16, --Planes  
    17, --Service  
    18, --Emergency  
    19, --Military  
    20, --Commercial  
    21, --Trains  
    22, --Open Wheel
}
