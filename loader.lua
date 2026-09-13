--[[
================================================================
  PROJECT: HrDora Hud - Blox Fruits Ultra Engine (Mobile Edition)
  COMBINED & OPTIMIZED BY: MrDon
  SUPPORT EXECUTORS: Delta, Codex, Hydrogen, Fluxus, Arceus X
================================================================
]]

-- ===================== [1] CONFIG =====================
local CFG = {
    -- Farm
    AutoFarm       = false,
    MobName        = "auto",    -- "auto" = theo level, hoặc chọn tên mob
    HoverHeight    = 12,
    AttackDistance = 15,
    MaxDistance    = 6000,
    LoopDelay      = 0.1,
    SkillKeys      = { "Z", "X", "C", "V", "F" },
    UseM1          = true,

    -- Auto extras
    AutoQuest      = false,
    AutoStats      = false,
    StatFocus      = "Melee",   -- Melee / Defense / Sword / Gun / DemonFruit
    AutoSeaBeast   = false,
    AutoBoss       = false,
    BossName       = "The Gorilla King",
    AutoChest      = false,
    AutoFruit      = false,     -- Tự nhặt trái ác quỷ
    FastAttack     = true,

    -- Fruit spin / Grab / Dealer
    AutoRollFruit  = false,     -- Tự mua trái ở Fruit Dealer (nếu đủ Beli/Cooldown)
    RollDelay      = 5.0,       -- Delay an toàn tránh spam kick
    AutoGrabFruit  = false,     -- Tự bay tới trái vừa rơi trong world và nhặt
    GotoDealer     = false,     -- Tự teleport tới Blox Fruit Dealer

    -- Movement
    Speed          = 16,
    JumpPower      = 50,
    InfiniteJump   = false,
    NoClip         = false,
    WalkOnWater    = false,

    -- ESP
    ESPPlayer      = false,
    ESPFruit       = false,
    ESPChest       = false,
    ESPBoss        = false,

    -- Misc
    AntiAfk        = true,
    Respawn        = true,
}

-- ===================== [2] MOB DATA TABLE =====================
local MOB_TABLE = {
    { 1,    9,    "Bandit"              },
    { 10,   14,   "Monkey"              },
    { 15,   29,   "Gorilla"             },
    { 30,   39,   "Pirate"              },
    { 40,   59,   "Brute"               },
    { 60,   74,   "Desert Bandit"       },
    { 75,   89,   "Desert Officer"      },
    { 90,   99,   "Snow Bandit"         },
    { 100,  119,  "Snowman"             },
    { 120,  149,  "Chief Petty Officer" },
    { 150,  174,  "Sky Bandit"          },
    { 175,  189,  "Dark Master"         },
    { 190,  209,  "Prisoner"            },
    { 210,  249,  "Dangerous Prisoner"  },
    { 250,  274,  "Toga Warrior"        },
    { 275,  299,  "Gladiator"           },
    { 300,  324,  "Military Soldier"    },
    { 325,  374,  "Military Spy"        },
    { 375,  399,  "Fishman Warrior"     },
    { 400,  449,  "Fishman Commando"    },
    { 450,  474,  "God's Guard"         },
    { 475,  524,  "Shanda"              },
    { 525,  574,  "Royal Squad"         },
    { 575,  624,  "Royal Soldier"       },
    { 625,  699,  "Galley Pirate"       },
    { 700,  724,  "Galley Captain"      },
    { 725,  774,  "Raider"              },
    { 775,  824,  "Mercenary"           },
    { 825,  874,  "Swan Pirate"         },
    { 875,  924,  "Factory Staff"       },
    { 925,  949,  "Marine Lieutenant"   },
    { 950,  974,  "Marine Captain"      },
    { 975,  999,  "Zombie"              },
    { 1000, 1049, "Vampire"             },
    { 1050, 1099, "Snow Trooper"        },
    { 1100, 1174, "Winter Warrior"      },
    { 1175, 1249, "Lab Subordinate"     },
    { 1250, 1299, "Horned Warrior"      },
    { 1300, 1349, "Magma Ninja"         },
    { 1350, 1424, "Lava Pirate"         },
    { 1425, 1499, "Ship Deckhand"       },
    { 1500, 1524, "Ship Engineer"       },
    { 1525, 1574, "Ship Steward"        },
    { 1575, 1624, "Ship Officer"        },
    { 1625, 1699, "Arctic Warrior"      },
    { 1700, 1774, "Snow Lurker"         },
    { 1775, 1824, "Sea Soldier"         },
    { 1825, 1899, "Water Fighter"       },
    { 1900, 1974, "Marine Commodore"    },
    { 1975, 2049, "Marine Rear Admiral" },
    { 2050, 2074, "Fishman Raider"      },
    { 2075, 2124, "Fishman Captain"     },
    { 2125, 2174, "Forest Pirate"       },
    { 2175, 2224, "Mythological Pirate" },
    { 2225, 2249, "Jungle Pirate"       },
    { 2250, 2299, "Musketeer Pirate"    },
    { 2300, 2324, "Reborn Skeleton"     },
    { 2325, 2374, "Living Zombie"       },
    { 2375, 2424, "Demonic Soul"        },
    { 2425, 2449, "Posessed Mummy"      },
    { 2450, 2474, "Wandering Mummy"     },
    { 2475, math.huge, "Peanut Scout"   },
}

-- ===================== [3] SERVICES + STATE =====================
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UserInputService  = game:GetService("UserInputService")
local VIM               = game:GetService("VirtualInputManager")
local Workspace         = game:GetService("Workspace")
local StarterGui        = game:GetService("StarterGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LP        = Players.LocalPlayer
local Char      = LP.Character or LP.CharacterAdded:Wait()
local Hum       = Char:WaitForChild("Humanoid")
local HRP       = Char:WaitForChild("HumanoidRootPart")

local skillIndex = 1
local espCache   = {}

LP.CharacterAdded:Connect(function(c)
    Char = c
    Hum  = c:WaitForChild("Humanoid")
    HRP  = c:WaitForChild("HumanoidRootPart")
end)

pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "HrDora Ultra Engine",
        Text  = "Đã nạp Script Siêu Phẩm thành công!",
        Duration = 5,
    })
end)

-- ===================== [4] UTILS =====================
local function dist(a, b) return (a - b).Magnitude end

local function getLevel()
    local s = LP:FindFirstChild("leaderstats")
    if s and s:FindFirstChild("Level") then return s.Level.Value end
    return 1
end

local function pickMobByLevel()
    local lvl = getLevel()
    for _, r in ipairs(MOB_TABLE) do
        if lvl >= r[1] and lvl <= r[2] then return r[3] end
    end
    return "Bandit"
end

local function findNearest(name, container)
    if not HRP then return nil end
    container = container or Workspace:FindFirstChild("Enemies")
    if not container then return nil end
    local best, bestD = nil, math.huge
    for _, obj in ipairs(container:GetChildren()) do
        if obj.Name == name then
            local h = obj:FindFirstChildOfClass("Humanoid")
            local r = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Torso")
            if h and h.Health > 0 and r then
                local d = dist(HRP.Position, r.Position)
                if d < bestD and d <= CFG.MaxDistance then
                    bestD = d; best = obj
                end
            end
        end
    end
    return best
end

local function tp(cf)
    if HRP and typeof(cf) == "CFrame" then pcall(function() HRP.CFrame = cf end) end
end

local function clickM1()
    VIM:SendMouseButtonEvent(0, 0, 0, true,  game, 0)
    task.wait(0.02)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

local function pressKey(k)
    VIM:SendKeyEvent(true,  k, false, game)
    task.wait(0.03)
    VIM:SendKeyEvent(false, k, false, game)
end

local function nextSkill()
    local k = CFG.SkillKeys[skillIndex]
    skillIndex = (skillIndex % #CFG.SkillKeys) + 1
    return k
end

local function clearESPByTag(tag)
    for m, hl in pairs(espCache) do
        if hl and hl:GetAttribute("tag") == tag then
            hl:Destroy(); espCache[m] = nil
        end
    end
end

-- ===================== [5] CORE FEATURES =====================

-- (a) Anti-AFK
if CFG.AntiAfk then
    LP.Idled:Connect(function()
        VIM:SendKeyEvent(true, "Space", false, game); task.wait(0.1)
        VIM:SendKeyEvent(false,"Space", false, game)
    end)
end

-- (b) Auto Farm Mob
task.spawn(function()
    while task.wait(CFG.LoopDelay) do
        if not CFG.AutoFarm or not Char or not HRP or not Hum or Hum.Health <= 0 then continue end
        
        local name = (CFG.MobName == "auto") and pickMobByLevel() or CFG.MobName
        local mob  = findNearest(name)
        if mob then
            local r = mob:FindFirstChild("HumanoidRootPart")
            if r then
                local targetCF = r.CFrame * CFrame.new(0, CFG.HoverHeight, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                tp(targetCF)
                
                if CFG.UseM1 then clickM1() end
                if CFG.FastAttack then clickM1() end
                pressKey(nextSkill())
            end
        end
    end
end)

-- (c) Auto Quest
task.spawn(function()
    while task.wait(2) do
        if not CFG.AutoQuest or not HRP then continue end
        pcall(function()
            local commF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if commF then
                local mobName = pickMobByLevel()
                commF:InvokeServer("StartQuest", mobName .. "Quest", 1)
            end
        end)
    end
end)

-- (d) Auto Stats
task.spawn(function()
    while task.wait(3) do
        if not CFG.AutoStats then continue end
        pcall(function()
            local commF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if commF then
                commF:InvokeServer("AddPoint", CFG.StatFocus, 3)
            end
        end)
    end
end)

-- (e) Auto Sea Beast
task.spawn(function()
    while task.wait(CFG.LoopDelay) do
        if not CFG.AutoSeaBeast or not HRP then continue end
        local sb = findNearest("SeaBeast1", Workspace) or findNearest("SeaBeast2", Workspace) or findNearest("Sea Beast", Workspace)
        if sb then
            local r = sb:FindFirstChild("HumanoidRootPart")
            if r then
                tp(r.CFrame * CFrame.new(0, CFG.HoverHeight, 0))
                if CFG.UseM1 then clickM1() end
                pressKey(nextSkill())
            end
        end
    end
end)

-- (f) Auto Boss
task.spawn(function()
    while task.wait(CFG.LoopDelay) do
        if not CFG.AutoBoss or not HRP then continue end
        local b = findNearest(CFG.BossName)
        if b then
            local r = b:FindFirstChild("HumanoidRootPart")
            if r then
                tp(r.CFrame * CFrame.new(0, CFG.HoverHeight, 0))
                if CFG.UseM1 then clickM1() end
                pressKey(nextSkill())
            end
        end
    end
end)

-- (g) Auto Chest
task.spawn(function()
    while task.wait(1) do
        if not CFG.AutoChest or not HRP then continue end
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj.Name:match("^Chest") then
                local pos = obj:IsA("BasePart") and obj.Position or obj:GetPivot().Position
                if dist(HRP.Position, pos) < 5000 then
                    tp(CFrame.new(pos + Vector3.new(0, 3, 0)))
                    task.wait(0.15)
                end
            end
        end
    end
end)

-- (h) Auto Grab Fruit (Bay nhặt trái)
task.spawn(function()
    while task.wait(1) do
        if not CFG.AutoFruit and not CFG.AutoGrabFruit then continue end
        if not HRP then continue end
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Tool") and (obj.Name:find("Fruit") or obj.Name:find("-Fruit")) then
                local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("BasePart")
                if handle then
                    local saved = HRP.CFrame
                    tp(CFrame.new(handle.Position))
                    task.wait(0.4)
                    tp(saved)
                    break
                end
            end
        end
    end
end)

-- (i) Auto Roll Fruit Safe
task.spawn(function()
    while task.wait(CFG.RollDelay) do
        if not CFG.AutoRollFruit then continue end
        pcall(function()
            local commF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("CommF_")
            if commF then
                commF:InvokeServer("Cousin", "Buy")
            end
        end)
    end
end)

-- (j) Teleport Dealer
local DEALER_POS = {
    Vector3.new(1373, 5, 4),      -- Sea 1
    Vector3.new(-1105, 5, 3855),  -- Sea 2
    Vector3.new(-1180, 30, 6390), -- Sea 3
}
task.spawn(function()
    while task.wait(2) do
        if not CFG.GotoDealer or not HRP then continue end
        local best, bestD = DEALER_POS[1], math.huge
        for _, p in ipairs(DEALER_POS) do
            local d = (HRP.Position - p).Magnitude
            if d < bestD then bestD = d; best = p end
        end
        tp(CFrame.new(best + Vector3.new(0, 2, 0)))
    end
end)

-- Movement Loops
RunService.Heartbeat:Connect(function()
    if Hum and Hum.Parent then
        Hum.WalkSpeed = CFG.Speed
        Hum.JumpPower = CFG.JumpPower
    end
    if CFG.NoClip and Char then
        for _, p in ipairs(Char:GetDescendants()) do
            if p:IsA("BasePart") then p.CanCollide = false end
        end
    end
    if CFG.WalkOnWater and HRP and HRP.Position.Y < 3 and Hum.MoveDirection.Magnitude > 0 then
        HRP.CFrame = CFrame.new(HRP.Position.X, 5, HRP.Position.Z)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if CFG.InfiniteJump and Hum then Hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

-- ESP Loops
task.spawn(function()
    while task.wait(1.5) do
        if CFG.ESPPlayer then
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character and not espCache[pl.Character] then
                    local h = Instance.new("Highlight")
                    h.Adornee = pl.Character; h.FillColor = Color3.fromRGB(0, 170, 255)
                    h.Parent = pl.Character; h:SetAttribute("tag", "player")
                    espCache[pl.Character] = h
                end
            end
        else clearESPByTag("player") end

        if CFG.ESPFruit then
            for _, f in ipairs(Workspace:GetChildren()) do
                if f.Name:find("Fruit") and not espCache[f] then
                    local h = Instance.new("Highlight")
                    h.Adornee = f; h.FillColor = Color3.fromRGB(255, 200, 0)
                    h.Parent = f; h:SetAttribute("tag", "fruit")
                    espCache[f] = h
                end
            end
        else clearESPByTag("fruit") end

        if CFG.ESPChest then
            for _, c in ipairs(Workspace:GetChildren()) do
                if c.Name:match("^Chest") and not espCache[c] then
                    local h = Instance.new("Highlight")
                    h.Adornee = c; h.FillColor = Color3.fromRGB(160, 90, 255)
                    h.Parent = c; h:SetAttribute("tag", "chest")
                    espCache[c] = h
                end
            end
        else clearESPByTag("chest") end
    end
end)

-- ===================== [6] ADVANCED MOBILE GUI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "HrDora_UltraHub"
ScreenGui.IgnoreGuiInset = true
ScreenGui.ResetOnSpawn   = false
ScreenGui.Parent         = LP:WaitForChild("PlayerGui")

-- Nút Tròn Toggle
local Toggle = Instance.new("TextButton")
Toggle.Size            = UDim2.new(0, 48, 0, 48)
Toggle.Position        = UDim2.new(0, 8, 0, 120)
Toggle.BackgroundColor3 = Color3.fromRGB(110, 68, 255)
Toggle.Text            = "HrDora"
Toggle.TextColor3      = Color3.new(1,1,1)
Toggle.TextScaled      = true
Toggle.Font            = Enum.Font.GothamBold
Toggle.BorderSizePixel = 0
Toggle.Parent          = ScreenGui
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(1,0)

-- Drag Logic Toggle Button
do
    local dragging, dragStart, startPos
    Toggle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Toggle.Position
        end
    end)
    Toggle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = input.Position - dragStart
            Toggle.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- Main Panel
local Panel = Instance.new("Frame")
Panel.Size             = UDim2.new(0, 320, 0, 380)
Panel.Position         = UDim2.new(0, 70, 0, 90)
Panel.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Panel.BorderSizePixel  = 0
Panel.Visible          = false
Panel.Parent           = ScreenGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke", Panel)
Stroke.Color     = Color3.fromRGB(110, 68, 255)
Stroke.Thickness = 1.5

-- Header
local Header = Instance.new("TextLabel", Panel)
Header.Size              = UDim2.new(1, 0, 0, 32)
Header.BackgroundColor3  = Color3.fromRGB(110, 68, 255)
Header.Text              = "HRDORA ULTRA ENGINE"
Header.TextColor3        = Color3.new(1,1,1)
Header.Font              = Enum.Font.GothamBold
Header.TextScaled        = true
Header.BorderSizePixel   = 0
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 10)

-- Drag Logic Main Panel
do
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Panel.Position
        end
    end)
    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local d = input.Position - dragStart
            Panel.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- Tab Bar
local TabBar = Instance.new("Frame", Panel)
TabBar.Size             = UDim2.new(1, -10, 0, 34)
TabBar.Position         = UDim2.new(0, 5, 0, 38)
TabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
TabBar.BorderSizePixel  = 0
Instance.new("UICorner", TabBar).CornerRadius = UDim.new(0, 6)

local Content = Instance.new("Frame", Panel)
Content.Size             = UDim2.new(1, -10, 1, -80)
Content.Position         = UDim2.new(0, 5, 0, 76)
Content.BackgroundTransparency = 1

local pages   = {}
local tabBtns = {}

local function makePage(name)
    local sf = Instance.new("ScrollingFrame")
    sf.Name                    = name
    sf.Size                    = UDim2.new(1, 0, 1, 0)
    sf.BackgroundTransparency  = 1
    sf.BorderSizePixel         = 0
    sf.ScrollBarThickness      = 4
    sf.CanvasSize              = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize     = Enum.AutomaticSize.Y
    sf.Visible                 = false
    sf.Parent                  = Content
    local list = Instance.new("UIListLayout", sf)
    list.Padding               = UDim.new(0, 6)
    list.SortOrder             = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", sf)
    pad.PaddingTop  = UDim.new(0, 4)
    pad.PaddingLeft = UDim.new(0, 4)
    pages[name] = sf
    return sf
end

local function makeTab(name)
    local b = Instance.new("TextButton", TabBar)
    b.Size             = UDim2.new(0, 72, 1, -4)
    b.Position         = UDim2.new(0, 4 + (#tabBtns * 76), 0, 2)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    b.Text             = name
    b.TextColor3       = Col
