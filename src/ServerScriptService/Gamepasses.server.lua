local mps = game:GetService("MarketplaceService")
local player = game:GetService("Players")

local productFunctions = {}

productFunctions[1264184734] = function(receipt, player) -- Buys Instant Roll
	player.playerstats.Quickroll.Value = true
end

productFunctions[3312266187] = function(receipt, player)  -- Buys Alpha Sword
	player.Inventory.AlphaSword.Value += 1
	print("Bought Alpha Sword")
end

-- CASH MICROTRANSCATIONS
productFunctions[3312217391] = function(receipt, player) 
	player.playerstats.Cash.Value += 1000
	print("Bought 100 cash")
end

productFunctions[3312217769] = function(receipt, player) 
	player.playerstats.Cash.Value += 5000
	print("Bought 1000 cash")
end

productFunctions[3312219202] = function(receipt, player) 
	player.playerstats.Cash.Value += 10000
	print("Bought 5000 cash")
end

productFunctions[3312219521] = function(receipt, player) 
	player.playerstats.Cash.Value += 50000
	print("Bought 10000 cash")
end
-- XP MICROTRANSCATIONS
productFunctions[3312223632] = function(receipt, player) 
	player.playerstats.XP.Value += 250
	print("Bought 30 XP")
end

productFunctions[3312223785] = function(receipt, player) 
	player.playerstats.XP.Value += 1250
	print("Bought 300 XP")
end

productFunctions[3312223933] = function(receipt, player) 
	player.playerstats.XP.Value += 2500
	print("Bought 1500 XP")
end

productFunctions[3312224077] = function(receipt, player) 
	player.playerstats.XP.Value += 12500
	print("Bought 3000 XP")
end

productFunctions[3321272185] = function(receipt, player) 
	player.playerstats.ResetStats.Value += 1
	print("Bought RESET STATS")
end



local function processReceipt(receiptInfo)
	local userId = receiptInfo.PlayerId
	local productId = receiptInfo.ProductId

	local player = player:GetPlayerByUserId(userId)
	if player then
		local handler = productFunctions[productId]
		local success, result = pcall(handler, receiptInfo, player)
		if success then
			return Enum.ProductPurchaseDecision.PurchaseGranted
		else
			warn("Failed to process receipt:", receiptInfo, result)
		end
	end

	return Enum.ProductPurchaseDecision.NotProcessedYet
end

mps.ProcessReceipt = processReceipt