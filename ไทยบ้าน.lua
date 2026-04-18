-- [[ SONGKRAN HUB V1.1 - THAIBAN CITY EDITION ]]
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "SONGKRAN HUB | Thaiban City 💦",
   LoadingTitle = "Loading Thaiban System...",
   LoadingSubtitle = "by Songkran",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "SongkranHub",
      FileName = "ThaibanConfig"
   },
   KeySystem = true, -- ระบบคีย์เพื่อความโปร
   KeySettings = {
      Title = "SONGKRAN HUB KEY",
      Subtitle = "Key: SONGKRAN123",
      Note = "Join Discord for more!",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"SONGKRAN123"}
   }
})

-- --- หน้าตำรวจ (Police Tab) ---
local PoliceTab = Window:CreateTab("Police Mode 👮", 4483362458)
PoliceTab:CreateButton({
   Name = "Auto Arrest (จับโจรใกล้ที่สุด)",
   Callback = function()
       -- ระบบหาโจรที่ใกล้ที่สุดแล้ววาร์ปไปจับ
       local localPlayer = game.Players.LocalPlayer
       local shortestDistance = math.huge
       local nearestThief = nil

       for _, v in pairs(game.Players:GetPlayers()) do
           if v ~= localPlayer and v.Team and (v.Team.Name == "Thief" or v.Team.Name == "Criminal") then
               local dist = (localPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
               if dist < shortestDistance then
                   shortestDistance = dist
                   nearestThief = v
               end
           end
       end

       if nearestThief then
           localPlayer.Character.HumanoidRootPart.CFrame = nearestThief.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1)
           Rayfield:Notify({Title = "System", Content = "จับโจร: " .. nearestThief.Name, Duration = 3})
       end
   end,
})

-- --- หน้าโจร (Criminal Tab) ---
local CriminalTab = Window:CreateTab("Criminal Mode 🔪", 4483362458)
CriminalTab:CreateToggle({
   Name = "God Mode / Anti-Arrest (ตำรวจจับไม่ได้)",
   CurrentValue = false,
   Flag = "AntiArrest",
   Callback = function(Value)
       _G.AntiArrest = Value
       while _G.AntiArrest do
           -- ระบบทำให้ Character ไม่โดน Hitbox หรือวาร์ปหนีนิดๆ เมื่อตำรวจเข้าใกล้
           for _, v in pairs(game.Players:GetPlayers()) do
               if v.Team and v.Team.Name == "Police" and v.Character then
                   local dist = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
                   if dist < 15 then -- ถ้าตำรวจเข้าใกล้ในระยะ 15 เมตร
                       game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0) -- วาร์ปขึ้นข้างบนนิดนึง (ไม่ร่วงโลก)
                   end
               end
           end
           task.wait(0.5)
       end
   end,
})

-- --- หน้าฟาร์ม (Farm Tab) ---
local FarmTab = Window:CreateTab("Job Farm 🎣", 4483362458)
FarmTab:CreateToggle({
   Name = "Auto Fishing (ตกปลาอัตโนมัติ)",
   CurrentValue = false,
   Flag = "AutoFish",
   Callback = function(Value)
       _G.AutoFish = Value
       while _G.AutoFish do
           -- จำลองการกดปุ่มตกปลา (ต้องปรับชื่อ RemoteEvent ตามแมพ)
           local args = { [1] = "Fish" }
           game:GetService("ReplicatedStorage").Events.FishingEvent:FireServer(unpack(args))
           task.wait(2) -- รอเวลาปลากินเบ็ด
       end
   end,
})

-- --- หน้าตั้งค่า (Settings) ---
local SettingsTab = Window:CreateTab("Settings ⚙️", 4483362458)
SettingsTab:CreateButton({
   Name = "Destroy Script (ปิดสคริปต์)",
   Callback = function()
       Rayfield:Destroy()
   end,
})
