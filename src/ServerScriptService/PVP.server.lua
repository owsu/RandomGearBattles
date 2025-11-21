local shopzone = game.Workspace.Map.Shop.ShopZone

local ignorelist = game.Workspace.Map:GetDescendants()
local filtertype = Enum.RaycastFilterType.Exclude

local overlapparams = OverlapParams.new()
overlapparams.FilterType = filtertype
overlapparams.FilterDescendantsInstances = ignorelist

-- CURRENT BUG: IF A PLAYER IS IN PVP ZONE AND YOU GO IN PVP ZONE, YOU KEEP YOUR FORCEFIELD FOR WHATEVER REASON

local function GetPlayers()
	-- everybody is in pvp list
	local pvplist = {}
	local simplehitbox = workspace:GetPartsInPart(shopzone, overlapparams)
	
	for i,plr in pairs(game.Players:GetChildren()) do
		table.insert(pvplist, plr)
	end
	-- remove the people ACTUALLY in the shop
	for i, hit in pairs(simplehitbox) do
		local player = game.Players:GetPlayerFromCharacter(hit.Parent)
		for i, plr in pairs(pvplist) do
			if plr == player then
				table.remove(pvplist, i)
				task.spawn(function()
					task.wait(.5)
					local char = plr.Character
					if char then
						local ff = plr.Character:FindFirstChild("ForceField")
						if not ff then
							Instance.new("ForceField", plr.Character)
						end
					end
				end)

				plr.Fightable.Value = false
			end
		end
	end

	-- In theory pvplist should only consist of people not in the shop
	for i, plr in pairs(pvplist) do
		pcall(function()
			local ff = plr.Character:FindFirstChild("ForceField")
			if ff then
				ff:Destroy()
			end
			plr.Fightable.Value = true
		end)
		
	end

end

while task.wait(.5) do
	GetPlayers()
end
