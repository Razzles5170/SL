local function decode(str)
	local result = ""
	for i = 1, #str do
		result = result .. string.char(string.byte(str, i) - 1)
	end
	return result
end

local function e(str)
	local result = ""
	for i = 1, #str do
		result = result .. string.char(string.byte(str, i) + 1)
	end
	return result
end

local o = {
	[e("hbnf")] = game,
	[e("hfuTfswjdf")] = function(s)
		return game:GetService(s)
	end,
	[e("IuuqTfswjdf")] = game:GetService("HttpService"),
	[e("Qmbzfst")] = game:GetService("Players"),
	[e("TubsufsHvj")] = game:GetService("StarterGui"),
	[e("SvoTfswjdf")] = game:GetService("RunService"),
	[e("xpslTqbdf")] = workspace,
	[e("MpdbmQmbzfs")] = game:GetService("Players").LocalPlayer,
	[e("VtfsJe")] = game:GetService("Players").LocalPlayer.UserId,
	[e("xbjo")] = warn,
	[e("xbju")] = wait,
	[e("qdbmm")] = pcall,
	[e("tusjohhbnf")] = string.char,
	[e("ujdl")] = tick,
	[e("dpspvujofxsbq")] = coroutine.wrap,
	[e("mpbetusjoh")] = loadstring,
	[e("IuuqHfu")] = function(url)
		return game:HttpGet(url)
	end,
	[e("tusjohgpsnbu")] = string.format,
	[e("qbjst")] = pairs,
	[e("ubcmfjotfsu")] = table.insert,
	[e("ubcmfdpodbu")] = table.concat,
	[e("tubsufsHvjTfuDpsf")] = function(a, b)
		return game:GetService("StarterGui"):SetCore(a, b)
	end,
	[e("gjsfdmjdlefufdups")] = function(cd)
		if fireclickdetector then
			return fireclickdetector(cd)
		end
	end,
	[e("hfudpoofdujpot")] = function(signal)
		if getconnections then
			return getconnections(signal)
		end
	end,
	[e("dmpofsfg")] = function(obj)
		if cloneref then
			return cloneref(obj)
		else
			return obj
		end
	end,
	[e("GjoeGjstuDijme")] = function(obj, name)
		return obj:FindFirstChild(name)
	end,
	[e("HfuDijmesfo")] = function(obj)
		return obj:GetChildren()
	end,
	[e("JtB")] = function(obj, class)
		return obj:IsA(class)
	end,
}

local p = {
	[e("bvuifo")] = "_G.LoaderAuthenticated",
	[e("tfdvsf")] = "_G.SecurityToken",
	[e("lfz")] = "_G.CurrentKey",
	[e("wfsjgz")] = "_G.KeyVerified",
	[e("vompe")] = "_G.StarLifeFarmerUnload",
	[e("tipxlfz")] = "_G.ShowKeyUI",
	[e("tfswfs")] = "https://key.razzles.xyz",
}

-- Check if loader authenticated this session
if not _G.LoaderAuthenticated or not _G.SecurityToken then
	local u = tostring(o[e("VtfsJe")])
	local v = decode(p[e("tfswfs")])
	local w = decode("Script executed without loader authentication")

	if not _G.SecurityToken then
		w = w .. " - Security token missing (possible tampering)"
	end

	o[e("qdbmm")](function()
		game:HttpPost(
			v .. "/log-bypass-attempt",
			o[e("IuuqTfswjdf")]:JSONEncode({
				roblox_id = u,
				reason = w,
				additional_info = "Direct script execution detected",
			}),
			true,
			"application/json"
		)
	end)

	o[e("qdbmm")](function()
		o[e("tubsufsHvjTfuDpsf")]("SendNotification", {
			Title = "🚫 Bypass Detected",
			Text = "Stop trying to bypass the key system! Use the proper loader.",
			Duration = 10,
		})
	end)

	o[e("xbjo")]("BYPASS ATTEMPT DETECTED: " .. w)

	o[e("xbju")](2)

	o[e("qdbmm")](function()
		o[e("MpdbmQmbzfs")]:Kick("🚫 Bypass Detected: Use the proper key system loader!")
	end)

	return
end

-- Verify we have a valid key before proceeding
if not _G.CurrentKey or not _G.KeyVerified then
	local u = tostring(o[e("VtfsJe")])
	local v = decode(p[e("tfswfs")])

	o[e("qdbmm")](function()
		game:HttpPost(
			v .. "/log-bypass-attempt",
			o[e("IuuqTfswjdf")]:JSONEncode({
				roblox_id = u,
				reason = "Script loaded without valid key - Possible key bypass or loader malfunction",
			}),
			true,
			"application/json"
		)
	end)

	o[e("qdbmm")](function()
		o[e("tubsufsHvjTfuDpsf")]("SendNotification", {
			Title = "⚠️ No Valid Key",
			Text = "No valid key found. Please use the loader to authenticate.",
			Duration = 5,
		})
	end)

	o[e("xbjo")]("Star Life Farmer: No valid key found, script will not load")
	return
end

-- Global unload function for key system
_G.StarLifeFarmerUnload = function()
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

	if Rayfield then
		o[e("qdbmm")](function()
			Rayfield:Destroy()
		end)
	end

	_G.LoaderAuthenticated = false

	o[e("qdbmm")](function()
		o[e("tubsufsHvjTfuDpsf")]("SendNotification", {
			Title = "Key System",
			Text = "Script unloaded - Key invalid or expired",
			Duration = 5,
		})
	end)

	o[e("xbjo")]("Star Life Farmer: Script unloaded due to key validation failure")
end

local x = o[e("MpdbmQmbzfs")]
local y = decode(p[e("tfswfs")])

o[e("qdbmm")](function()
	o[e("tubsufsHvjTfuDpsf")]("SendNotification", {
		Title = "Star Life Farmer",
		Text = "Loading script with valid key...",
		Duration = 3,
	})
end)

-- Key verification function
local function verifyKey(keyToVerify)
	local success, response = o[e("qdbmm")](function()
		return game:HttpPost(
			y .. "/verify-key",
			o[e("IuuqTfswjdf")]:JSONEncode({
				key = keyToVerify,
				roblox_id = tostring(x.UserId),
			}),
			true,
			"application/json"
		)
	end)

	if success then
		local data = o[e("IuuqTfswjdf")]:JSONDecode(response)
		return data.valid, data.reason
	else
		return false, "Failed to connect to server: " .. tostring(response)
	end
end

-- Continuous key verification
o[e("dpspvujofxsbq")](function()
	while o[e("xbju")](300) do
		if _G.CurrentKey then
			local isValid, reason = verifyKey(_G.CurrentKey)
			if not isValid then
				o[e("xbjo")]("Star Life Farmer: Key verification failed - " .. tostring(reason))
				if _G.StarLifeFarmerUnload then
					_G.StarLifeFarmerUnload()
				end
				if _G.ShowKeyUI then
					_G.ShowKeyUI()
				end
				break
			end
		else
			if _G.StarLifeFarmerUnload then
				_G.StarLifeFarmerUnload()
			end
			break
		end
	end
end)()

local Rayfield = o[e("mpbetusjoh")](game:HttpGet("https://sirius.menu/rayfield"))()

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

	local success1, error1 = o[e("qdbmm")](function()
		if o[e("gjsfdmjdlefufdups")] then
			o[e("gjsfdmjdlefufdups")](clickDetector)
			return true
		end
		return false
	end)

	if success1 and error1 then
		return true, "fireclickdetector success"
	end

	local success2, error2 = o[e("qdbmm")](function()
		if clickDetector.MouseClick then
			clickDetector.MouseClick:Fire(x)
			return true
		end
		return false
	end)

	if success2 and error2 then
		return true, "MouseClick event success"
	end

	local success3, error3 = o[e("qdbmm")](function()
		if o[e("hfudpoofdujpot")] then
			local connections = o[e("hfudpoofdujpot")](clickDetector.MouseClick)
			for _, connection in o[e("qbjst")](connections) do
				if connection.Function then
					connection.Function(x)
				end
			end
			return true
		end
		return false
	end)

	if success3 and error3 then
		return true, "getconnections success"
	end

	return false,
		o[e("tusjohgpsnbu")]("All methods failed: %s, %s, %s", tostring(error1), tostring(error2), tostring(error3))
end

local function fireCrates()
	local success = 0
	local total = 0
	local errors = {}

	local mapFolder = o[e("GjoeGjstuDijme")](o[e("xpslTqbdf")], "map")
	if not mapFolder then
		o[e("xbjo")]("Auto-Clicker: map folder not found in workspace")
		return 0, 0
	end

	for _, folder in o[e("qbjst")](o[e("HfuDijmesfo")](mapFolder)) do
		if folder.Name == "Folder" then
			for _, child in o[e("qbjst")](o[e("HfuDijmesfo")](folder)) do
				local shouldClick = false

				if crateSettings.common and child.Name == "common" then
					shouldClick = true
				elseif crateSettings.uncommon and child.Name == "uncommon" then
					shouldClick = true
				elseif crateSettings.rare and child.Name == "rare" then
					shouldClick = true
				end

				if shouldClick and o[e("GjoeGjstuDijme")](child, "ClickDetector") then
					local clickDetector = o[e("GjoeGjstuDijme")](child, "ClickDetector")
					total = total + 1
					local clicked, errorMsg = fireClickDetector(clickDetector)
					if clicked then
						success = success + 1
					else
						o[e("ubcmfjotfsu")](errors, child.Name .. ": " .. errorMsg)
					end
				end
			end
		end
	end

	if total == 0 and (crateSettings.common or crateSettings.uncommon or crateSettings.rare) then
		o[e("xbjo")]("Auto-Clicker: No selected crate types with ClickDetector found")
	end

	if #errors > 0 then
		o[e("xbjo")]("Auto-Clicker Crate Errors: " .. o[e("ubcmfdpodbu")](errors, ", "))
	end

	return success, total
end

local function firePresents()
	local success = 0
	local total = 0
	local errors = {}

	local mapFolder = o[e("GjoeGjstuDijme")](o[e("xpslTqbdf")], "map")
	if not mapFolder then
		o[e("xbjo")]("Auto-Clicker: map folder not found in workspace")
		return 0, 0
	end

	for _, folder in o[e("qbjst")](o[e("HfuDijmesfo")](mapFolder)) do
		if folder.Name == "Folder" then
			for _, child in o[e("qbjst")](o[e("HfuDijmesfo")](folder)) do
				if child.Name == "present" and o[e("GjoeGjstuDijme")](child, "ClickDetector") then
					local clickDetector = o[e("GjoeGjstuDijme")](child, "ClickDetector")
					total = total + 1
					local clicked, errorMsg = fireClickDetector(clickDetector)
					if clicked then
						success = success + 1
					else
						o[e("ubcmfjotfsu")](errors, "Present: " .. errorMsg)
					end
				end
			end
		end
	end

	if total == 0 then
		o[e("xbjo")]("Auto-Clicker: No present items with ClickDetector found")
	end

	if #errors > 0 then
		o[e("xbjo")]("Auto-Clicker Present Errors: " .. o[e("ubcmfdpodbu")](errors, ", "))
	end

	return success, total
end

local function fireCrystals()
	local success = 0
	local total = 0
	local errors = {}

	local mapFolder = o[e("GjoeGjstuDijme")](o[e("xpslTqbdf")], "map")
	if not mapFolder then
		o[e("xbjo")]("Auto-Clicker: map folder not found in workspace")
		return 0, 0
	end

	local planets = o[e("GjoeGjstuDijme")](mapFolder, "Planets")
	if not planets then
		o[e("xbjo")]("Auto-Clicker: Planets folder not found in map")
		return 0, 0
	end

	local arcannian = o[e("GjoeGjstuDijme")](planets, "Arcannian")
	if not arcannian then
		o[e("xbjo")]("Auto-Clicker: Arcannian not found in Planets")
		return 0, 0
	end

	local crystalFolder = o[e("GjoeGjstuDijme")](arcannian, "crystal")
	if not crystalFolder then
		o[e("xbjo")]("Auto-Clicker: crystal folder not found in Arcannian")
		return 0, 0
	end

	for _, child in o[e("qbjst")](o[e("HfuDijmesfo")](crystalFolder)) do
		if child.Name == "crystal" and o[e("GjoeGjstuDijme")](child, "ClickDetector") then
			local clickDetector = o[e("GjoeGjstuDijme")](child, "ClickDetector")
			total = total + 1
			local clicked, errorMsg = fireClickDetector(clickDetector)
			if clicked then
				success = success + 1
			else
				o[e("ubcmfjotfsu")](errors, child.Name .. ": " .. errorMsg)
			end
		end
	end

	if total == 0 then
		o[e("xbjo")]("Auto-Clicker: No crystal items with ClickDetector found")
	end

	if #errors > 0 then
		o[e("xbjo")]("Auto-Clicker Crystal Errors: " .. o[e("ubcmfdpodbu")](errors, ", "))
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

	local npcFolder = o[e("GjoeGjstuDijme")](o[e("xpslTqbdf")], "npc")
	if not npcFolder then
		o[e("xbjo")]("Auto-Clicker: npc folder not found in workspace")
		return 0, 0
	end

	for _, npc in o[e("qbjst")](o[e("HfuDijmesfo")](npcFolder)) do
		if o[e("JtB")](npc, "Model") and npc.Name == selectedNPC then
			local humanoid = o[e("GjoeGjstuDijme")](npc, "Humanoid")
			if humanoid then
				total = total + 1
				local killSuccess, killError = o[e("qdbmm")](function()
					humanoid.Health = 0
				end)
				if killSuccess then
					success = success + 1
				else
					o[e("ubcmfjotfsu")](errors, "Kill failed: " .. tostring(killError))
				end
			end
		end
	end

	if #errors > 0 then
		o[e("xbjo")]("Auto-Clicker NPC Kill Errors: " .. o[e("ubcmfdpodbu")](errors, ", "))
	end

	return success, total
end

local function getNPCList()
	local npcList = {}
	local npcFolder = o[e("GjoeGjstuDijme")](o[e("xpslTqbdf")], "npc")
	if npcFolder then
		for _, npc in o[e("qbjst")](o[e("HfuDijmesfo")](npcFolder)) do
			if o[e("JtB")](npc, "Model") and o[e("GjoeGjstuDijme")](npc, "Humanoid") then
				o[e("ubcmfjotfsu")](npcList, npc.Name)
			end
		end
	end
	if #npcList == 0 then
		o[e("ubcmfjotfsu")](npcList, "No NPCs Found")
	end
	return npcList
end

local function enableAntiAFK()
	local GC = o[e("hfudpoofdujpot")] or function()
		return {}
	end
	if GC then
		for i, v in o[e("qbjst")](GC(x.Idled)) do
			if v["Disable"] then
				v["Disable"](v)
			elseif v["Disconnect"] then
				v["Disconnect"](v)
			end
		end
		o[e("xbjo")]("Auto-Clicker: Anti-AFK enabled using getconnections method")
	else
		local VirtualUser = o[e("dmpofsfg")](o[e("hfuTfswjdf")]("VirtualUser"))
		x.Idled:Connect(function()
			if antiAfkEnabled then
				VirtualUser:CaptureController()
				VirtualUser:ClickButton2(Vector2.new())
			end
		end)
		o[e("xbjo")]("Auto-Clicker: Anti-AFK enabled using VirtualUser method")
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
			Content = o[e("tusjohgpsnbu")]("Fired: %d/%d crystals", success, total),
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
		o[e("xbjo")]("Auto-Clicker: All functions stopped by user")
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

		o[e("xbjo")]("Auto-Clicker: Script unloaded, all functions stopped")

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

o[e("SvoTfswjdf")].Heartbeat:Connect(function()
	local currentTime = o[e("ujdl")]()
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
			o[e("ubcmfjotfsu")](statusLines, o[e("tusjohgpsnbu")]("Crates: %d/%d", success, total))
		end
	end

	if presentClickLoop and currentTime - lastPresentClick >= clickDelay then
		lastPresentClick = currentTime
		local success, total = firePresents()
		if total > 0 then
			activeCount = activeCount + 1
			o[e("ubcmfjotfsu")](statusLines, o[e("tusjohgpsnbu")]("Presents: %d/%d", success, total))
		end
	end

	if crystalClickLoop and currentTime - lastCrystalClick >= clickDelay then
		lastCrystalClick = currentTime
		local success, total = fireCrystals()
		if total > 0 then
			activeCount = activeCount + 1
			o[e("ubcmfjotfsu")](statusLines, o[e("tusjohgpsnbu")]("Crystals: %d/%d", success, total))
		end
	end

	if npcKillLoop and currentTime - lastNPCKill >= clickDelay then
		lastNPCKill = currentTime
		local success, total = killNPC()
		if total > 0 then
			activeCount = activeCount + 1
			o[e("ubcmfjotfsu")](statusLines, o[e("tusjohgpsnbu")]("NPCs: %d/%d", success, total))
		end
	end

	local statusText = ""
	if activeCount > 0 then
		statusText = "Status: Active - " .. o[e("ubcmfdpodbu")](statusLines, " | ")
	else
		statusText = "Status: Ready - Waiting for commands..."
	end

	if antiAfkEnabled then
		statusText = statusText .. " | Anti-AFK: ON"
	end

	StatusLabel:Set(statusText)
end)

Rayfield:LoadConfiguration()

o[e("xbjo")]("Star Life Farmer loaded successfully with valid key!")
o[e("xbjo")](
	"Available functions: fireclickdetector="
		.. tostring(o[e("gjsfdmjdlefufdups")] ~= nil)
		.. ", getconnections="
		.. tostring(o[e("hfudpoofdujpot")] ~= nil)
)

o[e("qdbmm")](function()
	o[e("tubsufsHvjTfuDpsf")]("SendNotification", {
		Title = "Star Life Farmer",
		Text = "Script loaded successfully! Use 'K' to toggle UI.",
		Duration = 5,
	})
end)
