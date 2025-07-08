Config = {}

Config.Inventory = 'auto' --- this works
--Config.ThirdEye = 'auto' --- does not work


-- Growth time in milliseconds
Config.GrowthTime = 30000

-- Dynamic Grow Locations
Config.GrowLocations = {
    vector3(205.67, -872.95, 31.5),
    vector3(208.67, -874.95, 31.5)
}

-- Marker settings
Config.Markers = {
    PLANTING = {
        type = 1,
        scale = vector3(1.0, 1.0, 1.0),
        color = {0, 255, 0, 150}
    },
    HARVESTING = {
        type = 1,
        scale = vector3(1.0, 1.0, 1.0),
        color = {255, 255, 0, 150}
    },
    PROCESSING = {
        type = 1,
        scale = vector3(1.0, 1.0, 1.0),
        color = {0, 0, 255, 150}
    },
    SELLING = {
        type = 1,
        scale = vector3(1.0, 1.0, 1.0),
        color = {255, 0, 0, 150}
    }
}

-- locations
Config.Locations = {
    ProcessingBench = vector3(215.58, -895.79, 30.69),
    JointBench = vector3(217.12, -899.49, 30.69), -- You can change this location
    SellNPC = {
        coords = vector3(217.43, -875.49, 30.49),
        heading = 280.0
    }
}

Config.ZoneSizes = {
    Processing = { length = 1.5, width = 1.5 },
    Selling = { length = 1.5, width = 1.5 },
    Joint = { length = 1.5, width = 1.5 }
}


-- Item names
Config.Items = {
    SEED = "weed_seeds",
    RAW = "weed",
    PROCESSED = "processed_weed",
    JOINT = "joint"
}

-- Cooldown settings (milliseconds)
Config.Cooldowns = {
    PLANTING = 10000,
    HARVESTING = 5000
}

-- Notification settings
Config.Notifications = {
    SUCCESS = { icon = "✅", color = "success" },
    ERROR = { icon = "❌", color = "error" },
    INFO = { icon = "ℹ️", color = "primary" } -- 'primary' or 'info' depending on your QBCore Notify settings
}
-- Processing time in milliseconds
Config.ProcessingTime = 10000

-- Selling reward range
Config.SellingReward = {
    min = 150,
    max = 300
}

-- Models used in the system
Config.Models = {
    Planting = "prop_weed_02",
    Harvest = "prop_weed_01",
    Bench = "prop_tool_bench02",
    JointBench = "prop_tool_bench02"
}
