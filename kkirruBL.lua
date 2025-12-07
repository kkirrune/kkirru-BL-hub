-- This file was created by XHider https://discord.com/invite/E2N7w35zkt

return(function(...)
    local math, table, tonumber, setmetatable, string = ...
    local floor, max, unpack, concat, char, sub = math.floor, math.max, table.unpack, table.concat, string.char, string.sub
    
    local RANDOM_SEED = 2147483647
    
    -- Auto-detect Sea Level
    local function GetSeaLevel()
        local plr = game:GetService("Players").LocalPlayer
        if plr and plr.Data and plr.Data.Level then
            local level = plr.Data.Level.Value
            
            if level >= 700 then
                return 3
            elseif level >= 300 then
                return 2
            else
                return 1
            end
        end
        return 1
    end
    
    -- Server Hopping System
    local ServerHop = {
        ConfigFile = "ServerHopConfig.json",
        
        GetLowPlayerServers = function()
            local servers = {}
            local success, result = pcall(function()
                return game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"))
            end)
            
            if success and result and result.data then
                for _, server in ipairs(result.data) do
                    if server.playing < 5 and server.id ~= game.JobId then
                        table.insert(servers, {
                            id = server.id,
                            players = server.playing,
                            ping = server.ping or 100
                        })
                    end
                end
            end
            return servers
        end,
        
        HopToBestServer = function()
            local servers = ServerHop.GetLowPlayerServers()
            if #servers > 0 then
                table.sort(servers, function(a, b)
                    if a.players == b.players then
                        return a.ping < b.ping
                    end
                    return a.players < b.players
                end)
                
                local bestServer = servers[1]
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, bestServer.id)
                return true
            end
            return false
        end,
        
        AutoHopWhenFull = function(maxPlayers)
            maxPlayers = maxPlayers or 8
            local playerCount = #game:GetService("Players"):GetPlayers()
            
            if playerCount > maxPlayers then
                ServerHop.HopToBestServer()
            end
        end,
        
        SaveConfig = function(config)
            if writefile then
                writefile(ServerHop.ConfigFile, game:GetService("HttpService"):JSONEncode(config))
            end
        end,
        
        LoadConfig = function()
            if readfile and isfile(ServerHop.ConfigFile) then
                return game:GetService("HttpService"):JSONDecode(readfile(ServerHop.ConfigFile))
            end
            return {maxPlayers = 8, autoHop = true, hopDelay = 60}
        end
    }
    
    -- FPS Booster System
    local FPSBooster = {
        ConfigFile = "FPSConfig.json",
        
        Optimize = function()
            -- Remove unnecessary effects
            for _, effect in pairs(game:GetDescendants()) do
                if effect:IsA("ParticleEmitter") or effect:IsA("Trail") or effect:IsA("Smoke") or effect:IsA("Fire") then
                    effect:Destroy()
                end
            end
            
            -- Reduce graphics quality
            settings().Rendering.QualityLevel = 1
            
            -- Remove grass and trees
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    if part.Name:find("Grass") or part.Name:find("Tree") or part.Name:find("Bush") then
                        part.Transparency = 1
                        part.CanCollide = false
                    end
                end
            end
            
            -- Optimize lighting
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 100000
            lighting.Brightness = 2
            lighting.ClockTime = 14
            
            -- Reduce texture quality
            for _, decal in pairs(workspace:GetDescendants()) do
                if decal:IsA("Decal") then
                    decal:Destroy()
                end
            end
        end,
        
        SaveConfig = function(config)
            if writefile then
                writefile(FPSBooster.ConfigFile, game:GetService("HttpService"):JSONEncode(config))
            end
        end,
        
        LoadConfig = function()
            if readfile and isfile(FPSBooster.ConfigFile) then
                return game:GetService("HttpService"):JSONDecode(readfile(FPSBooster.ConfigFile))
            end
            return {removeEffects = true, removeGrass = true, optimizeLighting = true}
        end
    }
    
    -- Fast Farming System
    local FastFarm = {
        ConfigFile = "FarmConfig.json",
        
        AutoQuest = function()
            local plr = game:GetService("Players").LocalPlayer
            local seaLevel = GetSeaLevel()
            
            if seaLevel == 1 then
                -- Sea 1 Quests
                if plr.Data.Level.Value < 10 then
                    return {"Bandit", 10}
                elseif plr.Data.Level.Value < 25 then
                    return {"Monkey", 25}
                elseif plr.Data.Level.Value < 50 then
                    return {"Gorilla", 50}
                elseif plr.Data.Level.Value < 75 then
                    return {"Pirate", 75}
                elseif plr.Data.Level.Value < 100 then
                    return {"Brute", 100}
                elseif plr.Data.Level.Value < 125 then
                    return {"Desert Bandit", 125}
                elseif plr.Data.Level.Value < 150 then
                    return {"Desert Officer", 150}
                end
                
            elseif seaLevel == 2 then
                -- Sea 2 Quests
                if plr.Data.Level.Value < 175 then
                    return {"Snow Bandit", 175}
                elseif plr.Data.Level.Value < 225 then
                    return {"Snowman", 225}
                elseif plr.Data.Level.Value < 275 then
                    return {"Chief Petty Officer", 275}
                elseif plr.Data.Level.Value < 300 then
                    return {"Sky Bandit", 300}
                elseif plr.Data.Level.Value < 350 then
                    return {"Dark Master", 350}
                elseif plr.Data.Level.Value < 400 then
                    return {"Galley Captain", 400}
                elseif plr.Data.Level.Value < 450 then
                    return {"Galley Pirate", 450}
                end
                
            elseif seaLevel == 3 then
                -- Sea 3 Quests
                if plr.Data.Level.Value < 475 then
                    return {"Mercenary", 475}
                elseif plr.Data.Level.Value < 525 then
                    return {"Swan Pirate", 525}
                elseif plr.Data.Level.Value < 575 then
                    return {"Magma Admiral", 575}
                elseif plr.Data.Level.Value < 625 then
                    return {"Lava Pirate", 625}
                elseif plr.Data.Level.Value < 675 then
                    return {"Arctic Warrior", 675}
                elseif plr.Data.Level.Value < 725 then
                    return {"Snow Lurker", 725}
                elseif plr.Data.Level.Value < 775 then
                    return {"Sea Soldier", 775}
                elseif plr.Data.Level.Value < 800 then
                    return {"Water Fighter", 800}
                end
            end
            
            return {"", 0}
        end,
        
        AutoFarm = function()
            local quest = FastFarm.AutoQuest()
            if quest[1] ~= "" then
                -- Auto accept quest
                for _, npc in pairs(workspace:GetDescendants()) do
                    if npc:IsA("Model") and npc.Name:find(quest[1]) then
                        local humanoid = npc:FindFirstChild("Humanoid")
                        if humanoid then
                            -- Auto attack
                            game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").CFrame = npc:WaitForChild("HumanoidRootPart").CFrame
                            task.wait(0.5)
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game)
                            task.wait(0.1)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "X", false, game)
                        end
                    end
                end
            end
        end,
        
        SaveConfig = function(config)
            if writefile then
                writefile(FastFarm.ConfigFile, game:GetService("HttpService"):JSONEncode(config))
            end
        end,
        
        LoadConfig = function()
            if readfile and isfile(FastFarm.ConfigFile) then
                return game:GetService("HttpService"):JSONDecode(readfile(FastFarm.ConfigFile))
            end
            return {autoFarm = true, autoQuest = true, attackSpeed = 0.1}
        end
    }
    
    -- Blox Fruits Teleport System
    local BloxFruitsTP = {
        ConfigFile = "TeleportConfig.json",
        
        Sea1Islands = {
            ["Starter Island"] = CFrame.new(-1071.6, 15.8, 1425.6),
            ["Marine Starter"] = CFrame.new(-2562.8, 6.9, 2045.4),
            ["Pirate Starter"] = CFrame.new(-1162.9, 4.8, 3855.5),
            ["Middle Town"] = CFrame.new(-655.8, 7.9, 1437.7),
            ["Jungle"] = CFrame.new(-1612.8, 36.9, 149.1),
            ["Pirate Village"] = CFrame.new(-1181.3, 4.8, 3806.3),
            ["Desert"] = CFrame.new(944.2, 20.4, 4373.8),
            ["Snowy Village"] = CFrame.new(1355.5, 87.3, -1325.5),
            ["Marine Fortress"] = CFrame.new(-4914.5, 50.5, 4281.3),
            ["Sky Island 1"] = CFrame.new(-4970.2, 718.0, -2622.0),
            ["Sky Island 2"] = CFrame.new(-4813.2, 718.0, -1913.3),
            ["Sky Island 3"] = CFrame.new(-7952.2, 5545.7, -307.7),
            ["Prison"] = CFrame.new(4875.7, 5.7, 734.0),
            ["Colosseum"] = CFrame.new(-1836.6, 7.9, -1362.2),
            ["Mob Leader"] = CFrame.new(-2846.3, 7.9, 5318.8),
            ["Magma Village"] = CFrame.new(-5231.0, 8.6, 8467.4),
            ["Underwater City"] = CFrame.new(61163.9, 11.8, 1819.8),
            ["Fountain City"] = CFrame.new(5128.3, 59.5, 4105.5),
            ["Shank's Room"] = CFrame.new(-1442.2, 29.9, -28.0),
            ["Mob Island"] = CFrame.new(-2850.2, 7.9, 5354.9)
        },
        
        Sea2Islands = {
            ["Cafe"] = CFrame.new(-385.3, 73.0, 285.9),
            ["Faint City"] = CFrame.new(291.6, 109.4, -1870.6),
            ["Green Zone"] = CFrame.new(-2270.0, 73.0, -2596.9),
            ["Factory"] = CFrame.new(430.4, 210.7, -427.6),
            ["Colosseum"] = CFrame.new(-1836.6, 44.6, 1362.2),
            ["Ghost Island"] = CFrame.new(-5575.1, 87.9, -393.1),
            ["Graveyard"] = CFrame.new(-5589.3, 87.9, -393.1),
            ["Snow Mountain"] = CFrame.new(904.2, 200.8, -1063.8),
            ["Hot Island"] = CFrame.new(-5508.7, 15.1, -536.5),
            ["Cold Island"] = CFrame.new(-5923.8, 15.1, -4997.5),
            ["Volcano"] = CFrame.new(-5231.3, 8.6, 8467.5),
            ["Usoapp Island"] = CFrame.new(4762.8, 8.4, -2849.3),
            ["Mini Sky Island"] = CFrame.new(-4925.4, 721.1, -2623.1),
            ["Great Tree"] = CFrame.new(2681.6, 1682.8, -719.2),
            ["Castle on the Sea"] = CFrame.new(-5411.5, 314.5, -2975.9),
            ["Hydra Island"] = CFrame.new(5545.1, 668.4, 195.1),
            ["Floating Turtle"] = CFrame.new(-12505.6, 337.2, -7487.6),
            ["Mansion"] = CFrame.new(-12468.6, 374.9, -7553.6),
            ["Haunted Castle"] = CFrame.new(-9515.7, 142.1, 5528.9),
            ["Ice Castle"] = CFrame.new(5400.4, 28.2, -6235.4)
        },
        
        Sea3Islands = {
            ["Port Town"] = CFrame.new(-290.4, 6.9, 5343.6),
            ["Hydra Island"] = CFrame.new(5545.1, 668.4, 195.1),
            ["Great Tree"] = CFrame.new(2681.6, 1682.8, -719.2),
            ["Castle on the Sea"] = CFrame.new(-5411.5, 314.5, -2975.9),
            ["Floating Turtle"] = CFrame.new(-12505.6, 337.2, -7487.6),
            ["Haunted Castle"] = CFrame.new(-9515.7, 142.1, 5528.9),
            ["Ice Castle"] = CFrame.new(5400.4, 28.2, -6235.4),
            ["Forgotten Island"] = CFrame.new(-3051.9, 238.9, -10147.6),
            ["Usoapp Island"] = CFrame.new(4762.8, 8.4, -2849.3),
            ["Mini Sky Island"] = CFrame.new(-4925.4, 721.1, -2623.1),
            ["Kingdom of Rose"] = CFrame.new(-388.5, 138.2, 5614.4),
            ["Green Zone"] = CFrame.new(-2270.0, 73.0, -2596.9),
            ["Factory"] = CFrame.new(430.4, 210.7, -427.6),
            ["Colosseum"] = CFrame.new(-1836.6, 44.6, 1362.2),
            ["Swan Mansion"] = CFrame.new(923.2, 125.4, 32852.8),
            ["Dark Arena"] = CFrame.new(3748.8, 14.3, -2995.6),
            ["Cafe"] = CFrame.new(-385.3, 73.0, 285.9),
            ["Fountain City"] = CFrame.new(5128.3, 59.5, 4105.5),
            ["The Cafe"] = CFrame.new(-382.3, 73.0, 297.3),
            ["Jeremy's Restaurant"] = CFrame.new(-1082.8, 15.5, 1586.4)
        },
        
        TeleportTo = function(islandName)
            local seaLevel = GetSeaLevel()
            local islands = {}
            
            if seaLevel == 1 then
                islands = BloxFruitsTP.Sea1Islands
            elseif seaLevel == 2 then
                islands = BloxFruitsTP.Sea2Islands
            elseif seaLevel == 3 then
                islands = BloxFruitsTP.Sea3Islands
            end
            
            if islands[islandName] then
                local char = game:GetService("Players").LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = islands[islandName]
                    return true
                end
            end
            return false
        end,
        
        AutoTeleportQuest = function()
            local quest = FastFarm.AutoQuest()
            if quest[1] ~= "" then
                local npcName = quest[1]
                
                -- Find NPC location and teleport
                for islandName, _ in pairs(BloxFruitsTP.Sea1Islands) do
                    if islandName:find(npcName) then
                        BloxFruitsTP.TeleportTo(islandName)
                        break
                    end
                end
                
                for islandName, _ in pairs(BloxFruitsTP.Sea2Islands) do
                    if islandName:find(npcName) then
                        BloxFruitsTP.TeleportTo(islandName)
                        break
                    end
                end
                
                for islandName, _ in pairs(BloxFruitsTP.Sea3Islands) do
                    if islandName:find(npcName) then
                        BloxFruitsTP.TeleportTo(islandName)
                        break
                    end
                end
            end
        end,
        
        SaveConfig = function(config)
            if writefile then
                writefile(BloxFruitsTP.ConfigFile, game:GetService("HttpService"):JSONEncode(config))
            end
        end,
        
        LoadConfig = function()
            if readfile and isfile(BloxFruitsTP.ConfigFile) then
                return game:GetService("HttpService"):JSONDecode(readfile(BloxFruitsTP.ConfigFile))
            end
            return {autoTeleport = true, teleportDelay = 1, safeTeleport = true}
        end
    }
    
    -- Weapon Quest System
    local WeaponQuests = {
        ConfigFile = "WeaponConfig.json",
        
        Weapons = {
            ["Saber"] = {
                sea = 1,
                requirements = {
                    {"Defeat 5 Military Soldiers", "Military Soldier", 5},
                    {"Defeat 5 Military Officers", "Military Officer", 5},
                    {"Defeat 5 Military Spies", "Military Spy", 5}
                },
                npc = "Saber Expert",
                location = CFrame.new(-1452.6, 88.3, -147.4)
            },
            
            ["Rengoku"] = {
                sea = 2,
                requirements = {
                    {"Collect 20 Secret Keys", "Secret Key", 20},
                    {"Defeat Awakened Ice Admiral", "Awakened Ice Admiral", 1}
                },
                npc = "Legendary Sword Dealer",
                location = CFrame.new(-5113.6, 314.5, -2961.3)
            },
            
            ["Midnight Blade"] = {
                sea = 2,
                requirements = {
                    {"Defeat 50 Elite Pirates", "Elite Pirate", 50},
                    {"Defeat 30 Elite Hunters", "Elite Hunter", 30}
                },
                npc = "Elite Hunter",
                location = CFrame.new(-11834.1, 334.2, -8847.9)
            },
            
            ["Dragon Trident"] = {
                sea = 2,
                requirements = {
                    {"Defeat 50 Fishman Warriors", "Fishman Warrior", 50},
                    {"Defeat 25 Fishman Lords", "Fishman Lord", 25}
                },
                npc = "Forgotten Sage",
                location = CFrame.new(-3051.9, 238.9, -10147.6)
            },
            
            ["Yama"] = {
                sea = 3,
                requirements = {
                    {"Defeat 30 Soul Reapers", "Soul Reaper", 30},
                    {"Defeat 10 Cursed Captains", "Cursed Captain", 10}
                },
                npc = "Ghost",
                location = CFrame.new(-9515.7, 142.1, 5528.9)
            },
            
            ["Tushita"] = {
                sea = 3,
                requirements = {
                    {"Defeat 20 Longmas", "Longma", 20},
                    {"Defeat 3 Dough Kings", "Dough King", 3}
                },
                npc = "Ancient Monk",
                location = CFrame.new(-10238.9, 391.0, -9549.8)
            },
            
            ["Cursed Dual Katana"] = {
                sea = 3,
                requirements = {
                    {"Own Yama", "Yama", 1},
                    {"Own Tushita", "Tushita", 1}
                },
                npc = "Cursed Swordsmith",
                location = CFrame.new(916.2, 125.4, 32844.2)
            },
            
            ["True Triple Katana"] = {
                sea = 3,
                requirements = {
                    {"Own Saddi", "Saddi", 1},
                    {"Own Shisui", "Shisui", 1},
                    {"Own Wando", "Wando", 1}
                },
                npc = "Sword Master",
                location = CFrame.new(-5359.6, 424.0, -2737.7)
            }
        },
        
        AutoGetWeapon = function(weaponName)
            local weapon = WeaponQuests.Weapons[weaponName]
            if weapon and weapon.sea <= GetSeaLevel() then
                -- Teleport to NPC
                local char = game:GetService("Players").LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = weapon.location
                    
                    -- Auto complete requirements
                    for _, req in ipairs(weapon.requirements) do
                        local mobName = req[2]
                        local count = req[3]
                        
                        -- Auto farm mobs
                        for i = 1, count do
                            FastFarm.AutoFarm()
                            task.wait(0.5)
                        end
                    end
                    
                    return true
                end
            end
            return false
        end,
        
        GetAvailableWeapons = function()
            local available = {}
            local seaLevel = GetSeaLevel()
            
            for weaponName, weaponData in pairs(WeaponQuests.Weapons) do
                if weaponData.sea <= seaLevel then
                    table.insert(available, weaponName)
                end
            end
            
            return available
        end,
        
        SaveConfig = function(config)
            if writefile then
                writefile(WeaponQuests.ConfigFile, game:GetService("HttpService"):JSONEncode(config))
            end
        end,
        
        LoadConfig = function()
            if readfile and isfile(WeaponQuests.ConfigFile) then
                return game:GetService("HttpService"):JSONDecode(readfile(WeaponQuests.ConfigFile))
            end
            return {autoWeapon = true, weaponPriority = {"Saber", "Rengoku", "Midnight Blade"}}
        end
    }
    
    -- Main GUI System (NO ICONS)
    local KkirruHub = {}
    
    KkirruHub.CreateGUI = function()
        -- Load all configs
        local serverConfig = ServerHop.LoadConfig()
        local fpsConfig = FPSBooster.LoadConfig()
        local farmConfig = FastFarm.LoadConfig()
        local tpConfig = BloxFruitsTP.LoadConfig()
        local weaponConfig = WeaponQuests.LoadConfig()
        
        -- Create main GUI
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "KkirruHub"
        ScreenGui.Parent = game:GetService("CoreGui")
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Size = UDim2.new(0, 400, 0, 500)
        MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
        MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui
        
        -- Title (NO ICON)
        local Title = Instance.new("TextLabel")
        Title.Size = UDim2.new(1, 0, 0, 50)
        Title.Position = UDim2.new(0, 0, 0, 0)
        Title.Text = "KKIRRU HUB v2.0"
        Title.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
        Title.Font = Enum.Font.GothamBold
        Title.TextSize = 24
        Title.Parent = MainFrame
        
        -- Sea Level Display
        local SeaLabel = Instance.new("TextLabel")
        SeaLabel.Size = UDim2.new(1, -20, 0, 30)
        SeaLabel.Position = UDim2.new(0, 10, 0, 60)
        SeaLabel.Text = "Current Sea: " .. GetSeaLevel()
        SeaLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
        SeaLabel.BackgroundTransparency = 1
        SeaLabel.Font = Enum.Font.Gotham
        SeaLabel.TextSize = 18
        SeaLabel.Parent = MainFrame
        
        -- Server Hop Button (NO ICON)
        local ServerHopBtn = Instance.new("TextButton")
        ServerHopBtn.Size = UDim2.new(1, -20, 0, 40)
        ServerHopBtn.Position = UDim2.new(0, 10, 0, 100)
        ServerHopBtn.Text = "Server Hop (Low Players)"
        ServerHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ServerHopBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        ServerHopBtn.Font = Enum.Font.Gotham
        ServerHopBtn.TextSize = 16
        ServerHopBtn.Parent = MainFrame
        
        ServerHopBtn.MouseButton1Click:Connect(function()
            ServerHop.HopToBestServer()
        end)
        
        -- FPS Boost Button (NO ICON)
        local FPSBtn = Instance.new("TextButton")
        FPSBtn.Size = UDim2.new(1, -20, 0, 40)
        FPSBtn.Position = UDim2.new(0, 10, 0, 150)
        FPSBtn.Text = "Boost FPS (Remove Effects)"
        FPSBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        FPSBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        FPSBtn.Font = Enum.Font.Gotham
        FPSBtn.TextSize = 16
        FPSBtn.Parent = MainFrame
        
        FPSBtn.MouseButton1Click:Connect(function()
            FPSBooster.Optimize()
        end)
        
        -- Auto Farm Button (NO ICON)
        local FarmBtn = Instance.new("TextButton")
        FarmBtn.Size = UDim2.new(1, -20, 0, 40)
        FarmBtn.Position = UDim2.new(0, 10, 0, 200)
        FarmBtn.Text = "Auto Farm + Quest"
        FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        FarmBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        FarmBtn.Font = Enum.Font.Gotham
        FarmBtn.TextSize = 16
        FarmBtn.Parent = MainFrame
        
        FarmBtn.MouseButton1Click:Connect(function()
            FastFarm.AutoFarm()
        end)
        
        -- Teleport Section
        local TeleportLabel = Instance.new("TextLabel")
        TeleportLabel.Size = UDim2.new(1, -20, 0, 30)
        TeleportLabel.Position = UDim2.new(0, 10, 0, 250)
        TeleportLabel.Text = "Quick Teleport:"
        TeleportLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        TeleportLabel.BackgroundTransparency = 1
        TeleportLabel.Font = Enum.Font.Gotham
        TeleportLabel.TextSize = 16
        TeleportLabel.Parent = MainFrame
        
        local TeleportBox = Instance.new("TextBox")
        TeleportBox.Size = UDim2.new(1, -20, 0, 40)
        TeleportBox.Position = UDim2.new(0, 10, 0, 280)
        TeleportBox.PlaceholderText = "Enter island name..."
        TeleportBox.Text = ""
        TeleportBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        TeleportBox.Font = Enum.Font.Gotham
        TeleportBox.TextSize = 16
        TeleportBox.Parent = MainFrame
        
        -- Teleport Button (NO ICON)
        local TeleportBtn = Instance.new("TextButton")
        TeleportBtn.Size = UDim2.new(1, -20, 0, 40)
        TeleportBtn.Position = UDim2.new(0, 10, 0, 330)
        TeleportBtn.Text = "Teleport"
        TeleportBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        TeleportBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
        TeleportBtn.Font = Enum.Font.Gotham
        TeleportBtn.TextSize = 16
        TeleportBtn.Parent = MainFrame
        
        TeleportBtn.MouseButton1Click:Connect(function()
            BloxFruitsTP.TeleportTo(TeleportBox.Text)
        end)
        
        -- Weapon Quest Button (NO ICON)
        local WeaponBtn = Instance.new("TextButton")
        WeaponBtn.Size = UDim2.new(1, -20, 0, 40)
        WeaponBtn.Position = UDim2.new(0, 10, 0, 380)
        WeaponBtn.Text = "Auto Weapon Quest"
        WeaponBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        WeaponBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        WeaponBtn.Font = Enum.Font.Gotham
        WeaponBtn.TextSize = 16
        WeaponBtn.Parent = MainFrame
        
        WeaponBtn.MouseButton1Click:Connect(function()
            local weapons = WeaponQuests.GetAvailableWeapons()
            if #weapons > 0 then
                WeaponQuests.AutoGetWeapon(weapons[1])
            end
        end)
        
        -- Close Button (NO ICON)
        local CloseBtn = Instance.new("TextButton")
        CloseBtn.Size = UDim2.new(1, -20, 0, 40)
        CloseBtn.Position = UDim2.new(0, 10, 0, 430)
        CloseBtn.Text = "Close GUI"
        CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        CloseBtn.Font = Enum.Font.Gotham
        CloseBtn.TextSize = 16
        CloseBtn.Parent = MainFrame
        
        CloseBtn.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)
        
        -- Status Label
        local StatusLabel = Instance.new("TextLabel")
        StatusLabel.Size = UDim2.new(1, -20, 0, 30)
        StatusLabel.Position = UDim2.new(0, 10, 0, 480)
        StatusLabel.Text = "Status: Ready"
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        StatusLabel.BackgroundTransparency = 1
        StatusLabel.Font = Enum.Font.Gotham
        StatusLabel.TextSize = 14
        StatusLabel.Parent = MainFrame
        
        -- Auto-start features
        if fpsConfig.optimizeLighting then
            FPSBooster.Optimize()
            StatusLabel.Text = "Status: FPS Optimized"
        end
        
        if farmConfig.autoFarm then
            spawn(function()
                while task.wait(0.1) do
                    FastFarm.AutoFarm()
                end
            end)
            StatusLabel.Text = "Status: Auto Farm Started"
        end
        
        if serverConfig.autoHop then
            spawn(function()
                while task.wait(serverConfig.hopDelay) do
                    ServerHop.AutoHopWhenFull(serverConfig.maxPlayers)
                end
            end)
            StatusLabel.Text = "Status: Auto Hop Enabled"
        end
        
        if tpConfig.autoTeleport then
            spawn(function()
                while task.wait(tpConfig.teleportDelay) do
                    BloxFruitsTP.AutoTeleportQuest()
                end
            end)
            StatusLabel.Text = "Status: Auto Teleport Enabled"
        end
        
        -- Update Teleport Box with suggestions
        local function UpdateTeleportSuggestions()
            local seaLevel = GetSeaLevel()
            local islands = {}
            
            if seaLevel == 1 then
                islands = BloxFruitsTP.Sea1Islands
            elseif seaLevel == 2 then
                islands = BloxFruitsTP.Sea2Islands
            elseif seaLevel == 3 then
                islands = BloxFruitsTP.Sea3Islands
            end
            
            TeleportBox.PlaceholderText = "Type island name (Sea " .. seaLevel .. ")"
        end
        
        UpdateTeleportSuggestions()
        
        return ScreenGui
    end
    
    -- Start the hub
    local gui = KkirruHub.CreateGUI()
    
    -- Print console message
    print("==========================================")
    print("KKIRRU-BL HUB LOADED SUCCESSFULLY!")
    print("==========================================")
    
    return KkirruHub
end)(math, table, tonumber, setmetatable, string)
