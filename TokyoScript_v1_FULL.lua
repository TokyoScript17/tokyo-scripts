-- Tokyo Script V1.0 - All in One
-- Key System + Main Script

-- =====================
-- VALID KEYS
-- =====================
local VALID_KEYS = {
    "TOKYO-FAGF-Y1YI",
    "TOKYO-BTWY-9FSS",
    "TOKYO-UG47-QJE6",
    "TOKYO-IPWG-NOLF",
    "TOKYO-4TUW-ZI5P",
    "TOKYO-LY70-BXHA",
    "TOKYO-8MEG-8EML",
    "TOKYO-3FLD-NNM5",
    "TOKYO-QHWB-E49F",
    "TOKYO-L2DC-6SZF",
    "TOKYO-Y0H0-Y5ZG",
    "TOKYO-KEND-6Q9C",
    "TOKYO-MMTO-8O7D",
    "TOKYO-IR4G-4C5A",
    "TOKYO-PGD7-U485",
    "TOKYO-ACV1-FXB1",
    "TOKYO-3JLX-IDCH",
    "TOKYO-NRRR-7PNX",
    "TOKYO-AQPC-JPP3",
    "TOKYO-XU0H-89MB",
    "TOKYO-2EAS-AD1M",
    "TOKYO-PWGH-Y3JO",
    "TOKYO-2KDW-BLG2",
    "TOKYO-67GV-SQYV",
    "TOKYO-QLFZ-RAO6",
    "TOKYO-QC3Q-WZ42",
    "TOKYO-WFCY-LUDP",
    "TOKYO-D4P0-E68O",
    "TOKYO-QFUC-NF3L",
    "TOKYO-TJ0A-DCZ3",
    "TOKYO-BT8R-XPFA",
    "TOKYO-DFG6-80W9",
    "TOKYO-H2F2-ZIK5",
    "TOKYO-571U-1FTR",
    "TOKYO-573W-DEIR",
    "TOKYO-VHD4-T03G",
    "TOKYO-6BGD-0G76",
    "TOKYO-Y72C-TWQE",
    "TOKYO-MWVS-F65P",
    "TOKYO-NTXS-54AQ",
    "TOKYO-X4MS-9P7S",
    "TOKYO-E0AQ-1X53",
    "TOKYO-EYOB-4JYM",
    "TOKYO-DXGL-VGGC",
    "TOKYO-PXZV-PNC4",
    "TOKYO-V336-7Q4M",
    "TOKYO-KERY-WHJH",
    "TOKYO-ZXJ2-B1WG",
    "TOKYO-6MK8-PBZK",
    "TOKYO-E7CQ-FZO0",
}
local DISCORD_INVITE = "https://discord.gg/TUOCODICE"
local STORAGE_KEY = "TokyoScript_Key_v1"

-- =====================
-- SERVICES
-- =====================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local VirtualUser       = game:GetService("VirtualUser")

local LP       = Players.LocalPlayer
local USERNAME = LP.Name

local function GetChar() return LP.Character end
local function GetRoot() local c = GetChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum()  local c = GetChar(); return c and c:FindFirstChildOfClass("Humanoid") end

-- =====================
-- KEY STORAGE
-- =====================
local function SaveKey(k)
    pcall(function() LP.PlayerGui:SetAttribute(STORAGE_KEY, k) end)
end
local function LoadKey()
    local ok, v = pcall(function() return LP.PlayerGui:GetAttribute(STORAGE_KEY) end)
    return ok and v or nil
end
local function IsKeyValid(k)
    if not k or k == "" then return false end
    k = k:upper():gsub("%s", "")
    for _, v in ipairs(VALID_KEYS) do
        if k == v:upper() then return true end
    end
    return false
end

-- =====================
-- REMOTE FOLDERS
-- =====================
local RE    = ReplicatedStorage:WaitForChild("RemoteEvents", 5)
local Rem   = ReplicatedStorage:WaitForChild("Remotes", 5)
local AbSys = ReplicatedStorage:WaitForChild("AbilitySystem", 5)
local FrPS  = nil
pcall(function() FrPS = ReplicatedStorage:WaitForChild("FruitPowerSystem", 5) end)

local function Fire(folder, name, ...)
    if not folder then return end
    local r = folder:FindFirstChild(name)
    if r and r:IsA("RemoteEvent") then
        pcall(function() r:FireServer(...) end)
    end
end
local function Invoke(folder, name, ...)
    if not folder then return end
    local r = folder:FindFirstChild(name)
    if r and r:IsA("RemoteFunction") then
        local ok, res = pcall(function() return r:InvokeServer(...) end)
        if ok then return res end
    end
end
local function RE_Fire(n, ...)  Fire(RE, n, ...) end
local function Rem_Fire(n, ...) Fire(Rem, n, ...) end
local AbRemotes = AbSys and AbSys:FindFirstChild("Remotes")
local function Ab_Fire(n, ...) Fire(AbRemotes, n, ...) end

-- =====================
-- CONFIG
-- =====================
local Cfg = {
    Speedhack = false, SpeedValue = 80,
    InfinityJump = false,
    ESPPlayer = false,
    AutoHaki = false,
    AutoObservation = false,
    AutoConqueror = false,
    AutoFarm = false, SelectedMob = "Thief [Lv.10]",
    FarmPosition = "Behind",
    AutoFarmAll = false,
    AutoUseSkills = false,
    AutoFarmBoss = false, SelectedBoss = "Alucard",
    AutoSummonBoss = false, AutoKillSummon = false,
    SelectedSummonBoss = "Slime",
    AutoSpawnRimuru = false, AutoKillRimuru = false, DiffRimuru = "Normal",
    AutoSpawnAnos = false, AutoKillAnos = false,
    AutoSpawnStrongest = false, AutoKillStrongest = false,
    AutoAcceptQuest = false,
    AutoCompleteQuest = false,
    AutoQuestFarm = false,
    SelectedStat = "Melee", StatAmount = "1",
    AutoUpgradeStat = false,
    SelectedDungeon = "CidDungeon",
    AutoJoinDungeon = false,
    AutoJoinTeam = false,
    AutoRetry = false,
    AutoVote = false, SelectedDifficulty = "Extreme",
    StartKill = false,
    SelectedIsland = "BossIsland",
    SelectedNPC = "AizenNpc",
    AutoSlimeCraft = false,
    AutoGrailCraft = false,
    AntiAFK = true,
    Transparency = true,
}

-- =====================
-- LOOP MANAGER
-- =====================
local Loops = {}
local function StopLoop(n) Loops[n] = false end
local function StartLoop(n, fn, t)
    StopLoop(n); Loops[n] = true
    task.spawn(function()
        while Loops[n] do
            pcall(fn); task.wait(t or 0.1)
        end
    end)
end

-- =====================
-- UTILITY
-- =====================
local function FindNearest(kw, maxD)
    maxD = maxD or 600
    local root = GetRoot(); if not root then return nil end
    local best, bd = nil, maxD
    for _, m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m.Name:lower():find(kw:lower()) and m ~= GetChar() then
            local hum = m:FindFirstChildOfClass("Humanoid")
            local hr  = m:FindFirstChild("HumanoidRootPart")
            if hum and hr and hum.Health > 0 then
                local d = (root.Position - hr.Position).Magnitude
                if d < bd then best = m; bd = d end
            end
        end
    end
    return best
end

local function FindAnyMob(maxD)
    local root = GetRoot(); if not root then return nil end
    local best, bd = nil, maxD or 400
    for _, m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m ~= GetChar() then
            local hum = m:FindFirstChildOfClass("Humanoid")
            local hr  = m:FindFirstChild("HumanoidRootPart")
            if hum and hr and hum.Health > 0 and hum.MaxHealth > 0 and hum.MaxHealth < 1e9 then
                local d = (root.Position - hr.Position).Magnitude
                if d < bd then best = m; bd = d end
            end
        end
    end
    return best
end

local function TeleportTo(pos)
    local root = GetRoot()
    if root then root.CFrame = CFrame.new(pos + Vector3.new(0, 4, 0)) end
end

local function FireAllProx(kw)
    for _, pp in ipairs(workspace:GetDescendants()) do
        if pp:IsA("ProximityPrompt") and (pp.ActionText .. pp.ObjectText):lower():find(kw:lower()) then
            pcall(function() fireproximityprompt(pp) end)
        end
    end
end

local function ClickGUI(kw)
    for _, b in ipairs(LP.PlayerGui:GetDescendants()) do
        if b:IsA("TextButton") and b.Text:lower():find(kw:lower()) then
            pcall(function()
                local p = b.AbsolutePosition + b.AbsoluteSize / 2
                VirtualUser:Button1Down(p, workspace.CurrentCamera.CFrame)
                task.wait(0.05)
                VirtualUser:Button1Up(p, workspace.CurrentCamera.CFrame)
            end)
        end
    end
end

-- =====================
-- ATTACK
-- =====================
local function AttackTarget(target)
    if not target then return end
    local root = GetRoot(); local hum = GetHum()
    if not root or not hum or hum.Health <= 0 then return end
    local hr = target:FindFirstChild("HumanoidRootPart"); if not hr then return end
    local off = Cfg.FarmPosition == "Behind" and Vector3.new(0, 0, 4)
             or Cfg.FarmPosition == "Front"  and Vector3.new(0, 0, -4)
             or Vector3.new(4, 0, 0)
    root.CFrame = CFrame.lookAt(hr.Position + off, hr.Position)
    local CombatRem = ReplicatedStorage:FindFirstChild("CombatSystem")
    if CombatRem then CombatRem = CombatRem:FindFirstChild("Remotes") end
    if CombatRem then Fire(CombatRem, "RequestHit", target) end
    RE_Fire("CombatRemote", target)
    if Cfg.AutoUseSkills then
        for slot = 1, 5 do Ab_Fire("RequestAbility", slot); task.wait(0.07) end
    end
    local char = GetChar()
    if char then
        local equipped = false
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then equipped = true; pcall(function() t:Activate() end) end
        end
        if not equipped then
            local tool = LP.Backpack:FindFirstChildOfClass("Tool")
            if tool then tool.Parent = char end
        end
    end
    pcall(function()
        local cam = workspace.CurrentCamera
        local vp  = cam.ViewportSize
        VirtualUser:Button1Down(Vector2.new(vp.X / 2, vp.Y / 2), cam.CFrame)
        task.wait(0.04)
        VirtualUser:Button1Up(Vector2.new(vp.X / 2, vp.Y / 2), cam.CFrame)
    end)
    for _, v in ipairs(target:GetDescendants()) do
        if v:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(v) end) end
        if v:IsA("ClickDetector")   then pcall(function() fireclickdetector(v) end) end
    end
end

-- =====================
-- FEATURES
-- =====================
local function ApplySpeed(on)
    local h = GetHum(); if h then h.WalkSpeed = on and Cfg.SpeedValue or 16 end
end

local ijConn
local function ToggleInfJump(on)
    if ijConn then ijConn:Disconnect(); ijConn = nil end
    if on then
        ijConn = UserInputService.JumpRequest:Connect(function()
            local h = GetHum()
            if h then h:ChangeState(Enum.HumanoidStateType.Jumping); RE_Fire("MultiJumpRemote") end
        end)
    end
end

local function DoSprint(on) RE_Fire("SprintToggle", on) end
local function DoHaki() RE_Fire("HakiRemote", true); RE_Fire("HakiStateUpdate", true) end
local function DoObservation() RE_Fire("ObservationHakiRemote", true); RE_Fire("ObservationHakiStateUpdate", true) end
local function DoConqueror() RE_Fire("ConquerorHakiRemote", true); Rem_Fire("ConquerorHakiRemote", true) end
local function DoAcceptQuest() RE_Fire("QuestAccept"); FireAllProx("accept"); ClickGUI("accept") end
local function DoCompleteQuest() RE_Fire("QuestComplete"); RE_Fire("QuestRepeat"); ClickGUI("complete") end
local function DoAllocateStat()
    local amt = tonumber(Cfg.StatAmount) or 1
    RE_Fire("AllocateStat", Cfg.SelectedStat, amt)
    Rem_Fire("AllocateStats", Cfg.SelectedStat, amt)
end
local function DoEquipWeapon(name)
    Rem_Fire("EquipWeapon", name or Cfg.SelectedWeapon)
    local char = GetChar(); if not char then return end
    for _, t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and t.Name:lower():find((name or Cfg.SelectedWeapon or ""):lower()) then
            t.Parent = char; break
        end
    end
end
local function DoSummonBoss(n, d) Rem_Fire("RequestSummonBoss", n, d or "Normal") end
local function DoSpawnRimuru() RE_Fire("RequestAutoSpawnRimuru", Cfg.DiffRimuru); Rem_Fire("RequestSpawnRimuru", Cfg.DiffRimuru) end
local function DoSpawnAnos() Rem_Fire("RequestAutoSpawnAnos") end
local function DoSpawnStrongest() Rem_Fire("RequestAutoSpawnStrongest") end
local function DoSlimeCraft() Invoke(Rem, "RequestSlimeCraft"); RE_Fire("OpenSlimeCraftUI"); FireAllProx("craft") end
local function DoGrailCraft() Invoke(Rem, "RequestGrailCraft"); RE_Fire("OpenGrailCraftUI"); FireAllProx("grail") end
local function DoJoinDungeon() Rem_Fire("JoinDungeonPortal", Cfg.SelectedDungeon); FireAllProx("dungeon"); ClickGUI("join") end
local function DoDungeonVote() Rem_Fire("DungeonWaveVote", Cfg.SelectedDifficulty); ClickGUI(Cfg.SelectedDifficulty) end

local IslandPos = {
    BossIsland = Vector3.new(0,100,0), DesertIsland = Vector3.new(1000,100,0),
    DungeonIsland = Vector3.new(-1000,100,0), HuecoMundoIsland = Vector3.new(0,100,1000),
    JungleIsland = Vector3.new(0,100,-1000), ShibuyaDestroyed = Vector3.new(-500,100,500),
    SlimeIsland = Vector3.new(500,100,-500), SnowIsland = Vector3.new(1500,100,0),
    StarterIsland = Vector3.new(-1500,100,0),
}
local function DoTeleportIsland(name)
    Rem_Fire("TeleportToPortal", name)
    task.wait(0.5)
    local pos = IslandPos[name]; if pos then TeleportTo(pos) end
end
local function DoTeleportNPC(name)
    local kw = name:lower():gsub("npc",""):gsub("boss","")
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find(kw) then
            local hr = v:FindFirstChild("HumanoidRootPart")
            if hr then TeleportTo(hr.Position + Vector3.new(0,0,4)); return end
        end
    end
end
local function StartAntiAFK()
    StartLoop("AntiAFK", function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end, 55)
end

-- =====================
-- ESP
-- =====================
local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "TokyoESP"; ESPGui.ResetOnSpawn = false
if not pcall(function() ESPGui.Parent = game:GetService("CoreGui") end) then
    ESPGui.Parent = LP.PlayerGui
end
local function MakeESP(player)
    if player == LP then return end
    local function build()
        local c = player.Character; if not c then return end
        local head = c:FindFirstChild("Head"); if not head then return end
        local old = ESPGui:FindFirstChild("ESP_"..player.Name); if old then old:Destroy() end
        local bb = Instance.new("BillboardGui", ESPGui)
        bb.Name = "ESP_"..player.Name; bb.Adornee = head
        bb.Size = UDim2.new(0,140,0,50); bb.StudsOffset = Vector3.new(0,3,0); bb.AlwaysOnTop = true
        local lbl = Instance.new("TextLabel", bb)
        lbl.Size = UDim2.new(1,0,1,0); lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 13
        lbl.TextStrokeTransparency = 0; lbl.TextColor3 = Color3.fromRGB(0,200,255)
        lbl.Text = player.Name
        RunService.Heartbeat:Connect(function()
            if not bb or not bb.Parent then return end
            local r = GetRoot(); local pr = c:FindFirstChild("HumanoidRootPart")
            if r and pr then lbl.Text = player.Name.."\n["..math.floor((r.Position-pr.Position).Magnitude).."m]" end
        end)
    end
    build()
    player.CharacterAdded:Connect(function() task.wait(1); build() end)
end
local function UpdateESP()
    ESPGui:ClearAllChildren()
    if Cfg.ESPPlayer then for _, p in ipairs(Players:GetPlayers()) do MakeESP(p) end end
end

-- =====================
-- COLORS
-- =====================
local C = {
    Bg      = Color3.fromRGB(6, 9, 20),
    Side    = Color3.fromRGB(4, 7, 16),
    Panel   = Color3.fromRGB(10, 14, 28),
    Row1    = Color3.fromRGB(14, 18, 34),
    Row2    = Color3.fromRGB(9, 12, 25),
    Hover   = Color3.fromRGB(20, 26, 52),
    Accent  = Color3.fromRGB(80, 170, 255),
    Accent2 = Color3.fromRGB(140, 205, 255),
    AccentG = Color3.fromRGB(80, 230, 140),
    Border  = Color3.fromRGB(25, 40, 80),
    Text    = Color3.fromRGB(200, 215, 250),
    Dim     = Color3.fromRGB(90, 110, 160),
    White   = Color3.fromRGB(255, 255, 255),
    TOn     = Color3.fromRGB(60, 150, 255),
    TOff    = Color3.fromRGB(30, 40, 70),
    Gold    = Color3.fromRGB(255, 200, 60),
    Red     = Color3.fromRGB(255, 70, 70),
    Discord = Color3.fromRGB(88, 101, 242),
}

-- =====================
-- MAIN GUI
-- =====================
pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("TokyoGUI")
    if old then old:Destroy() end
end)
pcall(function()
    local old = LP.PlayerGui:FindFirstChild("TokyoGUI")
    if old then old:Destroy() end
end)

local SG = Instance.new("ScreenGui")
SG.Name = "TokyoGUI"; SG.ResetOnSpawn = false; SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
if not pcall(function() SG.Parent = game:GetService("CoreGui") end) then SG.Parent = LP.PlayerGui end

-- Main frame
local MF = Instance.new("Frame", SG)
MF.Name = "MainFrame"
MF.Size = UDim2.new(0,660,0,460)
MF.Position = UDim2.new(0.5,-330,0.5,-230)
MF.BackgroundColor3 = C.Bg
MF.BackgroundTransparency = 0.06
MF.BorderSizePixel = 0; MF.ClipsDescendants = true; MF.Visible = false
Instance.new("UICorner", MF).CornerRadius = UDim.new(0,14)
local mStroke = Instance.new("UIStroke", MF)
mStroke.Color = C.Border; mStroke.Thickness = 1.5

-- Titlebar
local TB = Instance.new("Frame", MF)
TB.Size = UDim2.new(1,0,0,32); TB.BackgroundColor3 = C.Side
TB.BackgroundTransparency = 0.04; TB.BorderSizePixel = 0; TB.ZIndex = 10
Instance.new("UICorner", TB).CornerRadius = UDim.new(0,14)
local tbFix = Instance.new("Frame", TB)
tbFix.Size = UDim2.new(1,0,0,14); tbFix.Position = UDim2.new(0,0,1,-14)
tbFix.BackgroundColor3 = C.Side; tbFix.BackgroundTransparency = 0.04; tbFix.BorderSizePixel = 0

local TBL = Instance.new("TextLabel", TB)
TBL.Size = UDim2.new(1,-80,1,0); TBL.Position = UDim2.new(0,14,0,0)
TBL.BackgroundTransparency = 1
TBL.Text = "Tokyo Script  V1.0"
TBL.TextColor3 = C.Dim; TBL.Font = Enum.Font.GothamBold
TBL.TextSize = 11; TBL.TextXAlignment = Enum.TextXAlignment.Left; TBL.ZIndex = 11

local function WBtn(col, ox)
    local b = Instance.new("TextButton", TB)
    b.Size = UDim2.new(0,13,0,13); b.Position = UDim2.new(1,ox,0.5,-6.5)
    b.BackgroundColor3 = col; b.Text = ""; b.BorderSizePixel = 0; b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(1,0)
    return b
end
WBtn(C.Red,-22).MouseButton1Click:Connect(function() SG:Destroy() end)
WBtn(C.Gold,-42).MouseButton1Click:Connect(function() MF.Visible = not MF.Visible end)

-- Drag
local drag, ds, sp = false
TB.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=true; ds=i.Position; sp=MF.Position end
end)
TB.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then drag=false end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
        local d = i.Position - ds
        MF.Position = UDim2.new(sp.X.Scale, sp.X.Offset+d.X, sp.Y.Scale, sp.Y.Offset+d.Y)
    end
end)
UserInputService.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.LeftControl then MF.Visible = not MF.Visible end
end)

-- Sidebar
local SB = Instance.new("Frame", MF)
SB.Size = UDim2.new(0,138,1,-32); SB.Position = UDim2.new(0,0,0,32)
SB.BackgroundColor3 = C.Side; SB.BackgroundTransparency = 0.04; SB.BorderSizePixel = 0
Instance.new("UIListLayout", SB).SortOrder = Enum.SortOrder.LayoutOrder

local sep = Instance.new("Frame", MF)
sep.Size = UDim2.new(0,1,1,-32); sep.Position = UDim2.new(0,138,0,32)
sep.BackgroundColor3 = C.Border; sep.BorderSizePixel = 0

local logo = Instance.new("TextLabel", SB)
logo.Size = UDim2.new(1,0,0,44); logo.BackgroundTransparency = 1
logo.Text = "TOKYO\nSCRIPT"; logo.TextColor3 = C.Accent; logo.Font = Enum.Font.GothamBold
logo.TextSize = 11; logo.LayoutOrder = 0

-- Content area
local CA = Instance.new("ScrollingFrame", MF)
CA.Size = UDim2.new(1,-139,1,-32); CA.Position = UDim2.new(0,139,0,32)
CA.BackgroundColor3 = C.Bg; CA.BackgroundTransparency = 0.06; CA.BorderSizePixel = 0
CA.ScrollBarThickness = 3; CA.ScrollBarImageColor3 = C.Accent
CA.CanvasSize = UDim2.new(0,0,0,0); CA.AutomaticCanvasSize = Enum.AutomaticSize.Y
local CAL = Instance.new("UIListLayout", CA)
CAL.SortOrder = Enum.SortOrder.LayoutOrder; CAL.Padding = UDim.new(0,2)
local CAP = Instance.new("UIPadding", CA)
CAP.PaddingTop = UDim.new(0,10); CAP.PaddingLeft = UDim.new(0,12)
CAP.PaddingRight = UDim.new(0,16); CAP.PaddingBottom = UDim.new(0,12)

-- Page system
local Pages, CurPage, RowIdx = {}, nil, 0
local function NewPage(name)
    local f = Instance.new("Frame", CA)
    f.Name = name; f.Size = UDim2.new(1,0,0,0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundTransparency = 1; f.Visible = false
    local l = Instance.new("UIListLayout", f)
    l.SortOrder = Enum.SortOrder.LayoutOrder; l.Padding = UDim.new(0,2)
    Pages[name] = f; return f
end
local function ShowPage(name)
    if CurPage and Pages[CurPage] then Pages[CurPage].Visible = false end
    CurPage = name; if Pages[name] then Pages[name].Visible = true end
    CA.CanvasPosition = Vector2.new(0,0)
end

-- Sidebar buttons
local SBBtns = {}
local function SideBtn(label, icon, page, order)
    local btn = Instance.new("TextButton", SB)
    btn.Size = UDim2.new(1,0,0,40); btn.BackgroundColor3 = C.Side
    btn.BackgroundTransparency = 1; btn.BorderSizePixel = 0; btn.Text = ""; btn.LayoutOrder = order
    local bar = Instance.new("Frame", btn)
    bar.Size = UDim2.new(0,3,0.65,0); bar.Position = UDim2.new(0,0,0.175,0)
    bar.BackgroundColor3 = C.Accent; bar.BorderSizePixel = 0; bar.Visible = false
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
    local ico = Instance.new("TextLabel", btn)
    ico.Size = UDim2.new(0,26,1,0); ico.Position = UDim2.new(0,10,0,0)
    ico.BackgroundTransparency = 1; ico.Text = icon
    ico.TextColor3 = C.Dim; ico.Font = Enum.Font.GothamBold; ico.TextSize = 15
    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1,-40,1,0); txt.Position = UDim2.new(0,38,0,0)
    txt.BackgroundTransparency = 1; txt.Text = label
    txt.TextColor3 = C.Dim; txt.Font = Enum.Font.Gotham; txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(SBBtns) do
            b.btn.BackgroundColor3 = C.Side; b.btn.BackgroundTransparency = 1
            b.bar.Visible = false; b.ico.TextColor3 = C.Dim; b.txt.TextColor3 = C.Dim
        end
        btn.BackgroundColor3 = C.Panel; btn.BackgroundTransparency = 0.35
        bar.Visible = true; ico.TextColor3 = C.Accent; txt.TextColor3 = C.White
        ShowPage(page)
    end)
    table.insert(SBBtns, {btn=btn, bar=bar, ico=ico, txt=txt, page=page})
end

-- Widget helpers
local function NextRow() RowIdx = RowIdx + 1; return RowIdx % 2 == 0 and C.Row1 or C.Row2 end

local function MkTitle(parent, text)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1,0,0,38); l.BackgroundTransparency = 1
    l.Text = text; l.TextColor3 = C.White; l.Font = Enum.Font.GothamBold; l.TextSize = 18
    l.TextXAlignment = Enum.TextXAlignment.Left; l.LayoutOrder = 0
end

local function MkSect(parent, text)
    RowIdx = RowIdx + 1
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,0,0,28); f.BackgroundTransparency = 1; f.LayoutOrder = RowIdx
    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,0,1,-4); lbl.BackgroundTransparency = 1; lbl.Text = "-- "..text
    lbl.TextColor3 = C.Accent2; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    local p = Instance.new("UIPadding", lbl); p.PaddingTop = UDim.new(0,10)
end

local function MkToggle(parent, label, cfgKey, cb)
    RowIdx = RowIdx + 1; local bg = NextRow()
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,36); row.BackgroundColor3 = bg
    row.BorderSizePixel = 0; row.LayoutOrder = RowIdx
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
    local lb = Instance.new("TextLabel", row)
    lb.Size = UDim2.new(1,-62,1,0); lb.Position = UDim2.new(0,12,0,0)
    lb.BackgroundTransparency = 1; lb.Text = label; lb.TextColor3 = C.Text
    lb.Font = Enum.Font.Gotham; lb.TextSize = 12; lb.TextXAlignment = Enum.TextXAlignment.Left
    local tbg = Instance.new("Frame", row)
    tbg.Size = UDim2.new(0,40,0,22); tbg.Position = UDim2.new(1,-52,0.5,-11)
    tbg.BackgroundColor3 = Cfg[cfgKey] and C.TOn or C.TOff; tbg.BorderSizePixel = 0
    Instance.new("UICorner", tbg).CornerRadius = UDim.new(1,0)
    local kn = Instance.new("Frame", tbg); kn.Size = UDim2.new(0,18,0,18)
    kn.Position = Cfg[cfgKey] and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
    kn.BackgroundColor3 = C.White; kn.BorderSizePixel = 0
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)
    local badge = Instance.new("TextLabel", row)
    badge.Size = UDim2.new(0,26,0,14); badge.Position = UDim2.new(1,-90,0.5,-7)
    badge.BackgroundColor3 = C.AccentG; badge.Text = "ON"; badge.TextColor3 = C.White
    badge.Font = Enum.Font.GothamBold; badge.TextSize = 8; badge.BorderSizePixel = 0
    badge.BackgroundTransparency = 1; badge.Visible = Cfg[cfgKey] or false
    Instance.new("UICorner", badge).CornerRadius = UDim.new(0,4)
    local ti = TweenInfo.new(0.16, Enum.EasingStyle.Quad)
    local function Set(v)
        Cfg[cfgKey] = v
        TweenService:Create(tbg, ti, {BackgroundColor3 = v and C.TOn or C.TOff}):Play()
        TweenService:Create(kn, ti, {Position = v and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
        TweenService:Create(lb, ti, {TextColor3 = v and C.White or C.Text}):Play()
        badge.Visible = v
        if cb then cb(v) end
    end
    local clk = Instance.new("TextButton", row)
    clk.Size = UDim2.new(1,0,1,0); clk.BackgroundTransparency = 1; clk.Text = ""
    clk.MouseButton1Click:Connect(function() Set(not Cfg[cfgKey]) end)
    clk.MouseEnter:Connect(function() TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3=C.Hover}):Play() end)
    clk.MouseLeave:Connect(function() TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3=bg}):Play() end)
end

local function MkDropdown(parent, label, opts, cfgKey, cb)
    RowIdx = RowIdx + 1; local bg = NextRow()
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,36); row.BackgroundColor3 = bg
    row.BorderSizePixel = 0; row.LayoutOrder = RowIdx; row.ClipsDescendants = false
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
    local lb = Instance.new("TextLabel", row)
    lb.Size = UDim2.new(0.44,0,1,0); lb.Position = UDim2.new(0,12,0,0)
    lb.BackgroundTransparency = 1; lb.Text = label; lb.TextColor3 = C.Text
    lb.Font = Enum.Font.Gotham; lb.TextSize = 12; lb.TextXAlignment = Enum.TextXAlignment.Left
    local sel = Instance.new("TextButton", row)
    sel.Size = UDim2.new(0.49,0,0,26); sel.Position = UDim2.new(0.5,-2,0.5,-13)
    sel.BackgroundColor3 = C.Panel; sel.Text = tostring(Cfg[cfgKey] or opts[1])
    sel.TextColor3 = C.Accent; sel.Font = Enum.Font.GothamBold; sel.TextSize = 11
    sel.BorderSizePixel = 0; sel.ZIndex = 5
    Instance.new("UICorner", sel).CornerRadius = UDim.new(0,5)
    local dl = Instance.new("Frame", row)
    dl.Size = UDim2.new(0.49,0,0,math.min(#opts,6)*27)
    dl.Position = UDim2.new(0.5,-2,1,4)
    dl.BackgroundColor3 = C.Panel; dl.BorderSizePixel = 0; dl.Visible = false; dl.ZIndex = 60
    Instance.new("UICorner", dl).CornerRadius = UDim.new(0,6)
    Instance.new("UIListLayout", dl).SortOrder = Enum.SortOrder.LayoutOrder
    for i, opt in ipairs(opts) do
        local ob = Instance.new("TextButton", dl)
        ob.Size = UDim2.new(1,0,0,27); ob.BackgroundColor3 = C.Panel
        ob.Text = " "..opt; ob.TextColor3 = C.Text; ob.Font = Enum.Font.Gotham
        ob.TextSize = 11; ob.BorderSizePixel = 0; ob.ZIndex = 61; ob.LayoutOrder = i
        ob.TextXAlignment = Enum.TextXAlignment.Left
        ob.MouseEnter:Connect(function() ob.BackgroundColor3 = C.Hover; ob.TextColor3 = C.White end)
        ob.MouseLeave:Connect(function() ob.BackgroundColor3 = C.Panel; ob.TextColor3 = C.Text end)
        ob.MouseButton1Click:Connect(function()
            Cfg[cfgKey] = opt; sel.Text = opt; dl.Visible = false
            if cb then cb(opt) end
        end)
    end
    sel.MouseButton1Click:Connect(function() dl.Visible = not dl.Visible end)
end

local function MkBtn(parent, label, sub, cb)
    RowIdx = RowIdx + 1; local h = sub and 48 or 36; local bg = NextRow()
    local row = Instance.new("TextButton", parent)
    row.Size = UDim2.new(1,0,0,h); row.BackgroundColor3 = bg
    row.BorderSizePixel = 0; row.Text = ""; row.LayoutOrder = RowIdx
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
    local lb = Instance.new("TextLabel", row)
    lb.Size = UDim2.new(1,-32,0,20); lb.Position = UDim2.new(0,12,0,sub and 7 or 8)
    lb.BackgroundTransparency = 1; lb.Text = label; lb.TextColor3 = C.Text
    lb.Font = Enum.Font.Gotham; lb.TextSize = 12; lb.TextXAlignment = Enum.TextXAlignment.Left
    if sub then
        local sl = Instance.new("TextLabel", row)
        sl.Size = UDim2.new(1,-32,0,14); sl.Position = UDim2.new(0,12,0,27)
        sl.BackgroundTransparency = 1; sl.Text = sub; sl.TextColor3 = C.Dim
        sl.Font = Enum.Font.Gotham; sl.TextSize = 10; sl.TextXAlignment = Enum.TextXAlignment.Left
    end
    local ar = Instance.new("TextLabel", row)
    ar.Size = UDim2.new(0,22,1,0); ar.Position = UDim2.new(1,-28,0,0)
    ar.BackgroundTransparency = 1; ar.Text = ">"; ar.TextColor3 = C.Accent
    ar.Font = Enum.Font.GothamBold; ar.TextSize = 22
    row.MouseButton1Click:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.07), {BackgroundColor3=C.Accent}):Play()
        task.delay(0.07, function() TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3=bg}):Play() end)
        if cb then cb() end
    end)
    row.MouseEnter:Connect(function() TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3=C.Hover}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3=bg}):Play() end)
end

-- =====================
-- PAGES
-- =====================

-- MAIN
local PM = NewPage("Main"); MkTitle(PM,"Main")
MkSect(PM,"Player")
MkToggle(PM,"Speedhack","Speedhack",function(v)
    if v then StartLoop("Speed",function() ApplySpeed(true) end,1) else StopLoop("Speed"); ApplySpeed(false) end
end)
MkToggle(PM,"Infinity Jump","InfinityJump",function(v) ToggleInfJump(v) end)
MkToggle(PM,"Sprint Toggle","SprintOn",function(v) DoSprint(v) end)
MkToggle(PM,"ESP Player","ESPPlayer",function() UpdateESP() end)
MkSect(PM,"Haki")
MkToggle(PM,"Auto Haki","AutoHaki",function(v)
    if v then StartLoop("Haki",DoHaki,3) else StopLoop("Haki") end
end)
MkToggle(PM,"Auto Observation","AutoObservation",function(v)
    if v then StartLoop("Obs",DoObservation,3) else StopLoop("Obs") end
end)
MkToggle(PM,"Auto Conqueror Haki","AutoConqueror",function(v)
    if v then StartLoop("Conq",DoConqueror,3) else StopLoop("Conq") end
end)

-- AUTO FARM
local PAF = NewPage("AutoFarm"); MkTitle(PAF,"Auto Farm")
MkSect(PAF,"Weapon")
MkDropdown(PAF,"Select Weapon",{"Combat","Sword","Gun","Fruit","None"},"SelectedWeapon")
MkBtn(PAF,"Equip Weapon Now",nil,function() DoEquipWeapon() end)
MkSect(PAF,"Mob Farm")
MkDropdown(PAF,"Select Mob",{
    "Thief [Lv.10]","Thief Boss [Lv.25]","Monkey [Lv.250]","Monkey Boss [Lv.500]",
    "Desert Bandit [Lv.750]","Desert Boss [Lv.1000]","Frost Rogue [Lv.1500]",
    "Snow Boss [Lv.2000]","Sorcerer Student [Lv.3000]","Panda Boss [Lv.4000]",
    "Hollow [Lv.5000]","Strong Sorcerer [Lv.6000]","Curse [Lv.7000]",
    "Slime [Lv.8000]","Academy Teacher [Lv.9000]",
},"SelectedMob")
MkDropdown(PAF,"Farm Position",{"Behind","Front","Side"},"FarmPosition")
MkToggle(PAF,"Auto Farm Mob","AutoFarm",function(v)
    if v then
        StartLoop("Farm",function()
            local kw = Cfg.SelectedMob:gsub("%s*%[.*%]",""):gsub("%s+$","")
            local m = FindNearest(kw)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("Farm") end
end)
MkToggle(PAF,"Auto Farm ALL Mobs","AutoFarmAll",function(v)
    if v then StartLoop("FarmAll",function() local m=FindAnyMob(); if m then AttackTarget(m) end end,0.05)
    else StopLoop("FarmAll") end
end)
MkSect(PAF,"Skills")
MkToggle(PAF,"Auto Use Skills","AutoUseSkills")
MkBtn(PAF,"Use Skills Once",nil,function()
    for slot=1,5 do Ab_Fire("RequestAbility",slot); task.wait(0.08) end
end)
MkSect(PAF,"Boss Farm")
MkDropdown(PAF,"Select Boss",{"Alucard","Gojo","Rimuru","Gilgamesh","Valentine","Anos","Slime"},"SelectedBoss")
MkToggle(PAF,"Auto Farm Boss","AutoFarmBoss",function(v)
    if v then StartLoop("FarmBoss",function() local m=FindNearest(Cfg.SelectedBoss,2000); if m then AttackTarget(m) end end,0.05)
    else StopLoop("FarmBoss") end
end)

-- QUEST
local PAQ = NewPage("Quest"); MkTitle(PAQ,"Quest")
MkSect(PAQ,"Auto Quest")
MkToggle(PAQ,"Auto Accept Quest","AutoAcceptQuest",function(v)
    if v then StartLoop("AcptQ",DoAcceptQuest,1.5) else StopLoop("AcptQ") end
end)
MkToggle(PAQ,"Auto Complete Quest","AutoCompleteQuest",function(v)
    if v then StartLoop("CompQ",DoCompleteQuest,1) else StopLoop("CompQ") end
end)
MkToggle(PAQ,"Auto Farm Quest Mob","AutoQuestFarm",function(v)
    if v then StartLoop("QFarm",function() local m=FindAnyMob(); if m then AttackTarget(m) end end,0.05)
    else StopLoop("QFarm") end
end)
MkBtn(PAQ,"Accept Quest Now",nil,function() DoAcceptQuest() end)
MkBtn(PAQ,"Complete Quest Now",nil,function() DoCompleteQuest() end)

-- BOSS
local PB = NewPage("Boss"); MkTitle(PB,"Boss System")
MkSect(PB,"Rimuru")
MkDropdown(PB,"Difficulty",{"Normal","Hard","Extreme"},"DiffRimuru")
MkToggle(PB,"Auto Spawn Rimuru","AutoSpawnRimuru",function(v)
    if v then StartLoop("SpawnRim",DoSpawnRimuru,4) else StopLoop("SpawnRim") end
end)
MkToggle(PB,"Auto Kill Rimuru","AutoKillRimuru",function(v)
    if v then StartLoop("KillRim",function() local m=FindNearest("Rimuru",2000); if m then AttackTarget(m) end end,0.05)
    else StopLoop("KillRim") end
end)
MkSect(PB,"Anos")
MkToggle(PB,"Auto Spawn Anos","AutoSpawnAnos",function(v)
    if v then StartLoop("SpawnAnos",DoSpawnAnos,4) else StopLoop("SpawnAnos") end
end)
MkToggle(PB,"Auto Kill Anos","AutoKillAnos",function(v)
    if v then StartLoop("KillAnos",function() local m=FindNearest("Anos",2000); if m then AttackTarget(m) end end,0.05)
    else StopLoop("KillAnos") end
end)
MkSect(PB,"Strongest Boss")
MkToggle(PB,"Auto Spawn Strongest","AutoSpawnStrongest",function(v)
    if v then StartLoop("SpawnStr",DoSpawnStrongest,4) else StopLoop("SpawnStr") end
end)
MkToggle(PB,"Auto Kill Strongest","AutoKillStrongest",function(v)
    if v then StartLoop("KillStr",function() local m=FindAnyMob(2000); if m then AttackTarget(m) end end,0.05)
    else StopLoop("KillStr") end
end)
MkSect(PB,"Crafting")
MkToggle(PB,"Auto Slime Craft","AutoSlimeCraft",function(v)
    if v then StartLoop("CraftSlime",DoSlimeCraft,3) else StopLoop("CraftSlime") end
end)
MkToggle(PB,"Auto Grail Craft","AutoGrailCraft",function(v)
    if v then StartLoop("CraftGrail",DoGrailCraft,3) else StopLoop("CraftGrail") end
end)
MkBtn(PB,"Craft Slime Key Now",nil,function() DoSlimeCraft() end)
MkBtn(PB,"Craft Grail Key Now",nil,function() DoGrailCraft() end)

-- DUNGEON
local PD = NewPage("Dungeon"); MkTitle(PD,"Dungeon")
MkSect(PD,"Join")
MkDropdown(PD,"Select Dungeon",{"CidDungeon","ShadowDungeon","FrostDungeon","VoidDungeon"},"SelectedDungeon")
MkToggle(PD,"Auto Join Dungeon","AutoJoinDungeon",function(v)
    if v then StartLoop("JoinD",DoJoinDungeon,2) else StopLoop("JoinD") end
end)
MkToggle(PD,"Auto Join Team","AutoJoinTeam",function(v)
    if v then StartLoop("JoinT",function() ClickGUI("team"); FireAllProx("team") end,2)
    else StopLoop("JoinT") end
end)
MkSect(PD,"Wave")
MkDropdown(PD,"Difficulty",{"Normal","Hard","Extreme"},"SelectedDifficulty")
MkToggle(PD,"Auto Vote Difficulty","AutoVote",function(v)
    if v then StartLoop("VoteD",DoDungeonVote,1) else StopLoop("VoteD") end
end)
MkToggle(PD,"Auto Retry","AutoRetry",function(v)
    if v then StartLoop("Retry",function() ClickGUI("retry"); Rem_Fire("DungeonWaveReplayVote") end,3)
    else StopLoop("Retry") end
end)
MkToggle(PD,"Kill Dungeon Mobs","StartKill",function(v)
    if v then StartLoop("DKill",function() local m=FindAnyMob(300); if m then AttackTarget(m) end end,0.05)
    else StopLoop("DKill") end
end)
MkBtn(PD,"Leave Dungeon",nil,function() Rem_Fire("LeaveDungeonPortal") end)

-- STATS
local PSt = NewPage("Stats"); MkTitle(PSt,"Stats")
MkSect(PSt,"Upgrade Stat")
MkDropdown(PSt,"Select Stat",{"Melee","Defense","Sword","Power","Spirit"},"SelectedStat")
MkDropdown(PSt,"Amount",{"1","5","10","50","100","999"},"StatAmount")
MkToggle(PSt,"Auto Upgrade Stats","AutoUpgradeStat",function(v)
    if v then StartLoop("UpgStat",DoAllocateStat,0.5) else StopLoop("UpgStat") end
end)
MkBtn(PSt,"Upgrade Once",nil,function() DoAllocateStat() end)
MkSect(PSt,"Stat Reroll")
MkBtn(PSt,"Open Stat Reroll UI",nil,function() RE_Fire("OpenStatRerollUI") end)
MkBtn(PSt,"Auto Skip Reroll",nil,function() RE_Fire("StatRerollUpdateAutoSkip") end)

-- TELEPORT
local PTP = NewPage("Teleport"); MkTitle(PTP,"Teleport")
MkSect(PTP,"Island")
MkDropdown(PTP,"Select Island",{
    "BossIsland","DesertIsland","DungeonIsland","HuecoMundoIsland",
    "JungleIsland","ShibuyaDestroyed","SlimeIsland","SnowIsland","StarterIsland"
},"SelectedIsland")
MkBtn(PTP,"Teleport to Island",nil,function() DoTeleportIsland(Cfg.SelectedIsland) end)
MkSect(PTP,"NPC")
MkDropdown(PTP,"Select NPC",{
    "AizenNpc","GojoBoss","RimuruNpc","CidNpc","ShopNpc","QuestNpc","SummonNpc","AnosNpc","GilgameshNpc"
},"SelectedNPC")
MkBtn(PTP,"Teleport to NPC",nil,function() DoTeleportNPC(Cfg.SelectedNPC) end)

-- SETTINGS
local PSet = NewPage("Settings"); MkTitle(PSet,"Settings")
MkSect(PSet,"Misc")
MkToggle(PSet,"Anti AFK","AntiAFK",function(v)
    if v then StartAntiAFK() else StopLoop("AntiAFK") end
end)
MkBtn(PSet,"Destroy GUI",nil,function() SG:Destroy() end)

-- Sidebar buttons
SideBtn("Main",      "[M]", "Main",     1)
SideBtn("Auto Farm", "[F]", "AutoFarm", 2)
SideBtn("Quest",     "[Q]", "Quest",    3)
SideBtn("Boss",      "[B]", "Boss",     4)
SideBtn("Dungeon",   "[D]", "Dungeon",  5)
SideBtn("Stats",     "[S]", "Stats",    6)
SideBtn("Teleport",  "[T]", "Teleport", 7)
SideBtn("Settings",  "[X]", "Settings", 8)

-- Open menu function
local function OpenMenu()
    MF.Visible = true
    MF.Size = UDim2.new(0,0,0,0); MF.Position = UDim2.new(0.5,0,0.5,0)
    TweenService:Create(MF, TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {
        Size = UDim2.new(0,660,0,460),
        Position = UDim2.new(0.5,-330,0.5,-230),
    }):Play()
    task.wait(0.1)
    ShowPage("Main")
    if SBBtns[1] then
        local b = SBBtns[1]
        b.btn.BackgroundColor3 = C.Panel; b.btn.BackgroundTransparency = 0.35
        b.bar.Visible = true; b.ico.TextColor3 = C.Accent; b.txt.TextColor3 = C.White
    end
end

if Cfg.AntiAFK then StartAntiAFK() end
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if Cfg.Speedhack then local h=char:WaitForChild("Humanoid",3); if h then h.WalkSpeed=Cfg.SpeedValue end end
    if Cfg.InfinityJump then ToggleInfJump(true) end
    if Cfg.ESPPlayer then task.wait(1); UpdateESP() end
end)

-- =====================
-- KEY SYSTEM GUI
-- =====================
pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("TokyoKeyUI")
    if old then old:Destroy() end
end)
pcall(function()
    local old = LP.PlayerGui:FindFirstChild("TokyoKeyUI")
    if old then old:Destroy() end
end)

local KG = Instance.new("ScreenGui")
KG.Name = "TokyoKeyUI"; KG.ResetOnSpawn = false
KG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
KG.IgnoreGuiInset = true
if not pcall(function() KG.Parent = game:GetService("CoreGui") end) then
    KG.Parent = LP.PlayerGui
end

-- Overlay
local kov = Instance.new("Frame", KG)
kov.Size = UDim2.new(1,0,1,0)
kov.BackgroundColor3 = Color3.fromRGB(0,0,0)
kov.BackgroundTransparency = 0.5
kov.BorderSizePixel = 0; kov.ZIndex = 1

-- Snow
local snowF = Instance.new("Frame", KG)
snowF.Size = UDim2.new(1,0,1,0)
snowF.BackgroundTransparency = 1; snowF.ZIndex = 2

local flakes = {}
for i = 1, 35 do
    local l = Instance.new("TextLabel", snowF)
    l.BackgroundTransparency = 1; l.ZIndex = 2
    l.Font = Enum.Font.GothamBold
    l.TextSize = math.random(8,20)
    l.Text = ({"*",".","+","o"})[math.random(4)]
    l.TextColor3 = Color3.fromRGB(math.random(120,200), math.random(160,220), 255)
    l.TextTransparency = math.random(4,8)/10
    l.Size = UDim2.new(0,20,0,20)
    local sx = math.random(0,100)/100
    l.Position = UDim2.new(sx, 0, math.random(-10,100)/100, 0)
    table.insert(flakes, {l=l, x=sx, spd=math.random(5,14)/10, rot=math.random(-2,2)})
end
local snowConn = RunService.Heartbeat:Connect(function(dt)
    for _, f in ipairs(flakes) do
        local ny = (f.l.Position.Y.Scale or 0) + dt * f.spd * 0.07
        if ny > 1.06 then ny = -0.04; f.x = math.random(0,100)/100 end
        local nx = f.x + math.sin(RunService.Heartbeat:IsConnected() and tick() * (f.rot~=0 and f.rot or 0.5) + f.x*9 or 0) * 0.004
        f.l.Position = UDim2.new(nx, 0, ny, 0)
    end
end)

-- Card
local kcard = Instance.new("Frame", KG)
kcard.Size = UDim2.new(0,0,0,0)
kcard.Position = UDim2.new(0.5,0,0.5,0)
kcard.BackgroundColor3 = C.Bg
kcard.BackgroundTransparency = 0.04
kcard.BorderSizePixel = 0; kcard.ZIndex = 10; kcard.ClipsDescendants = true
Instance.new("UICorner", kcard).CornerRadius = UDim.new(0,16)
local kStroke = Instance.new("UIStroke", kcard)
kStroke.Color = C.Border; kStroke.Thickness = 1.5

TweenService:Create(kcard, TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {
    Size = UDim2.new(0,420,0,340),
    Position = UDim2.new(0.5,-210,0.5,-170),
}):Play()

-- Top line
local ktl = Instance.new("Frame", kcard)
ktl.Size = UDim2.new(1,0,0,2); ktl.BackgroundColor3 = C.Accent
ktl.BorderSizePixel = 0; ktl.ZIndex = 11

-- Title
local kTitle = Instance.new("TextLabel", kcard)
kTitle.Size = UDim2.new(1,0,0,50); kTitle.Position = UDim2.new(0,0,0,14)
kTitle.BackgroundTransparency = 1
kTitle.Text = "Tokyo Script  V1.0"
kTitle.TextColor3 = C.White; kTitle.Font = Enum.Font.GothamBold
kTitle.TextSize = 20; kTitle.ZIndex = 12

local kSub = Instance.new("TextLabel", kcard)
kSub.Size = UDim2.new(1,0,0,20); kSub.Position = UDim2.new(0,0,0,64)
kSub.BackgroundTransparency = 1
kSub.Text = "Inserisci la key per accedere"
kSub.TextColor3 = C.Dim; kSub.Font = Enum.Font.Gotham
kSub.TextSize = 12; kSub.ZIndex = 12

-- Input
local kInBg = Instance.new("Frame", kcard)
kInBg.Size = UDim2.new(0,340,0,42); kInBg.Position = UDim2.new(0.5,-170,0,98)
kInBg.BackgroundColor3 = C.Panel; kInBg.BorderSizePixel = 0; kInBg.ZIndex = 12
Instance.new("UICorner", kInBg).CornerRadius = UDim.new(0,8)
local kInStr = Instance.new("UIStroke", kInBg)
kInStr.Color = C.Border; kInStr.Thickness = 1.5

local kInput = Instance.new("TextBox", kInBg)
kInput.Size = UDim2.new(1,-14,1,0); kInput.Position = UDim2.new(0,7,0,0)
kInput.BackgroundTransparency = 1; kInput.Text = ""
kInput.PlaceholderText = "Incolla la tua key..."
kInput.PlaceholderColor3 = C.Dim; kInput.TextColor3 = C.Accent2
kInput.Font = Enum.Font.GothamBold; kInput.TextSize = 14
kInput.ClearTextOnFocus = false; kInput.ZIndex = 13

kInput.Focused:Connect(function()
    TweenService:Create(kInStr, TweenInfo.new(0.15), {Color=C.Accent}):Play()
end)
kInput.FocusLost:Connect(function()
    TweenService:Create(kInStr, TweenInfo.new(0.15), {Color=C.Border}):Play()
end)

-- Status
local kStatus = Instance.new("TextLabel", kcard)
kStatus.Size = UDim2.new(1,-40,0,16); kStatus.Position = UDim2.new(0,20,0,146)
kStatus.BackgroundTransparency = 1; kStatus.Text = ""
kStatus.TextColor3 = C.Dim; kStatus.Font = Enum.Font.Gotham
kStatus.TextSize = 11; kStatus.ZIndex = 12

local function KSetStatus(msg, col)
    kStatus.Text = msg; kStatus.TextColor3 = col or C.Dim
end

-- Login button
local kLogin = Instance.new("TextButton", kcard)
kLogin.Size = UDim2.new(0,220,0,42); kLogin.Position = UDim2.new(0.5,-110,0,170)
kLogin.BackgroundColor3 = C.Accent; kLogin.Text = "LOGIN"
kLogin.TextColor3 = C.White; kLogin.Font = Enum.Font.GothamBold
kLogin.TextSize = 15; kLogin.BorderSizePixel = 0; kLogin.ZIndex = 12
Instance.new("UICorner", kLogin).CornerRadius = UDim.new(0,10)

kLogin.MouseEnter:Connect(function()
    TweenService:Create(kLogin, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(100,190,255)}):Play()
end)
kLogin.MouseLeave:Connect(function()
    TweenService:Create(kLogin, TweenInfo.new(0.12), {BackgroundColor3=C.Accent}):Play()
end)

-- Get Key button
local kGetKey = Instance.new("TextButton", kcard)
kGetKey.Size = UDim2.new(0,110,0,32); kGetKey.Position = UDim2.new(1,-122,1,-44)
kGetKey.BackgroundColor3 = C.Discord; kGetKey.Text = "Get Key"
kGetKey.TextColor3 = C.White; kGetKey.Font = Enum.Font.GothamBold
kGetKey.TextSize = 13; kGetKey.BorderSizePixel = 0; kGetKey.ZIndex = 12
Instance.new("UICorner", kGetKey).CornerRadius = UDim.new(0,8)

-- Toast
local toast = Instance.new("Frame", KG)
toast.Size = UDim2.new(0,140,0,36)
toast.Position = UDim2.new(1,-154,1,10)
toast.BackgroundColor3 = C.Panel; toast.BorderSizePixel = 0
toast.ZIndex = 50; toast.BackgroundTransparency = 0.1
Instance.new("UICorner", toast).CornerRadius = UDim.new(0,8)
local toastLbl = Instance.new("TextLabel", toast)
toastLbl.Size = UDim2.new(1,0,1,0); toastLbl.BackgroundTransparency = 1
toastLbl.Text = "Copied Link"; toastLbl.TextColor3 = C.AccentG
toastLbl.Font = Enum.Font.GothamBold; toastLbl.TextSize = 13; toastLbl.ZIndex = 51

local toastBusy = false
local function ShowToast()
    if toastBusy then return end; toastBusy = true
    TweenService:Create(toast, TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {
        Position = UDim2.new(1,-154,1,-50)
    }):Play()
    task.delay(2.2, function()
        TweenService:Create(toast, TweenInfo.new(0.22), {Position=UDim2.new(1,-154,1,10)}):Play()
        task.wait(0.25); toastBusy = false
    end)
end

kGetKey.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD_INVITE) end)
    pcall(function() game:GetService("GuiService"):OpenBrowserWindow(DISCORD_INVITE) end)
    ShowToast()
end)

-- Shake on error
local function KShake()
    local orig = kcard.Position
    for i = 1, 5 do
        local dir = i%2==0 and 7 or -7
        TweenService:Create(kcard, TweenInfo.new(0.055), {
            Position = UDim2.new(orig.X.Scale, orig.X.Offset+dir, orig.Y.Scale, orig.Y.Offset)
        }):Play()
        task.wait(0.06)
    end
    TweenService:Create(kcard, TweenInfo.new(0.1), {Position=orig}):Play()
end

-- Welcome screen then launch
local function PlayWelcome()
    TweenService:Create(kcard, TweenInfo.new(0.35), {
        BackgroundTransparency=1, Position=UDim2.new(0.5,-210,0.5,-240)
    }):Play()
    TweenService:Create(kov, TweenInfo.new(0.4), {BackgroundTransparency=1}):Play()
    for _, f in ipairs(flakes) do
        TweenService:Create(f.l, TweenInfo.new(0.3), {TextTransparency=1}):Play()
    end
    task.wait(0.4)
    kcard:Destroy()

    local wCard = Instance.new("Frame", KG)
    wCard.Size = UDim2.new(0,0,0,0); wCard.Position = UDim2.new(0.5,0,0.5,0)
    wCard.BackgroundColor3 = C.Bg; wCard.BackgroundTransparency = 0.04
    wCard.BorderSizePixel = 0; wCard.ZIndex = 20; wCard.ClipsDescendants = true
    Instance.new("UICorner", wCard).CornerRadius = UDim.new(0,16)
    local ws = Instance.new("UIStroke", wCard); ws.Color = C.AccentG; ws.Thickness = 1.8

    TweenService:Create(wCard, TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out), {
        Size = UDim2.new(0,380,0,260),
        Position = UDim2.new(0.5,-190,0.5,-130),
    }):Play()
    task.wait(0.3)

    local wIcon = Instance.new("TextLabel", wCard)
    wIcon.Size = UDim2.new(1,0,0,60); wIcon.Position = UDim2.new(0,0,0,14)
    wIcon.BackgroundTransparency = 1; wIcon.Text = "OK"
    wIcon.TextColor3 = C.AccentG; wIcon.Font = Enum.Font.GothamBold
    wIcon.TextSize = 28; wIcon.ZIndex = 22

    local wWelcome = Instance.new("TextLabel", wCard)
    wWelcome.Size = UDim2.new(1,0,0,26); wWelcome.Position = UDim2.new(0,0,0,80)
    wWelcome.BackgroundTransparency = 1; wWelcome.Text = "Welcome,"
    wWelcome.TextColor3 = C.Dim; wWelcome.Font = Enum.Font.Gotham
    wWelcome.TextSize = 14; wWelcome.ZIndex = 22

    local wName = Instance.new("TextLabel", wCard)
    wName.Size = UDim2.new(1,-40,0,36); wName.Position = UDim2.new(0,20,0,106)
    wName.BackgroundTransparency = 1; wName.Text = USERNAME
    wName.TextColor3 = C.White; wName.Font = Enum.Font.GothamBold
    wName.TextSize = 28; wName.ZIndex = 22

    local wSub = Instance.new("TextLabel", wCard)
    wSub.Size = UDim2.new(1,0,0,18); wSub.Position = UDim2.new(0,0,0,148)
    wSub.BackgroundTransparency = 1; wSub.Text = "Tokyo Script V1.0  -  Accesso concesso"
    wSub.TextColor3 = C.Dim; wSub.Font = Enum.Font.Gotham
    wSub.TextSize = 11; wSub.ZIndex = 22

    local barBg = Instance.new("Frame", wCard)
    barBg.Size = UDim2.new(0,300,0,5); barBg.Position = UDim2.new(0.5,-150,0,185)
    barBg.BackgroundColor3 = C.Panel; barBg.BorderSizePixel = 0; barBg.ZIndex = 22
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1,0)
    local barFill = Instance.new("Frame", barBg)
    barFill.Size = UDim2.new(0,0,1,0); barFill.BackgroundColor3 = C.AccentG
    barFill.BorderSizePixel = 0; barFill.ZIndex = 23
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)

    local loadLbl = Instance.new("TextLabel", wCard)
    loadLbl.Size = UDim2.new(1,0,0,16); loadLbl.Position = UDim2.new(0,0,0,200)
    loadLbl.BackgroundTransparency = 1; loadLbl.Text = "Caricamento..."
    loadLbl.TextColor3 = C.Dim; loadLbl.Font = Enum.Font.Gotham
    loadLbl.TextSize = 10; loadLbl.ZIndex = 22

    TweenService:Create(barFill, TweenInfo.new(1.4,Enum.EasingStyle.Quad), {Size=UDim2.new(1,0,1,0)}):Play()

    task.delay(1.5, function()
        loadLbl.Text = "Script avviato!"; loadLbl.TextColor3 = C.AccentG
        task.wait(0.5)
        TweenService:Create(wCard, TweenInfo.new(0.4), {
            BackgroundTransparency=1, Position=UDim2.new(0.5,-190,0.5,-200)
        }):Play()
        task.wait(0.45)
        snowConn:Disconnect()
        KG:Destroy()
        -- AVVIA MENU PRINCIPALE
        OpenMenu()
    end)
end

-- Login logic
local function TryLogin()
    local key = kInput.Text:upper():gsub("%s","")
    if key == "" then KSetStatus("Inserisci una key", C.Red); task.spawn(KShake); return end
    KSetStatus("Verifica in corso...", C.Dim)
    kLogin.Text = "..."; kLogin.Active = false
    task.wait(0.7)
    if IsKeyValid(key) then
        SaveKey(key)
        PlayWelcome()
    else
        kLogin.Text = "LOGIN"; kLogin.Active = true
        KSetStatus("Key non valida - ottieni la key dal Discord", C.Red)
        TweenService:Create(kStroke, TweenInfo.new(0.12), {Color=C.Red}):Play()
        task.spawn(KShake)
        task.delay(0.5, function() TweenService:Create(kStroke, TweenInfo.new(0.35), {Color=C.Border}):Play() end)
    end
end

kInput.FocusLost:Connect(function(enter) if enter then TryLogin() end end)
kLogin.MouseButton1Click:Connect(TryLogin)

-- Auto login
task.spawn(function()
    task.wait(0.5)
    local saved = LoadKey()
    if IsKeyValid(saved) then
        KSetStatus("Key trovata - accesso automatico...", C.AccentG)
        kInput.Text = saved
        task.wait(0.9)
        PlayWelcome()
    end
end)

print("Tokyo Script V1.0 - Caricato!")
