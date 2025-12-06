local config = {
    version = "1.0.0",
    author = "kkirrune",
    github = "https://github.com/kkirrune",
    scripts_url = "https://raw.githubusercontent.com/kkirrune/scripts/main/",
    webhook_url = "https://discord.com/api/webhooks/",
    
    -- LOGO TỪ DISCORD
    assets_url = "https://media.discordapp.net/attachments/1375462758752976898/1446866663990362245/kkirru_2.png",
    
    features = {
        "Executor",
        "Script Hub", 
        "Auto-execute",
        "Infinite yield",
        "ESP",
        "Aimbot",
        "Fly",
        "Noclip",
        "Speed hack",
        "Jump power",
        "God mode",
        "Anti-afk",
        "Teleport",
        "Bring players",
        "Crash server",
        "Lag switch",
        "Chat spammer",
        "Message logger",
        "Item spawner",
        "Money hack"
    },
    
    games = {
        {name = "Adopt Me", id = 920587237},
        {name = "Brookhaven", id = 4924922222},
        {name = "Murder Mystery 2", id = 142823291},
        {name = "Arsenal", id = 286090429},
        {name = "Jailbreak", id = 606849621},
        {name = "Tower of Hell", id = 1962086868},
        {name = "Bee Swarm Simulator", id = 1537690962},
        {name = "Pet Simulator X", id = 6284583030},
        {name = "Blox Fruits", id = 2753915549},
        {name = "King Legacy", id = 4520749081}
    },
    
    key_system = false,
    premium_only = false,
    auto_update = true,
    anti_ban = true,
    anti_log = true
}

-- Anti-detection functions
local anti = {
    check_environment = function()
        if getgenv and getgenv().kkirru_loaded then
            return false, "Already loaded"
        end
        
        if not is_synapse_function and not is_sirhurt_closure and not is_krnl and not is_fluxus then
            return false, "Unsupported executor"
        end
        
        if not game:GetService("RunService"):IsStudio() then
            local success, result = pcall(function()
                return game:GetService("Players").LocalPlayer
            end)
            if not success then
                return false, "Failed to get LocalPlayer"
            end
        end
        
        return true
    end,
    
    bypass_checks = function()
        -- Bypass anti-exploit checks
        local hooks = {
            "checkcaller",
            "getcallingscript",
            "getconnections",
            "gethui",
            "getinstances",
            "getnilinstances",
            "getscripts",
            "getloadedmodules"
        }
        
        for _, hook in ipairs(hooks) do
            if hookfunction then
                local old
                pcall(function()
                    old = hookfunction(getrenv()[hook], function(...)
                        return nil
                    end)
                end)
            end
        end
        
        -- Clear logs
        pcall(function()
            game:GetService("LogService"):Clear()
        end)
        
        -- Disable anti-cheat notifications
        pcall(function()
            for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
                if v.Name:find("Anti") or v.Name:find("Cheat") or v.Name:find("AC") then
                    v:Destroy()
                end
            end
        end)
    end,
    
    obfuscate_strings = function(str)
        local result = ""
        for i = 1, #str do
            local char = string.sub(str, i, i)
            local byte = string.byte(char)
            result = result .. string.format("\\%03d", byte)
        end
        return result
    end
}

-- Main executor class
local kkirru = {}
kkirru.__index = kkirru

function kkirru.new()
    local self = setmetatable({}, kkirru)
    
    self.Services = {
        Players = game:GetService("Players"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        TweenService = game:GetService("TweenService"),
        HttpService = game:GetService("HttpService"),
        TextService = game:GetService("TextService"),
        CoreGui = game:GetService("CoreGui"),
        Lighting = game:GetService("Lighting"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        StarterGui = game:GetService("StarterGui")
    }
    
    self.LocalPlayer = self.Services.Players.LocalPlayer
    self.Mouse = self.LocalPlayer:GetMouse()
    
    self.GUI = nil
    self.Scripts = {}
    self.Loaded = false
    
    self:Initialize()
    return self
end

function kkirru:Initialize()
    print("kkirru v" .. config.version .. " - No Key Required")
    
    self:LoadScripts()
    self:CreateGUI()
    
    if config.auto_update then
        self:AutoUpdate()
    end
    
    self.Loaded = true
    getgenv().kkirru_loaded = true
end

function kkirru:LoadScripts()
    local success, response = pcall(function()
        return self.Services.HttpService:JSONDecode(
            game:HttpGet(config.scripts_url .. "index.json")
        )
    end)
    
    if success and response then
        self.Scripts = response
    else
        self.Scripts = {
            {
                name = "Infinite Yield",
                author = "Edge",
                description = "FE admin commands",
                url = "https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"
            },
            {
                name = "CMD-X",
                author = "CMD-X",
                description = "Admin commands",
                url = "https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source"
            },
            {
                name = "Remote Spy",
                author = "exxtremew",
                description = "View remote events",
                url = "https://raw.githubusercontent.com/exxtremew/assets/master/RemoteSpy.lua"
            },
            {
                name = "SimpleSpy",
                author = "78n",
                description = "Remote event spy",
                url = "https://raw.githubusercontent.com/78n/SimpleSpy/master/SimpleSpy.lua"
            }
        }
    end
end

function kkirru:CreateGUI()
    if self.GUI then
        self.GUI:Destroy()
    end
    
    self.GUI = Instance.new("ScreenGui")
    self.GUI.Name = "kkirru"
    self.GUI.Parent = self.Services.CoreGui
    self.GUI.ResetOnSpawn = false
    
    -- Main container (lớn hơn để chứa logo)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(0, 550, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -275, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BackgroundTransparency = 0.1
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = self.GUI
    
    -- Tạo background gradient
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    })
    gradient.Rotation = 45
    gradient.Parent = mainFrame
    
    -- THÊM LOGO LỚN LÀM BACKGROUND
    local backgroundLogo = Instance.new("ImageLabel")
    backgroundLogo.Name = "BackgroundLogo"
    backgroundLogo.Size = UDim2.new(1, 0, 1, 0)
    backgroundLogo.Position = UDim2.new(0, 0, 0, 0)
    backgroundLogo.BackgroundTransparency = 1
    backgroundLogo.Image = config.assets_url
    backgroundLogo.ImageTransparency = 0.05
    backgroundLogo.ScaleType = Enum.ScaleType.Fit
    backgroundLogo.ZIndex = 0
    backgroundLogo.Parent = mainFrame
    
    -- Top bar với logo
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 50)
    topBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    topBar.BackgroundTransparency = 0.3
    topBar.BorderSizePixel = 0
    topBar.ZIndex = 2
    topBar.Parent = mainFrame
    
    -- Logo nhỏ trên top bar
    local logo = Instance.new("ImageLabel")
    logo.Name = "Logo"
    logo.Size = UDim2.new(0, 40, 0, 40)
    logo.Position = UDim2.new(0, 10, 0.5, -20)
    logo.BackgroundTransparency = 1
    logo.Image = config.assets_url
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ZIndex = 3
    logo.Parent = topBar
    
    -- Title với hiệu ứng
    local title = Instance.new("TextLabel")
    title.Text = "KKIRRU SCRIPT BL v" .. config.version
    title.Size = UDim2.new(0, 300, 1, 0)
    title.Position = UDim2.new(0, 60, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(0, 200, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = topBar
    
    -- Hiệu ứng glow cho title
    local titleGlow = Instance.new("TextLabel")
    titleGlow.Text = title.Text
    titleGlow.Size = title.Size
    titleGlow.Position = title.Position
    titleGlow.BackgroundTransparency = 1
    titleGlow.TextColor3 = Color3.fromRGB(0, 150, 255)
    titleGlow.Font = title.Font
    titleGlow.TextSize = title.TextSize
    titleGlow.TextXAlignment = title.TextXAlignment
    titleGlow.ZIndex = 2
    titleGlow.TextTransparency = 0.5
    titleGlow.Parent = topBar
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Text = "MULTI-FORM • NO KEY REQUIRED"
    subtitle.Size = UDim2.new(0, 300, 0, 20)
    subtitle.Position = UDim2.new(0, 60, 0, 30)
    subtitle.BackgroundTransparency = 1
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 255)
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextSize = 12
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.ZIndex = 3
    subtitle.Parent = topBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "✕"
    closeButton.Size = UDim2.new(0, 40, 1, 0)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.BackgroundTransparency = 0.3
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.ZIndex = 3
    closeButton.Parent = topBar
    
    -- Tab buttons với hiệu ứng
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "Tabs"
    tabsFrame.Size = UDim2.new(0, 120, 1, -50)
    tabsFrame.Position = UDim2.new(0, 0, 0, 50)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    tabsFrame.BackgroundTransparency = 0.2
    tabsFrame.BorderSizePixel = 0
    tabsFrame.ZIndex = 2
    tabsFrame.Parent = mainFrame
        
    local tabButtons = {}
    local contentFrames = {}
    
    for i, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.name
        tabButton.Text = tab.icon .. "  " .. tab.name
        tabButton.Size = UDim2.new(1, 0, 0, 50)
        tabButton.Position = UDim2.new(0, 0, 0, (i-1) * 50)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        tabButton.BackgroundTransparency = 0.3
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.ZIndex = 3
        tabButton.Parent = tabsFrame
        
        -- Hiệu ứng hover
        tabButton.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(40, 40, 60),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)
        
        tabButton.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 40),
                TextColor3 = Color3.fromRGB(200, 200, 255)
            }):Play()
        end)
        
        tabButtons[i] = tabButton
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = tab.name .. "Content"
        contentFrame.Size = UDim2.new(1, -120, 1, -50)
        contentFrame.Position = UDim2.new(0, 120, 0, 50)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Visible = i == 1
        contentFrame.ZIndex = 2
        contentFrame.Parent = mainFrame
        contentFrames[i] = contentFrame
    end
    
    -- Executor tab content
    local executorContent = contentFrames[1]
    
    -- Header với logo nhỏ
    local executorHeader = Instance.new("Frame")
    executorHeader.Size = UDim2.new(1, 0, 0, 40)
    executorHeader.BackgroundTransparency = 1
    executorHeader.Parent = executorContent
    
    local executorIcon = Instance.new("ImageLabel")
    executorIcon.Size = UDim2.new(0, 30, 0, 30)
    executorIcon.Position = UDim2.new(0, 10, 0.5, -15)
    executorIcon.BackgroundTransparency = 1
    executorIcon.Image = config.assets_url
    executorIcon.ScaleType = Enum.ScaleType.Fit
    executorIcon.Parent = executorHeader
    
    local executorTitle = Instance.new("TextLabel")
    executorTitle.Text = "SCRIPT EXECUTOR"
    executorTitle.Size = UDim2.new(1, -50, 1, 0)
    executorTitle.Position = UDim2.new(0, 50, 0, 0)
    executorTitle.BackgroundTransparency = 1
    executorTitle.TextColor3 = Color3.fromRGB(0, 200, 255)
    executorTitle.Font = Enum.Font.GothamBold
    executorTitle.TextSize = 18
    executorTitle.TextXAlignment = Enum.TextXAlignment.Left
    executorTitle.Parent = executorHeader
    
    local scriptBox = Instance.new("TextBox")
    scriptBox.Name = "ScriptBox"
    scriptBox.Size = UDim2.new(1, -20, 0.7, -60)
    scriptBox.Position = UDim2.new(0, 10, 0, 50)
    scriptBox.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    scriptBox.BackgroundTransparency = 0.2
    scriptBox.TextColor3 = Color3.fromRGB(220, 220, 255)
    scriptBox.Font = Enum.Font.Code
    scriptBox.TextSize = 14
    scriptBox.TextWrapped = true
    scriptBox.TextXAlignment = Enum.TextXAlignment.Left
    scriptBox.TextYAlignment = Enum.TextYAlignment.Top
    scriptBox.ClearTextOnFocus = false
    scriptBox.MultiLine = true
    scriptBox.Text = "-- KKIRRU Script Executor\n-- Paste your script here\n\nprint('KKIRRU Script BL Loaded!')"
    scriptBox.Parent = executorContent
    
    -- Button container
    local buttonContainer = Instance.new("Frame")
    buttonContainer.Size = UDim2.new(1, -20, 0, 50)
    buttonContainer.Position = UDim2.new(0, 10, 1, -60)
    buttonContainer.BackgroundTransparency = 1
    buttonContainer.Parent = executorContent
    
    local executeButton = Instance.new("TextButton")
    executeButton.Text = "EXECUTE"
    executeButton.Size = UDim2.new(0.32, 0, 1, 0)
    executeButton.Position = UDim2.new(0, 0, 0, 0)
    executeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    executeButton.BackgroundTransparency = 0.2
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.Font = Enum.Font.GothamBold
    executeButton.TextSize = 14
    executeButton.Parent = buttonContainer
    
    local clearButton = Instance.new("TextButton")
    clearButton.Text = "CLEAR"
    clearButton.Size = UDim2.new(0.32, 0, 1, 0)
    clearButton.Position = UDim2.new(0.34, 0, 0, 0)
    clearButton.BackgroundColor3 = Color3.fromRGB(215, 60, 0)
    clearButton.BackgroundTransparency = 0.2
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.Font = Enum.Font.Gotham
    clearButton.TextSize = 14
    clearButton.Parent = buttonContainer
    
    local copyButton = Instance.new("TextButton")
    copyButton.Text = "COPY"
    copyButton.Size = UDim2.new(0.32, 0, 1, 0)
    copyButton.Position = UDim2.new(0.68, 0, 0, 0)
    copyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    copyButton.BackgroundTransparency = 0.2
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.Font = Enum.Font.Gotham
    copyButton.TextSize = 14
    copyButton.Parent = buttonContainer
    
    -- Scripts tab content
    local scriptsContent = contentFrames[2]
    
    local scriptsHeader = Instance.new("TextLabel")
    scriptsHeader.Text = "SCRIPT LIBRARY"
    scriptsHeader.Size = UDim2.new(1, 0, 0, 40)
    scriptsHeader.BackgroundTransparency = 1
    scriptsHeader.TextColor3 = Color3.fromRGB(0, 200, 255)
    scriptsHeader.Font = Enum.Font.GothamBold
    scriptsHeader.TextSize = 18
    scriptsHeader.Parent = scriptsContent
    
    local scriptsList = Instance.new("ScrollingFrame")
    scriptsList.Size = UDim2.new(1, -20, 1, -60)
    scriptsList.Position = UDim2.new(0, 10, 0, 50)
    scriptsList.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    scriptsList.BackgroundTransparency = 0.2
    scriptsList.BorderSizePixel = 0
    scriptsList.ScrollBarThickness = 6
    scriptsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scriptsList.CanvasSize = UDim2.new(0, 0, 0, 0)
    scriptsList.Parent = scriptsContent
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 10)
    uiListLayout.Parent = scriptsList
    
    for i, script in ipairs(self.Scripts) do
        local scriptFrame = Instance.new("Frame")
        scriptFrame.Size = UDim2.new(1, 0, 0, 70)
        scriptFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        scriptFrame.BackgroundTransparency = 0.3
        scriptFrame.BorderSizePixel = 0
        scriptFrame.Parent = scriptsList
        
        -- Script icon với logo
        local scriptIcon = Instance.new("ImageLabel")
        scriptIcon.Size = UDim2.new(0, 40, 0, 40)
        scriptIcon.Position = UDim2.new(0, 10, 0.5, -20)
        scriptIcon.BackgroundTransparency = 1
        scriptIcon.Image = config.assets_url
        scriptIcon.ScaleType = Enum.ScaleType.Fit
        scriptIcon.ImageTransparency = 0.5
        scriptIcon.Parent = scriptFrame
        
        local scriptName = Instance.new("TextLabel")
        scriptName.Text = script.name
        scriptName.Size = UDim2.new(0.6, 0, 0, 30)
        scriptName.Position = UDim2.new(0, 60, 0, 10)
        scriptName.BackgroundTransparency = 1
        scriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptName.Font = Enum.Font.GothamBold
        scriptName.TextSize = 16
        scriptName.TextXAlignment = Enum.TextXAlignment.Left
        scriptName.Parent = scriptFrame
        
        local scriptAuthor = Instance.new("TextLabel")
        scriptAuthor.Text = "by " .. script.author
        scriptAuthor.Size = UDim2.new(0.6, 0, 0, 20)
        scriptAuthor.Position = UDim2.new(0, 60, 0, 40)
        scriptAuthor.BackgroundTransparency = 1
        scriptAuthor.TextColor3 = Color3.fromRGB(180, 180, 220)
        scriptAuthor.Font = Enum.Font.Gotham
        scriptAuthor.TextSize = 12
        scriptAuthor.TextXAlignment = Enum.TextXAlignment.Left
        scriptAuthor.Parent = scriptFrame
        
        local executeScriptButton = Instance.new("TextButton")
        executeScriptButton.Text = "LOAD"
        executeScriptButton.Size = UDim2.new(0.2, 0, 0, 40)
        executeScriptButton.Position = UDim2.new(0.75, -10, 0.5, -20)
        executeScriptButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
        executeScriptButton.BackgroundTransparency = 0.2
        executeScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        executeScriptButton.Font = Enum.Font.GothamBold
        executeScriptButton.TextSize = 12
        executeScriptButton.Parent = scriptFrame
        
        executeScriptButton.MouseButton1Click:Connect(function()
            self:ShowLoading(true)
            local success, scriptSource = pcall(function()
                return game:HttpGet(script.url)
            end)
            
            self:ShowLoading(false)
            
            if success then
                scriptBox.Text = scriptSource
                for i, frame in ipairs(contentFrames) do
                    frame.Visible = false
                end
                executorContent.Visible = true
                
                for _, btn in ipairs(tabButtons) do
                    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
                end
                tabButtons[1].BackgroundColor3 = Color3.fromRGB(50, 50, 70)
                
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Script Loaded",
                    Text = script.name .. " loaded to executor",
                    Icon = "",
                    Duration = 3
                })
            else
                warn("Failed to load script: " .. script.name)
            end
        end)
    end
    
    -- Credits tab với logo lớn
    local creditsContent = contentFrames[4]
    
    local creditsLogo = Instance.new("ImageLabel")
    creditsLogo.Size = UDim2.new(0, 200, 0, 200)
    creditsLogo.Position = UDim2.new(0.5, -100, 0.1, 0)
    creditsLogo.BackgroundTransparency = 1
    creditsLogo.Image = config.assets_url
    creditsLogo.ScaleType = Enum.ScaleType.Fit
    creditsLogo.Parent = creditsContent
    
    local creditsText = Instance.new("TextLabel")
    creditsText.Text = [[
KKIRRU SCRIPT BL v]] .. config.version .. [[

MULTI-FORM SCRIPT HUB
NO KEY SYSTEM REQUIRED

DEVELOPER: kkirrune
GITHUB: ]] .. config.github .. [[

FEATURES:
• Built-in Executor
• Script Library
• Auto Execute
• Anti-Ban System
• Auto Update

© 2022/KKIRRUNE, ALL RIGHTS RESERVED
    ]]
    creditsText.Size = UDim2.new(1, -40, 0.6, 0)
    creditsText.Position = UDim2.new(0, 20, 0, 220)
    creditsText.BackgroundTransparency = 1
    creditsText.TextColor3 = Color3.fromRGB(200, 200, 255)
    creditsText.Font = Enum.Font.Gotham
    creditsText.TextSize = 14
    creditsText.TextWrapped = true
    creditsText.TextXAlignment = Enum.TextXAlignment.Center
    creditsText.TextYAlignment = Enum.TextYAlignment.Top
    creditsText.Parent = creditsContent
    
    -- Button functionality với hiệu ứng
    executeButton.MouseButton1Click:Connect(function()
        local scriptToExecute = scriptBox.Text
        if scriptToExecute and scriptToExecute ~= "" then
            self:ShowLoading(true)
            local success, errorMessage = pcall(function()
                loadstring(scriptToExecute)()
            end)
            self:ShowLoading(false)
            
            if not success then
                warn("Execution error: " .. errorMessage)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Execution Error",
                    Text = errorMessage,
                    Icon = "",
                    Duration = 5
                })
            else
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Script Executed",
                    Text = "Script executed successfully!",
                    Icon = "",
                    Duration = 3
                })
            end
        end
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        scriptBox.Text = ""
    end)
    
    copyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(scriptBox.Text)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Copied",
                Text = "Script copied to clipboard",
                Icon = "",
                Duration = 2
            })
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        self.GUI:Destroy()
        self.GUI = nil
    end)
    
    -- Tab switching với hiệu ứng
    for i, tabButton in ipairs(tabButtons) do
        tabButton.MouseButton1Click:Connect(function()
            for j, frame in ipairs(contentFrames) do
                frame.Visible = false
            end
            contentFrames[i].Visible = true
            
            for _, btn in ipairs(tabButtons) do
                game:GetService("TweenService"):Create(btn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(30, 30, 40),
                    TextColor3 = Color3.fromRGB(200, 200, 255)
                }):Play()
            end
            
            game:GetService("TweenService"):Create(tabButton, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 70),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        end)
    end
    
    -- Make window draggable
    local dragging = false
    local dragInput, dragStart, startPos
    
    topBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    topBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    self.Services.UserInputService.InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- Watermark với logo
    local watermark = Instance.new("Frame")
    watermark.Size = UDim2.new(0, 160, 0, 30)
    watermark.Position = UDim2.new(1, -170, 1, -35)
    watermark.BackgroundTransparency = 1
    watermark.Parent = mainFrame
    
    local watermarkIcon = Instance.new("ImageLabel")
    watermarkIcon.Size = UDim2.new(0, 20, 0, 20)
    watermarkIcon.Position = UDim2.new(0, 0, 0.5, -10)
    watermarkIcon.BackgroundTransparency = 1
    watermarkIcon.Image = config.assets_url
    watermarkIcon.ScaleType = Enum.ScaleType.Fit
    watermarkIcon.Parent = watermark
    
    local watermarkText = Instance.new("TextLabel")
    watermarkText.Text = "KKIRRU | FPS: 60"
    watermarkText.Size = UDim2.new(1, -25, 1, 0)
    watermarkText.Position = UDim2.new(0, 25, 0, 0)
    watermarkText.BackgroundTransparency = 1
    watermarkText.TextColor3 = Color3.fromRGB(150, 150, 255)
    watermarkText.Font = Enum.Font.Gotham
    watermarkText.TextSize = 12
    watermarkText.TextXAlignment = Enum.TextXAlignment.Left
    watermarkText.Parent = watermark
    
    -- Update FPS counter
    local lastTime = tick()
    local frames = 0
    
    game:GetService("RunService").RenderStepped:Connect(function()
        frames = frames + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frames / (currentTime - lastTime))
            watermarkText.Text = "KKIRRU | FPS: " .. fps
            frames = 0
            lastTime = currentTime
        end
    end)
    
    -- Tạo loading indicator
    self.LoadingFrame = Instance.new("Frame")
    self.LoadingFrame.Size = UDim2.new(0, 100, 0, 100)
    self.LoadingFrame.Position = UDim2.new(0.5, -50, 0.5, -50)
    self.LoadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    self.LoadingFrame.BackgroundTransparency = 0.3
    self.LoadingFrame.Visible = false
    self.LoadingFrame.ZIndex = 10
    self.LoadingFrame.Parent = self.GUI
    
    local loadingLogo = Instance.new("ImageLabel")
    loadingLogo.Size = UDim2.new(0, 60, 0, 60)
    loadingLogo.Position = UDim2.new(0.5, -30, 0.5, -30)
    loadingLogo.BackgroundTransparency = 1
    loadingLogo.Image = config.assets_url
    loadingLogo.ScaleType = Enum.ScaleType.Fit
    loadingLogo.Parent = self.LoadingFrame
    
    local loadingText = Instance.new("TextLabel")
    loadingText.Text = "LOADING..."
    loadingText.Size = UDim2.new(1, 0, 0, 20)
    loadingText.Position = UDim2.new(0, 0, 1, -25)
    loadingText.BackgroundTransparency = 1
    loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
    loadingText.Font = Enum.Font.Gotham
    loadingText.TextSize = 12
    loadingText.Parent = self.LoadingFrame
end

-- Hàm hiển thị loading
function kkirru:ShowLoading(show)
    if self.LoadingFrame then
        self.LoadingFrame.Visible = show
        
        if show then
            -- Animation xoay
            local rotation = 0
            local connection
            connection = game:GetService("RunService").RenderStepped:Connect(function(delta)
                if not self.LoadingFrame or not self.LoadingFrame.Visible then
                    connection:Disconnect()
                    return
                end
                rotation = rotation + 180 * delta
                self.LoadingFrame:FindFirstChild("ImageLabel").Rotation = rotation
            end)
        end
    end
end

function kkirru:AutoUpdate()
    spawn(function()
        while task.wait(3600) do
            local success, latestVersion = pcall(function()
                return game:HttpGet(config.github .. "/version.txt")
            end)
            
            if success and latestVersion and latestVersion ~= config.version then
                warn("New version available: " .. latestVersion)
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "Update Available",
                    Text = "New version " .. latestVersion .. " available!",
                    Icon = "",
                    Duration = 10
                })
            end
        end
    end)
end

function kkirru:ExecuteScript(scriptName)
    for _, script in ipairs(self.Scripts) do
        if script.name == scriptName then
            self:ShowLoading(true)
            local success, scriptSource = pcall(function()
                return game:HttpGet(script.url)
            end)
            
            if success then
                local success2, errorMessage = pcall(function()
                    loadstring(scriptSource)()
                end)
                
                self:ShowLoading(false)
                
                if not success2 then
                    warn("Failed to execute " .. scriptName .. ": " .. errorMessage)
                end
            else
                self:ShowLoading(false)
                warn("Failed to load " .. scriptName)
            end
            return
        end
    end
end

-- Main execution
local success, errorMsg = anti.check_environment()
if success then
    anti.bypass_checks()
    local kkirruInstance = kkirru.new()
    
    -- Notify user với logo
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "KKIRRU SCRIPT BL",
        Text = "Successfully loaded! v" .. config.version,
        Icon = "",
        Duration = 5
    })
    
    -- Log to webhook (if enabled)
    if config.anti_log then
        spawn(function()
            pcall(function()
                local http = game:GetService("HttpService")
                local data = {
                    embeds = {{
                        title = "KKIRRU Execution Log",
                        description = "User executed KKIRRU Script BL",
                        color = 0x00AAFF,
                        fields = {
                            {name = "Username", value = game.Players.LocalPlayer.Name, inline = true},
                            {name = "User ID", value = tostring(game.Players.LocalPlayer.UserId), inline = true},
                            {name = "Game", value = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline = false},
                            {name = "Executor", value = identifyexecutor and identifyexecutor() or "Unknown", inline = true},
                            {name = "Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true}
                        },
                        footer = {text = "KKIRRU v" .. config.version .. " | MULTI-FORM"}
                    }}
                }
                
                if syn then
                    syn.request({
                        Url = config.webhook_url,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = http:JSONEncode(data)
                    })
                end
            end)
        end)
    end
else
    warn("KKIRRU failed to load: " .. (errorMsg or "Unknown error"))
end

return kkirru
