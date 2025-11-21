local player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera

local fovLoop = game:GetService("RunService").RenderStepped:Connect(function()
	Camera.FieldOfView = 90
end)

-- high other people

for i,plr in pairs(game.Players:GetChildren()) do
	if plr.Character then
		local highlight = Instance.new("Highlight", plr.Character)
		highlight.FillTransparency = 1
		if plr == game.Players.LocalPlayer then
			highlight.OutlineColor = Color3.new(0, 0.333333, 0)
		else
			highlight.OutlineColor = Color3.new(0.333333, 0, 0)
		end
		highlight.OutlineTransparency = .5
		
		
	end
end

player.Character.Humanoid.Died:connect(function()
	local gui = player.PlayerGui.Main:FindFirstChild("Ingame")
	-- uneqip weapons
	game.ReplicatedStorage.Remotes.Events.ItemEquipped:FireServer(false, gui.Hotbar.Button1:GetAttribute("Item"), gui.Hotbar.Button1)
	game.ReplicatedStorage.Remotes.Events.ItemEquipped:FireServer(false, gui.Hotbar.Button2:GetAttribute("Item"), gui.Hotbar.Button2)
end)

