local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local SERVER_URL = "https://key.razzles.xyz" 

_G.CurrentKey = nil
_G.KeyVerified = false
_G.ScriptLoaded = false
_G.LoaderAuthenticated = true 

local securityToken = tostring(math.random(1000000, 9999999))
_G.SecurityToken = securityToken

local function verifySecurityIntegrity()
	return _G.SecurityToken == securityToken and _G.LoaderAuthenticated == true
end

local function sendNotification(title, text, duration)
	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 5,
		})
	end)
end

local function verifyKey(keyToVerify)
	local success, response = pcall(function()
		return HttpService:PostAsync(
			SERVER_URL .. "/verify-key",
			HttpService:JSONEncode({
				key = keyToVerify,
				roblox_id = tostring(player.UserId),
			}),
			Enum.HttpContentType.ApplicationJson
		)
	end)

	if success then
		local data = HttpService:JSONDecode(response)
		return data.valid, data.reason
	else

		pcall(function()
			HttpService:PostAsync(
				SERVER_URL .. "/log-bypass-attempt",
				HttpService:JSONEncode({
					roblox_id = tostring(player.UserId),
					reason = "Failed to connect to key verification server - Possible server bypass attempt",
				}),
				Enum.HttpContentType.ApplicationJson
			)
		end)
		return false, "Failed to connect to server: " .. tostring(response)
	end
end

local function unloadScript()
	_G.KeyVerified = false
	_G.ScriptLoaded = false
	_G.CurrentKey = nil
	_G.LoaderAuthenticated = false 

	if _G.StarLifeFarmerUnload then
		_G.StarLifeFarmerUnload()
	end

	if player.PlayerGui:FindFirstChild("KeySystemUI") then
		player.PlayerGui.KeySystemUI:Destroy()
	end

	sendNotification("Key System", "Script unloaded - Key invalid or expired", 5)
	warn("Key System: Script unloaded due to key validation failure")
end

local function createUI()
	if player.PlayerGui:FindFirstChild("KeySystemUI") then
		player.PlayerGui.KeySystemUI:Destroy()
	end

	local screenGui = Instance.new("ScreenGui", player.PlayerGui)
	screenGui.Name = "KeySystemUI"
	screenGui.ResetOnSpawn = false

	local mainFrame = Instance.new("Frame", screenGui)
	mainFrame.Size = UDim2.new(0, 450, 0, 300)
	mainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	mainFrame.BorderSizePixel = 0

	local corner = Instance.new("UICorner", mainFrame)
	corner.CornerRadius = UDim.new(0, 8)

	local stroke = Instance.new("UIStroke", mainFrame)
	stroke.Color = Color3.fromRGB(60, 60, 60)
	stroke.Thickness = 2

	local title = Instance.new("TextLabel", mainFrame)
	title.Size = UDim2.new(1, 0, 0, 40)
	title.Text = "🔑 Key System - Star Life Farmer"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 16
	title.BorderSizePixel = 0

	local titleCorner = Instance.new("UICorner", title)
	titleCorner.CornerRadius = UDim.new(0, 8)

	local keyInput = Instance.new("TextBox", mainFrame)
	keyInput.Size = UDim2.new(0.85, 0, 0, 45)
	keyInput.Position = UDim2.new(0.075, 0, 0, 60)
	keyInput.PlaceholderText = "Enter your key here..."
	keyInput.Text = ""
	keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	keyInput.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	keyInput.Font = Enum.Font.Gotham
	keyInput.TextSize = 14
	keyInput.BorderSizePixel = 0
	keyInput.ClearTextOnFocus = false

	local inputCorner = Instance.new("UICorner", keyInput)
	inputCorner.CornerRadius = UDim.new(0, 6)

	local inputStroke = Instance.new("UIStroke", keyInput)
	inputStroke.Color = Color3.fromRGB(80, 80, 80)
	inputStroke.Thickness = 1

	local verifyButton = Instance.new("TextButton", mainFrame)
	verifyButton.Size = UDim2.new(0.4, 0, 0, 45)
	verifyButton.Position = UDim2.new(0.075, 0, 0, 125)
	verifyButton.Text = "✓ Verify Key"
	verifyButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
	verifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	verifyButton.Font = Enum.Font.GothamBold
	verifyButton.TextSize = 14
	verifyButton.BorderSizePixel = 0

	local verifyCorner = Instance.new("UICorner", verifyButton)
	verifyCorner.CornerRadius = UDim.new(0, 6)

	local getKeyButton = Instance.new("TextButton", mainFrame)
	getKeyButton.Size = UDim2.new(0.4, 0, 0, 45)
	getKeyButton.Position = UDim2.new(0.525, 0, 0, 125)
	getKeyButton.Text = "🔗 Get Key"
	getKeyButton.BackgroundColor3 = Color3.fromRGB(0, 150, 85)
	getKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	getKeyButton.Font = Enum.Font.GothamBold
	getKeyButton.TextSize = 14
	getKeyButton.BorderSizePixel = 0

	local getKeyCorner = Instance.new("UICorner", getKeyButton)
	getKeyCorner.CornerRadius = UDim.new(0, 6)

	local statusLabel = Instance.new("TextLabel", mainFrame)
	statusLabel.Size = UDim2.new(0.9, 0, 0, 60)
	statusLabel.Position = UDim2.new(0.05, 0, 0, 190)
	statusLabel.Text = "Welcome! Please enter your key or get a new one."
	statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Font = Enum.Font.Gotham
	statusLabel.TextSize = 12
	statusLabel.TextWrapped = true
	statusLabel.TextYAlignment = Enum.TextYAlignment.Top

	local infoLabel = Instance.new("TextLabel", mainFrame)
	infoLabel.Size = UDim2.new(0.9, 0, 0, 30)
	infoLabel.Position = UDim2.new(0.05, 0, 0, 260)
	infoLabel.Text = "Made by Razzles | Star Life Farmer v2.0"
	infoLabel.TextColor3 = Color3.fromRGB(120, 120, 120)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextSize = 10

	verifyButton.MouseButton1Click:Connect(function()
		local enteredKey = keyInput.Text:gsub("%s+", "") 
		if enteredKey == "" then
			statusLabel.Text = "❌ Please enter a key."
			statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			return
		end

		statusLabel.Text = "🔄 Verifying key..."
		statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
		verifyButton.Text = "Verifying..."
		verifyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

		wait(0.5) 

		local isValid, reason = verifyKey(enteredKey)
		if isValid then
			_G.CurrentKey = enteredKey
			_G.KeyVerified = true
			statusLabel.Text = "✅ Key verified successfully! Loading script..."
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)

			sendNotification("Key System", "Key verified! Loading Star Life Farmer...", 3)

			wait(1)
			screenGui:Destroy()

			local success, err = pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/Razzles5170/SL/refs/heads/main/main.luau"))()
				_G.ScriptLoaded = true
			end)

			if not success then
				statusLabel.Text = "❌ Failed to load script: " .. tostring(err)
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

		local success = pcall(function()
			setclipboard(SERVER_URL)
		end)

		if success then
			statusLabel.Text =
				"📋 Key link copied to clipboard!\nPaste it in your browser and follow the steps to get your key."
			statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			sendNotification("Key System", "Key link copied to clipboard! Paste in browser to get your key.", 7)
		else
			statusLabel.Text = "❌ Clipboard not supported. Visit: " .. SERVER_URL
			statusLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
			sendNotification("Key System", "Visit " .. SERVER_URL .. " to get your key", 7)
		end
	end)

	local dragToggle = nil
	local dragSpeed = 0.25
	local dragStart = nil
	local startPos = nil

	local function updateInput(input)
		local delta = input.Position - dragStart
		local position =
			UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		game:GetService("TweenService"):Create(mainFrame, TweenInfo.new(dragSpeed), { Position = position }):Play()
	end

	title.InputBegan:Connect(function(input)
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

	title.InputChanged:Connect(function(input)
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

local function startKeyVerificationLoop()
	coroutine.wrap(function()
		while wait(300) do 
			if _G.CurrentKey and _G.KeyVerified then
				local isValid, reason = verifyKey(_G.CurrentKey)
				if not isValid then
					warn("Key System: Key verification failed - " .. tostring(reason))

					pcall(function()
						HttpService:PostAsync(
							SERVER_URL .. "/log-key-validation",
							HttpService:JSONEncode({
								roblox_id = tostring(player.UserId),
								key = _G.CurrentKey,
								validation_result = "failed",
								failure_reason = tostring(reason),
							}),
							Enum.HttpContentType.ApplicationJson
						)
					end)

					unloadScript()

					createUI()
					break
				end
			end
		end
	end)()
end

function _G.ShowKeyUI()
	createUI()
end

function _G.StarLifeKeySystemUnload()
	unloadScript()
end

createUI()
startKeyVerificationLoop()

sendNotification("Key System", "Star Life Farmer Key System loaded!", 3)
