

-- Initialize services and globals
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local SERVER_URL = "https://key.razzles.xyz"

-- Function to get user ID safely
local function getUserId()
	if player and player.UserId and player.UserId ~= 0 then
		return tostring(player.UserId)
	elseif player and player.Name and player.Name ~= "" then
		return "name:" .. player.Name
	else
		return "temp:" .. tostring(math.random(100000, 999999))
	end
end

-- HTTP request function using exploit request functions (same as loader)
local function makeHttpRequest(url, method, data)
	local httpRequest = nil

	-- Try to get the appropriate HTTP request function (same order as loader)
	if syn and syn.request then
		httpRequest = syn.request
	elseif http and http.request then
		httpRequest = http.request
	elseif http_request then
		httpRequest = http_request
	elseif request then
		httpRequest = request
	end

	if not httpRequest then
		-- Fallback to HttpService
		if method == "POST" and data then
			local success, response = pcall(function()
				return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
			end)
			if success then
				return response, 200
			else
				return nil, tostring(response)
			end
		end
		return nil, "HTTP request function not found"
	end

	local requestData = {
		Url = url,
		Method = method or "GET",
		Headers = {
			["Content-Type"] = "application/json",
			["User-Agent"] = "StarLifeFarmer/2.0",
		},
	}

	if data then
		requestData.Body = HttpService:JSONEncode(data)
	end

	local success, response = pcall(function()
		return httpRequest(requestData)
	end)

	if success and response then
		return response.Body, response.StatusCode
	else
		return nil, tostring(response)
	end
end

-- Anti-bypass protection - Check if loader authenticated this session
print("DEBUG: Checking loader authentication...")
print("  getgenv().StarLifeKey exists:", getgenv().StarLifeKey ~= nil)
if getgenv().StarLifeKey then
	print("  LoaderAuthenticated:", getgenv().StarLifeKey.LoaderAuthenticated)
	print("  SecurityToken:", getgenv().StarLifeKey.SecurityToken)
	print("  CurrentKey:", getgenv().StarLifeKey.CurrentKey ~= nil)
	print("  KeyVerified:", getgenv().StarLifeKey.KeyVerified)
end

if
	not getgenv().StarLifeKey
	or not getgenv().StarLifeKey.LoaderAuthenticated
	or not getgenv().StarLifeKey.SecurityToken
then
	local bypassReason = "Script executed without loader authentication"
	if not getgenv().StarLifeKey or not getgenv().StarLifeKey.SecurityToken then
		bypassReason = bypassReason .. " - Security token missing (possible tampering)"
	end -- Log the bypass attempt to the server
	pcall(function()
		makeHttpRequest(SERVER_URL .. "/log-bypass-attempt", "POST", {
			roblox_userid = getUserId(),
			reason = bypassReason,
			additional_info = "Direct script execution detected",
		})
	end)

	-- Kick the player for trying to bypass
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "🚫 Bypass Detected",
			Text = "Stop trying to bypass the key system! Use the proper loader.",
			Duration = 10,
		})
	end)

	warn("BYPASS ATTEMPT DETECTED: " .. bypassReason)

	-- Wait a moment for notification to show, then kick
	wait(2)

	-- Kick the player
	pcall(function()
		game.Players.LocalPlayer:Kick("🚫 Bypass Detected: Use the proper key system loader!")
	end)

	return -- Stop script execution
end

-- Verify we have a valid key before proceeding
print("DEBUG: Checking key verification...")
if getgenv().StarLifeKey then
	print("  CurrentKey exists:", getgenv().StarLifeKey.CurrentKey ~= nil)
	print("  KeyVerified:", getgenv().StarLifeKey.KeyVerified)
else
	print("  StarLifeKey table does not exist!")
end

if not getgenv().StarLifeKey or not getgenv().StarLifeKey.CurrentKey or not getgenv().StarLifeKey.KeyVerified then
	local HttpService = game:GetService("HttpService")
	local Players = game:GetService("Players")
	local player = Players.LocalPlayer
	local SERVER_URL = "https://key.razzles.xyz"

	-- Function to get user ID safely
	local function getUserId()
		if player and player.UserId and player.UserId ~= 0 then
			return tostring(player.UserId)
		elseif player and player.Name and player.Name ~= "" then
			return "name:" .. player.Name
		else
			return "temp:" .. tostring(math.random(100000, 999999))
		end
	end -- Log this as a potential bypass attempt (no key but script loaded)
	pcall(function()
		makeHttpRequest(SERVER_URL .. "/log-bypass-attempt", "POST", {
			roblox_userid = getUserId(),
			reason = "Script loaded without valid key - Possible key bypass or loader malfunction",
		})
	end)

	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "⚠️ No Valid Key",
			Text = "No valid key found. Please use the loader to authenticate.",
			Duration = 5,
		})
	end)
	warn("Star Life Farmer: No valid key found, script will not load")
	return
end

-- Global unload function for key system
getgenv().StarLifeFarmerUnload = function()
	-- Stop all farming loops
	if rareClickLoop then
		rareClickLoop = false
	end
	if presentClickLoop then
		presentClickLoop = false
	end
	if crystalClickLoop then
		crystalClickLoop = false
	end
	if npcKillLoop then
		npcKillLoop = false
	end
	if antiAfkEnabled then
		antiAfkEnabled = false
	end
	if crateSettings then
		crateSettings.common = false
		crateSettings.uncommon = false
		crateSettings.rare = false
	end

	-- Destroy UI
	if Rayfield then
		pcall(function()
			Rayfield:Destroy()
		end)
	end

	-- Reset authentication flag
	getgenv().StarLifeKey.LoaderAuthenticated = false

	-- Send notification
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Key System",
			Text = "Script unloaded - Key invalid or expired",
			Duration = 5,
		})
	end)

	warn("Star Life Farmer: Script unloaded due to key validation failure")
end

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local SERVER_URL = "https://key.razzles.xyz"

-- Send notification that script is loading
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "Star Life Farmer",
		Text = "Loading script with valid key...",
		Duration = 3,
	})
end)

-- Function to get user ID safely
local function getUserId()
	if player and player.UserId and player.UserId ~= 0 then
		return tostring(player.UserId)
	elseif player and player.Name and player.Name ~= "" then
		return "name:" .. player.Name
	else
		return "temp:" .. tostring(math.random(100000, 999999))
	end
end

-- Helper function for HTTP requests (same as loader)
-- Key verification function (same as loader)
local function verifyKey(keyToVerify)
	local responseBody, statusCode = makeHttpRequest(SERVER_URL .. "/verify-key", "POST", {
		key = keyToVerify,
		roblox_userid = getUserId(),
		exploit = "client-side",
	})

	if responseBody then
		local success, data = pcall(function()
			return HttpService:JSONDecode(responseBody)
		end)

		if success and data then
			return data.valid, data.reason
		else
			return false, "Invalid server response"
		end
	else
		return false, "Failed to connect to server: " .. tostring(statusCode)
	end
end

local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

-- Key system is now handled by loader.luau
-- The main script is loaded after successful key verification

local rareClickLoop = false
local presentClickLoop = false
local crystalClickLoop = false
local npcKillLoop = false
local antiAfkEnabled = false
local selectedNPC = nil
local crateSettings = {
	common = false,
	uncommon = false,
	rare = false,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Window = Rayfield:CreateWindow({
	Name = "Key System Farmer",
	Icon = 0,
	LoadingTitle = "Script is freaking Loading",
	LoadingSubtitle = "Please wait...",
	Theme = "Default",

	ToggleUIKeybind = "K",

	DisableRayfieldPrompts = false,
	DisableBuildWarnings = false,

	ConfigurationSaving = {
		Enabled = true,
		FolderName = nil,
		FileName = "AutoClicker",
	},

	Discord = {
		Enabled = false,
		Invite = "noinvitelink",
		RememberJoins = true,
	},

	KeySystem = false,
})

-- The unload function is no longer needed here as the loader handles it.

local CrateTab = Window:CreateTab("Crate Farm", 4483362458)
local ItemTab = Window:CreateTab("Items", 4483362458)
local CrystalTab = Window:CreateTab("Crystals", 4483362458)
local NPCTab = Window:CreateTab("NPC Kill", 4483362458)
local UtilityTab = Window:CreateTab("Utility", 4483362458)
local StatusTab = Window:CreateTab("Status", 4483362458)
local ControlTab = Window:CreateTab("Controls", 4483362458)

local function fireClickDetector(clickDetector)
	if not clickDetector or not clickDetector:IsA("ClickDetector") or not clickDetector.Parent then
		return false, "Invalid ClickDetector"
	end

	local success1, error1 = pcall(function()
		if fireclickdetector then
			fireclickdetector(clickDetector)
			return true
		end
		return false
	end)

	if success1 and error1 then
		return true, "fireclickdetector success"
	end

	local success2, error2 = pcall(function()
		if clickDetector.MouseClick then
			clickDetector.MouseClick:Fire(player)
			return true
		end
		return false
	end)

	if success2 and error2 then
		return true, "MouseClick event success"
	end

	local success3, error3 = pcall(function()
		if getconnections then
			local connections = getconnections(clickDetector.MouseClick)
			for _, connection in pairs(connections) do
				if connection.Function then
					connection.Function(player)
				end
			end
			return true
		end
		return false
	end)

	if success3 and error3 then
		return true, "getconnections success"
	end

	return false, string.format("All methods failed: %s, %s, %s", tostring(error1), tostring(error2), tostring(error3))
end

local function fireCrates()
	local success = 0
	local total = 0
	local errors = {}

	local mapFolder = workspace:FindFirstChild("map")
	if not mapFolder then
		warn("Auto-Clicker: map folder not found in workspace")
		return 0, 0
	end

	for _, folder in pairs(mapFolder:GetChildren()) do
		if folder.Name == "Folder" then
			for _, child in pairs(folder:GetChildren()) do
				local shouldClick = false

				if crateSettings.common and child.Name == "common" then
					shouldClick = true
				elseif crateSettings.uncommon and child.Name == "uncommon" then
					shouldClick = true
				elseif crateSettings.rare and child.Name == "rare" then
					shouldClick = true
				end

				if shouldClick and child:FindFirstChild("ClickDetector") then
					local clickDetector = child:FindFirstChild("ClickDetector")
					total = total + 1
					local clicked, errorMsg = fireClickDetector(clickDetector)
					if clicked then
						success = success + 1
					else
						table.insert(errors, child.Name .. ": " .. errorMsg)
					end
				end
			end
		end
	end

	if total == 0 and (crateSettings.common or crateSettings.uncommon or crateSettings.rare) then
		warn("Auto-Clicker: No selected crate types with ClickDetector found")
	end

	if #errors > 0 then
		warn("Auto-Clicker Crate Errors: " .. table.concat(errors, ", "))
	end

	return success, total
end

local function firePresents()
	local success = 0
	local total = 0
	local errors = {}

	local mapFolder = workspace:FindFirstChild("map")
	if not mapFolder then
		warn("Auto-Clicker: map folder not found in workspace")
		return 0, 0
	end

	for _, folder in pairs(mapFolder:GetChildren()) do
		if folder.Name == "Folder" then
			for _, child in pairs(folder:GetChildren()) do
				if child.Name == "present" and child:FindFirstChild("ClickDetector") then
					local clickDetector = child:FindFirstChild("ClickDetector")
					total = total + 1
					local clicked, errorMsg = fireClickDetector(clickDetector)
					if clicked then
						success = success + 1
					else
						table.insert(errors, "Present: " .. errorMsg)
					end
				end
			end
		end
	end

	if total == 0 then
		warn("Auto-Clicker: No present items with ClickDetector found")
	end

	if #errors > 0 then
		warn("Auto-Clicker Present Errors: " .. table.concat(errors, ", "))
	end

	return success, total
end

local function fireCrystals()
	local success = 0
	local total = 0
	local errors = {}

	local mapFolder = workspace:FindFirstChild("map")
	if not mapFolder then
		warn("Auto-Clicker: map folder not found in workspace")
		return 0, 0
	end

	local planets = mapFolder:FindFirstChild("Planets")
	if not planets then
		warn("Auto-Clicker: Planets folder not found in map")
		return 0, 0
	end

	local arcannian = planets:FindFirstChild("Arcannian")
	if not arcannian then
		warn("Auto-Clicker: Arcannian not found in Planets")
		return 0, 0
	end

	local crystalFolder = arcannian:FindFirstChild("crystal")
	if not crystalFolder then
		warn("Auto-Clicker: crystal folder not found in Arcannian")
		return 0, 0
	end

	for _, child in pairs(crystalFolder:GetChildren()) do
		if child.Name == "crystal" and child:FindFirstChild("ClickDetector") then
			local clickDetector = child:FindFirstChild("ClickDetector")
			total = total + 1
			local clicked, errorMsg = fireClickDetector(clickDetector)
			if clicked then
				success = success + 1
			else
				table.insert(errors, child.Name .. ": " .. errorMsg)
			end
		end
	end

	if total == 0 then
		warn("Auto-Clicker: No crystal items with ClickDetector found")
	end

	if #errors > 0 then
		warn("Auto-Clicker Crystal Errors: " .. table.concat(errors, ", "))
	end

	return success, total
end

local function killNPC()
	local success = 0
	local total = 0
	local errors = {}

	if not selectedNPC or selectedNPC == "No NPCs Found" then
		return 0, 0
	end

	local npcFolder = workspace:FindFirstChild("npc")
	if not npcFolder then
		warn("Auto-Clicker: npc folder not found in workspace")
		return 0, 0
	end

	for _, npc in pairs(npcFolder:GetChildren()) do
		if npc:IsA("Model") and npc.Name == selectedNPC then
			local humanoid = npc:FindFirstChild("Humanoid")
			if humanoid then
				total = total + 1
				local killSuccess, killError = pcall(function()
					humanoid.Health = 0
				end)
				if killSuccess then
					success = success + 1
				else
					table.insert(errors, "Kill failed: " .. tostring(killError))
				end
			end
		end
	end

	if #errors > 0 then
		warn("Auto-Clicker NPC Kill Errors: " .. table.concat(errors, ", "))
	end

	return success, total
end

local function getNPCList()
	local npcList = {}
	local npcFolder = workspace:FindFirstChild("npc")
	if npcFolder then
		for _, npc in pairs(npcFolder:GetChildren()) do
			if npc:IsA("Model") and npc:FindFirstChild("Humanoid") then
				table.insert(npcList, npc.Name)
			end
		end
	end
	if #npcList == 0 then
		table.insert(npcList, "No NPCs Found")
	end
	return npcList
end

local function enableAntiAFK()
	local GC = getconnections or get_signal_cons
	if GC then
		for i, v in pairs(GC(Players.LocalPlayer.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end
		warn("Auto-Clicker: Anti-AFK enabled using getconnections method")
	else
		local VirtualUser = cloneref(game:GetService("VirtualUser"))
		Players.LocalPlayer.Idled:Connect(function()
			if antiAfkEnabled then
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end
		end)
		warn("Auto-Clicker: Anti-AFK enabled using VirtualUser method")
	end
end

local CrateSection = CrateTab:CreateSection("Crate Types")

local CommonToggle = CrateTab:CreateToggle({
	Name = "Farm Common Crates",
	CurrentValue = false,
	Flag = "CommonCrates",
	Callback = function(Value)
		crateSettings.common = Value
		if Value then
			Rayfield:Notify({
				Title = "Common Crates",
				Content = "Common crate farming enabled",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

local UncommonToggle = CrateTab:CreateToggle({
	Name = "Farm Uncommon Crates",
	CurrentValue = false,
	Flag = "UncommonCrates",
	Callback = function(Value)
		crateSettings.uncommon = Value
		if Value then
			Rayfield:Notify({
				Title = "Uncommon Crates",
				Content = "Uncommon crate farming enabled",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

local RareToggle = CrateTab:CreateToggle({
	Name = "Farm Rare Crates",
	CurrentValue = false,
	Flag = "RareCrates",
	Callback = function(Value)
		crateSettings.rare = Value
		if Value then
			Rayfield:Notify({
				Title = "Rare Crates",
				Content = "Rare crate farming enabled",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

local ItemSection = ItemTab:CreateSection("Item Farming")

local PresentToggle = ItemTab:CreateToggle({
	Name = "Farm Presents",
	CurrentValue = false,
	Flag = "Presents",
	Callback = function(Value)
		presentClickLoop = Value
		if Value then
			Rayfield:Notify({
				Title = "Presents",
				Content = "Present farming enabled",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

local CrystalSection = CrystalTab:CreateSection("Crystal Operations")

local CrystalOnceButton = CrystalTab:CreateButton({
	Name = "Fire Crystals Once",
	Callback = function()
		local success, total = fireCrystals()
		Rayfield:Notify({
			Title = "Crystal Fire Complete",
			Content = string.format("Fired: %d/%d crystals", success, total),
			Duration = 4,
			Image = 4483362458,
		})
	end,
})

local CrystalToggle = CrystalTab:CreateToggle({
	Name = "Auto Crystal Loop",
	CurrentValue = false,
	Flag = "CrystalLoop",
	Callback = function(Value)
		crystalClickLoop = Value
		if Value then
			Rayfield:Notify({
				Title = "Crystal Loop",
				Content = "Crystal auto-loop enabled",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

local NPCSection = NPCTab:CreateSection("NPC Selection")

local NPCDropdown = NPCTab:CreateDropdown({
	Name = "Select NPC to Kill",
	Options = getNPCList(),
	CurrentOption = { "No NPCs Found" },
	MultipleOptions = false,
	Flag = "NPCSelection",
	Callback = function(Options)
		selectedNPC = Options[1]
		if selectedNPC ~= "No NPCs Found" then
			Rayfield:Notify({
				Title = "NPC Selected",
				Content = "Selected: " .. selectedNPC,
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

local RefreshNPCButton = NPCTab:CreateButton({
	Name = "Refresh NPC List",
	Callback = function()
		local newList = getNPCList()
		NPCDropdown:Refresh(newList)
		Rayfield:Notify({
			Title = "NPC List",
			Content = "NPC list refreshed",
			Duration = 2,
			Image = 4483362458,
		})
	end,
})

local NPCKillToggle = NPCTab:CreateToggle({
	Name = "Auto Kill Selected NPC",
	CurrentValue = false,
	Flag = "NPCKill",
	Callback = function(Value)
		npcKillLoop = Value
		if Value then
			if selectedNPC and selectedNPC ~= "No NPCs Found" then
				Rayfield:Notify({
					Title = "NPC Auto Kill",
					Content = "Auto killing " .. selectedNPC .. " enabled",
					Duration = 3,
					Image = 4483362458,
				})
			else
				Rayfield:Notify({
					Title = "Warning",
					Content = "No NPC selected!",
					Duration = 3,
					Image = 4483362458,
				})
				npcKillLoop = false
			end
		end
	end,
})

local UtilitySection = UtilityTab:CreateSection("Utility Features")

local AntiAFKToggle = UtilityTab:CreateToggle({
	Name = "Anti-AFK",
	CurrentValue = false,
	Flag = "AntiAFK",
	Callback = function(Value)
		antiAfkEnabled = Value
		if Value then
			enableAntiAFK()
			Rayfield:Notify({
				Title = "Anti-AFK",
				Content = "Anti-AFK is now enabled",
				Duration = 3,
				Image = 4483362458,
			})
		else
			Rayfield:Notify({
				Title = "Anti-AFK",
				Content = "Anti-AFK is now disabled",
				Duration = 3,
				Image = 4483362458,
			})
		end
	end,
})

local ControlSection = ControlTab:CreateSection("Script Controls")

local StopAllButton = ControlTab:CreateButton({
	Name = "Stop All Functions",
	Callback = function()
		rareClickLoop = false
		presentClickLoop = false
		crystalClickLoop = false
		npcKillLoop = false
		antiAfkEnabled = false
		crateSettings.common = false
		crateSettings.uncommon = false
		crateSettings.rare = false

		CommonToggle:Set(false)
		UncommonToggle:Set(false)
		RareToggle:Set(false)
		PresentToggle:Set(false)
		CrystalToggle:Set(false)
		NPCKillToggle:Set(false)
		AntiAFKToggle:Set(false)

		Rayfield:Notify({
			Title = "All Stopped",
			Content = "All functions have been stopped",
			Duration = 4,
			Image = 4483362458,
		})
		warn("Auto-Clicker: All functions stopped by user")
	end,
})

local UnloadButton = ControlTab:CreateButton({
	Name = "Unload Script",
	Callback = function()
		rareClickLoop = false
		presentClickLoop = false
		crystalClickLoop = false
		npcKillLoop = false
		antiAfkEnabled = false
		crateSettings.common = false
		crateSettings.uncommon = false
		crateSettings.rare = false

		warn("Auto-Clicker: Script unloaded, all functions stopped")

		Rayfield:Destroy()
	end,
})

local StatusSection = StatusTab:CreateSection("Current Status")
local StatusLabel = StatusTab:CreateLabel("Status: Ready")

local lastCrateClick = 0
local lastPresentClick = 0
local lastCrystalClick = 0
local lastNPCKill = 0
local clickDelay = 0.5

RunService.Heartbeat:Connect(function()
	local currentTime = tick()
	local statusLines = {}
	local activeCount = 0

	if
		(crateSettings.common or crateSettings.uncommon or crateSettings.rare)
		and currentTime - lastCrateClick >= clickDelay
	then
		lastCrateClick = currentTime
		local success, total = fireCrates()
		if total > 0 then
			activeCount = activeCount + 1
			table.insert(statusLines, string.format("Crates: %d/%d", success, total))
		end
	end

	if presentClickLoop and currentTime - lastPresentClick >= clickDelay then
		lastPresentClick = currentTime
		local success, total = firePresents()
		if total > 0 then
			activeCount = activeCount + 1
			table.insert(statusLines, string.format("Presents: %d/%d", success, total))
		end
	end

	if crystalClickLoop and currentTime - lastCrystalClick >= clickDelay then
		lastCrystalClick = currentTime
		local success, total = fireCrystals()
		if total > 0 then
			activeCount = activeCount + 1
			table.insert(statusLines, string.format("Crystals: %d/%d", success, total))
		end
	end

	if npcKillLoop and currentTime - lastNPCKill >= clickDelay then
		lastNPCKill = currentTime
		local success, total = killNPC()
		if total > 0 then
			activeCount = activeCount + 1
			table.insert(statusLines, string.format("NPCs: %d/%d", success, total))
		end
	end

	local statusText = ""
	if activeCount > 0 then
		statusText = "Status: Active - " .. table.concat(statusLines, " | ")
	else
		statusText = "Status: Ready - Waiting for commands..."
	end

	if antiAfkEnabled then
		statusText = statusText .. " | Anti-AFK: ON"
	end

	StatusLabel:Set(statusText)
end)

-- Load configuration
Rayfield:LoadConfiguration()

-- Continuous key verification (every 5 minutes)
coroutine.wrap(function()
	while wait(300) do -- Check every 5 minutes
		if getgenv().StarLifeKey and getgenv().StarLifeKey.CurrentKey then
			local isValid, reason = verifyKey(getgenv().StarLifeKey.CurrentKey)
			if not isValid then
				warn("Star Life Farmer: Key verification failed - " .. tostring(reason))
				if getgenv().StarLifeFarmerUnload then
					getgenv().StarLifeFarmerUnload()
				end
				-- Show key UI again
				if getgenv().ShowKeyUI then
					getgenv().ShowKeyUI()
				end
				break
			end
		else
			-- No key found, unload
			if getgenv().StarLifeFarmerUnload then
				getgenv().StarLifeFarmerUnload()
			end
			break
		end
	end
end)()

warn("Star Life Farmer loaded successfully with valid key!")
warn(
	"Available functions: fireclickdetector="
		.. tostring(fireclickdetector ~= nil)
		.. ", getconnections="
		.. tostring(getconnections ~= nil)
)

-- Send final notification
pcall(function()
	StarterGui:SetCore("SendNotification", {
		Title = "Star Life Farmer",
		Text = "Script loaded successfully! Use 'K' to toggle UI.",
		Duration = 5,
	})
end)
