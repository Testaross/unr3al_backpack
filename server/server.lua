local registeredStashes = {}
local ox_inventory = exports.ox_inventory
local count_bagpacks = 0

local function GenerateText(num)
	local str
	repeat str = {}
		for i = 1, num do str[i] = string.char(math.random(65, 90)) end
		str = table.concat(str)
	until str ~= 'POL' and str ~= 'EMS'
	return str
end

local function GenerateSerial(text)
	if text and text:len() > 3 then
		return text
	end
	return ('%s%s%s'):format(math.random(100000,999999), text == nil and GenerateText(3) or text, math.random(100000,999999))
end

RegisterServerEvent('unr3al_backpack:openBackpack')
AddEventHandler('unr3al_backpack:openBackpack', function(identifier, bagtype)
	bagtype = bagtype
	if not registeredStashes[identifier] then
        ox_inventory:RegisterStash(bagtype..'_'..identifier, 'Backpack'..bagtype, Config.Backpacks[bagtype].Slots, Config.Backpacks[bagtype].Weight, false)
        registeredStashes[identifier] = true
    end
end)

lib.callback.register('unr3al_backpack:getNewIdentifier', function(source, slot, bagtype)
	bagtype = bagtype
	local newId = GenerateSerial()
	ox_inventory:SetMetadata(source, slot, {identifier = newId})
	ox_inventory:RegisterStash(bagtype..'_'..newId, 'Backpack'..bagtype, Config.Backpacks[bagtype].Slots, Config.Backpacks[bagtype].Weight, false)
	registeredStashes[newId] = true
	return newId
end)

CreateThread(function()
	while GetResourceState('ox_inventory') ~= 'started' do Wait(500) end
	if Config.Debug then print("Inventory Started") end
	local swapHook = ox_inventory:registerHook('swapItems', function(payload)
		local start, destination, move_type, count_bagpacks = payload.fromInventory, payload.toInventory, payload.tobagtype, 0
		if Config.Debug then print("Swap Alive") end
		for vbag in pairs(Config.Backpacks) do
			count_bagpacks = count_bagpacks + ox_inventory:GetItem(payload.source, vbag, nil, true)
		end
		if Config.Debug then print("Count: "..count_bagpacks) end
		if string.find(destination, 'bag') then
			TriggerClientEvent('ox_lib:notify', payload.source, {type = 'error', title = Strings.action_incomplete, description = Strings.backpack_in_backpack}) 
			return false
		end
		if Config.OneBagInInventory then
			if (count_bagpacks > 0 and move_type == 'player' and destination ~= start) then
				TriggerClientEvent('ox_lib:notify', payload.source, {type = 'error', title = Strings.action_incomplete, description = Strings.one_backpack_only}) 
				return false
			end
		end
		
		return true
	end, {
		print = false,
		itemFilter = {
			bag1 = true,
			bag2 = true
		},
	})

	AddEventHandler('onResourceStop', function()
		ox_inventory:removeHooks(swapHook)
	end)
end)

RegisterServerEvent('unr3al_backpack:save')
AddEventHandler('unr3al_backpack:save', function(skin)
    local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	MySQL.update('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)