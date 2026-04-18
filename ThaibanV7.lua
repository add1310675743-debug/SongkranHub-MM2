-- [[ SONGKRAN HUB V7.4 - ONLY AUTO ARREST GOD MODE ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SONGKRAN HUB | จับโจรขั้นเทพ 👮",
   LoadingTitle = "กำลังเปิดระบบล็อคเป้าหมาย...",
   LoadingSubtitle = "by Songkran",
   ConfigurationSaving = { Enabled = false }
})

local MainTab = Window:CreateTab("Main 🚔", 4483362458)

MainTab:CreateToggle({
   Name = "เปิดระบบ: วาร์ปปุ๊บ จับปั๊บ (Auto Arrest)",
   CurrentValue = false,
   Flag = "GodArrest",
   Callback = function(Value)
       _G.GodArrest = Value
       task.spawn(function()
           while _G.GodArrest do
               local lp = game.Players.LocalPlayer
               local char = lp.Character
               local target = nil
               local dist = math.huge

               -- 1. ค้นหาโจรที่ใกล้ที่สุด (เน้นทีมสีแดง หรือชื่อทีมที่มีคำว่าโจร)
               for _, v in pairs(game.Players:GetPlayers()) do
                   if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                       if v.TeamColor == BrickColor.new("Bright red") or (v.Team and v.Team.Name:find("Thief")) or (v.Team and v.Team.Name:find("โจร")) then
                           local d = (char.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                           if d < dist then
                               dist = d
                               target = v
                           end
                       end
                   end
               end

               -- 2. เข้าปฏิบัติการจับกุมแบบสายฟ้าแลบ
               if target and target.Character then
                   local tRoot = target.Character.HumanoidRootPart
                   local tHum = target.Character:FindFirstChild("Humanoid")
                   
                   -- เช็คว่าโจรยังไม่ตายและยังไม่โดนจับอยู่ก่อนหน้า
                   if tHum and tHum.Health > 0 then
                       -- วาร์ปไปซ้อนหลังโจรแบบ 100%
                       char.HumanoidRootPart.CFrame = tRoot.CFrame * CFrame.new(0, 0, 0.1)
                       
                       -- **แก้ไขใหม่: ค้นหากุญแจมือแบบเจาะจงชื่อ**
                       -- ปกติแมพไทยบ้านจะใช้ชื่อ "Handcuffs" หรือ "กุญแจมือ"
                       local handcuffs = lp.Backpack:FindFirstChild("Handcuffs") or char:FindFirstChild("Handcuffs") or 
                                          lp.Backpack:FindFirstChild("กุญแจมือ") or char:FindFirstChild("กุญแจมือ")
                       
                       if handcuffs then
                           -- ถือกุญแจมือ (และจะไม่สลับเป็นปืน)
                           char.Humanoid:EquipTool(handcuffs)
                           
                           -- ใช้ระบบจำลองการแตะตัว (Touch) เพื่อให้เซิร์ฟเวอร์คิดว่าเราจับโจรแล้ว
                           task.spawn(function()
                               for _, part in pairs(target.Character:GetChildren()) do
                                   if part:IsA("BasePart") then
                                       firetouchinterest(handcuffs.Handle, part, 0) -- เอาด้ามกุญแจมือแตะตัวโจร
                                       firetouchinterest(handcuffs.Handle, part, 1)
                                       
                                       -- แถมคลิกย้ำๆ ที่ตัวโจร
                                       fireclickdetector(part:FindFirstChildOfClass("ClickDetector"))
                                   end
                               end
                           end)
                           
                           -- กดใช้งานกุญแจมือ
                           handcuffs:Activate()
                       end
                   end
               end
               task.wait(0.01) -- ความไวระดับสูงสุด
           end
       end)
   end,
})

-- ปุ่มกากบาทปิดสคริปต์ (ตามที่คุณต้องการ)
MainTab:CreateButton({
   Name = "ปิดสคริปต์และทำลายเมนู (X)",
   Callback = function()
       _G.GodArrest = false
       Rayfield:Destroy()
   end,
})

               
