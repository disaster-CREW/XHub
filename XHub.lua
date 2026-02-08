-- SERVICES
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")

-- MAIN GUI
local gui = Instance.new("ScreenGui")
gui.Name = "XHub"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- MAIN FRAME
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 520, 0, 360)
frame.Position = UDim2.new(0.5, -260, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- LEFT TAB BAR
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(0, 130, 1, 0)
tabBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tabBar.Parent = frame
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 12)

-- TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 10)
title.BackgroundTransparency = 1
title.Text = "XHub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(180, 90, 255)
title.Parent = tabBar

-- CREATE THE X BUTTON
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.ZIndex = 40
closeButton.Parent = frame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 6)


-- X LOGIC FUNCTION
local function xLogic(gui, frame)
    -- Create confirmation popup
    local confirmFrame = Instance.new("Frame")
    confirmFrame.Size = UDim2.new(0, 300, 0, 150)
    confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    confirmFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    confirmFrame.Visible = false
    confirmFrame.ZIndex = 50
    confirmFrame.Parent = gui
    Instance.new("UICorner", confirmFrame).CornerRadius = UDim.new(0, 10)

    local confirmText = Instance.new("TextLabel")
    confirmText.Size = UDim2.new(1, 0, 0, 60)
    confirmText.Position = UDim2.new(0, 0, 0, 10)
    confirmText.BackgroundTransparency = 1
    confirmText.Text = "Are you sure you want to close the GUI?"
    confirmText.Font = Enum.Font.GothamBold
    confirmText.TextSize = 16
    confirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirmText.ZIndex = 51
    confirmText.Parent = confirmFrame

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 120, 0, 40)
    yesBtn.Position = UDim2.new(0, 20, 0, 90)
    yesBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    yesBtn.Text = "Yes"
    yesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.TextSize = 18
    yesBtn.ZIndex = 51
    yesBtn.Parent = confirmFrame
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 8)

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 120, 0, 40)
    noBtn.Position = UDim2.new(1, -140, 0, 90)
    noBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    noBtn.Text = "No"
    noBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    noBtn.Font = Enum.Font.GothamBold
    noBtn.TextSize = 18
    noBtn.ZIndex = 51
    noBtn.Parent = confirmFrame
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 8)

    -- Logic
    yesBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    noBtn.MouseButton1Click:Connect(function()
        confirmFrame.Visible = false
    end)

    -- Return function to trigger popup
    return function()
        confirmFrame.Visible = true
    end
end


-- CONNECT X BUTTON TO THE LOGIC
local openX = xLogic(gui, frame)
closeButton.MouseButton1Click:Connect(openX)

-- MINIMISE BUTTON (Windows-style "▁")
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 24, 0, 24)
minimize.Position = UDim2.new(1, -53, 0, 4) -- right next to the X button
minimize.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
minimize.Text = "-"  -- Windows-style minimise icon
minimize.Font = Enum.Font.GothamBold
minimize.TextSize = 20
minimize.TextColor3 = Color3.fromRGB(255, 255, 255)
minimize.ZIndex = 40
minimize.Parent = frame

local minCorner = Instance.new("UICorner", minimize)
minCorner.CornerRadius = UDim.new(0, 4)

minimize.MouseButton1Click:Connect(function()
    frame.Visible = false

    -- Create the "Show XHub" button at the top of the screen
    local showBtn = Instance.new("TextButton")
    showBtn.Size = UDim2.new(0, 120, 0, 35)
    showBtn.Position = UDim2.new(0.5, -60, 0, 3)
    showBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    showBtn.Text = "Show XHub"
    showBtn.Font = Enum.Font.GothamBold
    showBtn.TextSize = 16
    showBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    showBtn.ZIndex = 50
    showBtn.Parent = gui
    Instance.new("UICorner", showBtn).CornerRadius = UDim.new(0, 6)

    showBtn.MouseButton1Click:Connect(function()
        frame.Visible = true
        showBtn:Destroy()
    end)
end)

-- PAGE HOLDER
local pageHolder = Instance.new("Frame")
pageHolder.Size = UDim2.new(1, -130, 1, 0)
pageHolder.Position = UDim2.new(0, 130, 0, 0)
pageHolder.BackgroundTransparency = 1
pageHolder.Parent = frame

-- PAGE SYSTEM
local pages = {}

local function createPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 4
    page.Visible = false
    page.Parent = pageHolder
    pages[name] = page
    return page
end

local function switchPage(name)
    for _, p in pairs(pages) do
        p.Visible = false
    end
    pages[name].Visible = true
end

-- TAB CREATOR
local function makeTab(name, order)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(1, -20, 0, 35)
    tab.Position = UDim2.new(0, 10, 0, 50 + (order * 40))
    tab.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    tab.Text = name
    tab.Font = Enum.Font.GothamBold
    tab.TextSize = 16
    tab.TextColor3 = Color3.fromRGB(200, 150, 255)
    tab.Parent = tabBar
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 6)

    tab.MouseButton1Click:Connect(function()
        switchPage(name)
    end)
end

-- BUTTON CREATOR
local function makeButton(parent, text, callback)
    local count = 0
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("TextButton") then
            count += 1
        end
    end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, count * 40)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(callback)
end

-- CREATE TABS
makeTab("Basic", 1)
makeTab("Trolling", 2)
makeTab("Fun", 3)
makeTab("Settings", 4, "⚙️") -- gear emoji here

-- CREATE PAGES
local basic = createPage("Basic")
local trolling = createPage("Trolling")
local fun = createPage("Fun")
local settings = createPage("Settings")

-- SETTINGS BUTTONS --

local darkMode = false

-- THEME FUNCTION
local function applyTheme()
    local bg = darkMode and Color3.fromRGB(25,25,25) or Color3.fromRGB(240,240,240)
    local tabBg = darkMode and Color3.fromRGB(35,35,35) or Color3.fromRGB(220,220,220)
    local btnBg = darkMode and Color3.fromRGB(45,45,45) or Color3.fromRGB(200,200,200)
    local textColor = darkMode and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0)

    -- Main GUI
    frame.BackgroundColor3 = bg
    tabBar.BackgroundColor3 = tabBg

    -- Update all GUI elements
    for _, obj in ipairs(frame:GetDescendants()) do
        if obj:IsA("TextButton") then
            obj.BackgroundColor3 = btnBg
            obj.TextColor3 = textColor
        elseif obj:IsA("Frame") then
            obj.BackgroundColor3 = bg
        end
    end

    -- Restore your purple title
    title.TextColor3 = Color3.fromRGB(180, 90, 255)
end

-- THEME TOGGLE BUTTON
makeButton(settings, "Toggle Theme", function()
    darkMode = not darkMode
    applyTheme()
end)

-- UI SCALE
local UIScale = Instance.new("UIScale")
UIScale.Parent = frame

makeButton(settings, "Increase UI Size", function()
    UIScale.Scale = UIScale.Scale + 0.1
end)

makeButton(settings, "Decrease UI Size", function()
    UIScale.Scale = UIScale.Scale - 0.1
end)

-- ADD YOUR SCRIPTS HERE
makeButton(basic, "Infinite Yield", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

makeButton(trolling, "Give Tools", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Tools-giver-26246"))()
end)

makeButton(trolling, "Dex Explorer", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/raelhubfunctions/Save-scripts/refs/heads/main/DexMobile.lua"))()
end)

makeButton(basic, "fly GUI", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"))()
end)

makeButton(basic, "Shader", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/randomstring0/pshade-ultimate/refs/heads/main/src/cd.lua'))()
end)

makeButton(fun, "Music", function()
    loadstring(game:HttpGet(('https://raw.githubusercontent.com/Dan41/Roblox-Scripts/refs/heads/main/Youtube%20Music%20Player/YoutubeMusicPlayer.lua'),true))()
end)

makeButton(trolling, "Troll GUI", function()
    loadstring(game:HttpGet("https://pastefy.app/cZhmvb1G/raw"))()
end)

makeButton(basic, "ShiftLock Mobile", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/disaster-CREW/Shift-lock-for-mobile/refs/heads/main/shiftlock.lua"))()
end)

makeButton(trolling, "Avatar Copy GUI", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/darkdexv2/universalavatarchanger/main/avatarchanger"))()
end)

makeButton(fun, "AFEM MAX", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-AFEM-Max-Open-Alpha-50210"))()
end)


makeButton(fun, "Disco", function()
local player = game.Players.LocalPlayer
local mouse = player:GetMouse()

-- Функция для создания и запуска огненного шара
local function throwFireball()
    local fireball = Instance.new("Part")
    fireball.Size = Vector3.new(1, 1, 1)
    fireball.Shape = Enum.PartType.Ball
    fireball.Material = Enum.Material.Neon
    fireball.Position = player.Character.Head.Position + (player.Character.Head.CFrame.LookVector * 3)
    fireball.Anchored = false
    fireball.CanCollide = true
    fireball.Parent = workspace

    -- Функция для создания радужного эффекта
    local function updateColor()
        while fireball do
            for i = 0, 1, 0.1 do
                local color = Color3.fromHSV(i, 1, 1) -- Генерация радужного цвета
                fireball.BrickColor = BrickColor.new(color)
                wait(0.1) -- Задержка между изменениями цвета
            end
        end
    end

    -- Запускаем обновление цвета в отдельном потоке
    coroutine.wrap(updateColor)()

    -- Добавляем физику к огненному шару
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.Velocity = (mouse.Hit.p - fireball.Position).unit * 50 -- скорость полета
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Parent = fireball

    -- Удаляем огненный шар через 5 секунд
    game:GetService("Debris"):AddItem(fireball, 5)
end

-- Привязываем функцию к событию нажатия клавиши
mouse.Button1Down:Connect(throwFireball)
end)

makeButton(fun, "Rainbow Trail", function()
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    local trail = Instance.new("Trail")
    trail.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255,0,0)),
        ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,128,0)),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(255,255,0)),
        ColorSequenceKeypoint.new(0.6, Color3.fromRGB(0,255,0)),
        ColorSequenceKeypoint.new(0.8, Color3.fromRGB(0,0,255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(128,0,255)),
    }

    local a = Instance.new("Attachment", char.HumanoidRootPart)
    local b = Instance.new("Attachment", char.HumanoidRootPart)
    b.Position = Vector3.new(0, -2, 0)

    trail.Attachment0 = a
    trail.Attachment1 = b
    trail.Parent = char.HumanoidRootPart
end)

makeButton(fun, "Spin Effect", function()
    local hrp = game.Players.LocalPlayer.Character.HumanoidRootPart
    task.spawn(function()
        while true do
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(10), 0)
            task.wait()
        end
    end)
end)

makeButton(fun, "Cinematic Warm", function()
    local Lighting = game:GetService("Lighting")

    Lighting.Brightness = 2
    Lighting.ClockTime = 17
    Lighting.ExposureCompensation = 0.2
    Lighting.OutdoorAmbient = Color3.fromRGB(180, 140, 110)

    local cc = Lighting:FindFirstChild("DevwareColor") or Instance.new("ColorCorrectionEffect")
    cc.Name = "DevwareColor"
    cc.TintColor = Color3.fromRGB(255, 220, 190)
    cc.Saturation = -0.1
    cc.Contrast = 0.15
    cc.Parent = Lighting

    local bloom = Lighting:FindFirstChild("DevwareBloom") or Instance.new("BloomEffect")
    bloom.Name = "DevwareBloom"
    bloom.Intensity = 0.7
    bloom.Size = 24
    bloom.Threshold = 0.9
    bloom.Parent = Lighting

    local dof = Lighting:FindFirstChild("DevwareDOF") or Instance.new("DepthOfFieldEffect")
    dof.Name = "DevwareDOF"
    dof.FarIntensity = 0.4
    dof.FocusDistance = 25
    dof.InFocusRadius = 20
    dof.NearIntensity = 0.2
    dof.Parent = Lighting
end)
	
makeButton(basic, "Hologram Pet", function()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char then return end

    local pet = Instance.new("Part")
    pet.Shape = Enum.PartType.Ball
    pet.Size = Vector3.new(1.5, 1.5, 1.5)
    pet.Material = Enum.Material.Neon
    pet.Color = Color3.fromRGB(180, 90, 255)
    pet.Anchored = true
    pet.CanCollide = false
    pet.Parent = workspace

    -- Floating animation + follow
    task.spawn(function()
        while pet and char and char:FindFirstChild("HumanoidRootPart") do
            local t = tick()
            pet.CFrame = char.HumanoidRootPart.CFrame
                * CFrame.new(3, math.sin(t*3)*0.5 + 2, 0)
                * CFrame.Angles(0, t*2, 0)
            task.wait()
        end
    end)
end)

makeButton(fun, "FE Vehicle", function()
    loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-Vehicle-Script-V2-88610"))()
end)

makeButton(trolling, "FE Invisible", function()
      loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FE-Invisible-71225"))()
end)

-- DEFAULT PAGE
switchPage("Basic")
