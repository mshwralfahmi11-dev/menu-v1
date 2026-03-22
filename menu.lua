-- تحميل Kavo UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/refs/heads/main/source.lua"))()
local Window = Library.CreateLib("Red Night", "BloodTheme")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Tabs
local MainTab = Window:NewTab("Main")
local PlayerTab = Window:NewTab("Player")
local FunTab = Window:NewTab("Fun")

local Main = MainTab:NewSection("Main")
local PlayerSec = PlayerTab:NewSection("Player")
local Fun = FunTab:NewSection("Fun")

-- حالات
local speedOn, jumpOn, noclipOn = false, false, false
local spinOn = false
local flyOn = false
local flySpeed = 50
local savedPos = nil

-- ========================
-- MAIN
-- ========================
Main:NewToggle("Speed", "", function(v) speedOn = v end)
Main:NewToggle("Infinite Jump", "", function(v) jumpOn = v end)

-- ========================
-- PLAYER
-- ========================
PlayerSec:NewToggle("Noclip", "", function(v) noclipOn = v end)

PlayerSec:NewButton("Save Position", "", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        savedPos = char.HumanoidRootPart.CFrame
    end
end)

PlayerSec:NewButton("Return Position", "", function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") and savedPos then
        char.HumanoidRootPart.CFrame = savedPos
    end
end)

-- ========================
-- FUN 😈
-- ========================
Fun:NewToggle("Spin", "", function(v) spinOn = v end)

-- Fly
Fun:NewToggle("Fly", "Smooth Fly", function(v)
    flyOn = v
end)

Fun:NewButton("+ Speed", "", function()
    flySpeed = flySpeed + 10
end)

Fun:NewButton("- Speed", "", function()
    flySpeed = math.max(10, flySpeed - 10)
end)

Fun:NewLabel("Use WASD + Space/Shift")

-- ========================
-- تشغيل مستقر
-- ========================
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    -- Speed
    hum.WalkSpeed = speedOn and 50 or 16

    -- Jump
    hum.JumpPower = jumpOn and 100 or 50

    -- Noclip
    if noclipOn then
        for _,v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end

    -- Spin
    if spinOn then
        hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(3), 0)
    end

    -- Fly احترافي
    if flyOn then
        hum.PlatformStand = true

        local cam = workspace.CurrentCamera
        local move = Vector3.new()

        if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end

        hrp.Velocity = move * flySpeed
    else
        hum.PlatformStand = false
    end
end)

-- ========================
-- زر _
-- ========================
local gui = player:WaitForChild("PlayerGui")

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(0,40,0,40)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "_"
toggle.BackgroundColor3 = Color3.fromRGB(0,0,0)
toggle.TextColor3 = Color3.fromRGB(255,0,0)
toggle.Parent = gui

local visible = true

toggle.MouseButton1Click:Connect(function()
    visible = not visible
    for _,v in pairs(gui:GetChildren()) do
        if v:IsA("ScreenGui") and v ~= toggle.Parent then
            v.Enabled = visible
        end
    end
end)
