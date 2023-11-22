-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

local bagEquipped, bagObj
local hash = `p_michael_backpack_s`
local ox_inventory = exports.ox_inventory
local ped = cache.ped
local justConnect = true
local skin


local function PutOnBag()
    print("Putting on Backpack")
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.Male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config.Uniforms.Female)
        end
        saveSkin()
    end)
    bagEquipped = true
end

saveSkin = function()
    Wait(100)

    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('wasabi_backpack:save', skin)
    end)
end

local function RemoveBag()
    print("Removing Backpack")
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.CleanUniforms.Male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config.CleanUniforms.Female)
        end
        saveSkin()
        bagObj = nil
        bagEquipped = nil
    end)
end

AddEventHandler('ox_inventory:updateInventory', function(changes)
    if justConnect then
        Wait(4500)
        justConnect = nil
    end
    for k, v in pairs(changes) do
        if type(v) == 'table' then
            local count = ox_inventory:Search('count', 'backpack')
	        if count > 0 and (not bagEquipped or not bagObj) then
                PutOnBag()
            elseif count < 1 and bagEquipped then
                RemoveBag()
            end
        end
        if type(v) == 'boolean' then
            local count = ox_inventory:Search('count', 'backpack')
            if count < 1 and bagEquipped then
                RemoveBag()
            end
        end
    end
end)

lib.onCache('ped', function(value)
    ped = value
end)

lib.onCache('vehicle', function(value)
    if GetResourceState('ox_inventory') ~= 'started' then return end
    if value then
        RemoveBag()
    else
        local count = ox_inventory:Search('count', 'backpack')
        if count and count >= 1 then
            PutOnBag()
        end
    end
end)

exports('openBackpack', function(data, slot)
    if not slot?.metadata?.identifier then
        local identifier = lib.callback.await('wasabi_backpack:getNewIdentifier', 100, data.slot)
        ox_inventory:openInventory('stash', 'bag_'..identifier)
    else
        TriggerServerEvent('wasabi_backpack:openBackpack', slot.metadata.identifier)
        ox_inventory:openInventory('stash', 'bag_'..slot.metadata.identifier)
    end
end)
