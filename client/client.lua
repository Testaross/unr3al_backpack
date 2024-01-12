local bagEquipped, skin
local ox_inventory = exports.ox_inventory
local ped = cache.ped
local justConnect = true
local count = 0
local timeout, changed, puttedon = false, false, false

local function PutOnBag(bagtype)
    bagtype = bagtype
    if Config.Debug then print("Putting on Backpack") end
    if Config.Debug then print("Bag type: "..bagtype) end
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Backpacks[bagtype].Uniform.Male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config.Backpacks[bagtype].Uniform.Female)
        end
        saveSkin()
    end)
    bagEquipped = true
end

saveSkin = function()
    Wait(100)

    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('unr3al_backpack:save', skin)
    end)
end
--[[
local function RemoveBag(bagtype)
    bagtype = bagtype
    if Config.Debug then print("Removing Backpack") end
    TriggerEvent('skinchanger:getSkin', function(skin)
        if skin.sex == 0 then
            TriggerEvent('skinchanger:loadClothes', skin, Config.Backpacks[bagtype].CleanUniform.Male)
        else
            TriggerEvent('skinchanger:loadClothes', skin, Config.Backpacks[bagtype].CleanUniform.Female)
        end
        saveSkin()
        bagEquipped = nil
    end)
end
--]]
local function RemoveBag(bagtype)
    bagtype = bagtype
    if Config.Debug then print("Removing Backpack") end
    TriggerEvent('skinchanger:getSkin', function(skin)
        print(skin)
        print(bagtype)
        local clothesWithoutBag
        if skin.sex == 0 then
            clothesWithoutBag = Config.CleanUniform.Male
        else
            clothesWithoutBag = Config.CleanUniform.Female
        end
        TriggerEvent('skinchanger:loadClothes', skin, clothesWithoutBag)
        saveSkin()
        bagEquipped = nil
    end)
end

AddEventHandler('ox_inventory:updateInventory', function(changes)
    if justConnect then
        Wait(4500)
        justConnect = nil
    end
    if Config.Debug then print("Update Inv") end
    for k, v in pairs(changes) do
        if not changed then
            changed = true
            if Config.Debug then print("V: "..tostring(v)) end
            if type(v) == 'table' then
                if not timeout then
                    timeout = true
                    local count = 0
                    for vbag in pairs(Config.Backpacks) do
                            count = ox_inventory:Search('count', vbag)
                            if count > 0 and (not bagEquipped) then
                                if count >= 1 then
                                    PutOnBag(vbag)
                                    if Config.Debug then print("Count: "..count) end
                                end
                            end
                    end
                end
                timeout = false
            elseif type(v) == 'boolean' then
                if not timeout then
                    local count = 0
                    for vbag in pairs(Config.Backpacks) do
                        count = count + ox_inventory:Search('count', vbag)
                    end
                    if count > 0 and (not bagEquipped) then
                        if count >= 1 then
                            PutOnBag(vbag)
                            if Config.Debug then print("Count: "..count) end
                        end                                
                    else
                        if count == 0 and bagEquipped then
                            RemoveBag(vbag)
                        end
                    end
                end
            end
        end

    end
    changed = false
end)
lib.onCache('ped', function(value)
    ped = value
end)

lib.onCache('vehicle', function(value)
    if GetResourceState('ox_inventory') ~= 'started' then return end
    if value then
        RemoveBag()
    else
        for vbag in pairs(Config.Backpacks) do
			count = count + ox_inventory:Search('count', vbag)
		end
        if count and count >= 1 then
            PutOnBag(bagtype)
        end
    end
end)

for kbag in pairs(Config.Backpacks) do
    local bagtype = kbag
    exports('openBackpack_'..bagtype, function(data, slot)
        if Config.Debug then print("Export "..bagtype.." Triggered") end
        if not slot?.metadata?.identifier then
            local identifier = lib.callback.await('unr3al_backpack:getNewIdentifier', 100, data.slot, bagtype)
            ox_inventory:openInventory('stash', bagtype..'_'..identifier)
            if Config.Debug then print("Registered new identifier") end
        else
            TriggerServerEvent('unr3al_backpack:openBackpack', slot.metadata.identifier, bagtype)
            ox_inventory:openInventory('stash', bagtype..'_'..slot.metadata.identifier)
            if Config.Debug then print("Triggering open backpack") end
        end
    end)
end