local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Songkran Hub | Universal Aimbot",
   LoadingTitle = "Adapting to Map...",
   LoadingSubtitle = "by Gemini",
   ConfigurationSaving = { Enabled = false }
})

local Settings = {
    Enabled = false,
    TeamCheck = false,
    MaxDistance = 300, -- ตั้งค่าเริ่มต้นให้ล็อคเฉพาะตัวใกล้ๆ
    LockPart = "Head" -- สามารถเปลี่ยนเป็น HumanoidRootPart ได้ถ้าอยากล็อคตัว
}

local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ฟังก์ชันหาตัวที่ใกล้ตัวเราที่สุดแบบ Real-time
local function getAbsoluteNearestPlayer()
    local target = nil
    local nearestDistance = Settings.MaxDistance -- จำกัดระยะการล็อค

    -- ตรวจสอบว่าตัวละครเรามีตัวตนอยู่จริงในแมพนั้นๆ
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end

    local myPos = LocalPlayer.Character.HumanoidRootPart.Position

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(Settings.LockPart) then
            
            -- Team Check
            if Settings.TeamCheck and player.Team == LocalPlayer.Team then continue end
            
            -- ตรวจสอบว่าศัตรูยังมีชีวิต (เช็ค Humanoid หรือ Health)
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health <= 0 then continue end

            -- คำนวณระยะทางจริง (Magnitude)
            local enemyPos = player.Character[Settings.LockPart].Position
            local dist = (myPos - enemyPos).Magnitude

            -- เงื่อนไข: ต้องใกล้กว่าคนก่อนหน้าที่หาเจอ และต้องอยู่ในระยะ MaxDistance
            if dist < nearestDistance then
                nearestDistance = dist
                target = player
            end
        end
    end
    return target
end

-- ลูปการล็อค (ใช้ RenderStepped เพื่อความลื่นไหลทุกแมพ)
RunService.RenderStepped:Connect(function()
    if Settings.Enabled then
        local targetPlayer = getAbsoluteNearestPlayer()
        
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(Settings.LockPart) then
            local goalPos = targetPlayer.Character[Settings.LockPart].Position
            -- สั่งให้กล้องมองไปที่ตำแหน่งเป้าหมายทันที
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, goalPos)
        end
    end
end)

-- --- UI Control ---
local Tab = Window:CreateTab("Aimbot Settings", 4483362458)

Tab:CreateToggle({
   Name = "Enable Aimbot (ล็อคตัวที่ใกล้ที่สุด)",
   CurrentValue = false,
   Callback = function(Value)
      Settings.Enabled = Value
   end,
})

Tab:CreateSlider({
   Name = "Lock Range (จำกัดระยะ)",
   Range = {50, 2000},
   Increment = 10,
   Suffix = "Studs",
   CurrentValue = 300,
   Callback = function(Value)
      Settings.MaxDistance = Value
   end,
})

Tab:CreateDropdown({
   Name = "Lock Part (จุดที่ล็อค)",
   Options = {"Head", "HumanoidRootPart"},
   CurrentOption = {"Head"},
   MultipleOptions = false,
   Callback = function(Option)
      Settings.LockPart = Option[1]
   end,
})

Tab:CreateToggle({
   Name = "Team Check",
   CurrentValue = false,
   Callback = function(Value)
      Settings.TeamCheck = Value
   end,
})
