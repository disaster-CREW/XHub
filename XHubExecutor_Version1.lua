loadstring([[
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

-- ===== CONFIGURATION =====
local HUB_CONFIG = {
	SpawnLocation = Vector3.new(0, 5, 0),
	FlySpeed = 50,
	Destinations = {
		{
			Name = "Obby",
			Position = Vector3.new(0, 20, 0),
			Color = Color3.fromRGB(255, 0, 0)
		},
		{
			Name = "Parkour",
			Position = Vector3.new(100, 20, 0),
			Color = Color3.fromRGB(0, 255, 0)
		},
		{
			Name = "Combat Arena",
			Position = Vector3.new(-100, 20, 0),
			Color = Color3.fromRGB(0, 0, 255)
		},
		{
			Name = "Sandbox",
			Position = Vector3.new(0, 20, 100),
			Color = Color3.fromRGB(255, 255, 0)
		}
	}
}

-- ===== X HUB MANAGER CLASS =====
local XHub = {}
XHub.__index = XHub

function XHub.new()
	local self = setmetatable({}, XHub)
	self.activePlayers = {}
	self.teleportingPlayers = {}
	self.shiftLockPlayers = {}
	return self
end

function XHub:CreateHubEnvironment()
	local hubFolder = Instance.new("Folder")
	hubFolder.Name = "XHubEnvironment"
	hubFolder.Parent = workspace

	-- Create hub platform
	local platform = Instance.new("Part")
	platform.Name = "HubPlatform"
	platform.Shape = Enum.PartType.Block
	platform.Size = Vector3.new(100, 1, 100)
	platform.Material = Enum.Material.Concrete
	platform.BrickColor = BrickColor.new("Dark stone grey")
	platform.CanCollide = true
	platform.CFrame = CFrame.new(HUB_CONFIG.SpawnLocation - Vector3.new(0, 1, 0))
	platform.TopSurface = Enum.SurfaceType.Smooth
	platform.BottomSurface = Enum.SurfaceType.Smooth
	platform.Parent = hubFolder

	-- Create spawn location
	local spawn = Instance.new("SpawnLocation")
	spawn.Name = "HubSpawn"
	spawn.Size = Vector3.new(6, 1, 6)
	spawn.BrickColor = BrickColor.new("Bright green")
	spawn.CanCollide = true
	spawn.CFrame = CFrame.new(HUB_CONFIG.SpawnLocation)
	spawn.CanQuery = false
	spawn.Parent = hubFolder

	-- Create destination pads
	for i, destination in ipairs(HUB_CONFIG.Destinations) do
		local pad = Instance.new("Part")
		pad.Name = destination.Name .. "Pad"
		pad.Shape = Enum.PartType.Block
		pad.Size = Vector3.new(8, 0.5, 8)
		pad.Material = Enum.Material.Neon
		pad.Color = destination.Color
		pad.CanCollide = true
		pad.CFrame = CFrame.new(destination.Position)
		pad.TopSurface = Enum.SurfaceType.Smooth
		pad.BottomSurface = Enum.SurfaceType.Smooth
		pad.Parent = hubFolder

		-- Add destination label
		local label = Instance.new("SurfaceGui")
		label.Parent = pad
		label.Face = Enum.NormalId.Top

		local textLabel = Instance.new("TextLabel")
		textLabel.Size = UDim2.new(1, 0, 1, 0)
		textLabel.BackgroundTransparency = 0.3
		textLabel.BackgroundColor3 = destination.Color
		textLabel.TextColor3 = Color3.new(1, 1, 1)
		textLabel.TextSize = 24
		textLabel.Font = Enum.Font.GothamBold
		textLabel.Text = destination.Name
		textLabel.Parent = label

		-- Teleport on touch
		pad.Touched:Connect(function(hit)
			local character = hit.Parent
			local player = Players:GetPlayerFromCharacter(character)

			if player and not self.teleportingPlayers[player] then
				self:TeleportPlayer(player, destination.Position)
			end
		end)

		pad:SetAttribute("Destination", destination.Name)
		pad:SetAttribute("TeleportPosition", destination.Position)
	end

	-- Create center hub structure
	local center = Instance.new("Part")
	center.Name = "HubCenter"
	center.Shape = Enum.PartType.Cylinder
	center.Size = Vector3.new(10, 30, 10)
	center.Material = Enum.Material.Neon
	center.Color = Color3.fromRGB(100, 149, 237)
	center.CanCollide = false
	center.CFrame = CFrame.new(HUB_CONFIG.SpawnLocation + Vector3.new(0, 15, 0))
	center.Parent = hubFolder

	print("[X Hub] Hub environment created successfully!")
end

function XHub:CreatePlayerGUI(player)
	local playerGui = player:WaitForChild("PlayerGui")

	-- Create main screen GUI
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "XHubGui"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = playerGui

	-- Main frame
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "MainFrame"
	mainFrame.Size = UDim2.new(0, 320, 0, 900)
	mainFrame.Position = UDim2.new(0.5, -160, 0.5, -450)
	mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = screenGui

	-- Corner radius
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = mainFrame

	-- Title
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, 0, 0, 50)
	title.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
	title.TextColor3 = Color3.new(1, 1, 1)
	title.TextSize = 28
	title.Font = Enum.Font.GothamBold
	title.Text = "X HUB"
	title.BorderSizePixel = 0
	title.Parent = mainFrame

	local titleCorner = Instance.new("UICorner")
	titleCorner.CornerRadius = UDim.new(0, 10)
	titleCorner.Parent = title

	-- Buttons container
	local buttonsContainer = Instance.new("Frame")
	buttonsContainer.Name = "ButtonsContainer"
	buttonsContainer.Size = UDim2.new(1, -20, 1, -70)
	buttonsContainer.Position = UDim2.new(0, 10, 0, 60)
	buttonsContainer.BackgroundTransparency = 1
	buttonsContainer.Parent = mainFrame

	-- UIListLayout for buttons
	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 10)
	listLayout.Parent = buttonsContainer

	-- Create destination buttons
	for i, destination in ipairs(HUB_CONFIG.Destinations) do
		local button = Instance.new("TextButton")
		button.Name = destination.Name .. "Button"
		button.Size = UDim2.new(1, 0, 0, 50)
		button.BackgroundColor3 = destination.Color
		button.TextColor3 = Color3.new(1, 1, 1)
		button.TextSize = 18
		button.Font = Enum.Font.GothamBold
		button.Text = "→ " .. destination.Name
		button.BorderSizePixel = 0
		button.Parent = buttonsContainer

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 8)
		btnCorner.Parent = button

		-- Button click handler
		button.MouseButton1Click:Connect(function()
			self:TeleportPlayer(player, destination.Position)
		end)

		-- Hover effect
		button.MouseEnter:Connect(function()
			button.BackgroundTransparency = 0.2
		end)

		button.MouseLeave:Connect(function()
			button.BackgroundTransparency = 0
		end)
	end

	-- FLY GUI BUTTON
	local flyButton = Instance.new("TextButton")
	flyButton.Name = "FlyButton"
	flyButton.Size = UDim2.new(1, 0, 0, 50)
	flyButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
	flyButton.TextColor3 = Color3.new(1, 1, 1)
	flyButton.TextSize = 18
	flyButton.Font = Enum.Font.GothamBold
	flyButton.Text = "☁️ FLY GUI"
	flyButton.BorderSizePixel = 0
	flyButton.Parent = buttonsContainer

	local flyBtnCorner = Instance.new("UICorner")
	flyBtnCorner.CornerRadius = UDim.new(0, 8)
	flyBtnCorner.Parent = flyButton

	-- Fly GUI click handler
	flyButton.MouseButton1Click:Connect(function()
		self:ExecuteFlyGUI(player)
	end)

	-- Hover effect
	flyButton.MouseEnter:Connect(function()
		flyButton.BackgroundTransparency = 0.2
	end)

	flyButton.MouseLeave:Connect(function()
		flyButton.BackgroundTransparency = 0
	end)

	-- SHIFTLOCK BUTTON
	local shiftlockButton = Instance.new("TextButton")
	shiftlockButton.Name = "ShiftlockButton"
	shiftlockButton.Size = UDim2.new(1, 0, 0, 50)
	shiftlockButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
	shiftlockButton.TextColor3 = Color3.new(1, 1, 1)
	shiftlockButton.TextSize = 18
	shiftlockButton.Font = Enum.Font.GothamBold
	shiftlockButton.Text = "🔒 SHIFTLOCK (Off)"
	shiftlockButton.BorderSizePixel = 0
	shiftlockButton.Parent = buttonsContainer

	local shiftlockBtnCorner = Instance.new("UICorner")
	shiftlockBtnCorner.CornerRadius = UDim.new(0, 8)
	shiftlockBtnCorner.Parent = shiftlockButton

	-- Shiftlock toggle
	shiftlockButton.MouseButton1Click:Connect(function()
		if self.shiftLockPlayers[player] then
			self:StopShiftlock(player, shiftlockButton)
		else
			self:StartShiftlock(player, shiftlockButton)
		end
	end)

	-- Hover effect
	shiftlockButton.MouseEnter:Connect(function()
		shiftlockButton.BackgroundTransparency = 0.2
	end)

	shiftlockButton.MouseLeave:Connect(function()
		shiftlockButton.BackgroundTransparency = 0
	end)

	-- TROLL GUI BUTTON
	local trollButton = Instance.new("TextButton")
	trollButton.Name = "TrollButton"
	trollButton.Size = UDim2.new(1, 0, 0, 50)
	trollButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
	trollButton.TextColor3 = Color3.new(1, 1, 1)
	trollButton.TextSize = 18
	trollButton.Font = Enum.Font.GothamBold
	trollButton.Text = "🎭 TROLL GUI"
	trollButton.BorderSizePixel = 0
	trollButton.Parent = buttonsContainer

	local trollBtnCorner = Instance.new("UICorner")
	trollBtnCorner.CornerRadius = UDim.new(0, 8)
	trollBtnCorner.Parent = trollButton

	-- Troll GUI click handler
	trollButton.MouseButton1Click:Connect(function()
		self:ExecuteTrollGUI(player)
	end)

	-- Hover effect
	trollButton.MouseEnter:Connect(function()
		trollButton.BackgroundTransparency = 0.2
	end)

	trollButton.MouseLeave:Connect(function()
		trollButton.BackgroundTransparency = 0
	end)

	-- USERNAME INPUT LABEL
	local usernameLabel = Instance.new("TextLabel")
	usernameLabel.Name = "UsernameLabel"
	usernameLabel.Size = UDim2.new(1, 0, 0, 25)
	usernameLabel.BackgroundTransparency = 1
	usernameLabel.TextColor3 = Color3.new(1, 1, 1)
	usernameLabel.TextSize = 12
	usernameLabel.Font = Enum.Font.Gotham
	usernameLabel.Text = "Player to Copy Avatar:"
	usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
	usernameLabel.Parent = buttonsContainer

	-- USERNAME INPUT TEXTBOX
	local usernameBox = Instance.new("TextBox")
	usernameBox.Name = "UsernameBox"
	usernameBox.Size = UDim2.new(1, 0, 0, 35)
	usernameBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	usernameBox.TextColor3 = Color3.new(1, 1, 1)
	usernameBox.TextSize = 14
	usernameBox.Font = Enum.Font.Gotham
	usernameBox.PlaceholderText = "Enter username..."
	usernameBox.BorderSizePixel = 0
	usernameBox.ClearTextOnFocus = false
	usernameBox.Parent = buttonsContainer

	local usernameBoxCorner = Instance.new("UICorner")
	usernameBoxCorner.CornerRadius = UDim.new(0, 6)
	usernameBoxCorner.Parent = usernameBox

	-- COPY AVATAR BUTTON
	local copyAvatarButton = Instance.new("TextButton")
	copyAvatarButton.Name = "CopyAvatarButton"
	copyAvatarButton.Size = UDim2.new(1, 0, 0, 50)
	copyAvatarButton.BackgroundColor3 = Color3.fromRGB(200, 100, 255)
	copyAvatarButton.TextColor3 = Color3.new(1, 1, 1)
	copyAvatarButton.TextSize = 18
	copyAvatarButton.Font = Enum.Font.GothamBold
	copyAvatarButton.Text = "👤 Copy Avatar"
	copyAvatarButton.BorderSizePixel = 0
	copyAvatarButton.Parent = buttonsContainer

	local copyAvatarCorner = Instance.new("UICorner")
	copyAvatarCorner.CornerRadius = UDim.new(0, 8)
	copyAvatarCorner.Parent = copyAvatarButton

	-- Copy Avatar click handler
	copyAvatarButton.MouseButton1Click:Connect(function()
		local targetName = usernameBox.Text:match("^%s*(.-)%s*$")

		if targetName == "" then
			self:ShowNotification(player, "❌ Please enter a player name!", Color3.fromRGB(255, 100, 100))
			return
		end

		local targetPlayer = Players:FindFirstChild(targetName)

		if not targetPlayer or not targetPlayer.Character then
			self:ShowNotification(player, "❌ Player not found or has no character!", Color3.fromRGB(255, 100, 100))
			return
		end

		self:CopyAvatar(player, targetPlayer)
		self:ShowNotification(player, "✅ Avatar copied from " .. targetName .. "!", Color3.fromRGB(100, 255, 100))
		usernameBox.Text = ""
	end)

	-- Hover effect
	copyAvatarButton.MouseEnter:Connect(function()
		copyAvatarButton.BackgroundTransparency = 0.2
	end)

	copyAvatarButton.MouseLeave:Connect(function()
		copyAvatarButton.BackgroundTransparency = 0
	end)

	-- Close button
	local closeButton = Instance.new("TextButton")
	closeButton.Name = "CloseButton"
	closeButton.Size = UDim2.new(0, 30, 0, 30)
	closeButton.Position = UDim2.new(1, -40, 0, 10)
	closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
	closeButton.TextColor3 = Color3.new(1, 1, 1)
	closeButton.TextSize = 18
	closeButton.Font = Enum.Font.GothamBold
	closeButton.Text = "X"
	closeButton.BorderSizePixel = 0
	closeButton.Parent = mainFrame

	local closeCorner = Instance.new("UICorner")
	closeCorner.CornerRadius = UDim.new(0, 5)
	closeCorner.Parent = closeButton

	closeButton.MouseButton1Click:Connect(function()
		if self.shiftLockPlayers[player] then
			self:StopShiftlock(player, shiftlockButton)
		end
		mainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.3, true)
		wait(0.3)
		screenGui:Destroy()
	end)

	print("[X Hub] GUI created for player: " .. player.Name)
end

function XHub:ExecuteFlyGUI(player)
	if not player:FindFirstChild("PlayerScripts") then return end

	local flyScript = Instance.new("LocalScript")
	flyScript.Name = "FlyGUIScript"
	flyScript.Parent = player:WaitForChild("PlayerScripts")

	flyScript.Source = [[
		local success, result = pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
		end)

		if not success then
			print("Error loading Fly GUI: " .. tostring(result))
		else
			print("Fly GUI loaded successfully!")
		end
	]]

	self:ShowNotification(player, "☁️ Loading Fly GUI...", Color3.fromRGB(100, 200, 255))
	print("[X Hub] Fly GUI script loaded for player: " .. player.Name)

	game:GetService("Debris"):AddItem(flyScript, 5)
end

function XHub:ExecuteTrollGUI(player)
	if not player:FindFirstChild("PlayerScripts") then return end

	local trollScript = Instance.new("LocalScript")
	trollScript.Name = "TrollGUIScript"
	trollScript.Parent = player:WaitForChild("PlayerScripts")

	trollScript.Source = [[
		local success, result = pcall(function()
			loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-TROLL-GUI-BEST-85439"))()
		end)

		if not success then
			print("Error loading Troll GUI: " .. tostring(result))
		else
			print("Troll GUI loaded successfully!")
		end
	]]

	self:ShowNotification(player, "🎭 Loading Troll GUI...", Color3.fromRGB(100, 200, 255))
	print("[X Hub] Troll GUI script loaded for player: " .. player.Name)

	game:GetService("Debris"):AddItem(trollScript, 5)
end

function XHub:ShowNotification(player, message, color)
	local playerGui = player:WaitForChild("PlayerGui")

	local notification = Instance.new("Frame")
	notification.Name = "Notification"
	notification.Size = UDim2.new(0, 300, 0, 50)
	notification.Position = UDim2.new(0.5, -150, 0, 20)
	notification.BackgroundColor3 = color
	notification.BorderSizePixel = 0
	notification.Parent = playerGui
	notification.ZIndex = 200

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = notification

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextSize = 14
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Text = message
	textLabel.Parent = notification
	textLabel.ZIndex = 200

	game:GetService("Debris"):AddItem(notification, 3)
end

function XHub:StartShiftlock(player, shiftlockButton)
	if not player.Character then return end

	self.shiftLockPlayers[player] = true

	local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if not humanoidRootPart then return end

	-- Update button text
	shiftlockButton.Text = "🔒 SHIFTLOCK (On)"
	shiftlockButton.BackgroundColor3 = Color3.fromRGB(50, 200, 100)

	-- Create shiftlock script in PlayerScripts
	local localScript = Instance.new("LocalScript")
	localScript.Name = "ShiftlockScript"
	localScript.Parent = player:WaitForChild("PlayerScripts")

	localScript.Source = [[
		local player = game.Players.LocalPlayer
		local mouse = player:GetMouse()
		local camera = workspace.CurrentCamera
		local character = player.Character
		local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
		
		local shiftlockActive = true
		
		-- Hide mouse cursor
		mouse.Icon = ""
		
		while shiftlockActive and character.Parent do
			local mouseX = mouse.X
			local mouseY = mouse.Y
			local screenSize = mouse.ViewSizeX
			
			-- Calculate rotation
			local rotationX = (mouseX - screenSize / 2) / (screenSize / 2) * math.rad(80)
			local rotationY = (mouseY - mouse.ViewSizeY / 2) / (mouse.ViewSizeY / 2) * math.rad(60)
			
			-- Apply rotation to character
			humanoidRootPart.CFrame = humanoidRootPart.CFrame:lerp(
				CFrame.new(humanoidRootPart.Position) * CFrame.Angles(0, rotationX, 0),
				0.1
			)
			
			-- Camera follows character
			camera.CFrame = humanoidRootPart.CFrame * CFrame.new(0, 2, 8) * CFrame.Angles(rotationY, 0, 0)
			
			wait()
		end
		
		-- Restore mouse
		mouse.Icon = "rbxasset://textures/Cursors/MouseLockedCursor.png"
	]]

	self:ShowNotification(player, "✅ Shiftlock enabled!", Color3.fromRGB(100, 255, 100))
	print("[X Hub] Player " .. player.Name .. " enabled shiftlock!")
end

function XHub:StopShiftlock(player, shiftlockButton)
	if not player.Character then return end

	self.shiftLockPlayers[player] = nil

	-- Remove shiftlock script
	local playerScripts = player:FindFirstChild("PlayerScripts")
	if playerScripts then
		local shiftlockScript = playerScripts:FindFirstChild("ShiftlockScript")
		if shiftlockScript then
			shiftlockScript:Destroy()
		end
	end

	-- Update button text
	shiftlockButton.Text = "🔒 SHIFTLOCK (Off)"
	shiftlockButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)

	self:ShowNotification(player, "✅ Shiftlock disabled!", Color3.fromRGB(100, 255, 100))
	print("[X Hub] Player " .. player.Name .. " disabled shiftlock!")
end

function XHub:CopyAvatar(player, targetPlayer)
	if not player.Character or not targetPlayer.Character then return end

	local sourceCharacter = targetPlayer.Character
	local targetCharacter = player.Character

	-- Copy all accessories
	for _, accessory in pairs(sourceCharacter:GetChildren()) do
		if accessory:IsA("Accessory") then
			local newAccessory = accessory:Clone()
			newAccessory.Parent = targetCharacter
		end
	end

	-- Copy body parts colors
	local sourceBodyColors = sourceCharacter:FindFirstChild("BodyColors")
	if sourceBodyColors then
		local targetBodyColors = targetCharacter:FindFirstChild("BodyColors")
		if targetBodyColors then
			targetBodyColors.HeadColor3 = sourceBodyColors.HeadColor3
			targetBodyColors.TorsoColor3 = sourceBodyColors.TorsoColor3
			targetBodyColors.LeftArmColor3 = sourceBodyColors.LeftArmColor3
			targetBodyColors.RightArmColor3 = sourceBodyColors.RightArmColor3
			targetBodyColors.LeftLegColor3 = sourceBodyColors.LeftLegColor3
			targetBodyColors.RightLegColor3 = sourceBodyColors.RightLegColor3
		end
	end

	-- Copy face
	local sourceFace = sourceCharacter:FindFirstChild("Head"):FindFirstChildOfClass("Decal")
	local targetFace = targetCharacter:FindFirstChild("Head"):FindFirstChildOfClass("Decal")
	if sourceFace and targetFace then
		targetFace.Texture = sourceFace.Texture
	end

	print("[X Hub] Avatar copied from " .. targetPlayer.Name .. " to " .. player.Name)
end

function XHub:TeleportPlayer(player, position)
	if not player.Character then return end

	-- Stop shiftlock if enabled
	if self.shiftLockPlayers[player] then
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui then
			local hubGui = playerGui:FindFirstChild("XHubGui")
			if hubGui then
				local mainFrame = hubGui:FindFirstChild("MainFrame")
				if mainFrame then
					local buttonsContainer = mainFrame:FindFirstChild("ButtonsContainer")
					if buttonsContainer then
						local shiftlockButton = buttonsContainer:FindFirstChild("ShiftlockButton")
						if shiftlockButton then
							self:StopShiftlock(player, shiftlockButton)
						end
					end
				end
			end
		end
	end

	self.teleportingPlayers[player] = true

	local character = player.Character
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")

	if humanoidRootPart then
		-- Fade out effect
		local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local goal = {Transparency = 1}

		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				TweenService:Create(part, tweenInfo, goal):Play()
			end
		end

		wait(0.5)

		-- Teleport
		humanoidRootPart.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))

		-- Fade in effect
		local tweenInfo2 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local goal2 = {Transparency = 0}

		for _, part in pairs(character:GetDescendants()) do
			if part:IsA("BasePart") then
				TweenService:Create(part, tweenInfo2, goal2):Play()
			end
		end

		wait(0.5)
		self.teleportingPlayers[player] = nil
	end
end

function XHub:OnPlayerAdded(player)
	self.activePlayers[player] = true

	-- Wait for character to load
	local character = player.Character or player.CharacterAdded:Wait()

	-- Teleport player to hub spawn
	local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
	wait(0.5)
	humanoidRootPart.CFrame = CFrame.new(HUB_CONFIG.SpawnLocation)

	-- Create GUI
	self:CreatePlayerGUI(player)

	print("[X Hub] Player joined: " .. player.Name)
end

function XHub:OnPlayerRemoving(player)
	if self.shiftLockPlayers[player] then
		local playerGui = player:FindFirstChild("PlayerGui")
		if playerGui then
			local hubGui = playerGui:FindFirstChild("XHubGui")
			if hubGui then
				local mainFrame = hubGui:FindFirstChild("MainFrame")
				if mainFrame then
					local buttonsContainer = mainFrame:FindFirstChild("ButtonsContainer")
					if buttonsContainer then
						local shiftlockButton = buttonsContainer:FindFirstChild("ShiftlockButton")
						if shiftlockButton then
							self:StopShiftlock(player, shiftlockButton)
						end
					end
				end
			end
		end
	end
	self.activePlayers[player] = nil
	self.teleportingPlayers[player] = nil
	print("[X Hub] Player left: " .. player.Name)
end

-- ===== INITIALIZATION =====
local xHub = XHub.new()

-- Create hub environment
xHub:CreateHubEnvironment()

-- Handle player connections
Players.PlayerAdded:Connect(function(player)
	xHub:OnPlayerAdded(player)
end)

Players.PlayerRemoving:Connect(function(player)
	xHub:OnPlayerRemoving(player)
end)

-- Handle existing players
for _, player in pairs(Players:GetPlayers()) do
	xHub:OnPlayerAdded(player)
end

print("[X Hub] System initialized!")
]]) ()