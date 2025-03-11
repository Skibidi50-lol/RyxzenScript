function Init()
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
end

function Test()
    print(Fluent.Options)
end

Init()
Test()

local Window = Fluent:CreateWindow({
    Title = "Ryxzen - Rivals 1.0",
    SubTitle = "by ? bro",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Amethyst",
    MinimizeKey = Enum.KeyCode.RightShift -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "crosshair" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

local Section = Tabs.Main:AddSection("-Gun Settings(Level 8 executor needed)")

Tabs.Main:AddButton({
    Title = "All Gun Mod",
    Description = "Makes your gun super op(level 8 executor needed)",
    Callback = function()
       local function toggleTableAttribute(attribute, value)
    for _, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" and rawget(gcVal, attribute) then
            gcVal[attribute] = value
        end
    end
end

toggleTableAttribute("ShootCooldown", 0)
toggleTableAttribute("ShootSpread", 0)
toggleTableAttribute("ShootRecoil", 0)
    end
})

Tabs.Main:AddButton({
    Title = "No Recoil",
    Description = "Stop the Recoil(For Spray Weapon Like Burst Rifle)",
    Callback = function()
       local function toggleTableAttribute(attribute, value)
    for _, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" and rawget(gcVal, attribute) then
            gcVal[attribute] = value
        end
    end
end

toggleTableAttribute("ShootRecoil", 0)
    end
})

Tabs.Main:AddButton({
    Title = "Rapid Fire",
    Description = "No Shoot Cooldown",
    Callback = function()
       local function toggleTableAttribute(attribute, value)
    for _, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" and rawget(gcVal, attribute) then
            gcVal[attribute] = value
        end
    end
end

toggleTableAttribute("ShootCooldown", 0)
    end
})

Tabs.Main:AddButton({
    Title = "No Spread",
    Description = "idk",
    Callback = function()
       local function toggleTableAttribute(attribute, value)
    for _, gcVal in pairs(getgc(true)) do
        if type(gcVal) == "table" and rawget(gcVal, attribute) then
            gcVal[attribute] = value
        end
    end
end

toggleTableAttribute("ShootSpread", 0)
    end
})
