-- Fetch Local Player Information
local LocalPlayer = game:GetService("Players").LocalPlayer
local Username = LocalPlayer.Name
local DisplayName = LocalPlayer.DisplayName
local UserId = LocalPlayer.UserId

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Hub Window
local Window = Rayfield:CreateWindow({
   Name = "Custom Hub | Steal An Egg",
   LoadingTitle = "Loading Menu...",
   LoadingSubtitle = "Welcome, " .. DisplayName,
   ConfigurationSaving = {
      Enabled = false
   },
   KeySystem = false
})

-- Send Welcome Notification
Rayfield:Notify({
   Title = "Hub Loaded",
   Content = "Logged in as " .. Username,
   Duration = 5,
   Image = 4483362458
})

---------------------------------------------------------
-- TAB 1: PLAYER PROFILE & STATS
---------------------------------------------------------
local InfoTab = Window:CreateTab("Player Info", 4483362458)
local InfoSection = InfoTab:CreateSection("Account Info")

InfoSection:CreateParagraph({
   Title = "User Profile",
   Content = "Username: " .. Username .. "\nDisplay Name: " .. DisplayName .. "\nUser ID: " .. UserId
})

InfoSection:CreateButton({
   Name = "Copy User ID",
   Callback = function()
      setclipboard(tostring(UserId))
      Rayfield:Notify({
         Title = "Copied!",
         Content = "User ID copied to clipboard.",
         Duration = 3,
         Image = 4483362458
      })
   end,
})

---------------------------------------------------------
-- TAB 2: MOVEMENT MODS
---------------------------------------------------------
local PlayerTab = Window:CreateTab("Movement", 4483362458)
local MovementSection = PlayerTab:CreateSection("Speed & Jump")

MovementSection:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

MovementSection:CreateSlider({
   Name = "JumpPower",
   Range = {50, 250},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
         LocalPlayer.Character.Humanoid.UseJumpPower = true
         LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

---------------------------------------------------------
-- TAB 3: PET DISPLAY DEMO
---------------------------------------------------------
local PetTab = Window:CreateTab("Pet Preview", 4483362458)
local PetSection = PetTab:CreateSection("Rarity Reference")

PetSection:CreateParagraph({
   Title = "Common Egg",
   Content = "Chance: 60%\nCommon Pets: Cat, Dog"
})

PetSection:CreateParagraph({
   Title = "Rare Egg",
   Content = "Chance: 35%\nRare Pets: Golden Cat, Dragon"
})

---------------------------------------------------------
-- TAB 4: SETTINGS
---------------------------------------------------------
local SettingsTab = Window:CreateTab("Settings", 4483362458)
local SettingsSection = SettingsTab:CreateSection("Menu Control")

SettingsSection:CreateButton({
   Name = "Unload UI",
   Callback = function()
      Rayfield:Destroy()
   end,
})
