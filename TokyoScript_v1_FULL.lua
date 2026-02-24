-- Tokyo Script V1.0 - All-in-One

-- --------------------------------------------------
-- SERVICES
-- --------------------------------------------------
local Players          = game:GetService("Players")
local ReplicatedStorage= game:GetService("ReplicatedStorage")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser      = game:GetService("VirtualUser")

local LP = Players.LocalPlayer
local USERNAME = LP.Name
local function GetChar()  return LP.Character end
local function GetRoot()  local c=GetChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function GetHum()   local c=GetChar(); return c and c:FindFirstChildOfClass("Humanoid") end

-- --------------------------------------------------
-- REMOTE FOLDERS (reali da logs)
-- --------------------------------------------------
local RE   = ReplicatedStorage:WaitForChild("RemoteEvents",   5)  -- RemoteEvents folder
local Rem  = ReplicatedStorage:WaitForChild("Remotes",        5)  -- Remotes folder
local AbSys= ReplicatedStorage:WaitForChild("AbilitySystem",  5)  -- AbilitySystem folder
local FrPS = nil
pcall(function() FrPS = ReplicatedStorage:WaitForChild("FruitPowerSystem",5) end)

-- Cerca sotto-cartelle nei Remotes
local function Sub(parent, name)
    if not parent then return nil end
    return parent:FindFirstChild(name)
end

-- --------------------------------------------------
-- REMOTE HELPERS
-- --------------------------------------------------
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

-- Shortcuts per le due cartelle principali
local function RE_Fire(n,...)  Fire(RE,  n,...) end
local function Rem_Fire(n,...) Fire(Rem, n,...) end

-- AbilitySystem
local AbRemotes = AbSys and AbSys:FindFirstChild("Remotes")
local function Ab_Fire(n,...) Fire(AbRemotes,n,...) end

-- --------------------------------------------------
-- CONFIG
-- --------------------------------------------------
local Cfg = {
    -- Player
    Speedhack=false, SpeedValue=80,
    InfinityJump=false,
    ESPPlayer=false,
    -- Haki
    AutoHaki=false,
    AutoObservation=false,
    AutoConqueror=false,
    -- Farm
    AutoFarm=false, SelectedMob="Thief [Lv.10]",
    FarmPosition="Behind",
    AutoFarmAll=false,
    AutoUseSkills=false,
    -- Boss
    AutoFarmBoss=false, SelectedBoss="Alucard",
    AutoSummonBoss=false, AutoKillSummon=false,
    SelectedSummonBoss="Slime",
    -- Auto Spawn
    AutoSpawnRimuru=false, AutoKillRimuru=false, DiffRimuru="Normal",
    AutoSpawnAnos=false,   AutoKillAnos=false,
    AutoSpawnStrongest=false, AutoKillStrongest=false,
    -- Quest
    AutoAcceptQuest=false,
    AutoCompleteQuest=false,
    AutoQuestFarm=false,
    -- Stats
    SelectedStat="Melee", StatAmount="1",
    AutoUpgradeStat=false,
    -- Dungeon
    SelectedDungeon="CidDungeon",
    AutoJoinDungeon=false,
    AutoJoinTeam=false,
    AutoRetry=false,
    AutoVote=false, SelectedDifficulty="Extreme",
    StartKill=false,
    -- Teleport
    SelectedIsland="BossIsland",
    SelectedNPC="AizenNpc",
    -- Craft
    AutoSlimeCraft=false,
    AutoGrailCraft=false,
    -- Misc
    AntiAFK=true,
    Theme="Dark",
    Transparency=true,
}

-- --------------------------------------------------
-- LOOP MANAGER
-- --------------------------------------------------
local Loops = {}
local function StopLoop(n) Loops[n]=false end
local function StartLoop(n,fn,t)
    StopLoop(n); Loops[n]=true
    task.spawn(function()
        while Loops[n] do
            pcall(fn); task.wait(t or 0.1)
        end
    end)
end

-- --------------------------------------------------
-- UTILITY
-- --------------------------------------------------
local function FindNearest(kw, maxD)
    maxD = maxD or 600
    local root=GetRoot(); if not root then return nil end
    local best,bd=nil,maxD
    for _,m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m.Name:lower():find(kw:lower()) and m~=GetChar() then
            local hum=m:FindFirstChildOfClass("Humanoid")
            local hr=m:FindFirstChild("HumanoidRootPart")
            if hum and hr and hum.Health>0 then
                local d=(root.Position-hr.Position).Magnitude
                if d<bd then best=m;bd=d end
            end
        end
    end
    return best
end

local function FindAnyMob(maxD)
    local root=GetRoot(); if not root then return nil end
    local best,bd=nil,maxD or 400
    for _,m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and m~=GetChar() then
            local hum=m:FindFirstChildOfClass("Humanoid")
            local hr=m:FindFirstChild("HumanoidRootPart")
            if hum and hr and hum.Health>0 and hum.MaxHealth>0 and hum.MaxHealth<1e9 then
                local d=(root.Position-hr.Position).Magnitude
                if d<bd then best=m;bd=d end
            end
        end
    end
    return best
end

local function TeleportTo(pos)
    local root=GetRoot()
    if root then root.CFrame=CFrame.new(pos+Vector3.new(0,4,0)) end
end

local function FireAllProx(kw)
    for _,pp in ipairs(workspace:GetDescendants()) do
        if pp:IsA("ProximityPrompt") and (pp.ActionText..pp.ObjectText):lower():find(kw:lower()) then
            pcall(function() fireproximityprompt(pp) end)
        end
    end
end

local function ClickGUI(kw)
    for _,b in ipairs(LP.PlayerGui:GetDescendants()) do
        if b:IsA("TextButton") and b.Text:lower():find(kw:lower()) then
            pcall(function()
                local p=b.AbsolutePosition+b.AbsoluteSize/2
                VirtualUser:Button1Down(p, workspace.CurrentCamera.CFrame)
                task.wait(0.05)
                VirtualUser:Button1Up(p, workspace.CurrentCamera.CFrame)
            end)
        end
    end
end

-- --------------------------------------------------
-- ATTACK
-- --------------------------------------------------
local function AttackTarget(target)
    if not target then return end
    local root=GetRoot(); local hum=GetHum()
    if not root or not hum or hum.Health<=0 then return end
    local hr=target:FindFirstChild("HumanoidRootPart"); if not hr then return end

    -- Posizionamento
    local off = Cfg.FarmPosition=="Behind"  and Vector3.new(0,0,4)
             or Cfg.FarmPosition=="Front"   and Vector3.new(0,0,-4)
             or Vector3.new(4,0,0)
    root.CFrame = CFrame.lookAt(hr.Position+off, hr.Position)

    -- CombatSystem.Remotes.RequestHit (REALE)
    local CombatRemotes = ReplicatedStorage:FindFirstChild("CombatSystem")
    if CombatRemotes then CombatRemotes=CombatRemotes:FindFirstChild("Remotes") end
    if CombatRemotes then Fire(CombatRemotes,"RequestHit",target) end

    -- CombatRemote in RemoteEvents
    RE_Fire("CombatRemote", target)

    -- AbilitySystem se abilitato
    if Cfg.AutoUseSkills then
        for slot=1,5 do
            Ab_Fire("RequestAbility", slot)
            task.wait(0.07)
        end
    end

    -- Tool equip + activate
    local char=GetChar()
    if char then
        local equipped=false
        for _,t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") then equipped=true
                pcall(function() t:Activate() end)
            end
        end
        if not equipped then
            local tool=LP.Backpack:FindFirstChildOfClass("Tool")
            if tool then tool.Parent=char end
        end
    end

    -- Click simulato
    pcall(function()
        local cam=workspace.CurrentCamera
        local vp=cam.ViewportSize
        VirtualUser:Button1Down(Vector2.new(vp.X/2,vp.Y/2),cam.CFrame)
        task.wait(0.04)
        VirtualUser:Button1Up(Vector2.new(vp.X/2,vp.Y/2),cam.CFrame)
    end)

    -- ProximityPrompt + ClickDetector sul target
    for _,v in ipairs(target:GetDescendants()) do
        if v:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(v) end) end
        if v:IsA("ClickDetector")   then pcall(function() fireclickdetector(v)   end) end
    end
end

-- --------------------------------------------------
-- FEATURE FUNCTIONS (Remote REALI)
-- --------------------------------------------------

-- SPEEDHACK
local function ApplySpeed(on)
    local h=GetHum(); if h then h.WalkSpeed=on and Cfg.SpeedValue or 16 end
end

-- INFINITY JUMP — MultiJumpRemote (REALE)
local ijConn
local function ToggleInfJump(on)
    if ijConn then ijConn:Disconnect(); ijConn=nil end
    if on then
        ijConn=UserInputService.JumpRequest:Connect(function()
            local h=GetHum()
            if h then
                h:ChangeState(Enum.HumanoidStateType.Jumping)
                RE_Fire("MultiJumpRemote") -- Remote REALE
            end
        end)
    end
end

-- SPRINT — SprintToggle (REALE)
local function DoSprint(on)
    RE_Fire("SprintToggle", on)
end

-- HAKI — HakiRemote + HakiStateUpdate (REALI)
local function DoHaki()
    RE_Fire("HakiRemote", true)
    RE_Fire("HakiStateUpdate", true)
end

-- OBSERVATION HAKI — ObservationHakiRemote + ObservationHakiStateUpdate (REALI)
local function DoObservation()
    RE_Fire("ObservationHakiRemote", true)
    RE_Fire("ObservationHakiStateUpdate", true)
end

-- CONQUEROR HAKI — ConquerorHakiRemote in RemoteEvents + Remotes (REALI)
local function DoConqueror()
    RE_Fire("ConquerorHakiRemote", true)
    Rem_Fire("ConquerorHakiRemote", true)
    Rem_Fire("ConqHakiProgressionUpdate")
end

-- QUEST — QuestAccept + QuestComplete (REALI)
local function DoAcceptQuest()
    RE_Fire("QuestAccept")
    FireAllProx("accept"); FireAllProx("quest")
    ClickGUI("accept")
end
local function DoCompleteQuest()
    RE_Fire("QuestComplete")
    RE_Fire("QuestRepeat")
    ClickGUI("complete"); ClickGUI("claim"); ClickGUI("finish")
end

-- STAT — AllocateStat in RemoteEvents + AllocateStats in Remotes (REALI)
local function DoAllocateStat()
    local amt = tonumber(Cfg.StatAmount) or 1
    RE_Fire("AllocateStat",   Cfg.SelectedStat, amt)
    Rem_Fire("AllocateStats", Cfg.SelectedStat, amt)
end

-- EQUIP WEAPON — EquipWeapon in Remotes (REALE)
local function DoEquipWeapon(name)
    Rem_Fire("EquipWeapon", name or Cfg.SelectedWeapon)
    -- anche dal backpack
    local char=GetChar(); if not char then return end
    for _,t in ipairs(LP.Backpack:GetChildren()) do
        if t:IsA("Tool") and t.Name:lower():find((name or Cfg.SelectedWeapon):lower()) then
            t.Parent=char; break
        end
    end
end

-- SUMMON BOSS — RequestSummonBoss in Remotes (REALE)
local function DoSummonBoss(bossName, diff)
    Rem_Fire("RequestSummonBoss", bossName, diff or "Normal")
    Rem_Fire("OpenSummonUI")
end

-- RIMURU — RequestAutoSpawnRimuru + AutoSpawnRimuruUpdate (REALI in RemoteEvents)
local function DoSpawnRimuru()
    RE_Fire("RequestAutoSpawnRimuru", Cfg.DiffRimuru)
    RE_Fire("AutoSpawnRimuruUpdate")
    -- anche in Remotes
    Rem_Fire("RequestSpawnRimuru", Cfg.DiffRimuru)
end

-- ANOS — RequestAutoSpawnAnos in Remotes (REALE)
local function DoSpawnAnos()
    Rem_Fire("RequestAutoSpawnAnos")
    Rem_Fire("AutoSpawnAnosUpdate")
end

-- STRONGEST BOSS — RequestAutoSpawn + RequestAutoSpawnStrongest (REALI in Remotes)
local function DoSpawnStrongest()
    Rem_Fire("RequestAutoSpawn")
    Rem_Fire("RequestAutoSpawnStrongest")
    Rem_Fire("AutoSpawnUpdate")
    Rem_Fire("AutoSpawnStrongestUpdate")
end

-- SLIME CRAFT — RequestSlimeCraft in Remotes + OpenSlimeCraftUI in RemoteEvents (REALI)
local function DoSlimeCraft()
    local RemotesFolder = Rem
    Invoke(RemotesFolder,"RequestSlimeCraft")
    RE_Fire("OpenSlimeCraftUI")
    RE_Fire("SlimeCraftUpdate")
    FireAllProx("craft"); FireAllProx("slime")
end

-- GRAIL CRAFT — RequestGrailCraft in Remotes + OpenGrailCraftUI in RemoteEvents (REALI)
local function DoGrailCraft()
    Invoke(Rem,"RequestGrailCraft")
    RE_Fire("OpenGrailCraftUI")
    FireAllProx("grail"); FireAllProx("craft")
end

-- DUNGEON — JoinDungeonPortal + RequestDungeonPortal in Remotes (REALI)
local function DoJoinDungeon()
    Rem_Fire("JoinDungeonPortal",    Cfg.SelectedDungeon)
    Rem_Fire("RequestDungeonPortal", Cfg.SelectedDungeon)
    Rem_Fire("DungeonQuestAccept")
    FireAllProx("dungeon"); FireAllProx("join")
    ClickGUI("join")
end

-- DUNGEON VOTE — DungeonWaveVote in Remotes (REALE)
local function DoDungeonVote()
    Rem_Fire("DungeonWaveVote", Cfg.SelectedDifficulty)
    ClickGUI(Cfg.SelectedDifficulty)
end

-- TELEPORT — TeleportToPortal in Remotes (REALE)
local IslandPos = {
    BossIsland       = Vector3.new(0,100,0),
    DesertIsland     = Vector3.new(1000,100,0),
    DungeonIsland    = Vector3.new(-1000,100,0),
    HuecoMundoIsland = Vector3.new(0,100,1000),
    JungleIsland     = Vector3.new(0,100,-1000),
    SailorIsland     = Vector3.new(500,100,500),
    ShibuyaDestroyed = Vector3.new(-500,100,500),
    ShibuyaStation   = Vector3.new(-500,100,-500),
    SlimeIsland      = Vector3.new(500,100,-500),
    SnowIsland       = Vector3.new(1500,100,0),
    StarterIsland    = Vector3.new(-1500,100,0),
}
local function DoTeleportIsland(name)
    Rem_Fire("TeleportToPortal", name)
    Rem_Fire("OpenTeleportUI")
    task.wait(0.5)
    for _,v in ipairs(workspace:GetDescendants()) do
        if v.Name==name or v.Name:lower():find(name:lower():gsub("island","")) then
            local pos=(v:IsA("BasePart") and v.Position) or (v.PrimaryPart and v.PrimaryPart.Position)
            if pos then TeleportTo(pos); return end
        end
    end
    local pos=IslandPos[name]; if pos then TeleportTo(pos) end
end

local function DoTeleportNPC(name)
    local kw=name:lower():gsub("npc",""):gsub("boss","")
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find(kw) then
            local hr=v:FindFirstChild("HumanoidRootPart")
            if hr then TeleportTo(hr.Position+Vector3.new(0,0,4)); return end
        end
    end
end

-- ANTI AFK
local function StartAntiAFK()
    StartLoop("AntiAFK",function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end,55)
end

-- --------------------------------------------------
-- ESP
-- --------------------------------------------------
local ESPGui=Instance.new("ScreenGui")
ESPGui.Name="TokyoScript_ESP"; ESPGui.ResetOnSpawn=false
if not pcall(function() ESPGui.Parent=game:GetService("CoreGui") end) then
    ESPGui.Parent=LP.PlayerGui
end

local function ClearESP() ESPGui:ClearAllChildren() end
local function MakeESP(player)
    if player==LP then return end
    local function build()
        local c=player.Character; if not c then return end
        local head=c:FindFirstChild("Head"); if not head then return end
        local old=ESPGui:FindFirstChild("ESP_"..player.Name); if old then old:Destroy() end
        local bb=Instance.new("BillboardGui",ESPGui)
        bb.Name="ESP_"..player.Name; bb.Adornee=head
        bb.Size=UDim2.new(0,140,0,50); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true
        local lbl=Instance.new("TextLabel",bb)
        lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=13
        lbl.TextStrokeTransparency=0; lbl.TextColor3=Color3.fromRGB(0,200,255)
        lbl.Text=player.Name
        RunService.Heartbeat:Connect(function()
            if not bb or not bb.Parent then return end
            local r=GetRoot(); local pr=c:FindFirstChild("HumanoidRootPart")
            if r and pr then
                lbl.Text=player.Name.."\n❄ ["..math.floor((r.Position-pr.Position).Magnitude).."m]"
            end
        end)
    end
    build()
    player.CharacterAdded:Connect(function() task.wait(1); build() end)
end
local function UpdateESP()
    ClearESP()
    if Cfg.ESPPlayer then for _,p in ipairs(Players:GetPlayers()) do MakeESP(p) end end
end

-- --------------------------------------------------
-- GUI SETUP
-- --------------------------------------------------
pcall(function() game:GetService("CoreGui"):FindFirstChild("TokyoScript_GUI") and game:GetService("CoreGui").TokyoScript_GUI:Destroy() end)
pcall(function() LP.PlayerGui:FindFirstChild("TokyoScript_GUI") and LP.PlayerGui.TokyoScript_GUI:Destroy() end)

local SG=Instance.new("ScreenGui")
SG.Name="TokyoScript_GUI"; SG.ResetOnSpawn=false; SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
if not pcall(function() SG.Parent=game:GetService("CoreGui") end) then SG.Parent=LP.PlayerGui end

-- --------------------------------------------------
-- PALETTE COLORI — tema Navy Ice
-- --------------------------------------------------
local C={
    Bg      = Color3.fromRGB(6, 9, 20),
    Side    = Color3.fromRGB(4, 7, 16),
    Panel   = Color3.fromRGB(10, 14, 28),
    Row1    = Color3.fromRGB(14, 18, 34),
    Row2    = Color3.fromRGB(9,  12, 25),
    Hover   = Color3.fromRGB(20, 26, 52),
    Accent  = Color3.fromRGB(80, 170, 255),
    Accent2 = Color3.fromRGB(140, 205, 255),
    AccentG = Color3.fromRGB(80, 230, 140),   -- verde per stato attivo
    Border  = Color3.fromRGB(25, 40, 80),
    Text    = Color3.fromRGB(200, 215, 250),
    Dim     = Color3.fromRGB(90,  110, 160),
    White   = Color3.fromRGB(255, 255, 255),
    TOn     = Color3.fromRGB(60,  150, 255),
    TOff    = Color3.fromRGB(30,   40,  70),
    Gold    = Color3.fromRGB(255, 200, 60),
    Red     = Color3.fromRGB(255,  70, 70),
}

-- --------------------------------------------------
-- SNOW INTRO
-- --------------------------------------------------
local function PlaySnowIntro()
    local intro=Instance.new("Frame",SG)
    intro.Size=UDim2.new(1,0,1,0); intro.BackgroundTransparency=1; intro.ZIndex=200

    local syms={"❄","❅","❆","·","*","◦"}
    local flakes={}
    for i=1,55 do
        local l=Instance.new("TextLabel",intro)
        l.BackgroundTransparency=1; l.ZIndex=201
        l.Font=Enum.Font.GothamBold; l.TextSize=math.random(9,26)
        l.Text=syms[math.random(#syms)]
        l.TextColor3=Color3.fromRGB(math.random(170,255),math.random(200,255),255)
        l.TextTransparency=math.random(0,4)/10
        l.Size=UDim2.new(0,28,0,28)
        local sx=math.random(0,100)/100
        l.Position=UDim2.new(sx,0,-0.05,0)
        table.insert(flakes,{l=l,x=sx,spd=math.random(8,20)/10,dr=math.random(-3,3)/100,rot=math.random(-2,2)})
    end

    local title=Instance.new("TextLabel",intro)
    title.Size=UDim2.new(1,0,0,70); title.Position=UDim2.new(0,0,0.36,0)
    title.BackgroundTransparency=1; title.Text="👺  !Tokyo Script  👺"
    title.TextColor3=C.White; title.Font=Enum.Font.GothamBold; title.TextSize=30
    title.TextTransparency=1; title.ZIndex=202

    local sub=Instance.new("TextLabel",intro)
    sub.Size=UDim2.new(1,0,0,28); sub.Position=UDim2.new(0,0,0.53,0)
    sub.BackgroundTransparency=1; sub.Text="👺 !Tokyo Script V1.0"
    sub.TextColor3=C.Accent; sub.Font=Enum.Font.Gotham; sub.TextSize=15
    sub.TextTransparency=1; sub.ZIndex=202

    task.spawn(function()
        task.wait(0.3)
        TweenService:Create(title,TweenInfo.new(0.7),{TextTransparency=0}):Play()
        task.wait(0.2)
        TweenService:Create(sub,TweenInfo.new(0.5),{TextTransparency=0}):Play()
    end)

    local t=0; local conn
    conn=RunService.Heartbeat:Connect(function(dt)
        t=t+dt
        for _,f in ipairs(flakes) do
            local ny=-0.05+(t*f.spd*0.12)
            local nx=f.x+math.sin(t*f.rot+f.x*10)*0.007
            f.l.Position=UDim2.new(nx,0,ny,0)
            f.l.Rotation=t*f.rot*30
        end
    end)

    task.delay(2.8,function()
        TweenService:Create(title,TweenInfo.new(0.4),{TextTransparency=1}):Play()
        TweenService:Create(sub,  TweenInfo.new(0.4),{TextTransparency=1}):Play()
        task.wait(0.35)
        for _,f in ipairs(flakes) do
            TweenService:Create(f.l,TweenInfo.new(0.35),{TextTransparency=1}):Play()
        end
        task.wait(0.4); conn:Disconnect(); intro:Destroy()
    end)
end

-- --------------------------------------------------
-- MAIN FRAME
-- --------------------------------------------------
local MF=Instance.new("Frame",SG)
MF.Name="MainFrame"
MF.Size=UDim2.new(0,660,0,460)
MF.Position=UDim2.new(0.5,-330,0.5,-230)
MF.BackgroundColor3=C.Bg
MF.BackgroundTransparency=0.06
MF.BorderSizePixel=0; MF.ClipsDescendants=true; MF.Visible=false
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,14)
local mStroke=Instance.new("UIStroke",MF)
mStroke.Color=C.Border; mStroke.Thickness=1.5

-- TITLEBAR
local TB=Instance.new("Frame",MF)
TB.Size=UDim2.new(1,0,0,32); TB.BackgroundColor3=C.Side
TB.BackgroundTransparency=0.04; TB.BorderSizePixel=0; TB.ZIndex=10
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,14)
local tbFix=Instance.new("Frame",TB)
tbFix.Size=UDim2.new(1,0,0,14); tbFix.Position=UDim2.new(0,0,1,-14)
tbFix.BackgroundColor3=C.Side; tbFix.BackgroundTransparency=0.04; tbFix.BorderSizePixel=0

local tbGrad=Instance.new("UIGradient",TB)
tbGrad.Color=ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(6,10,24)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(14,20,44)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(6,10,24)),
})

local TBL=Instance.new("TextLabel",TB)
TBL.Size=UDim2.new(1,-80,1,0); TBL.Position=UDim2.new(0,14,0,0)
TBL.BackgroundTransparency=1
TBL.Text="👺 !Tokyo Script  ·  V1.0"
TBL.TextColor3=C.Dim; TBL.Font=Enum.Font.GothamBold
TBL.TextSize=11; TBL.TextXAlignment=Enum.TextXAlignment.Left; TBL.ZIndex=11

-- Window buttons
local function WBtn(col,ox)
    local b=Instance.new("TextButton",TB)
    b.Size=UDim2.new(0,13,0,13); b.Position=UDim2.new(1,ox,0.5,-6.5)
    b.BackgroundColor3=col; b.Text=""; b.BorderSizePixel=0; b.ZIndex=12
    Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
    return b
end
WBtn(C.Red,-22).MouseButton1Click:Connect(function() SG:Destroy() end)
WBtn(C.Gold,-42).MouseButton1Click:Connect(function() MF.Visible=not MF.Visible end)

-- Drag
local drag,ds,sp=false
TB.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;ds=i.Position;sp=MF.Position end
end)
TB.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end
end)
UserInputService.InputChanged:Connect(function(i)
    if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-ds
        MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
    end
end)
UserInputService.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.LeftControl then MF.Visible=not MF.Visible end
end)

-- SIDEBAR
local SB=Instance.new("Frame",MF)
SB.Size=UDim2.new(0,138,1,-32); SB.Position=UDim2.new(0,0,0,32)
SB.BackgroundColor3=C.Side; SB.BackgroundTransparency=0.04; SB.BorderSizePixel=0
Instance.new("UIListLayout",SB).SortOrder=Enum.SortOrder.LayoutOrder

-- Separatore
local sep=Instance.new("Frame",MF)
sep.Size=UDim2.new(0,1,1,-32); sep.Position=UDim2.new(0,138,0,32)
sep.BackgroundColor3=C.Border; sep.BorderSizePixel=0

-- Logo sidebar in alto
local logo=Instance.new("TextLabel",SB)
logo.Size=UDim2.new(1,0,0,44); logo.BackgroundTransparency=1
logo.Text="👺\n!Tokyo"; logo.TextColor3=C.Accent; logo.Font=Enum.Font.GothamBold
logo.TextSize=12; logo.LayoutOrder=0

-- CONTENT AREA
local CA=Instance.new("ScrollingFrame",MF)
CA.Size=UDim2.new(1,-139,1,-32); CA.Position=UDim2.new(0,139,0,32)
CA.BackgroundColor3=C.Bg; CA.BackgroundTransparency=0.06; CA.BorderSizePixel=0
CA.ScrollBarThickness=3; CA.ScrollBarImageColor3=C.Accent
CA.CanvasSize=UDim2.new(0,0,0,0); CA.AutomaticCanvasSize=Enum.AutomaticSize.Y
local CAL=Instance.new("UIListLayout",CA)
CAL.SortOrder=Enum.SortOrder.LayoutOrder; CAL.Padding=UDim.new(0,2)
local CAP=Instance.new("UIPadding",CA)
CAP.PaddingTop=UDim.new(0,10); CAP.PaddingLeft=UDim.new(0,12)
CAP.PaddingRight=UDim.new(0,16); CAP.PaddingBottom=UDim.new(0,12)

-- --------------------------------------------------
-- PAGE SYSTEM
-- --------------------------------------------------
local Pages,CurPage,RowIdx={},nil,0
local function NewPage(name)
    local f=Instance.new("Frame",CA)
    f.Name=name; f.Size=UDim2.new(1,0,0,0)
    f.AutomaticSize=Enum.AutomaticSize.Y
    f.BackgroundTransparency=1; f.Visible=false
    local l=Instance.new("UIListLayout",f)
    l.SortOrder=Enum.SortOrder.LayoutOrder; l.Padding=UDim.new(0,2)
    Pages[name]=f; return f
end
local function ShowPage(name)
    if CurPage and Pages[CurPage] then Pages[CurPage].Visible=false end
    CurPage=name; if Pages[name] then Pages[name].Visible=true end
    CA.CanvasPosition=Vector2.new(0,0)
end

-- --------------------------------------------------
-- SIDEBAR BUTTONS
-- --------------------------------------------------
local SBBtns={}
local function SideBtn(label,icon,page,order)
    local btn=Instance.new("TextButton",SB)
    btn.Size=UDim2.new(1,0,0,40); btn.BackgroundColor3=C.Side
    btn.BackgroundTransparency=1; btn.BorderSizePixel=0; btn.Text=""; btn.LayoutOrder=order

    local bar=Instance.new("Frame",btn)
    bar.Size=UDim2.new(0,3,0.65,0); bar.Position=UDim2.new(0,0,0.175,0)
    bar.BackgroundColor3=C.Accent; bar.BorderSizePixel=0; bar.Visible=false
    Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)

    local ico=Instance.new("TextLabel",btn)
    ico.Size=UDim2.new(0,26,1,0); ico.Position=UDim2.new(0,10,0,0)
    ico.BackgroundTransparency=1; ico.Text=icon
    ico.TextColor3=C.Dim; ico.Font=Enum.Font.GothamBold; ico.TextSize=15

    local txt=Instance.new("TextLabel",btn)
    txt.Size=UDim2.new(1,-40,1,0); txt.Position=UDim2.new(0,38,0,0)
    txt.BackgroundTransparency=1; txt.Text=label
    txt.TextColor3=C.Dim; txt.Font=Enum.Font.Gotham; txt.TextSize=12
    txt.TextXAlignment=Enum.TextXAlignment.Left

    btn.MouseEnter:Connect(function()
        if CurPage~=page then TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=0.7}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if CurPage~=page then TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundTransparency=1}):Play() end
    end)
    btn.MouseButton1Click:Connect(function()
        for _,b in pairs(SBBtns) do
            b.btn.BackgroundColor3=C.Side; b.btn.BackgroundTransparency=1
            b.bar.Visible=false; b.ico.TextColor3=C.Dim; b.txt.TextColor3=C.Dim
        end
        btn.BackgroundColor3=C.Panel; btn.BackgroundTransparency=0.35
        bar.Visible=true; ico.TextColor3=C.Accent; txt.TextColor3=C.White
        ShowPage(page)
    end)
    table.insert(SBBtns,{btn=btn,bar=bar,ico=ico,txt=txt,page=page})
end

-- --------------------------------------------------
-- WIDGET HELPERS
-- --------------------------------------------------
local function NextRow() RowIdx=RowIdx+1; return RowIdx%2==0 and C.Row1 or C.Row2 end

local function MkTitle(parent,text)
    local l=Instance.new("TextLabel",parent)
    l.Size=UDim2.new(1,0,0,38); l.BackgroundTransparency=1
    l.Text=text; l.TextColor3=C.White; l.Font=Enum.Font.GothamBold; l.TextSize=18
    l.TextXAlignment=Enum.TextXAlignment.Left; l.LayoutOrder=0
end

local function MkSect(parent,text)
    RowIdx=RowIdx+1
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,28); f.BackgroundTransparency=1; f.LayoutOrder=RowIdx
    local line=Instance.new("Frame",f)
    line.Size=UDim2.new(1,0,0,1); line.Position=UDim2.new(0,0,1,-1)
    line.BackgroundColor3=C.Border; line.BorderSizePixel=0
    local g=Instance.new("UIGradient",line)
    g.Color=ColorSequence.new({
        ColorSequenceKeypoint.new(0,C.Accent),
        ColorSequenceKeypoint.new(0.6,C.Border),
        ColorSequenceKeypoint.new(1,C.Bg),
    })
    local lbl=Instance.new("TextLabel",f)
    lbl.Size=UDim2.new(1,0,1,-4); lbl.Position=UDim2.new(0,0,0,0)
    lbl.BackgroundTransparency=1; lbl.Text="❄ "..text
    lbl.TextColor3=C.Accent2; lbl.Font=Enum.Font.GothamBold; lbl.TextSize=10
    lbl.TextXAlignment=Enum.TextXAlignment.Left
    local p=Instance.new("UIPadding",lbl); p.PaddingTop=UDim.new(0,10)
end

-- TOGGLE
local function MkToggle(parent,label,cfgKey,cb)
    RowIdx=RowIdx+1; local bg=NextRow()
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=bg
    row.BorderSizePixel=0; row.LayoutOrder=RowIdx
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

    local lb=Instance.new("TextLabel",row)
    lb.Size=UDim2.new(1,-62,1,0); lb.Position=UDim2.new(0,12,0,0)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C.Text
    lb.Font=Enum.Font.Gotham; lb.TextSize=12; lb.TextXAlignment=Enum.TextXAlignment.Left

    local tbg=Instance.new("Frame",row)
    tbg.Size=UDim2.new(0,40,0,22); tbg.Position=UDim2.new(1,-52,0.5,-11)
    tbg.BackgroundColor3=Cfg[cfgKey] and C.TOn or C.TOff; tbg.BorderSizePixel=0
    Instance.new("UICorner",tbg).CornerRadius=UDim.new(1,0)
    local tStr=Instance.new("UIStroke",tbg); tStr.Color=Cfg[cfgKey] and C.Accent or C.TOff; tStr.Thickness=1

    local kn=Instance.new("Frame",tbg); kn.Size=UDim2.new(0,18,0,18)
    kn.Position=Cfg[cfgKey] and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)
    kn.BackgroundColor3=C.White; kn.BorderSizePixel=0
    Instance.new("UICorner",kn).CornerRadius=UDim.new(1,0)

    -- Badge "ON" lampeggiante
    local badge=Instance.new("TextLabel",row)
    badge.Size=UDim2.new(0,26,0,14); badge.Position=UDim2.new(1,-90,0.5,-7)
    badge.BackgroundColor3=C.AccentG; badge.Text="ON"; badge.TextColor3=C.White
    badge.Font=Enum.Font.GothamBold; badge.TextSize=8; badge.BorderSizePixel=0
    badge.BackgroundTransparency=1
    Instance.new("UICorner",badge).CornerRadius=UDim.new(0,4)
    badge.Visible=Cfg[cfgKey] or false

    local ti=TweenInfo.new(0.16,Enum.EasingStyle.Quad)
    local function Set(v)
        Cfg[cfgKey]=v
        TweenService:Create(tbg,ti,{BackgroundColor3=v and C.TOn or C.TOff}):Play()
        TweenService:Create(tStr,ti,{Color=v and C.Accent or C.TOff}):Play()
        TweenService:Create(kn,ti,{Position=v and UDim2.new(1,-20,0.5,-9) or UDim2.new(0,2,0.5,-9)}):Play()
        TweenService:Create(lb,ti,{TextColor3=v and C.White or C.Text}):Play()
        badge.Visible=v
        if cb then cb(v) end
    end

    local clk=Instance.new("TextButton",row)
    clk.Size=UDim2.new(1,0,1,0); clk.BackgroundTransparency=1; clk.Text=""
    clk.MouseButton1Click:Connect(function() Set(not Cfg[cfgKey]) end)
    clk.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.Hover}):Play() end)
    clk.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=bg}):Play() end)
end

-- DROPDOWN
local function MkDropdown(parent,label,opts,cfgKey,cb)
    RowIdx=RowIdx+1; local bg=NextRow()
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,36); row.BackgroundColor3=bg
    row.BorderSizePixel=0; row.LayoutOrder=RowIdx; row.ClipsDescendants=false
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

    local lb=Instance.new("TextLabel",row)
    lb.Size=UDim2.new(0.44,0,1,0); lb.Position=UDim2.new(0,12,0,0)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C.Text
    lb.Font=Enum.Font.Gotham; lb.TextSize=12; lb.TextXAlignment=Enum.TextXAlignment.Left

    local sel=Instance.new("TextButton",row)
    sel.Size=UDim2.new(0.49,0,0,26); sel.Position=UDim2.new(0.5,-2,0.5,-13)
    sel.BackgroundColor3=C.Panel; sel.Text=tostring(Cfg[cfgKey])
    sel.TextColor3=C.Accent; sel.Font=Enum.Font.GothamBold; sel.TextSize=11
    sel.BorderSizePixel=0; sel.ZIndex=5
    Instance.new("UICorner",sel).CornerRadius=UDim.new(0,5)
    Instance.new("UIStroke",sel).Color=C.Border

    local arrow=Instance.new("TextLabel",sel)
    arrow.Size=UDim2.new(0,14,1,0); arrow.Position=UDim2.new(1,-16,0,0)
    arrow.BackgroundTransparency=1; arrow.Text="▾"; arrow.TextColor3=C.Accent
    arrow.Font=Enum.Font.GothamBold; arrow.TextSize=11

    local dl=Instance.new("Frame",row)
    dl.Size=UDim2.new(0.49,0,0,math.min(#opts,6)*27)
    dl.Position=UDim2.new(0.5,-2,1,4)
    dl.BackgroundColor3=C.Panel; dl.BorderSizePixel=0; dl.Visible=false; dl.ZIndex=60
    Instance.new("UICorner",dl).CornerRadius=UDim.new(0,6)
    Instance.new("UIStroke",dl).Color=C.Border
    Instance.new("UIListLayout",dl).SortOrder=Enum.SortOrder.LayoutOrder

    for i,opt in ipairs(opts) do
        local ob=Instance.new("TextButton",dl)
        ob.Size=UDim2.new(1,0,0,27); ob.BackgroundColor3=C.Panel
        ob.Text=" "..opt; ob.TextColor3=C.Text; ob.Font=Enum.Font.Gotham
        ob.TextSize=11; ob.BorderSizePixel=0; ob.ZIndex=61; ob.LayoutOrder=i
        ob.TextXAlignment=Enum.TextXAlignment.Left
        ob.MouseEnter:Connect(function() ob.BackgroundColor3=C.Hover; ob.TextColor3=C.White end)
        ob.MouseLeave:Connect(function() ob.BackgroundColor3=C.Panel; ob.TextColor3=C.Text end)
        ob.MouseButton1Click:Connect(function()
            Cfg[cfgKey]=opt; sel.Text=opt; dl.Visible=false; arrow.Text="▾"
            if cb then cb(opt) end
        end)
    end
    sel.MouseButton1Click:Connect(function()
        dl.Visible=not dl.Visible; arrow.Text=dl.Visible and "▴" or "▾"
    end)
end

-- BUTTON
local function MkBtn(parent,label,sub,cb)
    RowIdx=RowIdx+1; local h=sub and 48 or 36; local bg=NextRow()
    local row=Instance.new("TextButton",parent)
    row.Size=UDim2.new(1,0,0,h); row.BackgroundColor3=bg
    row.BorderSizePixel=0; row.Text=""; row.LayoutOrder=RowIdx
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,6)

    local lb=Instance.new("TextLabel",row)
    lb.Size=UDim2.new(1,-32,0,20); lb.Position=UDim2.new(0,12,0,sub and 7 or 8)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C.Text
    lb.Font=Enum.Font.Gotham; lb.TextSize=12; lb.TextXAlignment=Enum.TextXAlignment.Left

    if sub then
        local sl=Instance.new("TextLabel",row)
        sl.Size=UDim2.new(1,-32,0,14); sl.Position=UDim2.new(0,12,0,27)
        sl.BackgroundTransparency=1; sl.Text=sub; sl.TextColor3=C.Dim
        sl.Font=Enum.Font.Gotham; sl.TextSize=10; sl.TextXAlignment=Enum.TextXAlignment.Left
    end

    local ar=Instance.new("TextLabel",row)
    ar.Size=UDim2.new(0,22,1,0); ar.Position=UDim2.new(1,-28,0,0)
    ar.BackgroundTransparency=1; ar.Text="›"; ar.TextColor3=C.Accent
    ar.Font=Enum.Font.GothamBold; ar.TextSize=22

    row.MouseButton1Click:Connect(function()
        TweenService:Create(row,TweenInfo.new(0.07),{BackgroundColor3=C.Accent}):Play()
        task.delay(0.07,function() TweenService:Create(row,TweenInfo.new(0.15),{BackgroundColor3=bg}):Play() end)
        if cb then cb() end
    end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=C.Hover}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.1),{BackgroundColor3=bg}):Play() end)
end

-- --------------------------------------------------
-- ██ PAGINE ██
-- --------------------------------------------------

-- ┌─────────────── MAIN ───────────────┐
local PM=NewPage("Main"); MkTitle(PM,"Main")
MkSect(PM,"Player")
MkToggle(PM,"Speedhack","Speedhack",function(v)
    ApplySpeed(v)
    if v then StartLoop("Speed",function() ApplySpeed(true) end,1)
    else StopLoop("Speed"); ApplySpeed(false) end
end)
MkToggle(PM,"Infinity Jump","InfinityJump",function(v) ToggleInfJump(v) end)
MkToggle(PM,"Sprint Toggle","SprintOn",function(v) DoSprint(v) end)
MkToggle(PM,"ESP Player","ESPPlayer",function() UpdateESP() end)

MkSect(PM,"Haki  (Remote REALI)")
MkToggle(PM,"Auto Haki  [HakiRemote]","AutoHaki",function(v)
    if v then StartLoop("Haki",DoHaki,3) else StopLoop("Haki") end
end)
MkToggle(PM,"Auto Observation  [ObservationHakiRemote]","AutoObservation",function(v)
    if v then StartLoop("Obs",DoObservation,3) else StopLoop("Obs") end
end)
MkToggle(PM,"Auto Conqueror Haki  [ConquerorHakiRemote]","AutoConqueror",function(v)
    if v then StartLoop("Conq",DoConqueror,3) else StopLoop("Conq") end
end)

-- ┌─────────────── AUTO FARM ───────────────┐
local PAF=NewPage("AutoFarm"); MkTitle(PAF,"Auto Farm")
MkSect(PAF,"Weapon  [EquipWeapon]")
MkDropdown(PAF,"Select Weapon",{"Combat","Sword","Gun","Fruit","None"},"SelectedWeapon")
MkBtn(PAF,"Equip Weapon Now","Equip dal backpack + EquipWeapon Remote",function()
    DoEquipWeapon()
end)

MkSect(PAF,"Mob Farm  [CombatSystem.RequestHit]")
MkDropdown(PAF,"Select Mob",{
    "Thief [Lv.10]",
    "Thief Boss [Lv.25]",
    "Monkey [Lv.250]",
    "Monkey Boss [Lv.500]",
    "Desert Bandit [Lv.750]",
    "Desert Boss [Lv.1000]",
    "Frost Rogue [Lv.1500]",
    "Snow Boss [Lv.2000]",
    "Sorcerer Student [Lv.3000]",
    "Panda Boss [Lv.4000]",
    "Hollow [Lv.5000]",
    "Strong Sorcerer [Lv.6000]",
    "Curse [Lv.7000]",
    "Slime [Lv.8000]",
    "Academy Teacher [Lv.9000]",
},"SelectedMob")
MkDropdown(PAF,"Farm Position",{"Behind","Front","Side"},"FarmPosition")
MkToggle(PAF,"Auto Farm Mob","AutoFarm",function(v)
    if v then
        StartLoop("Farm",function()
            local kw=Cfg.SelectedMob:gsub("%s*%[.*%]",""):gsub("%s+$",""); local m=FindNearest(kw)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("Farm") end
end)
MkToggle(PAF,"Auto Farm ALL Mobs","AutoFarmAll",function(v)
    if v then
        StartLoop("FarmAll",function()
            local m=FindAnyMob()
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("FarmAll") end
end)

MkSect(PAF,"Skills  [AbilitySystem.RequestAbility]")
MkToggle(PAF,"Auto Use Skills (Z X C V F)","AutoUseSkills")
MkBtn(PAF,"Use Skills Once","Usa tutte le ability ora",function()
    for slot=1,5 do
        Ab_Fire("RequestAbility",slot)
        task.wait(0.08)
    end
end)

MkSect(PAF,"Boss Farm")
MkDropdown(PAF,"Select Boss",{"Alucard","Gojo","Rimuru","Gilgamesh","Valentine","Anos","Slime"},"SelectedBoss")
MkToggle(PAF,"Auto Farm Boss","AutoFarmBoss",function(v)
    if v then
        StartLoop("FarmBoss",function()
            local m=FindNearest(Cfg.SelectedBoss,2000)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("FarmBoss") end
end)

MkSect(PAF,"Summon Farm  [RequestSummonBoss]")
MkDropdown(PAF,"Summon Boss",{"Slime","Valentine","Anos","GojoV2","AlucardV2"},"SelectedSummonBoss")
MkToggle(PAF,"Auto Summon Boss","AutoSummonBoss",function(v)
    if v then
        StartLoop("SumBoss",function()
            DoSummonBoss(Cfg.SelectedSummonBoss,"Normal")
        end,4)
    else StopLoop("SumBoss") end
end)
MkToggle(PAF,"Auto Kill Summon","AutoKillSummon",function(v)
    if v then
        StartLoop("KillSum",function()
            local m=FindNearest(Cfg.SelectedSummonBoss,2000)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("KillSum") end
end)

-- ┌─────────────── QUEST ───────────────┐
local PAQ=NewPage("Quest"); MkTitle(PAQ,"Quest")
MkSect(PAQ,"Auto Quest  [QuestAccept / QuestComplete / QuestRepeat]")
MkToggle(PAQ,"Auto Accept Quest","AutoAcceptQuest",function(v)
    if v then StartLoop("AcptQ",DoAcceptQuest,1.5) else StopLoop("AcptQ") end
end)
MkToggle(PAQ,"Auto Complete Quest","AutoCompleteQuest",function(v)
    if v then StartLoop("CompQ",DoCompleteQuest,1) else StopLoop("CompQ") end
end)
MkToggle(PAQ,"Auto Farm Quest Mob","AutoQuestFarm",function(v)
    if v then
        StartLoop("QFarm",function()
            local m=FindAnyMob()
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("QFarm") end
end)
MkBtn(PAQ,"Accept Quest Now","Fires QuestAccept + ProxPrompt",function() DoAcceptQuest() end)
MkBtn(PAQ,"Complete Quest Now","Fires QuestComplete + QuestRepeat",function() DoCompleteQuest() end)

-- ┌─────────────── BOSS SYSTEM ───────────────┐
local PB=NewPage("Boss"); MkTitle(PB,"Boss System")

MkSect(PB,"Auto Spawn Rimuru  [RequestAutoSpawnRimuru]")
MkDropdown(PB,"Difficulty",{"Normal","Hard","Extreme"},"DiffRimuru")
MkToggle(PB,"Auto Spawn Rimuru","AutoSpawnRimuru",function(v)
    if v then StartLoop("SpawnRim",DoSpawnRimuru,4) else StopLoop("SpawnRim") end
end)
MkToggle(PB,"Auto Kill Rimuru","AutoKillRimuru",function(v)
    if v then
        StartLoop("KillRim",function()
            local m=FindNearest("Rimuru",2000)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("KillRim") end
end)

MkSect(PB,"Auto Spawn Anos  [RequestAutoSpawnAnos in Remotes]")
MkToggle(PB,"Auto Spawn Anos","AutoSpawnAnos",function(v)
    if v then StartLoop("SpawnAnos",DoSpawnAnos,4) else StopLoop("SpawnAnos") end
end)
MkToggle(PB,"Auto Kill Anos","AutoKillAnos",function(v)
    if v then
        StartLoop("KillAnos",function()
            local m=FindNearest("Anos",2000)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("KillAnos") end
end)

MkSect(PB,"Strongest Boss  [RequestAutoSpawnStrongest in Remotes]")
MkToggle(PB,"Auto Spawn Strongest","AutoSpawnStrongest",function(v)
    if v then StartLoop("SpawnStr",DoSpawnStrongest,4) else StopLoop("SpawnStr") end
end)
MkToggle(PB,"Auto Kill Strongest","AutoKillStrongest",function(v)
    if v then
        StartLoop("KillStr",function()
            local m=FindNearest("Boss",2000) or FindAnyMob(2000)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("KillStr") end
end)

MkSect(PB,"Event  — Slime & Valentine")
MkToggle(PB,"Auto Event Farm","AutoEventFarm",function(v)
    if v then
        StartLoop("EvFarm",function()
            local m=FindNearest("Slime",1000) or FindNearest("Valentine",1000)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("EvFarm") end
end)

MkSect(PB,"Crafting  [RequestSlimeCraft / RequestGrailCraft in Remotes]")
MkToggle(PB,"Auto Slime Craft","AutoSlimeCraft",function(v)
    if v then StartLoop("CraftSlime",DoSlimeCraft,3) else StopLoop("CraftSlime") end
end)
MkToggle(PB,"Auto Grail Craft","AutoGrailCraft",function(v)
    if v then StartLoop("CraftGrail",DoGrailCraft,3) else StopLoop("CraftGrail") end
end)
MkBtn(PB,"Craft Slime Key Now","RequestSlimeCraft + OpenSlimeCraftUI",function() DoSlimeCraft() end)
MkBtn(PB,"Craft Grail Key Now","RequestGrailCraft + OpenGrailCraftUI",function() DoGrailCraft() end)

-- ┌─────────────── DUNGEON ───────────────┐
local PD=NewPage("Dungeon"); MkTitle(PD,"Dungeon")
MkSect(PD,"Join  [JoinDungeonPortal + RequestDungeonPortal in Remotes]")
MkDropdown(PD,"Select Dungeon",{"CidDungeon","ShadowDungeon","FrostDungeon","VoidDungeon"},"SelectedDungeon")
MkToggle(PD,"Auto Join Dungeon","AutoJoinDungeon",function(v)
    if v then StartLoop("JoinD",DoJoinDungeon,2) else StopLoop("JoinD") end
end)
MkToggle(PD,"Auto Join Team","AutoJoinTeam",function(v)
    if v then
        StartLoop("JoinT",function()
            ClickGUI("team"); FireAllProx("team")
        end,2)
    else StopLoop("JoinT") end
end)

MkSect(PD,"Wave  [DungeonWaveVote + DungeonWaveReplayVote in Remotes]")
MkDropdown(PD,"Difficulty",{"Normal","Hard","Extreme"},"SelectedDifficulty")
MkToggle(PD,"Auto Vote Difficulty","AutoVote",function(v)
    if v then StartLoop("VoteD",DoDungeonVote,1) else StopLoop("VoteD") end
end)
MkToggle(PD,"Auto Retry","AutoRetry",function(v)
    if v then
        StartLoop("Retry",function()
            ClickGUI("retry"); ClickGUI("restart")
            Rem_Fire("DungeonWaveReplayVote")
        end,3)
    else StopLoop("Retry") end
end)
MkToggle(PD,"Start Kill (Dungeon Mobs)","StartKill",function(v)
    if v then
        StartLoop("DKill",function()
            local m=FindAnyMob(300)
            if m then AttackTarget(m) end
        end,0.05)
    else StopLoop("DKill") end
end)
MkBtn(PD,"Quest Shadow","DungeonQuestAccept Remote",function()
    Rem_Fire("DungeonQuestAccept")
    FireAllProx("shadow")
end)
MkBtn(PD,"Leave Dungeon","LeaveDungeonPortal Remote",function()
    Rem_Fire("LeaveDungeonPortal")
end)

-- ┌─────────────── STATS ───────────────┐
local PSt=NewPage("Stats"); MkTitle(PSt,"Stats")
MkSect(PSt,"Upgrade Stat  [AllocateStat in RE + AllocateStats in Rem]")
MkDropdown(PSt,"Select Stat",{"Melee","Defense","Sword","Power","Spirit"},"SelectedStat")
MkDropdown(PSt,"Amount",{"1","5","10","50","100","999"},"StatAmount")
MkToggle(PSt,"Auto Upgrade Stats","AutoUpgradeStat",function(v)
    if v then StartLoop("UpgStat",DoAllocateStat,0.5) else StopLoop("UpgStat") end
end)
MkBtn(PSt,"Upgrade Once","Alloca ora",function() DoAllocateStat() end)

MkSect(PSt,"Stat Reroll  [StatRerollUpdate + StatRerollUpdateAutoSkip in RE]")
MkBtn(PSt,"Open Stat Reroll UI","OpenStatRerollUI Remote",function()
    RE_Fire("OpenStatRerollUI")
end)
MkBtn(PSt,"Auto Skip Stat Reroll","StatUpdateAutoSkip",function()
    RE_Fire("StatUpdateAutoSkip")
    RE_Fire("StatRerollUpdateAutoSkip")
end)

MkSect(PSt,"Chest  [UseItem + PurchaseItem in Remotes]")
MkDropdown(PSt,"Chest Type",{"Common Chest","Rare Chest","Epic Chest","Legendary Chest","Mythical Chest"},"SelectedChestType")
MkDropdown(PSt,"Amount",{"1","5","10","50","100"},"ChestAmount")
MkBtn(PSt,"Open Chest Now","UseItem + PurchaseItem",function()
    local amt=tonumber(Cfg.ChestAmount) or 1
    Rem_Fire("UseItem",    Cfg.SelectedChestType, amt)
    Rem_Fire("PurchaseItem",Cfg.SelectedChestType, amt)
end)

-- ┌─────────────── TELEPORT ───────────────┐
local PTP=NewPage("Teleport"); MkTitle(PTP,"Teleport")
MkSect(PTP,"Island  [TeleportToPortal in Remotes]")
MkDropdown(PTP,"Select Island",{
    "BossIsland","DesertIsland","DungeonIsland","HuecoMundoIsland",
    "JungleIsland","SailorIsland","ShibuyaDestroyed","ShibuyaStation",
    "SlimeIsland","SnowIsland","StarterIsland"
},"SelectedIsland")
MkBtn(PTP,"Teleport to Island","TeleportToPortal Remote + posizione workspace",function()
    DoTeleportIsland(Cfg.SelectedIsland)
end)

MkSect(PTP,"NPC / Boss")
MkDropdown(PTP,"Select NPC",{
    "AizenNpc","GojoBoss","RimuruNpc","CidNpc","ShopNpc","QuestNpc","SummonNpc","AnosNpc","GilgameshNpc"
},"SelectedNPC")
MkBtn(PTP,"Teleport to NPC","Cerca nel workspace",function()
    DoTeleportNPC(Cfg.SelectedNPC)
end)

MkSect(PTP,"Event  [SlimePuzzleProgress + DungeonPuzzleProgress in Remotes]")
MkToggle(PTP,"Auto Slime Event","AutoSlimeEvent",function(v)
    if v then
        StartLoop("ASlime",function()
            local s=FindNearest("Slime",1000)
            if s then AttackTarget(s)
            else
                RE_Fire("SlimePuzzleProgress")
                for _,v2 in ipairs(workspace:GetDescendants()) do
                    if v2:IsA("BasePart") and v2.Name:lower():find("slime") then
                        TeleportTo(v2.Position); break
                    end
                end
            end
        end,0.12)
    else StopLoop("ASlime") end
end)
MkToggle(PTP,"Auto Jigsaw Event","AutoJigsawEvent",function(v)
    if v then
        StartLoop("AJigsaw",function()
            Rem_Fire("DungeonPuzzleProgress")
            local root=GetRoot(); if not root then return end
            for _,v2 in ipairs(workspace:GetDescendants()) do
                if v2:IsA("BasePart") and v2.Name:lower():find("jigsaw") then
                    root.CFrame=CFrame.new(v2.Position+Vector3.new(0,4,0))
                    task.wait(0.15)
                    local par=v2.Parent or v2
                    for _,pp in ipairs(par:GetDescendants()) do
                        if pp:IsA("ProximityPrompt") then pcall(function() fireproximityprompt(pp) end) end
                        if pp:IsA("ClickDetector")   then pcall(function() fireclickdetector(pp)   end) end
                    end
                end
            end
        end,0.5)
    else StopLoop("AJigsaw") end
end)

-- ┌─────────────── SETTINGS ───────────────┐
local PSet=NewPage("Settings"); MkTitle(PSet,"Settings")
MkSect(PSet,"Misc")
MkToggle(PSet,"Anti AFK","AntiAFK",function(v)
    if v then StartAntiAFK() else StopLoop("AntiAFK") end
end)
MkSect(PSet,"Interface")
MkDropdown(PSet,"Theme",{"Dark","Light"},"Theme",function(v)
    if v=="Light" then
        MF.BackgroundColor3=Color3.fromRGB(230,234,248)
        SB.BackgroundColor3=Color3.fromRGB(210,216,238)
    else
        MF.BackgroundColor3=C.Bg; SB.BackgroundColor3=C.Side
    end
end)
MkToggle(PSet,"Transparency","Transparency",function(v)
    MF.BackgroundTransparency=v and 0.06 or 0
end)
MkSect(PSet,"Info Remote Paths")
MkBtn(PSet,"RemoteEvents path","ReplicatedStorage.RemoteEvents.*",function() end)
MkBtn(PSet,"Remotes path","ReplicatedStorage.Remotes.*",function() end)
MkBtn(PSet,"AbilitySystem path","ReplicatedStorage.AbilitySystem.Remotes.*",function() end)
MkBtn(PSet,"CombatSystem path","ReplicatedStorage.CombatSystem.Remotes.*",function() end)
MkSect(PSet,"Controls")
MkBtn(PSet,"Minimize: LeftCtrl",nil,function() MF.Visible=not MF.Visible end)
MkBtn(PSet,"Destroy GUI",nil,function() SG:Destroy() end)

-- --------------------------------------------------
-- SIDEBAR BUTTONS
-- --------------------------------------------------
SideBtn("Main",      "⌂", "Main",     1)
SideBtn("Auto Farm", "⚔", "AutoFarm", 2)
SideBtn("Quest",     "📋","Quest",    3)
SideBtn("Boss",      "♛", "Boss",     4)
SideBtn("Dungeon",   "🏯","Dungeon",  5)
SideBtn("Stats",     "📊","Stats",    6)
SideBtn("Teleport",  "🌀","Teleport", 7)
SideBtn("Settings",  "⚙", "Settings", 8)

-- --------------------------------------------------
-- INIT
-- --------------------------------------------------
local function OpenMenu()
    MF.Visible=true
    MF.Size=UDim2.new(0,0,0,0); MF.Position=UDim2.new(0.5,0,0.5,0)
    TweenService:Create(MF,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,660,0,460),
        Position=UDim2.new(0.5,-330,0.5,-230),
    }):Play()
    task.wait(0.1)
    ShowPage("Main")
    if SBBtns[1] then
        local b=SBBtns[1]
        b.btn.BackgroundColor3=C.Panel; b.btn.BackgroundTransparency=0.35
        b.bar.Visible=true; b.ico.TextColor3=C.Accent; b.txt.TextColor3=C.White
    end
end

-- avvio dal key system

if Cfg.AntiAFK then StartAntiAFK() end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if Cfg.Speedhack then
        local h=char:WaitForChild("Humanoid",3)
        if h then h.WalkSpeed=Cfg.SpeedValue end
    end
    if Cfg.InfinityJump then ToggleInfJump(true) end
    if Cfg.ESPPlayer then task.wait(1); UpdateESP() end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1); if Cfg.ESPPlayer then MakeESP(p) end
    end)
end)
Players.PlayerRemoving:Connect(function()
    task.wait(0.5); if Cfg.ESPPlayer then UpdateESP() end
end)

print("👺 [!Tokyo Script V1.0] Caricato!  |  LeftCtrl = minimizza")

-- KEY SYSTEM

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
local DISCORD_INVITE = "https://discord.gg/TUOCODICE"  -- <-- metti il tuo link Discord

-- --------------------------------------------------
-- SERVICES
-- --------------------------------------------------
-- --------------------------------------------------
-- KEY STORAGE
-- --------------------------------------------------
local STORAGE_KEY = "SP_Key_v3"

local function SaveKey(k)
    pcall(function() LP.PlayerGui:SetAttribute(STORAGE_KEY, k) end)
end
local function LoadKey()
    local ok, v = pcall(function() return LP.PlayerGui:GetAttribute(STORAGE_KEY) end)
    return ok and v or nil
end
local function IsKeyValid(k)
    if not k or k=="" then return false end
    k = k:upper():gsub("%s","")
    for _, v in ipairs(VALID_KEYS) do
        if k == v:upper() then return true end
    end
    return false
end

-- --------------------------------------------------
-- PALETTE Navy Ice
-- --------------------------------------------------
local KC = {
    Bg      = Color3.fromRGB(6,  9,  20),
    Panel   = Color3.fromRGB(10, 14, 28),
    Row     = Color3.fromRGB(14, 18, 34),
    Hover   = Color3.fromRGB(20, 26, 52),
    Accent  = Color3.fromRGB(80, 170, 255),
    Accent2 = Color3.fromRGB(140,205,255),
    AccentG = Color3.fromRGB(80, 230,140),
    Border  = Color3.fromRGB(25,  40, 80),
    Text    = Color3.fromRGB(200,215,250),
    Dim     = Color3.fromRGB(90, 110,160),
    White   = Color3.fromRGB(255,255,255),
    Red     = Color3.fromRGB(255, 70,  70),
    Gold    = Color3.fromRGB(255,200,  60),
    DBlue   = Color3.fromRGB(18,  24,  50),
    Discord = Color3.fromRGB(88, 101,242),
}

-- --------------------------------------------------
-- GUI ROOT
-- --------------------------------------------------
pcall(function()
    local old = game:GetService("CoreGui"):FindFirstChild("SP_KeyUI2")
    if old then old:Destroy() end
end)
pcall(function()
    local old = LP.PlayerGui:FindFirstChild("SP_KeyUI2")
    if old then old:Destroy() end
end)

local SG = Instance.new("ScreenGui")
SG.Name            = "SP_KeyUI2"
SG.ResetOnSpawn    = false
SG.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset  = true
if not pcall(function() SG.Parent = game:GetService("CoreGui") end) then
    SG.Parent = LP.PlayerGui
end

-- --------------------------------------------------
-- OVERLAY + NEVE
-- --------------------------------------------------
local overlay = Instance.new("Frame", SG)
overlay.Size = UDim2.new(1,0,1,0)
overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
overlay.BackgroundTransparency = 0.5
overlay.BorderSizePixel = 0
overlay.ZIndex = 1

local snowFrame = Instance.new("Frame", SG)
snowFrame.Size = UDim2.new(1,0,1,0)
snowFrame.BackgroundTransparency = 1
snowFrame.ZIndex = 2

local syms   = {"❄","❅","❆","·","*","◦"}
local flakes = {}
for i = 1, 40 do
    local l = Instance.new("TextLabel", snowFrame)
    l.BackgroundTransparency = 1
    l.ZIndex        = 2
    l.Font          = Enum.Font.GothamBold
    l.TextSize      = math.random(8,22)
    l.Text          = syms[math.random(#syms)]
    l.TextColor3    = Color3.fromRGB(math.random(120,200), math.random(160,230), 255)
    l.TextTransparency = math.random(4,8)/10
    l.Size          = UDim2.new(0,26,0,26)
    local sx        = math.random(0,100)/100
    l.Position      = UDim2.new(sx, 0, math.random(-10,100)/100, 0)
    table.insert(flakes, {l=l, x=sx, spd=math.random(6,16)/10, rot=math.random(-2,2)})
end

local snowT    = 0
local snowConn = RunService.Heartbeat:Connect(function(dt)
    snowT = snowT + dt
    for _, f in ipairs(flakes) do
        local ny = (f.l.Position.Y.Scale or 0) + dt * f.spd * 0.07
        if ny > 1.06 then
            ny   = -0.04
            f.x  = math.random(0,100)/100
        end
        local nx = f.x + math.sin(snowT * (f.rot ~= 0 and f.rot or 0.5) + f.x*9) * 0.005
        f.l.Position = UDim2.new(nx, 0, ny, 0)
        f.l.Rotation = snowT * f.rot * 22
    end
end)

-- --------------------------------------------------
-- CARD
-- --------------------------------------------------
local card = Instance.new("Frame", SG)
card.Size                  = UDim2.new(0, 420, 0, 360)
card.Position              = UDim2.new(0.5, -210, 0.5, -180)
card.BackgroundColor3      = KC.Bg
card.BackgroundTransparency= 0.04
card.BorderSizePixel       = 0
card.ZIndex                = 10
card.ClipsDescendants      = true
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)
local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color     = KC.Border
cardStroke.Thickness = 1.5

-- top accent line
local topLine = Instance.new("Frame", card)
topLine.Size             = UDim2.new(1,0,0,2)
topLine.BackgroundColor3 = KC.Accent
topLine.BorderSizePixel  = 0
topLine.ZIndex           = 11
local tg = Instance.new("UIGradient", topLine)
tg.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0,70,170)),
    ColorSequenceKeypoint.new(0.5, KC.Accent),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0,70,170)),
})

-- Entrata card
card.Size     = UDim2.new(0,0,0,0)
card.Position = UDim2.new(0.5,0,0.5,0)
TweenService:Create(card, TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size     = UDim2.new(0,420,0,360),
    Position = UDim2.new(0.5,-210,0.5,-180),
}):Play()

-- --------------------------------------------------
-- CONTENUTO CARD
-- --------------------------------------------------

-- Icona rotante
local iconLbl = Instance.new("TextLabel", card)
iconLbl.Size               = UDim2.new(1,0,0,56)
iconLbl.Position           = UDim2.new(0,0,0,16)
iconLbl.BackgroundTransparency = 1
iconLbl.Text               = "❄"
iconLbl.TextColor3         = KC.Accent
iconLbl.Font               = Enum.Font.GothamBold
iconLbl.TextSize           = 40
iconLbl.ZIndex             = 12

local iRot = 0
local rotConn = RunService.Heartbeat:Connect(function(dt)
    iRot = iRot + dt * 20
    if iRot > 360 then iRot = iRot - 360 end
    iconLbl.Rotation = iRot
end)

-- Titolo
local titleLbl = Instance.new("TextLabel", card)
titleLbl.Size               = UDim2.new(1,0,0,26)
titleLbl.Position           = UDim2.new(0,0,0,76)
titleLbl.BackgroundTransparency = 1
titleLbl.Text               = "👺 !Tokyo Script  ·  v1.0"
titleLbl.TextColor3         = KC.White
titleLbl.Font               = Enum.Font.GothamBold
titleLbl.TextSize           = 19
titleLbl.ZIndex             = 12

-- Sottotitolo
local subLbl = Instance.new("TextLabel", card)
subLbl.Size               = UDim2.new(1,0,0,18)
subLbl.Position           = UDim2.new(0,0,0,104)
subLbl.BackgroundTransparency = 1
subLbl.Text               = "Inserisci la key per accedere"
subLbl.TextColor3         = KC.Dim
subLbl.Font               = Enum.Font.Gotham
subLbl.TextSize           = 12
subLbl.ZIndex             = 12

-- Divider
local div = Instance.new("Frame", card)
div.Size             = UDim2.new(0,340,0,1)
div.Position         = UDim2.new(0.5,-170,0,130)
div.BackgroundColor3 = KC.Border
div.BorderSizePixel  = 0
div.ZIndex           = 12

-- ── INPUT BOX ──
local inputBg = Instance.new("Frame", card)
inputBg.Size             = UDim2.new(0,340,0,42)
inputBg.Position         = UDim2.new(0.5,-170,0,146)
inputBg.BackgroundColor3 = KC.Panel
inputBg.BorderSizePixel  = 0
inputBg.ZIndex           = 12
Instance.new("UICorner", inputBg).CornerRadius = UDim.new(0,8)
local inputStroke = Instance.new("UIStroke", inputBg)
inputStroke.Color     = KC.Border
inputStroke.Thickness = 1.5

local inputBox = Instance.new("TextBox", inputBg)
inputBox.Size               = UDim2.new(1,-14,1,0)
inputBox.Position           = UDim2.new(0,7,0,0)
inputBox.BackgroundTransparency = 1
inputBox.Text               = ""
inputBox.PlaceholderText    = "Incolla la tua key..."
inputBox.PlaceholderColor3  = KC.Dim
inputBox.TextColor3         = KC.Accent2
inputBox.Font               = Enum.Font.GothamBold
inputBox.TextSize           = 14
inputBox.ClearTextOnFocus   = false
inputBox.ZIndex             = 13

inputBox.Focused:Connect(function()
    TweenService:Create(inputStroke,TweenInfo.new(0.15),{Color=KC.Accent}):Play()
    TweenService:Create(inputBg,TweenInfo.new(0.15),{BackgroundColor3=KC.Hover}):Play()
end)
inputBox.FocusLost:Connect(function()
    TweenService:Create(inputStroke,TweenInfo.new(0.15),{Color=KC.Border}):Play()
    TweenService:Create(inputBg,TweenInfo.new(0.15),{BackgroundColor3=KC.Panel}):Play()
end)

-- ── STATUS ──
local statusLbl = Instance.new("TextLabel", card)
statusLbl.Size               = UDim2.new(1,-40,0,16)
statusLbl.Position           = UDim2.new(0,20,0,194)
statusLbl.BackgroundTransparency = 1
statusLbl.Text               = ""
statusLbl.TextColor3         = KC.Dim
statusLbl.Font               = Enum.Font.Gotham
statusLbl.TextSize           = 11
statusLbl.ZIndex             = 12

local function SetStatus(msg, col)
    statusLbl.Text       = msg
    statusLbl.TextColor3 = col or KC.Dim
end

-- --------------------------------------------------
-- BOTTONE LOGIN
-- --------------------------------------------------
local loginBtn = Instance.new("TextButton", card)
loginBtn.Size             = UDim2.new(0,220,0,42)
loginBtn.Position         = UDim2.new(0.5,-110,0,216)
loginBtn.BackgroundColor3 = KC.Accent
loginBtn.Text             = "LOGIN"
loginBtn.TextColor3       = KC.White
loginBtn.Font             = Enum.Font.GothamBold
loginBtn.TextSize         = 15
loginBtn.BorderSizePixel  = 0
loginBtn.ZIndex           = 12
Instance.new("UICorner", loginBtn).CornerRadius = UDim.new(0,10)
local lbGrad = Instance.new("UIGradient", loginBtn)
lbGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(55,130,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25,80,200)),
})
lbGrad.Rotation = 90

loginBtn.MouseEnter:Connect(function()
    TweenService:Create(loginBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(100,190,255)}):Play()
end)
loginBtn.MouseLeave:Connect(function()
    TweenService:Create(loginBtn,TweenInfo.new(0.12),{BackgroundColor3=KC.Accent}):Play()
end)

-- --------------------------------------------------
-- BOTTONE GET KEY (in basso a destra)
-- --------------------------------------------------
local getKeyBtn = Instance.new("TextButton", card)
getKeyBtn.Size             = UDim2.new(0,110,0,32)
getKeyBtn.Position         = UDim2.new(1,-122,1,-44)
getKeyBtn.BackgroundColor3 = KC.Discord
getKeyBtn.Text             = "Get Key"
getKeyBtn.TextColor3       = KC.White
getKeyBtn.Font             = Enum.Font.GothamBold
getKeyBtn.TextSize         = 13
getKeyBtn.BorderSizePixel  = 0
getKeyBtn.ZIndex           = 12
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0,8)
local gkGrad = Instance.new("UIGradient", getKeyBtn)
gkGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100,120,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(70, 85,220)),
})
gkGrad.Rotation = 90

getKeyBtn.MouseEnter:Connect(function()
    TweenService:Create(getKeyBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(110,130,255)}):Play()
end)
getKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(getKeyBtn,TweenInfo.new(0.12),{BackgroundColor3=KC.Discord}):Play()
end)

-- ── Toast "Copied Link" in basso a destra ──
local toast = Instance.new("Frame", SG)
toast.Size             = UDim2.new(0,140,0,36)
toast.Position         = UDim2.new(1,-154, 1, 10)  -- fuori schermo in basso
toast.BackgroundColor3 = KC.Panel
toast.BorderSizePixel  = 0
toast.ZIndex           = 50
toast.BackgroundTransparency = 0.1
Instance.new("UICorner", toast).CornerRadius = UDim.new(0,8)
local toastStroke = Instance.new("UIStroke", toast)
toastStroke.Color     = KC.AccentG
toastStroke.Thickness = 1.2

local toastLbl = Instance.new("TextLabel", toast)
toastLbl.Size               = UDim2.new(1,0,1,0)
toastLbl.BackgroundTransparency = 1
toastLbl.Text               = "✔  Copied Link"
toastLbl.TextColor3         = KC.AccentG
toastLbl.Font               = Enum.Font.GothamBold
toastLbl.TextSize            = 13
toastLbl.ZIndex             = 51

local toastVisible = false
local function ShowToast()
    if toastVisible then return end
    toastVisible = true
    -- slide su
    TweenService:Create(toast, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1,-154, 1,-50)
    }):Play()
    task.delay(2.2, function()
        TweenService:Create(toast, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
            Position = UDim2.new(1,-154, 1, 10)
        }):Play()
        task.wait(0.25)
        toastVisible = false
    end)
end

-- Click Get Key: copia discord e mostra toast
getKeyBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD_INVITE) end)
    pcall(function() game:GetService("GuiService"):OpenBrowserWindow(DISCORD_INVITE) end)
    ShowToast()
end)

-- --------------------------------------------------
-- SHAKE su errore
-- --------------------------------------------------
local function ShakeCard()
    local orig = card.Position
    for i = 1,5 do
        local dir = i%2==0 and 7 or -7
        TweenService:Create(card,TweenInfo.new(0.055),{
            Position = UDim2.new(orig.X.Scale, orig.X.Offset+dir, orig.Y.Scale, orig.Y.Offset)
        }):Play()
        task.wait(0.06)
    end
    TweenService:Create(card,TweenInfo.new(0.1),{Position=orig}):Play()
end

-- --------------------------------------------------
-- WELCOME SCREEN
-- --------------------------------------------------
local function PlayWelcome(onDone)
    -- Fade out card
    TweenService:Create(card, TweenInfo.new(0.35,Enum.EasingStyle.Quad),{
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5,-210, 0.5,-240),
    }):Play()
    for _,v in ipairs(card:GetChildren()) do
        if v:IsA("GuiObject") then
            TweenService:Create(v,TweenInfo.new(0.25),{BackgroundTransparency=1}):Play()
            if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
                TweenService:Create(v,TweenInfo.new(0.25),{TextTransparency=1}):Play()
            end
        end
    end
    task.wait(0.4)
    card:Destroy()

    -- Welcome card
    local wCard = Instance.new("Frame", SG)
    wCard.Size             = UDim2.new(0,0,0,0)
    wCard.Position         = UDim2.new(0.5,0,0.5,0)
    wCard.BackgroundColor3 = KC.Bg
    wCard.BackgroundTransparency = 0.04
    wCard.BorderSizePixel  = 0
    wCard.ZIndex           = 20
    wCard.ClipsDescendants = true
    Instance.new("UICorner", wCard).CornerRadius = UDim.new(0,16)
    local ws = Instance.new("UIStroke", wCard)
    ws.Color     = KC.AccentG
    ws.Thickness = 1.8

    -- top line verde
    local wtl = Instance.new("Frame", wCard)
    wtl.Size             = UDim2.new(1,0,0,2)
    wtl.BackgroundColor3 = KC.AccentG
    wtl.BorderSizePixel  = 0; wtl.ZIndex=21
    local wtg = Instance.new("UIGradient", wtl)
    wtg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,150,80)),
        ColorSequenceKeypoint.new(0.5, KC.AccentG),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,150,80)),
    })

    -- Entrata
    TweenService:Create(wCard,TweenInfo.new(0.55,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size     = UDim2.new(0,400,0,300),
        Position = UDim2.new(0.5,-200,0.5,-150),
    }):Play()
    task.wait(0.3)

    -- Icona check
    local wIcon = Instance.new("TextLabel", wCard)
    wIcon.Size               = UDim2.new(1,0,0,70)
    wIcon.Position           = UDim2.new(0,0,0,18)
    wIcon.BackgroundTransparency = 1
    wIcon.Text               = "✔"
    wIcon.TextColor3         = KC.AccentG
    wIcon.Font               = Enum.Font.GothamBold
    wIcon.TextSize           = 0
    wIcon.ZIndex             = 22

    TweenService:Create(wIcon,TweenInfo.new(0.45,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        TextSize = 52
    }):Play()
    task.wait(0.2)

    -- "Welcome"
    local wWelcome = Instance.new("TextLabel", wCard)
    wWelcome.Size               = UDim2.new(1,0,0,30)
    wWelcome.Position           = UDim2.new(0,0,0,96)
    wWelcome.BackgroundTransparency = 1
    wWelcome.Text               = "Welcome,"
    wWelcome.TextColor3         = KC.Dim
    wWelcome.Font               = Enum.Font.Gotham
    wWelcome.TextSize           = 0
    wWelcome.ZIndex             = 22
    TweenService:Create(wWelcome,TweenInfo.new(0.3),{TextSize=16}):Play()
    task.wait(0.1)

    -- Username grande
    local wName = Instance.new("TextLabel", wCard)
    wName.Size               = UDim2.new(1,-40,0,40)
    wName.Position           = UDim2.new(0,20,0,122)
    wName.BackgroundTransparency = 1
    wName.Text               = USERNAME
    wName.TextColor3         = KC.White
    wName.Font               = Enum.Font.GothamBold
    wName.TextSize           = 0
    wName.ZIndex             = 22
    TweenService:Create(wName,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        TextSize = 30
    }):Play()
    task.wait(0.18)

    -- Sottotitolo
    local wSub = Instance.new("TextLabel", wCard)
    wSub.Size               = UDim2.new(1,0,0,20)
    wSub.Position           = UDim2.new(0,0,0,167)
    wSub.BackgroundTransparency = 1
    wSub.Text               = "Accesso concesso  ·  👺 !Tokyo Script v1.0"
    wSub.TextColor3         = KC.Dim
    wSub.Font               = Enum.Font.Gotham
    wSub.TextSize           = 0
    wSub.ZIndex             = 22
    TweenService:Create(wSub,TweenInfo.new(0.3),{TextSize=12}):Play()
    task.wait(0.1)

    -- Barra di caricamento
    local barBg = Instance.new("Frame", wCard)
    barBg.Size             = UDim2.new(0,320,0,5)
    barBg.Position         = UDim2.new(0.5,-160,0,210)
    barBg.BackgroundColor3 = KC.Panel
    barBg.BorderSizePixel  = 0; barBg.ZIndex=22
    Instance.new("UICorner", barBg).CornerRadius = UDim.new(1,0)

    local barFill = Instance.new("Frame", barBg)
    barFill.Size             = UDim2.new(0,0,1,0)
    barFill.BackgroundColor3 = KC.AccentG
    barFill.BorderSizePixel  = 0; barFill.ZIndex=23
    Instance.new("UICorner", barFill).CornerRadius = UDim.new(1,0)
    local bfg = Instance.new("UIGradient", barFill)
    bfg.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50,200,110)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(80,255,160)),
    })

    -- Loading label
    local loadLbl = Instance.new("TextLabel", wCard)
    loadLbl.Size               = UDim2.new(1,0,0,18)
    loadLbl.Position           = UDim2.new(0,0,0,224)
    loadLbl.BackgroundTransparency = 1
    loadLbl.Text               = "Caricamento script..."
    loadLbl.TextColor3         = KC.Dim
    loadLbl.Font               = Enum.Font.Gotham
    loadLbl.TextSize           = 11
    loadLbl.ZIndex             = 22

    TweenService:Create(barFill,TweenInfo.new(1.4,Enum.EasingStyle.Quad),{
        Size = UDim2.new(1,0,1,0)
    }):Play()

    -- Dots animati
    local dots = 0
    local dotConn
    dotConn = RunService.Heartbeat:Connect(function()
        dots = dots + 1
        if dots % 30 == 0 then
            local d = dots/30
            loadLbl.Text = "Caricamento script" .. string.rep(".", (d%4)+1)
        end
    end)

    task.delay(1.5, function()
        dotConn:Disconnect()
        loadLbl.Text = "✔  Script avviato!"
        loadLbl.TextColor3 = KC.AccentG

        task.wait(0.5)

        -- Fade out tutto
        TweenService:Create(wCard,TweenInfo.new(0.45,Enum.EasingStyle.Quad),{
            BackgroundTransparency = 1,
            Position = UDim2.new(0.5,-200, 0.5,-220),
        }):Play()
        TweenService:Create(overlay,TweenInfo.new(0.4),{BackgroundTransparency=1}):Play()
        for _, f in ipairs(flakes) do
            TweenService:Create(f.l,TweenInfo.new(0.3),{TextTransparency=1}):Play()
        end

        task.wait(0.5)
        snowConn:Disconnect()
        rotConn:Disconnect()
        SG:Destroy()
        if onDone then onDone() end
    end)
end

-- --------------------------------------------------
-- LOGICA LOGIN
-- --------------------------------------------------
local function TryLogin()
    local key = inputBox.Text:upper():gsub("%s","")
    if key == "" then
        SetStatus("✖  Inserisci una key", KC.Red)
        task.spawn(ShakeCard)
        return
    end

    SetStatus("⏳ Verifica in corso...", KC.Dim)
    loginBtn.Text   = "..."
    loginBtn.Active = false

    task.wait(0.7)

    if IsKeyValid(key) then
        SaveKey(key)
        PlayWelcome(function()
            pcall(PlaySnowIntro)
            task.delay(3.5, function() pcall(OpenMenu) end)
        end)
    else
        loginBtn.Text   = "LOGIN"
        loginBtn.Active = true
        SetStatus("✖  Key non valida — ottieni la key dal Discord", KC.Red)
        TweenService:Create(cardStroke,TweenInfo.new(0.12),{Color=KC.Red}):Play()
        task.spawn(ShakeCard)
        task.delay(0.5, function()
            TweenService:Create(cardStroke,TweenInfo.new(0.35),{Color=KC.Border}):Play()
        end)
    end
end

inputBox.FocusLost:Connect(function(enter) if enter then TryLogin() end end)
loginBtn.MouseButton1Click:Connect(TryLogin)

-- --------------------------------------------------
-- AUTO LOGIN (key già salvata)
-- --------------------------------------------------
task.spawn(function()
    task.wait(0.4)
    local saved = LoadKey()
    if IsKeyValid(saved) then
        SetStatus("✔  Key trovata — accesso automatico...", KC.AccentG)
        inputBox.Text = saved
        task.wait(0.9)
        PlayWelcome(function()
            pcall(PlaySnowIntro)
            task.delay(3.5, function() pcall(OpenMenu) end)
        end)
    end
end)

print("👺 [!Tokyo Script v1.0] Key System Caricato!")
