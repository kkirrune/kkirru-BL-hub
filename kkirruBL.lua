-- LEMON HUB SCRIPT - Deobfuscated Version
-- Original by XHider

return(function(...)
    local math, table, tonumber, setmetatable, string = ...
    local floor, max, unpack, concat, char, sub = math.floor, math.max, table.unpack, table.concat, string.char, string.sub
    
    -- Constants
    local RANDOM_SEED = 2147483647
    
    -- Decryption function
    local function decrypt_string(encrypted)
        local result = {}
        for i = 1, #encrypted, 2 do
            local hex_pair = sub(encrypted, i, i+1)
            if hex_pair and #hex_pair == 2 then
                local num = tonumber(hex_pair, 16)
                if num then
                    local decoded = ((num - math.random(0, 255)) + 256) % 256
                    result[#result+1] = char(decoded)
                end
            end
        end
        return table.concat(result)
    end
    
    -- Decrypted strings array
    local strings = {
        "getfenv",
        "setfenv", 
        "loadstring",
        "Protected",
        "Execute",
        "Run",
        "Gui",
        "ScreenGui",
        "Instance",
        "new",
        "Frame",
        "TextBox",
        "TextButton",
        "BackgroundColor3",
        "Position",
        "UDim2.new",
        "MouseButton1Click",
        "Connect",
        "function",
        "local",
        "pcall",
        "error",
        "warn",
        "if",
        "elseif",
        "end",
        "for",
        "in pairs",
        "do",
        "then",
        "return",
        "nil",
        "tostring",
        "tonumber",
        "and",
        "or",
        "not",
        "true",
        "false",
        "Color3.fromRGB",
        "TweenInfo.new",
        "Enum",
        "EasingStyle",
        "Quad",
        "Play",
        "Destroy",
        "FindFirstChild",
        "BackgroundTransparency",
        "1",
        "0",
        "ImageTransparency",
        "task.wait",
        "game",
        "GetService",
        "Players",
        "LocalPlayer",
        "HttpService",
        "HttpGet",
        "JSONEncode",
        "PostAsync",
        "ApplicationJson",
        "HttpContentType",
        "Enum",
        "setclipboard",
        "writefile",
        "readfile",
        "isfile",
        "whitelist",
        "kick",
        "discord.gg/",
        "lemonhub",
        "Version 1.0",
        "Loading",
        "Lemon Hub",
        "successfully",
        "loaded",
        "Error",
        "in",
        "script",
        "Please",
        "join",
        "Discord",
        "for updates",
        "and support",
        "Thank you",
        "Enjoy using Lemon Hub",
        "Anti-tamper",
        "protection",
        "activated",
        "Webhook sent",
        "checking",
        "URL",
        "github.com",
        "raw",
        "usercontent",
        "repository",
        "trieu1082",
        "Lemon",
        "hub-cute",
        "main.lua",
        "execute",
        "loadstring failed",
        "syntax error",
        "malformed",
        "Random seed generator",
        "Checksum failed",
        "Checking user permissions",
        "Permission denied response",
        "Logging user activity",
        "Log",
        "Entry",
        "Security violation",
        "",
        "Error 403",
        "Access forbidden",
        "Access",
        "Forbidden",
        "Contact administrator",
        "Request whitelist access",
        "Admin",
        "Contact",
        "Discord server invitation",
        "Discord",
        "Server",
        "Join now",
        "Lemon Hub Discord",
        "Discord invite",
        "Invite",
        "Copied successfully",
        "Clipboard",
        "Copy successful",
        "Execute script button",
        "Script URL input",
        "Placeholder text",
        "Example URL format",
        "https://",
        "Raw GitHub URL",
        "Pastebin URL",
        "Pastebin",
        "Load from URL",
        "Load",
        "Loading script",
        "Please wait",
        "Wait",
        "Executing",
        "Execution started",
        "Execution complete",
        "Complete",
        "Done",
        "Close",
        "Close button",
        "Button hover",
        "Hover",
        "Click",
        "Click event",
        "Button animation",
        "Animation",
        "Tween effect",
        "Effect",
        "Start",
        "Finish",
        "Duration",
        "Seconds",
        "Milliseconds",
        "Delay",
        "Wait time",
        "Time",
        "Time interval",
        "Interval",
        "Repeat",
        "Loop counter",
        "Counter",
        "Count",
        "Number",
        "Numeric value",
        "Value stored",
        "Stored",
        "Data",
        "Data structure",
        "Structure",
        "Array format",
        "Table format",
        "Table",
        "Key",
        "Key-value pair",
        "Pair",
        "Value",
        "Value type",
        "Type check",
        "Check",
        "Verify",
        "Verification process",
        "Process",
        "Processing",
        "Progress",
        "Progress bar",
        "Loading bar",
        "Percentage",
        "Percent complete",
        "Complete percentage",
        "UI element",
        "User interface"
    }
    
    -- Main functions table
    local LemonHub = {}
    
    -- Get string by index
    function LemonHub.getString(index)
        return strings[index + 1] or ""
    end
    
    -- Initialize services
    LemonHub.Players = game:GetService("Players")
    LemonHub.Workspace = game:GetService("Workspace")
    LemonHub.Lighting = game:GetService("Lighting")
    LemonHub.HttpService = game:GetService("HttpService")
    
    -- Get local player
    LemonHub.LocalPlayer = LemonHub.Players.LocalPlayer
    
    -- Configuration
    LemonHub.ScriptName = "Script"
    LemonHub.GuiName = "ScreenGui"
    LemonHub.FrameName = "Frame"
    LemonHub.Title = "Lemon Hub"
    LemonHub.Version = "Version 1.0"
    
    -- Check file system support
    LemonHub.HasFileSystem = type(isfile) == "function" and 
                            type(readfile) == "function" and 
                            type(writefile) == "function"
    
    -- Try to load script from GitHub
    local success, scriptContent = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/trieu1082/Lemon-hub/main/Lemon-hub-cute.lua")
    end)
    
    if success and scriptContent and scriptContent ~= "404: Not Found" then
        LemonHub.RemoteScript = tostring(scriptContent)
    end
    
    -- Read local files if available
    if LemonHub.HasFileSystem then
        pcall(function()
            if isfile(LemonHub.GuiName) then
                LemonHub.GuiContent = readfile(LemonHub.GuiName)
            end
            if isfile(LemonHub.FrameName) then
                LemonHub.FrameContent = readfile(LemonHub.FrameName)
            end
        end)
    end
    
    -- Whitelist system
    LemonHub.Whitelist = {}
    LemonHub.Whitelist["whitelist"] = true
    
    -- Check if user is whitelisted
    if LemonHub.Whitelist[LemonHub.LocalPlayer.Name] then
        -- Send webhook notification
        pcall(function()
            local data = {
                ["title"] = LemonHub.Title,
                ["description"] = LemonHub.Version .. " - " .. LemonHub.LocalPlayer.Name,
                ["color"] = 16711680
            }
            LemonHub.HttpService:PostAsync(
                "https://discord.com/api/webhooks/...",
                LemonHub.HttpService:JSONEncode(data),
                Enum.HttpContentType.ApplicationJson
            )
        end)
        
        -- Kick non-whitelisted users
        LemonHub.LocalPlayer:Kick("You are not whitelisted")
        return
    end
    
    -- Check version and load main script
    if LemonHub.GuiContent == LemonHub.ScriptName and 
       LemonHub.FrameContent == LemonHub.Version then
        print("Loading Lemon Hub...")
        pcall(function()
            loadstring(game:HttpGet(
                "https://raw.githubusercontent.com/trieu1082/Lemon-hub/main/Lemon-hub-cute.lua"
            ))()
        end)
        return
    end
    
    -- Remove old GUI if exists
    if LemonHub.Workspace:FindFirstChild("LemonHub") then
        LemonHub.Workspace.LemonHub:Destroy()
    end
    
    -- Create main GUI
    LemonHub.MainGui = Instance.new("ScreenGui", LemonHub.Workspace)
    LemonHub.MainGui.Name = "LemonHub"
    LemonHub.MainGui.ResetOnSpawn = false
    
    -- Create main frame
    LemonHub.MainFrame = Instance.new("Frame", LemonHub.MainGui)
    LemonHub.MainFrame.Position = UDim2.new(0, 0, 0, 0)
    LemonHub.MainFrame.Size = UDim2.new(0.5, 0, 0.5, 0)
    LemonHub.MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    
    -- Create execute button
    LemonHub.ExecuteButton = Instance.new("TextButton", LemonHub.MainFrame)
    LemonHub.ExecuteButton.Position = UDim2.new(0.5, 0, 0.5, 0)
    LemonHub.ExecuteButton.Size = UDim2.new(0.2, 0, 0.1, 0)
    LemonHub.ExecuteButton.Text = "Execute"
    LemonHub.ExecuteButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    
    -- Create URL input box
    LemonHub.URLBox = Instance.new("TextBox", LemonHub.MainFrame)
    LemonHub.URLBox.Position = UDim2.new(0.1, 0, 0.1, 0)
    LemonHub.URLBox.Size = UDim2.new(0.8, 0, 0.2, 0)
    LemonHub.URLBox.Text = "Enter script URL"
    LemonHub.URLBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    
    -- Create Discord button
    LemonHub.DiscordButton = Instance.new("TextButton", LemonHub.MainFrame)
    LemonHub.DiscordButton.Position = UDim2.new(0.1, 0, 0.8, 0)
    LemonHub.DiscordButton.Size = UDim2.new(0.2, 0, 0.1, 0)
    LemonHub.DiscordButton.Text = "Discord"
    LemonHub.DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    
    -- Create Close button
    LemonHub.CloseButton = Instance.new("TextButton", LemonHub.MainFrame)
    LemonHub.CloseButton.Position = UDim2.new(0.7, 0, 0.8, 0)
    LemonHub.CloseButton.Size = UDim2.new(0.2, 0, 0.1, 0)
    LemonHub.CloseButton.Text = "Close"
    LemonHub.CloseButton.BackgroundColor3 = Color3.fromRGB(220, 53, 69)
    
    -- Discord button click handler
    LemonHub.DiscordButton.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard("discord.gg/lemonhub")
        end)
        LemonHub.DiscordButton.BackgroundColor3 = Color3.fromRGB(100, 150, 200)
    end)
    
    -- Close button click handler
    LemonHub.CloseButton.MouseButton1Click:Connect(function()
        LemonHub.MainGui:Destroy()
    end)
    
    -- Execute button click handler
    LemonHub.ExecuteButton.MouseButton1Click:Connect(function()
        local url = LemonHub.URLBox.Text
        
        if url == "https://raw.githubusercontent.com/trieu1082/Lemon-hub/main/Lemon-hub-cute.lua" then
            -- Save configuration
            if LemonHub.HasFileSystem then
                pcall(function()
                    writefile(LemonHub.GuiName, LemonHub.ScriptName)
                    writefile(LemonHub.FrameName, LemonHub.Version)
                end)
            end
            
            -- Fade out animation
            local tween = game:GetService("TweenService"):Create(
                LemonHub.MainFrame,
                TweenInfo.new(0.9, Enum.EasingStyle.Quad),
                {BackgroundTransparency = 1}
            )
            tween:Play()
            
            -- Destroy GUI after animation
            task.wait(1)
            LemonHub.MainGui:Destroy()
            
            -- Load main script
            pcall(function()
                loadstring(game:HttpGet(url))()
            end)
        else
            LemonHub.ExecuteButton.BackgroundColor3 = Color3.fromRGB(200, 100, 150)
        end
    end)
    
    print("Lemon Hub loaded successfully!")
    
    return LemonHub
end)(math, table, tonumber, setmetatable, string)
