local config = {
    version = "1.0.0",
    author = "kkirrune",
    github = "https://github.com/kkirrune",
    scripts_url = "https://raw.githubusercontent.com/kkirrune/scripts/main/",
    webhook_url = "https://discord.com/api/webhooks/",
    
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

-- Main executor class - ĐỔI TÊN TỪ XHider thành kkirru
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
    self.GUI.Name = "kkirru" -- Đổi tên GUI
    self.GUI.Parent = self.Services.CoreGui
    self.GUI.ResetOnSpawn = false
    
    -- Main container
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "Main"
    mainFrame.Size = UDim2.new(0, 500, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = self.GUI
    
    -- Top bar
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(1, 0, 0, 40)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    topBar.BorderSizePixel = 0
    topBar.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Text = "kkirru v" .. config.version .. " - NO KEY" -- Đổi tiêu đề
    title.Size = UDim2.new(0, 250, 1, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 18
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = topBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Text = "X"
    closeButton.Size = UDim2.new(0, 40, 1, 0)
    closeButton.Position = UDim2.new(1, -40, 0, 0)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Font = Enum.Font.GothamBold
    closeButton.TextSize = 18
    closeButton.Parent = topBar
    
    -- Tab buttons
    local tabsFrame = Instance.new("Frame")
    tabsFrame.Name = "Tabs"
    tabsFrame.Size = UDim2.new(0, 100, 1, -40)
    tabsFrame.Position = UDim2.new(0, 0, 0, 40)
    tabsFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    tabsFrame.BorderSizePixel = 0
    tabsFrame.Parent = mainFrame
    
    local tabs = {
        {name = "Executor", icon = "📜"},
        {name = "Scripts", icon = "📂"},
        {name = "Settings", icon = "⚙️"},
        {name = "Credits", icon = "👥"}
    }
    
    local tabButtons = {}
    local contentFrames = {}
    
    for i, tab in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tab.name
        tabButton.Text = tab.icon .. " " .. tab.name
        tabButton.Size = UDim2.new(1, 0, 0, 40)
        tabButton.Position = UDim2.new(0, 0, 0, (i-1) * 40)
        tabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
        tabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.Parent = tabsFrame
        tabButtons[i] = tabButton
        
        local contentFrame = Instance.new("Frame")
        contentFrame.Name = tab.name .. "Content"
        contentFrame.Size = UDim2.new(1, -100, 1, -40)
        contentFrame.Position = UDim2.new(0, 100, 0, 40)
        contentFrame.BackgroundTransparency = 1
        contentFrame.Visible = i == 1
        contentFrame.Parent = mainFrame
        contentFrames[i] = contentFrame
    end
    
    -- Executor tab content
    local executorContent = contentFrames[1]
    
    local scriptBox = Instance.new("TextBox")
    scriptBox.Name = "ScriptBox"
    scriptBox.Size = UDim2.new(1, -20, 0.7, -10)
    scriptBox.Position = UDim2.new(0, 10, 0, 10)
    scriptBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    scriptBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    scriptBox.Font = Enum.Font.Code
    scriptBox.TextSize = 14
    scriptBox.TextWrapped = true
    scriptBox.TextXAlignment = Enum.TextXAlignment.Left
    scriptBox.TextYAlignment = Enum.TextYAlignment.Top
    scriptBox.ClearTextOnFocus = false
    scriptBox.MultiLine = true
    scriptBox.Text = "-- Paste your script here\nprint('Hello kkirru!')" -- Đổi thông báo
    scriptBox.Parent = executorContent
    
    local executeButton = Instance.new("TextButton")
    executeButton.Text = "Execute"
    executeButton.Size = UDim2.new(0.3, 0, 0, 40)
    executeButton.Position = UDim2.new(0, 10, 1, -50)
    executeButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
    executeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    executeButton.Font = Enum.Font.GothamBold
    executeButton.TextSize = 16
    executeButton.Parent = executorContent
    
    local clearButton = Instance.new("TextButton")
    clearButton.Text = "Clear"
    clearButton.Size = UDim2.new(0.3, 0, 0, 40)
    clearButton.Position = UDim2.new(0.35, 10, 1, -50)
    clearButton.BackgroundColor3 = Color3.fromRGB(215, 60, 0)
    clearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    clearButton.Font = Enum.Font.Gotham
    clearButton.TextSize = 16
    clearButton.Parent = executorContent
    
    local copyButton = Instance.new("TextButton")
    copyButton.Text = "Copy Output"
    copyButton.Size = UDim2.new(0.3, 0, 0, 40)
    copyButton.Position = UDim2.new(0.7, 0, 1, -50)
    copyButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.Font = Enum.Font.Gotham
    copyButton.TextSize = 16
    copyButton.Parent = executorContent
    
    -- Scripts tab content
    local scriptsContent = contentFrames[2]
    
    local scriptsList = Instance.new("ScrollingFrame")
    scriptsList.Size = UDim2.new(1, -20, 1, -20)
    scriptsList.Position = UDim2.new(0, 10, 0, 10)
    scriptsList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    scriptsList.BorderSizePixel = 0
    scriptsList.ScrollBarThickness = 6
    scriptsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scriptsList.Parent = scriptsContent
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Padding = UDim.new(0, 5)
    uiListLayout.Parent = scriptsList
    
    for i, script in ipairs(self.Scripts) do
        local scriptFrame = Instance.new("Frame")
        scriptFrame.Size = UDim2.new(1, 0, 0, 60)
        scriptFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        scriptFrame.BorderSizePixel = 0
        scriptFrame.Parent = scriptsList
        
        local scriptName = Instance.new("TextLabel")
        scriptName.Text = script.name
        scriptName.Size = UDim2.new(0.7, 0, 0, 30)
        scriptName.Position = UDim2.new(0, 10, 0, 5)
        scriptName.BackgroundTransparency = 1
        scriptName.TextColor3 = Color3.fromRGB(255, 255, 255)
        scriptName.Font = Enum.Font.GothamBold
        scriptName.TextSize = 16
        scriptName.TextXAlignment = Enum.TextXAlignment.Left
        scriptName.Parent = scriptFrame
        
        local scriptAuthor = Instance.new("TextLabel")
        scriptAuthor.Text = "by " .. script.author
        scriptAuthor.Size = UDim2.new(0.7, 0, 0, 20)
        scriptAuthor.Position = UDim2.new(0, 10, 0, 35)
        scriptAuthor.BackgroundTransparency = 1
        scriptAuthor.TextColor3 = Color3.fromRGB(200, 200, 200)
        scriptAuthor.Font = Enum.Font.Gotham
        scriptAuthor.TextSize = 12
        scriptAuthor.TextXAlignment = Enum.TextXAlignment.Left
        scriptAuthor.Parent = scriptFrame
        
        local executeScriptButton = Instance.new("TextButton")
        executeScriptButton.Text = "Load"
        executeScriptButton.Size = UDim2.new(0.2, 0, 0, 40)
        executeScriptButton.Position = UDim2.new(0.75, -10, 0.5, -20)
        executeScriptButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
        executeScriptButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        executeScriptButton.Font = Enum.Font.Gotham
        executeScriptButton.TextSize = 14
        executeScriptButton.Parent = scriptFrame
        
        executeScriptButton.MouseButton1Click:Connect(function()
            local success, scriptSource = pcall(function()
                return game:HttpGet(script.url)
            end)
            
            if success then
                scriptBox.Text = scriptSource
                for i, frame in ipairs(contentFrames) do
                    frame.Visible = false
                end
                executorContent.Visible = true
                
                for _, btn in ipairs(tabButtons) do
                    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                end
                tabButtons[1].BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            else
                warn("Failed to load script: " .. script.name)
            end
        end)
    end
    
    -- Settings tab content (giữ nguyên, có thể tùy chỉnh thêm)
    local settingsContent = contentFrames[3]
    
    local settings = {
        {name = "Auto Execute", default = false},
        {name = "Auto Attach", default = true},
        {name = "Anti Ban", default = true},
        {name = "Anti Log", default = true},
        {name = "Notification Sounds", default = true},
        {name = "Transparency", default = 0.8, min = 0.1, max = 1, step = 0.1}
    }
    
    local settingsList = Instance.new("ScrollingFrame")
    settingsList.Size = UDim2.new(1, -20, 1, -20)
    settingsList.Position = UDim2.new(0, 10, 0, 10)
    settingsList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    settingsList.BorderSizePixel = 0
    settingsList.ScrollBarThickness = 6
    settingsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    settingsList.Parent = settingsContent
    
    local settingsUIList = Instance.new("UIListLayout")
    settingsUIList.Padding = UDim.new(0, 10)
    settingsUIList.Parent = settingsList
    
    for i, setting in ipairs(settings) do
        local settingFrame = Instance.new("Frame")
        settingFrame.Size = UDim2.new(1, 0, 0, 40)
        settingFrame.BackgroundTransparency = 1
        settingFrame.Parent = settingsList
        
        local settingName = Instance.new("TextLabel")
        settingName.Text = setting.name
        settingName.Size = UDim2.new(0.6, 0, 1, 0)
        settingName.BackgroundTransparency = 1
        settingName.TextColor3 = Color3.fromRGB(255, 255, 255)
        settingName.Font = Enum.Font.Gotham
        settingName.TextSize = 14
        settingName.TextXAlignment = Enum.TextXAlignment.Left
        settingName.Parent = settingFrame
        
        if setting.default == true or setting.default == false then
            local toggle = Instance.new("TextButton")
            toggle.Text = setting.default and "ON" or "OFF"
            toggle.Size = UDim2.new(0.3, 0, 0.7, 0)
            toggle.Position = UDim2.new(0.65, 0, 0.15, 0)
            toggle.BackgroundColor3 = setting.default and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(60, 60, 60)
            toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 14
            toggle.Parent = settingFrame
            
            toggle.MouseButton1Click:Connect(function()
                setting.default = not setting.default
                toggle.Text = setting.default and "ON" or "OFF"
                toggle.BackgroundColor3 = setting.default and Color3.fromRGB(0, 120, 215) or Color3.fromRGB(60, 60, 60)
                
                pcall(function()
                    if isfile("kkirru_settings.json") then
                        local settingsData = self.Services.HttpService:JSONDecode(readfile("kkirru_settings.json"))
                        settingsData[setting.name] = setting.default
                        writefile("kkirru_settings.json", self.Services.HttpService:JSONEncode(settingsData))
                    else
                        local settingsData = {[setting.name] = setting.default}
                        writefile("kkirru_settings.json", self.Services.HttpService:JSONEncode(settingsData))
                    end
                end)
            end)
        end
    end
    
    -- Credits tab content
    local creditsContent = contentFrames[4]
    
    local creditsText = Instance.new("TextLabel")
    creditsText.Text = [[
kkirru v]] .. config.version .. [[

Developers:
• kkirrune
• Special thanks to our contributors

GitHub: ]] .. config.github .. [[

This is a modified version with no key system.
    ]]
    creditsText.Size = UDim2.new(1, -40, 1, -40)
    creditsText.Position = UDim2.new(0, 20, 0, 20)
    creditsText.BackgroundTransparency = 1
    creditsText.TextColor3 = Color3.fromRGB(255, 255, 255)
    creditsText.Font = Enum.Font.Gotham
    creditsText.TextSize = 14
    creditsText.TextWrapped = true
    creditsText.TextXAlignment = Enum.TextXAlignment.Left
    creditsText.TextYAlignment = Enum.TextYAlignment.Top
    creditsText.Parent = creditsContent
    
    -- Button functionality
    executeButton.MouseButton1Click:Connect(function()
        local scriptToExecute = scriptBox.Text
        if scriptToExecute and scriptToExecute ~= "" then
            local success, errorMessage = pcall(function()
                loadstring(scriptToExecute)()
            end)
            
            if not success then
                warn("Execution error: " .. errorMessage)
            end
        end
    end)
    
    clearButton.MouseButton1Click:Connect(function()
        scriptBox.Text = ""
    end)
    
    copyButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(scriptBox.Text)
        end
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        self.GUI:Destroy()
        self.GUI = nil
    end)
    
    -- Tab switching
    for i, tabButton in ipairs(tabButtons) do
        tabButton.MouseButton1Click:Connect(function()
            for j, frame in ipairs(contentFrames) do
                frame.Visible = false
            end
            contentFrames[i].Visible = true
            
            for _, btn in ipairs(tabButtons) do
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
            end
            tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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
    
    -- Add watermark - ĐỔI TÊN
    local watermark = Instance.new("TextLabel")
    watermark.Text = "kkirru | FPS: 60" -- Đổi watermark
    watermark.Size = UDim2.new(0, 120, 0, 20)
    watermark.Position = UDim2.new(1, -130, 1, -25)
    watermark.BackgroundTransparency = 1
    watermark.TextColor3 = Color3.fromRGB(255, 255, 255)
    watermark.Font = Enum.Font.Gotham
    watermark.TextSize = 12
    watermark.Parent = mainFrame
    
    -- Update FPS counter
    local lastTime = tick()
    local frames = 0
    
    game:GetService("RunService").RenderStepped:Connect(function()
        frames = frames + 1
        local currentTime = tick()
        if currentTime - lastTime >= 1 then
            local fps = math.floor(frames / (currentTime - lastTime))
            watermark.Text = "kkirru | FPS: " .. fps -- Cập nhật watermark
            frames = 0
            lastTime = currentTime
        end
    end)
end

function kkirru:AutoUpdate()
    spawn(function()
        while task.wait(3600) do
            local success, latestVersion = pcall(function()
                return game:HttpGet(config.github .. "/version.txt")
            end)
            
            if success and latestVersion and latestVersion ~= config.version then
                warn("New version available: " .. latestVersion)
            end
        end
    end)
end

function kkirru:ExecuteScript(scriptName)
    for _, script in ipairs(self.Scripts) do
        if script.name == scriptName then
            local success, scriptSource = pcall(function()
                return game:HttpGet(script.url)
            end)
            
            if success then
                local success2, errorMessage = pcall(function()
                    loadstring(scriptSource)()
                end)
                
                if not success2 then
                    warn("Failed to execute " .. scriptName .. ": " .. errorMessage)
                end
            else
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
    local kkirruInstance = kkirru.new() -- Đổi tên biến
    
    -- Notify user - ĐỔI TÊN THÔNG BÁO
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "kkirru - No Key",
        Text = "Successfully loaded! No key required.",
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
                        title = "kkirru Execution Log", -- Đổi tiêu đề log
                        description = "User executed kkirru", -- Đổi mô tả
                        color = 0x00FF00,
                        fields = {
                            {name = "Username", value = game.Players.LocalPlayer.Name, inline = true},
                            {name = "User ID", value = tostring(game.Players.LocalPlayer.UserId), inline = true},
                            {name = "Game", value = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, inline = false},
                            {name = "Executor", value = identifyexecutor and identifyexecutor() or "Unknown", inline = true},
                            {name = "Time", value = os.date("%Y-%m-%d %H:%M:%S"), inline = true}
                        },
                        footer = {text = "kkirru v" .. config.version} -- Đổi footer
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
    warn("kkirru failed to load: " .. (errorMsg or "Unknown error")) -- Đổi thông báo lỗi
end

return kkirru
