-- Load Rayfield UI Library safely
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Variables for toggles & features
local SpeedValue = 16
local SpeedEnabled = false
local Flying = false
local FlySpeed = 50

-- Create Main Hub Window
local Window = Rayfield:CreateWindow({
   Name = "VOID HUB | Steal a Brainrot",
   LoadingTitle = "Loading Void Hub Systems...",
   LoadingSubtitle = "Mobile & PC Compatible",
   ConfigurationSaving = { Enabled = false }
})

-- ==========================================
-- TAB 1: PLAYER MODS (FORCED SPEED & FLY)
-- ==========================================
local PlayerTab = Window:CreateTab("Movement Mods", 4483362458)

-- Speed Toggle
PlayerTab:CreateToggle({
   Name = "Enable Fast Speed",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value)
      SpeedEnabled = Value
   end,
})

-- Speed Slider
PlayerTab:CreateSlider({
   Name = "Walk Speed",
   Range = {16, 250},
   Increment = 5,
   Suffix = "Speed",
   CurrentValue = 50,
   Flag = "SpeedSlider",
   Callback = function(Value)
      SpeedValue = Value
   end,
})

-- Force Speed Loop (Prevents game from resetting your speed)
RunService.RenderStepped:Connect(function()
   if SpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
      LocalPlayer.Character.Humanoid.WalkSpeed = SpeedValue
   end
end)

-- Fly Mode Toggle
PlayerTab:CreateToggle({
   Name = "Fly Mode (Steal in Air)",
   CurrentValue = false,
   Flag = "FlyToggle",
   Callback = function(Value)
      Flying = Value
      local Character = LocalPlayer.Character
      if not Character then return end
      local Root = Character:FindFirstChild("HumanoidRootPart")
      
      if Flying and Root then
         local BodyVelocity = Instance.new("BodyVelocity")
         BodyVelocity.Name = "VoidFlyVelocity"
         BodyVelocity.MaxForce = Vector3.new(4e5, 4e5, 4e5)
         BodyVelocity.Velocity = Vector3.zero
         BodyVelocity.Parent = Root
         
         -- Flying control loop
         task.spawn(function()
            while Flying and Character:FindFirstChild("Humanoid") do
               local Camera = workspace.CurrentCamera
               BodyVelocity.Velocity = Camera.CFrame.LookVector * FlySpeed
               task.wait()
            end
            BodyVelocity:Destroy()
         end)
      elseif Root:FindFirstChild("VoidFlyVelocity") then
         Root.VoidFlyVelocity:Destroy()
      end
   end,
})

-- ==========================================
-- TAB 2: STEAL & EGG AUTOMATION
-- ==========================================
local StealTab = Window:CreateTab("Steal & Eggs", 4483362458)

-- Steal Rare Eggs
StealTab:CreateButton({
   Name = "Steal Rare Eggs",
   Callback = function()
      local Character = LocalPlayer.Character
      if not Character or not Character:FindFirstChild("HumanoidRootPart") then return end
      
      local found = false
      for _, obj in pairs(workspace:GetDescendants()) do
         if obj.Name:lower():find("rare") or obj.Name:lower():find("egg") or obj.Name:lower():find("brainrot") then
            if obj:IsA("BasePart") then
               Character.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
               found = true
               break
            elseif obj:IsA("Model") and obj.PrimaryPart then
               Character.HumanoidRootPart.CFrame = obj.PrimaryPart.CFrame + Vector3.new(0, 3, 0)
               found = true
               break
            end
         end
      end
      
      if not found then
         Rayfield:Notify({Title = "Void Hub", Content = "No Rare Eggs or Items found nearby!", Duration = 3})
      end
   end,
})

-- Bottom Steal (Teleport to Bottom / Underground Baseplate)
StealTab:CreateButton({
   Name = "Bottom Steal (Teleport Safe)",
   Callback = function()
      local Character = LocalPlayer.Character
      if Character and Character:FindFirstChild("HumanoidRootPart") then
         -- Teleports 15 studs below current position to steal safely from below
         Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, -15, 0)
      end
   end,
})

Rayfield:Notify({
   Title = "Void Hub Loaded",
   Content = "All features are ready!",
   Duration = 4,
})
