local events = game.ReplicatedStorage.Remotes.Events

events.ItemEquipped.OnServerEvent:Connect(function(plr, isEquipping, item, button)
	
	if isEquipping then
		button:SetAttribute("Active", true) -- Unequip other gear
		for i, otherbuttons in pairs(button.Parent:GetChildren()) do
			if otherbuttons:GetAttribute("Active") == true and otherbuttons ~= button then
				otherbuttons:SetAttribute("Active", false)
				for i, gear in pairs(plr.Character:GetChildren()) do
					if gear:IsA("Tool") then
						gear:Destroy()
					end
				end
			end
		end
		
		for i, gear in pairs(game.ReplicatedStorage.Loot:GetDescendants()) do -- Equip your gear
			if gear.Name == item then
				local weapon = gear:Clone()
				weapon.Parent = plr.Character
				plr.playerstats.ActiveItem.Value = item
			end
		end
		
	else
		
		button:SetAttribute("Active", false)
		for i, gear in pairs(plr.Character:GetChildren()) do
			if gear:IsA("Tool") then
				gear:Destroy()
			end
		end
	end
end)

events.SellItem.OnServerEvent:Connect(function(plr, item, hasItem)
	for i,v in pairs(plr.Inventory:GetChildren()) do
		if v.Name == item then
			if hasItem then
				if v.Value > 0 then
					v.Value -= 1
				else
					return
				end
			end
			
			local rarity
			for i,v in pairs(game.ReplicatedStorage.Loot:GetDescendants()) do
				if v.Name == item then
					rarity = v.Parent.Name
				end
			end
			
			if rarity == "Common" then
				plr.playerstats.Cash.Value += 5 * plr.upgradestats.CashStat.Value
				plr.playerstats.XP.Value += 1 * plr.upgradestats.XPStat.Value
			elseif rarity == "Uncommon" then
				plr.playerstats.Cash.Value += 10 * plr.upgradestats.CashStat.Value
				plr.playerstats.XP.Value += 2 * plr.upgradestats.XPStat.Value
			elseif rarity == "Rare" then
				plr.playerstats.Cash.Value += 15 * plr.upgradestats.CashStat.Value
				plr.playerstats.XP.Value += 4 * plr.upgradestats.XPStat.Value
			elseif rarity == "Epic" then
				plr.playerstats.Cash.Value += 20 * plr.upgradestats.CashStat.Value
				plr.playerstats.XP.Value += 6 * plr.upgradestats.XPStat.Value
			elseif rarity == "Exotic" then
				plr.playerstats.Cash.Value += 40 * plr.upgradestats.CashStat.Value
				plr.playerstats.XP.Value += 8 * plr.upgradestats.XPStat.Value
			elseif rarity == "Legendary" then 
				plr.playerstats.Cash.Value += 50 * plr.upgradestats.CashStat.Value
				plr.playerstats.XP.Value += 10 * plr.upgradestats.XPStat.Value
			elseif rarity == "Mythic" then
				plr.playerstats.Cash.Value += 100 * plr.upgradestats.CashStat.Value
				plr.playerstats.XP.Value += 20 * plr.upgradestats.XPStat.Value
			elseif rarity == "Gamepass" then
				plr.playerstats.Cash.Value += 1000 * plr.upgradestats.CashStat.Value
				plr.playerstats.XP.Value += 40 * plr.upgradestats.XPStat.Value
			end
		end
	end

end)

events.ItemSlotted.OnServerEvent:Connect(function(plr, slot, item)
	if slot == 1 then
		plr.playerstats.Slot1.Value = item
		plr.PlayerGui.Main.Ingame.Hotbar.Button1:SetAttribute("Item", item)
	elseif slot == 2 then
		plr.playerstats.Slot2.Value = item
		plr.PlayerGui.Main.Ingame.Hotbar.Button2:SetAttribute("Item", item)
	end
end)


events.BuyInventory.OnServerEvent:Connect(function(plr)
	local cash = plr.playerstats.Cash.Value
	local invslots = plr.playerstats.InventoryCapacity.Value
	
	if cash > (80 * 12^(1 + invslots/100)) then
		plr.playerstats.Cash.Value -= 60 * 12^(1 + plr.playerstats.InventoryCapacity.Value/80)
		plr.playerstats.InventoryCapacity.Value += 1
	end
end)