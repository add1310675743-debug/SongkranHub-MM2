-- [[ SONGKRAN HUB V2 - FIXED EDITION ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SONGKRAN HUB | Thaiban City 💦",
   LoadingTitle = "ปรับปรุงระบบใหม่...",
   LoadingSubtitle = "by Songkran",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false -- ปิดไว้ก่อนเพื่อให้คุณทดสอบได้ไวขึ้น
})

-- --- หน้าตำรวจ (Police Mode) ---
local PoliceTab = Window:CreateTab("Police Mode 👮", 4483362458)

PoliceTab:CreateToggle({
   Name = "Auto Arrest & Follow (ติดตามและจับอัตโนมัติ)",
   CurrentValue = false,
   Flag = "AutoArrest",
   Callback = function(Value)
       _G.AutoArrest = Value
       task.spawn(function()
           while _G.AutoArrest do
               local localPlayer = game.Players.LocalPlayer
               local nearestThief = nil
               local shortestDistance = math.huge

               -- แสกนหาโจร
               for _, v in pairs(game.Players:GetPlayers()) do
                   if v ~= localPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                       -- เช็คทีม (ปรับชื่อทีมตามจริงในแมพ)
                       if v.TeamColor == BrickColor.new("Bright red") or (v.Team and (v.Team.Name == "Thief" or v.Team.Name == "Criminal")) then
                           local dist = (localPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                           if dist < shortestDistance then
                               shortestDistance = dist
                               nearestThief = v
                           end
                       end
                   end
               end

               -- ถ้าเจอโจรให้วาร์ปตามตลอด
               if nearestThief and nearestThief.Character then
                   local root = localPlayer.Character.HumanoidRootPart
                   local targetRoot = nearestThief.Character.HumanoidRootPart
                   -- วาร์ปไปข้างหลังโจรนิดนึง
                   root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 1)
                   
                   -- คำสั่งจับ (กดใช้เครื่องมือจับอัตโนมัติ)
                   local handcuff = localPlayer.Character:FindFirstChild("Handcuffs") or localPlayer.Backpack:FindFirstChild("Handcuffs")
                   if handcuff then
                       localPlayer.Character.Humanoid:EquipTool(handcuff)
                       handcuff:Activate()
                   end
               end
               task.wait(0.1) -- เช็คทุก 0.1 วินาที เพื่อให้ติดหนึบเหมือนกาว
           end
       end)
   end,
})

-- --- หน้าโจร (Criminal Mode) ---
local CriminalTab = Window:CreateTab("Criminal Mode 🔪", 4483362458)

CriminalTab:CreateToggle({
   Name = "God Mode / Ghost Style (ตำรวจจับไม่ติด)",
   CurrentValue = false,
   Flag = "AntiArrest",
   Callback = function(Value)
       _G.AntiArrest = Value
       task.spawn(function()
           while _G.AntiArrest do
               local char = game.Players.LocalPlayer.Character
               if char then
                   -- วิธีทำให้จับไม่ติด: ย้ายตำแหน่งตัวละครหลอกๆ หรือทำให้ส่วนที่ใช้จับอยู่ห่างจากตัว
                   for _, v in pairs(game.Players:GetPlayers()) do
                       if v.TeamColor == BrickColor.new("Bright blue") or (v.Team and v.Team.Name == "Police") then
                           local pChar = v.Character
                           if pChar and pChar:FindFirstChild("HumanoidRootPart") then
                               local dist = (char.HumanoidRootPart.Position - pChar.HumanoidRootPart.Position).magnitude
                               if dist < 15 then
                                   -- ถ้าตำรวจใกล้ ให้บินขึ้นเบาๆ หรือสไลด์หนีแบบสมูท
                                   char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                                   task.wait(0.2)
                                   char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame * CFrame.new(0, -20, 0)
                               end
                           end
                       end
                   end
               end
               task.wait(0.3)
           end
       end)
   end,
})

-- --- หน้าฟาร์ม (Job Farm) ---
local FarmTab = Window:CreateTab("Job Farm 🎣", 4483362458)

FarmTab:CreateToggle({
   Name = "Auto Fishing (ตกปลาและกดเกจให้อัตโนมัติ)",
   CurrentValue = false,
   Flag = "AutoFish",
   Callback = function(Value)
       _G.AutoFish = Value
       task.spawn(function()
           while _G.AutoFish do
               -- ระบบจำลองการคลิกเมาส์ (Virtual Input)
               local vim = game:GetService("VirtualInputManager")
               vim:SendMouseButtonEvent(0, 0, 0, true, game, 0)
               task.wait(0.1)
               vim:SendMouseButtonEvent(0, 0, 0, false, game, 0)
               
               -- สุ่มรอปลากินเบ็ด และคลิกย้ำๆ เพื่อดึงปลา (แก้ปัญหาเกจวัด)
               task.wait(0.5)
           end
       end)
   end,
})
