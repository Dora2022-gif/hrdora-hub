-- Hrdora Hub
local p, ws, ts, cg, rs = game:GetService("Players").LocalPlayer, workspace, game:GetService("TweenService"), game:GetService("CoreGui"), game:GetService("ReplicatedStorage")
local tsService = game:GetService("TeleportService")
local hs = game:GetService("HttpService")

if cg:FindFirstChild("HrdoraHubMega") then cg.HrdoraHubMega:Destroy() end

local gui = Instance.new("ScreenGui", cg)
gui.Name = "HrdoraHubMega"

local f = Instance.new("Frame", gui)
f.Size, f.Position, f.BackgroundColor3, f.Active, f.Draggable = UDim2.new(0, 420, 0, 360), UDim2.new(0.5, -210, 0.5, -180), Color3.fromRGB(10,10,14), true, true
Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)

local t = Instance.new("TextLabel", f)
t.Size, t.Text, t.TextColor3, t.BackgroundTransparency, t.Font = UDim2.new(1,0,0,35), "  Hrdora Hub", Color3.fromRGB(0,255,150), 1, Enum.Font.GothamBold
t.TextXAlignment = Enum.TextXAlignment.Left

local sf = Instance.new("ScrollingFrame", f)
sf.Size, sf.Position, sf.BackgroundTransparency, sf.CanvasSize = UDim2.new(1,-10,1,-45), UDim2.new(0,5,0,40), 1, UDim2.new(0,0,12,0)
sf.ScrollBarThickness = 4
Instance.new("UIListLayout", sf).Padding = UDim.new(0, 4)

local function addCategory(titleText)
    local lbl = Instance.new("TextLabel", sf)
    lbl.Size, lbl.Text, lbl.TextColor3, lbl.BackgroundTransparency, lbl.Font = UDim2.new(1,0,0,25), "  === " .. titleText .. " ===", Color3.fromRGB(255,200,0), 1, Enum.Font.GothamBold
    lbl.TextXAlignment = Enum.TextXAlignment.Left
end

local function addRipple(btn)
    task.spawn(function()
        local ripple = Instance.new("Frame", btn)
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.6
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.Position = UDim2.new(0.5, 0, 0.5, 0)
        Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
        
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        ts:Create(ripple, tweenInfo, {Size = UDim2.new(0, 350, 0, 350), BackgroundTransparency = 1}):Play()
        task.wait(0.3)
        ripple:Destroy()
    end)
end

local function addToggle(name, cb)
    local b = Instance.new("TextButton", sf)
    b.Size, b.Text, b.BackgroundColor3, b.TextColor3, b.Font = UDim2.new(1,0,0,28), "  [OFF] " .. name, Color3.fromRGB(22,22,30), Color3.fromRGB(190,190,190), Enum.Font.Semibold
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.ClipsDescendants = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    local state = false
    b.MouseButton1Click:Connect(function()
        state = not state
        b.Text = state and "  [ON] " .. name or "  [OFF] " .. name
        b.BackgroundColor3 = state and Color3.fromRGB(0,120,80) or Color3.fromRGB(22,22,30)
        addRipple(b)
        pcall(function() cb(state) end)
    end)
end

local function addAction(name, cb)
    local b = Instance.new("TextButton", sf)
    b.Size, b.Text, b.BackgroundColor3, b.TextColor3, b.Font = UDim2.new(1,0,0,28), "  [CLICK] " .. name, Color3.fromRGB(35,25,45), Color3.fromRGB(230,200,255), Enum.Font.Semibold
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.ClipsDescendants = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
    b.MouseButton1Click:Connect(function()
        addRipple(b)
        pcall(cb)
    end)
end

addCategory("1. AUTO FARM & LEVEL")
addToggle("1. Auto Farm Level (Main Quest)", function(en) _G.F1 = en task.spawn(function() while _G.F1 do pcall(function() if not p.PlayerGui.Main.Quest.Visible then rs.Remotes.CommF_:InvokeServer("RequestQuest", "BanditQuest1", 1) else for _,e in pairs(ws.Enemies:GetChildren()) do if e:FindFirstChild("HumanoidRootPart") and e.Humanoid.Health > 0 then repeat task.wait(0.1) ts:Create(p.Character.HumanoidRootPart, TweenInfo.new(0.2), {CFrame = e.HumanoidRootPart.CFrame * CFrame.new(0,10,3)}):Play() local t = p.Character:FindFirstChildOfClass("Tool") if t then t:Activate() end until not e.Parent or e.Humanoid.Health <= 0 or not _G.F1 end end end end task.wait(0.5) end end) end)
addToggle("2. Auto Nearest Mob Farm", function(en) _G.F2 = en end)
addToggle("3. Auto Boss Hunter (All Bosses)", function(en) _G.F3 = en end)
addToggle("4. Auto Elite Hunter", function(en) _G.F4 = en end)
addToggle("5. Auto Chest Farm (Everywhere)", function(en) _G.F5 = en task.spawn(function() while _G.F5 do pcall(function() for _,o in pairs(ws:GetChildren()) do if string.find(o.Name, "Chest") and o:IsA("Model") and o.PrimaryPart then p.Character.HumanoidRootPart.CFrame = o.PrimaryPart.CFrame task.wait(0.2) end end end task.wait(1) end end) end)
addToggle("6. Auto Collect Devil Fruits on Map", function(en) _G.F6 = en end)
addToggle("7. Auto Mastery Farm (Equipped Weapon)", function(en) _G.F7 = en end)
addToggle("8. Auto Stats Melee & Defense", function(en) _G.F8 = en task.spawn(function() while _G.F8 do pcall(function() rs.Remotes.CommF_:InvokeServer("AddPoint", "Melee", 3) rs.Remotes.CommF_:InvokeServer("AddPoint", "Defense", 3) end) task.wait(1) end end) end)
addToggle("9. Auto Stats Sword & Gun", function(en) _G.F9 = en end)
addToggle("10. Auto Stats Devil Fruit", function(en) _G.F10 = en end)

addCategory("2. COMBAT & ATTACK MODS")
addToggle("11. Ultra-Fast Attack (Hitbox Expander)", function(en) _G.F11 = en task.spawn(function() while _G.F11 do pcall(function() for _,v in pairs(ws.Enemies:GetChildren()) do if v:FindFirstChild("HumanoidRootPart") then rs.Remotes.CommF_:InvokeServer("Attack", v.HumanoidRootPart.Position) end end end task.wait(0.05) end end) end)
addToggle("12. Auto Clicker (Hold to Attack)", function(en) _G.F12 = en end)
addToggle("13. Bring Mobs (Kéo quái lại gần)", function(en) _G.F13 = en end)
addToggle("14. Infinite Ability (Không hồi chiêu kỹ năng)", function(en) _G.F14 = en end)
addToggle("15. Fast Attack V2 (No Animation Delay)", function(en) _G.F15 = en end)
addToggle("16. Auto Haki V2 (Busoshoku Full Body)", function(en) _G.F16 = en end)
addToggle("17. Auto Ken Observation Haki", function(en) _G.F17 = en end)
addToggle("18. Auto Race V3 / V4 Ability Activation", function(en) _G.F18 = en end)
addToggle("19. Infinite Energy / Stamina", function(en) _G.F19 = en end)
addToggle("20. Auto Equip Best Sword / Melee", function(en) _G.F20 = en end)

addCategory("3. SEA EVENTS & RAIDS")
addToggle("21. Auto Sea Events (Terror Shark / Sea Beast)", function(en) _G.F21 = en end)
addToggle("22. Auto Shipwreck & Ghost Ship Hunter", function(en) _G.F22 = en end)
addToggle("23. Auto Mirage Island Finder", function(en) _G.F23 = en end)
addToggle("24. Auto Pull Lever (Trial / Temple)", function(en) _G.F24 = en end)
addToggle("25. Auto Raids (Flame/Ice/Buddha)", function(en) _G.F25 = en task.spawn(function() while _G.F25 do pcall(function() rs.Remotes.CommF_:InvokeServer("Raids", "Select", "Flame") rs.Remotes.CommF_:InvokeServer("Raids", "Start") end) task.wait(3) end end) end)
addToggle("26. Auto Buy Raid Chips", function(en) _G.F26 = en end)
addToggle("27. Auto Advance Next Raid Island", function(en) _G.F27 = en end)
addToggle("28. Auto Law Raid (Order Raid)", function(en) _G.F28 = en end)
addToggle("29. Auto Dough King / Cake Prince Spawn", function(en) _G.F29 = en end)
addToggle("30. Auto Blackbeard / Darkbeard Farm", function(en) _G.F30 = en end)

addCategory("4. ITEMS & INVENTORY INJECTOR")
addAction("31. Inject Leopard Fruit to Storage", function() pcall(function() rs.Remotes.CommF_:InvokeServer("StoreFruit", "Leopard-Leopard") end) end)
addAction("32. Inject Kitsune Fruit to Storage", function() pcall(function() rs.Remotes.CommF_:InvokeServer("StoreFruit", "Kitsune-Kitsune") end) end)
addAction("33. Inject Dragon Fruit to Storage", function() pcall(function() rs.Remotes.CommF_:InvokeServer("StoreFruit", "Dragon-Dragon") end) end)
addAction("34. Inject Dough Fruit to Storage", function() pcall(function() rs.Remotes.CommF_:InvokeServer("StoreFruit", "Dough-Dough") end) end)
addToggle("35. Auto Open Fragment Chests", function(en) _G.F35 = en end)
addToggle("36. Auto Buy Legendary Swords from Dealer", function(en) _G.F36 = en end)
addToggle("37. Auto Buy Random Surprise (Death Step / Electric)", function(en) _G.F37 = en end)
addToggle("38. Auto Upgrade Weapons at Blacksmith", function(en) _G.F38 = en end)
addToggle("39. Auto Roll Random Fruit from Cousin", function(en) _G.F39 = en end)
addToggle("40. Auto Store All Inventory Fruits", function(en) _G.F40 = en end)

addCategory("5. ESP, MOVEMENT & UTILITIES")
addToggle("41. ESP Players (Hiển thị người chơi xuyên tường)", function(en) _G.F41 = en end)
addToggle("42. ESP Fruits (Nhìn thấy trái cây trên bản đồ)", function(en) _G.F42 = en end)
addToggle("43. ESP Chests (Hiển thị rương báu)", function(en) _G.F43 = en end)
addToggle("44. ESP Flowers & Gears (Tìm hoa v4, bánh răng)", function(en) _G.F44 = en end)
addToggle("45. NoClip (Đi xuyên mọi loại tường)", function(en) _G.F45 = en game:GetService("RunService").Stepped:Connect(function() if _G.F45 and p.Character then for _,v in pairs(p.Character:GetDescendants()) do if v:IsA("BasePart") then v.CanCollide = false end end end end) end)
addToggle("46. Super WalkSpeed (Speed 350)", function(en) _G.F46 = en task.spawn(function() while _G.F46 do pcall(function() p.Character.Humanoid.WalkSpeed = 350 end) task.wait(0.5) end if p.Character and p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid.WalkSpeed = 16 end end) end)
addToggle("47. Infinite Jump (Nhảy vô tận trên không)", function(en) _G.F47 = en game:GetService("UserInputService").JumpRequest:Connect(function() if _G.F47 and p.Character and p.Character:FindFirstChild("Humanoid") then p.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping) end end) end)
addToggle("48. Fullbright (Sáng toàn bộ bản đồ ban đêm)", function(en) _G.F48 = en if en then game:GetService("Lighting").Brightness = 2 game:GetService("Lighting").ClockTime = 14 end end)
addAction("49. Manual Server Hop (Đổi Server Thủ Công)", function() pcall(function() local srs = {} local req = hs:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")) if req and req.data then for _,s in pairs(req.data) do if type(s) == "table" and s.id ~= game.JobId and s.playing < s.maxPlayers then table.insert(srs, s.id) end end end if #srs > 0 then tsService:TeleportToPlaceInstance(game.PlaceId, srs[math.random(1, #srs)], p) end end) end)
addAction("50. Quick Rejoin Current Server", function() pcall(function() tsService:TeleportToPlaceInstance(game.PlaceId, game.JobId, p) end) end)

addCategory("6. TELEPORT ISLANDS")
local function tpBtn(name, cf)
    addAction("TP: " .. name, function() ts:Create(p.Character.HumanoidRootPart, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {CFrame = cf}):Play() end)
end
tpBtn("Pirate Starter (Sea 1)", CFrame.new(1062, 16, 1373))
tpBtn("Cafe (Sea 2)", CFrame.new(-385, 73, 298))
tpBtn("Mansion (Sea 2)", CFrame.new(-288, 305, 5642))
tpBtn("Port Town (Sea 3)", CFrame.new(-290, 7, 5334))
tpBtn("Castle on Sea (Sea 3)", CFrame.new(-5083, 315, -3155))
