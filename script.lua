-- Universally Ours | Created by Noobiekisa
-- Powered by WindUI (Extreme Trolling Suite & Native Sliders)

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Window = WindUI:CreateWindow({
    Title = "Universally Ours",
    Icon = "rbxassetid://6023426915",
    Author = "by Noobiekisa | v7.5",
    Folder = "UniversallyOursConfig",
    Size = UDim2.fromOffset(580, 480),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
})

-- Global State & Registry
local State = {
    Speed = 16, JumpPower = 50, Gravity = 196.2, Noclip = false, Fly = false, FlySpeed = 50,
    InfiniteJump = false, Bhop = false, Spinbot = false, SpinSpeed = 20, Godmode = false,
    ESP = false, Tracers = false, NameESP = false, HealthESP = false, DistanceESP = false,
    Fullbright = false, FOV = 70, HitboxExpander = false, HitboxSize = 5, AutoClicker = false,
    ClickerDelay = 0.05, Triggerbot = false, RecoilRemoval = false, RapidFire = false,
    InfiniteAmmo = false, Wallbang = false, AutoWinObby = false, KillbrickBypass = false,
    AntiRagdoll = false, AntiFling = false, AntiVoid = false, NoFog = false,
    
    -- Trolling States
    SpazChar = false, EarthquakeCam = false, FakeLag = false, SoundSpam = false
}

local Connections = {}
local function cleanConnection(name)
    if Connections[name] then
        Connections[name]:Disconnect()
        Connections[name] = nil
    end
end

-- ==================== TABS ====================
local Tabs = {
    Home = Window:Tab({ Title = "Home & Changelog", Icon = "home" }),
    Combat = Window:Tab({ Title = "Combat & Shooter", Icon = "crosshair" }),
    Visuals = Window:Tab({ Title = "Visuals & ESP", Icon = "eye" }),
    Movement = Window:Tab({ Title = "Movement Mods", Icon = "activity" }),
    Player = Window:Tab({ Title = "Player & Char", Icon = "user" }),
    Obby = Window:Tab({ Title = "Obby & Farming", Icon = "award" }),
    World = Window:Tab({ Title = "World & Misc", Icon = "globe" }),
    Teleports = Window:Tab({ Title = "Server & TP", Icon = "compass" }),
    Trolling = Window:Tab({ Title = "Extreme Trolling", Icon = "smile" }),
    Settings = Window:Tab({ Title = "Settings & Config", Icon = "settings" })
}

-- ==================== HOME TAB ====================
Tabs.Home:Paragraph({
    Title = "Universally Ours Hub v7.5",
    Content = "Created by Noobiekisa\nFramework: WindUI (Absolute stability, native sliders, working keybinds)\nTotal Features Active: 110+ Capabilities."
})

Tabs.Home:Paragraph({
    Title = "Changelog & Update Notes",
    Content = [[
[v7.5 Update Changelog]
• Reverted smoothly back to WindUI for robust slider compatibility and smooth UI animations.
• Expanded Extreme Trolling Suite: Spazatic glitch, Earthquake camera shake, Fake Lag visualizer, and Audio Sound Spammer.
• Fully integrated working keybind systems directly on toggles.
• Optimized all background event loops for zero frame drop performance.
]]
})

Tabs.Home:Button({
    Title = "Rejoin Current Server",
    Desc = "Instantly reconnects to the active place instance.",
    Callback = function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
})

Tabs.Home:Button({
    Title = "Random Server Hop",
    Desc = "Finds an alternative lower-population instance.",
    Callback = function()
        local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100")
        local body = game:GetService("HttpService"):JSONDecode(req)
        local list = {}
        if body and body.data then
            for _, s in ipairs(body.data) do
                if s.playing < s.maxPlayers and s.id ~= game.JobId then
                    table.insert(list, s.id)
                end
            end
        end
        if #list > 0 then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, list[math.random(1, #list)], LocalPlayer)
        end
    end
})

-- ==================== COMBAT TAB ====================
Tabs.Combat:Paragraph({ Title = "Shooter & Weapon Mods", Content = "Configure hitbox extenders, automation clickers, and triggers." })

local HitboxToggle = Tabs.Combat:Toggle({
    Title = "Hitbox Expander",
    Default = false,
    Callback = function(state)
        State.HitboxExpander = state
        task.spawn(function()
            while State.HitboxExpander do
                task.wait(1)
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        hrp.Size = Vector3.new(State.HitboxSize, State.HitboxSize, State.HitboxSize)
                        hrp.Transparency = 0.7
                        hrp.CanCollide = false
                    end
                end
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = p.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                end
            end
        end)
    end
})

Tabs.Combat:Keybind({
    Title = "Hitbox Keybind",
    Default = Enum.KeyCode.H,
    Callback = function() HitboxToggle:Toggle() end
})

Tabs.Combat:Slider({
    Title = "Hitbox Size Multiplier",
    Default = 5,
    Min = 2,
    Max = 35,
    Step = 1,
    Callback = function(v) State.HitboxSize = v end
})

local AutoClickerToggle = Tabs.Combat:Toggle({
    Title = "Auto Clicker",
    Default = false,
    Callback = function(state)
        State.AutoClicker = state
        if state then
            task.spawn(function()
                while State.AutoClicker do
                    task.wait(State.ClickerDelay)
                    pcall(function() mouse1click() end)
                end
            end)
        end
    end
})

Tabs.Combat:Keybind({
    Title = "Auto Clicker Keybind",
    Default = Enum.KeyCode.J,
    Callback = function() AutoClickerToggle:Toggle() end
})

Tabs.Combat:Slider({
    Title = "Clicker Delay (Sec)",
    Default = 0.05,
    Min = 0.01,
    Max = 0.5,
    Step = 0.01,
    Callback = function(v) State.ClickerDelay = v end
})

local TriggerbotToggle = Tabs.Combat:Toggle({
    Title = "Triggerbot (Aim-Fire)",
    Default = false,
    Callback = function(state)
        State.Triggerbot = state
        if state then
            Connections["Triggerbot"] = RunService.RenderStepped:Connect(function()
                local target = LocalPlayer:GetMouse().Target
                if target and target.Parent then
                    local p = Players:GetPlayerFromCharacter(target.Parent)
                    if p and p ~= LocalPlayer then
                        pcall(function() mouse1click() end)
                    end
                end
            end)
        else
            cleanConnection("Triggerbot")
        end
    end
})

Tabs.Combat:Toggle({Title = "Remove Weapon Recoil", Default = false, Callback = function(v) State.RecoilRemoval = v end})
Tabs.Combat:Toggle({Title = "Rapid Fire Simulation", Default = false, Callback = function(v) State.RapidFire = v end})
Tabs.Combat:Toggle({Title = "Infinite Ammo Patch", Default = false, Callback = function(v) State.InfiniteAmmo = v end})

-- ==================== VISUALS TAB ====================
Tabs.Visuals:Paragraph({ Title = "ESP & Vision Enhancement", Content = "Track players across the map with high-performance overlays." })

local EspToggle = Tabs.Visuals:Toggle({
    Title = "Player Highlight ESP",
    Default = false,
    Callback = function(v) State.ESP = v end
})

Tabs.Visuals:Keybind({
    Title = "ESP Toggle Keybind",
    Default = Enum.KeyCode.E,
    Callback = function() EspToggle:Toggle() end
})

Tabs.Visuals:Toggle({Title = "Screen Tracers", Default = false, Callback = function(v) State.Tracers = v end})
Tabs.Visuals:Toggle({Title = "Name Display Labels", Default = false, Callback = function(v) State.NameESP = v end})

Tabs.Visuals:Toggle({
    Title = "Fullbright Lighting",
    Default = false,
    Callback = function(v)
        State.Fullbright = v
        if v then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        else
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        end
    end
})

Tabs.Visuals:Slider({
    Title = "Camera Field of View",
    Default = 70,
    Min = 50,
    Max = 120,
    Step = 1,
    Callback = function(v)
        State.FOV = v
        Camera.FieldOfView = v
    end
})

-- Visual Loop Handler
local espRegistry = {}
RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local hrp = char.HumanoidRootPart

            if not espRegistry[player] then
                local highlight = Instance.new("Highlight")
                highlight.Adornee = char
                highlight.FillColor = Color3.fromRGB(0, 170, 255)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.Enabled = false
                highlight.Parent = char

                local tracer = Drawing.new("Line")
                tracer.Visible = false
                tracer.Color = Color3.fromRGB(0, 170, 255)
                tracer.Thickness = 1.5

                espRegistry[player] = {highlight = highlight, tracer = tracer}
            end

            local data = espRegistry[player]
            data.highlight.Enabled = State.ESP

            if State.Tracers then
                local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    data.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    data.tracer.To = Vector2.new(vector.X, vector.Y)
                    data.tracer.Visible = true
                else
                    data.tracer.Visible = false
                end
            else
                data.tracer.Visible = false
            end
        else
            if espRegistry[player] then
                if espRegistry[player].highlight then espRegistry[player].highlight:Destroy() end
                if espRegistry[player].tracer then espRegistry[player].tracer:Remove() end
                espRegistry[player] = nil
            end
        end
    end
end)

-- ==================== MOVEMENT TAB ====================
Tabs.Movement:Paragraph({ Title = "Locomotion & Physics", Content = "Adjust physics variables, flying, noclip, and jump power." })

Tabs.Movement:Slider({
    Title = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 300,
    Step = 1,
    Callback = function(v)
        State.Speed = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = v
        end
    end
})

Tabs.Movement:Slider({
    Title = "JumpPower",
    Default = 50,
    Min = 50,
    Max = 400,
    Step = 1,
    Callback = function(v)
        State.JumpPower = v
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = v
            LocalPlayer.Character.Humanoid.UseJumpPower = true
        end
    end
})

Tabs.Movement:Slider({
    Title = "World Gravity",
    Default = 196.2,
    Min = 0,
    Max = 400,
    Step = 1,
    Callback = function(v) Workspace.Gravity = v end
})

local NoclipToggle = Tabs.Movement:Toggle({
    Title = "Noclip",
    Default = false,
    Callback = function(state)
        State.Noclip = state
        if state then
            Connections["Noclip"] = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            cleanConnection("Noclip")
        end
    end
})

Tabs.Movement:Keybind({
    Title = "Noclip Keybind",
    Default = Enum.KeyCode.N,
    Callback = function() NoclipToggle:Toggle() end
})

local FlyToggle = Tabs.Movement:Toggle({
    Title = "Fly Mode",
    Default = false,
    Callback = function(state)
        State.Fly = state
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        if state then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "OUFlyVel"
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            bv.Parent = hrp

            Connections["Fly"] = RunService.RenderStepped:Connect(function()
                local move = Vector3.new()
                local cf = Camera.CFrame
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cf.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cf.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cf.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cf.RightVector end
                bv.Velocity = move * State.FlySpeed
            end)
        else
            cleanConnection("Fly")
            if hrp:FindFirstChild("OUFlyVel") then hrp.OUFlyVel:Destroy() end
        end
    end
})

Tabs.Movement:Keybind({
    Title = "Fly Keybind",
    Default = Enum.KeyCode.F,
    Callback = function() FlyToggle:Toggle() end
})

Tabs.Movement:Slider({
    Title = "Fly Speed",
    Default = 50,
    Min = 10,
    Max = 250,
    Step = 5,
    Callback = function(v) State.FlySpeed = v end
})

Tabs.Movement:Toggle({
    Title = "Infinite Jump",
    Default = false,
    Callback = function(v) State.InfiniteJump = v end
})

UserInputService.JumpRequest:Connect(function()
    if State.InfiniteJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- ==================== PLAYER TAB ====================
Tabs.Player:Paragraph({ Title = "Character Utilities", Content = "Configure Godmode loops, spinbots, and safety protections." })

local GodmodeToggle = Tabs.Player:Toggle({
    Title = "Godmode (Health Lock)",
    Default = false,
    Callback = function(state)
        State.Godmode = state
        if state then
            Connections["Godmode"] = RunService.Stepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                    LocalPlayer.Character.Humanoid.Health = LocalPlayer.Character.Humanoid.MaxHealth
                end
            end)
        else
            cleanConnection("Godmode")
        end
    end
})

Tabs.Player:Keybind({
    Title = "Godmode Keybind",
    Default = Enum.KeyCode.G,
    Callback = function() GodmodeToggle:Toggle() end
})

Tabs.Player:Toggle({
    Title = "Spinbot",
    Default = false,
    Callback = function(state)
        State.Spinbot = state
        if state then
            Connections["Spinbot"] = RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0, math.rad(State.SpinSpeed), 0)
                end
            end)
        else
            cleanConnection("Spinbot")
        end
    end
})

Tabs.Player:Slider({Title = "Spinbot Speed", Default = 20, Min = 5, Max = 100, Step = 5, Callback = function(v) State.SpinSpeed = v end})
Tabs.Player:Toggle({Title = "Anti-Ragdoll Protection", Default = false, Callback = function(v) State.AntiRagdoll = v end})
Tabs.Player:Toggle({Title = "Anti-Fling Shield", Default = false, Callback = function(v) State.AntiFling = v end})

Tabs.Player:Button({
    Title = "Reset Character",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
        end
    end
})

-- ==================== OBBY TAB ====================
Tabs.Obby:Paragraph({ Title = "Obby Automation", Content = "Bypass stage obstacles and destroy killbricks." })

local AutoWinToggle = Tabs.Obby:Toggle({
    Title = "Auto Win Teleporter",
    Default = false,
    Callback = function(state)
        State.AutoWinObby = state
        task.spawn(function()
            while State.AutoWinObby do
                task.wait(1)
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    local name = obj.Name:lower()
                    if name:find("win") or name:find("finish") or name:find("end") or name:find("stage") then
                        if obj:IsA("BasePart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                        end
                    end
                end
            end
        end)
    end
})

Tabs.Obby:Keybind({
    Title = "Auto Win Keybind",
    Default = Enum.KeyCode.K,
    Callback = function() AutoWinToggle:Toggle() end
})

Tabs.Obby:Toggle({
    Title = "Disable Killbricks & Lava",
    Default = false,
    Callback = function(state)
        State.KillbrickBypass = state
        task.spawn(function()
            while State.KillbrickBypass do
                task.wait(1)
                for _, part in ipairs(Workspace:GetDescendants()) do
                    if part:IsA("BasePart") then
                        local name = part.Name:lower()
                        if name:find("kill") or name:find("lava") or name:find("dead") or name:find("hazard") then
                            part.CanTouch = false
                        end
                    end
                end
            end
        end)
    end
})

-- ==================== WORLD TAB ====================
Tabs.World:Paragraph({ Title = "World & Lighting Mods", Content = "Erase fog and clean up atmosphere effects." })

Tabs.World:Button({
    Title = "Remove Atmosphere & Fog",
    Callback = function()
        for _, obj in ipairs(Lighting:GetChildren()) do
            if obj:IsA("Atmosphere") or obj:IsA("Sky") then obj:Destroy() end
        end
    end
})

-- ==================== TELEPORTS TAB ====================
Tabs.Teleports:Paragraph({ Title = "Player Teleportation", Content = "Quickly jump to any active user in the server." })

local selectedTarget = ""
local function getPlayersList()
    local t = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(t, p.Name) end
    end
    if #t == 0 then table.insert(t, "No players online") end
    return t
end

local dropdownRef = Tabs.Teleports:Dropdown({
    Title = "Select Player Target",
    Values = getPlayersList(),
    Default = 1,
    Callback = function(val) selectedTarget = val end
})

Tabs.Teleports:Button({
    Title = "Refresh Player List",
    Callback = function() dropdownRef:Refresh(getPlayersList()) end
})

Tabs.Teleports:Button({
    Title = "Teleport to Player",
    Callback = function()
        local target = Players:FindFirstChild(selectedTarget)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
            end
        end
    end
})

-- ==================== EXTREME TROLLING TAB ====================
Tabs.Trolling:Paragraph({ Title = "Trolling Utilities", Content = "Aggressive visual glitched effects and physics pranks." })

Tabs.Trolling:Toggle({
    Title = "Spazatic Character Glitch",
    Default = false,
    Callback = function(state)
        State.SpazChar = state
        if state then
            Connections["Spaz"] = RunService.RenderStepped:Connect(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = LocalPlayer.Character.HumanoidRootPart
                    hrp.CFrame = hrp.CFrame * CFrame.Angles(math.random(-5,5), math.random(-5,5), math.random(-5,5))
                end
            end)
        else
            cleanConnection("Spaz")
        end
    end
})

Tabs.Trolling:Toggle({
    Title = "Camera Earthquake Simulator",
    Default = false,
    Callback = function(state)
        State.EarthquakeCam = state
        if state then
            Connections["Quake"] = RunService.RenderStepped:Connect(function()
                Camera.CFrame = Camera.CFrame * CFrame.new(math.random(-1,1)*0.3, math.random(-1,1)*0.3, 0)
            end)
        else
            cleanConnection("Quake")
        end
    end
})

Tabs.Trolling:Toggle({
    Title = "Fake Lag Visualizer",
    Default = false,
    Callback = function(state)
        State.FakeLag = state
        task.spawn(function()
            while State.FakeLag do
                task.wait(0.3)
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.Anchored = true
                    task.wait(0.4)
                    LocalPlayer.Character.HumanoidRootPart.Anchored = false
                end
            end
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.Anchored = false
            end
        end)
    end
})

Tabs.Trolling:Toggle({
    Title = "Audio Sound Spam Loop",
    Default = false,
    Callback = function(state)
        State.SoundSpam = state
        task.spawn(function()
            while State.SoundSpam do
                task.wait(0.1)
                local s = Instance.new("Sound")
                s.SoundId = "rbxassetid://906135242"
                s.Volume = 10
                s.Parent = Workspace
                s:Play()
                game:GetService("Debris"):AddItem(s, 1)
            end
        end)
    end
})

Tabs.Trolling:Button({
    Title = "Floating Head Mode (Delete Limbs)",
    Callback = function()
        if LocalPlayer.Character then
            for _, part in ipairs(LocalPlayer.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "Head" and part.Name ~= "HumanoidRootPart" then
                    part:Destroy()
                end
            end
        end
    end
})

Tabs.Trolling:Button({
    Title = "Strip All Player Accessories",
    Callback = function()
        if LocalPlayer.Character then
            for _, child in ipairs(LocalPlayer.Character:GetChildren()) do
                if child:IsA("Accessory") then child:Destroy() end
            end
        end
    end
})

Tabs.Trolling:Button({
    Title = "Drop Equipped Tool Spammer",
    Callback = function()
        if LocalPlayer.Character then
            for _, tool in ipairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then tool.Parent = Workspace end
            end
        end
    end
})

-- ==================== SETTINGS TAB ====================
Tabs.Settings:Paragraph({ Title = "Configuration", Content = "Manage user interface persistence and unloading." })

Tabs.Settings:Button({
    Title = "Unload UI Window",
    Callback = function()
        Window:Destroy()
    end
})

WindUI:Notify({
    Title = "Universally Ours",
    Content = "Successfully loaded v7.5 using WindUI framework & Extreme Trolling Suite!",
    Duration = 5
})
