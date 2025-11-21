local module = require(game.ReplicatedStorage.Modules.RNG)
local analyticservice = game:GetService("AnalyticsService")

game.ReplicatedStorage.Remotes.Functions.Buttonroll.OnServerInvoke = function(plr)
	local rarity = module.ChooseRarity(plr)
	local item = module.ChooseItem(rarity)
	
	task.delay(5, function()
		if rarity ~= "Common" and rarity ~= "Uncommon" and rarity ~= "Rare" then
			for i,v in pairs(game.Players:GetChildren()) do
				game.ReplicatedStorage.Remotes.Events.SpunItem:FireClient(v, rarity, item, plr.DisplayName)
			end
		end
	end)
	
	
	analyticservice:LogOnboardingFunnelStepEvent(plr, 3, "Rolled an item")
	return item, rarity
end

game.ReplicatedStorage.Remotes.Events.ItemAccepted.OnServerEvent:Connect(function(plr, item, rarity)
	if plr.playerstats.InventoryCount.Value < plr.playerstats.InventoryCapacity.Value then
		for i,stat in pairs(plr.Inventory:GetChildren()) do
			if stat.Name == item then
				stat.Value += 1
			end
		end
	end
	
end)