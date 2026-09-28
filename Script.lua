-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the Main Window
local Window = Rayfield:CreateWindow({
   Name = "My Custom Script Hub",
   LoadingTitle = "Loading Script...",
   LoadingSubtitle = "by You",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- Create a Tab for Player Features
local PlayerTab = Window:CreateTab("Player Settings", 4483362458) -- Title, Image

-- 1. WalkSpeed Slider
PlayerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

-- 2. JumpPower Slider
PlayerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 300},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
         game.Players.LocalPlayer.Character.Humanoid.UseJumpPower = true
         game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end
   end,
})

-- Create a Tab for Utility Features
local UtilTab = Window:CreateTab("Utilities", 4483362458)

-- 3. Fullbright Toggle (Night Vision)
UtilTab:CreateToggle({
   Name = "Fullbright (Remove Shadows)",
   CurrentValue = false,
   Flag = "FullbrightToggle",
   Callback = function(Value)
      if Value then
         game:GetService("Lighting").Ambient = Color3.fromRGB(255, 255, 255)
         game:GetService("Lighting").Brightness = 2
      else
         game:GetService("Lighting").Ambient = Color3.fromRGB(127, 127, 127)
         game:GetService("Lighting").Brightness = 1
      end
   end,
})

-- 4. Notification Test Button
UtilTab:CreateButton({
   Name = "Test Notification",
   Callback = function()
      Rayfield:Notify({
         Title = "Script Alert",
         Content = "Your custom script button works!",
         Duration = 4,
         Image = 4483362458,
      })
   end,
})
