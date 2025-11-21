local debris = game:GetService("Debris")
local hitbox = Instance.new("Part", game.ServerStorage)
local debris = game:GetService("Debris")
hitbox.Anchored = true
hitbox.Size = Vector3.new(5, 5, 5)
hitbox.Transparency = 1
hitbox.CanCollide = false

local ignorelist = game.Workspace.Map:GetDescendants()
local filtertype = Enum.RaycastFilterType.Exclude

local overlapparams = OverlapParams.new()
overlapparams.FilterType = filtertype
overlapparams.FilterDescendantsInstances = ignorelist


function Stun(enemy, timer, hasAnim)
	enemy.Humanoid:SetAttribute("Stunned", true)
	

	task.spawn(function()
		task.wait(timer)
		local hum = enemy:FindFirstChild("Humanoid")
		if hum then
			hum:SetAttribute("Stunned", false)
		end
	end)
end

game.ReplicatedStorage.Remotes.Events.SwordSwing.OnServerEvent:Connect(function(plr, crit, anim, damage)
	local hitarea = hitbox:Clone()
	local basedmg = damage * plr.upgradestats.DamageStat.Value
	if basedmg > 50 then
		basedmg = 50
	end
	local isStunned = plr.Character.Humanoid:GetAttribute("Stunned")
	local hitlist = {}




	hitarea.Parent = game.Workspace
	hitarea.CFrame = CFrame.new(plr.Character.HumanoidRootPart.CFrame * Vector3.new(0, 0, -2))
	debris:AddItem(hitarea, .25)

	local simplehitbox = workspace:GetPartsInPart(hitarea, overlapparams)

	for i , hit in (simplehitbox) do
		if isStunned or plr.Character.Humanoid.Health <= 0 then
			break
		end
		if hit.Parent:FindFirstChild("Humanoid") and not table.find(hitlist, hit.Parent) and hit.Parent ~= plr.Character then
			local enemy = hit.Parent
			table.insert(hitlist, enemy)
			
			local fightable = true
			local hitanimTrack = enemy.Humanoid.Animator:LoadAnimation(anim)
			local enemyplr = game:GetService("Players"):GetPlayerFromCharacter(enemy)
			if enemyplr then
				if enemyplr.Fightable.Value == false then
					fightable = false
				end
			end

			

			if crit and fightable then
				local attackNoise = game.ServerStorage.Sounds.Crit:Clone()
				attackNoise.Parent = enemy.HumanoidRootPart
				debris:AddItem(attackNoise, 1)

				local attachment = Instance.new("Attachment", enemy.HumanoidRootPart)
				local lv = Instance.new("LinearVelocity", enemy)
				lv.MaxForce = math.huge
				lv.Attachment0 = attachment
				lv.VectorVelocity = plr.Character.PrimaryPart.CFrame.LookVector * 20
				debris:AddItem(lv, .2)
				debris:AddItem(attachment, .2)

				enemy.Humanoid:TakeDamage(basedmg * 1.5)
				hitanimTrack:Play()
				enemy.HumanoidRootPart.CFrame = CFrame.lookAt(enemy.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position)
				Stun(enemy, .4, false)
				attackNoise:Play()
				local tag = Instance.new("ObjectValue", enemy.Humanoid)
				tag.Name = "creator"
				tag.Value = plr
				debris:AddItem(tag, 1)

			elseif fightable then
				local attackNoise = game.ServerStorage.Sounds.SwordHit:Clone()
				attackNoise.Parent = enemy.HumanoidRootPart
				debris:AddItem(attackNoise, 1)

				enemy.Humanoid:TakeDamage(basedmg)
				hitanimTrack:Play()
				enemy.HumanoidRootPart.CFrame = CFrame.lookAt(enemy.HumanoidRootPart.Position, plr.Character.HumanoidRootPart.Position)
				Stun(enemy, .4, false)
				attackNoise:Play()
				local tag = Instance.new("ObjectValue", enemy.Humanoid)
				tag.Name = "creator"
				tag.Value = plr
				debris:AddItem(tag, 1)
			end

		end

	end

end)



game.ReplicatedStorage.Remotes.Events.Drink.OnServerEvent:Connect(function(plr, type)
	
	if type == "Bloxy" or type == "Goblet" then
		for count = 5, 0, -1 do
			task.wait(1)
			plr.Character.Humanoid.Health += 4
		end
	elseif type == "Bloxiade" then
		plr.Character.Humanoid.WalkSpeed = 28
		local sparkles = Instance.new("Sparkles", plr.Character)
		debris:AddItem(sparkles, 15)
		task.wait(15)
		plr.Character.Humanoid.WalkSpeed = 16
	elseif type == "Witch" then
		plr.Character.Head.Size = Vector3.new(2, 2, 2)
		for count = 5, 0, -1 do
			task.wait(.3)
			plr.Character.Humanoid.Health += 6
		end
	end
	
	local drinkNoise = game.ServerStorage.Sounds.Drink:Clone()
	drinkNoise.Parent = plr.Character.HumanoidRootPart
	drinkNoise:Play()
	debris:AddItem(drinkNoise, 1)
	
	
end)


game.ReplicatedStorage.Remotes.Events.SprintEvent.OnServerEvent:Connect(function(plr, isSprinting)
	local humanoid = plr.Character:FindFirstChild("Humanoid")

	if not humanoid then return end
	if humanoid:GetAttribute("Stunned") then return end

	if isSprinting then
		humanoid:SetAttribute("Running", true)
		humanoid:SetAttribute("Blocking", false)
		humanoid.WalkSpeed = 22
	else
		humanoid:SetAttribute("Running", false)
		humanoid.WalkSpeed = 16
	end
end)

game.ReplicatedStorage.Remotes.Events.PunchEvent.OnServerEvent:Connect(function(plr, hand)
	pcall(function()
		if plr.Fightable.Value == true and plr.Character.Humanoid.Health > 0 then -- for pvp
			for i,enemy in pairs(game.Players:GetChildren()) do
				if enemy ~= plr and enemy.Fightable.Value == true then
					local char = enemy.Character
					if math.floor((plr.Character.HumanoidRootPart.Position - char.HumanoidRootPart.Position).magnitude) <= 6 then
						local dmg = 15 * plr.upgradestats.DamageStat.Value
						if dmg > 50 then
							dmg = 50
						end
						char.Humanoid:TakeDamage(dmg)
						--playNoise("Hand", plr)
						local tag = Instance.new("ObjectValue", char.Humanoid)
						tag.Name = "creator"
						tag.Value = plr
						debris:AddItem(tag, 1)
					end
				end
			end
		elseif plr.Fightable.Value == false and plr.Character.Humanoid.Health > 0 then -- for mobs
			for i,enemy in pairs(game.Workspace.Enemies:GetChildren()) do
				if math.floor((plr.Character.HumanoidRootPart.Position - enemy.HumanoidRootPart.Position).magnitude) <= 6 then
					enemy.Humanoid:TakeDamage(15 * plr.upgradestats.DamageStat.Value)
					--playNoise("Hand", plr)
					local tag = Instance.new("ObjectValue", enemy.Humanoid)
					tag.Name = "creator"
					tag.Value = plr
					debris:AddItem(tag, 1)
				end
			end
		end
	end)

end)