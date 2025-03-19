local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local roles

-- Infinite Jump
local InfiniteJumpEnabled = false -- Default off

UserInputService.JumpRequest:Connect(function()
	if InfiniteJumpEnabled then
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

-- Variable to track if teleportation is enabled
local teleportEnabled = false
-- Variable to track if ESP is enabled
local espEnabled = false
-- Variable to track if GodMode is enabled
local godModeEnabled = false

-- Function to find the CoinContainer
local function findCoinContainer()
    for _, child in pairs(workspace:GetChildren()) do
        local coinContainer = child:FindFirstChild("CoinContainer")
        if coinContainer then
            return coinContainer
        end
    end
    return nil
end

-- Function to find the nearest coin within a certain radius
local function findNearestCoin(radius)
    local coinContainer = findCoinContainer()
    if not coinContainer then
        print("CoinContainer not found")
        return nil
    end
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local nearestCoin = nil
    local nearestDistance = radius
    for _, coin in pairs(coinContainer:GetChildren()) do
        local distance = (coin.Position - humanoidRootPart.Position).Magnitude
        if distance < nearestDistance then
            nearestCoin = coin
            nearestDistance = distance
        end
    end
    return nearestCoin
end

-- Function to teleport to a coin
local function teleportToCoin(coin)
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out) -- Reduced duration to 0.1 seconds
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = coin.CFrame})
    tween:Play()
    return tween
end

-- Variable to track if a teleport is in progress
local isTeleporting = false

-- Function to teleport to a nearby coin or a random coin
local function teleportToNearbyOrRandomCoin()
    if not teleportEnabled or isTeleporting then return end
    local nearbyRadius = 50 -- Adjust this value to change the "nearby" distance
    local nearbyCoin = findNearestCoin(nearbyRadius)
    if nearbyCoin then
        print("Teleporting to nearby coin")
        isTeleporting = true
        local tween = teleportToCoin(nearbyCoin)
        tween.Completed:Connect(function()
            isTeleporting = false
            teleportToNearbyOrRandomCoin() -- Immediately move to the next coin
        end)
    else
        local coinContainer = findCoinContainer()
        if not coinContainer then
            print("CoinContainer not found")
            return
        end
        local coins = coinContainer:GetChildren()
        if #coins == 0 then
            print("No coins found")
            return
        end
        local randomCoin = coins[math.random(1, #coins)]
        print("Teleporting to random coin")
        isTeleporting = true
        local tween = teleportToCoin(randomCoin)
        tween.Completed:Connect(function()
            isTeleporting = false
            teleportToNearbyOrRandomCoin() -- Immediately move to the next coin
        end)
    end
end

-- Function to handle character respawn
local function onCharacterAdded(newCharacter)
    character = newCharacter
end

-- Connect to current and future characters
player.CharacterAdded:Connect(onCharacterAdded)

-- Start the continuous teleportation loop
RunService.Heartbeat:Connect(function()
    if teleportEnabled and character and character:FindFirstChild("HumanoidRootPart") then
        teleportToNearbyOrRandomCoin()
    end
end)

-- GodMode Function
local accessories = {}
function GodMode()
    if player.Character then
        if player.Character:FindFirstChild("Humanoid") then
            for _, accessory in pairs(player.Character.Humanoid:GetAccessories()) do
                table.insert(accessories, accessory:Clone())
            end
            player.Character.Humanoid.Name = "deku"
        end
        local v = player.Character["deku"]:Clone()
        v.Parent = player.Character
        v.Name = "Humanoid"
        wait(0.1)
        player.Character["deku"]:Destroy()
        workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
        for _, accessory in pairs(accessories) do
            player.Character.Humanoid:AddAccessory(accessory)
        end
        player.Character.Animate.Disabled = true
        wait(0.1)
        player.Character.Animate.Disabled = false
    end
end

local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nebula-Softworks/Luna-Interface-Suite/refs/heads/main/source.lua", true))()
local Window = Luna:CreateWindow({
	Name = "Ryxzen - MM2",
	Subtitle = nil,
	LogoID = "82795327169782",
	LoadingEnabled = true,
	LoadingTitle = "Loading...",
	LoadingSubtitle = "by Skibidi50-lol",

	ConfigSettings = {
		RootFolder = nil,
		ConfigFolder = "Big Hub"
	},

	KeySystem = false
})

local mainTab = Window:CreateTab({
	Name = "Main",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true
})

local Toggle = mainTab:CreateToggle({
	Name = "Coin Farm",
	CurrentValue = false,
    Callback = function(Value)
       teleportEnabled = Value
    end
}, "CoinToggle")

local Toggle = mainTab:CreateToggle({
	Name = "God Mode(Reset After Round)",
	CurrentValue = false,
    Callback = function(Value)
        godModeEnabled = value
        if godModeEnabled then
            GodMode()
        end
    end
}, "GodToggle")

local plrTab = Window:CreateTab({
	Name = "Player",
	Icon = "view_in_ar",
	ImageSource = "Material",
	ShowTitle = true
})

-- Infinite Jump Toggle
local Toggle = plrTab:CreateToggle({
	Name = "Infinite Jump",
	CurrentValue = false,
    Callback = function(Value)
       InfiniteJumpEnabled = Value
    end
}, "JumpToggle")

local Slider = plrTab:CreateSlider({
	Name = "WalkSpeed",
	Range = {16, 200}, 
	Increment = 1, 
	CurrentValue = 16, 
    Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
}, "SpeedSlider")

local Slider = plrTab:CreateSlider({
	Name = "JumpPower",
	Range = {50, 500}, 
	Increment = 1, 
	CurrentValue = 50, 
    Callback = function(Value)
       game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end
}, "JumpSlider")
