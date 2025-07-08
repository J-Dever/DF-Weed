-- Visual Functions: 3D text, markers, blip, props

local processingBench = nil
local showVisuals = true
local weedBlip = nil

function notify(type, message)
    local info = Config.Notifications[type]
    if not info then info = { icon = "ℹ️", color = "primary" } end

    TriggerEvent('QBCore:Notify', info.icon .. " " .. message, info.color)
end


-- 3D Text
function DrawText3D(coords, text, scale, font, offsetZ)
    scale = scale or 0.35
    font = font or 4
    offsetZ = offsetZ or 0.15

    SetTextScale(scale, scale)
    SetTextFont(font)
    SetTextProportional(1)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    SetDrawOrigin(coords.x, coords.y, coords.z + offsetZ, 0)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

-- General Marker Drawing
function drawMarker(location, markerConfig)
    DrawMarker(
        markerConfig.type,
        location.x, location.y, location.z - 1.0,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        markerConfig.scale.x, markerConfig.scale.y, markerConfig.scale.z,
        markerConfig.color[1], markerConfig.color[2], markerConfig.color[3], markerConfig.color[4],
        false, true, 2, nil, nil, false
    )
end

-- Specific for planting logic
function drawPlantingMarker(location)
    if not plantedPlants[location] then
        drawMarker(location, Config.Markers.PLANTING)
    else
        drawMarker(location, Config.Markers.HARVESTING)
    end
end

-- Custom progress bar
function showCustomProgressBar(label, duration)
    local startTime = GetGameTimer()
    local endTime = startTime + duration
    local barWidth = 0.2
    local barHeight = 0.035
    local xPos, yPos = 0.5, 0.88
    local segments = 5

    Citizen.CreateThread(function()
        while GetGameTimer() < endTime do
            local remainingTime = endTime - GetGameTimer()
            local progress = (duration - remainingTime) / duration

            DrawRect(xPos, yPos, barWidth + 0.008, barHeight + 0.012, 0, 0, 0, 200)
            DrawRect(xPos + barWidth / 2 + 0.015, yPos, 0.015, barHeight, 255, 255, 255, 200)

            local segmentWidth = barWidth / segments
            for i = 0, segments - 1 do
                local color = (i < math.floor(progress * segments)) and {0, 255, 0} or {100, 100, 100}
                DrawRect(xPos - barWidth / 2 + segmentWidth * i + segmentWidth / 2, yPos, segmentWidth - 0.004, barHeight, color[1], color[2], color[3], 200)
            end

            SetTextFont(4)
            SetTextProportional(1)
            SetTextScale(0.35, 0.35)
            SetTextColour(255, 255, 255, 255)
            SetTextCentre(true)
            SetTextEntry("STRING")
            AddTextComponentString(label)
            DrawText(xPos, yPos - 0.07)

            SetTextFont(4)
            SetTextScale(0.28, 0.28)
            SetTextCentre(false)
            SetTextEntry("STRING")
            AddTextComponentString(math.floor(progress * 100) .. "%")
            DrawText(xPos + barWidth / 2 + 0.03, yPos - 0.012)

            Citizen.Wait(0)
        end
    end)
end

-- Blip creation
function createWeedBlip()
    if weedBlip then return end
    weedBlip = AddBlipForCoord(208.42, -871.92, 31.5)
    SetBlipSprite(weedBlip, 496)
    SetBlipDisplay(weedBlip, 4)
    SetBlipScale(weedBlip, 0.9)
    SetBlipColour(weedBlip, 2)
    SetBlipAsShortRange(weedBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("Weed Grow Area")
    EndTextCommandSetBlipName(weedBlip)
end

-- Spawn processing bench
function createProcessingBench()
    local model = GetHashKey(Config.Models.Bench)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    processingBench = CreateObject(model, Config.Locations.ProcessingBench.x, Config.Locations.ProcessingBench.y, Config.Locations.ProcessingBench.z - 1.0, false, false, true)
    FreezeEntityPosition(processingBench, true)
end

-- Spawn joint-making bench
function createJointBench()
    local model = GetHashKey(Config.Models.JointBench)
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local bench = CreateObject(model, Config.Locations.JointBench.x, Config.Locations.JointBench.y, Config.Locations.JointBench.z - 1.0, false, false, true)
    FreezeEntityPosition(bench, true)
end

-- Spawn NPC
function createSellNPC()
    local model = GetHashKey("g_m_y_ballaorig_01")
    RequestModel(model)
    while not HasModelLoaded(model) do Citizen.Wait(0) end
    local npc = CreatePed(4, model, Config.Locations.SellNPC.coords.x, Config.Locations.SellNPC.coords.y, Config.Locations.SellNPC.coords.z - 1.0, Config.Locations.SellNPC.heading, false, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end
