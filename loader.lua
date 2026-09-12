-- Hrdora Hub (White Minimalist Version)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = workspace

if CoreGui:FindFirstChild("HrdoraHubWhite") then
    CoreGui.HrdoraHubWhite:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HrdoraHubWhite"
ScreenGui.Parent = CoreGui

-- Nút thu mở menu nổi màu trắng
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 45, 0, 45)
ToggleBtn.Position = UDim2.new(0, 20, 0, 100)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
ToggleBtn.TextColor3 = Color3.fromRGB(20, 20, 20)
ToggleBtn.Text = "H"
ToggleBtn.TextSize = 20
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 8)

-- Khung chính màu trắng
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 280)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Tiêu đề
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundTransparency = 1
Title.Text = "Hrdora Hub [White Mode]"
Title.TextColor3 = Color3.fromRGB(30, 30, 30)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- Danh sách cuộn tính năng
local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -8, 1, -40)
Scroll.Position = UDim2.new(0, 4, 0, 38)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 3.5, 0)
Scroll.ScrollBarThickness = 3
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 5)
Layout.Parent = Scroll

local function addBtn(txt, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
    b.TextColor3 = Color3.fromRGB(40, 40, 40)
    b.Text = " " .. txt
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextSize = 12
    b.Font = Enum.Font.GothamSemibold
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function() pcall(cb) end)
end

local function addLbl(txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 22)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(0, 120, 255)
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.Parent = Scroll
end

-- Tích hợp toàn bộ tính năng
addLbl("-- [ 1. AUTO FARM ] --")
addBtn("Auto Farm Level (Quest)", function()
    _G.AF = not _G.AF
    task.spawn(function()
        while _G.AF do
            pcall(function()
                if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("RequestQuest", "BanditQuest1", 1)
                else
                    for _, e in pairs(Workspace.Enemies:GetChildren()) do
                        if e:FindFirstChild("HumanoidRootPart") and e.Humanoid.Health > 0 then
                            repeat task.wait(0.1)
                                LocalPlayer.Character.HumanoidRootPart.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 10, 3)
                                local t = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if t then t:Activate() end
                            until not e.Parent or e.Humanoid.Health <= 0 or not _G.AF
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

addBtn("Auto Chest Farm", function()
    _G.AC = not _G.AC
    task.spawn(function()
        while _G.AC do
            pcall(function()
                for _, o in pairs(Workspace:GetChildren()) do
                    if string.find(o.Name, "Chest") and o:IsA("Model") and o.PrimaryPart then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = o.PrimaryPart.CFrame
                        task.wait(0.2)
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

addLbl("-- [ 2. COMBAT ] --")
addBtn("Ultra-Fast Attack", function()
    _G.FA = not _G.FA
    task.spawn(function()
        while _G.FA do
            pcall(function()
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("Attack", v.HumanoidRootPart.Position)
                    end
                end
            end)
            task.wait(0.05)
        end
    end)
end)

addLbl("-- [ 3. FRUITS & SPAWNER ] --")
addBtn("Store All Inventory Fruits", function()
    pcall(function()
        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", v.Name)
            end
        end
    end)
end)

addBtn("Spawn & Eat: Buddha", function()
    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Buddha-Buddha") end)
end)

addBtn("Spawn & Eat: Portal", function()
    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Portal-Portal") end)
end)

addBtn("Spawn & Eat: Leopard", function()
    pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Leopard-Leopard") end)
end)

addLbl("-- [ 4. TELEPORT ] --")
addBtn("TP: Cafe (Sea 2)", function()
    pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-385, 73, 298) end)
end)

addBtn("TP: Castle on Sea (Sea 3)", function()
    pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5083, 315, -3155) end)
end)
