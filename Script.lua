-- Load Rayfield UI Library safely
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PathfindingService = game:GetService("PathfindingService")
local LocalPlayer = Players.LocalPlayer

-- Variables for toggles & features
local SpeedValue = 16
local SpeedEnabled = false
local Flying = false
local FlySpeed = 50
local SequenceRunning = false

-- Create Main Hub Window
local Window = Rayfield:CreateWindow({
   Name = "VOID HUB | Steal a Brainrot",
   LoadingTitle = "Loading Void Hub Systems...",
   LoadingSubtitle = "Mobile & PC Compatible",
   ConfigurationSaving = { Enabled = false }
})

-- Helper Function: Smooth Pathfinding Movement
local function walkToPosition(targetCFrame)
   local character = LocalPlayer.Character
   if not character then return end
   local humanoid = character:FindFirstChildOfClass("Humanoid")
   local rootPart = character:FindFirstChild("HumanoidRootPart")
   if not humanoid or not rootPart then return end

   local path = PathfindingService:CreatePath({
      AgentRadius = 2,
      AgentHeight = 5,
      AgentCanJump = true
   })
   
   path:ComputeAsync(rootPart.Position, targetCFrame.Position)
   
   if path.Status == Enum.PathStatus.Success then
      local waypoints = path:GetWaypoints()
      for _, waypoint in ipairs(waypoints) do
         if not SequenceRunning then break end
         if waypoint.Action == Enum.PathWaypointAction.Jump then
            humanoid.Jump = true
         end
         humanoid:MoveTo(waypoint.Position)
         humanoid.MoveToFinished:Wait()
      end
   else
      humanoid:MoveTo(targetCFrame.Position)
      humanoid.MoveToFinished:Wait()
   end
end

-- Helper Function: Execute the complete Sequence
local function executeStealSequence()
   local character = LocalPlayer.Character
   if not character or not character:FindFirstChild("HumanoidRootPart") then return end
   local rootPart = character.HumanoidRootPart
   local humanoid = character:FindFirstChildOfClass("Humanoid")

   -- 1. Find Primary Target (Chicken / Forest Egg)
   local eggTarget = nil
   for _, obj in pairs(workspace:GetDescendants()) do
      local name = obj.Name:lower()
      if name:find("chicken") or name:find("forest") or name:find("egg") or name:find("brainrot") then
         if obj:IsA("BasePart") then
            eggTarget = obj.CFrame
            break
         elseif obj:IsA("Model") and obj.PrimaryPart then
            eggTarget = obj.PrimaryPart.CFrame
            break
         end
      end
   end

   if not eggTarget then
      Rayfield:Notify({Title = "Auto Steal", Content = "No Chicken or Forest Egg found!", Duration = 3})
      return
   end

   Rayfield:Notify({Title = "Auto Steal", Content = "Walking to Target Egg...", Duration = 2})
   walkToPosition(eggTarget)

   -- 2. Step Backwards
   if humanoid and rootPart then
      task.wait(0.2)
      local backwardPos = rootPart.CFrame * CFrame.new(0, 0, 5) -- Walks 5 studs backward
      humanoid:MoveTo(backwardPos.Position)
      humanoid.MoveToFinished:Wait()
   end

   -- 3. Move to Secondary Target (Box / Demon Zone)
   local demonTarget = nil
   for _, obj in pairs(workspace:GetDescendants()) do
      local name = obj.Name:lower()
      if name:find("demon") or name:find("box") or name:find("zone") then
         if obj:IsA("BasePart") then
            demonTarget = obj.CFrame
            break
         elseif obj:IsA("Model") and obj.PrimaryPart then
            demonTarget = obj.PrimaryPart.CFrame
            break
         end
      end
   end

   if demonTarget then
      Rayfield:Notify({Title = "Auto Steal", Content = "Egg Secured! Walking to Demon Zone...", Duration = 2})
      walkToPosition(demonTarget)
   else
      Rayfield:Notify({Title = "Auto Steal", Content = "Egg collected! (Demon Zone target not found)", Duration = 3})
   end
end

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

-- Force Speed Loop (Prevents game from resetting speed)
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
         
         task.spawn(function()
            while Flying and Character:FindFirstChild("Humanoid") do
               local Camera = workspace.CurrentCamera
               BodyVelocity.Velocity = Camera.CFrame.LookVector * FlySpeed
               task.wait()
            end
            if BodyVelocity then BodyVelocity:Destroy() end
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

-- Trigger Sequence One Time
StealTab:CreateButton({
   Name = "Run Steal Sequence (Chicken -> Backwards -> Demon)",
   Callback = function()
      SequenceRunning = true
      task.spawn(function()
         executeStealSequence()
         SequenceRunning = false
      end)
   end,
})

-- Steal Rare Eggs (Instant Teleport)
StealTab:CreateButton({
   Name = "Instant Teleport to Rare Egg",
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

-- Bottom Steal (Teleport Underground)
StealTab:CreateButton({
   Name = "Bottom Steal (Teleport Safe)",
   Callback = function()
      local Character = LocalPlayer.Character
      if Character and Character:FindFirstChild("HumanoidRootPart") then
         Character.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, -15, 0)
      end
   end,
})

Rayfield:Notify({
   Title = "Void Hub Loaded",
   Content = "All features are ready!",
   Duration = 4,
})
