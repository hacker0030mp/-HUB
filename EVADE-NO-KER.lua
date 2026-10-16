-- =======================================================
-- สุริยันหยินหยาง HUB & RTS HUB - สคริปต์กิจกรรม Evade
-- (เวอร์ชันภาษาไทย 100% + ธีมสีเขียวมรกต)
-- =======================================================

local _version = "1.6.66"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. _version .. "/main.lua"))()

-- -------------------------------------------------------
-- [ ปรับแต่งธีมโทนสีเขียวสุริยันหยินหยาง ]
-- -------------------------------------------------------
WindUI:AddTheme({
    Name = "YinYangGreen",
    Accent = Color3.fromHex("#10b981"),      -- สีเขียวมรกตเด่น
    Background = Color3.fromHex("#091a12"),  -- สีเขียวเข้มเฉดดำ
    Outline = Color3.fromHex("#059669"),     -- ขอบสีเขียวสด
    Text = Color3.fromHex("#ecfdf5"),        -- ข้อความสีขาวอมเขียวอ่อน
    Placeholder = Color3.fromHex("#6ee7b7"), -- ข้อความตัวอย่างสีเขียวพาสเทล
    Button = Color3.fromHex("#047857"),      -- ปุ่มกดสีเขียวเข้ม
    Icon = Color3.fromHex("#34d399"),        -- ไอคอนสีเขียวสว่าง
})

-- สร้างหน้าต่างหลัก
local Window = WindUI:CreateWindow({
    Title = "สุริยันหยินหยาง HUB + RTS HUB | กิจกรรม Evade",
    Icon = "bird",
    Author = "โมโก้ ไมเกิร์น & ใจ",
    Folder = "YinYang_RTS_Evade",
    Size = UDim2.fromOffset(600, 480),
    Transparent = true,
    Theme = "YinYangGreen",
    SideBarWidth = 170,
    HasOutline = true
})

-- แสดงหน้าต่างแจ้งเตือนต้อนรับ
WindUI:Popup({
    Title = "สุริยันหยินหยาง HUB",
    Content = "ยินดีต้อนรับสู่สคริปต์ Evade โทนสีเขียวมรกตภาษาไทย!",
    Buttons = {
        {
            Title = "เริ่มใช้งาน",
            Callback = function()
                print("เริ่มใช้งาน สุริยันหยินหยาง HUB...")
            end
        }
    }
})

-- -------------------------------------------------------
-- [ ตัวแปรและฟังก์ชันระบบ ]
-- -------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local AutoRegen = false
local AutoFarmMoney = false
local MoneyAmountPerLoop = 10000
local FarmDelay = 1

local WalkSpeedValue = 16
local JumpPowerValue = 50
local GravityValue = 196.2
local NoclipEnabled = false
local InfiniteJumpEnabled = false
local AutoJumpEnabled = false
local GodEmoteLock = false

local function getHumanoid()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

local function addMoney(player, amount)
    if not player then return end
    pcall(function()
        local stats = player:FindFirstChild("leaderstats")
        if stats then
            local money = stats:FindFirstChild("Money") or stats:FindFirstChild("Coins") or stats:FindFirstChild("Cash")
            if money then
                money.Value = money.Value + amount
            end
        end
    end)
end

-- ระบบทำงานเบื้องหลัง
task.spawn(function()
    while task.wait(1) do
        if AutoRegen then
            pcall(function()
                local hum = getHumanoid()
                if hum and hum.Health < hum.MaxHealth then
                    hum.Health = hum.Health + 9999999999
                end
            end)
        end
    end
end)

task.spawn(function()
    while true do
        if FarmDelay <= 0 then
            task.defer(task.wait)
        else
            task.wait(FarmDelay)
        end
        if AutoFarmMoney then
            addMoney(LocalPlayer, MoneyAmountPerLoop)
        end
    end
end)

RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        pcall(function()
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        pcall(function()
            local hum = getHumanoid()
            if hum then hum:ChangeState("Jumping") end
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    if AutoJumpEnabled then
        pcall(function()
            local hum = getHumanoid()
            if hum and hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState("Jumping")
            end
        end)
    end
end)

RunService.RenderStepped:Connect(function()
    if GodEmoteLock then
        pcall(function()
            local hum = getHumanoid()
            if hum then hum.WalkSpeed = WalkSpeedValue end
        end)
    end
end)

-- -------------------------------------------------------
-- [ หน้าเมนูต่างๆ (ภาษาไทย 100%) ]
-- -------------------------------------------------------

-- 1. หมวดออโต้ฟาร์ม
local FarmTab = Window:Tab({ Title = "1. ฟาร์มอัตโนมัติ", Icon = "bird" })

local FarmSection = FarmTab:Section({ Title = "หมวดตั้งค่าการฟาร์มเงิน" })

FarmSection:Toggle({
    Title = "เปิด/ปิด ระบบฟาร์มเงินอัตโนมัติ",
    Callback = function(Value)
        AutoFarmMoney = Value
        WindUI:Notify({
            Title = "สถานะการฟาร์ม",
            Content = Value and "เริ่มฟาร์มเงินอัตโนมัติแล้ว" or "หยุดการฟาร์มเงินแล้ว",
            Duration = 3
        })
    end
})

FarmSection:Input({
    Title = "จำนวนเงินที่ต้องการเพิ่มต่อรอบ",
    Value = tostring(MoneyAmountPerLoop),
    Placeholder = "พิมพ์ตัวเลข...",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then MoneyAmountPerLoop = num end
    end
})

FarmSection:Slider({
    Title = "ความเร็วในการเพิ่มเงิน (วินาที)",
    Value = {
        Min = 0,
        Max = 10,
        Default = 1
    },
    Callback = function(Value)
        FarmDelay = Value
    end
})

local HealthSection = FarmTab:Section({ Title = "หมวดระบบพลังชีวิต" })

HealthSection:Toggle({
    Title = "ฟื้นฟูเลือดอมตะ (ไม่มีวันตาย)",
    Callback = function(Value)
        AutoRegen = Value
        WindUI:Notify({
            Title = "ระบบพลังชีวิต",
            Content = Value and "เปิดใช้งานเลือดอมตะแล้ว" or "ปิดใช้งานเลือดอมตะ",
            Duration = 3
        })
    end
})

-- 2. หมวดตัวละคร
local PlayerTab = Window:Tab({ Title = "2. ตัวละคร", Icon = "bird" })

local PlayerSection = PlayerTab:Section({ Title = "หมวดปรับแต่งสเตตัสตัวละคร" })

PlayerSection:Slider({
    Title = "ความเร็วในการเดิน",
    Value = {
        Min = 16,
        Max = 300,
        Default = 16
    },
    Callback = function(Value)
        WalkSpeedValue = Value
        local hum = getHumanoid()
        if hum then hum.WalkSpeed = Value end
    end
})

PlayerSection:Slider({
    Title = "ความสูงในการกระโดด",
    Value = {
        Min = 50,
        Max = 200,
        Default = 50
    },
    Callback = function(Value)
        JumpPowerValue = Value
        local hum = getHumanoid()
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})

PlayerSection:Slider({
    Title = "ระดับแรงโน้มถ่วง (ตกช้า/ลอยตัว)",
    Value = {
        Min = 10,
        Max = 196,
        Default = 196
    },
    Callback = function(Value)
        GravityValue = Value
        pcall(function() workspace.Gravity = Value end)
    end
})

PlayerSection:Toggle({
    Title = "กระโดดอัตโนมัติ (เมื่อเท้าแตะพื้น)",
    Callback = function(Value)
        AutoJumpEnabled = Value
    end
})

PlayerSection:Toggle({
    Title = "กระโดดได้ไม่จำกัด (กระโดดกลางอากาศ)",
    Callback = function(Value)
        InfiniteJumpEnabled = Value
    end
})

PlayerSection:Toggle({
    Title = "เดินทะลุสิ่งกีดขวาง (ทะลุกำแพง)",
    Callback = function(Value)
        NoclipEnabled = Value
    end
})

PlayerSection:Toggle({
    Title = "ล็อกความเร็วเดิน (ขณะเต้นหรือรำ)",
    Callback = function(Value)
        GodEmoteLock = Value
    end
})

-- 3. หมวดช่วยเหลือผู้เล่น
local MultiTab = Window:Tab({ Title = "3. แบกผู้เล่น", Icon = "bird" })

local MultiSection = MultiTab:Section({ Title = "หมวดระบบช่วยเหลือและแบกเพื่อน" })

MultiSection:Button({
    Title = "วาร์ปไปอุ้มแบกเพื่อนที่ล้ม",
    Callback = function()
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if player.Character:FindFirstChild("Downed") or (player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health <= 0) then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                            WindUI:Notify({ Title = "ระบบแบกเพื่อน", Content = "วาร์ปไปแบกเพื่อน: " .. player.Name, Duration = 3 })
                            break
                        end
                    end
                end
            end
        end)
    end
})

MultiSection:Button({
    Title = "วาร์ปไปช่วยชุบชีวิตเพื่อนอัตโนมัติ",
    Callback = function()
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health <= 0 or player.Character:FindFirstChild("Downed") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                            WindUI:Notify({ Title = "ระบบชุบชีวิต", Content = "วาร์ปไปชุบชีวิตเพื่อน: " .. player.Name, Duration = 3 })
                            break
                        end
                    end
                end
            end
        end)
    end
})

-- 4. หมวดข้อมูลสคริปต์
local AboutTab = Window:Tab({ Title = "4. เกี่ยวกับ", Icon = "bird" })

local AboutSection = AboutTab:Section({ Title = "หมวดข้อมูลผู้พัฒนาและชุมชน" })

AboutSection:Button({
    Title = "ทีมผู้พัฒนา: ชุมชนสุริยันหยินหยาง HUB & RTS HUB",
    Callback = function() end
})

AboutSection:Button({
    Title = "เครดิตผู้สร้าง: โมโก้ ไมเกิร์น & ใจ",
    Callback = function() end
})

AboutSection:Button({
    Title = "คัดลอกลิงก์เข้าร่วม ดิสคอร์ด ชุมชน",
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/yZsDDsKJ9t")
            WindUI:Notify({
                Title = "ดิสคอร์ดชุมชน",
                Content = "คัดลอกลิงก์ดิสคอร์ดเรียบร้อยแล้ว!",
                Duration = 3
            })
        end)
    end
})

WindUI:Notify({
    Title = "สำเร็จ",
    Content = "โหลดเมนูภาษาไทยสมบูรณ์แบบแล้ว!",
    Duration = 3
})
