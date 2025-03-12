--// Modules
local dhlock = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/DH-Lua-Lock/refs/heads/main/Main.lua"))()
local esp = loadstring(game:HttpGet('https://raw.githubusercontent.com/0f76/seere_v3/main/ESP/v3_esp.lua'))()

--// Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/lxte/lates-lib/main/Main.lua"))()
local Window = Library:CreateWindow({
    Title = "Ryxzen Rivals",
    Theme = "Dark",
    
    Size = UDim2.fromOffset(570, 370),
    Transparency = 0.2,
    Blurring = true,
    MinimizeKeybind = Enum.KeyCode.LeftAlt,
})

local Themes = {
    Dark = {
        Primary = Color3.fromRGB(30, 30, 30),
        Secondary = Color3.fromRGB(35, 35, 35),
        Component = Color3.fromRGB(40, 40, 40),
        Interactables = Color3.fromRGB(45, 45, 45),
        Tab = Color3.fromRGB(200, 200, 200),
        Title = Color3.fromRGB(240,240,240),
        Description = Color3.fromRGB(200,200,200),
        Shadow = Color3.fromRGB(0, 0, 0),
        Outline = Color3.fromRGB(40, 40, 40),
        Icon = Color3.fromRGB(220, 220, 220),
    },
}

Window:SetTheme(Themes.Dark)
local Main = Window:AddTab({
    Title = "Aim Features",
    Section = "Aim Settings",
    Icon = "rbxassetid://11963373994"
})

Window:AddSection({ Name = "Aimbot", Tab = Main })
Window:AddToggle({
    Title = "Aimbot",
    Description = "Lock onto player head (press MB2)",
    Tab = Main,
    Callback = function(Boolean) 
        getgenv().dhlock.enabled = Boolean
        getgenv().dhlock.fov = 500
    end,
})

local silentAimActive = false
Window:AddToggle({
    Title = "Silent Aim",
    Description = "I know it only aim at the torso the reason is try to not get detected",
    Tab = Main,
    Callback = function(Boolean)
        silentAimActive = Boolean
    end,
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

-- Function to get the nearest target's torso
local function getNearestTorso()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    
    if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
        return closestPlayer.Character.HumanoidRootPart
    end
    return nil
end

-- Silent Aim Functionality
UserInputService.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.KeyCode == Enum.KeyCode.ButtonR2) and silentAimActive then
        local targetTorso = getNearestTorso()
        if targetTorso then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetTorso.Position)
            ReplicatedStorage.Remotes.Attack:FireServer(targetTorso)
        end
    end
end)

-- ESP TAB
local espTab = Window:AddTab({
    Title = "Visuals",
    Section = "Visuals Settings",
    Icon = "rbxassetid://11963373994"
})

Window:AddSection({ Name = "Visual Settings", Tab = espTab })

local highlightEnabled = false

local function applyHighlight(player)
    if player ~= LocalPlayer and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(0, 255, 0)
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function updateHighlights()
    for _, player in pairs(Players:GetPlayers()) do
        if highlightEnabled then
            applyHighlight(player)
        else
            if player.Character and player.Character:FindFirstChild("Highlight") then
                player.Character.Highlight:Destroy()
            end
        end
    end
end

Window:AddToggle({
    Title = "Chams",
    Description = "You Need to spam toggle it because some new player will not highlighted",
    Tab = espTab,
    Callback = function(Boolean)
        highlightEnabled = Boolean
        updateHighlights()
    end,
})

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if highlightEnabled then
            applyHighlight(player)
        end
    end)
end)

updateHighlights()

print("Silent Aim, ESP, and Player Highlights Script for Rivals loaded successfully.")
