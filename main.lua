-- [[ SONGKRAN HUB V6 - MURDER MYSTERY 2 SPECIAL ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystem"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local CorrectKey = "SONGKRAN123"

local function StartMainScript()
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
    local Window = Library.CreateLib("SONGKRAN HUB - MM2 V.6", "DarkTheme")

    -- --- หน้าหลัก (Main) ---
    local MainTab = Window:NewTab("Main Menu")
    local MainSection = MainTab:NewSection("Player Mods")

    MainSection:NewSlider("WalkSpeed", "วิ่งไวขึ้น", 500, 16, function(s)
        pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s end)
    end)

    MainSection:NewSlider("JumpPower", "กระโดดสูง", 500, 50, function(s)
        pcall(function() game.Players.LocalPlayer.Character.Humanoid.JumpPower = s end)
    end)

    -- --- หน้าฟาร์ม (Farming) ---
    local FarmTab = Window:NewTab("Farming")
    local FarmSection = FarmTab:NewSection("Auto Collect")

    FarmSection:NewToggle("Auto Collect Coins", "ดูดเหรียญอัตโนมัติ (รันรอบแมพ)", function(state)
        _G.AutoCoin = state
        task.spawn(function()
            while _G.AutoCoin do
                local char = game.Players.LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                local container = workspace:FindFirstChild("CoinContainer") or workspace:FindFirstChild("Coins") -- รองรับหลายชื่อ
                if container then
                    for _, coin in pairs(container:GetChildren()) do
                        if _G.AutoCoin and root and coin:IsA("BasePart") then
                            root.CFrame = coin.CFrame
                            task.wait(0.1)
                        end
                    end
                end
                task.wait()
            end
        end)
    end)

    -- --- หน้าสายลับ (Visuals/ESP) ---
    local VisualTab = Window:NewTab("Visuals")
    local VisualSection = VisualTab:NewSection("ESP Settings")

    VisualSection:NewToggle("Show Murderer & Sheriff", "ระบุตัวฆาตกรและตำรวจ", function(state)
        _G.MM2Esp = state
        game:GetService("RunService").RenderStepped:Connect(function()
            if not _G.MM2Esp then return end
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= game.Players.LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local color = Color3.fromRGB(0, 255, 0) -- Innocent
                    if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then
                        color = Color3.fromRGB(255, 0, 0) -- Murderer
                    elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then
                        color = Color3.fromRGB(0, 0, 255) -- Sheriff
                    end
                    
                    if not p.Character:FindFirstChild("MM2Box") then
                        local b = Instance.new("BoxHandleAdornment", p.Character)
                        b.Name = "MM2Box"
                        b.Adornee = p.Character.HumanoidRootPart
                        b.AlwaysOnTop = true
                        b.ZIndex = 10
                        b.Size = Vector3.new(4, 5, 0.5)
                        b.Transparency = 0.5
                        b.Color3 = color
                    else
                        p.Character.MM2Box.Color3 = color
                    end
                end
            end
        end)
    end)

    -- --- หน้าสากล (Misc) ---
    local MiscTab = Window:NewTab("Misc")
    local MiscSection = MiscTab:NewSection("Tools")

    MiscSection:NewButton("Fly Mode (CFrame)", "บินตามกล้อง (เปิด/ปิดในตัว)", function()
        _G.Fly = not _G.Fly
        local char = game.Players.LocalPlayer.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        if _G.Fly then
            task.spawn(function()
                while _G.Fly and char.Parent do
                    local moveDir = game.Players.LocalPlayer.Character.Humanoid.MoveDirection
                    if moveDir.Magnitude > 0 then
                        root.CFrame = root.CFrame * CFrame.new(moveDir.X * 2, (workspace.CurrentCamera.CFrame.LookVector.Y * 2), moveDir.Z * 2)
                    end
                    root.Velocity = Vector3.new(0, 0.1, 0)
                    task.wait()
                end
            end)
        end
    end)
end

-- --- ระบบ Key UI (LOGIN) ---
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 260, 0, 180)
KeyFrame.Position = UDim2.new(0.5, -130, 0.5, -90)
KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Instance.new("UICorner", KeyFrame)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = "SONGKRAN HUB | MM2 LOGIN"
KeyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 16

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0.8, 0, 0, 35)
KeyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
KeyInput.PlaceholderText = "Type Key: SONGKRAN123"
KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", KeyInput)

local SubmitBtn = Instance.new("TextButton", KeyFrame)
SubmitBtn.Size = UDim2.new(0.8, 0, 0, 40)
SubmitBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
SubmitBtn.Text = "LOGIN"
SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", SubmitBtn)

SubmitBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        ScreenGui:Destroy()
        StartMainScript()
    else
        SubmitBtn.Text = "WRONG KEY"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        task.wait(1)
        SubmitBtn.Text = "LOGIN"
        SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    end
end)
