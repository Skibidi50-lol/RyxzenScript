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
-- Variable to track if ESP is enabled
local espEnabled = false
-- Variable to track if GodMode is enabled
local godModeEnabled = false

-- Function to apply highlight to a character
local function applyHighlight(player)
    if player.Character then
        -- Remove existing highlight
        if player.Character:FindFirstChild("Highlight") then
            player.Character.Highlight:Destroy()
        end

        local highlight = Instance.new("Highlight")
        highlight.Name = "Highlight"
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(255, 255, 255) -- White highlight
        highlight.OutlineColor = Color3.fromRGB(0, 0, 0)    -- Black outline
    end
end

-- Function to highlight all players
local function highlightAllPlayers()
    for _, p in pairs(Players:GetPlayers()) do
        applyHighlight(p)
    end
end

-- Apply highlights on startup
highlightAllPlayers()

-- Apply highlight to new players when they join
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        applyHighlight(player)
    end)
end)

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

local window = library:Window("Ryxzen - MM2 | MAIN WINDOW")

window:Toggle("Auto Farm Coin", false, function(bool)
    teleportEnabled = bool
end)

window:Toggle("God Mode (Reset After Round)", false, function(bool)
    godModeEnabled = bool
    if godModeEnabled then
        GodMode()
    end
end)

window:Toggle("Enabled ESP", false, function(bool)
    ESP.Enabled = bool
end)

window:Toggle("BOX", false, function(bool)
    ESP.ShowBox = bool
	ESP.BoxType = "Corner Box Esp";
end)

window:Button("Rejoin", function()
    TeleportService:Teleport(game.PlaceId, player)
end)
