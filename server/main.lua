local Locales = {}
dofile("locales.lua") -- adjust path if needed

QBCore = exports['qb-core']:GetCoreObject()

-- Inside server.lua if needed
QBCore.Functions.CreateCallback('qb-core:HasItem', function(source, cb, item)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player then
        local hasItem = Player.Functions.GetItemByName(item)
        cb(hasItem ~= nil)
    else
        cb(false)
    end
end)

-- Add Item to Player
RegisterNetEvent('weed:addItem')
AddEventHandler('weed:addItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.AddItem(item, amount)
    end
end)

-- Remove Item from Player
RegisterNetEvent('weed:removeItem')
AddEventHandler('weed:removeItem', function(item, amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        Player.Functions.RemoveItem(item, amount)
    end
end)

-- Weed joint making
RegisterNetEvent("weed:client:makeJoint", function()
    if isProcessing then return end
    isProcessing = true

    makeJoint()

    SetTimeout(3000, function()
        isProcessing = false
    end)
end)

RegisterNetEvent("weed:client:processWeed", function()
    processWeed()  -- Called here
end)

-- Add Money to Player
RegisterNetEvent('weed:addMoney')
AddEventHandler('weed:addMoney', function(amount)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        Player.Functions.AddMoney('cash', amount)
        TriggerClientEvent('QBCore:Notify', src, 'You received $' .. amount .. ' cash for selling weed.', 'success')
    end
end)
