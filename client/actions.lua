-- Actions: plant, harvest, process, roll joint, sell
local growthTime = Config.GrowthTime
local plantingModel = Config.Models.Planting
local harvestModel = Config.Models.Harvest
plantedPlants = {}

local function plantWeed(location)
    if plantedPlants[location] then
        notify("ERROR", "Location already occupied.")
        return
    end

    Config.Inventory.HasItem(Config.Items.SEED, function(result)
        if not result then
            notify("ERROR", "You don't have any weed seeds.")
            return
        end

        TriggerServerEvent('weed:removeItem', Config.Items.SEED, 1)
        local model = GetHashKey(plantingModel)
        RequestModel(model)
        while not HasModelLoaded(model) do Citizen.Wait(0) end

        local ped = PlayerPedId()
        TaskStartScenarioInPlace(ped, "world_human_gardener_plant", 0, true)
        Citizen.Wait(7000)
        ClearPedTasks(ped)

        local plant = CreateObject(model, location.x, location.y, location.z - 1.0, false, false, false)
        FreezeEntityPosition(plant, true)

        plantedPlants[location] = {
            obj = plant,
            plantedAt = GetGameTimer(),
            grown = false
        }

        notify("SUCCESS", "Weed planted.")
    end)
end

local function harvestWeed(location)
    local data = plantedPlants[location]
    if not data then return end

    DeleteObject(data.obj)
    plantedPlants[location] = nil

    TriggerServerEvent('weed:addItem', Config.Items.RAW, 1)
    notify("SUCCESS", "Weed harvested.")
end

local function processWeed()
    local ped = PlayerPedId()
    Config.Inventory.HasItem(Config.Items.RAW, function(result)
        if not result then
            notify("ERROR", "You don't have any weed to process.")
            return
        end

        TriggerServerEvent('weed:removeItem', Config.Items.RAW, 1)

        local dict = "mini@repair"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end
        TaskPlayAnim(ped, dict, "fixing_a_ped", 8.0, -8.0, Config.ProcessingTime, 1, 0, false, false, false)
        showCustomProgressBar("Processing Weed", Config.ProcessingTime)
        Citizen.Wait(Config.ProcessingTime)
        ClearPedTasks(ped)

        TriggerServerEvent('weed:addItem', Config.Items.PROCESSED, 1)
        notify("SUCCESS", "Weed processed.")
    end)
end

local function makeJoint()
    local ped = PlayerPedId()
    Config.Inventory.HasItem(Config.Items.PROCESSED, function(result)
        if not result then
            notify("ERROR", "You don't have processed weed.")
            return
        end

        TriggerServerEvent('weed:removeItem', Config.Items.PROCESSED, 1)

         local dict = "mini@repair"
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Citizen.Wait(0) end
        TaskPlayAnim(ped, dict, "fixing_a_ped", 8.0, -8.0, Config.ProcessingTime, 1, 0, false, false, false)
        showCustomProgressBar("Rolling Joint", Config.ProcessingTime)
        Citizen.Wait(Config.ProcessingTime)
        ClearPedTasks(ped)

        TriggerServerEvent('weed:addItem', Config.Items.JOINT, 1)
        notify("SUCCESS", "You rolled a joint.")
    end)
end

local function sellWeed()
    Config.Inventory.HasItem(Config.Items.PROCESSED, function(result)
        if not result then
            notify("ERROR", "You don't have processed weed to sell.")
            return
        end

        TriggerServerEvent('weed:removeItem', Config.Items.PROCESSED, 1)
        local amount = math.random(Config.SellingReward.min, Config.SellingReward.max)
        TriggerServerEvent('weed:addMoney', amount)
        notify("SUCCESS", "Sold weed for $" .. amount)
    end)
end

-- Optional: Main growth loop
local function runWeedLoop()
    local growLocations = Config.GrowLocations
    local harvestModel = Config.Models.Harvest

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5)
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)

            for _, loc in pairs(growLocations) do
                drawPlantingMarker(loc)

                -- Grow timer
                for plantLoc, plantData in pairs(plantedPlants) do
                    local elapsed = GetGameTimer() - plantData.plantedAt
                    if not plantData.grown and elapsed >= growthTime then
                        DeleteObject(plantData.obj)

                        local model = GetHashKey(harvestModel)
                        RequestModel(model)
                        while not HasModelLoaded(model) do Citizen.Wait(0) end

                        local obj = CreateObject(model, plantLoc.x, plantLoc.y, plantLoc.z - 1.0, false, false, false)
                        FreezeEntityPosition(obj, true)

                        plantData.obj = obj
                        plantData.grown = true
                    end
                end

                local distance = #(coords - loc)
                if distance <= 2.0 then
                    if not plantedPlants[loc] then
                        DrawText3D(loc, "Press [E] to Plant Weed Seed", 0.35, 4, 0.15)
                        if IsControlJustPressed(0, 38) and not isOnCooldown("PLANTING") then
                            plantWeed(loc)
                        end
                    elseif plantedPlants[loc].grown then
                        DrawText3D(loc, "Press [E] to Harvest Weed", 0.35, 4, 0.15)
                        if IsControlJustPressed(0, 38) and not isOnCooldown("HARVESTING") then
                            harvestWeed(loc)
                        end
                    else
                        DrawText3D(loc, "Weed is still growing...", 0.35, 4, 0.15)
                    end
                end
            end
        end
    end)
end
RegisterNetEvent("weed:runLoop")
AddEventHandler("weed:runLoop", function()
    runWeedLoop()
end)

_G.processWeed = processWeed
_G.makeJoint = makeJoint
_G.sellWeed = sellWeed

local lastUsed = {}

function isOnCooldown(action)
    local cooldown = Config.Cooldowns[action]
    if not cooldown then return false end

    local now = GetGameTimer()
    if lastUsed[action] and now - lastUsed[action] < cooldown then
        local remaining = math.ceil((cooldown - (now - lastUsed[action])) / 1000)
        notify("INFO", "Cooldown active (" .. remaining .. "s left)")
        return true
    end

    lastUsed[action] = now
    return false
end

