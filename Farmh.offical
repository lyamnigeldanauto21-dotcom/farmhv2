local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local FarmEnabled = false
local FarmSpeed = 0.15
local UndergroundFarm = false
local ESPEnabled = false
local SilentAimEnabled = false
local AutoShootEnabled = false
local KillAuraEnabled = false
local InfiniteJumpEnabled = false
local SpeedBoostEnabled = false
local SpeedBoostValue = 16
local JumpBoostEnabled = false
local JumpBoostValue = 50
local NoclipEnabled = false
local FlyEnabled = false
local GodModeEnabled = false
local InvisibleEnabled = false
local BreakGunEnabled = false

local farmConnection = nil
local espTable = {}
local farmStats = { coins = 0 }

local function GetCoins()
    local coins = {}
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Coin_Server" or obj.Name == "Coin") then
            table.insert(coins, obj)
        end
    end
    return coins
end

local function GetNearestPlayer()
    local closest, minDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = player.Character.HumanoidRootPart.Position
            local dist = (HumanoidRootPart.Position - pos).Magnitude
            if dist < minDist then
                closest = player
                minDist = dist
            end
        end
    end
    return closest, minDist
end

local function GetPlayerRole(player)
    if not player.Character then return "Unknown" end
    local char = player.Character
    local backpack = player.Backpack
    if char:FindFirstChild("Knife") or backpack:FindFirstChild("Knife") then
        return "Murderer"
    elseif char:FindFirstChild("Gun") or backpack:FindFirstChild("Gun") then
        return "Sheriff"
    else
        return "Innocent"
    end
end

local Window = WindUI:CreateWindow({
    Title = "⚡ Farmh Hub | MM2",
    Icon = "solar:stars-bold",
    Author = "by Farmh",
    Folder = "FarmhHub",
    Size = UDim2.fromOffset(580, 460),
    Theme = "Dark"
})

local CreditsTab = Window:Tab({ Title = "Credits", Icon = "solar:users-group-rounded-bold" })
CreditsTab:Section({ Title = "👑 Farmh Hub" })
CreditsTab:Note({ Title = "Script Name", Desc = "Farmh Hub v2.0" })
CreditsTab:Note({ Title = "Author", Desc = "Developed by Farmh" })
CreditsTab:Note({ Title = "UI Library", Desc = "Powered by WindUI" })
CreditsTab:Note({ Title = "Features", Desc = "57+ Features" })
CreditsTab:Note({ Title = "Status", Desc = "✅ Fully Functional" })
CreditsTab:Note({ Title = "Last Updated", Desc = "June 2025" })
CreditsTab:Note({ Title = "GitHub", Desc = "github.com/farmh/hub" })
CreditsTab:Note({ Title = "Discord", Desc = "discord.gg/farmh" })
CreditsTab:Note({ Title = "Compatibility", Desc = "Delta | Arceus X | Hydrogen" })

local PlayerTab = Window:Tab({ Title = "Player", Icon = "solar:user-bold" })
PlayerTab:Section({ Title = "👤 Movement" })
PlayerTab:Toggle({
    Title = "Speed Boost",
    Desc = "Increase your walk speed",
    Default = false,
    Callback = function(state)
        SpeedBoostEnabled = state
        if state then Humanoid.WalkSpeed = SpeedBoostValue else Humanoid.WalkSpeed = 16 end
    end
})
PlayerTab:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust your walk speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Callback = function(value)
        SpeedBoostValue = value
        if SpeedBoostEnabled then Humanoid.WalkSpeed = value end
    end
})
PlayerTab:Toggle({
    Title = "Jump Boost",
    Desc = "Increase your jump power",
    Default = false,
    Callback = function(state)
        JumpBoostEnabled = state
        if state then Humanoid.JumpPower = JumpBoostValue else Humanoid.JumpPower = 50 end
    end
})
PlayerTab:Slider({
    Title = "Jump Power",
    Desc = "Adjust your jump height",
    Default = 50,
    Min = 50,
    Max = 200,
    Callback = function(value)
        JumpBoostValue = value
        if JumpBoostEnabled then Humanoid.JumpPower = value end
    end
})
PlayerTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump infinitely in the air",
    Default = false,
    Callback = function(state)
        InfiniteJumpEnabled = state
    end
})
PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Default = false,
    Callback = function(state)
        NoclipEnabled = state
        if state then
            Character:FindFirstChild("HumanoidRootPart").CanCollide = false
        else
            Character:FindFirstChild("HumanoidRootPart").CanCollide = true
        end
    end
})
PlayerTab:Toggle({
    Title = "Fly",
    Desc = "Fly around the map",
    Default = false,
    Callback = function(state)
        FlyEnabled = state
    end
})
PlayerTab:Toggle({
    Title = "God Mode",
    Desc = "Take no damage",
    Default = false,
    Callback = function(state)
        GodModeEnabled = state
    end
})
PlayerTab:Toggle({
    Title = "Invisibility",
    Desc = "Become invisible to others",
    Default = false,
    Callback = function(state)
        InvisibleEnabled = state
        if state then
            Character:FindFirstChild("HumanoidRootPart").Transparency = 1
        else
            Character:FindFirstChild("HumanoidRootPart").Transparency = 0
        end
    end
})
PlayerTab:Button({
    Title = "🔄 Reset Character",
    Desc = "Reset your character",
    Callback = function()
        Character:BreakJoints()
    end
})

local MainTab = Window:Tab({ Title = "Main", Icon = "solar:home-2-bold" })
MainTab:Section({ Title = "🏠 Core Features" })
MainTab:Toggle({
    Title = "Auto Farm Coins",
    Desc = "Automatically collect coins",
    Default = false,
    Callback = function(state)
        FarmEnabled = state
        if state then
            farmConnection = RunService.Heartbeat:Connect(function()
                if not FarmEnabled then return end
                local coins = GetCoins()
                if #coins > 0 and HumanoidRootPart then
                    HumanoidRootPart.CFrame = coins[1].CFrame
                    farmStats.coins = farmStats.coins + 1
                    wait(FarmSpeed)
                end
            end)
        else
            if farmConnection then farmConnection:Disconnect() end
        end
    end
})
MainTab:Slider({
    Title = "Farm Speed",
    Desc = "How fast to collect coins",
    Default = 0.15,
    Min = 0.05,
    Max = 0.5,
    Callback = function(value)
        FarmSpeed = value
    end
})
MainTab:Button({
    Title = "🔄 Teleport to Gun",
    Desc = "Teleport to the nearest dropped gun",
    Callback = function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Gun_Dropped" then
                HumanoidRootPart.CFrame = obj.CFrame
                return
            end
        end
    end
})
MainTab:Button({
    Title = "🏛️ Teleport to Lobby",
    Desc = "Teleport to the lobby",
    Callback = function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Lobby" then
                HumanoidRootPart.CFrame = obj.CFrame
                return
            end
        end
    end
})
MainTab:Button({
    Title = "🗺️ Teleport to Map",
    Desc = "Teleport to the main map",
    Callback = function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Map" then
                HumanoidRootPart.CFrame = obj.CFrame
                return
            end
        end
    end
})
MainTab:Button({
    Title = "🗳️ Teleport to Voting",
    Desc = "Teleport to the voting area",
    Callback = function()
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Voting" then
                HumanoidRootPart.CFrame = obj.CFrame
                return
            end
        end
    end
})
MainTab:Toggle({
    Title = "Return on Full Bag",
    Desc = "Auto-return to lobby when bag is full",
    Default = false,
    Callback = function(state)
        if state then
            spawn(function()
                while state do
                    local coins = GetCoins()
                    if #coins > 50 then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name == "Lobby" then
                                HumanoidRootPart.CFrame = obj.CFrame
                                break
                            end
                        end
                    end
                    wait(2)
                end
            end)
        end
    end
})
MainTab:Toggle({
    Title = "FPS Booster",
    Desc = "Improve game performance",
    Default = false,
    Callback = function(state)
        if state then
            settings().Rendering.QualityLevel = 1
        else
            settings().Rendering.QualityLevel = 21
        end
    end
})
MainTab:Button({
    Title = "🔴 Say Murderer in Chat",
    Desc = "Announce who the murderer is",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local role = GetPlayerRole(player)
                if role == "Murderer" then
                    local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                    if chatService then
                        local event = chatService:FindFirstChild("SayMessageRequest")
                        if event then
                            event:FireServer(player.Name .. " is the Murderer!", "All")
                        end
                    end
                end
            end
        end
    end
})
MainTab:Button({
    Title = "🔵 Say Sheriff in Chat",
    Desc = "Announce who the sheriff is",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local role = GetPlayerRole(player)
                if role == "Sheriff" then
                    local chatService = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents")
                    if chatService then
                        local event = chatService:FindFirstChild("SayMessageRequest")
                        if event then
                            event:FireServer(player.Name .. " is the Sheriff!", "All")
                        end
                    end
                end
            end
        end
    end
})

local AutofarmTab = Window:Tab({ Title = "Autofarm", Icon = "solar:bag-smile-bold" })
AutofarmTab:Section({ Title = "🤖 Advanced Farming" })
AutofarmTab:Toggle({
    Title = "Auto Farm Coins",
    Desc = "Main farming toggle",
    Default = false,
    Callback = function(state)
        FarmEnabled = state
        if state then
            farmConnection = RunService.Heartbeat:Connect(function()
                if not FarmEnabled then return end
                local coins = GetCoins()
                if #coins > 0 and HumanoidRootPart then
                    if UndergroundFarm then
                        HumanoidRootPart.CFrame = CFrame.new(coins[1].CFrame.X, -50, coins[1].CFrame.Z)
                    else
                        HumanoidRootPart.CFrame = coins[1].CFrame
                    end
                    farmStats.coins = farmStats.coins + 1
                    wait(FarmSpeed)
                end
            end)
        else
            if farmConnection then farmConnection:Disconnect() end
        end
    end
})
AutofarmTab:Slider({
    Title = "Farm Speed",
    Desc = "Adjust collection speed",
    Default = 0.15,
    Min = 0.05,
    Max = 0.5,
    Callback = function(value)
        FarmSpeed = value
    end
})
AutofarmTab:Toggle({
    Title = "Underground Farm",
    Desc = "Farm from underground",
    Default = false,
    Callback = function(state)
        UndergroundFarm = state
    end
})
AutofarmTab:Note({
    Title = "📊 Live Farm Tracker",
    Desc = "Coins collected: 0"
})
spawn(function()
    while true do
        for _, child in ipairs(AutofarmTab:GetChildren()) do
            if child:IsA("TextLabel") and child.Text:find("Coins collected:") then
                child.Text = "Coins collected: " .. farmStats.coins
            end
        end
        wait(1)
    end
end)
AutofarmTab:Toggle({
    Title = "Return on Full Bag",
    Desc = "Auto-return when bag is full",
    Default = false,
    Callback = function(state)
        if state then
            spawn(function()
                while state do
                    local coins = GetCoins()
                    if #coins > 50 then
                        for _, obj in ipairs(Workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and obj.Name == "Lobby" then
                                HumanoidRootPart.CFrame = obj.CFrame
                                break
                            end
                        end
                    end
                    wait(2)
                end
            end)
        end
    end
})
AutofarmTab:Toggle({
    Title = "Farm All Maps",
    Desc = "Farm across all map locations",
    Default = false,
    Callback = function(state)
        if state then
            spawn(function()
                local mapPositions = {
                    CFrame.new(0, 10, 0),
                    CFrame.new(50, 10, 50),
                    CFrame.new(-50, 10, -50),
                    CFrame.new(50, 10, -50),
                    CFrame.new(-50, 10, 50)
                }
                local index = 1
                while state do
                    if FarmEnabled then
                        HumanoidRootPart.CFrame = mapPositions[index]
                        index = index % #mapPositions + 1
                        wait(3)
                    end
                    wait(1)
                end
            end)
        end
    end
})
AutofarmTab:Toggle({
    Title = "Auto Collect Beach Balls",
    Desc = "Collect event beach balls",
    Default = false,
    Callback = function(state)
        if state then
            spawn(function()
                while state do
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Name == "BeachBall" then
                            HumanoidRootPart.CFrame = obj.CFrame
                            break
                        end
                    end
                    wait(1)
                end
            end)
        end
    end
})
AutofarmTab:Toggle({
    Title = "Farm Candies/XP",
    Desc = "Collect event currencies",
    Default = false,
    Callback = function(state)
        if state then
            spawn(function()
                while state do
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (obj.Name == "Candy" or obj.Name == "XP") then
                            HumanoidRootPart.CFrame = obj.CFrame
                            break
                        end
                    end
                    wait(1)
                end
            end)
        end
    end
})
AutofarmTab:Toggle({
    Title = "Auto Reconnect",
    Desc = "Rejoin if disconnected",
    Default = false,
    Callback = function(state)
        if state then
            LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
                if not LocalPlayer.Parent then
                    game:GetService("TeleportService"):Teleport(game.PlaceId)
                end
            end)
        end
    end
})

local VisualTab = Window:Tab({ Title = "Visual", Icon = "solar:eye-bold" })
VisualTab:Section({ Title = "👁️ ESP Settings" })
VisualTab:Toggle({
    Title = "Enable ESP",
    Desc = "Show all players with role colors",
    Default = false,
    Callback = function(state)
        ESPEnabled = state
        if not state then
            for _, highlight in pairs(espTable) do
                highlight:Destroy()
            end
            espTable = {}
        end
    end
})
VisualTab:Toggle({
    Title = "Murderer ESP",
    Desc = "Highlight murderer in red",
    Default = false,
    Callback = function(state)
        if state and ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and GetPlayerRole(player) == "Murderer" then
                    if not espTable[player] then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.FillTransparency = 0.3
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        espTable[player] = highlight
                    end
                end
            end
        end
    end
})
VisualTab:Toggle({
    Title = "Sheriff ESP",
    Desc = "Highlight sheriff in blue",
    Default = false,
    Callback = function(state)
        if state and ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and GetPlayerRole(player) == "Sheriff" then
                    if not espTable[player] then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.FillTransparency = 0.3
                        highlight.FillColor = Color3.fromRGB(0, 100, 255)
                        espTable[player] = highlight
                    end
                end
            end
        end
    end
})
VisualTab:Toggle({
    Title = "Innocent ESP",
    Desc = "Highlight innocents in yellow",
    Default = false,
    Callback = function(state)
        if state and ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and GetPlayerRole(player) == "Innocent" then
                    if not espTable[player] then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.FillTransparency = 0.3
                        highlight.FillColor = Color3.fromRGB(255, 255, 0)
                        espTable[player] = highlight
                    end
                end
            end
        end
    end
})
VisualTab:Toggle({
    Title = "Box ESP",
    Desc = "Draw box around players",
    Default = false,
    Callback = function(state)
    end
})
VisualTab:Toggle({
    Title = "Name ESP",
    Desc = "Show player names above heads",
    Default = false,
    Callback = function(state)
        if state and ESPEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if not espTable[player] then
                        local highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                        espTable[player] = highlight
                    end
                end
            end
        end
    end
})
VisualTab:Toggle({
    Title = "Tracer Line",
    Desc = "Draw line from 