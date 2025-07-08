-- Target Zone Setup

-- Wait until the target system is ready
local function waitForTarget()
    while not exports['qb-target'] do
        print("[Weed Script] Waiting for qb-target to load...")
        Citizen.Wait(100)
    end
end


-- Processing Bench Zone
local function addProcessingZone()
    local sz = Config.ZoneSizes.Processing
    exports['qb-target']:AddBoxZone("weed_processing", Config.Locations.ProcessingBench, 1.5, 1.5, {
        name = "weed_processing",
        heading = 0,
        debugPoly = false,
        minZ = Config.Locations.ProcessingBench.z - 1.0,
        maxZ = Config.Locations.ProcessingBench.z + 1.5,
    }, {
        options = {
            {
                type = "client",
                event = "weed:client:processWeed",
                icon = "fas fa-cannabis",
                label = _L("process"),
            }
        },
        distance = 2.0
    })
end


-- Selling Zone
function reAddSellZone()
    local sz = Config.ZoneSizes.Selling
    exports['qb-target']:AddBoxZone("weed_selling", Config.Locations.SellNPC.coords, sz.length, sz.width, {
        name = "weed_selling",
        heading = Config.Locations.SellNPC.heading,
        debugPoly = false,
        minZ = Config.Locations.SellNPC.coords.z - 1.0,
        maxZ = Config.Locations.SellNPC.coords.z + 1.0,
    }, {
        options = {
            {
                type = "client",
                event = "weed:client:sellWeed",
                icon = "fas fa-money-bill-wave",
                label = _L("sell"),
            }
        },
        distance = 2.0
    })
end

-- Joint Rolling Zone
local function addJointZone()
    local sz = Config.ZoneSizes.Joint
    exports['qb-target']:AddBoxZone("weed_jointmaking", Config.Locations.JointBench, sz.length, sz.width, {
        name = "weed_jointmaking",
        heading = 0,
        debugPoly = false,
        minZ = Config.Locations.JointBench.z - 1.0,
        maxZ = Config.Locations.JointBench.z + 1.5,
    }, {
        options = {
            {
                type = "client",
                event = "weed:client:makeJoint",
                icon = "fas fa-smoking",
                label = _L("roll_joint"),
            }
        },
        distance = 2.0
    })
end

-- Public setup call
function setupTargetZones()
    Citizen.CreateThread(function()
        waitForTarget()
        addProcessingZone()
        reAddSellZone()
        addJointZone()
    end)
end
