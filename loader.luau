

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local SERVER_URL = "https://key.razzles.xyz" -- server URL

-- Detect exploit environment and get appropriate functions
local exploitFunctions = {}

-- HTTP Request function detection
if syn and syn.request then
	exploitFunctions.httpRequest = syn.request
elseif http and http.request then
	exploitFunctions.httpRequest = http.request
elseif http_request then
	exploitFunctions.httpRequest = http_request
elseif request then
	exploitFunctions.httpRequest = request
end

-- Clipboard function detection
if syn and syn.write_clipboard then
	exploitFunctions.setClipboard = syn.write_clipboard
elseif setclipboard then
	exploitFunctions.setClipboard = setclipboard
elseif toclipboard then
	exploitFunctions.setClipboard = toclipboard
elseif set_clipboard then
	exploitFunctions.setClipboard = set_clipboard
end

-- Loadstring detection
if loadstring then
	exploitFunctions.loadstring = loadstring
elseif load then
	exploitFunctions.loadstring = load
end

-- Global variables for script management
getgenv().StarLifeKey = {
	CurrentKey = nil,
	KeyVerified = false,
	ScriptLoaded = false,
	LoaderAuthenticated = true,
	SecurityToken = tostring(math.random(1000000, 9999999)),
}

local function sendNotification(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 5,
		})
	end)
end

local function makeHttpRequest(url, method, data)
	if not exploitFunctions.httpRequest then
		warn("No HTTP request function available!")
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
		requestData.Body = game:GetService("HttpService"):JSONEncode(data)
	end

	local success, response = pcall(function()
		return exploitFunctions.httpRequest(requestData)
	end)

	if success and response then
		return response.Body, response.StatusCode
	else
		return nil, tostring(response)
	end
end

-- Function to get user ID with fallbacks including Roblox API
local function getUserId()
	-- Try multiple methods to get user ID
	if player and player.UserId and player.UserId ~= 0 then
		return tostring(player.UserId)
	end

	-- Fallback 1: Try getting from Players service directly
	local success1, userId1 = pcall(function()
		local localPlayer = game:GetService("Players").LocalPlayer
		if localPlayer and localPlayer.UserId and localPlayer.UserId ~= 0 then
			return tostring(localPlayer.UserId)
		end
	end)

	if success1 and userId1 then
		return userId1
	end

	-- Fallback 2: Use Roblox API to get user ID from username
	local success2, realUserId = pcall(function()
		local username = nil
		if player and player.Name and player.Name ~= "" then
			username = player.Name
		elseif game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Name then
			username = game:GetService("Players").LocalPlayer.Name
		end

		if username then
			-- Use Roblox API to get user ID from username
			local apiResponse, statusCode = makeHttpRequest("https://users.roblox.com/v1/usernames/users", "POST", {
				usernames = { username },
				excludeBannedUsers = true,
			})

			if apiResponse then
				local data = game:GetService("HttpService"):JSONDecode(apiResponse)
				if data and data.data and #data.data > 0 then
					local userData = data.data[1]
					if userData.id and userData.id ~= 0 then
						return tostring(userData.id)
					end
				end
			end
		end
		return nil
	end)

	if success2 and realUserId then
		return realUserId
	end

	-- Fallback 3: Use player name as identifier
	local success3, playerName = pcall(function()
		if player and player.Name and player.Name ~= "" then
			return player.Name
		elseif game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer.Name then
			return game:GetService("Players").LocalPlayer.Name
		end
	end)

	if success3 and playerName then
		return "name:" .. playerName
	end

	-- Fallback 4: Generate a temporary ID
	warn("Could not get user ID, using temporary identifier")
	return "temp:" .. tostring(math.random(100000, 999999))
end

local function verifyKey(keyToVerify)
	local userId = getUserId()
	local responseBody, statusCode = makeHttpRequest(SERVER_URL .. "/verify-key", "POST", {
		key = keyToVerify,
		roblox_userid = userId,
		exploit = "client-side",
	})

	if responseBody then
		local success, data = pcall(function()
			return game:GetService("HttpService"):JSONDecode(responseBody)
		end)

		if success and data then
			return data.valid, data.reason
		else
			return false, "Invalid server response"
		end
	else -- Log bypass attempt
		pcall(function()
			makeHttpRequest(SERVER_URL .. "/log-bypass-attempt", "POST", {
				roblox_userid = getUserId(),
				reason = "Failed to connect to key verification server",
				error = tostring(statusCode),
			})
		end)
		return false, "Failed to connect to server: " .. tostring(statusCode)
	end
end

local function unloadScript()
	getgenv().StarLifeKey.KeyVerified = false
	getgenv().StarLifeKey.ScriptLoaded = false
	getgenv().StarLifeKey.CurrentKey = nil
	getgenv().StarLifeKey.LoaderAuthenticated = false

	-- Call the main script's unload function if it exists
	if getgenv().StarLifeFarmerUnload then
		getgenv().StarLifeFarmerUnload()
	end

	-- Destroy any existing UI
	local existingUI = player.PlayerGui:FindFirstChild("KeySystemUI")
	if existingUI then
		existingUI:Destroy()
	end

	sendNotification("Key System", "Script unloaded - Key invalid or expired", 5)
	warn("Key System: Script unloaded due to key validation failure")
end

local function loadMainScript()
	local scriptUrl = "https://raw.githubusercontent.com/Razzles5170/SL/refs/heads/main/main.luau"
	local responseBody, statusCode = makeHttpRequest(scriptUrl, "GET")

	if responseBody and exploitFunctions.loadstring then
		local success, err = pcall(function()
			exploitFunctions.loadstring(responseBody)()
			getgenv().StarLifeKey.ScriptLoaded = true
		end)

		if success then
			sendNotification("Script loaded successfully!", 3)
			return true
		else
			warn("Failed to execute script: " .. tostring(err))
			return false, "Failed to execute script: " .. tostring(err)
		end
	else
		warn("Failed to download script: " .. tostring(statusCode))
		return false, "Failed to download script: " .. tostring(statusCode)
	end
end

local function createUI()
	-- Remove existing UI
	local existingUI = player.PlayerGui:FindFirstChild("KeySystemUI")
	if existingUI then
		existingUI:Destroy()
	end

	-- Create main UI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "KeySystemUI"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = player.PlayerGui

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 450, 0, 320)
	mainFrame.Position = UDim2.new(0.5, -225, 0.5, -160)
	mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	-- Add modern styling
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = mainFrame

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(70, 70, 70)
	stroke.Thickness = 2
	stroke.Parent = mainFrame

	-- Gradient background
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 25)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15)),
	})
	gradient.Rotation = 45
	gradient.Parent = mainFrame

	-- Title bar
	local titleBar = Instance.new("Frame")
	titleBar.Size = UDim2.new(1, 0, 0, 50)
	titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	titleBar.BorderSizePixel = 0
	titleBar.Parent = mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 12)
	titleCorner.Parent = titleBar

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 1, 0)
	title.Text = "Key System"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.GothamBold
	title.TextSize = 18
	title.Parent = titleBar

	-- Key input
	local keyInput = Instance.new("TextBox")
	keyInput.Size = UDim2.new(0.85, 0, 0, 45)
	keyInput.Position = UDim2.new(0.075, 0, 0, 70)
	keyInput.PlaceholderText = "Enter your key here..."
	keyInput.Text = ""
	keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	keyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	keyInput.Font = Enum.Font.Gotham
	keyInput.TextSize = 14
	keyInput.BorderSizePixel = 0
	keyInput.ClearTextOnFocus = false
	keyInput.Parent = mainFrame

	local inputCorner = Instance.new("UICorner")
	inputCorner.CornerRadius = UDim.new(0, 8)
	inputCorner.Parent = keyInput

	local inputStroke = Instance.new("UIStroke")
	inputStroke.Color = Color3.fromRGB(60, 60, 60)
	inputStroke.Thickness = 1
	inputStroke.Parent = keyInput

	-- Verify button
	local verifyButton = Instance.new("TextButton")
	verifyButton.Size = UDim2.new(0.4, 0, 0, 45)
	verifyButton.Position = UDim2.new(0.075, 0, 0, 135)
	verifyButton.Text = "✓ Verify Key"
	verifyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	verifyButton.Font = Enum.Font.GothamBold
	verifyButton.TextSize = 14
	verifyButton.BorderSizePixel = 0
	verifyButton.Parent = mainFrame

	local verifyCorner = Instance.new("UICorner")
	verifyCorner.CornerRadius = UDim.new(0, 8)
	verifyCorner.Parent = verifyButton

	-- Get key button
	local getKeyButton = Instance.new("TextButton")
	getKeyButton.Size = UDim2.new(0.4, 0, 0, 45)
	getKeyButton.Position = UDim2.new(0.525, 0, 0, 135)
	getKeyButton.Text = "🔗 Get Key"
	getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 85)
	getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	getKeyButton.Font = Enum.Font.GothamBold
	getKeyButton.TextSize = 14
	getKeyButton.BorderSizePixel = 0
	getKeyButton.Parent = mainFrame

	local getKeyCorner = Instance.new("UICorner")
	getKeyCorner.CornerRadius = UDim.new(0, 8)
	getKeyCorner.Parent = getKeyButton

	-- Status label
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(0.9, 0, 0, 80)
	statusLabel.Position = UDim2.new(0.05, 0, 0, 200)
	statusLabel.Text =
		"Welcome! Please enter your key or get a new one.\n\nCompatible with KRNL, Swift, Bunni and other executors."
	statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextSize = 12
	statusLabel.TextWrapped = true
	statusLabel.TextYAlignment = Enum.TextYAlignment.Top
	statusLabel.Parent = mainFrame

	-- Info label
	local infoLabel = Instance.new("TextLabel")
	infoLabel.Size = UDim2.new(0.9, 0, 0, 25)
	infoLabel.Position = UDim2.new(0.05, 0, 0, 290)
	infoLabel.Text = "Made by Noah Chang "
	infoLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextSize = 10
	infoLabel.Parent = mainFrame

	-- Button animations
	local function animateButton(button, hoverColor, normalColor)
		button.MouseEnter:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = hoverColor }):Play()
		end)

		button.MouseLeave:Connect(function()
			TweenService:Create(button, TweenInfo.new(0.2), { BackgroundColor3 = normalColor }):Play()
		end)
	end

	animateButton(verifyButton, Color3.fromRGB(20, 140, 235), Color3.fromRGB(0, 120, 215))
	animateButton(getKeyButton, Color3.fromRGB(20, 170, 105), Color3.fromRGB(0, 150, 85))

	-- Button functionality
	verifyButton.MouseButton1Click:Connect(function()
		local enteredKey = keyInput.Text:gsub("%s+", "") -- Remove whitespace
		if enteredKey == "" then
			statusLabel.Text = "❌ Please enter a key."
			statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			return
		end

		statusLabel.Text = "🔄 Verifying key with server..."
		statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
		verifyButton.Text = "Verifying..."
		verifyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

		task.wait(0.5) -- Small delay for UX

		local isValid, reason = verifyKey(enteredKey)
		if isValid then
			-- Set all required global variables before loading script
			getgenv().StarLifeKey.CurrentKey = enteredKey
			getgenv().StarLifeKey.KeyVerified = true
			getgenv().StarLifeKey.LoaderAuthenticated = true
			getgenv().StarLifeKey.ScriptLoaded = false
			-- Ensure SecurityToken persists (don't regenerate it)
			if not getgenv().StarLifeKey.SecurityToken then
				getgenv().StarLifeKey.SecurityToken = tostring(math.random(1000000, 9999999))
			end

			-- Debug logging
			print("DEBUG: Global variables set:")
			print("  CurrentKey:", getgenv().StarLifeKey.CurrentKey)
			print("  KeyVerified:", getgenv().StarLifeKey.KeyVerified)
			print("  LoaderAuthenticated:", getgenv().StarLifeKey.LoaderAuthenticated)
			print("  SecurityToken:", getgenv().StarLifeKey.SecurityToken)

			statusLabel.Text = "✅ Key verified successfully! Loading script..."
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)

			sendNotification("Key System", "Key verified! Loading...", 3)

			task.wait(1)
			screenGui:Destroy()

			print("DEBUG: About to load main script...")
			local success, err = loadMainScript()
			if success then
				getgenv().StarLifeKey.ScriptLoaded = true
				print("DEBUG: Script loaded successfully, ScriptLoaded set to true")
			else
				print("DEBUG: Script load failed:", err)
				statusLabel.Text = "❌ " .. tostring(err)
				statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
				sendNotification("Key System", "Failed to load script!", 5)
			end
		else
			statusLabel.Text = "❌ " .. tostring(reason)
			statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			verifyButton.Text = "✓ Verify Key"
			verifyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
			sendNotification("Key System", "Key verification failed: " .. tostring(reason), 5)
		end
	end)

	getKeyButton.MouseButton1Click:Connect(function()
		local success = false
		if exploitFunctions.setClipboard then
			success = pcall(function()
				exploitFunctions.setClipboard(SERVER_URL)
			end)
		end

		if success then
			statusLabel.Text = "📋 Key link copied to clipboard!\nPaste it in your browser to get your key."
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			sendNotification("Key System", "Key link copied! Paste in browser to get your key.", 7)
		else
			statusLabel.Text = "❌ Clipboard not supported.\nVisit: " .. SERVER_URL
			statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
			sendNotification("Key System", "Visit " .. SERVER_URL .. " to get your key", 7)
		end
	end)

	-- Make UI draggable
	local dragToggle = false
	local dragSpeed = 0.25
	local dragStart = nil
	local startPos = nil

	local function updateInput(input)
		local delta = input.Position - dragStart
		local position =
			UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(mainFrame, TweenInfo.new(dragSpeed), { Position = position }):Play()
	end

	titleBar.InputBegan:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch
		then
			dragToggle = true
			dragStart = input.Position
			startPos = mainFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	titleBar.InputChanged:Connect(function(input)
		if
			input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch
		then
			if dragToggle then
				updateInput(input)
			end
		end
	end)
end

-- Key verification loop (runs every 5 minutes)
local function startKeyVerificationLoop()
	task.spawn(function()
		while task.wait(300) do -- Check every 5 minutes
			if getgenv().StarLifeKey.CurrentKey and getgenv().StarLifeKey.KeyVerified then
				local isValid, reason = verifyKey(getgenv().StarLifeKey.CurrentKey)
				if not isValid then
					warn("Key System: Key verification failed - " .. tostring(reason)) -- Log the failed validation
					pcall(function()
						makeHttpRequest(SERVER_URL .. "/log-key-validation", "POST", {
							roblox_userid = getUserId(),
							key = getgenv().StarLifeKey.CurrentKey,
							validation_result = "failed",
							failure_reason = tostring(reason),
						})
					end)

					-- Completely unload everything and reload the loader from scratch
					unloadScript()

					-- Wait a moment before reloading
					task.wait(1)

					-- Reload the entire loader from GitHub
					local success = pcall(function()
						local loaderContent
						if exploitFunctions.httpRequest then
							local result = exploitFunctions.httpRequest({
								Url = "https://raw.githubusercontent.com/Razzles5170/SL/refs/heads/main/loader.luau",
								Method = "GET",
							})
							loaderContent = result.Body
						else
							-- Fallback
							loaderContent = game:GetService("HttpService"):GetAsync(
								"https://raw.githubusercontent.com/Razzles5170/SL/refs/heads/main/loader.luau"
							)
						end

						if exploitFunctions.loadstring then
							exploitFunctions.loadstring(loaderContent)()
						end
					end)

					if not success then
						warn("Failed to reload loader - creating UI manually")
						createUI()
					end

					break
				end
			end
		end
	end)
end

-- Global functions for external access
getgenv().ShowKeyUI = function()
	createUI()
end

getgenv().StarLifeKeySystemUnload = function()
	unloadScript()
end

-- Check exploit compatibility
local function checkExploitCompatibility()
	local compatible = false
	local exploitName = "Unknown"

	if exploitFunctions.httpRequest and exploitFunctions.loadstring then
		compatible = true

		if syn then
			exploitName = "Synapse X"
		elseif http then
			exploitName = "KRNL"
		elseif request then
			exploitName = "Fluxus"
		else
			exploitName = "Generic Exploit"
		end
	end

	return compatible, exploitName
end

-- Initialize
local isCompatible, exploitName = checkExploitCompatibility()

if isCompatible then
	createUI()
	startKeyVerificationLoop()
	sendNotification("Key System", "Key system loaded", 3)
else
	warn("Exploit not compatible! This loader requires HTTP request and loadstring functions.")
	sendNotification("Error", "Exploit not compatible with this loader!", 10)
end
