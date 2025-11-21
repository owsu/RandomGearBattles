local plr = game.Players.LocalPlayer
local humanoid = plr.Character:FindFirstChild("Humanoid")
local actionservice = game:GetService("ContextActionService")
local lastkey = nil
local lasttimepressed = tick()

local events = game.ReplicatedStorage.Remotes.Events
local anims = game.ReplicatedStorage.Animations.Combat

local blockTrack = humanoid.Animator:LoadAnimation(anims.Blocking)
local unblockTrack = humanoid.Animator:LoadAnimation(anims.Unblock)
local punchRightTrack1 = humanoid.Animator:LoadAnimation(anims.RPunch1)
local punchLeftTrack1 = humanoid.Animator:LoadAnimation(anims.LPunch1)

local combo = 1
local m1Available = true

local function m1Swing(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin and m1Available then
		local tool = plr.Character:FindFirstChildOfClass("Tool")
		if not tool then
			m1Available = false
			local hand = nil
			if combo == 1 then
				hand = humanoid.Parent.RightHand
				combo = 2
				punchRightTrack1:Play()
			elseif combo == 2 then
				hand = humanoid.Parent.LeftHand
				combo = 1
				punchLeftTrack1:Play()
			end

			events.PunchEvent:FireServer(hand)
			blockTrack:Stop()
			events.BlockedEvent:FireServer(false, true)
			task.wait(.5)
			m1Available = true
		end
		
	end
end

local function Block(actionName, inputState, inputObject)
	
	if inputState == Enum.UserInputState.Begin then
		local tool = plr.Character:FindFirstChildOfClass("Tool")
		if not tool then
			events.BlockedEvent:FireServer(true, false)
			blockTrack:Play()
		end
	elseif inputState == Enum.UserInputState.End and humanoid:GetAttribute("Blocking") then
		blockTrack:Stop()
		unblockTrack:Play()
		events.BlockedEvent:FireServer(false, false)
	end
	
end

local function Run(actionName, inputState, inputObject)
	if inputState == Enum.UserInputState.Begin then
		events.SprintEvent:FireServer(true)
	elseif inputState == Enum.UserInputState.End and humanoid:GetAttribute("Running") then
		events.SprintEvent:FireServer(false)
	end
end



--[[
actionservice:BindAction("Punch", m1Swing, true, Enum.KeyCode.Q)
actionservice:SetPosition("Punch", UDim2.new(.8, 0, .1, 0))
actionservice:SetTitle("Punch", "Punch")

actionservice:BindAction("Block", Block, true, Enum.KeyCode.F)
actionservice:SetPosition("Block", UDim2.new(.8, 0, -.2, 0))
actionservice:SetTitle("Block", "Block")
]]

actionservice:BindAction("Run", Run, true, Enum.KeyCode.LeftControl)
actionservice:SetPosition("Run", UDim2.new(.8, 0, .1, 0)) -- used to be -.5
actionservice:SetTitle("Run", "Run")