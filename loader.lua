-- Hrdora Hub Ultimate - Neon RGB & Animated UI Edition
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = workspace
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

if CoreGui:FindFirstChild("HrdoraNeonHub") then
    CoreGui.HrdoraNeonHub:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HrdoraNeonHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = CoreGui

-- Nút mở/đóng menu có hiệu ứng phóng to thu nhỏ
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleNode"
ToggleBtn.Size = UDim2.new(0, 52, 0, 52)
ToggleBtn.Position = UDim2.new(0, 24, 0, 130)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 240, 255)
ToggleBtn.Text = "HR"
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 16)
local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Thickness = 2
ToggleStroke.Color = Color3.fromRGB(0, 240, 255)

-- Hiệu ứng đổi màu LED viền nút bấm liên tục
task.spawn(function()
    while true do
        for i = 0, 1, 0.01 do
            ToggleStroke.Color = Color3.fromHSV(i, 0.9, 1)
            task.wait(0.05)
        end
    end
end)

-- Khung Main chính
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainEngineContainer"
MainFrame.Size = UDim2.new(0, 460, 0, 520)
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -260)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui

Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 16)
local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2
MainStroke.Color = Color3.fromRGB(120, 50, 255)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
    -- Hiệu ứng mờ dần hoặc thu phóng khi ẩn hiện menu có thể thêm ở đây
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -20, 0, 45)
TitleLabel.Position = UDim2.new(0, 18, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "✨ HRDORA HUB // NEON ANIMATED ENGINE"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame

local TabContainer = Instance.new("ScrollingFrame")
TabContainer.Size = UDim2.new(1, -24, 0, 40)
TabContainer.Position = UDim2.new(0, 12, 0, 48)
TabContainer.BackgroundTransparency = 1
TabContainer.CanvasSize = UDim2.new(1.5, 0, 0, 0)
TabContainer.ScrollBarThickness = 0
TabContainer.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.Padding = UDim.new(0, 8)
TabLayout.Parent = TabContainer

local ContentPanelsContainer = Instance.new("Frame")
ContentPanelsContainer.Size = UDim2.new(1, -24, 1, -104)
ContentPanelsContainer.Position = UDim2.new(0, 12, 0, 96)
ContentPanelsContainer.BackgroundTransparency = 1
ContentPanelsContainer.Parent = MainFrame

local Panels = {}

local function createEngineTab(tabName, index)
    local panel = Instance.new("ScrollingFrame")
    panel.Name = tabName .. "Panel"
    panel.Size = UDim2.new(1, 0, 1, 0)
    panel.BackgroundTransparency = 1
    panel.CanvasSize = UDim2.new(0, 0, 10.0, 0)
    panel.ScrollBarThickness = 3
    panel.ScrollBarImageColor3 = Color3.fromRGB(150, 50, 255)
    panel.Visible = (index == 1)
    panel.Parent = ContentPanelsContainer

    local pLayout = Instance.new("UIListLayout")
    pLayout.Padding = UDim.new(0, 10)
    pLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    pLayout.Parent = panel

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(0, 105, 0, 36)
    tabBtn.BackgroundColor3 = index == 1 and Color3.fromRGB(40, 20, 70) or Color3.fromRGB(18, 18, 28)
    tabBtn.TextColor3 = index == 1 and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(160, 160, 190)
    tabBtn.Text = tabName
    tabBtn.TextSize = 11
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = TabContainer

    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)
    local tStroke = Instance.new("UIStroke", tabBtn)
    tStroke.Color = index == 1 and Color3.fromRGB(0, 240, 255) or Color3.fromRGB(50, 50, 80)
    tStroke.Thickness = 1.5

    tabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Panels) do p.Visible = false end
        for _, b in pairs(TabContainer:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(18, 18, 28), TextColor3 = Color3.fromRGB(160, 160, 190)}):Play()
            end
        end
        panel.Visible = true
        TweenService:Create(tabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 20, 70), TextColor3 = Color3.fromRGB(0, 240, 255)}):Play()
    end)

    Panels[tabName] = panel
    return panel
end

local function addUIComponentButton(parentPanel, btnText, callbackFunction)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -6, 0, 38)
    b.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    b.TextColor3 = Color3.fromRGB(220, 230, 255)
    b.Text = "   ⚡ " .. btnText
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextSize = 11
    b.Font = Enum.Font.GothamMedium
    b.Parent = parentPanel

    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Color3.fromRGB(60, 60, 95)
    stroke.Thickness = 1.2

    -- Animation chuyển màu khi rê chuột hoặc bấm
    b.MouseButton1Click:Connect(function()
        -- Hiệu ứng nhún nhảy (Scale animation giả lập)
        TweenService:Create(b, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0, 240, 255), TextColor3 = Color3.fromRGB(10, 10, 15)}):Play()
        task.wait(0.1)
        TweenService:Create(b, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 35), TextColor3 = Color3.fromRGB(220, 230, 255)}):Play()
        
        pcall(callbackFunction)
    end)
end

local function addUIComponentLabel(parentPanel, labelText)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -6, 0, 24)
    l.BackgroundTransparency = 1
    l.Text = "  🔥 " .. string.upper(labelText)
    l.TextColor3 = Color3.fromRGB(0, 240, 255)
    l.TextSize = 10
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parentPanel
end

-- TAB 1: FARM & COMBAT
local Tab1 = createEngineTab("Cày Cuộc", 1)
addUIComponentLabel(Tab1, "Hệ Thống Auto Farm & Chống Stun")
addUIComponentButton(Tab1, "Bật/Tắt: Auto Farm (Bay Cao + Anti-Stun)", function()
    _G.AF = not _G.AF
    task.spawn(function()
        while _G.AF do
            pcall(function()
                local character = LocalPlayer.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") then return end
                
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then
                    pcall(function()
                        local bodyVel = character.HumanoidRootPart:FindFirstChild("HrdoraAntiStun")
                        if not bodyVel then
                            bodyVel = Instance.new("BodyVelocity")
                            bodyVel.Name = "HrdoraAntiStun"
                            bodyVel.MaxForce = Vector3.new(400000, 400000, 400000)
                            bodyVel.Velocity = Vector3.new(0, 0, 0)
                            bodyVel.Parent = character.HumanoidRootPart
                        end
                    end)
                end

                local activeTool = character:FindFirstChildOfClass("Tool")
                if not activeTool then
                    for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
                        if item:IsA("Tool") and (item.ToolTip == "Sword" or item.ToolTip == "Melee" or item.ToolTip == "Blox Fruit" or item.ToolTip == "Gun") then
                            humanoid:EquipTool(item)
                            task.wait(0.2)
                            break
                        end
                    end
                end

                local questGui = LocalPlayer.PlayerGui:FindFirstChild("Main") and LocalPlayer.PlayerGui.Main:FindFirstChild("Quest")
                if questGui and not questGui.Visible then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("RequestQuest", "BanditQuest1", 1)
                else
                    if Workspace:FindFirstChild("Enemies") then
                        for _, e in pairs(Workspace.Enemies:GetChildren()) do
                            if e:FindFirstChild("HumanoidRootPart") and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                                repeat task.wait(0.2)
                                    if character:FindFirstChild("HumanoidRootPart") and e:FindFirstChild("HumanoidRootPart") then
                                        character.HumanoidRootPart.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 18, 2)
                                        local tool = character:FindFirstChildOfClass("Tool")
                                        if tool then tool:Activate() end
                                    end
                                until not e.Parent or e.Humanoid.Health <= 0 or not _G.AF
                            end
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local bv = LocalPlayer.Character.HumanoidRootPart:FindFirstChild("HrdoraAntiStun")
                if bv then bv:Destroy() end
            end
        end)
    end)
end)

addUIComponentButton(Tab1, "Bật/Tắt: Auto Nhặt Rương", function()
    _G.AC = not _G.AC
    task.spawn(function()
        while _G.AC do
            pcall(function()
                for _, chest in pairs(Workspace:GetChildren()) do
                    if string.find(chest.Name, "Chest") and chest:IsA("Model") and chest.PrimaryPart then
                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            LocalPlayer.Character.HumanoidRootPart.CFrame = chest.PrimaryPart.CFrame
                            task.wait(0.2)
                        end
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

addUIComponentButton(Tab1, "Bật/Tắt: Đánh Siêu Tốc (Fast Attack)", function()
    _G.FA = not _G.FA
    task.spawn(function()
        while _G.FA do
            pcall(function()
                if Workspace:FindFirstChild("Enemies") then
                    for _, v in pairs(Workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") then
                            ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack", v.HumanoidRootPart.Position)
                        end
                    end
                end
            end)
            task.wait(0.04)
        end
    end)
end)

-- TAB 2: FRUITS
local Tab2 = createEngineTab("Trái Ác Quỷ", 2)
addUIComponentLabel(Tab2, "Tính Năng Vòng Quay & Trái")
addUIComponentButton(Tab2, "Bật/Tắt: Vòng Quay Vô Hạn (Spam Spin)", function()
    _G.SpamSpin = not _G.SpamSpin
    task.spawn(function()
        while _G.SpamSpin do
            pcall(function()
                ReplicatedStorage.Remotes.CommF_:InvokeServer("Cousin", "Buy")
            end)
            task.wait(0.2)
        end
    end)
end)

addUIComponentButton(Tab2, "Cất Hết Trái Vào Kho", function()
    pcall(function()
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name, "Fruit") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name)
            end
        end
    end)
end)

-- TAB 3: TELEPORT
local Tab3 = createEngineTab("Dịch Chuyển", 3)
addUIComponentLabel(Tab3, "Dịch Chuyển Nhanh Các Đảo")
local islandMap = {
    {"Đảo Gió (Sea 1)", CFrame.new(979, 16, 1427)},
    {"Quán Cafe (Sea 2)", CFrame.new(-385, 73, 298)},
    {"Lâu Đài Trên Biển (Sea 3)", CFrame.new(-5083, 315, -3155)}
}
for _, data in ipairs(islandMap) do
    addUIComponentButton(Tab3, data[1], function()
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = data[2]
            end
        end)
    end)
end

-- TAB 4: UTILITIES
local Tab4 = createEngineTab("Tiện Ích", 4)
addUIComponentLabel(Tab4, "Công Cụ Hỗ Trợ Khác")
addUIComponentButton(Tab4, "Bật/Tắt: Xuyên Tường (NoClip)", function()
    _G.NC = not _G.NC
    RunService.Stepped:Connect(function()
        if _G.NC and LocalPlayer.Character then
            for _, p in pairs(LocalPlayer.Character:GetDescendants()) do
                if p:IsA("BasePart") then p.CanCollide = false end
            end
        end
    end)
end)

addUIComponentButton(Tab4, "Hủy Giao Diện (Cleanup Hub)", function()
    ScreenGui:Destroy()
end)
