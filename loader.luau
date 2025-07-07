local a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v = -- Fixed order
	function(...)
		return game:GetService(...)
	end, Instance.new, pcall, ipairs, tostring, string.gsub, string.char, string.byte, table.concat, math.random, coroutine.wrap, wait, Color3.fromRGB, UDim2.new, Enum.Font.GothamBold, Enum.HttpContentType.ApplicationJson, Enum.UserInputType.MouseButton1, Enum.UserInputState.End, Enum.TextYAlignment.Top, getfenv, setfenv, loadstring

-- Re-map the local variables correctly to avoid calling Enum values.
local a_GetService = a
local b_Instance_new = b
local c_pcall = c
local d_ipairs = d
local e_tostring = e
local f_gsub = f
local g_char = g
local h_byte = h
local i_concat = i
local j_random = j
local k_wrap = k
local l_wait = l
local m_Color3_fromRGB = m
local n_UDim2_new = n
local o_Font = o
local p_HttpContentType = p
local q_UserInputType = Enum.UserInputType
local r_UserInputState = Enum.UserInputState
local s_TextYAlignment = s
local t_getfenv = t
local u_setfenv = u
local v_loadstring = v

local a0 = a_GetService("HttpService")
local a1 = a_GetService("Players")
local a2 = a_GetService("StarterGui")
local a3 = a1.LocalPlayer
local a4 = "https://key.razzles.xyz"
_G.CurrentKey = nil
_G.KeyVerified = false
_G.ScriptLoaded = false
_G.LoaderAuthenticated = true
local a5 = e_tostring(j_random(1000000, 9999999)) -- Use correct functions
_G.SecurityToken = a5

local function a6()
	return _G.SecurityToken == a5 and _G.LoaderAuthenticated == true
end

local function a7(a8, a9, aa)
	c_pcall(function()
		a2:SetCore("SendNotification", { Title = a8, Text = a9, Duration = aa or 5 })
	end)
end

local function ab(ac)
	if not a6() then
		return false, "Security check failed"
	end
	local ad, ae = c_pcall(function()
		return game:HttpPost(
			a4 .. "/verify-key",
			a0:JSONEncode({ key = ac, roblox_userid = a3.UserId }),
			"application/json"
		)
	end)
	if ad then
		local af, ag = c_pcall(function()
			return a0:JSONDecode(ae)
		end)
		if af and ag then
			return ag.valid, ag.reason
		else
			return false, "Invalid server response"
		end
	else
		return false, "Connection failed: " .. e_tostring(ae)
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
		c_pcall(_G.StarLifeFarmerUnload)
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
	local ak = b_Instance_new("ScreenGui", a3.PlayerGui)
	ak.Name = "KeySystemUI"
	ak.ResetOnSpawn = false
	local al = b_Instance_new("Frame", ak)
	al.Size = n_UDim2_new(0, 450, 0, 300)
	al.Position = n_UDim2_new(0.5, -225, 0.5, -150)
	al.BackgroundColor3 = m_Color3_fromRGB(25, 25, 25)
	al.BorderSizePixel = 0
	b_Instance_new("UICorner", al).CornerRadius = UDim.new(0, 8)
	local am = b_Instance_new("UIStroke", al)
	am.Color = m_Color3_fromRGB(60, 60, 60)
	am.Thickness = 2
	local an = b_Instance_new("TextLabel", al)
	an.Size = n_UDim2_new(1, 0, 0, 40)
	an.Text = "🔑 Key System"
	an.TextColor3 = m_Color3_fromRGB(255, 255, 255)
	an.BackgroundColor3 = m_Color3_fromRGB(40, 40, 40)
	an.Font = o_Font
	an.TextSize = 16
	b_Instance_new("UICorner", an).CornerRadius = UDim.new(0, 8)
	local ao = b_Instance_new("TextBox", al)
	ao.Size = n_UDim2_new(0.85, 0, 0, 45)
	ao.Position = n_UDim2_new(0.075, 0, 0, 60)
	ao.Text = ""
	ao.PlaceholderText = "Enter your key here..."
	ao.TextColor3 = m_Color3_fromRGB(255, 255, 255)
	ao.BackgroundColor3 = m_Color3_fromRGB(35, 35, 35)
	ao.Font = Enum.Font.Gotham
	ao.TextSize = 14
	ao.ClearTextOnFocus = true
	b_Instance_new("UICorner", ao).CornerRadius = UDim.new(0, 6)
	local ap = b_Instance_new("UIStroke", ao)
	ap.Color = m_Color3_fromRGB(80, 80, 80)
	ap.Thickness = 1
	local aq = b_Instance_new("TextButton", al)
	aq.Size = n_UDim2_new(0.4, 0, 0, 45)
	aq.Position = n_UDim2_new(0.075, 0, 0, 125)
	aq.Text = "✓ Verify Key"
	aq.BackgroundColor3 = m_Color3_fromRGB(0, 120, 215)
	aq.TextColor3 = m_Color3_fromRGB(255, 255, 255)
	aq.Font = o_Font
	aq.TextSize = 14
	b_Instance_new("UICorner", aq).CornerRadius = UDim.new(0, 6)
	local ar = b_Instance_new("TextButton", al)
	ar.Size = n_UDim2_new(0.4, 0, 0, 45)
	ar.Position = n_UDim2_new(0.525, 0, 0, 125)
	ar.Text = "🔗 Get Key"
	ar.BackgroundColor3 = m_Color3_fromRGB(0, 150, 85)
	ar.TextColor3 = m_Color3_fromRGB(255, 255, 255)
	ar.Font = o_Font
	ar.TextSize = 14
	b_Instance_new("UICorner", ar).CornerRadius = UDim.new(0, 6)
	local as = b_Instance_new("TextLabel", al)
	as.Size = n_UDim2_new(0.9, 0, 0, 60)
	as.Position = n_UDim2_new(0.05, 0, 0, 190)
	as.Text = "Welcome! Please enter your key or get a new one."
	as.TextColor3 = m_Color3_fromRGB(200, 200, 200)
	as.BackgroundTransparency = 1
	as.Font = Enum.Font.Gotham
	as.TextSize = 12
	as.TextWrapped = true
	as.TextYAlignment = s_TextYAlignment
	local at = b_Instance_new("TextLabel", al)
	at.Size = n_UDim2_new(0.9, 0, 0, 30)
	at.Position = n_UDim2_new(0.05, 0, 0, 260)
	at.Text = "Made by thosewhoknow  | Farmer v2.0"
	at.TextColor3 = m_Color3_fromRGB(120, 120, 120)
	at.BackgroundTransparency = 1
	at.Font = Enum.Font.Gotham
	at.TextSize = 10
	aq.MouseButton1Click:Connect(function()
		if not a6() then
			return
		end
		local au = f_gsub(ao.Text, "%s+", "")
		if au == "" then
			as.Text = "❌ Please enter a key."
			as.TextColor3 = m_Color3_fromRGB(255, 100, 100)
			return
		end
		as.Text = "🔄 Verifying key..."
		as.TextColor3 = m_Color3_fromRGB(255, 200, 0)
		aq.Text = "Verifying..."
		aq.BackgroundColor3 = m_Color3_fromRGB(100, 100, 100)
		l_wait(0.5)
		local av, aw = ab(au)
		if av then
			_G.CurrentKey = au
			_G.KeyVerified = true
			as.Text = "✅ Key verified successfully! Loading script..."
			as.TextColor3 = m_Color3_fromRGB(100, 255, 100)
			a7("Key System", "Key verified! Loading Farmer...", 3)
			l_wait(1)
			ak:Destroy()
			local ax, ay = c_pcall(function()
				v_loadstring(
					game:HttpGet(
						"https://raw.githubusercontent.com/Razzles5170/SL/refs/heads/main/main.luau",
						true
					)
				)()
				_G.ScriptLoaded = true
			end)
			if not ax then
				as.Text = "❌ Failed to load script: " .. e_tostring(ay)
				as.TextColor3 = m_Color3_fromRGB(255, 100, 100)
				a7("Key System", "Failed to load script!", 5)
			end
		else
			as.Text = "❌ " .. e_tostring(aw)
			as.TextColor3 = m_Color3_fromRGB(255, 100, 100)
			aq.Text = "✓ Verify Key"
			aq.BackgroundColor3 = m_Color3_fromRGB(0, 120, 215)
			a7("Key System", "Key verification failed: " .. e_tostring(aw), 5)
		end
	end)
	ar.MouseButton1Click:Connect(function()
		if typeof(setclipboard) == "function" then
			local az = c_pcall(setclipboard, a4)
			if az then
				as.Text =
					"📋 Key link copied to clipboard!\nPaste it in your browser and follow the steps to get your key."
				as.TextColor3 = m_Color3_fromRGB(100, 255, 100)
				a7("Key System", "Key link copied to clipboard! Paste in browser to get your key.", 7)
			else
				as.Text = "❌ Clipboard not supported. Visit: " .. a4
				as.TextColor3 = m_Color3_fromRGB(255, 200, 0)
				a7("Key System", "Visit " .. a4 .. " to get your key", 7)
			end
		else
			as.Text = "❌ Clipboard not available. Visit: " .. a4
			as.TextColor3 = m_Color3_fromRGB(255, 200, 0)
			a7("Key System", "Visit " .. a4 .. " to get your key", 7)
		end
	end)
	local aA, aB, aC, aD
	an.InputBegan:Connect(function(aE)
		if aE.UserInputType == q_UserInputType.MouseButton1 or aE.UserInputType == q_UserInputType.Touch then
			aA = true
			aC = aE.Position
			aD = al.Position
			aE.Changed:Connect(function()
				if aE.UserInputState == r_UserInputState.End then
					aA = false
				end
			end)
		end
	end)
	an.InputChanged:Connect(function(aF)
		if aF.UserInputType == q_UserInputType.MouseMovement or aF.UserInputType == q_UserInputType.Touch then
			if aA then
				local aG = aF.Position - aC
				local aH = n_UDim2_new(aD.X.Scale, aD.X.Offset + aG.X, aD.Y.Scale, aD.Y.Offset + aG.Y)
				a_GetService("TweenService"):Create(al, TweenInfo.new(0.25), { Position = aH }):Play()
			end
		end
	end)
end

local function aI()
	k_wrap(function()
		while l_wait(300) do
			if _G.CurrentKey and _G.KeyVerified and a6() then
				local aJ, aK = ab(_G.CurrentKey)
				if not aJ then
					warn("Key System: Key validation failed - " .. e_tostring(aK))
					c_pcall(function()
						game:HttpPost(
							a4 .. "/log-key-validation",
							a0:JSONEncode({
								roblox_userid = a3.UserId,
								key = _G.CurrentKey,
								validation_result = "failed",
								failure_reason = e_tostring(aK),
							}),
							"application/json"
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
	a7("Key System", "Key System loaded!", 3)
else
	warn("Loader integrity compromised.")
end
