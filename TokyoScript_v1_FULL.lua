--[[
    TOKYO SCRIPT V1.0 - Fixed
]]

-- SHIMS
if not fireproximityprompt then fireproximityprompt = function() end end
if not fireclickdetector   then fireclickdetector   = function() end end
if not setclipboard        then setclipboard        = function() end end
if not writefile           then writefile           = function() end end
if not keypress            then keypress            = function() end end
if not keyrelease          then keyrelease          = function() end end
if not firesignal          then firesignal          = function() end end

-- SERVICES
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UIS               = game:GetService("UserInputService")
local VU                = game:GetService("VirtualUser")
local SoundService      = game:GetService("SoundService")

-- LANG
local KEY_UI_EN = {
    key_title    = "Tokyo Script  -  Authentication",
    key_sub      = "Enter your key to access the script",
    key_btn      = "LOGIN",
    key_get      = "Get Key",
    key_help     = "GET HELP",
    key_empty    = "Please enter a key",
    key_checking = "Checking...",
    key_invalid  = "Invalid key  -  get your key on Discord",
    key_found    = "Key found  -  auto login...",
    key_loading  = "Loading...",
    key_done     = "Script started!",
    key_welcome  = "Welcome to Tokyo Script,",
    key_access   = "Access granted  -  Tokyo Script V1.0",
    hotkey       = "CTRL  -  open / close",
}
local LANGS = {
    it = {
        sb_main="Principale", sb_farm="Auto Farm", sb_quest="Quest",
        sb_boss="Boss", sb_dungeon="Dungeon", sb_stats="Stats",
        sb_tp="Teleport", sb_settings="Impostazioni",
        pg_main="Principale", s_player="Giocatore",
        t_speed="Speedhack", t_jump="Infinity Jump", t_esp="ESP Giocatori",
        s_haki="Haki", t_haki="Auto Haki",
        t_obs="Auto Observation", t_conq="Auto Conqueror Haki",
        pg_farm="Auto Farm", s_mob="Mob Specifico",
        d_mob="Seleziona Mob", d_pos="Posizione Farm",
        t_farm="Auto Farm Mob", s_farmall="Farm Tutti i Mob",
        t_farmall="Auto Farm TUTTI i Mob",
        s_skills="Skills", skill_info="Tasti skill",
        t_skills="Auto Usa Skills", b_skills="Usa Skills Adesso",
        s_bossfarm="Boss Farm", d_boss="Seleziona Boss", t_bossfarm="Auto Farm Boss",
        pg_quest="Quest", s_quest="Auto Quest",
        t_acceptq="Auto Accetta Quest", t_completeq="Auto Completa Quest",
        t_qfarm="Auto Farm Quest Mob",
        b_acceptq="Accetta Quest Adesso", b_completeq="Completa Quest Adesso",
        pg_boss="Boss System", t_spawnrim="Auto Spawn Rimuru",
        t_killrim="Auto Kill Rimuru", t_spawnanos="Auto Spawn Anos",
        t_killanos="Auto Kill Anos", s_strongest="Strongest Boss",
        t_spawnstr="Auto Spawn Strongest", t_killstr="Auto Kill Strongest",
        s_craft="Crafting", t_slime="Auto Slime Craft", t_grail="Auto Grail Craft",
        pg_dun="Dungeon", d_dun="Seleziona Dungeon", t_joindun="Auto Join Dungeon",
        s_wave="Wave", t_vote="Auto Vota Difficolta", t_retry="Auto Retry",
        t_dkill="Kill Mob Dungeon", b_leave="Lascia Dungeon",
        pg_stats="Stats", s_upgrade="Upgrade", d_stat="Stat",
        d_qty="Quantita", t_autostat="Auto Upgrade Stats", b_upgrade="Upgrade Adesso",
        pg_tp="Teleport", s_island="Isola", d_island="Seleziona Isola",
        b_tpisland="Teleport Isola", s_npc="NPC",
        d_npc="Seleziona NPC", b_tpnpc="Teleport NPC",
        pg_settings="Impostazioni", s_misc="Misc",
        t_afk="Anti AFK", b_destroy="Distruggi GUI", diff="Difficolta",
    },
    en = {
        sb_main="Home", sb_farm="Auto Farm", sb_quest="Quest",
        sb_boss="Boss", sb_dungeon="Dungeon", sb_stats="Stats",
        sb_tp="Teleport", sb_settings="Settings",
        pg_main="Home", s_player="Player",
        t_speed="Speedhack", t_jump="Infinity Jump", t_esp="Player ESP",
        s_haki="Haki", t_haki="Auto Haki",
        t_obs="Auto Observation", t_conq="Auto Conqueror Haki",
        pg_farm="Auto Farm", s_mob="Specific Mob",
        d_mob="Select Mob", d_pos="Farm Position",
        t_farm="Auto Farm Mob", s_farmall="Farm All Mobs",
        t_farmall="Auto Farm ALL Mobs",
        s_skills="Skills", skill_info="Skill keys",
        t_skills="Auto Use Skills", b_skills="Use Skills Now",
        s_bossfarm="Boss Farm", d_boss="Select Boss", t_bossfarm="Auto Farm Boss",
        pg_quest="Quest", s_quest="Auto Quest",
        t_acceptq="Auto Accept Quest", t_completeq="Auto Complete Quest",
        t_qfarm="Auto Farm Quest Mob",
        b_acceptq="Accept Quest Now", b_completeq="Complete Quest Now",
        pg_boss="Boss System", t_spawnrim="Auto Spawn Rimuru",
        t_killrim="Auto Kill Rimuru", t_spawnanos="Auto Spawn Anos",
        t_killanos="Auto Kill Anos", s_strongest="Strongest Boss",
        t_spawnstr="Auto Spawn Strongest", t_killstr="Auto Kill Strongest",
        s_craft="Crafting", t_slime="Auto Slime Craft", t_grail="Auto Grail Craft",
        pg_dun="Dungeon", d_dun="Select Dungeon", t_joindun="Auto Join Dungeon",
        s_wave="Wave", t_vote="Auto Vote Difficulty", t_retry="Auto Retry",
        t_dkill="Kill Dungeon Mobs", b_leave="Leave Dungeon",
        pg_stats="Stats", s_upgrade="Upgrade", d_stat="Stat",
        d_qty="Amount", t_autostat="Auto Upgrade Stats", b_upgrade="Upgrade Now",
        pg_tp="Teleport", s_island="Island", d_island="Select Island",
        b_tpisland="Teleport Island", s_npc="NPC",
        d_npc="Select NPC", b_tpnpc="Teleport NPC",
        pg_settings="Settings", s_misc="Misc",
        t_afk="Anti AFK", b_destroy="Destroy GUI", diff="Difficulty",
    },
    es = {
        sb_main="Inicio", sb_farm="Auto Farm", sb_quest="Quest",
        sb_boss="Boss", sb_dungeon="Dungeon", sb_stats="Stats",
        sb_tp="Teleport", sb_settings="Ajustes",
        pg_main="Inicio", s_player="Jugador",
        t_speed="Speedhack", t_jump="Salto Infinito", t_esp="ESP Jugadores",
        s_haki="Haki", t_haki="Auto Haki",
        t_obs="Auto Observation", t_conq="Auto Conqueror Haki",
        pg_farm="Auto Farm", s_mob="Mob Especifico",
        d_mob="Seleccionar Mob", d_pos="Posicion Farm",
        t_farm="Auto Farm Mob", s_farmall="Farm Todos los Mobs",
        t_farmall="Auto Farm TODOS los Mobs",
        s_skills="Skills", skill_info="Teclas skill",
        t_skills="Auto Usar Skills", b_skills="Usar Skills Ahora",
        s_bossfarm="Boss Farm", d_boss="Seleccionar Boss", t_bossfarm="Auto Farm Boss",
        pg_quest="Quest", s_quest="Auto Quest",
        t_acceptq="Auto Aceptar Quest", t_completeq="Auto Completar Quest",
        t_qfarm="Auto Farm Quest Mob",
        b_acceptq="Aceptar Quest Ahora", b_completeq="Completar Quest Ahora",
        pg_boss="Boss System", t_spawnrim="Auto Spawn Rimuru",
        t_killrim="Auto Kill Rimuru", t_spawnanos="Auto Spawn Anos",
        t_killanos="Auto Kill Anos", s_strongest="Strongest Boss",
        t_spawnstr="Auto Spawn Strongest", t_killstr="Auto Kill Strongest",
        s_craft="Crafting", t_slime="Auto Slime Craft", t_grail="Auto Grail Craft",
        pg_dun="Dungeon", d_dun="Seleccionar Dungeon", t_joindun="Auto Entrar Dungeon",
        s_wave="Wave", t_vote="Auto Votar Dificultad", t_retry="Auto Reintentar",
        t_dkill="Matar Mobs Dungeon", b_leave="Salir Dungeon",
        pg_stats="Stats", s_upgrade="Mejorar", d_stat="Stat",
        d_qty="Cantidad", t_autostat="Auto Mejorar Stats", b_upgrade="Mejorar Ahora",
        pg_tp="Teleport", s_island="Isla", d_island="Seleccionar Isla",
        b_tpisland="Teleport Isla", s_npc="NPC",
        d_npc="Seleccionar NPC", b_tpnpc="Teleport NPC",
        pg_settings="Ajustes", s_misc="Misc",
        t_afk="Anti AFK", b_destroy="Destruir GUI", diff="Dificultad",
    },
}
local COUNTRY_LANG = {IT="it",SM="it",VA="it",ES="es",MX="es",AR="es",CO="es",PE="es",VE="es",CL="es"}
local L = LANGS.en
local CurLangCode = "en"
local function SetLang(code)
    if LANGS[code] then CurLangCode=code; L=LANGS[code]
        pcall(function() game:GetService("Players").LocalPlayer.PlayerGui:SetAttribute("TokyoLang",code) end)
    end
end
local function InitLang()
    local saved
    pcall(function() saved=game:GetService("Players").LocalPlayer.PlayerGui:GetAttribute("TokyoLang") end)
    if saved and LANGS[saved] then SetLang(saved); return end
    task.spawn(function()
        local ok,res=pcall(function() return game:HttpGet("https://ipapi.co/country_code/",true) end)
        if ok and res and #res>=2 then
            local cc=res:upper():gsub("%s",""):sub(1,2)
            local lang=COUNTRY_LANG[cc]
            if lang then SetLang(lang) end
        end
    end)
end
InitLang()

local LP  = Players.LocalPlayer
local PG  = LP.PlayerGui
local WHO = LP.Name

-- KEYS
local VALID_KEYS = {
    "TOKYO-FAGF-Y1YI","TOKYO-BTWY-9FSS","TOKYO-UG47-QJE6","TOKYO-IPWG-NOLF",
    "TOKYO-4TUW-ZI5P","TOKYO-LY70-BXHA","TOKYO-8MEG-8EML","TOKYO-3FLD-NNM5",
    "TOKYO-QHWB-E49F","TOKYO-L2DC-6SZF","TOKYO-Y0H0-Y5ZG","TOKYO-KEND-6Q9C",
    "TOKYO-MMTO-8O7D","TOKYO-IR4G-4C5A","TOKYO-PGD7-U485","TOKYO-ACV1-FXB1",
    "TOKYO-3JLX-IDCH","TOKYO-NRRR-7PNX","TOKYO-AQPC-JPP3","TOKYO-XU0H-89MB",
    "TOKYO-2EAS-AD1M","TOKYO-PWGH-Y3JO","TOKYO-2KDW-BLG2","TOKYO-67GV-SQYV",
    "TOKYO-QLFZ-RAO6","TOKYO-QC3Q-WZ42","TOKYO-WFCY-LUDP","TOKYO-D4P0-E68O",
    "TOKYO-QFUC-NF3L","TOKYO-TJ0A-DCZ3","TOKYO-BT8R-XPFA","TOKYO-DFG6-80W9",
    "TOKYO-H2F2-ZIK5","TOKYO-571U-1FTR","TOKYO-573W-DEIR","TOKYO-VHD4-T03G",
    "TOKYO-6BGD-0G76","TOKYO-Y72C-TWQE","TOKYO-MWVS-F65P","TOKYO-NTXS-54AQ",
    "TOKYO-X4MS-9P7S","TOKYO-E0AQ-1X53","TOKYO-EYOB-4JYM","TOKYO-DXGL-VGGC",
    "TOKYO-PXZV-PNC4","TOKYO-V336-7Q4M","TOKYO-KERY-WHJH","TOKYO-ZXJ2-B1WG",
    "TOKYO-6MK8-PBZK","TOKYO-E7CQ-FZO0",
}
local DISCORD  = "https://discord.gg/TUOCODICE"
local KEY_ATTR = "TokyoScriptKey_v2"
local function SaveKey(k) pcall(function() PG:SetAttribute(KEY_ATTR,k) end) end
local function LoadKey() local ok,v=pcall(function() return PG:GetAttribute(KEY_ATTR) end); return ok and v or nil end
local function ValidKey(k)
    if not k or k=="" then return false end
    k=k:upper():gsub("%s","")
    for _,v in ipairs(VALID_KEYS) do if k==v then return true end end
    return false
end

-- CLEANUP
local function Kill(name)
    pcall(function() local o=PG:FindFirstChild(name); if o then o:Destroy() end end)
    pcall(function() local cg=game:GetService("CoreGui"); local o=cg:FindFirstChild(name); if o then o:Destroy() end end)
end
Kill("TokyoGUI"); Kill("TokyoKeyUI"); Kill("TokyoESP")
task.wait(0.05)

-- REMOTES
local RE    = ReplicatedStorage:WaitForChild("RemoteEvents",5)
local Rem   = ReplicatedStorage:WaitForChild("Remotes",5)
local AbSys = ReplicatedStorage:WaitForChild("AbilitySystem",5)
local AbRem = AbSys and AbSys:FindFirstChild("Remotes")
local function Fire(folder,name,a1,a2,a3,a4,a5)
    if not folder then return end
    local r=folder:FindFirstChild(name)
    if r and r:IsA("RemoteEvent") then pcall(function() r:FireServer(a1,a2,a3,a4,a5) end) end
end
local function Invoke(folder,name,a1,a2,a3,a4,a5)
    if not folder then return end
    local r=folder:FindFirstChild(name)
    if r and r:IsA("RemoteFunction") then
        local ok,res=pcall(function() return r:InvokeServer(a1,a2,a3,a4,a5) end)
        if ok then return res end
    end
end
local function REF(n,a1,a2,a3,a4,a5) Fire(RE,   n,a1,a2,a3,a4,a5) end
local function RMF(n,a1,a2,a3,a4,a5) Fire(Rem,  n,a1,a2,a3,a4,a5) end
local function ABF(n,a1,a2,a3,a4,a5) Fire(AbRem,n,a1,a2,a3,a4,a5) end

-- CONFIG
local Cfg = {
    Speed=false, SpeedVal=80,
    InfJump=false, ESP=false,
    Haki=false, Obs=false, Conq=false,
    Farm=false, FarmMob="Thief [Lv.10]", FarmPos="Behind",
    FarmAll=false,
    Skills=false,
    SkillEnabled={Z=true,X=true,C=true,V=true,F=true,Q=false,E=false,R=false,T=false,G=false},
    FarmBoss=false, Boss="Alucard",
    AcptQ=false, CompQ=false, QFarm=false,
    SpawnRim=false, KillRim=false, DiffRim="Normal",
    SpawnAnos=false, KillAnos=false,
    SpawnStr=false, KillStr=false,
    SlimeCraft=false, GrailCraft=false,
    JoinDungeon=false, VoteDungeon=false, DungeonDiff="Extreme",
    Retry=false, DKill=false, SelDungeon="CidDungeon",
    SelStat="Melee", StatAmt="1", AutoStat=false,
    SelIsland="BossIsland", SelNPC="AizenNpc",
    AntiAFK=true,
}

-- LOOP MANAGER
local Loops={}
local function StopLoop(n) Loops[n]=false end
local function StartLoop(n,fn,t)
    StopLoop(n); Loops[n]=true
    task.spawn(function()
        while Loops[n] do pcall(fn); task.wait(t or 0.2) end
    end)
end

-- CHAR HELPERS
local function Char() return LP.Character end
local function Root() local c=Char(); return c and c:FindFirstChild("HumanoidRootPart") end
local function Hum()  local c=Char(); return c and c:FindFirstChildOfClass("Humanoid") end

-- !! FIX: IsNPC definita PRIMA di HasLv e IsTarget !!
local NPC_KW = {
    "crafter","shop","vendor","merchant","npc","quest","trainer","master",
    "guide","keeper","broker","dealer","citizen","elder","chief","recruiter",
    "tutor","blacksmith","upgrade","portal","gate","summon",
}
local function IsNPC(m)
    local n = m.Name:lower()
    for _,kw in ipairs(NPC_KW) do
        if n:find(kw,1,true) then return true end
    end
    for _,v in ipairs(m:GetDescendants()) do
        if v:IsA("TextLabel") then
            local t = v.Text:lower()
            for _,kw in ipairs(NPC_KW) do
                if t:find(kw,1,true) then return true end
            end
        end
    end
    return false
end

local function HasLv(m)
    if m.Name:lower():find("lv") and not IsNPC(m) then return true end
    for _,v in ipairs(m:GetDescendants()) do
        if v:IsA("TextLabel") then
            local t=v.Text:lower()
            if (t:find("lv%.") or t:find("%[lv") or t:find("lv %d")) and not IsNPC(m) then
                return true
            end
        end
    end
    return false
end

local function IsTarget(m)
    if not m or not m.Parent then return false end
    if m==Char() then return false end
    local h=m:FindFirstChildOfClass("Humanoid")
    local r=m:FindFirstChild("HumanoidRootPart")
    if not h or not r then return false end
    if h.Health<=0 then return false end
    if IsNPC(m) then return false end
    return true
end

local function FindByKw(kw)
    local root=Root(); if not root then return nil end
    kw=kw:lower():gsub("%s*%[lv.*",""):gsub("^%s+",""):gsub("%s+$","")
    local best,bd=nil,math.huge
    for _,m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and IsTarget(m) and m.Name:lower():find(kw,1,true) then
            local hr=m:FindFirstChild("HumanoidRootPart")
            if hr then
                local d=(root.Position-hr.Position).Magnitude
                if d<bd then best=m;bd=d end
            end
        end
    end
    return best
end

local function FindLvMob()
    local root=Root(); if not root then return nil end
    local best,bd=nil,math.huge
    for _,m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and IsTarget(m) and HasLv(m) then
            local hr=m:FindFirstChild("HumanoidRootPart")
            if hr then
                local d=(root.Position-hr.Position).Magnitude
                if d<bd then best=m;bd=d end
            end
        end
    end
    return best
end

local function FindAny()
    local root=Root(); if not root then return nil end
    local best,bd=nil,math.huge
    for _,m in ipairs(workspace:GetDescendants()) do
        if m:IsA("Model") and IsTarget(m) then
            local hr=m:FindFirstChild("HumanoidRootPart")
            if hr then
                local d=(root.Position-hr.Position).Magnitude
                if d<bd then best=m;bd=d end
            end
        end
    end
    return best
end

local function TpTo(pos) local r=Root(); if r then r.CFrame=CFrame.new(pos+Vector3.new(0,3,0)) end end
local function TpNear(t)
    if not t or not t.Parent then return end
    local hr=t:FindFirstChild("HumanoidRootPart"); if not hr then return end
    local r=Root(); if not r then return end
    local off=Cfg.FarmPos=="Front" and Vector3.new(0,0,-4)
            or Cfg.FarmPos=="Side"  and Vector3.new(4,0,0)
            or Vector3.new(0,0,4)
    r.CFrame=CFrame.lookAt(hr.Position+off,hr.Position)
end

local function HWKey(kc)
    pcall(function() keypress(kc.Value) end)
    task.wait(0.07)
    pcall(function() keyrelease(kc.Value) end)
end

local function UseSkills()
    local en=Cfg.SkillEnabled or {}
    for _,key in ipairs({"Z","X","C","V","F","Q","E","R","T","G"}) do
        if en[key] then
            local ok,kc=pcall(function() return Enum.KeyCode[key] end)
            if ok and kc then HWKey(kc); pcall(function() ABF("RequestAbility",key) end); task.wait(0.04) end
        end
    end
end

local function Attack(target)
    if not target or not target.Parent then return end
    local mH=Hum(); if not mH or mH.Health<=0 then return end
    local tH=target:FindFirstChildOfClass("Humanoid"); if not tH or tH.Health<=0 then return end
    local hr=target:FindFirstChild("HumanoidRootPart"); if not hr then return end
    TpNear(target)
    local cs=ReplicatedStorage:FindFirstChild("CombatSystem")
    if cs then local rem=cs:FindFirstChild("Remotes"); if rem then Fire(rem,"RequestHit",target) end end
    REF("CombatRemote",target); REF("AttackRemote",target)
    if Cfg.Skills then UseSkills() end
    local ch=Char()
    if ch then
        local has=false
        for _,t in ipairs(ch:GetChildren()) do
            if t:IsA("Tool") then has=true; pcall(function() t:Activate() end) end
        end
        if not has then local t=LP.Backpack:FindFirstChildOfClass("Tool"); if t then t.Parent=ch end end
    end
    pcall(function()
        local cam=workspace.CurrentCamera
        local mid=Vector2.new(cam.ViewportSize.X/2,cam.ViewportSize.Y/2)
        VU:Button1Down(mid,cam.CFrame); task.wait(0.04); VU:Button1Up(mid,cam.CFrame)
    end)
end

-- FEATURES
local ijConn
local function ApplySpeed(on) local h=Hum(); if h then h.WalkSpeed=on and Cfg.SpeedVal or 16 end end
local function ToggleIJ(on)
    if ijConn then ijConn:Disconnect(); ijConn=nil end
    if on then ijConn=UIS.JumpRequest:Connect(function()
        local h=Hum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end) end
end
local function DoHaki()      HWKey(Enum.KeyCode.G); REF("HakiRemote",true); REF("HakiStateUpdate",true) end
local function DoObs()       REF("ObservationHakiRemote",true); REF("ObservationHakiStateUpdate",true) end
local function DoConq()      REF("ConquerorHakiRemote",true); RMF("ConquerorHakiRemote",true) end
local function DoAcceptQ()
    REF("QuestAccept")
    for _,p in ipairs(workspace:GetDescendants()) do
        if p:IsA("ProximityPrompt") and p.ActionText:lower():find("accept") then
            pcall(function() fireproximityprompt(p) end)
        end
    end
end
local function DoCompleteQ() REF("QuestComplete"); REF("QuestRepeat") end
local function DoStat()      local a=tonumber(Cfg.StatAmt) or 1; REF("AllocateStat",Cfg.SelStat,a); RMF("AllocateStats",Cfg.SelStat,a) end
local function DoSpawnRim()  REF("RequestAutoSpawnRimuru",Cfg.DiffRim); RMF("RequestSpawnRimuru",Cfg.DiffRim) end
local function DoSpawnAnos() RMF("RequestAutoSpawnAnos") end
local function DoSpawnStr()  RMF("RequestAutoSpawnStrongest") end
local function DoJoinDun()   RMF("JoinDungeonPortal",Cfg.SelDungeon) end
local function DoDunVote()   RMF("DungeonWaveVote",Cfg.DungeonDiff) end
local IslandPos={
    BossIsland=Vector3.new(0,100,0),DesertIsland=Vector3.new(1000,100,0),
    DungeonIsland=Vector3.new(-1000,100,0),HuecoMundoIsland=Vector3.new(0,100,1000),
    JungleIsland=Vector3.new(0,100,-1000),ShibuyaDestroyed=Vector3.new(-500,100,500),
    SlimeIsland=Vector3.new(500,100,-500),SnowIsland=Vector3.new(1500,100,0),
    StarterIsland=Vector3.new(-1500,100,0),
}
local function TpIsland(n) RMF("TeleportToPortal",n); task.wait(0.5); local p=IslandPos[n]; if p then TpTo(p) end end
local function TpNPC(n)
    local kw=n:lower():gsub("npc",""):gsub("boss","")
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:lower():find(kw) then
            local hr=v:FindFirstChild("HumanoidRootPart"); if hr then TpTo(hr.Position); return end
        end
    end
end
local function StartAFK()
    StartLoop("AFK",function() pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new()) end) end,55)
end
local function PlaySound(id,vol)
    task.spawn(function()
        pcall(function()
            local s=Instance.new("Sound"); s.SoundId="rbxassetid://"..tostring(id)
            s.Volume=vol or 0.8; s.RollOffMaxDistance=9999; s.Parent=SoundService
            s:Play(); task.wait(4); pcall(function() s:Destroy() end)
        end)
    end)
end

-- ESP
local ESPGui=Instance.new("ScreenGui")
ESPGui.Name="TokyoESP"; ESPGui.ResetOnSpawn=false; ESPGui.Parent=PG
local function MakeESP(p)
    if p==LP then return end
    local function build()
        local ch=p.Character; if not ch then return end
        local head=ch:FindFirstChild("Head"); if not head then return end
        local old=ESPGui:FindFirstChild("E_"..p.Name); if old then old:Destroy() end
        local bb=Instance.new("BillboardGui",ESPGui)
        bb.Name="E_"..p.Name; bb.Adornee=head
        bb.Size=UDim2.new(0,150,0,44); bb.StudsOffset=Vector3.new(0,3,0); bb.AlwaysOnTop=true
        local lbl=Instance.new("TextLabel",bb)
        lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1
        lbl.Font=Enum.Font.GothamBold; lbl.TextSize=12; lbl.TextStrokeTransparency=0
        lbl.TextColor3=Color3.fromRGB(130,90,255); lbl.Text=p.Name
        RunService.Heartbeat:Connect(function()
            if not bb.Parent then return end
            local r=Root(); local pr=ch:FindFirstChild("HumanoidRootPart")
            if r and pr then lbl.Text=p.Name.."\n"..math.floor((r.Position-pr.Position).Magnitude).."m" end
        end)
    end
    build(); p.CharacterAdded:Connect(function() task.wait(1); build() end)
end
local function UpdateESP()
    ESPGui:ClearAllChildren()
    if Cfg.ESP then for _,p in ipairs(Players:GetPlayers()) do MakeESP(p) end end
end

-- COLORS
local C = {
    Bg=Color3.fromRGB(10,8,18), Side=Color3.fromRGB(7,5,14),
    Panel=Color3.fromRGB(16,12,30), Row1=Color3.fromRGB(20,15,38), Row2=Color3.fromRGB(14,11,26),
    Hover=Color3.fromRGB(28,20,52),
    Pu=Color3.fromRGB(138,92,255), Pu2=Color3.fromRGB(170,130,255), Pu3=Color3.fromRGB(100,60,200),
    White=Color3.fromRGB(240,235,255), Text=Color3.fromRGB(185,175,215), Dim=Color3.fromRGB(100,88,140),
    Border=Color3.fromRGB(42,30,72), Off=Color3.fromRGB(30,22,54),
    Green=Color3.fromRGB(72,220,130), Red=Color3.fromRGB(220,60,60),
    Gold=Color3.fromRGB(255,200,60), Blue=Color3.fromRGB(88,101,242),
}
local FT=Enum.Font.GothamBold; local FN=Enum.Font.Gotham; local FM=Enum.Font.GothamMedium

-- MAIN GUI
local SG=Instance.new("ScreenGui")
SG.Name="TokyoGUI"; SG.ResetOnSpawn=false
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.Parent=PG

local MF=Instance.new("Frame",SG)
MF.Name="Main"; MF.Size=UDim2.new(0,780,0,510)
MF.Position=UDim2.new(0.5,-390,0.5,-255)
MF.BackgroundColor3=C.Bg; MF.BorderSizePixel=0
MF.ClipsDescendants=true; MF.Visible=false
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,12)
local mStr=Instance.new("UIStroke",MF); mStr.Color=C.Border; mStr.Thickness=1.2

-- TOP BAR
local TB=Instance.new("Frame",MF)
TB.Size=UDim2.new(1,0,0,44); TB.BackgroundColor3=C.Side; TB.BorderSizePixel=0
Instance.new("UICorner",TB).CornerRadius=UDim.new(0,12)
local tbFix=Instance.new("Frame",TB)
tbFix.Size=UDim2.new(1,0,0,12); tbFix.Position=UDim2.new(0,0,1,-12)
tbFix.BackgroundColor3=C.Side; tbFix.BorderSizePixel=0
local TBGrad=Instance.new("Frame",MF)
TBGrad.Size=UDim2.new(1,0,0,2); TBGrad.Position=UDim2.new(0,0,0,44)
TBGrad.BackgroundColor3=C.Pu; TBGrad.BorderSizePixel=0
local tg=Instance.new("UIGradient",TBGrad)
tg.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.Pu3),ColorSequenceKeypoint.new(0.5,C.Pu),ColorSequenceKeypoint.new(1,C.Pu3)})
local TBT=Instance.new("TextLabel",TB)
TBT.Size=UDim2.new(0,200,1,0); TBT.Position=UDim2.new(0,14,0,0)
TBT.BackgroundTransparency=1; TBT.Text="Tokyo Script"
TBT.TextColor3=C.White; TBT.Font=FT; TBT.TextSize=16
TBT.TextXAlignment=Enum.TextXAlignment.Left
local TBV=Instance.new("TextLabel",TB)
TBV.Size=UDim2.new(0,40,1,0); TBV.Position=UDim2.new(0,218,0,0)
TBV.BackgroundTransparency=1; TBV.Text="v1.0"
TBV.TextColor3=C.Dim; TBV.Font=FN; TBV.TextSize=11
TBV.TextXAlignment=Enum.TextXAlignment.Left
local TBH=Instance.new("TextLabel",TB)
TBH.Size=UDim2.new(0,140,1,0); TBH.Position=UDim2.new(0.5,-70,0,0)
TBH.BackgroundTransparency=1; TBH.Text=KEY_UI_EN.hotkey
TBH.TextColor3=C.Dim; TBH.Font=FN; TBH.TextSize=9

local function WBtn(col,ox,sym,fn)
    local b=Instance.new("TextButton",TB)
    b.Size=UDim2.new(0,14,0,14); b.Position=UDim2.new(1,ox,0.5,-7)
    b.BackgroundColor3=col; b.Text=sym; b.Font=FT; b.TextSize=9
    b.TextColor3=Color3.fromRGB(15,15,15); b.BorderSizePixel=0
    Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
    b.MouseButton1Click:Connect(fn); return b
end
WBtn(Color3.fromRGB(255,80,80),-22,"x",function() SG:Destroy() end)
WBtn(Color3.fromRGB(255,185,50),-42,"-",function() MF.Visible=not MF.Visible end)

-- DRAG
local drag,ds,sp=false
TB.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=true;ds=i.Position;sp=MF.Position end end)
TB.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then drag=false end end)
UIS.InputChanged:Connect(function(i)
    if drag and i.UserInputType==Enum.UserInputType.MouseMovement then
        local d=i.Position-ds
        MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
    end
end)
UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode==Enum.KeyCode.LeftControl then MF.Visible=not MF.Visible end
end)

-- SIDEBAR
local SB=Instance.new("Frame",MF)
SB.Size=UDim2.new(0,162,1,-46); SB.Position=UDim2.new(0,0,0,46)
SB.BackgroundColor3=C.Side; SB.BorderSizePixel=0
local SBL=Instance.new("UIListLayout",SB); SBL.SortOrder=Enum.SortOrder.LayoutOrder
local SBLogo=Instance.new("TextLabel",SB)
SBLogo.Size=UDim2.new(1,0,0,54); SBLogo.BackgroundTransparency=1
SBLogo.Text="TOKYO\nSCRIPT"; SBLogo.TextColor3=C.Pu; SBLogo.Font=FT
SBLogo.TextSize=12; SBLogo.LayoutOrder=0
local Sep=Instance.new("Frame",MF)
Sep.Size=UDim2.new(0,1,1,-46); Sep.Position=UDim2.new(0,162,0,46)
Sep.BackgroundColor3=C.Border; Sep.BorderSizePixel=0

-- CONTENT AREA
local CA=Instance.new("ScrollingFrame",MF)
CA.Size=UDim2.new(1,-163,1,-46); CA.Position=UDim2.new(0,163,0,46)
CA.BackgroundColor3=C.Bg; CA.BorderSizePixel=0
CA.ScrollBarThickness=3; CA.ScrollBarImageColor3=C.Pu
CA.CanvasSize=UDim2.new(0,0,0,0); CA.AutomaticCanvasSize=Enum.AutomaticSize.Y
local CAL=Instance.new("UIListLayout",CA); CAL.SortOrder=Enum.SortOrder.LayoutOrder; CAL.Padding=UDim.new(0,1)
local CAP=Instance.new("UIPadding",CA)
CAP.PaddingTop=UDim.new(0,10); CAP.PaddingLeft=UDim.new(0,14)
CAP.PaddingRight=UDim.new(0,14); CAP.PaddingBottom=UDim.new(0,12)

-- PAGE SYSTEM
local Pages,CurPage,RowN={},nil,0
local function NewPage(n)
    local f=Instance.new("Frame",CA); f.Name=n
    f.Size=UDim2.new(1,0,0,0); f.AutomaticSize=Enum.AutomaticSize.Y
    f.BackgroundTransparency=1; f.Visible=false
    local l=Instance.new("UIListLayout",f); l.SortOrder=Enum.SortOrder.LayoutOrder; l.Padding=UDim.new(0,2)
    Pages[n]=f; return f
end
local function ShowPage(n)
    if CurPage and Pages[CurPage] then Pages[CurPage].Visible=false end
    CurPage=n; if Pages[n] then Pages[n].Visible=true end
    CA.CanvasPosition=Vector2.new(0,0)
end

-- SIDEBAR BUTTONS
local SBBtns={}
local function SideBtn(lbl,ico,page,ord)
    local btn=Instance.new("TextButton",SB)
    btn.Size=UDim2.new(1,0,0,38); btn.BackgroundTransparency=1
    btn.BackgroundColor3=C.Side; btn.BorderSizePixel=0; btn.Text=""; btn.LayoutOrder=ord
    local bar=Instance.new("Frame",btn)
    bar.Size=UDim2.new(0,3,0.6,0); bar.Position=UDim2.new(0,0,0.2,0)
    bar.BackgroundColor3=C.Pu; bar.BorderSizePixel=0; bar.Visible=false
    Instance.new("UICorner",bar).CornerRadius=UDim.new(1,0)
    local pill=Instance.new("Frame",btn)
    pill.Size=UDim2.new(1,-8,0.75,0); pill.Position=UDim2.new(0,4,0.125,0)
    pill.BackgroundColor3=C.Pu; pill.BackgroundTransparency=1; pill.BorderSizePixel=0
    Instance.new("UICorner",pill).CornerRadius=UDim.new(0,8)
    local ic=Instance.new("TextLabel",btn)
    ic.Size=UDim2.new(0,28,1,0); ic.Position=UDim2.new(0,12,0,0)
    ic.BackgroundTransparency=1; ic.Text=ico; ic.Font=FT; ic.TextSize=15; ic.TextColor3=C.Dim
    local tx=Instance.new("TextLabel",btn)
    tx.Size=UDim2.new(1,-44,1,0); tx.Position=UDim2.new(0,44,0,0)
    tx.BackgroundTransparency=1; tx.Text=lbl; tx.Font=FM; tx.TextSize=13
    tx.TextColor3=C.Dim; tx.TextXAlignment=Enum.TextXAlignment.Left
    btn.MouseButton1Click:Connect(function()
        for _,b in pairs(SBBtns) do
            b.btn.BackgroundTransparency=1
            TweenService:Create(b.pill,TweenInfo.new(0.15),{BackgroundTransparency=1}):Play()
            b.bar.Visible=false; b.ic.TextColor3=C.Dim; b.tx.TextColor3=C.Dim
        end
        TweenService:Create(pill,TweenInfo.new(0.15),{BackgroundTransparency=0.85}):Play()
        bar.Visible=true; ic.TextColor3=C.Pu; tx.TextColor3=C.White
        ShowPage(page)
    end)
    btn.MouseEnter:Connect(function()
        if not bar.Visible then TweenService:Create(pill,TweenInfo.new(0.1),{BackgroundTransparency=0.94}):Play() end
    end)
    btn.MouseLeave:Connect(function()
        if not bar.Visible then TweenService:Create(pill,TweenInfo.new(0.1),{BackgroundTransparency=1}):Play() end
    end)
    table.insert(SBBtns,{btn=btn,bar=bar,ic=ic,tx=tx,pill=pill})
end

-- WIDGETS
local function NextBg() RowN=RowN+1; return RowN%2==0 and C.Row1 or C.Row2 end
local function MkTitle(parent,text)
    RowN=RowN+1
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,46); f.BackgroundTransparency=1; f.LayoutOrder=RowN
    local lb=Instance.new("TextLabel",f)
    lb.Size=UDim2.new(1,0,0,28); lb.Position=UDim2.new(0,0,0,12)
    lb.BackgroundTransparency=1; lb.Text=text
    lb.TextColor3=C.White; lb.Font=FT; lb.TextSize=17
    lb.TextXAlignment=Enum.TextXAlignment.Left
    local ln=Instance.new("Frame",f)
    ln.Size=UDim2.new(1,0,0,1); ln.Position=UDim2.new(0,0,1,-1)
    ln.BackgroundColor3=C.Pu; ln.BorderSizePixel=0
    local lng=Instance.new("UIGradient",ln)
    lng.Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.Pu),ColorSequenceKeypoint.new(0.6,C.Pu3),ColorSequenceKeypoint.new(1,C.Bg)})
end
local function MkSect(parent,text)
    RowN=RowN+1
    local f=Instance.new("Frame",parent)
    f.Size=UDim2.new(1,0,0,30); f.BackgroundTransparency=1; f.LayoutOrder=RowN
    local lb=Instance.new("TextLabel",f)
    lb.Size=UDim2.new(1,0,0,16); lb.Position=UDim2.new(0,2,1,-18)
    lb.BackgroundTransparency=1; lb.Text=text:upper()
    lb.TextColor3=C.Pu; lb.Font=FT; lb.TextSize=9
    lb.TextXAlignment=Enum.TextXAlignment.Left
    local ln=Instance.new("Frame",f)
    ln.Size=UDim2.new(1,0,0,1); ln.Position=UDim2.new(0,0,1,-1)
    ln.BackgroundColor3=C.Border; ln.BorderSizePixel=0
end
local function MkToggle(parent,label,cfgKey,cb)
    RowN=RowN+1; local bg=NextBg()
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=bg
    row.BorderSizePixel=0; row.LayoutOrder=RowN
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local pill=Instance.new("Frame",row)
    pill.Size=UDim2.new(0,36,0,20); pill.Position=UDim2.new(1,-48,0.5,-10)
    pill.BackgroundColor3=Cfg[cfgKey] and C.Pu or C.Off; pill.BorderSizePixel=0
    Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0)
    local knob=Instance.new("Frame",pill)
    knob.Size=UDim2.new(0,16,0,16); knob.Position=Cfg[cfgKey] and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    knob.BackgroundColor3=C.White; knob.BorderSizePixel=0
    Instance.new("UICorner",knob).CornerRadius=UDim.new(1,0)
    local lb=Instance.new("TextLabel",row)
    lb.Size=UDim2.new(1,-60,1,0); lb.Position=UDim2.new(0,12,0,0)
    lb.BackgroundTransparency=1; lb.Text=label
    lb.TextColor3=Cfg[cfgKey] and C.White or C.Text; lb.Font=FM; lb.TextSize=13
    lb.TextXAlignment=Enum.TextXAlignment.Left
    local ti=TweenInfo.new(0.15,Enum.EasingStyle.Quad)
    local function Set(v)
        Cfg[cfgKey]=v
        TweenService:Create(pill,ti,{BackgroundColor3=v and C.Pu or C.Off}):Play()
        TweenService:Create(knob,ti,{Position=v and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
        TweenService:Create(lb,ti,{TextColor3=v and C.White or C.Text}):Play()
        if cb then cb(v) end
    end
    local clk=Instance.new("TextButton",row)
    clk.Size=UDim2.new(1,0,1,0); clk.BackgroundTransparency=1; clk.Text=""
    clk.MouseButton1Click:Connect(function() Set(not Cfg[cfgKey]) end)
    clk.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.08),{BackgroundColor3=C.Hover}):Play() end)
    clk.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.08),{BackgroundColor3=bg}):Play() end)
end
local DropOv=Instance.new("Frame",SG)
DropOv.Size=UDim2.new(1,0,1,0); DropOv.BackgroundTransparency=1; DropOv.ZIndex=200; DropOv.Active=false
local activeDL=nil
DropOv.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 then
        if activeDL then activeDL.Visible=false; activeDL=nil end
        DropOv.Active=false
    end
end)
local function MkDropdown(parent,label,opts,cfgKey,cb)
    RowN=RowN+1; local bg=NextBg()
    local row=Instance.new("Frame",parent)
    row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=bg
    row.BorderSizePixel=0; row.LayoutOrder=RowN
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local lb=Instance.new("TextLabel",row)
    lb.Size=UDim2.new(0.44,0,1,0); lb.Position=UDim2.new(0,12,0,0)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C.Text; lb.Font=FM; lb.TextSize=13
    lb.TextXAlignment=Enum.TextXAlignment.Left
    local sel=Instance.new("TextButton",row)
    sel.Size=UDim2.new(0.52,-4,0,24); sel.Position=UDim2.new(0.46,0,0.5,-12)
    sel.BackgroundColor3=C.Panel; sel.BorderSizePixel=0
    sel.Text=tostring(Cfg[cfgKey] or opts[1])
    sel.TextColor3=C.Pu; sel.Font=FM; sel.TextSize=12
    Instance.new("UICorner",sel).CornerRadius=UDim.new(0,6)
    local sStr=Instance.new("UIStroke",sel); sStr.Color=C.Border; sStr.Thickness=1
    local arr=Instance.new("TextLabel",sel)
    arr.Size=UDim2.new(0,18,1,0); arr.Position=UDim2.new(1,-18,0,0)
    arr.BackgroundTransparency=1; arr.Text="v"; arr.Font=FT; arr.TextSize=11; arr.TextColor3=C.Pu
    local dlH=math.min(#opts,8)*28
    local dl=Instance.new("Frame",DropOv)
    dl.BackgroundColor3=Color3.fromRGB(13,10,24); dl.BorderSizePixel=0
    dl.Visible=false; dl.ZIndex=201
    Instance.new("UICorner",dl).CornerRadius=UDim.new(0,8)
    local dlStr=Instance.new("UIStroke",dl); dlStr.Color=C.Border; dlStr.Thickness=1
    local dlSc=Instance.new("ScrollingFrame",dl)
    dlSc.Size=UDim2.new(1,-2,1,-2); dlSc.Position=UDim2.new(0,1,0,1)
    dlSc.BackgroundTransparency=1; dlSc.BorderSizePixel=0
    dlSc.ScrollBarThickness=3; dlSc.ScrollBarImageColor3=C.Pu
    dlSc.CanvasSize=UDim2.new(0,0,0,#opts*28); dlSc.ZIndex=202
    Instance.new("UIListLayout",dlSc).SortOrder=Enum.SortOrder.LayoutOrder
    for i,opt in ipairs(opts) do
        local ob=Instance.new("TextButton",dlSc)
        ob.Size=UDim2.new(1,0,0,28); ob.BackgroundColor3=Color3.fromRGB(13,10,24)
        ob.Text="   "..opt; ob.TextColor3=C.Text; ob.Font=FM; ob.TextSize=12
        ob.BorderSizePixel=0; ob.TextXAlignment=Enum.TextXAlignment.Left; ob.ZIndex=203; ob.LayoutOrder=i
        ob.MouseEnter:Connect(function() ob.BackgroundColor3=C.Hover; ob.TextColor3=C.Pu end)
        ob.MouseLeave:Connect(function() ob.BackgroundColor3=Color3.fromRGB(13,10,24); ob.TextColor3=C.Text end)
        ob.MouseButton1Click:Connect(function()
            Cfg[cfgKey]=opt; sel.Text=opt
            dl.Visible=false; activeDL=nil; DropOv.Active=false
            if cb then cb(opt) end
        end)
    end
    sel.MouseButton1Click:Connect(function()
        if activeDL and activeDL~=dl then activeDL.Visible=false end
        if dl.Visible then dl.Visible=false; activeDL=nil; DropOv.Active=false; return end
        local ap=sel.AbsolutePosition; local as=sel.AbsoluteSize
        local scrH=workspace.CurrentCamera.ViewportSize.Y
        local w=math.max(as.X+20,180)
        dl.Size=UDim2.new(0,w,0,dlH)
        if scrH-(ap.Y+as.Y)<dlH+8 then dl.Position=UDim2.new(0,ap.X,0,ap.Y-dlH-4)
        else dl.Position=UDim2.new(0,ap.X,0,ap.Y+as.Y+4) end
        dl.Visible=true; activeDL=dl; DropOv.Active=true
    end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.08),{BackgroundColor3=C.Hover}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.08),{BackgroundColor3=bg}):Play() end)
end
local function MkBtn(parent,label,cb)
    RowN=RowN+1; local bg=NextBg()
    local row=Instance.new("TextButton",parent)
    row.Size=UDim2.new(1,0,0,34); row.BackgroundColor3=bg
    row.BorderSizePixel=0; row.Text=""; row.LayoutOrder=RowN
    Instance.new("UICorner",row).CornerRadius=UDim.new(0,8)
    local lb=Instance.new("TextLabel",row)
    lb.Size=UDim2.new(1,-36,1,0); lb.Position=UDim2.new(0,14,0,0)
    lb.BackgroundTransparency=1; lb.Text=label; lb.TextColor3=C.Text
    lb.Font=FM; lb.TextSize=13; lb.TextXAlignment=Enum.TextXAlignment.Left
    local ar=Instance.new("TextLabel",row)
    ar.Size=UDim2.new(0,22,1,0); ar.Position=UDim2.new(1,-26,0,0)
    ar.BackgroundTransparency=1; ar.Text=">"; ar.Font=FT; ar.TextSize=20; ar.TextColor3=C.Pu
    row.MouseButton1Click:Connect(function()
        TweenService:Create(row,TweenInfo.new(0.07),{BackgroundColor3=C.Pu3}):Play()
        task.delay(0.07,function() TweenService:Create(row,TweenInfo.new(0.15),{BackgroundColor3=bg}):Play() end)
        if cb then cb() end
    end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.08),{BackgroundColor3=C.Hover}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.08),{BackgroundColor3=bg}):Play() end)
end

-- PAGES
local PM=NewPage("Main"); MkTitle(PM,L.pg_main)
MkSect(PM,L.s_player)
MkToggle(PM,L.t_speed,"Speed",function(v)
    if v then StartLoop("Speed",function() ApplySpeed(true) end,1) else StopLoop("Speed"); ApplySpeed(false) end
end)
MkToggle(PM,L.t_jump,"InfJump",function(v) ToggleIJ(v) end)
MkToggle(PM,L.t_esp,"ESP",function() UpdateESP() end)
MkSect(PM,L.s_haki)
MkToggle(PM,L.t_haki,"Haki",function(v) if v then DoHaki() end end)
MkToggle(PM,L.t_obs,"Obs",function(v)
    if v then StartLoop("Obs",DoObs,3) else StopLoop("Obs") end
end)
MkToggle(PM,L.t_conq,"Conq",function(v)
    if v then StartLoop("Conq",DoConq,3) else StopLoop("Conq") end
end)

local PAF=NewPage("Farm"); MkTitle(PAF,L.pg_farm)
MkSect(PAF,L.s_mob)
MkDropdown(PAF,L.d_mob,{
    "Thief [Lv.10]","Thief Boss [Lv.25]","Monkey [Lv.250]","Monkey Boss [Lv.500]",
    "Desert Bandit [Lv.750]","Desert Boss [Lv.1000]","Frost Rogue [Lv.1500]",
    "Snow Boss [Lv.2000]","Sorcerer Student [Lv.3000]","Panda Boss [Lv.4000]",
    "Hollow [Lv.5000]","Strong Sorcerer [Lv.6000]","Curse [Lv.7000]",
    "Slime [Lv.8000]","Academy Teacher [Lv.9000]",
},"FarmMob")
MkDropdown(PAF,L.d_pos,{"Behind","Front","Side"},"FarmPos")
MkToggle(PAF,L.t_farm,"Farm",function(v)
    if v then
        StartLoop("Farm",function()
            local kw=Cfg.FarmMob:lower():gsub("%s*%[lv.*",""):gsub("^%s+",""):gsub("%s+$","")
            local m=FindByKw(kw); if m then Attack(m) end
        end,0.3)
    else StopLoop("Farm") end
end)
MkSect(PAF,L.s_farmall)
MkToggle(PAF,L.t_farmall,"FarmAll",function(v)
    if v then StartLoop("FarmAll",function() local m=FindLvMob(); if m then Attack(m) end end,0.3)
    else StopLoop("FarmAll") end
end)
MkSect(PAF,L.s_skills)
do
    RowN=RowN+1
    local ALL={"Z","X","C","V","F","Q","E","R","T","G"}
    local sWrap=Instance.new("Frame",PAF)
    sWrap.Size=UDim2.new(1,0,0,58); sWrap.BackgroundColor3=C.Row1
    sWrap.BorderSizePixel=0; sWrap.LayoutOrder=RowN
    Instance.new("UICorner",sWrap).CornerRadius=UDim.new(0,8)
    local sInfo=Instance.new("TextLabel",sWrap)
    sInfo.Size=UDim2.new(1,0,0,16); sInfo.Position=UDim2.new(0,12,0,6)
    sInfo.BackgroundTransparency=1; sInfo.Text=L.skill_info
    sInfo.TextColor3=C.Dim; sInfo.Font=FN; sInfo.TextSize=10
    sInfo.TextXAlignment=Enum.TextXAlignment.Left
    local sBtns=Instance.new("Frame",sWrap)
    sBtns.Size=UDim2.new(1,-24,0,28); sBtns.Position=UDim2.new(0,12,0,24)
    sBtns.BackgroundTransparency=1; sBtns.BorderSizePixel=0
    local sLayout=Instance.new("UIListLayout",sBtns)
    sLayout.FillDirection=Enum.FillDirection.Horizontal
    sLayout.SortOrder=Enum.SortOrder.LayoutOrder; sLayout.Padding=UDim.new(0,4)
    for i,key in ipairs(ALL) do
        local en=Cfg.SkillEnabled[key] or false
        local btn=Instance.new("TextButton",sBtns)
        btn.Size=UDim2.new(0,28,0,26); btn.Text=key; btn.LayoutOrder=i
        btn.BackgroundColor3=en and C.Pu or C.Off
        btn.TextColor3=en and C.White or C.Dim
        btn.Font=FT; btn.TextSize=12; btn.BorderSizePixel=0
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
        local bStr=Instance.new("UIStroke",btn); bStr.Color=en and C.Pu or C.Border; bStr.Thickness=1
        btn.MouseButton1Click:Connect(function()
            Cfg.SkillEnabled[key]=not Cfg.SkillEnabled[key]
            local on=Cfg.SkillEnabled[key]
            TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=on and C.Pu or C.Off,TextColor3=on and C.White or C.Dim}):Play()
            bStr.Color=on and C.Pu or C.Border
        end)
    end
end
MkToggle(PAF,L.t_skills,"Skills")
MkBtn(PAF,L.b_skills,function() UseSkills() end)
MkSect(PAF,L.s_bossfarm)
MkDropdown(PAF,L.d_boss,{"Alucard","Gojo","Rimuru","Gilgamesh","Valentine","Anos","Slime"},"Boss")
MkToggle(PAF,L.t_bossfarm,"FarmBoss",function(v)
    if v then StartLoop("FarmBoss",function() local m=FindByKw(Cfg.Boss:lower()); if m then Attack(m) end end,0.3)
    else StopLoop("FarmBoss") end
end)

local PAQ=NewPage("Quest"); MkTitle(PAQ,L.pg_quest)
MkSect(PAQ,L.s_quest)
MkToggle(PAQ,L.t_acceptq,"AcptQ",function(v)
    if v then StartLoop("AcptQ",DoAcceptQ,1.5) else StopLoop("AcptQ") end
end)
MkToggle(PAQ,L.t_completeq,"CompQ",function(v)
    if v then StartLoop("CompQ",DoCompleteQ,1) else StopLoop("CompQ") end
end)
MkToggle(PAQ,L.t_qfarm,"QFarm",function(v)
    if v then StartLoop("QFarm",function() local m=FindLvMob(); if m then Attack(m) end end,0.3)
    else StopLoop("QFarm") end
end)
MkBtn(PAQ,L.b_acceptq,function() DoAcceptQ() end)
MkBtn(PAQ,L.b_completeq,function() DoCompleteQ() end)

local PB=NewPage("Boss"); MkTitle(PB,L.pg_boss)
MkSect(PB,"Rimuru")
MkDropdown(PB,L.diff,{"Normal","Hard","Extreme"},"DiffRim")
MkToggle(PB,L.t_spawnrim,"SpawnRim",function(v)
    if v then StartLoop("SpawnRim",DoSpawnRim,4) else StopLoop("SpawnRim") end
end)
MkToggle(PB,L.t_killrim,"KillRim",function(v)
    if v then StartLoop("KillRim",function() local m=FindByKw("rimuru"); if m then Attack(m) end end,0.3)
    else StopLoop("KillRim") end
end)
MkSect(PB,"Anos")
MkToggle(PB,L.t_spawnanos,"SpawnAnos",function(v)
    if v then StartLoop("SpawnAnos",DoSpawnAnos,4) else StopLoop("SpawnAnos") end
end)
MkToggle(PB,L.t_killanos,"KillAnos",function(v)
    if v then StartLoop("KillAnos",function() local m=FindByKw("anos"); if m then Attack(m) end end,0.3)
    else StopLoop("KillAnos") end
end)
MkSect(PB,L.s_strongest)
MkToggle(PB,L.t_spawnstr,"SpawnStr",function(v)
    if v then StartLoop("SpawnStr",DoSpawnStr,4) else StopLoop("SpawnStr") end
end)
MkToggle(PB,L.t_killstr,"KillStr",function(v)
    if v then StartLoop("KillStr",function() local m=FindAny(); if m then Attack(m) end end,0.3)
    else StopLoop("KillStr") end
end)
MkSect(PB,L.s_craft)
MkToggle(PB,L.t_slime,"SlimeCraft",function(v)
    if v then StartLoop("SLCraft",function() Invoke(Rem,"RequestSlimeCraft") end,3) else StopLoop("SLCraft") end
end)
MkToggle(PB,L.t_grail,"GrailCraft",function(v)
    if v then StartLoop("GRCraft",function() Invoke(Rem,"RequestGrailCraft") end,3) else StopLoop("GRCraft") end
end)

local PD=NewPage("Dungeon"); MkTitle(PD,L.pg_dun)
MkSect(PD,"Join")
MkDropdown(PD,L.d_dun,{"CidDungeon","ShadowDungeon","FrostDungeon","VoidDungeon"},"SelDungeon")
MkToggle(PD,L.t_joindun,"JoinDungeon",function(v)
    if v then StartLoop("JoinD",DoJoinDun,2) else StopLoop("JoinD") end
end)
MkSect(PD,L.s_wave)
MkDropdown(PD,L.diff,{"Normal","Hard","Extreme"},"DungeonDiff")
MkToggle(PD,L.t_vote,"VoteDungeon",function(v)
    if v then StartLoop("VoteD",DoDunVote,1) else StopLoop("VoteD") end
end)
MkToggle(PD,L.t_retry,"Retry",function(v)
    if v then StartLoop("Retry",function() RMF("DungeonWaveReplayVote") end,3) else StopLoop("Retry") end
end)
MkToggle(PD,L.t_dkill,"DKill",function(v)
    if v then StartLoop("DKill",function() local m=FindAny(); if m then Attack(m) end end,0.3)
    else StopLoop("DKill") end
end)
MkBtn(PD,L.b_leave,function() RMF("LeaveDungeonPortal") end)

local PSt=NewPage("Stats"); MkTitle(PSt,L.pg_stats)
MkSect(PSt,L.s_upgrade)
MkDropdown(PSt,L.d_stat,{"Melee","Defense","Sword","Power","Spirit"},"SelStat")
MkDropdown(PSt,L.d_qty,{"1","5","10","50","100","999"},"StatAmt")
MkToggle(PSt,L.t_autostat,"AutoStat",function(v)
    if v then StartLoop("UpgStat",DoStat,0.5) else StopLoop("UpgStat") end
end)
MkBtn(PSt,L.b_upgrade,function() DoStat() end)

local PTP=NewPage("Teleport"); MkTitle(PTP,L.pg_tp)
MkSect(PTP,L.s_island)
MkDropdown(PTP,L.d_island,{
    "BossIsland","DesertIsland","DungeonIsland","HuecoMundoIsland",
    "JungleIsland","ShibuyaDestroyed","SlimeIsland","SnowIsland","StarterIsland"
},"SelIsland")
MkBtn(PTP,L.b_tpisland,function() TpIsland(Cfg.SelIsland) end)
MkSect(PTP,L.s_npc)
MkDropdown(PTP,L.d_npc,{
    "AizenNpc","GojoBoss","RimuruNpc","CidNpc","ShopNpc","QuestNpc","SummonNpc","AnosNpc","GilgameshNpc"
},"SelNPC")
MkBtn(PTP,L.b_tpnpc,function() TpNPC(Cfg.SelNPC) end)

local PSet=NewPage("Settings"); MkTitle(PSet,L.pg_settings)
MkSect(PSet,"Language / Lingua / Idioma")
do
    RowN=RowN+1; local bg=NextBg()
    local lrow=Instance.new("Frame",PSet)
    lrow.Size=UDim2.new(1,0,0,52); lrow.BackgroundColor3=bg
    lrow.BorderSizePixel=0; lrow.LayoutOrder=RowN
    Instance.new("UICorner",lrow).CornerRadius=UDim.new(0,8)
    local info=Instance.new("TextLabel",lrow)
    info.Size=UDim2.new(1,0,0,18); info.Position=UDim2.new(0,12,0,6)
    info.BackgroundTransparency=1; info.Text="Select Language / Seleziona Lingua"
    info.TextColor3=C.Dim; info.Font=FM; info.TextSize=10
    info.TextXAlignment=Enum.TextXAlignment.Left
    local btnRow=Instance.new("Frame",lrow)
    btnRow.Size=UDim2.new(1,-24,0,26); btnRow.Position=UDim2.new(0,12,0,22)
    btnRow.BackgroundTransparency=1
    local bLayout=Instance.new("UIListLayout",btnRow)
    bLayout.FillDirection=Enum.FillDirection.Horizontal
    bLayout.SortOrder=Enum.SortOrder.LayoutOrder; bLayout.Padding=UDim.new(0,8)
    local LANG_OPTS={{code="it",label="IT  Italiano"},{code="en",label="EN  English"},{code="es",label="ES  Espanol"}}
    local langBtns={}
    local function UpdateLangBtns()
        for _,b in pairs(langBtns) do
            local active=b.code==CurLangCode
            TweenService:Create(b.f,TweenInfo.new(0.12),{BackgroundColor3=active and C.Pu or C.Off}):Play()
            b.s.Color=active and C.Pu or C.Border
        end
    end
    for i,opt in ipairs(LANG_OPTS) do
        local btn=Instance.new("TextButton",btnRow)
        btn.Size=UDim2.new(0,110,0,26); btn.LayoutOrder=i
        btn.BackgroundColor3=opt.code==CurLangCode and C.Pu or C.Off
        btn.TextColor3=opt.code==CurLangCode and C.White or C.Dim
        btn.Text=opt.label; btn.Font=FT; btn.TextSize=11; btn.BorderSizePixel=0
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
        local bStr=Instance.new("UIStroke",btn)
        bStr.Color=opt.code==CurLangCode and C.Pu or C.Border; bStr.Thickness=1
        table.insert(langBtns,{f=btn,code=opt.code,s=bStr})
        btn.MouseButton1Click:Connect(function() SetLang(opt.code); UpdateLangBtns() end)
    end
end
MkSect(PSet,L.s_misc)
MkToggle(PSet,L.t_afk,"AntiAFK",function(v)
    if v then StartAFK() else StopLoop("AFK") end
end)
MkBtn(PSet,L.b_destroy,function() SG:Destroy(); ESPGui:Destroy() end)

-- SIDEBAR
SideBtn(L.sb_main,    "H","Main",    1)
SideBtn(L.sb_farm,    "F","Farm",    2)
SideBtn(L.sb_quest,   "Q","Quest",   3)
SideBtn(L.sb_boss,    "B","Boss",    4)
SideBtn(L.sb_dungeon, "D","Dungeon", 5)
SideBtn(L.sb_stats,   "S","Stats",   6)
SideBtn(L.sb_tp,      "T","Teleport",7)
SideBtn(L.sb_settings,"X","Settings",8)

-- OPEN MENU
local function OpenMenu()
    MF.Visible=true
    MF.Size=UDim2.new(0,0,0,0); MF.Position=UDim2.new(0.5,0,0.5,0)
    TweenService:Create(MF,TweenInfo.new(0.42,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,780,0,510), Position=UDim2.new(0.5,-390,0.5,-255)
    }):Play()
    task.wait(0.18); ShowPage("Main")
    if SBBtns[1] then
        local b=SBBtns[1]
        TweenService:Create(b.pill,TweenInfo.new(0.15),{BackgroundTransparency=0.85}):Play()
        b.bar.Visible=true; b.ic.TextColor3=C.Pu; b.tx.TextColor3=C.White
    end
end

if Cfg.AntiAFK then StartAFK() end
LP.CharacterAdded:Connect(function(ch)
    task.wait(0.5)
    if Cfg.Speed   then local h=ch:WaitForChild("Humanoid",3); if h then h.WalkSpeed=Cfg.SpeedVal end end
    if Cfg.InfJump then ToggleIJ(true) end
    if Cfg.ESP     then task.wait(1); UpdateESP() end
end)

-- KEY GUI
local KG=Instance.new("ScreenGui")
KG.Name="TokyoKeyUI"; KG.ResetOnSpawn=false
KG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
KG.IgnoreGuiInset=true; KG.Parent=PG

local KBg=Instance.new("Frame",KG)
KBg.Size=UDim2.new(1,0,1,0); KBg.BackgroundColor3=Color3.fromRGB(5,3,12)
KBg.BackgroundTransparency=0.3; KBg.BorderSizePixel=0; KBg.ZIndex=1

local OniF=Instance.new("Frame",KG)
OniF.Size=UDim2.new(1,0,1,0); OniF.BackgroundTransparency=1; OniF.ZIndex=2
local flakes={}
for i=1,30 do
    local l=Instance.new("TextLabel",OniF)
    l.BackgroundTransparency=1; l.ZIndex=2; l.Font=Enum.Font.GothamBold
    l.TextSize=math.random(10,22)
    l.Text=({"*","+","o","."})[math.random(4)]
    l.TextColor3=Color3.fromRGB(math.random(90,170),math.random(50,120),255)
    l.TextTransparency=math.random(3,7)/10
    l.Size=UDim2.new(0,28,0,28)
    local sx=math.random(0,100)/100
    l.Position=UDim2.new(sx,0,math.random(-20,100)/100,0)
    flakes[i]={l=l,x=sx,spd=math.random(2,8)/10}
end
local snowConn=RunService.Heartbeat:Connect(function(dt)
    for _,f in ipairs(flakes) do
        local ny=(f.l.Position.Y.Scale or 0)+dt*f.spd*0.05
        if ny>1.08 then ny=-0.06; f.x=math.random(0,100)/100 end
        f.l.Position=UDim2.new(f.x,0,ny,0)
    end
end)

local KC=Instance.new("Frame",KG)
KC.Size=UDim2.new(0,0,0,0); KC.Position=UDim2.new(0.5,0,0.5,0)
KC.BackgroundColor3=Color3.fromRGB(10,8,18); KC.BorderSizePixel=0
KC.ZIndex=10; KC.ClipsDescendants=true
Instance.new("UICorner",KC).CornerRadius=UDim.new(0,14)
local KCStr=Instance.new("UIStroke",KC); KCStr.Color=Color3.fromRGB(42,30,72); KCStr.Thickness=1.2

TweenService:Create(KC,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
    Size=UDim2.new(0,480,0,300), Position=UDim2.new(0.5,-240,0.5,-150)
}):Play()

local KTop=Instance.new("Frame",KC)
KTop.Size=UDim2.new(1,0,0,42); KTop.BackgroundColor3=Color3.fromRGB(7,5,14); KTop.BorderSizePixel=0
Instance.new("UICorner",KTop).CornerRadius=UDim.new(0,14)
local kTopFix=Instance.new("Frame",KTop)
kTopFix.Size=UDim2.new(1,0,0,14); kTopFix.Position=UDim2.new(0,0,1,-14)
kTopFix.BackgroundColor3=Color3.fromRGB(7,5,14); kTopFix.BorderSizePixel=0
local KTopLine=Instance.new("Frame",KC)
KTopLine.Size=UDim2.new(1,0,0,2); KTopLine.Position=UDim2.new(0,0,0,42)
KTopLine.BackgroundColor3=Color3.fromRGB(138,92,255); KTopLine.BorderSizePixel=0
local KTit=Instance.new("TextLabel",KTop)
KTit.Size=UDim2.new(1,-20,1,0); KTit.Position=UDim2.new(0,14,0,0)
KTit.BackgroundTransparency=1; KTit.Text=KEY_UI_EN.key_title
KTit.TextColor3=Color3.fromRGB(220,215,240); KTit.Font=FT; KTit.TextSize=13
KTit.TextXAlignment=Enum.TextXAlignment.Left
local KSub=Instance.new("TextLabel",KC)
KSub.Size=UDim2.new(1,0,0,18); KSub.Position=UDim2.new(0,0,0,54)
KSub.BackgroundTransparency=1; KSub.Text=KEY_UI_EN.key_sub
KSub.TextColor3=Color3.fromRGB(100,88,140); KSub.Font=FN; KSub.TextSize=11
local KInBg=Instance.new("Frame",KC)
KInBg.Size=UDim2.new(0,400,0,40); KInBg.Position=UDim2.new(0.5,-200,0,84)
KInBg.BackgroundColor3=Color3.fromRGB(16,12,30); KInBg.BorderSizePixel=0
Instance.new("UICorner",KInBg).CornerRadius=UDim.new(0,8)
local KInStr=Instance.new("UIStroke",KInBg); KInStr.Color=Color3.fromRGB(42,30,72); KInStr.Thickness=1
local KInput=Instance.new("TextBox",KInBg)
KInput.Size=UDim2.new(1,-16,1,0); KInput.Position=UDim2.new(0,8,0,0)
KInput.BackgroundTransparency=1; KInput.Text=""
KInput.PlaceholderText="TOKYO-XXXX-XXXX"
KInput.PlaceholderColor3=Color3.fromRGB(65,55,95)
KInput.TextColor3=Color3.fromRGB(138,92,255)
KInput.Font=FT; KInput.TextSize=15; KInput.ClearTextOnFocus=false
KInput.Focused:Connect(function() TweenService:Create(KInStr,TweenInfo.new(0.15),{Color=Color3.fromRGB(138,92,255)}):Play() end)
KInput.FocusLost:Connect(function() TweenService:Create(KInStr,TweenInfo.new(0.15),{Color=Color3.fromRGB(42,30,72)}):Play() end)

local KStat=Instance.new("TextLabel",KC)
KStat.Size=UDim2.new(1,-40,0,14); KStat.Position=UDim2.new(0,20,0,130)
KStat.BackgroundTransparency=1; KStat.Text=""
KStat.TextColor3=Color3.fromRGB(100,88,140); KStat.Font=FN; KStat.TextSize=11
local function KSetS(msg,col) KStat.Text=msg; KStat.TextColor3=col or Color3.fromRGB(100,88,140) end

local KBtn=Instance.new("TextButton",KC)
KBtn.Size=UDim2.new(0,240,0,40); KBtn.Position=UDim2.new(0.5,-120,0,150)
KBtn.BorderSizePixel=0; KBtn.Text=""; KBtn.ZIndex=12
Instance.new("UICorner",KBtn).CornerRadius=UDim.new(0,10)
local KBtnBg=Instance.new("Frame",KBtn)
KBtnBg.Size=UDim2.new(1,0,1,0); KBtnBg.BackgroundColor3=Color3.fromRGB(138,92,255)
KBtnBg.BorderSizePixel=0; KBtnBg.ZIndex=11
Instance.new("UICorner",KBtnBg).CornerRadius=UDim.new(0,10)
local KBtnLbl=Instance.new("TextLabel",KBtn)
KBtnLbl.Size=UDim2.new(1,0,1,0); KBtnLbl.BackgroundTransparency=1
KBtnLbl.Text=KEY_UI_EN.key_btn; KBtnLbl.TextColor3=Color3.fromRGB(240,235,255)
KBtnLbl.Font=FT; KBtnLbl.TextSize=15; KBtnLbl.ZIndex=13
KBtn.MouseEnter:Connect(function() TweenService:Create(KBtnBg,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(160,110,255)}):Play() end)
KBtn.MouseLeave:Connect(function() TweenService:Create(KBtnBg,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(138,92,255)}):Play() end)

local function KSmBtn(txt,col,ox,fn)
    local b=Instance.new("TextButton",KC)
    b.Size=UDim2.new(0,110,0,26); b.Position=UDim2.new(0,ox,1,-38)
    b.BackgroundColor3=col; b.Text=txt; b.TextColor3=Color3.fromRGB(230,225,250)
    b.Font=FM; b.TextSize=11; b.BorderSizePixel=0; b.ZIndex=12
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
    b.MouseButton1Click:Connect(fn); return b
end
KSmBtn(KEY_UI_EN.key_get,Color3.fromRGB(88,101,242),254,function()
    pcall(function() setclipboard(DISCORD) end)
    pcall(function() game:GetService("GuiService"):OpenBrowserWindow(DISCORD) end)
end)
KSmBtn(KEY_UI_EN.key_help,Color3.fromRGB(22,16,42),16,function()
    pcall(function() setclipboard(DISCORD) end)
    pcall(function() game:GetService("GuiService"):OpenBrowserWindow(DISCORD) end)
end)

local function KShake()
    local op=KC.Position
    for i=1,5 do
        local d=i%2==0 and 9 or -9
        TweenService:Create(KC,TweenInfo.new(0.05),{Position=UDim2.new(op.X.Scale,op.X.Offset+d,op.Y.Scale,op.Y.Offset)}):Play()
        task.wait(0.055)
    end
    TweenService:Create(KC,TweenInfo.new(0.1),{Position=op}):Play()
end

local function PlayWelcome()
    TweenService:Create(KC,TweenInfo.new(0.32),{BackgroundTransparency=1,Position=UDim2.new(0.5,-240,0.5,-240)}):Play()
    TweenService:Create(KBg,TweenInfo.new(0.38),{BackgroundTransparency=1}):Play()
    for _,f in ipairs(flakes) do TweenService:Create(f.l,TweenInfo.new(0.28),{TextTransparency=1}):Play() end
    task.wait(0.35); pcall(function() KC:Destroy() end)

    local WC=Instance.new("Frame",KG)
    WC.Size=UDim2.new(0,0,0,0); WC.Position=UDim2.new(0.5,0,0.5,0)
    WC.BackgroundColor3=Color3.fromRGB(10,8,18); WC.BorderSizePixel=0
    WC.ZIndex=20; WC.ClipsDescendants=true
    Instance.new("UICorner",WC).CornerRadius=UDim.new(0,14)
    local WStr=Instance.new("UIStroke",WC); WStr.Color=Color3.fromRGB(138,92,255); WStr.Thickness=1.5
    TweenService:Create(WC,TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
        Size=UDim2.new(0,380,0,240), Position=UDim2.new(0.5,-190,0.5,-120)
    }):Play()
    task.wait(0.3)

    local WWel=Instance.new("TextLabel",WC)
    WWel.Size=UDim2.new(1,0,0,20); WWel.Position=UDim2.new(0,0,0,40)
    WWel.BackgroundTransparency=1; WWel.Text=KEY_UI_EN.key_welcome
    WWel.TextColor3=Color3.fromRGB(100,88,140); WWel.Font=FN; WWel.TextSize=12; WWel.ZIndex=22

    local WName=Instance.new("TextLabel",WC)
    WName.Size=UDim2.new(1,-40,0,34); WName.Position=UDim2.new(0,20,0,60)
    WName.BackgroundTransparency=1; WName.Text=WHO
    WName.TextColor3=Color3.fromRGB(240,235,255); WName.Font=FT; WName.TextSize=28; WName.ZIndex=22

    local WSub=Instance.new("TextLabel",WC)
    WSub.Size=UDim2.new(1,0,0,16); WSub.Position=UDim2.new(0,0,0,104)
    WSub.BackgroundTransparency=1; WSub.Text=KEY_UI_EN.key_access
    WSub.TextColor3=Color3.fromRGB(72,220,130); WSub.Font=FM; WSub.TextSize=11; WSub.ZIndex=22

    local BBg=Instance.new("Frame",WC)
    BBg.Size=UDim2.new(0,300,0,4); BBg.Position=UDim2.new(0.5,-150,0,138)
    BBg.BackgroundColor3=Color3.fromRGB(22,16,42); BBg.BorderSizePixel=0; BBg.ZIndex=22
    Instance.new("UICorner",BBg).CornerRadius=UDim.new(1,0)
    local BFill=Instance.new("Frame",BBg)
    BFill.Size=UDim2.new(0,0,1,0); BFill.BackgroundColor3=Color3.fromRGB(138,92,255)
    BFill.BorderSizePixel=0; BFill.ZIndex=23
    Instance.new("UICorner",BFill).CornerRadius=UDim.new(1,0)

    local BLbl=Instance.new("TextLabel",WC)
    BLbl.Size=UDim2.new(1,0,0,14); BLbl.Position=UDim2.new(0,0,0,150)
    BLbl.BackgroundTransparency=1; BLbl.Text=KEY_UI_EN.key_loading
    BLbl.TextColor3=Color3.fromRGB(100,88,140); BLbl.Font=FN; BLbl.TextSize=10; BLbl.ZIndex=22

    TweenService:Create(BFill,TweenInfo.new(1.6,Enum.EasingStyle.Quad),{Size=UDim2.new(1,0,1,0)}):Play()
    task.delay(1.7,function()
        BLbl.Text=KEY_UI_EN.key_done; BLbl.TextColor3=Color3.fromRGB(138,92,255)
        task.wait(0.5)
        TweenService:Create(WC,TweenInfo.new(0.38),{BackgroundTransparency=1,Position=UDim2.new(0.5,-190,0.5,-200)}):Play()
        task.wait(0.42)
        pcall(function() snowConn:Disconnect() end)
        pcall(function() KG:Destroy() end)
        OpenMenu()
    end)
end

local function TryLogin()
    local key=KInput.Text:upper():gsub("%s","")
    if key=="" then KSetS(KEY_UI_EN.key_empty,Color3.fromRGB(220,60,60)); task.spawn(KShake); return end
    KSetS(KEY_UI_EN.key_checking,Color3.fromRGB(100,88,140))
    KBtnLbl.Text="..."; KBtn.Active=false
    task.wait(0.65)
    if ValidKey(key) then
        SaveKey(key); PlayWelcome()
    else
        KBtnLbl.Text=KEY_UI_EN.key_btn; KBtn.Active=true
        KSetS(KEY_UI_EN.key_invalid,Color3.fromRGB(220,60,60))
        TweenService:Create(KCStr,TweenInfo.new(0.12),{Color=Color3.fromRGB(220,60,60)}):Play()
        task.spawn(KShake)
        task.delay(0.7,function() TweenService:Create(KCStr,TweenInfo.new(0.35),{Color=Color3.fromRGB(42,30,72)}):Play() end)
    end
end

KInput.FocusLost:Connect(function(enter) if enter then TryLogin() end end)
KBtn.MouseButton1Click:Connect(TryLogin)

task.spawn(function()
    task.wait(0.6)
    local saved=LoadKey()
    if ValidKey(saved) then
        KSetS(KEY_UI_EN.key_found,Color3.fromRGB(72,220,130))
        KInput.Text=saved; task.wait(0.9); PlayWelcome()
    end
end)

print("[Tokyo Script V1.0] OK")
