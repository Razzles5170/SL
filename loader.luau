local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z =
	game.GetService,
	Instance.new,
	pcall,
	ipairs,
	tostring,
	string.gsub,
	string.char,
	string.byte,
	table.concat,
	math.random,
	coroutine.wrap,
	wait,
	Color3.fromRGB,
	UDim2.new,
	Enum.Font,
	Enum.HttpContentType,
	Enum.UserInputType,
	Enum.UserInputState,
	Enum.TextYAlignment,
	getfenv,
	setfenv,
	loadstring
local a0 = a("HttpService")
local a1 = a("Players")
local a2 = a("StarterGui")
local a3 = a1.LocalPlayer
local a4 = "https://key.razzles.xyz"
_G.CurrentKey = nil
_G.KeyVerified = false
_G.ScriptLoaded = false
_G.LoaderAuthenticated = true
local a5 = t(r(1000000, 9999999))
_G.SecurityToken = a5
local function a6()
	return _G.SecurityToken == a5 and _G.LoaderAuthenticated == true
end
local function a7(a8, a9, aa)
	c(function()
		a2:SetCore("SendNotification", { Title = a8, Text = a9, Duration = aa or 5 })
	end)
end
local function ab(ac)
	if not a6() then
		return false, "Security check failed"
	end
	local ad, ae = c(function()
		return a0:PostAsync(
			a4 .. "/verify-key",
			a0:JSONEncode({ key = ac, roblox_id = t(a3.UserId) }),
			p.ApplicationJson
		)
	end)
	if ad then
		local af, ag = c(function()
			return a0:JSONDecode(ae)
		end)
		if af and ag then
			return ag.valid, ag.reason
		else
			return false, "Invalid server response"
		end
	else
		return false, "Connection failed: " .. t(ae)
	end
end
local function ah()
	if not a6() then
		return
	end
	_G.KeyVerified = false
	_G.ScriptLoaded = false
	_G.CurrentKey = nil
	_G.LoaderAuthenticated = false
	if _G.StarLifeFarmerUnload then
		c(_G.StarLifeFarmerUnload)
	end
	local ai = a3.PlayerGui:FindFirstChild("KeySystemUI")
	if ai then
		ai:Destroy()
	end
	a7("Key System", "Script unloaded", 5)
	warn("Key System: Unloaded")
end
local function aj()
	if a3.PlayerGui:FindFirstChild("KeySystemUI") then
		return
	end
	local ak = b("ScreenGui", a3.PlayerGui)
	ak.Name = "KeySystemUI"
	ak.ResetOnSpawn = false
	local al = b("Frame", ak)
	al.Size = n(0, 450, 0, 300)
	al.Position = n(0.5, -225, 0.5, -150)
	al.BackgroundColor3 = m(25, 25, 25)
	al.BorderSizePixel = 0
	b("UICorner", al).CornerRadius = UDim.new(0, 8)
	local am = b("UIStroke", al)
	am.Color = m(60, 60, 60)
	am.Thickness = 2
	local an = b("TextLabel", al)
	an.Size = n(1, 0, 0, 40)
	an.Text = "🔑 Key System - Star Life Farmer"
	an.TextColor3 = m(255, 255, 255)
	an.BackgroundColor3 = m(40, 40, 40)
	an.Font = o.GothamBold
	an.TextSize = 16
	b("UICorner", an).CornerRadius = UDim.new(0, 8)
	local ao = b("TextBox", al)
	ao.Size = n(0.85, 0, 0, 45)
	ao.Position = n(0.075, 0, 0, 60)
	ao.PlaceholderText = "Enter your key here..."
	ao.TextColor3 = m(255, 255, 255)
	ao.BackgroundColor3 = m(35, 35, 35)
	ao.Font = o.Gotham
	ao.TextSize = 14
	ao.ClearTextOnFocus = false
	b("UICorner", ao).CornerRadius = UDim.new(0, 6)
	local ap = b("UIStroke", ao)
	ap.Color = m(80, 80, 80)
	ap.Thickness = 1
	local aq = b("TextButton", al)
	aq.Size = n(0.4, 0, 0, 45)
	aq.Position = n(0.075, 0, 0, 125)
	aq.Text = "✓ Verify Key"
	aq.BackgroundColor3 = m(0, 120, 215)
	aq.TextColor3 = m(255, 255, 255)
	aq.Font = o.GothamBold
	aq.TextSize = 14
	b("UICorner", aq).CornerRadius = UDim.new(0, 6)
	local ar = b("TextButton", al)
	ar.Size = n(0.4, 0, 0, 45)
	ar.Position = n(0.525, 0, 0, 125)
	ar.Text = "🔗 Get Key"
	ar.BackgroundColor3 = m(0, 150, 85)
	ar.TextColor3 = m(255, 255, 255)
	ar.Font = o.GothamBold
	ar.TextSize = 14
	b("UICorner", ar).CornerRadius = UDim.new(0, 6)
	local as = b("TextLabel", al)
	as.Size = n(0.9, 0, 0, 60)
	as.Position = n(0.05, 0, 0, 190)
	as.Text = "Welcome! Please enter your key or get a new one."
	as.TextColor3 = m(200, 200, 200)
	as.BackgroundTransparency = 1
	as.Font = o.Gotham
	as.TextSize = 12
	as.TextWrapped = true
	as.TextYAlignment = s.Top
	local at = b("TextLabel", al)
	at.Size = n(0.9, 0, 0, 30)
	at.Position = n(0.05, 0, 0, 260)
	at.Text = "Made by Razzles | Star Life Farmer v2.0"
	at.TextColor3 = m(120, 120, 120)
	at.BackgroundTransparency = 1
	at.Font = o.Gotham
	at.TextSize = 10
	aq.MouseButton1Click:Connect(function()
		if not a6() then
			return
		end
		local au = f(ao.Text, "%s+", "")
		if au == "" then
			as.Text = "❌ Please enter a key."
			as.TextColor3 = m(255, 100, 100)
			return
		end
		as.Text = "🔄 Verifying key..."
		as.TextColor3 = m(255, 200, 0)
		aq.Text = "Verifying..."
		aq.BackgroundColor3 = m(100, 100, 100)
		l(0.5)
		local av, aw = ab(au)
		if av then
			_G.CurrentKey = au
			_G.KeyVerified = true
			as.Text = "✅ Key verified successfully! Loading script..."
			as.TextColor3 = m(100, 255, 100)
			a7("Key System", "Key verified! Loading Star Life Farmer...", 3)
			l(1)
			ak:Destroy()
			local ax, ay = c(function()
				z(a0:HttpGet("https://raw.githubusercontent.com/Razzles5170/SL/refs/heads/main/main.luau"))()
				_G.ScriptLoaded = true
			end)
			if not ax then
				as.Text = "❌ Failed to load script: " .. t(ay)
				as.TextColor3 = m(255, 100, 100)
				a7("Key System", "Failed to load script!", 5)
			end
		else
			as.Text = "❌ " .. t(aw)
			as.TextColor3 = m(255, 100, 100)
			aq.Text = "✓ Verify Key"
			aq.BackgroundColor3 = m(0, 120, 215)
			a7("Key System", "Key verification failed: " .. t(aw), 5)
		end
	end)
	ar.MouseButton1Click:Connect(function()
		local az = c(setclipboard, a4)
		if az then
			as.Text =
				"📋 Key link copied to clipboard!\nPaste it in your browser and follow the steps to get your key."
			as.TextColor3 = m(100, 255, 100)
			a7("Key System", "Key link copied to clipboard! Paste in browser to get your key.", 7)
		else
			as.Text = "❌ Clipboard not supported. Visit: " .. a4
			as.TextColor3 = m(255, 200, 0)
			a7("Key System", "Visit " .. a4 .. " to get your key", 7)
		end
	end)
	local aA, aB, aC, aD
	an.InputBegan:Connect(function(aE)
		if aE.UserInputType == q.MouseButton1 or aE.UserInputType == q.Touch then
			aA = true
			aC = aE.Position
			aD = al.Position
			aE.Changed:Connect(function()
				if aE.UserInputState == r.End then
					aA = false
				end
			end)
		end
	end)
	an.InputChanged:Connect(function(aF)
		if aF.UserInputType == q.MouseMovement or aF.UserInputType == q.Touch then
			if aA then
				local aG = aF.Position - aC
				local aH = n(aD.X.Scale, aD.X.Offset + aG.X, aD.Y.Scale, aD.Y.Offset + aG.Y)
				a("TweenService"):Create(al, TweenInfo.new(0.25), { Position = aH }):Play()
			end
		end
	end)
end
local function aI()
	k(function()
		while l(300) do
			if _G.CurrentKey and _G.KeyVerified and a6() then
				local aJ, aK = ab(_G.CurrentKey)
				if not aJ then
					warn("Key System: Key validation failed - " .. t(aK))
					c(function()
						a0:PostAsync(
							a4 .. "/log-key-validation",
							a0:JSONEncode({
								roblox_id = t(a3.UserId),
								key = _G.CurrentKey,
								validation_result = "failed",
								failure_reason = t(aK),
							}),
							p.ApplicationJson
						)
					end)
					ah()
					aj()
					break
				end
			end
		end
	end)()
end
_G.ShowKeyUI = aj
_G.StarLifeKeySystemUnload = ah
if a6() then
	aj()
	aI()
	a7("Key System", "Star Life Farmer Key System loaded!", 3)
else
	warn("Loader integrity compromised.")
end
