--Modules
local dhlock = loadstring(game:HttpGet("https://raw.githubusercontent.com/Stratxgy/DH-Lua-Lock/refs/heads/main/Main.lua"))()
--Set Up
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Splix"))()
local window = library:new({textsize = 13.5,font = Enum.Font.RobotoMono,name = "Ryxzen Hub",color = Color3.fromRGB(225,58,81)})
local aimtab = window:page({name = "Aim Features"})
local section1 = aimtab:section({name = "Aimbot Settings",side = "left",size = 250})
--Aimbot Settings
section1:toggle({name = "Aimbot",def = false,callback = function(value)
  tog = value
    getgenv().dhlock.enabled = tog
    getgenv().dhlock.fov = 500
end})
