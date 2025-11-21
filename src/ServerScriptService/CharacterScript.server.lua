local Players = game:GetService("Players")
local debris = game:GetService("Debris")
local tweenservice = game:GetService("TweenService")
local tweeninfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In, 0, false, 0)
local analyticservice = game:GetService("AnalyticsService")

local function onCharacterAdded(char)
	local plr = Players:GetPlayerFromCharacter(char)
	local human = char:FindFirstChild("Humanoid")
	local fightable = plr.Fightable.Value
	human:SetAttribute("Stunned", false)
	local a0, a1 = Instance.new("Attachment", char.HumanoidRootPart), Instance.new("Attachment", char.HumanoidRootPart)
	
	a0.CFrame = CFrame.new(0, char.HumanoidRootPart.Size.Y/2, 0)
	a1.CFrame = CFrame.new(0, -char.HumanoidRootPart.Size.Y/2, 0)
	a0.Name = "A0"
	a1.Name = "A1"
	
	local trail = plr.playerstats.Trail.Value
	local t = game.ReplicatedStorage.Store.Trails:FindFirstChild(trail):Clone()
	t.Parent = char
	t.Attachment0 = a0
	t.Attachment1 = a1
	
	if human then
		local hp = human.Health
		human.HealthChanged:Connect(function(newhp) -- Shows damage markers
			
			local gui = game.ReplicatedStorage.GUI.HealthChange:Clone()
			local xpos = math.random(-1, 1)
			local ypos = math.random(-1, 1)
			gui.SizeOffset = Vector2.new(xpos, ypos) 
			gui.Parent = human.Parent
			local tweengoal = {
				SizeOffset = Vector2.new(xpos, ypos + 2)
			}
			local tween = tweenservice:Create(gui, tweeninfo, tweengoal)
			tween:Play()
			debris:AddItem(gui,1)

			if hp > newhp then -- If player got hurt
				gui.TextLabel.Text = "-"..math.floor(hp - newhp + 0.5)
			else -- If player healed
				gui.TextLabel.Text = "+"..math.floor(newhp - hp + 0.5)
				gui.TextLabel.TextColor3 = Color3.fromRGB(40, 108, 9)
			end
			hp = newhp
		end)
		
	end
	

end

local function onCharacterRemoved(char)
	for i, tag in pairs(char:GetDescendants()) do
		if tag:IsA('ObjectValue') and tag.Value and tag.Value:IsA('Player') then
			local killer = tag.Value
			if killer:FindFirstChild("playerstats") then
				local cash = nil
				pcall(function()
					local weapon = killer.Character:FindFirstChildOfClass("Tool")
					local cash = weapon:GetAttribute("Cash")
				end)
				killer.leaderstats.Kills.Value += 1
				killer.playerstats.XP.Value += 5 * killer.upgradestats.XPStat.Value
				if cash then
					killer.playerstats.Cash.Value += math.floor(80 * cash * killer.upgradestats.CashStat.Value)
				else
					killer.playerstats.Cash.Value += 80 * killer.upgradestats.CashStat.Value
					print("character died")
				end
				
				analyticservice:LogOnboardingFunnelStepEvent(killer, 6, "Killed a player")
			end
			return
		end
	end
end
	

local function playerAdded(plr)
	plr.CharacterAdded:Connect(onCharacterAdded)
	plr.CharacterRemoving:Connect(onCharacterRemoved)
end

Players.PlayerAdded:Connect(playerAdded)