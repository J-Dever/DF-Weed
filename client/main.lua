QBCore = exports['qb-core']:GetCoreObject()

-- Flags & Data
local showVisuals = true
local weedBlip = nil
local plantedPlants = {}

if Config.ThirdEye == 'qb-target' then
    local targetExport = exports['qb-target']
    if targetExport and targetExport.AddBoxZone then
        Config.ThirdEye = targetExport
        print("[Weed Script] Auto-detected qb-target.")
    else
        print("[Weed Script] Failed to detect qb-target export.")
    end
end

-- Load modules
local function initWeedScript()
    createProcessingBench()
    createSellNPC()
    createJointBench()
    setupTargetZones()
    if showVisuals then
        createWeedBlip()
    end
end

-- Toggle markers & blip
RegisterCommand("toggleweed", function()
    showVisuals = not showVisuals
    if showVisuals then
        notify("INFO", "Weed markers and blip enabled.")
        createWeedBlip()
    else
        notify("INFO", "Weed markers and blip disabled.")
        if DoesBlipExist(weedBlip) then
            RemoveBlip(weedBlip)
            weedBlip = nil
        end
    end
end, false)

-- Register events
RegisterNetEvent("weed:client:processWeed", function()
    if isProcessing then return end
    isProcessing = true
    processWeed()
    SetTimeout(3000, function() isProcessing = false end)
end)

RegisterNetEvent("weed:client:sellWeed", function()
    if isSelling then return end
    isSelling = true
    exports['qb-target']:RemoveZone("weed_selling")
    sellWeed()
    SetTimeout(3000, function()
        isSelling = false
        reAddSellZone() -- from targets.lua
    end)
end)
RegisterNetEvent("weed:client:makeJoint", function()
    if isProcessing then return end
    isProcessing = true

    makeJoint() -- ⛔ This causes an error because makeJoint is not in scope

    SetTimeout(3000, function()
        isProcessing = false
    end)
end)


-- Start everything
Citizen.CreateThread(function()
    Wait(1000)
    initWeedScript()
    TriggerEvent("weed:runLoop")
end)
