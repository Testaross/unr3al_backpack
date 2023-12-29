local bagEquipped, bagObj, skin
local ox_inventory = exports.ox_inventory
local ped = cache.ped
local justConnect = true
local count = 0


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

local function RemoveBag()
    if Config.Debug then print("Removing Backpack") end
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
    if Config.Debug then print("Update Inv") end
    for k, v in pairs(changes) do
        if Config.Debug then print("V: "..tostring(v)) end
        if type(v) == 'table' then
            for vbag in pairs(Config.Backpacks) do
                count = count + ox_inventory:Search('count', vbag)
                if count > 0 and (not bagEquipped or not bagObj) then
                    for vbag in pairs(Config.Backpacks) do
                        bagcount = ox_inventory:GetItemCount(vbag)
                        if bagcount >= 1 then
                            PutOnBag(vbag)
                            if Config.Debug then print("Count: "..bagcount) end
                        end
                    end
                elseif count < 1 and bagEquipped then
                    RemoveBag()
                end
            end

        end
        if type(v) == 'boolean' then
            RemoveBag()
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