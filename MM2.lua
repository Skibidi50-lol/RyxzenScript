local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Turtle-Brand/Turtle-Lib/main/source.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/linemaster2/esp-library/main/library.lua"))();
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local roles

-- Variable to track if teleportation is enabled
local teleportEnabled = false
-- Variable to track if GodMode is enabled
local godModeEnabled = false


-- Variable to track if a teleport is in progress
local isTeleporting = false

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
    if not coinContainer then return nil end
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local nearestCoin, nearestDistance = nil, radius

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
    local tweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = coin.CFrame})
    tween:Play()
    return tween
end

-- Function to teleport to a nearby or random coin
local function teleportToNearbyOrRandomCoin()
    if not teleportEnabled or isTeleporting then return end
    local nearbyRadius = 50
    local nearbyCoin = findNearestCoin(nearbyRadius)

    if nearbyCoin then
        isTeleporting = true
        local tween = teleportToCoin(nearbyCoin)
        tween.Completed:Connect(function()
            isTeleporting = false
            teleportToNearbyOrRandomCoin()
        end)
    else
        local coinContainer = findCoinContainer()
        if not coinContainer then return end
        local coins = coinContainer:GetChildren()
        if #coins == 0 then return end
        local randomCoin = coins[math.random(1, #coins)]
        
        isTeleporting = true
        local tween = teleportToCoin(randomCoin)
        tween.Completed:Connect(function()
            isTeleporting = false
            teleportToNearbyOrRandomCoin()
        end)
    end
end

-- Function to handle character respawn
local function onCharacterAdded(newCharacter)
    character = newCharacter
end

-- Connect to current and future characters
player.CharacterAdded:Connect(onCharacterAdded)

-- Start teleportation loop
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

game:GetService("StarterGui"):SetCore("SendNotification",{
	Title = "WARNING", -- Required
	Text = "PRESS P TO TOGGLE UI", -- Required
	Icon = "rbxassetid://1234567890" -- Optional
})


local window = library:Window("Ryxzen - MM2 | MAIN")

window:Toggle("Auto Farm Coin", false, function(bool)
    teleportEnabled = bool
end)

window:Toggle("God Mode (Reset After Round)", false, function(bool)
    godModeEnabled = bool
    if godModeEnabled then
        GodMode()
    end
end)

local window2 = library:Window("Ryxzen - MM2 | VISUAL")

window2:Toggle("Enabled ESP", false, function(bool)
    ESP.Enabled = bool
end)

window2:Toggle("BOX", false, function(bool)
    ESP.ShowBox = bool
	ESP.BoxType = "Corner Box Esp";
end)

window2:Toggle("NAME", false, function(bool)
    ESP.ShowName = bool
end)

window2:Toggle("TRACER", false, function(bool)
    ESP.ShowTracer = bool
end)


window:Button("Rejoin", function()
    TeleportService:Teleport(game.PlaceId, player)
end)

library:Keybind("P")
