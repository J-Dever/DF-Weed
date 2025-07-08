Citizen.CreateThread(function()
    -- Inventory Detection
    if Config.Inventory == 'auto' then
        if GetResourceState("qb-core") == "started" then
            print("[Weed Script] Auto-detected QBCore inventory.")
            local QBCore = exports['qb-core']:GetCoreObject()
            Config.Inventory = {
                HasItem = function(item, cb)
                    QBCore.Functions.TriggerCallback('qb-core:HasItem', cb, item)
                end,
                AddItem = function(item, amount)
                    TriggerServerEvent('weed:addItem', item, amount)
                end,
                RemoveItem = function(item, amount)
                    TriggerServerEvent('weed:removeItem', item, amount)
                end
            }
        elseif GetResourceState("ox_inventory") == "started" then
            print("[Weed Script] Auto-detected OX Inventory.")
            Config.Inventory = {
                HasItem = function(item, cb)
                    local count = exports.ox_inventory:Search('count', item)
                    cb(count and count > 0)
                end,
                AddItem = function(item, amount)
                    TriggerServerEvent('ox_inventory:addItem', item, amount)
                end,
                RemoveItem = function(item, amount)
                    TriggerServerEvent('ox_inventory:removeItem', item, amount)
                end
            }
        else
            print("[Weed Script] ⚠️ Could not auto-detect inventory system.")
            Config.Inventory = {
                HasItem = function(item, cb)
                    cb(false)
                end,
                AddItem = function(item, amount) end,
                RemoveItem = function(item, amount) end
            }
        end
    end

    -- Third Eye Detection
    if Config.ThirdEye == 'auto' then
        if GetResourceState("qb-target") == "started" then
            print("[Weed Script] Auto-detected qb-target.")
            Config.ThirdEye = {
            AddBoxZone = function(id, coords, length, width, boxOptions, targetData)
            local targetOptions = targetData and targetData.options
            if type(targetOptions) ~= "table" then
            print("[Weed Script] ⚠️ Invalid target options provided to AddBoxZone:", id)
            targetOptions = {}
        end

        exports['qb-target']:AddBoxZone(id, coords, length, width, boxOptions, targetOptions)
    end
}


        elseif GetResourceState("ox_target") == "started" then
            print("[Weed Script] Auto-detected ox_target.")
            Config.ThirdEye = {
                AddBoxZone = function(id, coords, length, width, opts, data)
                    exports['ox_target']:addBoxZone({
                        name = id,
                        coords = coords,
                        size = vec3(length, width, opts.maxZ - opts.minZ),
                        rotation = opts.heading or 0,
                        debug = opts.debugPoly or false,
                        options = data.options,
                        distance = data.distance or 2.0
                    })
                end
            }
        else
            print("[Weed Script] ⚠️ No supported third eye system detected.")
            Config.ThirdEye = {
                AddBoxZone = function(...) end -- no-op fallback
            }
        end
    end
end)

