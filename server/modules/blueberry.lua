local data = {}
TriggerEvent("redemrp_inventory:getData", function(call) data = call end)

RegisterServerEvent("RegisterUsableItem:blueberry")
AddEventHandler("RegisterUsableItem:blueberry", function(source)
    local _source = source
	-- local blueberry_data = data.getItem(_source, 'blueberry')
	-- -- blueberry_data.RemoveItem(1)
    TriggerClientEvent('exp_target_menu:EatBlueBerry', _source)
end)

RegisterServerEvent('exp_target_menu:addBlueBerry')
AddEventHandler('exp_target_menu:addBlueBerry', function() 
	local _source = source
	local blueberry_data = data.getItem(_source, 'blueberry')
	local stick_data = data.getItem(_source, 'stick')
	math.randomseed(GetGameTimer())
	local amount = math.random(1,2)
	blueberry_data.AddItem(amount)
	stick_data.AddItem(1)
end)