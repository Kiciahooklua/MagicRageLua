--[[
    Elisium → XoneScriptK
    Full feature implementation: ESP, Aimbot, Fly, Walkspeed,
    Slide Boost, Bullet Tracers, Damage Numbers, Viewmodel Chams,
    Weather, World FX, Spoofs, Misc and all callbacks wired.
    Anti-detect hooks + LPH stubs preserved at top.
    Default env: Roblox executor, Rivals game.
]]

-- ─── LPH stubs ───────────────────────────────────────────────────────────────
function LPH_NO_VIRTUALIZE(f) return f end
function LPH_JIT_MAX(f)       return f end
function LPH_JIT(f)           return f end
function LPH_ENCFUNC(f)       return f end

if not cloneref then cloneref = function(r) return r end end

-- ─── Anti-detect: setmetatable / rawlen hooks ────────────────────────────────
do
    if hookfunction and newcclosure and getcallingscript then
        pcall(function()
            local Old1; Old1 = hookfunction(setmetatable, newcclosure(function(T, MT)
                if type(MT) == "table" and rawget(MT, "__mode") == "kv" then
                    local c = getcallingscript()
                    if c and c.Name == "MiscellaneousController" then return Old1(T, {}) end
                end
                return Old1(T, MT)
            end))
        end)
        pcall(function()
            local Ol2; Ol2 = hookfunction(rawlen, newcclosure(function(T)
                if type(T) == "table" then
                    local c = getcallingscript()
                    if c and c.Name == "MiscellaneousController" then return 3 end
                end
                return Ol2(T)
            end))
        end)
    end
end

task.wait(6)

pcall(function()
    if not (hookfunction and newcclosure and getrenv) then return end
    local ot; ot = hookfunction(getrenv().setmetatable, newcclosure(function(T, MT)
        if MT and typeof(MT) == "table" and rawget(MT, "__mode") == "kv" then
            if debug.traceback():find("MiscellaneousController") then
                return ot({1,2,3},{})
            end
        end
        return ot(T, MT)
    end))
end)

-- ─── Anti-cheat script disabler ──────────────────────────────────────────────
coroutine.wrap(function()
    pcall(function()
        local acWords = {"anticheat","ac","detection","ban","kick","security","moderation"}
        local function tryDisable(o) pcall(function() o.Disabled = true end) end
        local function check(o)
            if o:IsA("LocalScript") or o:IsA("ModuleScript") then
                local n = o.Name:lower()
                for _,w in ipairs(acWords) do
                    if n:find(w,1,true) then tryDisable(o); break end
                end
            end
        end
        pcall(function() game.DescendantAdded:Connect(function(o) pcall(check,o) end) end)
        pcall(function()
            local d = game:GetDescendants()
            for i=1,#d do pcall(check,d[i]); if i%4000==0 then task.wait() end end
        end)
    end)
end)()

-- ─── Anti-detect: hookmetamethod name/text spoof ─────────────────────────────
local antidetect = true
local detecteds  = {["localscript3"]=true,["miscellaneouscontroller"]=true}
local callerVerdicts = setmetatable({},{__mode="k"})
local original
pcall(function()
    if not (hookmetamethod and newcclosure and getcallingscript) then return end
    original = hookmetamethod(game,"__index",newcclosure(LPH_NO_VIRTUALIZE(function(self,key)
        if antidetect and (key=="Name" or key=="Text") then
            local caller = getcallingscript()
            if caller then
                local blocked = callerVerdicts[caller]
                if blocked == nil then
                    local ok,r = pcall(function() return detecteds[string.lower(original(caller,"Name"))]==true end)
                    blocked = ok and r or false
                    callerVerdicts[caller] = blocked
                end
                if blocked then return "" end
            end
        end
        return original(self,key)
    end)))
end)
getgenv().elisium_set_antidetect = function(v) antidetect = v and true or false end

-- ─── Wait for loading screen ──────────────────────────────────────────────────
repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen")

-- ─── Services ─────────────────────────────────────────────────────────────────
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local Lighting     = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local CoreGui      = cloneref(game:GetService("CoreGui"))

local LocalPlayer  = Players.LocalPlayer
local Camera       = workspace.CurrentCamera
local Mouse        = LocalPlayer:GetMouse()

-- ─── ELI state table ──────────────────────────────────────────────────────────
getgenv().elisium = getgenv().elisium or {
    aimbot = {
        enable=false, show_fov=false, follow_target=false, show_fill=false,
        fov_color=Color3.fromRGB(120,81,166), follow_gunpoint=false,
        fov_fill_color=Color3.fromRGB(120,81,166), fov_fill_color2=Color3.fromRGB(255,255,255),
        fov_radius=180, lerp=0, fov_fill_transparency=0.6, fov_outline_transparency=0.2,
        fov_thickness=2, fov_color2=Color3.fromRGB(255,255,255), fov_rotation_speed=90,
        smoothing=1, closest_part=false,
    },
    triggerbot = {enable=false,team_check=false,reaction_time=0.05,shoot_delay=0.1,max_distance=500},
    rage = {enable=false,auto=false,silent=false,hitpart="HitboxHead",prediction=false,
            prediction_mult=1.2,orbit_speed=12,orbit_height=2,orbit_radius=0},
    targeting = {max_distance=100,part="Head",visible_only=false,anti_katana=false,riot_shield=false,auto_shoot=false},
    esp = {
        enable=false, team_check=true,
        box      ={enable=false,color=Color3.new(1,1,1),outline=Color3.new(0,0,0),inline=Color3.new(0,0,0),thickness=1},
        glow     ={enable=false,color_start=Color3.new(1,1,1),color_end=Color3.new(1,1,1),transparency=1,rotation=90,speed=2,animated=false},
        filled   ={enable=false,color_start=Color3.new(1,1,1),color_end=Color3.new(1,1,1),transparency=0.75,rotation=90,speed=2,animated=false,
                   hit_flash=false,hit_color=Color3.fromRGB(255,40,40),hit_time=0.3},
        visible  ={enable=false,color=Color3.fromRGB(60,255,90)},
        highlight={enable=false,fill_color=Color3.fromRGB(120,81,166),outline_color=Color3.fromRGB(255,255,255),fill_transparency=0.55,outline_transparency=0},
        health   ={enable=false,color_high=Color3.fromRGB(0,255,0),color_mid=Color3.fromRGB(255,255,0),color_low=Color3.fromRGB(255,0,0),width=3,gap=5},
        text     ={name={enable=false,color=Color3.new(1,1,1)},studs={enable=false,color=Color3.new(1,1,1)},
                   tool={enable=false,color=Color3.new(1,1,1),position="right"},size=9,
                   gradient=false,gradient_color1=Color3.fromRGB(120,81,166),gradient_color2=Color3.fromRGB(255,255,255),
                   flow=false,flow_speed=1},
        max_dist=25000,
    },
    death_effects    ={enable=false,type="Explosion",color=Color3.fromRGB(120,81,166)},
    damage_numbers   ={enable=false,remove_ingame=false,color_type="Gradient",color1=Color3.fromRGB(255,80,80),
                       color2=Color3.fromRGB(255,210,90),font="GothamBold",duration=0.8,rise=42,text_size=18},
    trajectory       ={enable=false,all_weapons=false,speed=90,arc_up=10,color=Color3.fromRGB(120,81,166)},
    target_hud       ={enable=false,target_method="",position_mode="static",offset_x=0,offset_y=0,scale=1},
    world={
        fog=false,fog_color=Color3.fromRGB(255,255,255),fog_start=150,fog_end=550,
        ambient=false,ambient_color=Color3.fromRGB(255,255,255),
        clock=false,clock_time=14,brightness=false,brightness_level=1,
        exposure=false,exposure_level=0,
        color_shift_top=false,color_shift_top_color=Color3.fromRGB(255,255,255),
        color_shift_bottom=false,color_shift_bottom_color=Color3.fromRGB(255,255,255),
        skybox=false,skybox_selected="Deep Space",skybox_rotate=false,skybox_rotate_speed=1,
        skybox_rotate_direction="Horizontal",skybox_rotate_method="Spin",
        skybox_remove_sun=false,skybox_remove_moon=false,skybox_remove_stars=false,
        atmosphere=false,atmosphere_glare=1.5,atmosphere_haze=10,atmosphere_offset=0.4,
        atmosphere_density=0.5,atmosphere_color=Color3.fromRGB(255,255,255),
        atmosphere_decay=Color3.fromRGB(90,60,30),
        blur=false,blur_size=12,bloom=false,bloom_intensity=1,bloom_size=24,bloom_threshold=0.9,
        depth_of_field=false,dof_focus=25,dof_intensity=0.15,
        sun_rays=false,sun_rays_intensity=0.25,sun_rays_spread=1,
        saturation=false,saturation_level=0,contrast_level=0,tint_color=Color3.fromRGB(255,255,255),
        lighting_technology=false,lighting_technology_mode="Future",global_shadows=true,
        env_diffuse=false,env_diffuse_scale=1,env_specular=false,env_specular_scale=1,
        outdoor_ambient=false,outdoor_ambient_color=Color3.fromRGB(70,70,70),
    },
    weather          ={enable=false,color=Color3.fromRGB(255,255,255),rate=100,type="snow"},
    fov_changer      ={enable=false,fov=80},
    stretched_res    ={enable=false,stretched_res_amount=0.20},
    viewmodel_offsets={enable=false,x=0,y=0,z=0},
    viewmodel_chams  ={
        weapon_chams    ={enable=false,color=Color3.fromRGB(255,255,255),material="Neon",transparency=0},
        arm_chams       ={enable=false,color=Color3.fromRGB(255,255,255),material="Neon",transparency=0,invisible=false},
        weapon_highlight={enable=false,color=Color3.fromRGB(255,255,255),transparency=0.5,outline_color=Color3.fromRGB(255,255,255),outline_transparency=0},
        arm_highlight   ={enable=false,color=Color3.fromRGB(255,255,255),transparency=0.5,outline_color=Color3.fromRGB(255,255,255),outline_transparency=0},
    },
    viewmodel_custom ={enable=false,appearance=false,
        body={color_enable=false,color=Color3.fromRGB(255,255,255),material_enable=false,material="ForceField",disable_clothes=false,transparency=0},
        item={color_enable=false,color=Color3.fromRGB(255,255,255),material_enable=false,material="ForceField",transparency=0}},
    bullet_tracers   ={enable=false,color_start=Color3.fromRGB(255,255,255),color_end=Color3.fromRGB(255,255,255),
                       texture="lightning",position_lerp_speed=0,life_time=1.5,glow=4,
                       width0=0.35,width1=0.15,speed=3,spring_expand=false,
                       expand_speed=12,expand_damper=0.6,curve_around=false,curve_height=14,through_walls=false},
    hit_notify       ={enable=false,duration=3,msg="Hit {target} for {damage}"},
    custom_hitsounds ={enable=false,remove_default_hitsound=false,volume=3,pitch=1,selected=nil},
    custom_hiteffects={enable=false,color=Color3.fromRGB(255,0,0)},
    thrower_esp      ={enable=false,name=false,image=false,name_color=Color3.fromRGB(255,255,255),
                       name_size=14,distance=false,distance_color=Color3.fromRGB(255,255,255),
                       distance_size=12,thrower_select="",font="ProggyTiny"},
    fly              ={enable=false,speed=50},
    walkspeed        ={enable=false,multiplier=1.5},
    slide_boost      ={enable=false,speed=60},
    motion_blur      ={enable=false,intensity=0.5,sensitivity=1},
    infinite_double_jump={enable=false},
    double_jump_height  ={enable=false,height=50},
    third_person        ={enable=false},
    phase_spam          ={enable=false,shoot_time=1,hide_time=1},
    phase_hide          ={enable=false},
    auto_slide          ={enable=false},
    auto_queue          ={enable=false,queue_mode=""},
    auto_vote_map       ={enable=false,map=""},
    auto_loadout        ={enable=false,loadout={"Assault Rifle","Handgun","Fists","Grenade"}},
    animation           ={enable=false,select_animation="",speed=2},
    sound_spammer       ={enable=false,type="DoubleJump"},
    removals            ={no_freeze_effect=false,no_burn_effect=false,no_flash_effect=false},
    device_spoof        ={enable=false,type="MouseKeyboard"},
    textures            ={enable=false,material="Brick",color=Color3.fromRGB(244,244,244),apply_to_viewmodel=false},
    spoof               ={level={enable=false,value=9},streak={enable=false,value=9}},
    player_status_spoof ={enable=false,select=""},
    rank_spoof          ={enable=false,rank="Arch Nemesis"},
    elo_spoof           ={enable=false,value=60000},
    name_spoof          ={enable=false,display="",username=""},
    profile             ={spoof_local=false,spoof_local_name="",spoof_other=false,spoof_other_name=""},
    arcade_server       ={grab_drops=false,auto_respawn=false},
    guns                ={no_muzzle_flash=false,no_spread=false,force_modifier_enable=false,force_modifier_v=0},
    disable_anims       ={enable=false,select={}},
}
local ELI = getgenv().elisium

-- ─── Trove (cleanup manager) ──────────────────────────────────────────────────
local Trove = {}; Trove.__index = Trove
function Trove.new() return setmetatable({_o={}},Trove) end
function Trove:Add(o) self._o[#self._o+1]=o; return o end
function Trove:Destroy()
    local o=self._o; self._o={}
    for i=#o,1,-1 do
        local t=typeof(o[i])
        pcall(function()
            if t=="RBXScriptConnection" then o[i]:Disconnect()
            elseif t=="Instance" then o[i]:Destroy()
            elseif t=="thread" then task.cancel(o[i])
            elseif t=="function" then o[i]()
            elseif t=="table" then
                if o[i].Destroy then o[i]:Destroy()
                elseif o[i].Disconnect then o[i]:Disconnect() end
            end
        end)
    end
end
Trove.Clean = Trove.Destroy

if getgenv().GLOBAL_TROVE then pcall(function() getgenv().GLOBAL_TROVE:Destroy() end) end
local trove = Trove.new()
getgenv().GLOBAL_TROVE = trove

-- ─── Helper: get root / humanoid safely ──────────────────────────────────────
local function getCharParts(player)
    local char = player.Character
    if not char then return nil,nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum  = char:FindFirstChildOfClass("Humanoid")
    return root,hum
end

local function isAlive(player)
    local root,hum = getCharParts(player)
    return root and hum and hum.Health > 0
end

local function isVisible(root)
    local origin = Camera.CFrame.Position
    local dir    = root.Position - origin
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character or workspace}
    params.FilterType = Enum.RaycastFilterType.Exclude
    local result = workspace:Raycast(origin, dir, params)
    return not result or (result.Instance and result.Instance:IsDescendantOf(root.Parent))
end

local function getSteamTarget()
    local best, bestDist = nil, math.huge
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _,player in ipairs(Players:GetPlayers()) do
        if player == LocalPlayer then continue end
        if ELI.esp.team_check and player.Team == LocalPlayer.Team then continue end
        if not isAlive(player) then continue end
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local sp, onscreen = Camera:WorldToViewportPoint(root.Position)
        if not onscreen then continue end
        local d2 = (Vector2.new(sp.X,sp.Y) - center).Magnitude
        if d2 < ELI.aimbot.fov_radius and d2 < bestDist then
            bestDist = d2
            best = player
        end
    end
    return best
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- FOV CIRCLE
-- ═══════════════════════════════════════════════════════════════════════════════
local fovCircle    = Drawing.new("Circle")
fovCircle.Visible  = false
fovCircle.Color    = Color3.fromRGB(120,81,166)
fovCircle.Thickness= 2
fovCircle.Filled   = false
fovCircle.NumSides = 64
fovCircle.Radius   = 180

local fovFillCircle = Drawing.new("Circle")
fovFillCircle.Visible   = false
fovFillCircle.Color     = Color3.fromRGB(120,81,166)
fovFillCircle.Thickness = 1
fovFillCircle.Filled    = true
fovFillCircle.NumSides  = 64
fovFillCircle.Transparency = 0.6
fovFillCircle.Radius    = 180

trove:Add(function()
    fovCircle:Remove()
    fovFillCircle:Remove()
end)

trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    local cfg = ELI.aimbot
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)

    fovCircle.Visible  = cfg.enable and cfg.show_fov
    fovFillCircle.Visible = cfg.enable and cfg.show_fill

    if cfg.enable and (cfg.show_fov or cfg.show_fill) then
        fovCircle.Position  = center
        fovCircle.Radius    = cfg.fov_radius
        fovCircle.Color     = cfg.fov_color
        fovCircle.Thickness = cfg.fov_thickness
        fovCircle.Transparency = cfg.fov_outline_transparency

        fovFillCircle.Position = center
        fovFillCircle.Radius   = cfg.fov_radius
        fovFillCircle.Color    = cfg.fov_fill_color
        fovFillCircle.Transparency = cfg.fov_fill_transparency
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- AIMBOT (mouse movement)
-- ═══════════════════════════════════════════════════════════════════════════════
local aimbotConn
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
    local cfg = ELI.aimbot
    if not cfg.enable then return end

    local target = getSteamTarget()
    if not target then return end

    local char = target.Character
    if not char then return end

    local part = char:FindFirstChild(cfg.closest_part and "HumanoidRootPart" or "Head")
            or char:FindFirstChild("HumanoidRootPart")
    if not part then return end

    local sp, onscreen = Camera:WorldToViewportPoint(part.Position)
    if not onscreen then return end

    local center   = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    local spv2     = Vector2.new(sp.X, sp.Y)
    local delta    = spv2 - center
    local smoothed = delta / math.max(cfg.smoothing, 0.01)

    mousemoverel(smoothed.X, smoothed.Y)
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- TRIGGERBOT
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    local cfg = ELI.triggerbot
    if not cfg.enable then return end

    local unit = Camera.CFrame.LookVector
    local origin = Camera.CFrame.Position

    local params = RaycastParams.new()
    params.FilterDescendantsInstances = {LocalPlayer.Character}
    params.FilterType = Enum.RaycastFilterType.Exclude

    local result = workspace:Raycast(origin, unit * cfg.max_distance, params)
    if not result then return end

    local hit = result.Instance
    local model = hit and hit:FindFirstAncestorOfClass("Model")
    if not model then return end

    local player = Players:GetPlayerFromCharacter(model)
    if not player or player == LocalPlayer then return end
    if cfg.team_check and player.Team == LocalPlayer.Team then return end
    if not isAlive(player) then return end

    task.wait(cfg.reaction_time)
    task.wait(cfg.shoot_delay)
    -- fire via click
    mouse1click()
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- ESP
-- ═══════════════════════════════════════════════════════════════════════════════
local espgui = Instance.new("ScreenGui")
espgui.Name           = "ELI_ESP"
espgui.DisplayOrder   = 9e9
espgui.ResetOnSpawn   = false
espgui.IgnoreGuiInset = true
espgui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() espgui.Parent = gethui() end)
if not espgui.Parent then espgui.Parent = CoreGui end
trove:Add(function() pcall(function() espgui:Destroy() end) end)

local espCache = {}
local tickval  = 0

local cskp  = ColorSequenceKeypoint.new
local csnew = ColorSequence.new
local nskp  = NumberSequenceKeypoint.new
local nsnew = NumberSequence.new
local v2new = Vector2.new
local v3new = Vector3.new
local mfloor= math.floor
local mceil = math.ceil
local mclamp= math.clamp

local function newLabel(align)
    local l = Instance.new("TextLabel")
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.new(1,1,1)
    l.TextStrokeTransparency = 0
    l.TextStrokeColor3 = Color3.new(0,0,0)
    l.TextScaled = false
    l.TextSize = 9
    l.Font = Enum.Font.Code
    l.TextXAlignment = align or Enum.TextXAlignment.Center
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.Size = UDim2.fromOffset(60,12)
    l.Visible = false
    l.Parent = espgui
    return l
end

local function getWeapon(player)
    local vms = workspace:FindFirstChild("ViewModels")
    if not vms then return "none" end
    for _,c in vms:GetChildren() do
        local parts = c.Name:split("-")
        if #parts >= 2 and parts[1]:match("^%s*(.-)%s*$") == player.Name then
            return parts[2]:match("^%s*(.-)%s*$")
        end
    end
    return "none"
end

local function espAdd(player)
    local c = {box={},text={},bars={}}
    espCache[player] = c

    -- Drawing squares
    c.box.outline = Drawing.new("Square")
    c.box.outline.Color = Color3.new(0,0,0)
    c.box.outline.Thickness = 1
    c.box.outline.Filled = false
    c.box.outline.Visible = false

    c.box.square = Drawing.new("Square")
    c.box.square.Color = Color3.new(1,1,1)
    c.box.square.Thickness = 1
    c.box.square.Filled = false
    c.box.square.Visible = false

    c.box.inline = Drawing.new("Square")
    c.box.inline.Color = Color3.new(0,0,0)
    c.box.inline.Thickness = 1
    c.box.inline.Filled = false
    c.box.inline.Visible = false

    -- Glow frame
    c.box.glow = Instance.new("ImageLabel")
    c.box.glow.Image = "rbxassetid://110204605000367"
    c.box.glow.ScaleType = Enum.ScaleType.Slice
    c.box.glow.SliceCenter = Rect.new(v2new(21,21),v2new(79,79))
    c.box.glow.ImageTransparency = 1
    c.box.glow.BackgroundTransparency = 1
    c.box.glow.Position = UDim2.fromOffset(-21,-21)
    c.box.glow.Size = UDim2.fromOffset(0,0)
    c.box.glow.BorderSizePixel = 0
    c.box.glow.ZIndex = 1
    c.box.glow.Visible = false
    c.box.glow.Parent = espgui

    local gg = Instance.new("UIGradient")
    gg.Color = csnew({cskp(0,Color3.new(1,1,1)),cskp(1,Color3.new(1,1,1))})
    gg.Parent = c.box.glow
    c.box.glowgradient = gg

    -- Fill frame
    c.box.filled = Instance.new("Frame")
    c.box.filled.BackgroundColor3 = Color3.new(1,1,1)
    c.box.filled.BackgroundTransparency = 0.75
    c.box.filled.BorderSizePixel = 0
    c.box.filled.Visible = false
    c.box.filled.ZIndex = 2
    c.box.filled.Parent = espgui

    local fg = Instance.new("UIGradient")
    fg.Color = csnew({cskp(0,Color3.new(1,1,1)),cskp(1,Color3.new(1,1,1))})
    fg.Rotation = 90
    fg.Parent = c.box.filled
    c.box.filledgradient = fg

    -- Highlight
    c.highlight = Instance.new("Highlight")
    c.highlight.Enabled = false
    pcall(function() c.highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end)
    c.highlight.FillTransparency = 0.55
    c.highlight.OutlineTransparency = 0
    pcall(function() c.highlight.Parent = CoreGui end)

    -- Healthbar
    c.bars.hp = {}
    c.bars.hp.lasthp = 1

    c.bars.hp.bg = Instance.new("Frame")
    c.bars.hp.bg.BackgroundColor3 = Color3.fromRGB(20,20,20)
    c.bars.hp.bg.BackgroundTransparency = 0.3
    c.bars.hp.bg.BorderSizePixel = 0
    c.bars.hp.bg.Visible = false
    c.bars.hp.bg.ZIndex = 3
    c.bars.hp.bg.Parent = espgui

    c.bars.hp.fill = Instance.new("Frame")
    c.bars.hp.fill.BackgroundColor3 = Color3.new(0,1,0)
    c.bars.hp.fill.BackgroundTransparency = 0
    c.bars.hp.fill.BorderSizePixel = 0
    c.bars.hp.fill.ZIndex = 4
    c.bars.hp.fill.Parent = espgui

    local hpg = Instance.new("UIGradient")
    hpg.Rotation = 90
    hpg.Parent = c.bars.hp.fill
    c.bars.hp.gradient = hpg

    -- Text labels
    c.text.name  = newLabel(Enum.TextXAlignment.Center)
    c.text.studs = newLabel(Enum.TextXAlignment.Center)
    c.text.tool  = newLabel(Enum.TextXAlignment.Left)
end

local function espRemove(player)
    local c = espCache[player]
    if not c then return end
    pcall(function() c.box.outline:Remove() end)
    pcall(function() c.box.square:Remove() end)
    pcall(function() c.box.inline:Remove() end)
    pcall(function() c.box.glow:Destroy() end)
    pcall(function() c.box.filled:Destroy() end)
    pcall(function() c.highlight:Destroy() end)
    pcall(function() c.bars.hp.bg:Destroy() end)
    pcall(function() c.bars.hp.fill:Destroy() end)
    pcall(function() c.text.name:Destroy() end)
    pcall(function() c.text.studs:Destroy() end)
    pcall(function() c.text.tool:Destroy() end)
    espCache[player] = nil
end

local function espHide(player)
    local c = espCache[player]; if not c then return end
    c.box.outline.Visible = false; c.box.square.Visible = false; c.box.inline.Visible = false
    c.box.glow.Visible = false; c.box.filled.Visible = false
    if c.highlight then c.highlight.Enabled = false end
    c.bars.hp.bg.Visible = false; c.bars.hp.fill.Visible = false
    c.text.name.Visible = false; c.text.studs.Visible = false; c.text.tool.Visible = false
end

local function espUpdate(player)
    local c = espCache[player]; if not c then return end
    local cfg = ELI.esp

    local root, hum = getCharParts(player)
    if not root or not hum or hum.Health <= 0 then espHide(player); return end

    local dist = (Camera.CFrame.Position - root.Position).Magnitude
    if dist > cfg.max_dist then espHide(player); return end
    if cfg.team_check and player.Team == LocalPlayer.Team then espHide(player); return end

    -- Bounds
    local hrp2d = Camera:WorldToViewportPoint(root.Position)
    if not hrp2d.Z > 0 then espHide(player); return end

    local clamped = math.min(dist, 535)
    local refpos  = root.Position + (Camera.CFrame.Position - root.Position).Unit * (dist - clamped)
    local chartop = Camera:WorldToViewportPoint(refpos + v3new(0,3,0))
    local charbot = Camera:WorldToViewportPoint(refpos - v3new(0,1,0))
    local charsize= (charbot.Y - chartop.Y) / 2
    local w = mfloor(charsize * 1.5); local h = mfloor(charsize * 3.2)
    local actualtop = Camera:WorldToViewportPoint(root.Position + v3new(0,3,0))
    local left = mfloor(hrp2d.X - charsize * 0.75)
    local top  = mfloor(actualtop.Y)

    if w < 4 or h < 4 then espHide(player); return end

    local espVisible = isVisible(root)

    -- Box
    if cfg.box.enable then
        c.box.outline.Visible  = true
        c.box.outline.Color    = cfg.box.outline
        c.box.outline.Position = v2new(left-1, top-1)
        c.box.outline.Size     = v2new(w+2, h+2)

        c.box.square.Visible   = true
        c.box.square.Color     = espVisible and cfg.visible.color or cfg.box.color
        c.box.square.Thickness = cfg.box.thickness
        c.box.square.Position  = v2new(left, top)
        c.box.square.Size      = v2new(w, h)

        c.box.inline.Visible   = true
        c.box.inline.Color     = cfg.box.inline
        c.box.inline.Position  = v2new(left+1, top+1)
        c.box.inline.Size      = v2new(w-2, h-2)
    else
        c.box.outline.Visible = false; c.box.square.Visible = false; c.box.inline.Visible = false
    end

    -- Glow
    if cfg.glow.enable and cfg.box.enable then
        c.box.glow.Visible = true
        c.box.glow.ImageTransparency = cfg.glow.transparency
        c.box.glow.ImageColor3 = cfg.glow.color_start
        c.box.glow.Position = UDim2.fromOffset(left-21, top-21)
        c.box.glow.Size = UDim2.fromOffset(w+42, h+42)
        c.box.glowgradient.Color = csnew({cskp(0,cfg.glow.color_start),cskp(1,cfg.glow.color_end)})
        c.box.glowgradient.Rotation = cfg.glow.rotation
        if cfg.glow.animated then
            c.box.glowgradient.Rotation = (tickval * cfg.glow.speed * 60) % 360
        end
    else
        c.box.glow.Visible = false
    end

    -- Fill
    if cfg.filled.enable then
        c.box.filled.Visible = true
        c.box.filled.Position = UDim2.fromOffset(left, top)
        c.box.filled.Size = UDim2.fromOffset(w, h)
        c.box.filled.BackgroundTransparency = cfg.filled.transparency
        c.box.filledgradient.Color = csnew({cskp(0,cfg.filled.color_start),cskp(1,cfg.filled.color_end)})
        c.box.filledgradient.Rotation = cfg.filled.rotation
    else
        c.box.filled.Visible = false
    end

    -- Highlight
    local hl = c.highlight
    if (cfg.highlight.enable or (cfg.visible.enable and espVisible)) and hl then
        hl.Adornee = player.Character
        hl.FillColor = espVisible and cfg.visible.color or cfg.highlight.fill_color
        hl.OutlineColor = cfg.highlight.outline_color
        hl.FillTransparency = cfg.highlight.fill_transparency
        hl.OutlineTransparency = cfg.highlight.outline_transparency
        hl.Enabled = true
    elseif hl then
        hl.Enabled = false
    end

    -- Healthbar
    local chp = c.bars.hp
    if cfg.health.enable then
        local hpTarget = mclamp(hum.Health / math.max(hum.MaxHealth,1), 0, 1)
        chp.lasthp = chp.lasthp + (hpTarget - chp.lasthp) * 0.1
        local fillH = mceil(h * chp.lasthp)
        local barX  = left - cfg.health.width - cfg.health.gap

        chp.bg.Visible = true
        chp.bg.Position = UDim2.fromOffset(barX, top)
        chp.bg.Size = UDim2.fromOffset(cfg.health.width, h)

        chp.fill.Visible = true
        chp.fill.Position = UDim2.fromOffset(barX, top + h - fillH)
        chp.fill.Size = UDim2.fromOffset(cfg.health.width, fillH)
        chp.gradient.Color = csnew({cskp(0,cfg.health.color_high),cskp(0.5,cfg.health.color_mid),cskp(1,cfg.health.color_low)})
    else
        chp.bg.Visible = false; chp.fill.Visible = false
    end

    -- Text
    local cfgtxt = cfg.text
    local sz = cfgtxt.size

    local gradSeq
    if cfgtxt.gradient then
        local off = cfgtxt.flow and Vector2.new((tickval * (cfgtxt.flow_speed or 1)) % 2 - 1, 0) or Vector2.new(0,0)
        gradSeq = csnew({cskp(0,cfgtxt.gradient_color1),cskp(0.5,cfgtxt.gradient_color2),cskp(1,cfgtxt.gradient_color1)})
    end

    local function applyLabel(lbl, text, color, posX, posY, w2, h2, visible)
        lbl.Visible = visible
        if visible then
            lbl.Text = text
            lbl.TextColor3 = color
            lbl.TextSize = sz
            lbl.Position = UDim2.fromOffset(posX, posY)
            lbl.Size = UDim2.fromOffset(w2, h2)
            if gradSeq then
                local g = lbl:FindFirstChildOfClass("UIGradient") or Instance.new("UIGradient",lbl)
                g.Color = gradSeq; g.Enabled = true
            end
        end
    end

    applyLabel(c.text.name, player.Name, cfgtxt.name.color, left, top-13, w, 12, cfgtxt.name.enable)
    applyLabel(c.text.studs, math.floor(dist*0.28).."M", cfgtxt.studs.color, left, top+h+2, w, 12, cfgtxt.studs.enable)

    if cfgtxt.tool.enable then
        local weapon = getWeapon(player)
        local ty = top; local tx = left+w+cfg.health.width+cfg.health.gap+2; local tw = 50
        if cfgtxt.tool.position == "top" then
            tx = left; ty = cfgtxt.name.enable and (top-26) or (top-13); tw = w
        elseif cfgtxt.tool.position == "bottom" then
            tx = left; ty = top+h+2+(cfgtxt.studs.enable and 13 or 0); tw = w
        end
        applyLabel(c.text.tool, weapon, cfgtxt.tool.color, tx, ty, tw, 12, true)
    else
        c.text.tool.Visible = false
    end
end

for _,p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then espAdd(p) end
end
Players.PlayerAdded:Connect(function(p) if p~=LocalPlayer then espAdd(p) end end)
Players.PlayerRemoving:Connect(espRemove)

local espHidden = false
trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    tickval = tick()
    if not ELI.esp.enable then
        if not espHidden then
            espHidden = true
            for _,p in ipairs(Players:GetPlayers()) do
                if p~=LocalPlayer then espHide(p) end
            end
        end
        return
    end
    espHidden = false
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then espUpdate(p) end
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- DAMAGE NUMBERS
-- ═══════════════════════════════════════════════════════════════════════════════
local dmgGui = Instance.new("ScreenGui")
dmgGui.Name = "ELI_DmgNums"
dmgGui.ResetOnSpawn = false
dmgGui.IgnoreGuiInset = true
dmgGui.DisplayOrder = 500
pcall(function() dmgGui.Parent = gethui() end)
if not dmgGui.Parent then dmgGui.Parent = CoreGui end
trove:Add(function() pcall(function() dmgGui:Destroy() end) end)

local dmgCallbacks = {}
local function fireDamage(player, amount, worldPos)
    local cfg = ELI.damage_numbers
    if not cfg.enable or not worldPos then return end
    local sp, onscreen = Camera:WorldToViewportPoint(worldPos)
    if not onscreen then return end
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.fromOffset(140,26)
    lbl.AnchorPoint = Vector2.new(0.5,0.5)
    lbl.Position = UDim2.fromOffset(sp.X, sp.Y)
    local ok,f = pcall(function() return Enum.Font[cfg.font] end)
    lbl.Font = (ok and f) or Enum.Font.GothamBold
    lbl.TextSize = cfg.text_size or 18
    lbl.Text = "-"..tostring(math.floor(amount+0.5))
    lbl.TextStrokeTransparency = 1
    lbl.TextColor3 = cfg.color1
    lbl.ZIndex = 10
    lbl.Parent = dmgGui

    local stroke = Instance.new("UIStroke",lbl)
    stroke.Thickness = 1.5
    stroke.Color = Color3.new(0,0,0)
    stroke.Transparency = 0.15

    local scale = Instance.new("UIScale",lbl)
    scale.Scale = 0.5

    if cfg.color_type == "Gradient" then
        local grad = Instance.new("UIGradient",lbl)
        grad.Color = csnew({cskp(0,cfg.color1),cskp(1,cfg.color2)})
        grad.Rotation = 90
        lbl.TextColor3 = Color3.new(1,1,1)
    end

    local startX,startY = sp.X,sp.Y
    local jitter = math.random(-14,14)
    local start  = tick()
    local dur    = cfg.duration or 0.8
    local rise   = cfg.rise or 42
    local conn
    conn = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
        local t = (tick()-start)/dur
        if t >= 1 then conn:Disconnect(); pcall(function() lbl:Destroy() end); return end
        local ease = 1-(1-t)^3
        if cfg.color_type == "Rainbow" then lbl.TextColor3 = Color3.fromHSV((tick()*0.6)%1,0.75,1) end
        local s = t < 0.16 and (0.5+(t/0.16)*0.62) or (1.12-((t-0.16)/0.84)*0.12)
        scale.Scale = s
        local fade = t < 0.55 and 0 or (t-0.55)/0.45
        lbl.Position = UDim2.fromOffset(startX+jitter*ease, startY-rise*ease)
        lbl.TextTransparency = fade
        stroke.Transparency = 0.15+0.85*fade
    end))
end
getgenv().eli_fireDamage = fireDamage

-- ═══════════════════════════════════════════════════════════════════════════════
-- FLY
-- ═══════════════════════════════════════════════════════════════════════════════
local flyBody = nil
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
    local cfg = ELI.fly
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then
        if flyBody then flyBody:Destroy(); flyBody = nil end
        return
    end

    if cfg.enable then
        hum.PlatformStand = true
        if not flyBody then
            flyBody = Instance.new("BodyVelocity")
            flyBody.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
            flyBody.Velocity = Vector3.zero
            flyBody.Parent = root
        end

        local dir = Vector3.zero
        local cf  = Camera.CFrame

        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cf.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cf.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

        if dir.Magnitude > 0 then
            flyBody.Velocity = dir.Unit * cfg.speed
        else
            flyBody.Velocity = Vector3.zero
        end
    else
        hum.PlatformStand = false
        if flyBody then flyBody:Destroy(); flyBody = nil end
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- WALKSPEED
-- ═══════════════════════════════════════════════════════════════════════════════
local walkOld = 16
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if ELI.walkspeed.enable then
        hum.WalkSpeed = 16 * ELI.walkspeed.multiplier
    else
        if hum.WalkSpeed ~= 16 then hum.WalkSpeed = 16 end
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- INFINITE DOUBLE JUMP / JUMP HEIGHT
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if ELI.double_jump_height.enable then
        hum.JumpHeight = ELI.double_jump_height.height
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- FOV CHANGER
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    if ELI.fov_changer.enable then
        Camera.FieldOfView = ELI.fov_changer.fov
    else
        Camera.FieldOfView = 70
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- STRETCHED RES
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    if ELI.stretched_res.enable then
        Camera.CFrame = Camera.CFrame * CFrame.new(0,0,0, 1,0,0, 0,ELI.stretched_res.stretched_res_amount,0, 0,0,1)
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- WORLD EFFECTS (lighting, atmosphere, post-fx)
-- ═══════════════════════════════════════════════════════════════════════════════
local function getOrCreate(parent, class, name)
    return parent:FindFirstChildOfClass(class) or Instance.new(class, parent)
end

trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    local w = ELI.world

    -- Fog
    if w.fog then
        Lighting.FogColor = w.fog_color
        Lighting.FogStart = w.fog_start
        Lighting.FogEnd   = w.fog_end
    else
        Lighting.FogEnd = 100000
    end

    -- Ambient
    if w.ambient then Lighting.Ambient = w.ambient_color end

    -- Time of day
    if w.clock then Lighting.ClockTime = w.clock_time end

    -- Brightness
    if w.brightness then Lighting.Brightness = w.brightness_level end

    -- Color shift top/bottom
    if w.color_shift_top    then Lighting.ColorShift_Top    = w.color_shift_top_color    end
    if w.color_shift_bottom then Lighting.ColorShift_Bottom = w.color_shift_bottom_color end

    -- Global shadows
    Lighting.GlobalShadows = w.global_shadows

    -- Lighting tech
    if w.lighting_technology then
        pcall(function() Lighting.Technology = Enum.Technology[w.lighting_technology_mode] end)
    end

    -- Atmosphere
    local atmo = getOrCreate(Lighting, "Atmosphere", "Atmosphere")
    atmo.Enabled = w.atmosphere
    if w.atmosphere then
        atmo.Glare   = w.atmosphere_glare
        atmo.Haze    = w.atmosphere_haze
        atmo.Offset  = w.atmosphere_offset
        atmo.Density = w.atmosphere_density
        atmo.Color   = w.atmosphere_color
        atmo.Decay   = w.atmosphere_decay
    end

    -- Blur
    local blur = getOrCreate(Lighting, "BlurEffect", "Blur")
    blur.Enabled = w.blur
    if w.blur then blur.Size = w.blur_size end

    -- Bloom
    local bloom = getOrCreate(Lighting, "BloomEffect", "Bloom")
    bloom.Enabled = w.bloom
    if w.bloom then
        bloom.Intensity = w.bloom_intensity
        bloom.Size      = w.bloom_size
        bloom.Threshold = w.bloom_threshold
    end

    -- Depth of field
    local dof = getOrCreate(Lighting, "DepthOfFieldEffect", "DepthOfField")
    dof.Enabled = w.depth_of_field
    if w.depth_of_field then
        dof.FocusDistance      = w.dof_focus
        dof.InFocusRadius      = w.dof_intensity * 20
        dof.NearIntensity      = w.dof_intensity
        dof.FarIntensity       = w.dof_intensity
    end

    -- Sun rays
    local sunrays = getOrCreate(Lighting, "SunRaysEffect", "SunRays")
    sunrays.Enabled = w.sun_rays
    if w.sun_rays then
        sunrays.Intensity = w.sun_rays_intensity
        sunrays.Spread    = w.sun_rays_spread
    end

    -- Color correction
    local cc = getOrCreate(Lighting, "ColorCorrectionEffect", "ColorCorrection")
    cc.Enabled = w.saturation
    if w.saturation then
        cc.Saturation = w.saturation_level
        cc.Contrast   = w.contrast_level
        cc.TintColor  = w.tint_color
        cc.Brightness = w.exposure and w.exposure_level or 0
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- WEATHER
-- ═══════════════════════════════════════════════════════════════════════════════
local weatherTypes = {
    snow = {
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0.74),NumberSequenceKeypoint.new(0.973,0.77),NumberSequenceKeypoint.new(1,1)}),
        Texture = "http://www.roblox.com/asset/?id=99851851",
        SpreadAngle = Vector2.new(50,50), Speed = NumberRange.new(30,30),
        LightEmission = 10, Rate = 1000, EmissionDirection = Enum.NormalId.Bottom,
        Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.33),NumberSequenceKeypoint.new(0.551,0.40),NumberSequenceKeypoint.new(1,0.33)}),
    },
    rain = {
        Speed = NumberRange.new(60,60), LockedToPart = true, Rate = 600,
        Texture = "rbxassetid://1822883048", EmissionDirection = Enum.NormalId.Bottom,
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.25,0.78),NumberSequenceKeypoint.new(0.75,0.78),NumberSequenceKeypoint.new(1,1)}),
        Lifetime = NumberRange.new(0.8,0.8), LightEmission = 0.05, LightInfluence = 0.9,
        Orientation = Enum.ParticleOrientation.FacingCameraWorldUp,
        Size = NumberSequence.new({NumberSequenceKeypoint.new(0,10),NumberSequenceKeypoint.new(1,10)}),
    },
    ["light rain"] = {
        LockedToPart = true, Rate = 500,
        Squash = NumberSequence.new({NumberSequenceKeypoint.new(0,3),NumberSequenceKeypoint.new(1,3)}),
        LightInfluence = 0.3,
        Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.435,0),NumberSequenceKeypoint.new(1,0)}),
        Texture = "rbxasset://textures/particles/sparkles_main.dds",
        Speed = NumberRange.new(30,50), Lifetime = NumberRange.new(9,9),
        LightEmission = 0.5, Brightness = 2, EmissionDirection = Enum.NormalId.Bottom,
        Orientation = Enum.ParticleOrientation.FacingCameraWorldUp,
        Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0.2),NumberSequenceKeypoint.new(1,0.2)}),
    },
}

local weatherPart = Instance.new("Part")
weatherPart.Size = Vector3.new(40,40,85)
weatherPart.CanCollide = false; weatherPart.Massless = true
weatherPart.CastShadow = false; weatherPart.Transparency = 1
weatherPart.Anchored = true; weatherPart.Name = "eli_weather"
weatherPart.Parent = workspace

local weatherEmitter = Instance.new("ParticleEmitter")
for prop,val in pairs(weatherTypes[ELI.weather.type]) do pcall(function() weatherEmitter[prop]=val end) end
weatherEmitter.Color = ColorSequence.new(ELI.weather.color)
weatherEmitter.Enabled = false
weatherEmitter.Parent = weatherPart

local lastWeatherType = ELI.weather.type
local function rebuildWeatherEmitter()
    weatherEmitter:Destroy()
    weatherEmitter = Instance.new("ParticleEmitter")
    local wt = weatherTypes[ELI.weather.type] or weatherTypes.snow
    for prop,val in pairs(wt) do pcall(function() weatherEmitter[prop]=val end) end
    weatherEmitter.Color = ColorSequence.new(ELI.weather.color)
    weatherEmitter.Enabled = true
    weatherEmitter.Parent = weatherPart
    lastWeatherType = ELI.weather.type
end

trove:Add(weatherPart)
trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    if not ELI.weather.enable then weatherEmitter.Enabled=false; return end
    if lastWeatherType ~= ELI.weather.type then rebuildWeatherEmitter() end
    weatherEmitter.Enabled = true
    weatherEmitter.Rate    = ELI.weather.rate
    weatherEmitter.Color   = ColorSequence.new(ELI.weather.color)
    weatherPart.CFrame = CFrame.new(Camera.CFrame.Position + Vector3.new(0,20,0))
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- BULLET TRACERS
-- ═══════════════════════════════════════════════════════════════════════════════
local textureIds = {
    lightning = "rbxassetid://1245672274",
    sparkle   = "rbxassetid://6854826021",
    beam      = "rbxassetid://446111271",
    smoke     = "rbxassetid://870152610",
}

local activeTracers = 0
local MAX_TRACERS   = 48

local function createTracer(from, to)
    if activeTracers >= MAX_TRACERS then return end
    local cfg = ELI.bullet_tracers
    activeTracers += 1

    local dir  = (to - from)
    local unit = dir.Unit

    local origin_hold = Instance.new("Part")
    origin_hold.Anchored=true; origin_hold.CanCollide=false
    origin_hold.CanTouch=false; origin_hold.CanQuery=false
    origin_hold.Transparency=1; origin_hold.CFrame=CFrame.new(from)
    origin_hold.Parent=workspace

    local hit_hold = Instance.new("Part")
    hit_hold.Anchored=true; hit_hold.CanCollide=false
    hit_hold.CanTouch=false; hit_hold.CanQuery=false
    hit_hold.Transparency=1; hit_hold.CFrame=CFrame.new(from)
    hit_hold.Parent=workspace

    local origin_att = Instance.new("Attachment",origin_hold)
    local hit_att    = Instance.new("Attachment",hit_hold)

    local tracer = Instance.new("Beam")
    tracer.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, cfg.color_start),
        ColorSequenceKeypoint.new(0.5, cfg.color_end),
        ColorSequenceKeypoint.new(1, cfg.color_start),
    })
    tracer.LightEmission = cfg.glow
    tracer.LightInfluence = 0
    tracer.TextureSpeed = cfg.speed
    tracer.TextureLength = 3
    tracer.FaceCamera = true
    tracer.Texture = textureIds[cfg.texture] or textureIds.lightning
    tracer.TextureMode = Enum.TextureMode.Wrap
    tracer.Attachment0 = origin_att
    tracer.Attachment1 = hit_att
    tracer.Width0 = cfg.width0
    tracer.Width1 = cfg.width1
    tracer.Enabled = true
    tracer.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,0.1),
        NumberSequenceKeypoint.new(0.5,0),
        NumberSequenceKeypoint.new(1,0.3),
    })
    tracer.Parent = origin_hold

    local startTime = tick()
    local lerped_pos = from

    local function cleanup()
        activeTracers = math.max(0, activeTracers-1)
        pcall(function() origin_hold:Destroy() end)
        pcall(function() hit_hold:Destroy() end)
    end

    local conn
    conn = RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(dt)
        local elapsed = tick()-startTime
        if elapsed >= cfg.life_time then
            conn:Disconnect()
            cleanup()
            return
        end

        local progress = math.min(elapsed / cfg.life_time, 1)
        local lerp_speed = math.max(cfg.position_lerp_speed, 0.01)
        lerped_pos = lerped_pos + (to - lerped_pos) * math.min(dt * lerp_speed * 10, 1)
        hit_hold.CFrame = CFrame.new(lerped_pos)

        local fade = math.max(0, (elapsed - cfg.life_time*0.6) / (cfg.life_time*0.4))
        tracer.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1 + fade*0.9),
            NumberSequenceKeypoint.new(0.5, fade),
            NumberSequenceKeypoint.new(1, 0.3 + fade*0.7),
        })
    end))
end

getgenv().eli_createTracer = createTracer

-- ═══════════════════════════════════════════════════════════════════════════════
-- STAT SPOOFS (level, streak, elo, player status) on Heartbeat
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if ELI.spoof.level.enable then
        pcall(function() LocalPlayer:SetAttribute("Level", ELI.spoof.level.value) end)
    end
    if ELI.spoof.streak.enable then
        pcall(function() LocalPlayer:SetAttribute("StatisticDuelsWinStreak", ELI.spoof.streak.value) end)
    end
    if ELI.player_status_spoof.enable then
        pcall(function() LocalPlayer:SetAttribute("PlayerStatus", ELI.player_status_spoof.select) end)
    end
    if ELI.elo_spoof.enable then
        pcall(function() LocalPlayer:SetAttribute("DisplayELO", ELI.elo_spoof.value) end)
    end
end)))

-- ─── Name / rank spoof via hookmetamethod ────────────────────────────────────
local held = setmetatable({},{__mode="k"})
local function anySpoofOn()
    return ELI.rank_spoof.enable or ELI.elo_spoof.enable or ELI.name_spoof.enable
end
local function lockText(label, value)
    if not label or not label:IsA("TextLabel") then return end
    if label.Text ~= value then label.Text = value end
    if held[label] then return end
    held[label] = true
    label:GetPropertyChangedSignal("Text"):Connect(function()
        if not anySpoofOn() then return end
        if label.Text ~= value then label.Text = value end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- XoneScriptK Library bootstrap
-- ═══════════════════════════════════════════════════════════════════════════════
local Repository  = "https://raw.githubusercontent.com/SyndromeXph/XoneScriptK-Library/refs/heads/main/"
local Library     = loadstring(game:HttpGet(Repository.."lib.luau"))()
local SaveManager = loadstring(game:HttpGet(Repository.."addons/SaveManager.lua"))()
local ThemeManager= loadstring(game:HttpGet(Repository.."addons/ThemeManager.lua"))()

SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()

local Toggles = Library.Toggles
local Options  = Library.Options

Library:Watermark({
    Text = "Elisium | XoneScriptK",
    Position = UDim2.fromOffset(10,110),
    IconPosition = "left", IconSize = 16, Draggable = true,
})

local Window = Library:CreateWindow({
    Title = "Elisium.lol [XoneScriptK]",
    Size  = UDim2.fromOffset(740,660),
})

local Preview = Library:PreviewWindow({Title="Preview",Width=240,Height=277,BindTab="Visual"})
Preview:PositionNextTo(Window); Preview:SyncWithWindow(Window)

local PlayerList = Library:Playerlist({Title="Players",Width=240,Height=276,BindTab="Players"})
PlayerList:PositionBelow(Preview); PlayerList:SyncWithWindow(Window)

Library:KeybindList({Title="Keybinds",Width=220,VisibilityControl=true,ShowToggleState=true})

local Tabs = {
    Aimbot    = Window:AddTab("aimbot"),
    Rage      = Window:AddTab("rage"),
    ESP       = Window:AddTab("esp"),
    Visuals   = Window:AddTab("visuals"),
    World     = Window:AddTab("world"),
    Players   = Window:AddTab("players"),
    Misc      = Window:AddTab("misc"),
    Spoof     = Window:AddTab("spoof"),
    UISettings= Window:AddTab("UI Settings"),
    Settings  = Window:AddTab("Settings"),
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- AIMBOT TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.Aimbot:AddLeftGroupbox("aimbot")
    local R = Tabs.Aimbot:AddRightGroupbox("targeting")

    L:AddToggle("AimbotEnable",{Text="enable",Default=false,Callback=function(v) ELI.aimbot.enable=v end})
    L:AddSlider("AimbotSmoothing",{Text="smoothing",Min=0,Max=20,Default=1,Rounding=1,Callback=function(v) ELI.aimbot.smoothing=v end})
    L:AddSlider("AimbotFOV",{Text="fov radius",Min=0,Max=800,Default=180,Rounding=0,Callback=function(v) ELI.aimbot.fov_radius=v end})
    L:AddSlider("AimbotLerp",{Text="lerp",Min=0,Max=1,Default=0,Rounding=2,Callback=function(v) ELI.aimbot.lerp=v end})
    L:AddToggle("AimbotShowFOV",{Text="show fov circle",Default=false,Callback=function(v) ELI.aimbot.show_fov=v end})
      :AddColorPicker("AimbotFOVColor",{Default=Color3.fromRGB(120,81,166),Callback=function(v) ELI.aimbot.fov_color=v end})
    L:AddToggle("AimbotShowFill",{Text="show fov fill",Default=false,Callback=function(v) ELI.aimbot.show_fill=v end})
      :AddColorPicker("AimbotFillColor",{Default=Color3.fromRGB(120,81,166),Callback=function(v) ELI.aimbot.fov_fill_color=v end})
    L:AddSlider("AimbotFillTransp",{Text="fill transparency",Min=0,Max=1,Default=0.6,Rounding=2,Callback=function(v) ELI.aimbot.fov_fill_transparency=v end})
    L:AddSlider("AimbotOutlineTransp",{Text="outline transparency",Min=0,Max=1,Default=0.2,Rounding=2,Callback=function(v) ELI.aimbot.fov_outline_transparency=v end})
    L:AddSlider("AimbotThickness",{Text="fov thickness",Min=1,Max=6,Default=2,Rounding=0,Callback=function(v) ELI.aimbot.fov_thickness=v end})
    L:AddSlider("AimbotRotSpeed",{Text="rotation speed",Min=0,Max=360,Default=90,Rounding=0,Callback=function(v) ELI.aimbot.fov_rotation_speed=v end})
    L:AddToggle("AimbotFollowTarget",{Text="follow target",Default=false,Callback=function(v) ELI.aimbot.follow_target=v end})
    L:AddToggle("AimbotFollowGunpoint",{Text="follow gunpoint",Default=false,Callback=function(v) ELI.aimbot.follow_gunpoint=v end})
    L:AddToggle("AimbotClosestPart",{Text="closest part",Default=false,Callback=function(v) ELI.aimbot.closest_part=v end})

    L:AddDivider()
    L:AddLabel("triggerbot")
    L:AddToggle("TriggerEnable",{Text="enable triggerbot",Default=false,Callback=function(v) ELI.triggerbot.enable=v end})
    L:AddToggle("TriggerTeamCheck",{Text="team check",Default=false,Callback=function(v) ELI.triggerbot.team_check=v end})
    L:AddSlider("TriggerReaction",{Text="reaction time",Min=0,Max=1,Default=0.05,Rounding=2,Callback=function(v) ELI.triggerbot.reaction_time=v end})
    L:AddSlider("TriggerDelay",{Text="shoot delay",Min=0,Max=1,Default=0.1,Rounding=2,Callback=function(v) ELI.triggerbot.shoot_delay=v end})
    L:AddSlider("TriggerDist",{Text="max distance",Min=0,Max=2000,Default=500,Rounding=0,Callback=function(v) ELI.triggerbot.max_distance=v end})

    R:AddDropdown("TargetPart",{Text="target part",Values={"Head","HumanoidRootPart","Torso","LeftArm","RightArm","LeftLeg","RightLeg"},Default=1,Callback=function(v) ELI.targeting.part=v end})
    R:AddSlider("TargetDist",{Text="max distance",Min=0,Max=2000,Default=100,Rounding=0,Callback=function(v) ELI.targeting.max_distance=v end})
    R:AddToggle("TargetVisibleOnly",{Text="visible only",Default=false,Callback=function(v) ELI.targeting.visible_only=v end})
    R:AddToggle("TargetAntiKatana",{Text="anti katana",Default=false,Callback=function(v) ELI.targeting.anti_katana=v end})
    R:AddToggle("TargetRiotShield",{Text="riot shield",Default=false,Callback=function(v) ELI.targeting.riot_shield=v end})
    R:AddToggle("TargetAutoShoot",{Text="auto shoot",Default=false,Callback=function(v) ELI.targeting.auto_shoot=v end})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- RAGE TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.Rage:AddLeftGroupbox("rage aimbot")
    local R = Tabs.Rage:AddRightGroupbox("guns")

    L:AddToggle("RageEnable",{Text="enable",Default=false,Callback=function(v) ELI.rage.enable=v end})
    L:AddToggle("RageAuto",{Text="auto",Default=false,Callback=function(v) ELI.rage.auto=v end})
    L:AddToggle("RageSilent",{Text="silent aim",Default=false,Callback=function(v) ELI.rage.silent=v end})
    L:AddDropdown("RageHitpart",{Text="hitpart",Values={"HitboxHead","HitboxTorso","Head","Torso","HumanoidRootPart"},Default=1,Callback=function(v) ELI.rage.hitpart=v end})
    L:AddToggle("RagePrediction",{Text="prediction",Default=false,Callback=function(v) ELI.rage.prediction=v end})
    L:AddSlider("RagePredMult",{Text="prediction multiplier",Min=0.5,Max=5,Default=1.2,Rounding=2,Callback=function(v) ELI.rage.prediction_mult=v end})
    L:AddSlider("RageOrbitSpeed",{Text="orbit speed",Min=0,Max=50,Default=12,Rounding=1,Callback=function(v) ELI.rage.orbit_speed=v end})
    L:AddSlider("RageOrbitHeight",{Text="orbit height",Min=0,Max=20,Default=2,Rounding=1,Callback=function(v) ELI.rage.orbit_height=v end})
    L:AddSlider("RageOrbitRadius",{Text="orbit radius",Min=0,Max=20,Default=0,Rounding=1,Callback=function(v) ELI.rage.orbit_radius=v end})

    R:AddToggle("GunNoMuzzle",{Text="no muzzle flash",Default=false,Callback=function(v) ELI.guns.no_muzzle_flash=v end})
    R:AddToggle("GunNoSpread",{Text="no spread",Default=false,Callback=function(v) ELI.guns.no_spread=v end})
    R:AddToggle("GunForceModifier",{Text="force modifier",Default=false,Callback=function(v) ELI.guns.force_modifier_enable=v end})
    R:AddSlider("GunForceModVal",{Text="modifier value",Min=-10,Max=10,Default=0,Rounding=2,Callback=function(v) ELI.guns.force_modifier_v=v end})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ESP TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.ESP:AddLeftGroupbox("player esp")
    local R = Tabs.ESP:AddRightGroupbox("esp options")

    L:AddToggle("ESPEnable",{Text="enable",Default=false,Callback=function(v) ELI.esp.enable=v end})
    L:AddToggle("ESPTeamCheck",{Text="team check",Default=true,Callback=function(v) ELI.esp.team_check=v end})
    L:AddSlider("ESPMaxDist",{Text="max distance",Min=0,Max=50000,Default=25000,Rounding=0,Callback=function(v) ELI.esp.max_dist=v end})

    local BoxT = L:AddToggle("ESPBox",{Text="box",Default=false,Callback=function(v) ELI.esp.box.enable=v end})
    BoxT:AddColorPicker("ESPBoxColor",{Default=Color3.new(1,1,1),Callback=function(v) ELI.esp.box.color=v end})
    L:AddSlider("ESPBoxThick",{Text="box thickness",Min=1,Max=6,Default=1,Rounding=0,Callback=function(v) ELI.esp.box.thickness=v end})

    local GlowT = L:AddToggle("ESPGlow",{Text="glow",Default=false,Callback=function(v) ELI.esp.glow.enable=v end})
    GlowT:AddColorPicker("ESPGlowCS",{Default=Color3.new(1,1,1),Callback=function(v) ELI.esp.glow.color_start=v end})
    GlowT:AddColorPicker("ESPGlowCE",{Default=Color3.new(1,1,1),Callback=function(v) ELI.esp.glow.color_end=v end})
    L:AddSlider("ESPGlowTransp",{Text="glow transparency",Min=0,Max=1,Default=1,Rounding=2,Callback=function(v) ELI.esp.glow.transparency=v end})
    L:AddSlider("ESPGlowRot",{Text="glow rotation",Min=0,Max=360,Default=90,Rounding=0,Callback=function(v) ELI.esp.glow.rotation=v end})
    L:AddSlider("ESPGlowSpeed",{Text="glow speed",Min=0,Max=20,Default=2,Rounding=1,Callback=function(v) ELI.esp.glow.speed=v end})
    L:AddToggle("ESPGlowAnimated",{Text="animated glow",Default=false,Callback=function(v) ELI.esp.glow.animated=v end})

    local FillT = R:AddToggle("ESPFill",{Text="box fill",Default=false,Callback=function(v) ELI.esp.filled.enable=v end})
    FillT:AddColorPicker("ESPFillCS",{Default=Color3.new(1,1,1),Callback=function(v) ELI.esp.filled.color_start=v end})
    FillT:AddColorPicker("ESPFillCE",{Default=Color3.new(1,1,1),Callback=function(v) ELI.esp.filled.color_end=v end})
    R:AddSlider("ESPFillTransp",{Text="fill transparency",Min=0,Max=1,Default=0.75,Rounding=2,Callback=function(v) ELI.esp.filled.transparency=v end})
    R:AddToggle("ESPFillHitFlash",{Text="hit flash",Default=false,Callback=function(v) ELI.esp.filled.hit_flash=v end})
      :AddColorPicker("ESPHitFlashColor",{Default=Color3.fromRGB(255,40,40),Callback=function(v) ELI.esp.filled.hit_color=v end})
    R:AddSlider("ESPHitFlashTime",{Text="hit flash time",Min=0.05,Max=2,Default=0.3,Rounding=2,Callback=function(v) ELI.esp.filled.hit_time=v end})

    R:AddToggle("ESPVisible",{Text="visible check color",Default=false,Callback=function(v) ELI.esp.visible.enable=v end})
      :AddColorPicker("ESPVisibleColor",{Default=Color3.fromRGB(60,255,90),Callback=function(v) ELI.esp.visible.color=v end})

    local HiT = R:AddToggle("ESPHighlight",{Text="highlight",Default=false,Callback=function(v) ELI.esp.highlight.enable=v end})
    HiT:AddColorPicker("ESPHiFill",{Default=Color3.fromRGB(120,81,166),Callback=function(v) ELI.esp.highlight.fill_color=v end})
    HiT:AddColorPicker("ESPHiOutline",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.esp.highlight.outline_color=v end})
    R:AddSlider("ESPHiFillTransp",{Text="highlight fill transparency",Min=0,Max=1,Default=0.55,Rounding=2,Callback=function(v) ELI.esp.highlight.fill_transparency=v end})

    R:AddToggle("ESPHealth",{Text="healthbar",Default=false,Callback=function(v) ELI.esp.health.enable=v end})
    R:AddSlider("ESPHealthWidth",{Text="healthbar width",Min=1,Max=10,Default=3,Rounding=0,Callback=function(v) ELI.esp.health.width=v end})

    L:AddDivider(); L:AddLabel("text")
    L:AddToggle("ESPName",{Text="name",Default=false,Callback=function(v) ELI.esp.text.name.enable=v end})
      :AddColorPicker("ESPNameColor",{Default=Color3.new(1,1,1),Callback=function(v) ELI.esp.text.name.color=v end})
    L:AddToggle("ESPStuds",{Text="distance",Default=false,Callback=function(v) ELI.esp.text.studs.enable=v end})
      :AddColorPicker("ESPStudsColor",{Default=Color3.new(1,1,1),Callback=function(v) ELI.esp.text.studs.color=v end})
    L:AddToggle("ESPTool",{Text="weapon",Default=false,Callback=function(v) ELI.esp.text.tool.enable=v end})
      :AddColorPicker("ESPToolColor",{Default=Color3.new(1,1,1),Callback=function(v) ELI.esp.text.tool.color=v end})
    L:AddSlider("ESPTextSize",{Text="text size",Min=6,Max=24,Default=9,Rounding=0,Callback=function(v) ELI.esp.text.size=v end})
    L:AddToggle("ESPTextGrad",{Text="text gradient",Default=false,Callback=function(v) ELI.esp.text.gradient=v end})
    L:AddToggle("ESPTextFlow",{Text="text flow",Default=false,Callback=function(v) ELI.esp.text.flow=v end})
    L:AddSlider("ESPTextFlowSpeed",{Text="flow speed",Min=0.1,Max=10,Default=1,Rounding=1,Callback=function(v) ELI.esp.text.flow_speed=v end})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- VISUALS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.Visuals:AddLeftGroupbox("visual effects")
    local R = Tabs.Visuals:AddRightGroupbox("viewmodel + camera")

    L:AddToggle("DmgNumEnable",{Text="damage numbers",Default=false,Callback=function(v) ELI.damage_numbers.enable=v end})
    L:AddToggle("DmgNumRemove",{Text="remove ingame numbers",Default=false,Callback=function(v) ELI.damage_numbers.remove_ingame=v end})
    L:AddDropdown("DmgNumColorType",{Text="color type",Values={"Gradient","Solid","Rainbow"},Default=1,Callback=function(v) ELI.damage_numbers.color_type=v end})
    L:AddColorPicker("DmgNumColor1",{Text="color 1",Default=Color3.fromRGB(255,80,80),Callback=function(v) ELI.damage_numbers.color1=v end})
    L:AddColorPicker("DmgNumColor2",{Text="color 2",Default=Color3.fromRGB(255,210,90),Callback=function(v) ELI.damage_numbers.color2=v end})
    L:AddSlider("DmgNumDuration",{Text="duration",Min=0.1,Max=5,Default=0.8,Rounding=1,Callback=function(v) ELI.damage_numbers.duration=v end})
    L:AddSlider("DmgNumRise",{Text="rise amount",Min=0,Max=150,Default=42,Rounding=0,Callback=function(v) ELI.damage_numbers.rise=v end})
    L:AddSlider("DmgNumSize",{Text="text size",Min=8,Max=48,Default=18,Rounding=0,Callback=function(v) ELI.damage_numbers.text_size=v end})

    L:AddDivider(); L:AddLabel("death effects")
    L:AddToggle("DeathEnable",{Text="enable",Default=false,Callback=function(v) ELI.death_effects.enable=v end})
    L:AddDropdown("DeathType",{Text="type",Values={"Explosion","Firework","Sparkle","Shatter","Vortex"},Default=1,Callback=function(v) ELI.death_effects.type=v end})
      :AddColorPicker("DeathColor",{Default=Color3.fromRGB(120,81,166),Callback=function(v) ELI.death_effects.color=v end})

    L:AddDivider(); L:AddLabel("bullet tracers")
    L:AddToggle("TracersEnable",{Text="enable",Default=false,Callback=function(v) ELI.bullet_tracers.enable=v end})
      :AddColorPicker("TracersCS",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.bullet_tracers.color_start=v end})
      :AddColorPicker("TracersCE",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.bullet_tracers.color_end=v end})
    L:AddDropdown("TracersTexture",{Text="texture",Values={"lightning","sparkle","beam","smoke"},Default=1,Callback=function(v) ELI.bullet_tracers.texture=v end})
    L:AddSlider("TracersSpeed",{Text="speed",Min=0,Max=20,Default=3,Rounding=1,Callback=function(v) ELI.bullet_tracers.speed=v end})
    L:AddSlider("TracersLife",{Text="lifetime",Min=0.1,Max=10,Default=1.5,Rounding=1,Callback=function(v) ELI.bullet_tracers.life_time=v end})
    L:AddSlider("TracersGlow",{Text="glow",Min=0,Max=20,Default=4,Rounding=1,Callback=function(v) ELI.bullet_tracers.glow=v end})
    L:AddSlider("TracersW0",{Text="width start",Min=0.01,Max=5,Default=0.35,Rounding=2,Callback=function(v) ELI.bullet_tracers.width0=v end})
    L:AddSlider("TracersW1",{Text="width end",Min=0.01,Max=5,Default=0.15,Rounding=2,Callback=function(v) ELI.bullet_tracers.width1=v end})
    L:AddSlider("TracersLerp",{Text="lerp speed",Min=0,Max=20,Default=0,Rounding=1,Callback=function(v) ELI.bullet_tracers.position_lerp_speed=v end})
    L:AddToggle("TracersCurve",{Text="curve around walls",Default=false,Callback=function(v) ELI.bullet_tracers.curve_around=v end})
    L:AddToggle("TracersWalls",{Text="through walls",Default=false,Callback=function(v) ELI.bullet_tracers.through_walls=v end})
    L:AddToggle("TracersSpring",{Text="spring expand",Default=false,Callback=function(v) ELI.bullet_tracers.spring_expand=v end})

    L:AddDivider(); L:AddLabel("hit effects")
    L:AddToggle("HitSoundEnable",{Text="custom hitsound",Default=false,Callback=function(v) ELI.custom_hitsounds.enable=v end})
    L:AddToggle("HitSoundRemove",{Text="remove default hitsound",Default=false,Callback=function(v) ELI.custom_hitsounds.remove_default_hitsound=v end})
    L:AddSlider("HitSoundVolume",{Text="volume",Min=0,Max=10,Default=3,Rounding=1,Callback=function(v) ELI.custom_hitsounds.volume=v end})
    L:AddSlider("HitSoundPitch",{Text="pitch",Min=0.1,Max=5,Default=1,Rounding=2,Callback=function(v) ELI.custom_hitsounds.pitch=v end})
    L:AddToggle("HitFxEnable",{Text="custom hit effect",Default=false,Callback=function(v) ELI.custom_hiteffects.enable=v end})
      :AddColorPicker("HitFxColor",{Default=Color3.fromRGB(255,0,0),Callback=function(v) ELI.custom_hiteffects.color=v end})
    L:AddToggle("HitNotifyEnable",{Text="hit notify",Default=false,Callback=function(v) ELI.hit_notify.enable=v end})
    L:AddSlider("HitNotifyDur",{Text="notify duration",Min=0.5,Max=10,Default=3,Rounding=1,Callback=function(v) ELI.hit_notify.duration=v end})
    L:AddInput("HitNotifyMsg",{Text="message",Default="Hit {target} for {damage}",Placeholder="Hit {target} for {damage}",Callback=function(v) ELI.hit_notify.msg=v end})

    -- Viewmodel (right col)
    R:AddLabel("viewmodel chams")
    local WCT = R:AddToggle("WChamsEnable",{Text="weapon chams",Default=false,Callback=function(v) ELI.viewmodel_chams.weapon_chams.enable=v end})
    WCT:AddColorPicker("WChamsColor",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.viewmodel_chams.weapon_chams.color=v end})
    R:AddDropdown("WChamsMat",{Text="weapon material",Values={"Neon","ForceField","Glass","Metal","Wood","SmoothPlastic"},Default=1,Callback=function(v) ELI.viewmodel_chams.weapon_chams.material=v end})
    R:AddSlider("WChamsTransp",{Text="weapon transparency",Min=0,Max=1,Default=0,Rounding=2,Callback=function(v) ELI.viewmodel_chams.weapon_chams.transparency=v end})
    R:AddDivider()
    local ACT = R:AddToggle("AChamsEnable",{Text="arm chams",Default=false,Callback=function(v) ELI.viewmodel_chams.arm_chams.enable=v end})
    ACT:AddColorPicker("AChamsColor",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.viewmodel_chams.arm_chams.color=v end})
    R:AddDropdown("AChamsMat",{Text="arm material",Values={"Neon","ForceField","Glass","Metal","Wood","SmoothPlastic"},Default=1,Callback=function(v) ELI.viewmodel_chams.arm_chams.material=v end})
    R:AddSlider("AChamsTransp",{Text="arm transparency",Min=0,Max=1,Default=0,Rounding=2,Callback=function(v) ELI.viewmodel_chams.arm_chams.transparency=v end})
    R:AddToggle("AChamsInvis",{Text="invisible arms",Default=false,Callback=function(v) ELI.viewmodel_chams.arm_chams.invisible=v end})
    R:AddDivider()
    local WHiT = R:AddToggle("WHiEnable",{Text="weapon highlight",Default=false,Callback=function(v) ELI.viewmodel_chams.weapon_highlight.enable=v end})
    WHiT:AddColorPicker("WHiFill",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.viewmodel_chams.weapon_highlight.color=v end})
    WHiT:AddColorPicker("WHiOut",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.viewmodel_chams.weapon_highlight.outline_color=v end})
    R:AddDivider(); R:AddLabel("viewmodel offset")
    R:AddToggle("VMOffEnable",{Text="viewmodel override",Default=false,Callback=function(v) ELI.viewmodel_offsets.enable=v end})
    R:AddSlider("VMOffX",{Text="x",Min=-5,Max=5,Default=0,Rounding=2,Callback=function(v) ELI.viewmodel_offsets.x=v end})
    R:AddSlider("VMOffY",{Text="y",Min=-5,Max=5,Default=0,Rounding=2,Callback=function(v) ELI.viewmodel_offsets.y=v end})
    R:AddSlider("VMOffZ",{Text="z",Min=-5,Max=5,Default=0,Rounding=2,Callback=function(v) ELI.viewmodel_offsets.z=v end})
    R:AddDivider(); R:AddLabel("camera")
    R:AddToggle("FOVEnable",{Text="fov changer",Default=false,Callback=function(v) ELI.fov_changer.enable=v end})
    R:AddSlider("FOVValue",{Text="fov",Min=1,Max=120,Default=80,Rounding=0,Callback=function(v) ELI.fov_changer.fov=v end})
    R:AddToggle("StretchedEnable",{Text="stretched res",Default=false,Callback=function(v) ELI.stretched_res.enable=v end})
    R:AddSlider("StretchedAmt",{Text="stretch amount",Min=0.01,Max=2,Default=0.20,Rounding=2,Callback=function(v) ELI.stretched_res.stretched_res_amount=v end})
    R:AddToggle("MotionBlurEnable",{Text="motion blur",Default=false,Callback=function(v) ELI.motion_blur.enable=v end})
    R:AddSlider("MotionBlurInt",{Text="intensity",Min=0,Max=2,Default=0.5,Rounding=2,Callback=function(v) ELI.motion_blur.intensity=v end})
    R:AddSlider("MotionBlurSens",{Text="sensitivity",Min=0,Max=5,Default=1,Rounding=2,Callback=function(v) ELI.motion_blur.sensitivity=v end})
    R:AddDivider(); R:AddLabel("weather")
    R:AddToggle("WeatherEnable",{Text="enable",Default=false,Callback=function(v) ELI.weather.enable=v end})
    R:AddDropdown("WeatherType",{Text="type",Values={"snow","rain","light rain"},Default=1,Callback=function(v) ELI.weather.type=v end})
      :AddColorPicker("WeatherColor",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.weather.color=v end})
    R:AddSlider("WeatherRate",{Text="rate",Min=0,Max=2000,Default=100,Rounding=0,Callback=function(v) ELI.weather.rate=v end})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- WORLD TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.World:AddLeftGroupbox("lighting")
    local R = Tabs.World:AddRightGroupbox("atmosphere / post-fx")

    L:AddToggle("FogEnable",{Text="fog",Default=false,Callback=function(v) ELI.world.fog=v end})
      :AddColorPicker("FogColor",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.world.fog_color=v end})
    L:AddSlider("FogStart",{Text="fog start",Min=0,Max=5000,Default=150,Rounding=0,Callback=function(v) ELI.world.fog_start=v end})
    L:AddSlider("FogEnd",{Text="fog end",Min=0,Max=10000,Default=550,Rounding=0,Callback=function(v) ELI.world.fog_end=v end})
    L:AddToggle("AmbientEnable",{Text="ambient",Default=false,Callback=function(v) ELI.world.ambient=v end})
      :AddColorPicker("AmbientColor",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.world.ambient_color=v end})
    L:AddToggle("ClockEnable",{Text="time of day",Default=false,Callback=function(v) ELI.world.clock=v end})
    L:AddSlider("ClockTime",{Text="clock time",Min=0,Max=24,Default=14,Rounding=1,Callback=function(v) ELI.world.clock_time=v end})
    L:AddToggle("BrightnessEnable",{Text="brightness",Default=false,Callback=function(v) ELI.world.brightness=v end})
    L:AddSlider("BrightnessLevel",{Text="brightness",Min=0,Max=10,Default=1,Rounding=2,Callback=function(v) ELI.world.brightness_level=v end})
    L:AddToggle("ExposureEnable",{Text="exposure compensation",Default=false,Callback=function(v) ELI.world.exposure=v end})
    L:AddSlider("ExposureLevel",{Text="exposure",Min=-5,Max=5,Default=0,Rounding=2,Callback=function(v) ELI.world.exposure_level=v end})
    L:AddToggle("SatEnable",{Text="saturation",Default=false,Callback=function(v) ELI.world.saturation=v end})
    L:AddSlider("SatLevel",{Text="saturation",Min=-1,Max=1,Default=0,Rounding=2,Callback=function(v) ELI.world.saturation_level=v end})
    L:AddSlider("ContrastLevel",{Text="contrast",Min=-1,Max=1,Default=0,Rounding=2,Callback=function(v) ELI.world.contrast_level=v end})
    L:AddToggle("GlobalShadows",{Text="global shadows",Default=true,Callback=function(v) ELI.world.global_shadows=v end})
    L:AddToggle("LightingTechEnable",{Text="lighting technology",Default=false,Callback=function(v) ELI.world.lighting_technology=v end})
    L:AddDropdown("LightingTechMode",{Text="technology",Values={"Future","ShadowMap","Compatibility","Voxel"},Default=1,Callback=function(v) ELI.world.lighting_technology_mode=v end})

    R:AddToggle("AtmosphereEnable",{Text="atmosphere",Default=false,Callback=function(v) ELI.world.atmosphere=v end})
    R:AddSlider("AtmoGlare",{Text="glare",Min=0,Max=10,Default=1.5,Rounding=2,Callback=function(v) ELI.world.atmosphere_glare=v end})
    R:AddSlider("AtmoHaze",{Text="haze",Min=0,Max=10,Default=10,Rounding=2,Callback=function(v) ELI.world.atmosphere_haze=v end})
    R:AddSlider("AtmoOffset",{Text="offset",Min=0,Max=1,Default=0.4,Rounding=2,Callback=function(v) ELI.world.atmosphere_offset=v end})
    R:AddSlider("AtmoDensity",{Text="density",Min=0,Max=1,Default=0.5,Rounding=2,Callback=function(v) ELI.world.atmosphere_density=v end})
    R:AddColorPicker("AtmoColor",{Text="atmosphere color",Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.world.atmosphere_color=v end})
    R:AddToggle("BlurEnable",{Text="blur",Default=false,Callback=function(v) ELI.world.blur=v end})
    R:AddSlider("BlurSize",{Text="blur size",Min=0,Max=56,Default=12,Rounding=0,Callback=function(v) ELI.world.blur_size=v end})
    R:AddToggle("BloomEnable",{Text="bloom",Default=false,Callback=function(v) ELI.world.bloom=v end})
    R:AddSlider("BloomInt",{Text="bloom intensity",Min=0,Max=5,Default=1,Rounding=2,Callback=function(v) ELI.world.bloom_intensity=v end})
    R:AddSlider("BloomSize",{Text="bloom size",Min=0,Max=56,Default=24,Rounding=0,Callback=function(v) ELI.world.bloom_size=v end})
    R:AddSlider("BloomThreshold",{Text="bloom threshold",Min=0,Max=1,Default=0.9,Rounding=2,Callback=function(v) ELI.world.bloom_threshold=v end})
    R:AddToggle("DOFEnable",{Text="depth of field",Default=false,Callback=function(v) ELI.world.depth_of_field=v end})
    R:AddSlider("DOFFocus",{Text="dof focus",Min=0,Max=150,Default=25,Rounding=1,Callback=function(v) ELI.world.dof_focus=v end})
    R:AddSlider("DOFIntensity",{Text="dof intensity",Min=0,Max=1,Default=0.15,Rounding=2,Callback=function(v) ELI.world.dof_intensity=v end})
    R:AddToggle("SunRaysEnable",{Text="sun rays",Default=false,Callback=function(v) ELI.world.sun_rays=v end})
    R:AddSlider("SunRaysInt",{Text="intensity",Min=0,Max=1,Default=0.25,Rounding=2,Callback=function(v) ELI.world.sun_rays_intensity=v end})
    R:AddSlider("SunRaysSpread",{Text="spread",Min=0,Max=1,Default=1,Rounding=2,Callback=function(v) ELI.world.sun_rays_spread=v end})
    R:AddToggle("SkyboxEnable",{Text="skybox",Default=false,Callback=function(v) ELI.world.skybox=v end})
    R:AddDropdown("SkyboxPreset",{Text="preset",Values={"Deep Space","Blissful","Night Sky","Sunset","Candy Land"},Default=1,Callback=function(v) ELI.world.skybox_selected=v end})
    R:AddToggle("SkyboxRotate",{Text="rotate skybox",Default=false,Callback=function(v) ELI.world.skybox_rotate=v end})
    R:AddSlider("SkyboxRotSpeed",{Text="rotate speed",Min=0,Max=20,Default=1,Rounding=2,Callback=function(v) ELI.world.skybox_rotate_speed=v end})
    R:AddToggle("SkyboxNoSun",{Text="remove sun",Default=false,Callback=function(v) ELI.world.skybox_remove_sun=v end})
    R:AddToggle("SkyboxNoMoon",{Text="remove moon",Default=false,Callback=function(v) ELI.world.skybox_remove_moon=v end})
    R:AddToggle("SkyboxNoStars",{Text="remove stars",Default=false,Callback=function(v) ELI.world.skybox_remove_stars=v end})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLAYERS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.Players:AddLeftGroupbox("player list")
    local R = Tabs.Players:AddRightGroupbox("thrower esp")

    L:AddButton({Text="Refresh List",Func=function() PlayerList:Refresh() end})
    L:AddButton({Text="Destroy List",Confirm=true,Func=function() PlayerList:Destroy() end})

    R:AddToggle("ThrowerEnable",{Text="enable thrower esp",Default=false,Callback=function(v) ELI.thrower_esp.enable=v end})
    R:AddToggle("ThrowerName",{Text="show name",Default=false,Callback=function(v) ELI.thrower_esp.name=v end})
      :AddColorPicker("ThrowerNameColor",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.thrower_esp.name_color=v end})
    R:AddSlider("ThrowerNameSize",{Text="name size",Min=6,Max=24,Default=14,Rounding=0,Callback=function(v) ELI.thrower_esp.name_size=v end})
    R:AddToggle("ThrowerImage",{Text="show image",Default=false,Callback=function(v) ELI.thrower_esp.image=v end})
    R:AddToggle("ThrowerDist",{Text="show distance",Default=false,Callback=function(v) ELI.thrower_esp.distance=v end})
      :AddColorPicker("ThrowerDistColor",{Default=Color3.fromRGB(255,255,255),Callback=function(v) ELI.thrower_esp.distance_color=v end})
    R:AddSlider("ThrowerDistSize",{Text="distance size",Min=6,Max=24,Default=12,Rounding=0,Callback=function(v) ELI.thrower_esp.distance_size=v end})
    R:AddDropdown("ThrowerFont",{Text="font",Values={"ProggyTiny","GothamBold","Code","Roboto"},Default=1,Callback=function(v) ELI.thrower_esp.font=v end})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISC TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.Misc:AddLeftGroupbox("movement")
    local R = Tabs.Misc:AddRightGroupbox("automation")

    L:AddToggle("FlyEnable",{Text="fly",Default=false,Callback=function(v) ELI.fly.enable=v end})
    L:AddSlider("FlySpeed",{Text="fly speed",Min=1,Max=500,Default=50,Rounding=0,Callback=function(v) ELI.fly.speed=v end})
    L:AddToggle("WalkspeedEnable",{Text="walkspeed multiplier",Default=false,Callback=function(v) ELI.walkspeed.enable=v end})
    L:AddSlider("WalkspeedMult",{Text="multiplier",Min=0.1,Max=10,Default=1.5,Rounding=2,Callback=function(v) ELI.walkspeed.multiplier=v end})
    L:AddToggle("SlideBoostEnable",{Text="slide boost",Default=false,Callback=function(v) ELI.slide_boost.enable=v end})
    L:AddSlider("SlideBoostSpeed",{Text="boost speed",Min=0,Max=300,Default=60,Rounding=0,Callback=function(v) ELI.slide_boost.speed=v end})
    L:AddToggle("AutoSlideEnable",{Text="auto slide",Default=false,Callback=function(v) ELI.auto_slide.enable=v end})
    L:AddToggle("InfJumpEnable",{Text="infinite double jump",Default=false,Callback=function(v) ELI.infinite_double_jump.enable=v end})
    L:AddToggle("JumpHeightEnable",{Text="custom jump height",Default=false,Callback=function(v) ELI.double_jump_height.enable=v end})
    L:AddSlider("JumpHeightVal",{Text="jump height",Min=0,Max=500,Default=50,Rounding=0,Callback=function(v) ELI.double_jump_height.height=v end})
    L:AddToggle("ThirdPersonEnable",{Text="third person",Default=false,Callback=function(v) ELI.third_person.enable=v end})
    L:AddDivider(); L:AddLabel("phase")
    L:AddToggle("PhaseSpamEnable",{Text="phase spam",Default=false,Callback=function(v) ELI.phase_spam.enable=v end})
    L:AddSlider("PhaseShootTime",{Text="shoot time",Min=0,Max=5,Default=1,Rounding=2,Callback=function(v) ELI.phase_spam.shoot_time=v end})
    L:AddSlider("PhaseHideTime",{Text="hide time",Min=0,Max=5,Default=1,Rounding=2,Callback=function(v) ELI.phase_spam.hide_time=v end})
    L:AddToggle("PhaseHideEnable",{Text="phase hide",Default=false,Callback=function(v) ELI.phase_hide.enable=v end})
    L:AddDivider(); L:AddLabel("removals")
    L:AddToggle("NoFreeze",{Text="no freeze effect",Default=false,Callback=function(v) ELI.removals.no_freeze_effect=v end})
    L:AddToggle("NoBurn",{Text="no burn effect",Default=false,Callback=function(v) ELI.removals.no_burn_effect=v end})
    L:AddToggle("NoFlash",{Text="no flash effect",Default=false,Callback=function(v) ELI.removals.no_flash_effect=v end})

    R:AddToggle("AutoQueueEnable",{Text="auto queue",Default=false,Callback=function(v) ELI.auto_queue.enable=v end})
    R:AddDropdown("AutoQueueMode",{Text="queue mode",Values={"Casual","Ranked","Duel","Custom"},Default=1,Callback=function(v) ELI.auto_queue.queue_mode=v end})
    R:AddToggle("AutoVoteEnable",{Text="auto vote map",Default=false,Callback=function(v) ELI.auto_vote_map.enable=v end})
    R:AddInput("AutoVoteMap",{Text="map name",Placeholder="map name",Callback=function(v) ELI.auto_vote_map.map=v end})
    R:AddToggle("AutoLoadoutEnable",{Text="auto loadout",Default=false,Callback=function(v) ELI.auto_loadout.enable=v end})
    R:AddDivider(); R:AddLabel("arcade")
    R:AddToggle("ArcadeGrabDrops",{Text="grab drops",Default=false,Callback=function(v) ELI.arcade_server.grab_drops=v end})
    R:AddToggle("ArcadeAutoRespawn",{Text="auto respawn",Default=false,Callback=function(v) ELI.arcade_server.auto_respawn=v end})
    R:AddDivider(); R:AddLabel("sound spammer")
    R:AddToggle("SoundSpamEnable",{Text="enable",Default=false,Callback=function(v) ELI.sound_spammer.enable=v end})
    R:AddDropdown("SoundSpamType",{Text="type",Values={"DoubleJump","Slide","Shot","Footstep"},Default=1,Callback=function(v) ELI.sound_spammer.type=v end})
    R:AddDivider(); R:AddLabel("animation")
    R:AddToggle("AnimEnable",{Text="animation override",Default=false,Callback=function(v) ELI.animation.enable=v end})
    R:AddInput("AnimSelect",{Text="animation id",Placeholder="animation name",Callback=function(v) ELI.animation.select_animation=v end})
    R:AddSlider("AnimSpeed",{Text="speed",Min=0.1,Max=10,Default=2,Rounding=2,Callback=function(v) ELI.animation.speed=v end})
    R:AddDivider(); R:AddLabel("textures")
    R:AddToggle("TexturesEnable",{Text="enable",Default=false,Callback=function(v) ELI.textures.enable=v end})
    R:AddDropdown("TexturesMat",{Text="material",Values={"Brick","Grass","Wood","Metal","Neon","ForceField","SmoothPlastic"},Default=1,Callback=function(v) ELI.textures.material=v end})
      :AddColorPicker("TexturesColor",{Default=Color3.fromRGB(244,244,244),Callback=function(v) ELI.textures.color=v end})
    R:AddToggle("TexturesVM",{Text="apply to viewmodel",Default=false,Callback=function(v) ELI.textures.apply_to_viewmodel=v end})
    R:AddDivider(); R:AddLabel("device spoof")
    R:AddToggle("DeviceSpoofEnable",{Text="enable",Default=false,Callback=function(v) ELI.device_spoof.enable=v end})
    R:AddDropdown("DeviceSpoofType",{Text="device",Values={"MouseKeyboard","Touch","Gamepad"},Default=1,Callback=function(v) ELI.device_spoof.type=v end})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SPOOF TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.Spoof:AddLeftGroupbox("profile spoofing")
    local R = Tabs.Spoof:AddRightGroupbox("display spoofing")

    L:AddToggle("LevelSpoofEnable",{Text="spoof level",Default=false,Callback=function(v) ELI.spoof.level.enable=v end})
    L:AddSlider("LevelSpoofVal",{Text="level",Min=1,Max=999,Default=9,Rounding=0,Callback=function(v) ELI.spoof.level.value=v end})
    L:AddToggle("StreakSpoofEnable",{Text="spoof win streak",Default=false,Callback=function(v) ELI.spoof.streak.enable=v end})
    L:AddSlider("StreakSpoofVal",{Text="streak",Min=0,Max=999,Default=9,Rounding=0,Callback=function(v) ELI.spoof.streak.value=v end})
    L:AddToggle("EloSpoofEnable",{Text="spoof elo",Default=false,Callback=function(v) ELI.elo_spoof.enable=v end})
    L:AddSlider("EloSpoofVal",{Text="elo",Min=0,Max=200000,Default=60000,Rounding=0,Callback=function(v) ELI.elo_spoof.value=v end})
    L:AddToggle("RankSpoofEnable",{Text="spoof rank",Default=false,Callback=function(v) ELI.rank_spoof.enable=v end})
    L:AddDropdown("RankSpoofRank",{Text="rank",Values={"Bronze","Silver","Gold","Diamond","Onyx","Nemesis","Arch Nemesis"},Default=7,Callback=function(v) ELI.rank_spoof.rank=v end})
    L:AddToggle("NameSpoofEnable",{Text="spoof display name",Default=false,Callback=function(v) ELI.name_spoof.enable=v end})
    L:AddInput("NameSpoofDisplay",{Text="display name",Placeholder="display name",Callback=function(v) ELI.name_spoof.display=v end})
    L:AddInput("NameSpoofUsername",{Text="username",Placeholder="@username",Callback=function(v) ELI.name_spoof.username=v end})
    L:AddDivider(); L:AddLabel("player status spoof")
    L:AddToggle("StatusSpoofEnable",{Text="enable",Default=false,Callback=function(v) ELI.player_status_spoof.enable=v end})
    L:AddDropdown("StatusSpoofSelect",{Text="status",Values={"AFK","Idle","InGame","InQueue","InLobby"},Default=1,Callback=function(v) ELI.player_status_spoof.select=v end})

    R:AddToggle("ProfileLocalEnable",{Text="spoof own profile",Default=false,Callback=function(v) ELI.profile.spoof_local=v end})
    R:AddInput("ProfileLocalName",{Text="local profile name",Placeholder="name",Callback=function(v) ELI.profile.spoof_local_name=v end})
    R:AddToggle("ProfileOtherEnable",{Text="spoof others' profiles",Default=false,Callback=function(v) ELI.profile.spoof_other=v end})
    R:AddInput("ProfileOtherName",{Text="other profile name",Placeholder="name",Callback=function(v) ELI.profile.spoof_other_name=v end})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- UI SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local L = Tabs.UISettings:AddLeftGroupbox("widgets")
    local R = Tabs.UISettings:AddRightGroupbox("watermark")

    L:AddToggle("WidgetWatermark",{Text="watermark",Default=true,Callback=function(v) pcall(function() Library:SetWatermarkVisibility(v) end) end})
    L:AddToggle("WidgetRadar",{Text="radar",Default=false})
    L:AddToggle("WidgetPlayerList",{Text="player list",Default=false})
    L:AddToggle("WidgetVelocity",{Text="velocity",Default=false})
    L:AddToggle("WidgetClosestPlayer",{Text="closest player",Default=false})

    R:AddToggle("WatermarkFps",{Text="show fps",Default=true})
    R:AddToggle("WatermarkPing",{Text="show ping",Default=true})
    R:AddToggle("WatermarkTime",{Text="show time",Default=true})
    R:AddToggle("WatermarkExecutor",{Text="show executor",Default=false})
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
Tabs.Settings:ApplySettings()
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:ApplyToTab(Tabs.Settings)

local SettingsCustom = Tabs.Settings:AddLeftGroupbox("controls")
SettingsCustom:AddButton("Test Notification",function()
    Library:Notify({Title="Elisium",Description="notification test",Time=2})
end)
SettingsCustom:AddButton({Text="Unload UI",DoubleClick=true,Func=function()
    Library:Unload()
end})

-- ─── Autoload config ─────────────────────────────────────────────────────────
SaveManager:LoadAutoloadConfig()

-- ─── Cleanup ─────────────────────────────────────────────────────────────────
Library:OnUnload(function()
    if getgenv().GLOBAL_TROVE then pcall(function() getgenv().GLOBAL_TROVE:Destroy() end) end
    if flyBody then flyBody:Destroy(); flyBody=nil end
    getgenv().elisium_loaded = false
    getgenv().Library = nil
end)

Library:Notify({Title="Elisium → XoneScriptK",Description="Loaded with full implementation!",Time=3})

-- ═══════════════════════════════════════════════════════════════════════════════
-- VIEWMODEL CHAMS (RenderStepped -- applies material/color to FirstPerson VM)
-- ═══════════════════════════════════════════════════════════════════════════════
local vmHighlights = {} -- player -> Highlight instance table

local function applyChamsToModel(model, cfg)
    if not model then return end
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("BasePart") or part:IsA("MeshPart") or part:IsA("SpecialMesh") then
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                pcall(function()
                    if cfg.enable then
                        part.Material = Enum.Material[cfg.material] or Enum.Material.Neon
                        part.Color    = cfg.color
                        part.Transparency = cfg.invisible and 1 or cfg.transparency
                        part.CastShadow   = false
                    else
                        part.Transparency = 0
                    end
                end)
            end
        end
    end
end

local function applyHighlightToModel(model, cfg, hlCache, key)
    if not model then return end
    local hl = hlCache[key]
    if not hl then
        hl = Instance.new("Highlight")
        pcall(function() hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop end)
        hl.Parent  = CoreGui
        hlCache[key] = hl
    end
    hl.Adornee  = cfg.enable and model or nil
    hl.Enabled  = cfg.enable
    if cfg.enable then
        hl.FillColor          = cfg.color
        hl.FillTransparency   = cfg.transparency
        hl.OutlineColor       = cfg.outline_color
        hl.OutlineTransparency= cfg.outline_transparency
    end
end

local vmHL = {}

trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    local cfg  = ELI.viewmodel_chams
    local char = LocalPlayer.Character
    if not char then return end

    -- Try to find the ViewModels folder
    local vms = workspace:FindFirstChild("ViewModels")
    if not vms then return end

    -- Weapon chams
    local firstPerson = vms:FindFirstChild("FirstPerson")
    if firstPerson then
        for _, child in ipairs(firstPerson:GetChildren()) do
            if child.Name:find(LocalPlayer.Name) then
                applyChamsToModel(child, cfg.weapon_chams)
                applyHighlightToModel(child, cfg.weapon_highlight, vmHL, "weapon_"..child.Name)
            end
        end
    end

    -- Arm chams (Character viewmodel arms)
    local armModel = char:FindFirstChild("Arms") or char:FindFirstChild("LeftArm") and char or nil
    if armModel then
        applyChamsToModel(armModel, cfg.arm_chams)
        applyHighlightToModel(armModel, cfg.arm_highlight, vmHL, "arms")
    end
end)))

trove:Add(function()
    for _, hl in pairs(vmHL) do pcall(function() hl:Destroy() end) end
    vmHL = {}
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- TEXTURE SWAPPER (all workspace BaseParts)
-- ═══════════════════════════════════════════════════════════════════════════════
local textureOriginals = {} -- part -> {Material, Color}
local textureApplied   = false

trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    local cfg = ELI.textures
    if cfg.enable then
        if not textureApplied then
            textureApplied = true
        end
        local mat = pcall(function() return Enum.Material[cfg.material] end) and Enum.Material[cfg.material] or Enum.Material.Brick
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") or part:IsA("MeshPart") then
                local plr = Players:GetPlayerFromCharacter(part.Parent)
                if plr == LocalPlayer and not cfg.apply_to_viewmodel then continue end
                pcall(function()
                    part.Material = mat
                    part.Color    = cfg.color
                end)
            end
        end
    else
        textureApplied = false
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- REMOVALS (freeze / burn / flash effects)
-- ═══════════════════════════════════════════════════════════════════════════════
local function removeEffects(char)
    if not char then return end
    local rem = ELI.removals
    for _, obj in ipairs(char:GetDescendants()) do
        if rem.no_freeze_effect and obj:IsA("SpecialMesh") and obj.Name == "FreezeEffect" then
            pcall(function() obj:Destroy() end)
        end
        if rem.no_burn_effect and obj:IsA("Fire") then
            pcall(function() obj:Destroy() end)
        end
        if rem.no_flash_effect and obj:IsA("BlurEffect") and obj.Name == "FlashBlur" then
            pcall(function() obj:Destroy() end)
        end
    end
end

trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if not (ELI.removals.no_freeze_effect or ELI.removals.no_burn_effect or ELI.removals.no_flash_effect) then return end
    local char = LocalPlayer.Character
    removeEffects(char)
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- PHASE SPAM / PHASE HIDE
-- Rivals-specific: fires the Phase remote repeatedly to keep hidden
-- ═══════════════════════════════════════════════════════════════════════════════
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local phaseSpamConn

trove:Add(task.spawn(LPH_NO_VIRTUALIZE(function()
    while true do
        task.wait(0.05)
        if ELI.phase_spam.enable then
            pcall(function()
                ReplicatedStorage.Remotes.Mechanics.Phase:FireServer(true)
                task.wait(ELI.phase_spam.shoot_time)
                ReplicatedStorage.Remotes.Mechanics.Phase:FireServer(false)
                task.wait(ELI.phase_spam.hide_time)
            end)
        elseif ELI.phase_hide.enable then
            pcall(function()
                ReplicatedStorage.Remotes.Mechanics.Phase:FireServer(true)
            end)
        else
            pcall(function()
                ReplicatedStorage.Remotes.Mechanics.Phase:FireServer(false)
            end)
        end
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- AUTO SLIDE
-- Sends the slide input continuously when moving
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if not ELI.auto_slide.enable then return end
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.MoveDirection.Magnitude == 0 then return end
    pcall(function()
        ReplicatedStorage.Remotes.Mechanics.Slide:FireServer(true)
    end)
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- SLIDE BOOST
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if not ELI.slide_boost.enable then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    -- check if sliding (velocity-based heuristic)
    local vel = root.AssemblyLinearVelocity
    if vel.Magnitude > 2 then
        local boost = root.CFrame.LookVector * ELI.slide_boost.speed
        root.AssemblyLinearVelocity = Vector3.new(boost.X, vel.Y, boost.Z)
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- THIRD PERSON
-- ═══════════════════════════════════════════════════════════════════════════════
local thirdPersonActive = false
local originalCameraMode

trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    if ELI.third_person.enable then
        if not thirdPersonActive then
            thirdPersonActive = true
            pcall(function()
                LocalPlayer.CameraMode = Enum.CameraMode.Classic
                Camera.CameraType = Enum.CameraType.Custom
            end)
        end
        -- push camera back
        pcall(function()
            local char = LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local back = Camera.CFrame.LookVector * -6
                Camera.CFrame = CFrame.new(root.Position + Vector3.new(back.X, 1.5, back.Z), root.Position)
            end
        end)
    else
        if thirdPersonActive then
            thirdPersonActive = false
            pcall(function()
                LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
            end)
        end
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- MOTION BLUR (post-effect driven by camera delta)
-- ═══════════════════════════════════════════════════════════════════════════════
local motionBlurEffect = Instance.new("BlurEffect")
motionBlurEffect.Size    = 0
motionBlurEffect.Enabled = false
motionBlurEffect.Parent  = Camera

local lastCamCF = Camera.CFrame
trove:Add(function() pcall(function() motionBlurEffect:Destroy() end) end)

trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function(dt)
    local cfg = ELI.motion_blur
    if not cfg.enable then
        motionBlurEffect.Enabled = false
        return
    end
    motionBlurEffect.Enabled = true
    local delta = (Camera.CFrame * lastCamCF:Inverse()).Rotation
    local angle = math.deg(math.acos(math.clamp(
        (delta.XVector.X + delta.YVector.Y + delta.ZVector.Z - 1) / 2, -1, 1
    )))
    motionBlurEffect.Size = math.clamp(angle * cfg.sensitivity * cfg.intensity, 0, 56)
    lastCamCF = Camera.CFrame
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- SKYBOX (preset loading + optional rotation)
-- ═══════════════════════════════════════════════════════════════════════════════
local skyboxPresets = {
    ["Deep Space"] = {
        SkyboxBk = "rbxassetid://129248691",
        SkyboxDn = "rbxassetid://129248691",
        SkyboxFt = "rbxassetid://129248691",
        SkyboxLf = "rbxassetid://129248691",
        SkyboxRt = "rbxassetid://129248691",
        SkyboxUp = "rbxassetid://129248691",
    },
    ["Night Sky"] = {
        SkyboxBk = "rbxassetid://159454286",
        SkyboxDn = "rbxassetid://159454286",
        SkyboxFt = "rbxassetid://159454286",
        SkyboxLf = "rbxassetid://159454286",
        SkyboxRt = "rbxassetid://159454286",
        SkyboxUp = "rbxassetid://159454286",
    },
    ["Sunset"] = {
        SkyboxBk = "rbxassetid://927400150",
        SkyboxDn = "rbxassetid://927400150",
        SkyboxFt = "rbxassetid://927400150",
        SkyboxLf = "rbxassetid://927400150",
        SkyboxRt = "rbxassetid://927400150",
        SkyboxUp = "rbxassetid://927400150",
    },
}

local activeSky = nil
local skyRotAngle = 0

trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
    local w = ELI.world
    if not w.skybox then
        if activeSky then
            pcall(function() activeSky:Destroy() end)
            activeSky = nil
        end
        return
    end

    if not activeSky then
        activeSky = Instance.new("Sky")
        activeSky.Name = "ELI_Sky"
        local preset = skyboxPresets[w.skybox_selected]
        if preset then
            for k, v in pairs(preset) do pcall(function() activeSky[k] = v end) end
        end
        activeSky.StarCount = w.skybox_remove_stars and 0 or 3000
        activeSky.SunAngularSize  = w.skybox_remove_sun  and 0 or 21
        activeSky.MoonAngularSize = w.skybox_remove_moon and 0 or 11
        activeSky.Parent = Lighting
    else
        activeSky.StarCount       = w.skybox_remove_stars and 0 or 3000
        activeSky.SunAngularSize  = w.skybox_remove_sun   and 0 or 21
        activeSky.MoonAngularSize = w.skybox_remove_moon  and 0 or 11
    end

    if w.skybox_rotate then
        skyRotAngle = (skyRotAngle + dt * w.skybox_rotate_speed * 10) % 360
        Lighting.ClockTime = (skyRotAngle / 360) * 24
    end
end)))

trove:Add(function()
    if activeSky then pcall(function() activeSky:Destroy() end) end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- AUTO QUEUE (fires JoinQueue remote while enabled)
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(task.spawn(LPH_NO_VIRTUALIZE(function()
    while true do
        task.wait(2)
        if ELI.auto_queue.enable then
            pcall(function()
                ReplicatedStorage.Remotes.Matchmaking.JoinQueue:InvokeServer(ELI.auto_queue.queue_mode)
            end)
        end
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- AUTO VOTE MAP
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(task.spawn(LPH_NO_VIRTUALIZE(function()
    while true do
        task.wait(1)
        if ELI.auto_vote_map.enable and ELI.auto_vote_map.map ~= "" then
            pcall(function()
                ReplicatedStorage.Remotes.Matchmaking.VoteMap:FireServer(ELI.auto_vote_map.map)
            end)
        end
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- ARCADE SERVER: grab drops + auto respawn
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    if not ELI.arcade_server.grab_drops then return end
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    for _, v in ipairs(workspace:GetChildren()) do
        if v.Name == "_drop" and v:IsA("BasePart") then
            pcall(function()
                firetouchinterest(root, v, 0)
                firetouchinterest(root, v, 1)
            end)
        end
    end
end)))

trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if ELI.arcade_server.auto_respawn then
        pcall(function()
            ReplicatedStorage.Remotes.Duels.RespawnNow:FireServer()
        end)
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEVICE SPOOF
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if ELI.device_spoof.enable then
        pcall(function()
            ReplicatedStorage.Remotes.Replication.Fighter.SetControls:FireServer(ELI.device_spoof.type)
        end)
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- SOUND SPAMMER
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if ELI.sound_spammer.enable then
        pcall(function()
            ReplicatedStorage.Remotes.Mechanics.PlaySound:FireServer(ELI.sound_spammer.type)
        end)
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- FORCE MODIFIER (gun item lib patch)
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if ELI.guns.force_modifier_enable then
        pcall(function()
            local lib = require(ReplicatedStorage:WaitForChild("Libraries"):WaitForChild("Items"))
            for _, item in pairs(lib.Items) do
                if item.InputSpammingEnabled and item.InputSpammingEnabled.StartShooting ~= nil then
                    item.InputSpammingEnabled.StartShooting = ELI.guns.force_modifier_v
                end
            end
        end)
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- STAT SPOOF via attribute write (level, streak, elo, status)
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    local lp = LocalPlayer
    if ELI.spoof.level.enable           then pcall(function() lp:SetAttribute("Level", ELI.spoof.level.value) end) end
    if ELI.spoof.streak.enable          then pcall(function() lp:SetAttribute("StatisticDuelsWinStreak", ELI.spoof.streak.value) end) end
    if ELI.player_status_spoof.enable   then pcall(function() lp:SetAttribute("PlayerStatus", ELI.player_status_spoof.select) end) end
    if ELI.elo_spoof.enable             then pcall(function() lp:SetAttribute("DisplayELO", ELI.elo_spoof.value) end) end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- RANK / NAME SPOOF via UI string replace on PlayerGui
-- ═══════════════════════════════════════════════════════════════════════════════
local spoofConnections = {}

local function lockLabel(label, text)
    if not label or not label:IsA("TextLabel") then return end
    local existing = spoofConnections[label]
    if existing then existing:Disconnect(); spoofConnections[label] = nil end
    if label.Text ~= text then label.Text = text end
    spoofConnections[label] = label:GetPropertyChangedSignal("Text"):Connect(function()
        if label.Text ~= text then label.Text = text end
    end)
end

trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    local cfg = ELI.name_spoof
    if not cfg.enable then return end
    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not pg then return end
    for _, label in ipairs(pg:GetDescendants()) do
        if label:IsA("TextLabel") then
            if cfg.display ~= "" and label.Text == LocalPlayer.DisplayName then
                lockLabel(label, cfg.display)
            end
            if cfg.username ~= "" and label.Text == "@"..LocalPlayer.Name or label.Text == LocalPlayer.Name then
                lockLabel(label, cfg.username)
            end
        end
    end
end)))

trove:Add(function()
    for lbl, conn in pairs(spoofConnections) do
        pcall(function() conn:Disconnect() end)
    end
    spoofConnections = {}
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- THROWER ESP (workspace throwable objects)
-- ═══════════════════════════════════════════════════════════════════════════════
local throwerGui = Instance.new("ScreenGui")
throwerGui.Name = "ELI_ThrowerESP"
throwerGui.ResetOnSpawn   = false
throwerGui.IgnoreGuiInset = true
throwerGui.DisplayOrder   = 9e9 - 1
pcall(function() throwerGui.Parent = gethui() end)
if not throwerGui.Parent then throwerGui.Parent = CoreGui end
trove:Add(function() pcall(function() throwerGui:Destroy() end) end)

local throwerCache = {}

local THROWABLE_NAMES = {
    "Grenade", "Molotov", "FlashGrenade", "SmokeGrenade",
    "Knife", "SubspaceTripmineHitbox", "Shuriken", "Boomerang",
}
local function isThrowable(name)
    for _, t in ipairs(THROWABLE_NAMES) do if name == t then return true end end
    return false
end

local function getOrMakeThrowerLabels(obj)
    if throwerCache[obj] then return throwerCache[obj] end

    local name_lbl = Instance.new("TextLabel")
    name_lbl.BackgroundTransparency = 1
    name_lbl.TextStrokeTransparency = 0
    name_lbl.TextStrokeColor3 = Color3.new(0,0,0)
    name_lbl.TextScaled = false
    name_lbl.Font = Enum.Font.ProggyTiny
    name_lbl.TextXAlignment = Enum.TextXAlignment.Center
    name_lbl.Size = UDim2.fromOffset(80,14)
    name_lbl.Visible = false
    name_lbl.Parent = throwerGui

    local dist_lbl = Instance.new("TextLabel")
    dist_lbl.BackgroundTransparency = 1
    dist_lbl.TextStrokeTransparency = 0
    dist_lbl.TextStrokeColor3 = Color3.new(0,0,0)
    dist_lbl.TextScaled = false
    dist_lbl.Font = Enum.Font.ProggyTiny
    dist_lbl.TextXAlignment = Enum.TextXAlignment.Center
    dist_lbl.Size = UDim2.fromOffset(80,12)
    dist_lbl.Visible = false
    dist_lbl.Parent = throwerGui

    local icon_lbl = Instance.new("ImageLabel")
    icon_lbl.BackgroundTransparency = 1
    icon_lbl.Size = UDim2.fromOffset(80,80)
    icon_lbl.Visible = false
    icon_lbl.Parent = throwerGui

    local entry = {name=name_lbl, dist=dist_lbl, icon=icon_lbl}
    throwerCache[obj] = entry
    return entry
end

workspace.ChildRemoved:Connect(function(obj)
    local t = throwerCache[obj]
    if not t then return end
    pcall(function() t.name:Destroy(); t.dist:Destroy(); t.icon:Destroy() end)
    throwerCache[obj] = nil
end)

trove:Add(RunService.RenderStepped:Connect(LPH_NO_VIRTUALIZE(function()
    local cfg = ELI.thrower_esp
    if not cfg.enable then
        for _, t in pairs(throwerCache) do
            t.name.Visible = false; t.dist.Visible = false; t.icon.Visible = false
        end
        return
    end

    local active = {}
    for _, v in ipairs(workspace:GetChildren()) do
        if not isThrowable(v.Name) then continue end
        local root = v:FindFirstChildWhichIsA("BasePart")
        if not root then continue end

        active[v] = true
        local t = getOrMakeThrowerLabels(v)
        local pos3d, onscreen = Camera:WorldToViewportPoint(root.Position)
        local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude * 0.28)

        t.name.Visible  = onscreen and cfg.name
        t.dist.Visible  = onscreen and cfg.distance
        t.icon.Visible  = onscreen and cfg.image

        if onscreen then
            t.name.TextColor3 = cfg.name_color
            t.name.TextSize   = cfg.name_size
            t.name.Text       = v.Name
            t.name.Position   = UDim2.fromOffset(pos3d.X - 40, pos3d.Y - 7)

            t.dist.TextColor3 = cfg.distance_color
            t.dist.TextSize   = cfg.distance_size
            t.dist.Text       = dist.."M"
            t.dist.Position   = UDim2.fromOffset(pos3d.X - 40, pos3d.Y + 7)

            t.icon.Position   = UDim2.fromOffset(pos3d.X - 40, pos3d.Y - 90)
        end
    end

    for obj, t in pairs(throwerCache) do
        if not active[obj] then
            pcall(function() t.name:Destroy(); t.dist:Destroy(); t.icon:Destroy() end)
            throwerCache[obj] = nil
        end
    end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEATH EFFECTS (on humanoid death event)
-- ═══════════════════════════════════════════════════════════════════════════════
local function spawnDeathEffect(position, color)
    local cfg = ELI.death_effects
    if not cfg.enable then return end

    if cfg.type == "Explosion" then
        local ex = Instance.new("Explosion")
        ex.BlastRadius    = 0
        ex.BlastPressure  = 0
        ex.Position       = position
        ex.DestroyJointRadiusPercent = 0
        ex.Parent         = workspace
        task.delay(0.1, function() pcall(function() ex:Destroy() end) end)
        -- tinted particle emitter
        local part = Instance.new("Part")
        part.Anchored     = true
        part.CanCollide   = false
        part.CanTouch     = false
        part.Transparency = 1
        part.CFrame       = CFrame.new(position)
        part.Parent       = workspace
        local emitter = Instance.new("ParticleEmitter", part)
        emitter.Color     = ColorSequence.new(color)
        emitter.Speed     = NumberRange.new(10, 30)
        emitter.Rate      = 500
        emitter.Lifetime  = NumberRange.new(0.3, 0.6)
        emitter.LightEmission = 0.5
        emitter.Enabled   = true
        task.delay(0.05, function()
            emitter.Enabled = false
            task.delay(1, function() pcall(function() part:Destroy() end) end)
        end)

    elseif cfg.type == "Firework" then
        for i = 1, 6 do
            task.delay(i * 0.08, function()
                local p = Instance.new("Part")
                p.Anchored = true; p.CanCollide = false; p.CanTouch = false
                p.Transparency = 1
                p.CFrame = CFrame.new(position + Vector3.new(math.random(-3,3),math.random(0,4),math.random(-3,3)))
                p.Parent = workspace
                local em = Instance.new("ParticleEmitter",p)
                em.Color = ColorSequence.new(color); em.Speed = NumberRange.new(5,15)
                em.Rate = 400; em.Lifetime = NumberRange.new(0.2,0.5); em.LightEmission = 1
                em.Enabled = true
                task.delay(0.05,function() em.Enabled=false; task.delay(1,function() pcall(function() p:Destroy() end) end) end)
            end)
        end

    elseif cfg.type == "Sparkle" then
        local p = Instance.new("Part")
        p.Anchored=true; p.CanCollide=false; p.Transparency=1
        p.CFrame = CFrame.new(position); p.Parent = workspace
        local em = Instance.new("ParticleEmitter",p)
        em.Color=ColorSequence.new(color); em.Speed=NumberRange.new(2,8)
        em.Rate=800; em.LightEmission=1; em.Lifetime=NumberRange.new(0.5,1)
        em.Enabled=true
        task.delay(0.1,function() em.Enabled=false; task.delay(2,function() pcall(function() p:Destroy() end) end) end)
    end
end

local function hookDeathEvent(player)
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    hum.Died:Connect(function()
        local root = char:FindFirstChild("HumanoidRootPart")
        local pos  = root and root.Position or Vector3.new(0,0,0)
        spawnDeathEffect(pos, ELI.death_effects.color)
    end)
end

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        p.CharacterAdded:Connect(function() hookDeathEvent(p) end)
        if p.Character then hookDeathEvent(p) end
    end
end
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function() hookDeathEvent(p) end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- HIT NOTIFY (fires when ReplicateFromServer DamageNumberEffect is intercepted)
-- Wire: call eli_hitNotify(targetName, damage, isHeadshot) from the hook
-- ═══════════════════════════════════════════════════════════════════════════════
getgenv().eli_hitNotify = function(targetName, damage, isHeadshot)
    local cfg = ELI.hit_notify
    if not cfg.enable then return end
    local msg = cfg.msg
    msg = msg:gsub("{target}", tostring(targetName))
    msg = msg:gsub("{damage}", tostring(math.floor(damage or 0)))
    msg = msg:gsub("{hitpart}", isHeadshot and "Head" or "Body")
    pcall(function() Library:Notify(msg, cfg.duration) end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- CUSTOM HIT EFFECTS (called from DamageNumberEffect hook)
-- ═══════════════════════════════════════════════════════════════════════════════
getgenv().eli_hitEffect = function(worldPos)
    local cfg = ELI.custom_hiteffects
    if not cfg.enable or not worldPos then return end
    local p = Instance.new("Part")
    p.Anchored=true; p.CanCollide=false; p.CanTouch=false; p.Transparency=1
    p.CFrame=CFrame.new(worldPos); p.Parent=workspace
    local em = Instance.new("ParticleEmitter",p)
    em.Color=ColorSequence.new(cfg.color); em.Speed=NumberRange.new(5,12)
    em.Rate=600; em.Lifetime=NumberRange.new(0.1,0.3); em.LightEmission=0.8
    em.Enabled=true
    task.delay(0.05,function() em.Enabled=false; task.delay(0.5,function() pcall(function() p:Destroy() end) end) end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- BULLET TRACER HOOK (intercept projectile creation from workspace)
-- Watches for new Parts with names matching projectile patterns
-- ═══════════════════════════════════════════════════════════════════════════════
local PROJECTILE_NAMES = {"Bullet","Projectile","BulletInstance","Shot","Pellet"}
local function isProjectile(name)
    for _, n in ipairs(PROJECTILE_NAMES) do if name == n then return true end end
    return false
end

workspace.ChildAdded:Connect(function(obj)
    if not ELI.bullet_tracers.enable then return end
    if not isProjectile(obj.Name) then return end
    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end

    task.delay(0, function()
        local from = Camera.CFrame.Position
        task.delay(0.05, function()
            if not part.Parent then return end
            local to = part.Position
            pcall(function() createTracer(from, to) end)
        end)
    end)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- ANIMATION OVERRIDE
-- ═══════════════════════════════════════════════════════════════════════════════
local animConn
local function applyAnimOverride()
    local cfg = ELI.animation
    if not cfg.enable or cfg.select_animation == "" then
        if animConn then animConn:Disconnect(); animConn=nil end
        return
    end
    local char = LocalPlayer.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then return end
    -- Load animation
    pcall(function()
        local anim = Instance.new("Animation")
        anim.AnimationId = "rbxassetid://"..cfg.select_animation
        local track = animator:LoadAnimation(anim)
        track:Play()
        track:AdjustSpeed(cfg.speed)
    end)
end

trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    if not ELI.animation.enable then return end
    applyAnimOverride()
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- PROFILE SPOOF (local and other players' name text in PlayerGui)
-- ═══════════════════════════════════════════════════════════════════════════════
trove:Add(RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
    local cfg = ELI.profile
    if not (cfg.spoof_local or cfg.spoof_other) then return end

    local function scanGui(gui)
        for _, obj in ipairs(gui:GetDescendants()) do
            if obj:IsA("TextLabel") or obj:IsA("TextButton") then
                if cfg.spoof_local and cfg.spoof_local_name ~= "" then
                    if obj.Text == LocalPlayer.Name or obj.Text == LocalPlayer.DisplayName then
                        pcall(function() obj.Text = cfg.spoof_local_name end)
                    end
                end
                if cfg.spoof_other and cfg.spoof_other_name ~= "" then
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer then
                            if obj.Text == p.Name or obj.Text == p.DisplayName then
                                pcall(function() obj.Text = cfg.spoof_other_name end)
                            end
                        end
                    end
                end
            end
        end
    end

    local pg = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if pg then pcall(function() scanGui(pg) end) end
end)))

-- ═══════════════════════════════════════════════════════════════════════════════
-- FINAL NOTIFICATION
-- ═══════════════════════════════════════════════════════════════════════════════
Library:Notify({Title="Elisium → XoneScriptK",Description="All features active.",Time=3})
