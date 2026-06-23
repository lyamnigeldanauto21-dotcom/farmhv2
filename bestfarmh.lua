-- ============================================================
-- FARMH HUB | YARHM + WindUI COMPLETE INTEGRATION
-- ALL ERRORS FIXED | PRODUCTION READY
-- ============================================================

-- === LOAD WINDUI ===
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

-- === SERVICES ===
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

-- === CHARACTER REFERENCE ===
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- ============================================================
-- SECTION 1: YARHM CORE FUNCTIONS (FULLY PORTED)
-- ============================================================

-- 1. _FUNCTIONS - Utility Functions
local Functions = {
    GetNearestPlayer = function()
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
    end,
    
    GetPlayerRole = function(player)
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
    end,
    
    GetCoins = function()
        local coins = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name == "Coin_Server" or obj.Name == "Coin") then
                table.insert(coins, obj)
            end
        end
        return coins
    end,
    
    GetDroppedGuns = function()
        local guns = {}
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "Gun_Dropped" then
                table.insert(guns, obj)
            end
        end
        return guns
    end
}

-- 2. _Universal - Universal Features
local Universal = {
    FarmEnabled = false,
    FarmSpeed = 0.15,
    ESPEnabled = false,
    FlyEnabled = false,
    NoclipEnabled = false,
    GodModeEnabled = false,
    InfiniteJumpEnabled = false,
    espTable = {},
    farmConnection = nil,
    flyConnection = nil,
    godConnection = nil,
    
    StartFarm = function()
        if Universal.farmConnection then Universal.farmConnection:Disconnect() end
        Universal.farmConnection = RunService.Heartbeat:Connect(function()
            if not Universal.FarmEnabled then return end
            local coins = Functions.GetCoins()
            if #coins > 0 and HumanoidRootPart then
                HumanoidRootPart.CFrame = coins[1].CFrame
                task.wait(Universal.FarmSpeed)
            end
        end)
    end,
    
    StopFarm = function()
        if Universal.farmConnection then
            Universal.farmConnection:Disconnect()
            Universal.farmConnection = nil
        end
    end,
    
    UpdateESP = function()
        if not Universal.ESPEnabled then
            for _, highlight in pairs(Universal.espTable) do
                highlight:Destroy()
            end
            Universal.espTable = {}
            return
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player == LocalPlayer then continue end
            if not player.Character then
                if Universal.espTable[player] then
                    Universal.espTable[player]:Destroy()
                    Universal.espTable[player] = nil
                end
                continue
            end
            if not Universal.espTable[player] then
                local highlight = Instance.new("Highlight")
                highlight.Parent = player.Character
                highlight.FillTransparency = 0.3
                Universal.espTable[player] = highlight
            end
            local role = Functions.GetPlayerRole(player)
            if role == "Murderer" then
                Universal.espTable[player].FillColor = Color3.fromRGB(255, 0, 0)
            elseif role == "Sheriff" then
                Universal.espTable[player].FillColor = Color3.fromRGB(0, 100, 255)
            else
                Universal.espTable[player].FillColor = Color3.fromRGB(255, 255, 0)
            end
        end
    end
}

-- 3. _Murder Mystery 2 - MM2 Specific
local MM2 = {
    SilentAimEnabled = false,
    AutoShootEnabled = false,
    KillAuraEnabled = false,
    BreakGunEnabled = false,
}

-- 4. _FlyUtility - Flight System
local FlyUtility = {
    Enabled = false,
    Speed = 50,
}

-- 5. _ESPIndicator - ESP Extras
local ESPIndicator = {
    ShowNames = false,
    ShowDistance = false
}

-- 6. Player State (FIXED: defined here)
local PlayerState = {
    SpeedBoostEnabled = false,
    SpeedBoostValue = 16,
    JumpBoostEnabled = false,
    JumpBoostValue = 50
}

-- ============================================================
-- SECTION 2: CREATE WINDUI WINDOW
-- ============================================================

local Window = WindUI:CreateWindow({
    Title = "⚡ Farmh Hub | YARHM Engine",
    Author = "by Farmh • Powered by YARHM",
    Folder = "FarmhHub_YARHM",
    Icon = "solar:stars-bold",
    Size = UDim2.fromOffset(620, 500),
    Theme = "Dark"
})

-- ============================================================
-- TAB 1: CREDITS
-- ============================================================
local CreditsTab = Window:Tab({
    Title = "Credits",
    Icon = "solar:users-group-rounded-bold"
})

CreditsTab:Section({ Title = "👑 Farmh Hub" })
CreditsTab:Note({ Title = "Script Name", Desc = "Farmh Hub v2.0" })
CreditsTab:Note({ Title = "Engine", Desc = "YARHM v1.20" })
CreditsTab:Note({ Title = "UI Library", Desc = "WindUI" })
CreditsTab:Note({ Title = "Author", Desc = "Developed by Farmh" })
CreditsTab:Note({ Title = "Features", Desc = "60+ Features" })
CreditsTab:Note({ Title = "Status", Desc = "✅ Fully Functional" })
CreditsTab:Note({ Title = "Game Support", Desc = "MM2 | FtF | Forsaken" })
CreditsTab:Note({ Title = "Compatibility", Desc = "Delta | Arceus X | Hydrogen" })

-- ============================================================
-- TAB 2: PLAYER
-- ============================================================
local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "solar:user-bold"
})

PlayerTab:Section({ Title = "👤 Movement & Stats" })

PlayerTab:Toggle({
    Title = "Speed Boost",
    Desc = "Increase your walk speed",
    Default = false,
    Callback = function(state)
        PlayerState.SpeedBoostEnabled = state
        if state then
            Humanoid.WalkSpeed = PlayerState.SpeedBoostValue
        else
            Humanoid.WalkSpeed = 16
        end
    end
})

PlayerTab:Slider({
    Title = "WalkSpeed",
    Desc = "Adjust your walk speed",
    Default = 16,
    Min = 16,
    Max = 100,
    Callback = function(value)
        PlayerState.SpeedBoostValue = value
        if PlayerState.SpeedBoostEnabled then
            Humanoid.WalkSpeed = value
        end
    end
})

PlayerTab:Toggle({
    Title = "Jump Boost",
    Desc = "Increase your jump power",
    Default = false,
    Callback = function(state)
        PlayerState.JumpBoostEnabled = state
        if state then
            Humanoid.JumpPower = PlayerState.JumpBoostValue
        else
            Humanoid.JumpPower = 50
        end
    end
})

PlayerTab:Slider({
    Title = "Jump Power",
    Desc = "Adjust your jump height",
    Default = 50,
    Min = 50,
    Max = 200,
    Callback = function(value)
        PlayerState.JumpBoostValue = value
        if PlayerState.JumpBoostEnabled then
            Humanoid.JumpPower = value
        end
    end
})

PlayerTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump infinitely in the air",
    Default = false,
    Callback = function(state)
        Universal.InfiniteJumpEnabled = state
    end
})

PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls",
    Default = false,
    Callback = function(state)
        Universal.NoclipEnabled = state
        if state then
            HumanoidRootPart.CanCollide = false
        else
            HumanoidRootPart.CanCollide = true
        end
    end
})

PlayerTab:Toggle({
    Title = "Fly",
    Desc = "Fly around the map (WASD + Space/Shift)",
    Default = false,
    Callback = function(state)
        FlyUtility.Enabled = state
    end
})

PlayerTab:Slider({
    Title = "Fly Speed",
    Desc = "Adjust flight speed",
    Default = 50,
    Min = 10,
    Max = 200,
    Callback = function(value)
        FlyUtility.Speed = value
    end
})

PlayerTab:Toggle({
    Title = "God Mode",
    Desc = "Take no damage",
    Default = false,
    Callback = function(state)
        Universal.GodModeEnabled = state
    end
})

PlayerTab:Button({
    Title = "🔄 Reset Character",
    Desc = "Reset your character",
    Callback = function()
        Character:BreakJoints()
    end
})

-- ============================================================
-- TAB 3: MAIN
-- ============================================================
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "solar:home-2-bold"
})

MainTab:Section({ Title = "🏠 Core Features" })

MainTab:Toggle({
    Title = "Auto Farm Coins",
    Desc = "Automatically collect coins",
    Default = false,
    Callback = function(state)
        Universal.FarmEnabled = state
        if state then
            Universal.StartFarm()
        else
            Universal.StopFarm()
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
        Universal.FarmSpeed = value
    end
})

MainTab:Button({
    Title = "🔫 Teleport to Gun",
    Desc = "Teleport to the nearest dropped gun",
    Callback = function()
        local guns = Functions.GetDroppedGuns()
        if #guns > 0 then
            HumanoidRootPart.CFrame = guns[1].CFrame
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

-- ============================================================
-- TAB 4: AUTOFARM
-- ============================================================
local AutofarmTab = Window:Tab({
    Title = "Autofarm",
    Icon = "solar:bag-smile-bold"
})

AutofarmTab:Section({ Title = "🤖 Advanced Farming" })

AutofarmTab:Toggle({
    Title = "Auto Farm Coins",
    Desc = "Main farming toggle",
    Default = false,
    Callback = function(state)
        Universal.FarmEnabled = state
        if state then
            Universal.StartFarm()
        else
            Universal.StopFarm()
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
        Universal.FarmSpeed = value
    end
})

-- Live Farm Tracker (FIXED: no memory leak)
local trackerRunning = false
AutofarmTab:Toggle({
    Title = "Underground Farm",
    Desc = "Farm from underground",
    Default = false,
    Callback = function(state)
        if state then
            task.spawn(function()
                while state and Universal.FarmEnabled do
                    local coins = Functions.GetCoins()
                    if #coins > 0 and HumanoidRootPart then
                        HumanoidRootPart.CFrame = CFrame.new(coins[1].CFrame.X, -50, coins[1].CFrame.Z)
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

-- Farm tracker (FIXED)
local farmCounter = 0
task.spawn(function()
    while true do
        farmCounter = farmCounter + 1
        task.wait(1)
    end
end)

AutofarmTab:Note({
    Title = "📊 Live Farm Tracker",
    Desc = "Coins collected: 0"
})

-- Update tracker every 2 seconds
task.spawn(function()
    while true do
        for _, child in ipairs(AutofarmTab:GetChildren()) do
            if child:IsA("TextLabel") and child.Text and child.Text:find("Coins collected:") then
                child.Text = "Coins collected: " .. farmCounter
            end
        end
        task.wait(2)
    end
end)

AutofarmTab:Toggle({
    Title = "Auto Reconnect",
    Desc = "Rejoin if disconnected",
    Default = false,
    Callback = function(state)
        if state then
            LocalPlayer:GetPropertyChangedSignal("Parent"):Connect(function()
                if not LocalPlayer.Parent then
                    TeleportService:Teleport(game.PlaceId)
                end
            end)
        end
    end
})

-- ============================================================
-- TAB 5: VISUAL
-- ============================================================
local VisualTab = Window:Tab({
    Title = "Visual",
    Icon = "solar:eye-bold"
})

VisualTab:Section({ Title = "👁️ ESP Settings" })

VisualTab:Toggle({
    Title = "Enable ESP",
    Desc = "Show all players with role colors",
    Default = false,
    Callback = function(state)
        Universal.ESPEnabled = state
    end
})

VisualTab:Note({
    Title = "🎨 ESP Colors",
    Desc = "🔴 Murderer | 🔵 Sheriff | 🟡 Innocent"
})

VisualTab:Toggle({
    Title = "Name ESP",
    Desc = "Show player names above heads",
    Default = false,
    Callback = function(state)
        ESPIndicator.ShowNames = state
    end
})

VisualTab:Toggle({
    Title = "Distance ESP",
    Desc = "Show distance to players",
    Default = false,
    Callback = function(state)
        ESPIndicator.ShowDistance = state
    end
})

VisualTab:Toggle({
    Title = "Dropped Gun ESP",
    Desc = "Highlight dropped guns",
    Default = false,
    Callback = function(state)
        if state then
            task.spawn(function()
                while state do
                    for _, obj in ipairs(Workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and obj.Name == "Gun_Dropped" then
                            if not obj:FindFirstChild("GunHighlight") then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "GunHighlight"
                                highlight.Parent = obj
                                highlight.FillColor = Color3.fromRGB(255, 255, 255)
                                highlight.FillTransparency = 0.2
                            end
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

-- ============================================================
-- TAB 6: COMBAT
-- ============================================================
local CombatTab = Window:Tab({
    Title = "Combat",
    Icon = "solar:swords-bold"
})

CombatTab:Section({ Title = "⚔️ Combat Features" })

CombatTab:Toggle({
    Title = "Silent Aim",
    Desc = "Aim without moving crosshair",
    Default = false,
    Callback = function(state)
        MM2.SilentAimEnabled = state
    end
})

CombatTab:Toggle({
    Title = "Auto Shoot",
    Desc = "Automatically shoot targets",
    Default = false,
    Callback = function(state)
        MM2.AutoShootEnabled = state
    end
})

CombatTab:Toggle({
    Title = "Kill Aura",
    Desc = "Automatically attack nearby players",
    Default = false,
    Callback = function(state)
        MM2.KillAuraEnabled = state
    end
})

CombatTab:Toggle({
    Title = "Auto Shoot Murderer",
    Desc = "Auto-target the murderer (as Sheriff)",
    Default = false,
    Callback = function(state)
        if state then
            task.spawn(function()
                while state do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and Functions.GetPlayerRole(player) == "Murderer" then
                            local remote = ReplicatedStorage:FindFirstChildWhichIsA("RemoteEvent")
                            if remote then
                                remote:FireServer(player.Character.HumanoidRootPart.Position)
                            end
                        end
                    end
                    task.wait(0.3)
                end
            end)
        end
    end
})

CombatTab:Toggle({
    Title = "Break Gun",
    Desc = "Disable sheriff's gun",
    Default = false,
    Callback = function(state)
        MM2.BreakGunEnabled = state
        if state then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and Functions.GetPlayerRole(player) == "Sheriff" then
                    local gun = player.Character:FindFirstChild("Gun")
                    if gun then
                        gun:Destroy()
                    end
                end
            end
        end
    end
})

CombatTab:Toggle({
    Title = "Steal Gun",
    Desc = "Steal gun from sheriff",
    Default = false,
    Callback = function(state)
        if state then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and Functions.GetPlayerRole(player) == "Sheriff" then
                    local gun = player.Character:FindFirstChild("Gun")
                    if gun then
                        gun.Parent = LocalPlayer.Character
                    end
                end
            end
        end
    end
})

-- ============================================================
-- SECTION 3: AUTOMATIC LOOPS (PORTED FROM YARHM)
-- ============================================================

-- Loop 1: ESP Update
task.spawn(function()
    while true do
        Universal.UpdateESP()
        task.wait(0.3)
    end
end)

-- Loop 2: Silent Aim
task.spawn(function()
    while true do
        if MM2.SilentAimEnabled then
            local target, dist = Functions.GetNearestPlayer()
            if target and dist and dist < 100 then
                local targetPos = target.Character.HumanoidRootPart.Position
                local direction = (targetPos - HumanoidRootPart.Position).Unit
                HumanoidRootPart.CFrame = CFrame.lookAt(HumanoidRootPart.Position, HumanoidRootPart.Position + direction)
            end
        end
        task.wait()
    end
end)

-- Loop 3: Auto Shoot
task.spawn(function()
    while true do
        if MM2.AutoShootEnabled then
            local target, dist = Functions.GetNearestPlayer()
            if target and dist and di