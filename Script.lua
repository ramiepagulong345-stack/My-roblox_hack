-- Load the Rayfield UI Library safely
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create the Main Hub Window
local Window = Rayfield:CreateWindow({
   Name = "Brainrot Steal Hub",
   LoadingTitle = "Loading Mechanics...",
   LoadingSubtitle = "by Studio Developer",
   ConfigurationSaving = {
      Enabled = false
   }
})

-- Main Tab
local MainTab = Window:CreateTab("Player Mods", 4483362458) -- Title, ImageId

-- Walkspeed Slider
local SpeedSlider = MainTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 100},
   Increment = 1,
   Suffix = "Speed",
   CurrentValue = 16,
   Flag = "SpeedSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
   end,
})

-- Jump Power Slider
local JumpSlider = MainTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 200},
   Increment = 5,
   Suffix = "Power",
   CurrentValue = 50,
   Flag = "JumpSlider",
   Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
   end,
})

-- Steal Toggle Action Button
local ActionButton = MainTab:CreateButton({
   Name = "Auto-Collect Nearby Brainrot Items",
   Callback = function()
      -- Example logic: Find nearby items and bring them to player
      local player = game.Players.LocalPlayer
      local char = player.Character or player.CharacterAdded:Wait()
      
      for _, item in pairs(workspace:GetChildren()) do
         if item:IsA("Tool") or item.Name == "BrainrotItem" then
            if item:FindFirstChild("Handle") then
               item.Handle.CFrame = char.HumanoidRootPart.CFrame
            end
         end
      end
   end,
})

Rayfield:Notify({
   Title = "Hub Loaded",
   Content = "Brainrot Steal controls are ready to use!",
   Duration = 5,
   Image = 4483362458,
})
