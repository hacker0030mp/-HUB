-- =======================================================
-- สุริยันหยินหยาง HUB & RTS HUB - Evade Event Script
-- (Updated: Low Gravity / Slow Fall System)
-- =======================================================

local WindUI = loadstring(game:HttpGet("https://tree-hub.vercel.app/api/UI/WindUI"))()

local Window = WindUI:CreateWindow({
    Title = "สุริยันหยินหยาง HUB + RTS HUB | Evade Event",
    Icon = "rbxassetid://10734919808",
    Author = "โมโก้ ไมเกิร์น & ใจ",
    Folder = "YinYang_RTS_Evade",
    Size = UDim2.fromOffset(600, 480),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 170,
    HasOutline = true
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
local GravityValue = 196.2 -- ค่าแรงโน้มถ่วงเดิมของ Roblox
local NoclipEnabled = false
local InfiniteJumpEnabled = false
local AutoJumpEnabled = false
local GodEmoteLock = false

-- ฟังก์ชันเพิ่มเงิน
local function addMoney(player, amount)
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

-- 1. Auto Regen
task.spawn(function()
    while true do
        task.wait(1)
        if AutoRegen then
            pcall(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    local hum = character:FindFirstChildOfClass("Humanoid")
                    if hum.Health < hum.MaxHealth then
                        hum.Health = hum.Health + 9999999999
                    end
                end
            end)
        end
    end
end)

-- 2. Auto Farm Money
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

-- 3. Noclip (เดินทะลุกำแพง)
RunService.Stepped:Connect(function()
    if NoclipEnabled and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 4. Infinite Jump (กระโดดไม่จำกัด)
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

-- 5. Auto Jump (กระโดดอัตโนมัติเมื่อเท้าแตะพื้น)
RunService.RenderStepped:Connect(function()
    if AutoJumpEnabled and LocalPlayer.Character then
        pcall(function()
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.FloorMaterial ~= Enum.Material.Air then
                humanoid:ChangeState("Jumping")
            end
        end)
    end
end)

-- 6. ล็อกความเร็วเมื่อกดท่าทาง (GOD Mode Speed Lock for Emotes)
RunService.RenderStepped:Connect(function()
    if GodEmoteLock and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        hum.WalkSpeed = WalkSpeedValue
    end
end)

-- -------------------------------------------------------
-- [ หน้าเมนูต่างๆ (Tabs) ]
-- -------------------------------------------------------

-- Tab 1: ออโต้ฟาร์ม (Auto Farm)
local FarmTab = Window:Tab({ Title = "1. ออโต้ฟาร์ม", Icon = "rbxassetid://10734938600" })

FarmTab:Section({ Title = "ตั้งค่าออโต้ฟาร์มเงิน" })

FarmTab:Toggle({
    Title = "เปิด/ปิด ออโต้ฟาร์มเงิน",
    Value = false,
    Callback = function(Value)
        AutoFarmMoney = Value
    end
})

FarmTab:Input({
    Title = "จำนวนเงินที่ต้องการเพิ่มต่อครั้ง",
    Value = tostring(MoneyAmountPerLoop),
    Placeholder = "ใส่ตัวเลข...",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then MoneyAmountPerLoop = num end
    end
})

FarmTab:Slider({
    Title = "ความเร็วการเพิ่ม (ทุกๆ กี่วินาที)",
    Min = 0,
    Max = 10,
    Default = 1,
    Increment = 0.5,
    Callback = function(Value)
        FarmDelay = Value
    end
})

FarmTab:Section({ Title = "บัคเลือด" })
FarmTab:Toggle({
    Title = "ฟื้นฟูเลือดอมตะ (Infinite Health)",
    Value = false,
    Callback = function(Value)
        AutoRegen = Value
    end
})

-- Tab 2: ระบบตัวละคร (Player Settings)
local PlayerTab = Window:Tab({ Title = "2. Player (ตัวละคร)", Icon = "rbxassetid://10734950020" })

PlayerTab:Section({ Title = "ปรับแต่งสเตตัสตัวละคร" })

PlayerTab:Slider({
    Title = "ความเร็วการเดิน (WalkSpeed)",
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(Value)
        WalkSpeedValue = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = Value
        end
    end
})

PlayerTab:Slider({
    Title = "กระโดดสูง (JumpPower)",
    Min = 50,
    Max = 200,
    Default = 50,
    Callback = function(Value)
        JumpPowerValue = Value
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            hum.UseJumpPower = true
            hum.JumpPower = Value
        end
    end
})

-- สไลด์ปรับแรงโน้มถ่วง (ค่าปกติ = 196.2, ยิ่งน้อยยิ่งตกช้า/ลอยตัว)
PlayerTab:Slider({
    Title = "แรงโน้มถ่วง (Gravity / ตกช้า)",
    Min = 10,
    Max = 196.2,
    Default = 196.2,
    Increment = 5,
    Callback = function(Value)
        GravityValue = Value
        pcall(function()
            workspace.Gravity = Value
        end)
        WindUI:Notify({ Title = "Gravity", Content = "ปรับแรงโน้มถ่วงเป็น: " .. Value, Duration = 2 })
    end
})

PlayerTab:Toggle({
    Title = "ออโต้กระโดด (Auto Jump when Landing)",
    Desc = "เมื่อเท้าแตะพื้น ตัวละครจะกระโดดต่อให้อัตโนมัติทันที",
    Value = false,
    Callback = function(Value)
        AutoJumpEnabled = Value
        WindUI:Notify({ Title = "Auto Jump", Content = Value and "เปิดออโต้กระโดดแล้ว!" or "ปิดออโต้กระโดด", Duration = 2 })
    end
})

PlayerTab:Toggle({
    Title = "กระโดดไม่จำกัด (Infinite Jump)",
    Desc = "กระโดดกลางอากาศได้เรื่อยๆ ไต่ขึ้นฟ้าได้ไม่จำกัด",
    Value = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
        WindUI:Notify({ Title = "Infinite Jump", Content = Value and "เปิดกระโดดไม่จำกัดแล้ว!" or "ปิดการกระโดดไม่จำกัด", Duration = 2 })
    end
})

PlayerTab:Toggle({
    Title = "ทะลุสิ่งของ (Noclip)",
    Desc = "เดินทะลุกำแพง สิ่งกีดขวาง และแมปได้ทั้งหมด",
    Value = false,
    Callback = function(Value)
        NoclipEnabled = Value
        WindUI:Notify({ Title = "Noclip", Content = Value and "เปิดเดินทะลุกำแพงแล้ว" or "ปิดการเดินทะลุ", Duration = 2 })
    end
})

PlayerTab:Toggle({
    Title = "รีโมท GOD Mode (ล็อกความเร็วเวลารำ)",
    Desc = "เมื่อกดท่าทาง/Emote ความเร็วเดินจะคงเท่าเดิมไม่ช้าลง",
    Value = false,
    Callback = function(Value)
        GodEmoteLock = Value
        WindUI:Notify({ Title = "GOD Emote Lock", Content = Value and "เปิดใช้งานล็อกความเร็วแล้ว!" or "ปิดการใช้งาน", Duration = 2 })
    end
})

-- Tab 3: ระบบผู้เล่น/แบกเพื่อน (Carry & Multiplayer)
local MultiTab = Window:Tab({ Title = "3. แบกผู้เล่น (Carry / Multi)", Icon = "rbxassetid://10723415693" })

MultiTab:Section({ Title = "ระบบแบก & ช่วยเหลือเพื่อน" })

MultiTab:Button({
    Title = "อุ้ม/แบกเพื่อนที่ล้ม (Carry Downed Player)",
    Desc = "วาร์ปไปอุ้มแบกเพื่อนที่ล้มอยู่ทันที",
    Callback = function()
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    if player.Character:FindFirstChild("Downed") or (player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health <= 0) then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                            WindUI:Notify({ Title = "Carry System", Content = "วาร์ปไปแบกเพื่อน: " .. player.Name, Duration = 2 })
                            break
                        end
                    end
                end
            end
        end)
    end
})

MultiTab:Button({
    Title = "ชุบชีวิตเพื่อนอัตโนมัติ (Auto Revive)",
    Callback = function()
        pcall(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
                    if player.Character.Humanoid.Health <= 0 or player.Character:FindFirstChild("Downed") then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
                            break
                        end
                    end
                end
            end
        end)
    end
})

-- Tab 4: เกี่ยวกับ (About & Discord)
local AboutTab = Window:Tab({ Title = "4. เกี่ยวกับ", Icon = "rbxassetid://10723423881" })

AboutTab:Section({ Title = "ข้อมูลผู้พัฒนา & ดิสคอร์ด" })
AboutTab:Paragraph({ Title = "ผู้สร้าง", Desc = "สุริยันหยินหยาง HUB & RTS HUB Community" })
AboutTab:Paragraph({ Title = "เครดิต", Desc = "โมโก้ ไมเกิร์น & ใจ" })
AboutTab:Paragraph({ Title = "Discord Link", Desc = "https://discord.gg/yZsDDsKJ9t" })

AboutTab:Button({
    Title = "เข้าร่วม Discord Community (คัดลอกลิงก์)",
    Desc = "กดเพื่อคัดลอกลิงก์ Discord เข้าสู่ระบบคลิปบอร์ด",
    Callback = function()
        pcall(function()
            setclipboard("https://discord.gg/yZsDDsKJ9t")
            WindUI:Notify({ 
                Title = "Discord Community", 
                Content = "คัดลอกลิงก์ https://discord.gg/yZsDDsKJ9t สำเร็จแล้ว!", 
                Duration = 4 
            })
        end)
    end
})

WindUI:Notify({
    Title = "สุริยันหยินหยาง HUB",
    Content = "เพิ่มระบบแรงโน้มถ่วง (ตกช้า) เรียบร้อยแล้ว!",
    Duration = 4
})
