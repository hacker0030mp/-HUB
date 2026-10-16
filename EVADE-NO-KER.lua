-- =======================================================
-- สุริยันหยินหยาง HUB & RTS HUB - Custom UI + Kill System
-- ภาษาไทย 100% | ไอคอนลอยหมุนได้และลากได้ | ธีมสีเขียวมรกต
-- =======================================================

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- ลบ UI เก่าทิ้งก่อนสร้างใหม่ (ป้องกันซ้ำซ้อน)
if CoreGui:FindFirstChild("YinYangCustomUI") then
    CoreGui.YinYangCustomUI:Destroy()
end

-- สร้าง ScreenGui หลัก
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YinYangCustomUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- =======================================================
-- 1. สร้างไอคอนลูกบอลลอยได้ (Floating Rotating Logo)
-- =======================================================
local FloatingButton = Instance.new("ImageButton")
FloatingButton.Name = "FloatingLogo"
FloatingButton.Parent = ScreenGui
FloatingButton.BackgroundColor3 = Color3.fromRGB(5, 14, 9)
FloatingButton.BorderColor3 = Color3.fromRGB(16, 185, 129)
FloatingButton.BorderSizePixel = 2
FloatingButton.Position = UDim2.new(0.05, 0, 0.2, 0)
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Image = "https://cdn.phototourl.com/member/2026-10-16-c8fd00c7-3c45-446d-bf02-956f9ca17068.jpg"
FloatingButton.ScaleType = Enum.ScaleType.Stretch
FloatingButton.Active = true
FloatingButton.Draggable = true -- เปิดให้ลากไปมาบนหน้าจอได้

local UICorner = Instance.new("UICorner", FloatingButton)
UICorner.CornerRadius = UDim.new(1, 0) -- ทรงกลม

-- ทำให้รูปภาพหมุน 360 องศาตลอดเวลา
task.spawn(function()
    local rotation = 0
    while FloatingButton and FloatingButton.Parent do
        rotation = (rotation + 2) % 360
        FloatingButton.Rotation = rotation
        task.wait(0.03)
    end
end)

-- =======================================================
-- 2. สร้างหน้าต่างเมนูหลัก (Main Frame)
-- =======================================================
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 14, 9)
MainFrame.BorderColor3 = Color3.fromRGB(16, 185, 129)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Visible = false -- ซ่อนไว้ก่อน กดที่ไอคอนลอยถึงจะเปิด

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

-- หัวข้อด้านบน (Header - แสดงค่ายผู้พัฒนา)
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Parent = MainFrame
Header.BackgroundColor3 = Color3.fromRGB(4, 120, 87)
Header.Size = UDim2.new(1, 0, 0, 40)

local HeaderCorner = Instance.new("UICorner", Header)
HeaderCorner.CornerRadius = UDim.new(0, 12)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = Header
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, -40, 1, 0)
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "สุริยันหยินหยาง HUB & RTS HUB | โมโก้ ไมเกิร์น & ใจ"
TitleLabel.TextColor3 = Color3.fromRGB(236, 253, 245)
TitleLabel.TextSize = 13
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

-- ปุ่มปิดหน้าต่าง (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = Header
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 38, 38)
CloseBtn.Position = UDim2.new(1, -35, 0.5, -12)
CloseBtn.Size = UDim2.new(0, 24, 0, 24)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 14
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- กดที่ไอคอนลอยเพื่อเปิด/ปิดเมนูหลัก
FloatingButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- =======================================================
-- 3. ระบบแท็บและเนื้อหาภายใน (Tabs & Content)
-- =======================================================
local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundTransparency = 1
TabContainer.Position = UDim2.new(0, 10, 0, 50)
TabContainer.Size = UDim2.new(1, -20, 1, -60)
TabContainer.CanvasSize = UDim2.new(0, 0, 2.5, 0)
TabContainer.ScrollBarThickness = 6

local UIListLayout = Instance.new("UIListLayout", TabContainer)
UIListLayout.Padding = UDim.new(0, 10)

-- ฟังก์ชันสร้างหัวข้อหมวดหมู่
local function createSectionTitle(text)
    local lbl = Instance.new("TextLabel")
    lbl.Parent = TabContainer
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 0, 25)
    lbl.Font = Enum.Font.SourceSansBold
    lbl.Text = "--- " .. text .. " ---"
    lbl.TextColor3 = Color3.fromRGB(110, 231, 183)
    lbl.TextSize = 15
    return lbl
end

-- ฟังก์ชันสร้างปุ่มกด
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.BackgroundColor3 = Color3.fromRGB(4, 120, 87)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(236, 253, 245)
    btn.TextSize = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ฟังก์ชันสร้างปุ่ม Toggle เปิด/ปิด
local function createToggle(text, defaultState, callback)
    local state = defaultState
    local btn = Instance.new("TextButton")
    btn.Parent = TabContainer
    btn.BackgroundColor3 = state and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(31, 41, 55)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.SourceSansBold
    btn.Text = text .. (state and " [เปิด]" or " [ปิด]")
    btn.TextColor3 = Color3.fromRGB(236, 253, 245)
    btn.TextSize = 15
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(31, 41, 55)
        btn.Text = text .. (state and " [เปิด]" or " [ปิด]")
        callback(state)
    end)
    return btn
end

-- =======================================================
-- [ บรรจุฟังก์ชันทั้งหมดรวมถึงระบบ Kill ]
-- =======================================================

createSectionTitle("⚔️ ระบบ Kill (การกำจัดเป้าหมาย)")

createButton("💥 วาร์ปไปฟัน/ฆ่าผู้เล่นทุกคนในแมพ (Kill All)", function()
    pcall(function()
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local originalPos = myRoot.CFrame

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local targetRoot = plr.Character.HumanoidRootPart
                myRoot.CFrame = targetRoot.CFrame
                task.wait(0.1) -- ขยับไปหาทีละคนเพื่อโจมตี
            end
        end
        myRoot.CFrame = originalPos
    end)
end)

createToggle("🎯 ล็อกเป้าหมายโจมตีอัตโนมัติ (Aimbot/Kill Aura)", false, function(state)
    _G.KillAura = state
    task.spawn(function()
        while _G.KillAura do
            task.wait(0.2)
            pcall(function()
                local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot then return end
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRoot") then
                        local enemyRoot = plr.Character.HumanoidRootPart
                        if (myRoot.Position - enemyRoot.Position).Magnitude < 15 then
                            -- โจมตีอัตโนมัติระยะประชิด
                            local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                            if tool then tool:Activate() end
                        end
                    end
                end
            end)
        end
    end)
end)

createSectionTitle("⚡ ตัวละครและการเคลื่อนไหว")

createButton("⚡ เร่งความเร็วเดิน (WalkSpeed 50)", function()
    pcall(function()
        LocalPlayer.Character.Humanoid.WalkSpeed = 50
    end)
end)

createButton("🚀 กระโดดสูงพิเศษ (JumpPower 120)", function()
    pcall(function()
        LocalPlayer.Character.Humanoid.UseJumpPower = true
        LocalPlayer.Character.Humanoid.JumpPower = 120
    end)
end)

createSectionTitle("⚙️ ระบบตั้งค่า UI และความปลอดภัย")

createToggle("🔒 ล็อกไอคอนลอย (Lock Floating Icon)", false, function(state)
    FloatingButton.Draggable = not state
end)

createToggle("👁️ เปิด/ปิด มองทะลุกำแพง (ESP)", false, function(state)
    _G.PlayerESP = state
end)

createButton("❌ ปิดและลบสคริปต์ทั้งหมด", function()
    ScreenGui:Destroy()
end)

-- ระบบ ESP สากล
RunService.RenderStepped:Connect(function()
    if _G.PlayerESP then
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    if not head:FindFirstChild("CustomESP") then
                        local bb = Instance.new("BillboardGui", head)
                        bb.Name = "CustomESP"
                        bb.Size = UDim2.new(0, 100, 0, 40)
                        bb.AlwaysOnTop = true
                        bb.StudsOffset = Vector3.new(0, 2, 0)
                        
                        local txt = Instance.new("TextLabel", bb)
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(16, 185, 129)
                        txt.TextStrokeTransparency = 0.4
                        txt.TextSize = 14
                        txt.Font = Enum.Font.SourceSansBold
                        txt.Text = player.Name
                    end
                end
            end
        end)
    else
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character and player.Character:FindFirstChild("Head") then
                    local esp = player.Character.Head:FindFirstChild("CustomESP")
                    if esp then esp:Destroy() end
                end
            end
        end)
    end
end)

print("สุริยันหยินหยาง Custom UI + Kill System โหลดสำเร็จ!")
