local QBCore = exports['qb-core']:GetCoreObject() 
local currentJobId = nil
local Cooldown = false



RegisterServerEvent('cw-boostjob:server:startr', function(jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    
	if Player.PlayerData.money['cash'] >= Config.Jobs[jobId].RunCost then
        currentJobId = jobId
		Player.Functions.RemoveMoney('cash', Config.Jobs[currentJobId].RunCost, "Running Costs")
        Player.Functions.RemoveItem('swap_token', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['swap_token'], "remove")
        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.send_email_right_now"), 'success')
        TriggerEvent('cw-boostjob:server:coolout')
		TriggerClientEvent('cw-boostjob:client:runactivate', src)
	else
		TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
	end
end)

RegisterServerEvent('cw-boostjob:server:giveSlip', function(model)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local item = 'swap_slip'
    local info = {}
    info.vehicle = model

    Player.Functions.AddItem(item, 1, nil, info)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], "add")

end)


-- cool down for job
RegisterServerEvent('cw-boostjob:server:coolout', function()
    Cooldown = true
    local timer = Config.Cooldown * 1000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

QBCore.Functions.CreateCallback("cw-boostjob:server:coolc",function(source, cb)
    
    if Cooldown then
        cb(true)
    else
        cb(false) 
    end
end)
