-- Hrdora Hub Pro - Ultimate Teleport & Farm Edition
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = workspace
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("HrdoraHubUltimate") then
    CoreGui.HrdoraHubUltimate:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "HrdoraHubUltimate"
ScreenGui.Parent = CoreGui

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 50, 0, 50)
ToggleBtn.Position = UDim2.new(0, 20, 0, 120)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
ToggleBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
ToggleBtn.Text = "H"
ToggleBtn.TextSize = 24
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Draggable = true
ToggleBtn.Parent = ScreenGui
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 14)

local ToggleStroke = Instance.new("UIStroke", ToggleBtn)
ToggleStroke.Thickness = 2.5
ToggleStroke.Color = Color3.fromRGB(138, 43, 225)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 360, 0, 390)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -195)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Thickness = 2.5
MainStroke.Color = Color3.fromRGB(0, 229, 255)

ToggleBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "Hrdora Hub [Bản Dịch Chuyển & Cày Cục]"
Title.TextColor3 = Color3.fromRGB(0, 229, 255)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -12, 1, -50)
Scroll.Position = UDim2.new(0, 6, 0, 45)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 9.5, 0)
Scroll.ScrollBarThickness = 3
Scroll.Parent = MainFrame

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0, 6)
Layout.Parent = Scroll

local function addBtn(txt, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 45)
    b.TextColor3 = Color3.fromRGB(240, 240, 240)
    b.Text = "  " .. txt
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.TextSize = 12
    b.Font = Enum.Font.GothamSemibold
    b.Parent = Scroll
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    local stroke = Instance.new("UIStroke", b)
    stroke.Color = Color3.fromRGB(90, 90, 150)
    stroke.Transparency = 0.4

    b.MouseButton1Click:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(0, 229, 255), TextColor3 = Color3.fromRGB(15, 15, 25)}):Play()
        task.wait(0.12)
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3 = Color3.fromRGB(25, 25, 45), TextColor3 = Color3.fromRGB(240, 240, 240)}):Play()
        pcall(cb)
    end)
end

local function addLbl(txt)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 28)
    l.BackgroundTransparency = 1
    l.Text = " " .. txt
    l.TextColor3 = Color3.fromRGB(255, 170, 0)
    l.TextSize = 12
    l.Font = Enum.Font.GothamBold
    l.Parent = Scroll
end

addLbl("--- 1. TỰ ĐỘNG CÀY CUỐC & NHẶT ĐỒ ---")
addBtn("Bật/Tắt: Tự Động Cày Cấp (Farm Quest)", function()
    _G.AF = not _G.AF
    task.spawn(function()
        while _G.AF do
            pcall(function()
                local questGui = LocalPlayer.PlayerGui.Main.Quest
                if not questGui.Visible then
                    ReplicatedStorage.Remotes.CommF_:InvokeServer("RequestQuest", "BanditQuest1", 1)
                else
                    for _, e in pairs(Workspace.Enemies:GetChildren()) do
                        if e:FindFirstChild("HumanoidRootPart") and e:FindFirstChild("Humanoid") and e.Humanoid.Health > 0 then
                            repeat task.wait(0.1)
                                LocalPlayer.Character.HumanoidRootPart.CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0, 10, 3)
                                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                                if tool then tool:Activate() end
                            until not e.Parent or e.Humanoid.Health <= 0 or not _G.AF
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
end)

addBtn("Bật/Tắt: Tự Động Nhặt Rương (Auto Chest)", function()
    _G.AC = not _G.AC
    task.spawn(function()
        while _G.AC do
            pcall(function()
                for _, chest in pairs(Workspace:GetChildren()) do
                    if string.find(chest.Name, "Chest") and chest:IsA("Model") and chest.PrimaryPart then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = chest.PrimaryPart.CFrame
                        task.wait(0.2)
                    end
                end
            end)
            task.wait(1)
        end
    end)
end)

addLbl("--- 2. HỖ TRỢ CHIẾN ĐẤU ---")
addBtn("Bật/Tắt: Đánh Siêu Tốc (Fast Attack)", function()
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
            task.wait(0.04)
        end
    end)
end)

addBtn("Bật/Tắt: Kéo Quái Lại Gần (Bring Mobs)", function()
    _G.BM = not _G.BM
    task.spawn(function()
        while _G.BM do
            pcall(function()
                local myPos = LocalPlayer.Character.HumanoidRootPart.Position
                for _, v in pairs(Workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - myPos).Magnitude < 350 then
                            v.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                            v.HumanoidRootPart.CanCollide = false
                        end
                    end
                end
            end)
            task.wait(0.3)
        end
    end)
end)

addLbl("--- 3. HỆ THỐNG VÒNG QUAY & KHO ---")
addBtn("Bật/Tắt: Quay Tự Động Không Bao Giờ Tắt (Spam Spin)", function()
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

addBtn("Cất Hết Toàn Bộ Trái Trong Túi Vào Kho", function()
    pcall(function()
        for _, item in pairs(LocalPlayer.Backpack:GetChildren()) do
            if item:IsA("Tool") and string.find(item.Name, "Fruit") then
                ReplicatedStorage.Remotes.CommF_:InvokeServer("StoreFruit", item.Name)
            end
        end
    end)
end)

addLbl("--- 4. GỌI TRỰC TIẾP TRÁI ÁC QUỶ VIP ---")
addBtn("Gọi & Kích Hoạt: Kitsune", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Kitsune-Kitsune") end) end)
addBtn("Gọi & Kích Hoạt: Leopard (Báo)", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Leopard-Leopard") end) end)
addBtn("Gọi & Kích Hoạt: Dragon (Rồng)", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Dragon-Dragon") end) end)
addBtn("Gọi & Kích Hoạt: Spirit (Hồn Ma)", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Spirit-Spirit") end) end)
addBtn("Gọi & Kích Hoạt: Dough (Bột Mì)", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Dough-Dough") end) end)
addBtn("Gọi & Kích Hoạt: Buddha (Phật Tổ)", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Buddha-Buddha") end) end)
addBtn("Gọi & Kích Hoạt: Portal (Cổng Không Gian)", function() pcall(function() ReplicatedStorage.Remotes.CommF_:InvokeServer("LoadFruit", "Portal-Portal") end) end)

addLbl("--- 5. DỊCH CHUYỂN TOÀN BỘ ĐẢO & NPC ---")
addBtn("Dịch Chuyển Đến: Quán Cafe (Sea 2)", function()
    pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-385, 73, 298) end)
end)

addBtn("Dịch Chuyển Đến: Lâu Đài Trên Biển (Sea 3)", function()
    pcall(function() LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-5083, 315, -3155) end)
end)

addBtn("Dịch Chuyển Đến Đảo Bí Ẩn (Mirage Island)", function()
    pcall(function()
        for _, v in pairs(Workspace:GetChildren()) do
            if string.find(v.Name, "Mirage") and v:FindFirstChild("PrimaryPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame + Vector3.new(0, 50, 0)
                break
            end
        end
    end)
end)

addBtn("Dịch Chuyển Đến Sự Kiện Biển (Sea Events)", function()
    pcall(function()
        for _, v in pairs(Workspace.SeaEvents:GetChildren()) do
            if v:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                break
            end
        end
    end)
end)

addBtn("Dịch Chuyển Đến Người Chơi Gần Nhất", function()
    pcall(function()
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 10, 3)
                break
            end
        end
    end)
end)
