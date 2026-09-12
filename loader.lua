-- Hrdora Hub (Full Professional Version with Real Functions & Fruit Spawner)
local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = workspace
local TweenService = game:GetService("TweenService")

local Window = Library:CreateWindow({
    Title = 'Hrdora Hub - Blox Fruits Full Edition',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Main = Window:AddTab('Auto Farm'),
    Combat = Window:AddTab('Combat'),
    Items = Window:AddTab('Fruits & Spawner'),
    Misc = Window:AddTab('Teleport & Misc')
}

-- 1. TAB AUTO FARM
local FarmGroup = Tabs.Main:AddLeftGroupbox('Farm Settings')
FarmGroup:AddToggle('AutoFarmLevel', {
    Text = 'Auto Farm Level (Quest & Mobs)',
    Default = false,
    Callback = function(Value)
        _G.AutoFarm = Value
        task.spawn(function()
            while _G.AutoFarm do
                pcall(function()
                    if not LocalPlayer.PlayerGui.Main.Quest.Visible then
                        ReplicatedStorage.Remotes.CommF_:InvokeServer("RequestQuest", "BanditQuest1", 1)
                    else
                        for _, e in pairs(Workspace.Enemies:GetChildren()) do
                            if e:FindFirstChild("HumanoidRootPart") and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                                repeat task.wait(0.1)
                                    LocalPlayer.Character.HumanoidRootPart.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 10, 3)
                                    local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                    if tool then tool:Activate() end
                                until not e.Parent or e.Humanoid.Health <= 0 or not _G.AutoFarm
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

FarmGroup:AddToggle('AutoChest', {
    Text = 'Auto Chest Farm (Nhặt rương)',
    Default = false,
    Callback = function(Value)
        _G.AutoChest = Value
        task.spawn(function()
            while _G.AutoChest do
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
    end
})

-- 2. TAB COMBAT
local CombatGroup = Tabs.Combat:AddLeftGroupbox('Combat & Attack')
CombatGroup:AddToggle('FastAttack', {
    Text = 'Ultra-Fast Attack (Đánh siêu tốc)',
    Default = false,
    Callback = function(Value)
        _G.FastAtk = Value
        task.spawn(function()
            while _G.FastAtk do
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
    end
})

CombatGroup:AddToggle('BringMobs', {
    Text = 'Bring Mobs (Kéo quái lại gần)',
    Default = false,
    Callback = function(Value)
        _G.BringMob = Value
        task.spawn(function()
            while _G.BringMob do
                pcall(function()
                    local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                    for _, v in pairs(Workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if (v.HumanoidRootPart.Position - myPos).Magnitude < 250 then
                                v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                                v.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                v.HumanoidRootPart.Transparency = 0.8
                                v.HumanoidRootPart.CanCollide = false
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end
})

-- 3. TAB FRUITS & SPAWNER
local ItemGroup = Tabs.Items:AddLeftGroupbox('Fruit & Inventory Tools')

ItemGroup:AddButton('Store All Inventory Fruits (Cất hết trái)', function()
    pcall(function()
        for _, v in pairs(LocalPlayer.Backpack:GetChildren()) do
            if v:IsA("Tool") and string.find(v.Name, "Fruit") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", v.Name)
            end
        end
    end)
end)

ItemGroup:AddButton('ESP Fruits (Nhìn thấy trái cây trên bản đồ)', function()
    for _, v in pairs(Workspace:GetChildren()) do
        if v:IsA("Tool") and v:FindFirstChild("Handle") then
            if not v.Handle:FindFirstChild("FruitESP") then
                local bill = Instance.new("BillboardGui", v.Handle)
                bill.Name = "FruitESP"
                bill.Size = UDim2.new(0, 100, 0, 40)
                bill.AlwaysOnTop = true
                local lbl = Instance.new("TextLabel", bill)
                lbl.Size = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Text = "🍎 " .. v.Name
                lbl.TextColor3 = Color3.fromRGB(255, 50, 50)
                lbl.TextSize = 14
                lbl.Font = Enum.Font.GothamBold
            end
        end
    end
end)

local SpawnerGroup = Tabs.Items:AddRightGroupbox('Call / Spawn Fruits to Eat')

SpawnerGroup:AddButton('Spawn & Eat: Buddha', function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Buddha-Buddha")
    end)
end)

SpawnerGroup:AddButton('Spawn & Eat: Portal', function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Portal-Portal")
    end)
end)

SpawnerGroup:AddButton('Spawn & Eat: Leopard', function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Leopard-Leopard")
    end)
end)

SpawnerGroup:AddButton('Spawn & Eat: Kitsune', function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Kitsune-Kitsune")
    end)
end)

SpawnerGroup:AddButton('Spawn & Eat: Flame', function()
    pcall(function()
        ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Flame-Flame")
    end)
end)

-- 4. TAB TELEPORT & MISC
local MiscGroup = Tabs.Misc:AddLeftGroupbox('Teleport Islands')
local function addTp(name, cf)
    MiscGroup:AddButton("TP: " .. name, function()
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                TweenService:Create(LocalPlayer.Character.HumanoidRootPart, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame = cf}):Play()
            end
        end)
    end)
end

addTp("Pirate Starter (Sea 1)", CFrame.new(1062, 16, 1373))
addTp("Cafe (Sea 2)", CFrame.new(-385, 73, 298))
addTp("Mansion (Sea 2)", CFrame.new(-288, 305, 5642))
addTp("Port Town (Sea 3)", CFrame.new(-290, 7, 5334))
addTp("Castle on Sea (Sea 3)", CFrame.new(-5083, 315, -3155))

Library:Notify('Hrdora Hub Full Version Loaded Successfully!')
