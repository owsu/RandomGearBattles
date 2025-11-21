local dataservice = game:GetService("DataStoreService")
local datastore = dataservice:GetDataStore("Alphav2")
local dailyrewards = dataservice:GetDataStore("RewardsDaily")
local badgeservice = game:GetService("BadgeService")
local analyticservice = game:GetService("AnalyticsService")

local function LoadStats(plr)
	local stat = Instance.new("Folder", plr)
	stat.Name = "playerstats"

	local inventory = Instance.new("Folder", plr)
	inventory.Name = "Inventory"

	local leaderstats = Instance.new("Folder", plr)
	leaderstats.Name = "leaderstats"
	
	local upgradestats = Instance.new("Folder", plr)
	upgradestats.Name = "upgradestats"

	local owneditems = Instance.new("Folder", plr)
	owneditems.Name = "OwnedItems"
		
	local fightable = Instance.new("BoolValue", plr)
	fightable.Name = "Fightable"
	fightable.Value = false

	local kills = Instance.new("IntValue", leaderstats)
	kills.Name = "Kills"

	local level = Instance.new("IntValue", leaderstats)
	level.Name = "Level"
	level.Value = 1

	local cash = Instance.new("IntValue", stat)
	cash.Name = "Cash"
	cash.Value = 0

	local trail = Instance.new("StringValue", stat)
	trail.Name = "Trail"
	trail.Value = "Default"


	local xp = Instance.new("IntValue", stat)
	xp.Name = "XP"

	local daily = Instance.new("BoolValue", stat)
	daily.Name = "Daily"
	daily.Value = false
	
	local groupdaily = Instance.new("BoolValue", stat)
	groupdaily.Name = "GroupDaily"
	groupdaily.Value = false

	local activeitem = Instance.new("StringValue", stat)
	activeitem.Name = "ActiveItem"
	activeitem.Value = "None"

	local slot1 = Instance.new("StringValue", stat)
	slot1.Name = "Slot1"
	slot1.Value = "None"

	local slot2 = Instance.new("StringValue", stat)
	slot2.Name = "Slot2"
	slot2.Value = "None"

	local maxXP = Instance.new("IntValue", stat)
	maxXP.Name = "MaxXP"
	maxXP.Value = 15

	local totalbuttons = Instance.new("IntValue", stat)
	totalbuttons.Name = "TotalButtons"
	totalbuttons.Value = 2

	local freepoints = Instance.new("IntValue", stat)
	freepoints.Name = "FreePoints"
	freepoints.Value = 0
	
	local resetstats = Instance.new("IntValue", stat)
	resetstats.Name = "ResetStats"
	resetstats.Value = 0
	
	local XPStat = Instance.new("NumberValue", upgradestats)
	XPStat.Name = "XPStat"
	XPStat.Value = 1
	
	local CashStat = Instance.new("NumberValue", upgradestats)
	CashStat.Name = "CashStat"
	CashStat.Value = 1
	
	local CDStat = Instance.new("NumberValue", upgradestats)
	CDStat.Name = "CDStat"
	CDStat.Value = 1
	
	local LuckStat = Instance.new("NumberValue", upgradestats)
	LuckStat.Name = "LuckStat"
	LuckStat.Value = 1
	
	local DamageStat = Instance.new("NumberValue", upgradestats)
	DamageStat.Name = "DamageStat"
	DamageStat.Value = 1
	
	

	local inventorycount = Instance.new("IntValue", stat)
	inventorycount.Name = "InventoryCount"

	local maxinventory = Instance.new("IntValue", stat)
	maxinventory.Name = "InventoryCapacity"
	maxinventory.Value = 7

	for i, gear in pairs(game.ReplicatedStorage.Loot:GetDescendants()) do
		if gear:IsA("Tool") then
			local gearvalue = Instance.new("IntValue", inventory)
			gearvalue.Name = gear.Name

			gearvalue.Changed:Connect(function()
				local count = 0
				for i,v in pairs(inventory:GetChildren()) do
					count += v.Value
				end
				inventorycount.Value = count
			end)
		end
	end
	
	for i, trail in pairs(game.ReplicatedStorage.Store.Trails:GetDescendants()) do
		if trail:IsA("Trail") then
			local trailvalue = Instance.new("BoolValue", owneditems)
			trailvalue.Name = trail.Name
		end
	end
					

	local data -- LOAD DATA
	local success, errorMessage = pcall(function()
		data = datastore:GetAsync(plr.UserId)
	end)
	if success and data ~= nil then
		for i,v in pairs(leaderstats:GetChildren()) do
			v.Value = data[v.Name] or 0
		end
		for i,v in pairs(stat:GetChildren()) do
			v.Value = data[v.Name] or 0
			if v.Name == "Trail" then
				v.Value = data[v.Name] or "Default"
			end
		end
		for i,v in pairs(inventory:GetChildren()) do
			v.Value = data[v.Name] or 0
		end
		for i,v in pairs(upgradestats:GetChildren()) do
			v.Value = data[v.Name] or 1
		end
		for i,v in pairs(owneditems:GetChildren()) do
			v.Value = data[v.Name] or false
		end
	elseif not success and data ~= nil then
		plr.Kick("Data failed to load, error message: " .. errorMessage)
	end
	
	owneditems:FindFirstChild("Default").Value = true
	
	-- TUTORIAL 
	
	if data == nil then
		-- no tutorial method? plr.PlayerGui:WaitForChild("Tutorial", 15).Enabled = true
	end
end
game.Players.PlayerAdded:Connect(function(plr)
	local isAlpha = true
	LoadStats(plr)
	analyticservice:LogOnboardingFunnelStepEvent(plr, 1, "Joined game")
	local playerstats = plr.playerstats
	-- Daily!
	pcall(function()
		local lastJoined = dailyrewards:GetAsync(plr.UserId)
		
		if not lastJoined then
			-- FIRST PLAYTHROUGH
			plr.playerstats.Daily.Value = true
			dailyrewards:SetAsync(plr.UserId, os.time())
			if plr:IsInGroup(769404750) then
				plr.playerstats.GroupDaily.Value = true
			end
		else
			local timeDiff = math.abs(os.difftime(os.time(), lastJoined))
			if timeDiff >= 86400 then
				dailyrewards:SetAsync(plr.UserId,os.time())
				plr.playerstats.Daily.Value = false
				if plr:IsInGroup(769404750) then
					plr.playerstats.GroupDaily.Value = false
				end
			else
				plr.playerstats.Daily.Value = false
				plr.playerstats.GroupDaily.Value = false
			end
		end			

	end)
	
	-- Referral
	local referredByPlayerId = plr:GetJoinData().ReferredByPlayerId

	local referrerEvent: RemoteEvent = game.ReplicatedStorage:FindFirstChild("ReferralReceivedEvent")
	referrerEvent:FireClient(plr, referredByPlayerId)
	
	if referredByPlayerId and referredByPlayerId ~= 0 then
		referrerEvent:FireClient(plr, referredByPlayerId)
	end
	
	function rewardReferrer(referrerId)
		local referrerPlayer = game.Players:GetPlayerByUserId(referrerId)
		if referrerPlayer then
			referrerPlayer.playerstats.Cash.Value += 25
		end
	end

	function rewardInvitee(player)
		player.playerstats.Cash.Value += 25
	end
	
	playerstats.XP.Changed:Connect(function()
		if playerstats.XP.Value >= playerstats.MaxXP.Value then -- level up!
			playerstats.XP.Value -= plr.playerstats.MaxXP.Value
			plr.leaderstats.Level.Value += 1
			playerstats.MaxXP.Value = 30 * 1.10^(plr.leaderstats.Level.Value - 1)
			plr.playerstats.FreePoints.Value += 1
		end
	end)
	
	plr.PlayerGui:WaitForChild("Main").Ingame.Hotbar.Button1:SetAttribute("Item", playerstats.Slot1.Value)
	plr.PlayerGui:WaitForChild("Main").Ingame.Hotbar.Button2:SetAttribute("Item", playerstats.Slot2.Value)
	
	
	
	for i,v in pairs(game.ReplicatedStorage:WaitForChild("Loot"):GetDescendants()) do
		if v.Name == playerstats.Slot1.Value then
			v:Clone().Parent = plr.PlayerGui:WaitForChild("Main").Ingame.Hotbar.Button1.GearImage
		end
		if v.Name == playerstats.Slot2.Value then
			v:Clone().Parent = plr.PlayerGui:WaitForChild("Main").Ingame.Hotbar.Button2.GearImage
		end
	end
	
	if isAlpha then
		badgeservice:AwardBadge(plr.UserId, 1625998682571442)
	end
	
	badgeservice:AwardBadge(plr.UserId, 2138674790883781)
	
	-- playtime rewards
	
	local playtime = Instance.new("IntValue", plr)
	playtime.Name = "PlayTime"
	
	while task.wait(1) do
		playtime.Value += 1
	end
end)

game.Players.PlayerRemoving:Connect(function(plr)
	local data = { -- Save stats
		Kills = plr.leaderstats.Kills.Value,
		Level = plr.leaderstats.Level.Value,
		XP = plr.playerstats.XP.Value,
		MaxXP = plr.playerstats.MaxXP.Value,
		TotalButtons = plr.playerstats.TotalButtons.Value,
		InventoryCount = plr.playerstats.InventoryCount.Value,
		InventoryCapacity = plr.playerstats.InventoryCapacity.Value,
		Slot1 = plr.playerstats.Slot1.Value,
		Slot2 = plr.playerstats.Slot2.Value,
		Cash = plr.playerstats.Cash.Value,
		Trail = plr.playerstats.Trail.Value,
		FreePoints = plr.playerstats.FreePoints.Value,
		ResetStats = plr.playerstats.ResetStats.Value,
		XPStat = plr.upgradestats.XPStat.Value,
		CashStat = plr.upgradestats.CashStat.Value,
		CDStat = plr.upgradestats.CDStat.Value,
		LuckStat = plr.upgradestats.LuckStat.Value,
		DamageStat = plr.upgradestats.DamageStat.Value,
	}
	for i,v in pairs(plr.Inventory:GetChildren()) do -- Save Inv
		data[v.Name] = v.Value
	end
	for i,v in pairs(plr.OwnedItems:GetChildren()) do -- Save Trails
		data[v.Name] = v.Value
	end
	local success, errorMessage = pcall(function()
		data = datastore:SetAsync(plr.UserId, data)
	end)
	if success then
		print("saved")
	else
		warn(errorMessage)
	end

end)

