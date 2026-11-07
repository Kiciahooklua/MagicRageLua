--[[
    Elisium features → XoneScriptK UI
    All ELI feature groups preserved. Callbacks wire into getgenv().elisium.
    Anti-detect / LPH stubs, Trove, SaveManager, ThemeManager carried over.
    Default: Windows / Roblox executor environment.
]]

-- ─── LPH stubs (required by elisium internals) ──────────────────────────────
function LPH_NO_VIRTUALIZE(f) return f end
function LPH_JIT_MAX(f)       return f end
function LPH_JIT(f)           return f end
function LPH_ENCFUNC(f)       return f end

if not cloneref then cloneref = function(ref) return ref end end

-- ─── Anti-detect (setmetatable / rawlen hooks) ──────────────────────────────
do
    if hookfunction and newcclosure and getcallingscript then
        pcall(function()
            local Old1 = nil
            Old1 = hookfunction(setmetatable, newcclosure(function(Table, MetaTable)
                if type(MetaTable) == "table" and rawget(MetaTable, "__mode") == "kv" then
                    local Caller = getcallingscript()
                    if Caller and Caller.Name == "MiscellaneousController" then
                        return Old1(Table, {})
                    end
                end
                return Old1(Table, MetaTable)
            end))
        end)

        pcall(function()
            local Ol2 = nil
            Ol2 = hookfunction(rawlen, newcclosure(function(Table)
                if type(Table) == "table" then
                    local Caller = getcallingscript()
                    if Caller and Caller.Name == "MiscellaneousController" then
                        return 3
                    end
                end
                return Ol2(Table)
            end))
        end)
    end
end

task.wait(6)

pcall(function()
    if not (hookfunction and newcclosure and getrenv) then return end
    local oldtable
    oldtable = hookfunction(getrenv().setmetatable, newcclosure(function(Table, Metatable)
        if Metatable and typeof(Metatable) == "table" and rawget(Metatable, "__mode") == "kv" then
            local trace = debug.traceback()
            if trace:find("MiscellaneousController") then
                return oldtable({1, 2, 3}, {})
            end
        end
        return oldtable(Table, Metatable)
    end))
end)

-- ─── Anti-cheat script disabler ─────────────────────────────────────────────
coroutine.wrap(function()
    pcall(function()
        local acWords = {"anticheat","ac","detection","ban","kick","security","moderation"}
        local function disableScript(obj) obj.Disabled = true end
        local function checkScript(obj)
            if obj:IsA("LocalScript") or obj:IsA("ModuleScript") then
                local n = string.lower(obj.Name)
                for _, ac in ipairs(acWords) do
                    if string.find(n, ac, 1, true) then
                        pcall(disableScript, obj)
                        break
                    end
                end
            end
        end
        pcall(function() game.DescendantAdded:Connect(function(o) pcall(checkScript, o) end) end)
        pcall(function()
            local d = game:GetDescendants()
            for i = 1, #d do
                pcall(checkScript, d[i])
                if i % 4000 == 0 then task.wait() end
            end
        end)
    end)
end)()

-- ─── Anti-detect: hookmetamethod name/text spoof ────────────────────────────
local antidetect = true
local detecteds  = { ["localscript3"] = true, ["miscellaneouscontroller"] = true }
local callerVerdicts = setmetatable({}, { __mode = "k" })
local original
pcall(function()
    if not (hookmetamethod and newcclosure and getcallingscript) then return end
    original = hookmetamethod(game, "__index", newcclosure(LPH_NO_VIRTUALIZE(function(self, key)
        if antidetect and (key == "Name" or key == "Text") then
            local caller = getcallingscript()
            if caller then
                local blocked = callerVerdicts[caller]
                if blocked == nil then
                    local ok, result = pcall(function()
                        return detecteds[string.lower(original(caller, "Name"))] == true
                    end)
                    blocked = ok and result or false
                    callerVerdicts[caller] = blocked
                end
                if blocked then return "" end
            end
        end
        return original(self, key)
    end)))
end)

getgenv().elisium_set_antidetect = function(v) antidetect = v and true or false end

-- ─── Wait for loading screen ─────────────────────────────────────────────────
repeat task.wait() until not game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen")

-- ─── ELI state table (all feature defaults) ──────────────────────────────────
getgenv().elisium = getgenv().elisium or {
    aimbot = {
        enable = false, show_fov = false, follow_target = false, show_fill = false,
        fov_color = Color3.fromRGB(120,81,166), follow_gunpoint = false,
        fov_fill_color = Color3.fromRGB(120,81,166), fov_fill_color2 = Color3.fromRGB(255,255,255),
        fov_radius = 180, lerp = 0, fov_fill_transparency = 0.6, fov_outline_transparency = 0.2,
        fov_thickness = 2, fov_color2 = Color3.fromRGB(255,255,255), fov_rotation_speed = 90,
        smoothing = 1, closest_part = false,
    },
    triggerbot = { enable = false, team_check = false, reaction_time = 0.05, shoot_delay = 0.1, max_distance = 500 },
    rage = { enable = false, auto = false, silent = false, hitpart = "HitboxHead", prediction = false,
             prediction_mult = 1.2, orbit_speed = 12, orbit_height = 2, orbit_radius = 0 },
    targeting = { max_distance = 100, part = "Head", visible_only = false, anti_katana = false,
                  riot_shield = false, auto_shoot = false },
    esp = {
        enable = false, team_check = true,
        box      = { enable = false, color = Color3.new(1,1,1), outline = Color3.new(0,0,0), inline = Color3.new(0,0,0), thickness = 1 },
        glow     = { enable = false, color_start = Color3.new(1,1,1), color_end = Color3.new(1,1,1), transparency = 1, rotation = 90, speed = 2, animated = false },
        filled   = { enable = false, color_start = Color3.new(1,1,1), color_end = Color3.new(1,1,1), transparency = 0.75, rotation = 90, speed = 2, animated = false,
                     hit_flash = false, hit_color = Color3.fromRGB(255,40,40), hit_time = 0.3 },
        visible  = { enable = false, color = Color3.fromRGB(60,255,90) },
        highlight= { enable = false, fill_color = Color3.fromRGB(120,81,166), outline_color = Color3.fromRGB(255,255,255), fill_transparency = 0.55, outline_transparency = 0 },
        health   = { enable = false, color_high = Color3.fromRGB(0,255,0), color_mid = Color3.fromRGB(255,255,0), color_low = Color3.fromRGB(255,0,0), width = 3, gap = 5 },
        text     = { name = { enable = false, color = Color3.new(1,1,1) }, studs = { enable = false, color = Color3.new(1,1,1) },
                     tool = { enable = false, color = Color3.new(1,1,1), position = "right" }, size = 9,
                     gradient = false, gradient_color1 = Color3.fromRGB(120,81,166), gradient_color2 = Color3.fromRGB(255,255,255),
                     flow = false, flow_speed = 1 },
        max_dist = 25000,
    },
    death_effects    = { enable = false, type = "Explosion", color = Color3.fromRGB(120,81,166) },
    damage_numbers   = { enable = false, remove_ingame = false, color_type = "Gradient", color1 = Color3.fromRGB(255,80,80),
                         color2 = Color3.fromRGB(255,210,90), font = "GothamBold", duration = 0.8, rise = 42, text_size = 18 },
    trajectory       = { enable = false, all_weapons = false, speed = 90, arc_up = 10, color = Color3.fromRGB(120,81,166) },
    target_hud       = { enable = false, target_method = "", position_mode = "static", offset_x = 0, offset_y = 0, scale = 1 },
    world = {
        fog = false, fog_color = Color3.fromRGB(255,255,255), fog_start = 150, fog_end = 550,
        ambient = false, ambient_color = Color3.fromRGB(255,255,255),
        clock = false, clock_time = 14, brightness = false, brightness_level = 1,
        exposure = false, exposure_level = 0,
        color_shift_top = false, color_shift_top_color = Color3.fromRGB(255,255,255),
        color_shift_bottom = false, color_shift_bottom_color = Color3.fromRGB(255,255,255),
        skybox = false, skybox_selected = "Deep Space", skybox_rotate = false, skybox_rotate_speed = 1,
        skybox_rotate_direction = "Horizontal", skybox_rotate_method = "Spin",
        skybox_remove_sun = false, skybox_remove_moon = false, skybox_remove_stars = false,
        atmosphere = false, atmosphere_glare = 1.5, atmosphere_haze = 10, atmosphere_offset = 0.4,
        atmosphere_density = 0.5, atmosphere_color = Color3.fromRGB(255,255,255),
        atmosphere_decay = Color3.fromRGB(90,60,30),
        blur = false, blur_size = 12,
        bloom = false, bloom_intensity = 1, bloom_size = 24, bloom_threshold = 0.9,
        depth_of_field = false, dof_focus = 25, dof_intensity = 0.15,
        sun_rays = false, sun_rays_intensity = 0.25, sun_rays_spread = 1,
        saturation = false, saturation_level = 0, contrast_level = 0, tint_color = Color3.fromRGB(255,255,255),
        lighting_technology = false, lighting_technology_mode = "Future", global_shadows = true,
        env_diffuse = false, env_diffuse_scale = 1, env_specular = false, env_specular_scale = 1,
        outdoor_ambient = false, outdoor_ambient_color = Color3.fromRGB(70,70,70),
    },
    weather          = { enable = false, color = Color3.fromRGB(255,255,255), rate = 100, type = "snow" },
    fov_changer      = { enable = false, fov = 80 },
    auto_slide       = { enable = false },
    guns             = { no_muzzle_flash = false, no_spread = false, force_modifier_enable = false, force_modifier_v = 0 },
    disable_anims    = { enable = false, select = {} },
    stretched_res    = { enable = false, stretched_res_amount = 0.20 },
    viewmodel_offsets= { enable = false, x = 0, y = 0, z = 0 },
    viewmodel_chams  = {
        weapon_chams    = { enable = false, color = Color3.fromRGB(255,255,255), material = "Neon", transparency = 0 },
        arm_chams       = { enable = false, color = Color3.fromRGB(255,255,255), material = "Neon", transparency = 0, invisible = false },
        weapon_highlight= { enable = false, color = Color3.fromRGB(255,255,255), transparency = 0.5, outline_color = Color3.fromRGB(255,255,255), outline_transparency = 0 },
        arm_highlight   = { enable = false, color = Color3.fromRGB(255,255,255), transparency = 0.5, outline_color = Color3.fromRGB(255,255,255), outline_transparency = 0 },
    },
    viewmodel_custom = {
        enable = false, appearance = false,
        body = { color_enable = false, color = Color3.fromRGB(255,255,255), material_enable = false, material = "ForceField", disable_clothes = false, transparency = 0 },
        item = { color_enable = false, color = Color3.fromRGB(255,255,255), material_enable = false, material = "ForceField", transparency = 0 },
    },
    bullet_tracers   = { enable = false, color_start = Color3.fromRGB(255,255,255), color_end = Color3.fromRGB(255,255,255),
                         texture = "lightning", position_lerp_speed = 0, life_time = 1.5, glow = 4,
                         width0 = 0.35, width1 = 0.15, speed = 3, spring_expand = false,
                         expand_speed = 12, expand_damper = 0.6, curve_around = false, curve_height = 14, through_walls = false },
    hit_notify       = { enable = false, duration = 3, msg = "Hit {target} for {damage}" },
    custom_hitsounds = { enable = false, remove_default_hitsound = false, volume = 3, pitch = 1, selected = nil },
    custom_hiteffects= { enable = false, color = Color3.fromRGB(255,0,0) },
    thrower_esp      = { enable = false, name = false, image = false, name_color = Color3.fromRGB(255,255,255),
                         name_size = 14, distance = false, distance_color = Color3.fromRGB(255,255,255),
                         distance_size = 12, thrower_select = "", font = "ProggyTiny" },
    fly              = { enable = false, speed = 50 },
    walkspeed        = { enable = false, multiplier = 1.5 },
    slide_boost      = { enable = false, speed = 60 },
    motion_blur      = { enable = false, intensity = 0.5, sensitivity = 1 },
    infinite_double_jump = { enable = false },
    double_jump_height   = { enable = false, height = 50 },
    third_person     = { enable = false },
    phase_spam       = { enable = false, shoot_time = 1, hide_time = 1 },
    phase_hide       = { enable = false },
    auto_slide       = { enable = false },
    auto_queue       = { enable = false, queue_mode = "" },
    auto_vote_map    = { enable = false, map = "" },
    auto_loadout     = { enable = false, loadout = {"Assault Rifle","Handgun","Fists","Grenade"} },
    animation        = { enable = false, select_animation = "", speed = 2 },
    sound_spammer    = { enable = false, type = "DoubleJump" },
    removals         = { no_freeze_effect = false, no_burn_effect = false, no_flash_effect = false },
    device_spoof     = { enable = false, type = "MouseKeyboard" },
    textures         = { enable = false, material = "Brick", color = Color3.fromRGB(244,244,244), apply_to_viewmodel = false },
    spoof            = { level = { enable = false, value = 9 }, streak = { enable = false, value = 9 } },
    player_status_spoof = { enable = false, select = "" },
    rank_spoof       = { enable = false, rank = "Arch Nemesis" },
    elo_spoof        = { enable = false, value = 60000 },
    name_spoof       = { enable = false, display = "", username = "" },
    profile          = { spoof_local = false, spoof_local_name = "", spoof_other = false, spoof_other_name = "" },
    arcade_server    = { grab_drops = false, auto_respawn = false },
    guns             = { no_muzzle_flash = false, no_spread = false, force_modifier_enable = false, force_modifier_v = 0 },
}

local ELI = getgenv().elisium

-- ─── XoneScriptK Library bootstrap ──────────────────────────────────────────
local Repository = "https://raw.githubusercontent.com/SyndromeXph/XoneScriptK-Library/refs/heads/main/"
local Library    = loadstring(game:HttpGet(Repository .. "lib.luau"))()
local SaveManager= loadstring(game:HttpGet(Repository .. "addons/SaveManager.lua"))()
local ThemeManager=loadstring(game:HttpGet(Repository .. "addons/ThemeManager.lua"))()

SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()

local Toggles = Library.Toggles
local Options  = Library.Options

-- ─── Watermark ───────────────────────────────────────────────────────────────
local Watermark = Library:Watermark({
    Text        = "Elisium | XoneScriptK",
    Position    = UDim2.fromOffset(10, 110),
    IconPosition= "left",
    IconSize    = 16,
    Draggable   = true,
})

-- ─── Window ──────────────────────────────────────────────────────────────────
local Window = Library:CreateWindow({
    Title = "Elisium.lol [XoneScriptK]",
    Size  = UDim2.fromOffset(740, 660),
})

-- ─── Auxiliary windows ───────────────────────────────────────────────────────
local Preview = Library:PreviewWindow({ Title = "Preview", Width = 240, Height = 277, BindTab = "Visual" })
Preview:PositionNextTo(Window)
Preview:SyncWithWindow(Window)

local PlayerList = Library:Playerlist({ Title = "Players", Width = 240, Height = 276, BindTab = "Players" })
PlayerList:PositionBelow(Preview)
PlayerList:SyncWithWindow(Window)

local KeybindList = Library:KeybindList({ Title = "Keybinds", Width = 220, VisibilityControl = true, ShowToggleState = true })

-- ─── Tabs ─────────────────────────────────────────────────────────────────────
local Tabs = {
    Aimbot   = Window:AddTab("aimbot"),
    Rage     = Window:AddTab("rage"),
    ESP      = Window:AddTab("esp"),
    Visuals  = Window:AddTab("visuals"),
    World    = Window:AddTab("world"),
    Players  = Window:AddTab("players"),
    Misc     = Window:AddTab("misc"),
    Spoof    = Window:AddTab("spoof"),
    UISettings=Window:AddTab("UI Settings"),
    Settings = Window:AddTab("Settings"),
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- AIMBOT TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local AimL = Tabs.Aimbot:AddLeftGroupbox("aimbot")
    local AimR = Tabs.Aimbot:AddRightGroupbox("targeting")

    AimL:AddToggle("AimbotEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.aimbot.enable = v end })

    AimL:AddSlider("AimbotSmoothing", { Text = "smoothing", Min = 0, Max = 20, Default = 1, Rounding = 1,
        Callback = function(v) ELI.aimbot.smoothing = v end })

    AimL:AddSlider("AimbotFOV", { Text = "fov radius", Min = 0, Max = 500, Default = 180, Rounding = 0,
        Callback = function(v) ELI.aimbot.fov_radius = v end })

    AimL:AddSlider("AimbotLerp", { Text = "lerp", Min = 0, Max = 1, Default = 0, Rounding = 2,
        Callback = function(v) ELI.aimbot.lerp = v end })

    AimL:AddToggle("AimbotShowFOV", { Text = "show fov circle", Default = false,
        Callback = function(v) ELI.aimbot.show_fov = v end })
        :AddColorPicker("AimbotFOVColor", { Default = Color3.fromRGB(120,81,166),
            Callback = function(v) ELI.aimbot.fov_color = v end })

    AimL:AddToggle("AimbotShowFill", { Text = "show fov fill", Default = false,
        Callback = function(v) ELI.aimbot.show_fill = v end })
        :AddColorPicker("AimbotFillColor", { Default = Color3.fromRGB(120,81,166),
            Callback = function(v) ELI.aimbot.fov_fill_color = v end })

    AimL:AddSlider("AimbotFillTransparency", { Text = "fill transparency", Min = 0, Max = 1, Default = 0.6, Rounding = 2,
        Callback = function(v) ELI.aimbot.fov_fill_transparency = v end })

    AimL:AddSlider("AimbotOutlineTransparency", { Text = "outline transparency", Min = 0, Max = 1, Default = 0.2, Rounding = 2,
        Callback = function(v) ELI.aimbot.fov_outline_transparency = v end })

    AimL:AddSlider("AimbotThickness", { Text = "fov thickness", Min = 1, Max = 6, Default = 2, Rounding = 0,
        Callback = function(v) ELI.aimbot.fov_thickness = v end })

    AimL:AddSlider("AimbotRotSpeed", { Text = "fov rotation speed", Min = 0, Max = 360, Default = 90, Rounding = 0,
        Callback = function(v) ELI.aimbot.fov_rotation_speed = v end })

    AimL:AddToggle("AimbotFollowTarget", { Text = "follow target", Default = false,
        Callback = function(v) ELI.aimbot.follow_target = v end })

    AimL:AddToggle("AimbotFollowGunpoint", { Text = "follow gunpoint", Default = false,
        Callback = function(v) ELI.aimbot.follow_gunpoint = v end })

    AimL:AddToggle("AimbotClosestPart", { Text = "closest part", Default = false,
        Callback = function(v) ELI.aimbot.closest_part = v end })

    -- Triggerbot
    AimL:AddDivider()
    AimL:AddLabel("triggerbot")

    AimL:AddToggle("TriggerEnable", { Text = "enable triggerbot", Default = false,
        Callback = function(v) ELI.triggerbot.enable = v end })

    AimL:AddToggle("TriggerTeamCheck", { Text = "team check", Default = false,
        Callback = function(v) ELI.triggerbot.team_check = v end })

    AimL:AddSlider("TriggerReaction", { Text = "reaction time", Min = 0, Max = 1, Default = 0.05, Rounding = 2,
        Callback = function(v) ELI.triggerbot.reaction_time = v end })

    AimL:AddSlider("TriggerDelay", { Text = "shoot delay", Min = 0, Max = 1, Default = 0.1, Rounding = 2,
        Callback = function(v) ELI.triggerbot.shoot_delay = v end })

    AimL:AddSlider("TriggerDist", { Text = "max distance", Min = 0, Max = 2000, Default = 500, Rounding = 0,
        Callback = function(v) ELI.triggerbot.max_distance = v end })

    -- Targeting (right column)
    AimR:AddDropdown("TargetPart", { Text = "target part",
        Values = {"Head","HumanoidRootPart","Torso","LeftArm","RightArm","LeftLeg","RightLeg"},
        Default = 1,
        Callback = function(v) ELI.targeting.part = v end })

    AimR:AddSlider("TargetDist", { Text = "max distance", Min = 0, Max = 2000, Default = 100, Rounding = 0,
        Callback = function(v) ELI.targeting.max_distance = v end })

    AimR:AddToggle("TargetVisibleOnly", { Text = "visible only", Default = false,
        Callback = function(v) ELI.targeting.visible_only = v end })

    AimR:AddToggle("TargetAntiKatana", { Text = "anti katana", Default = false,
        Callback = function(v) ELI.targeting.anti_katana = v end })

    AimR:AddToggle("TargetRiotShield", { Text = "riot shield targeting", Default = false,
        Callback = function(v) ELI.targeting.riot_shield = v end })

    AimR:AddToggle("TargetAutoShoot", { Text = "auto shoot", Default = false,
        Callback = function(v) ELI.targeting.auto_shoot = v end })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- RAGE TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local RageL = Tabs.Rage:AddLeftGroupbox("rage aimbot")
    local RageR = Tabs.Rage:AddRightGroupbox("guns")

    RageL:AddToggle("RageEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.rage.enable = v end })

    RageL:AddToggle("RageAuto", { Text = "auto", Default = false,
        Callback = function(v) ELI.rage.auto = v end })

    RageL:AddToggle("RageSilent", { Text = "silent aim", Default = false,
        Callback = function(v) ELI.rage.silent = v end })

    RageL:AddDropdown("RageHitpart", { Text = "hitpart",
        Values = {"HitboxHead","HitboxTorso","Head","Torso","HumanoidRootPart"},
        Default = 1,
        Callback = function(v) ELI.rage.hitpart = v end })

    RageL:AddToggle("RagePrediction", { Text = "prediction", Default = false,
        Callback = function(v) ELI.rage.prediction = v end })

    RageL:AddSlider("RagePredMult", { Text = "prediction multiplier", Min = 0.5, Max = 5, Default = 1.2, Rounding = 2,
        Callback = function(v) ELI.rage.prediction_mult = v end })

    RageL:AddSlider("RageOrbitSpeed", { Text = "orbit speed", Min = 0, Max = 50, Default = 12, Rounding = 1,
        Callback = function(v) ELI.rage.orbit_speed = v end })

    RageL:AddSlider("RageOrbitHeight", { Text = "orbit height", Min = 0, Max = 20, Default = 2, Rounding = 1,
        Callback = function(v) ELI.rage.orbit_height = v end })

    RageL:AddSlider("RageOrbitRadius", { Text = "orbit radius", Min = 0, Max = 20, Default = 0, Rounding = 1,
        Callback = function(v) ELI.rage.orbit_radius = v end })

    -- Guns
    RageR:AddToggle("GunNoMuzzle", { Text = "no muzzle flash", Default = false,
        Callback = function(v) ELI.guns.no_muzzle_flash = v end })

    RageR:AddToggle("GunNoSpread", { Text = "no spread", Default = false,
        Callback = function(v) ELI.guns.no_spread = v end })

    RageR:AddToggle("GunForceModifier", { Text = "force modifier", Default = false,
        Callback = function(v) ELI.guns.force_modifier_enable = v end })

    RageR:AddSlider("GunForceModifierVal", { Text = "modifier value", Min = -10, Max = 10, Default = 0, Rounding = 2,
        Callback = function(v) ELI.guns.force_modifier_v = v end })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- ESP TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local EspL = Tabs.ESP:AddLeftGroupbox("player esp")
    local EspR = Tabs.ESP:AddRightGroupbox("esp options")

    EspL:AddToggle("ESPEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.esp.enable = v end })

    EspL:AddToggle("ESPTeamCheck", { Text = "team check", Default = true,
        Callback = function(v) ELI.esp.team_check = v end })

    EspL:AddSlider("ESPMaxDist", { Text = "max distance", Min = 0, Max = 50000, Default = 25000, Rounding = 0,
        Callback = function(v) ELI.esp.max_dist = v end })

    -- Box
    local BoxT = EspL:AddToggle("ESPBox", { Text = "box", Default = false,
        Callback = function(v) ELI.esp.box.enable = v end })
    BoxT:AddColorPicker("ESPBoxColor", { Default = Color3.new(1,1,1),
        Callback = function(v) ELI.esp.box.color = v end })

    EspL:AddSlider("ESPBoxThickness", { Text = "box thickness", Min = 1, Max = 6, Default = 1, Rounding = 0,
        Callback = function(v) ELI.esp.box.thickness = v end })

    -- Glow
    local GlowT = EspL:AddToggle("ESPGlow", { Text = "glow", Default = false,
        Callback = function(v) ELI.esp.glow.enable = v end })
    GlowT:AddColorPicker("ESPGlowColorStart", { Default = Color3.new(1,1,1),
        Callback = function(v) ELI.esp.glow.color_start = v end })
    GlowT:AddColorPicker("ESPGlowColorEnd", { Default = Color3.new(1,1,1),
        Callback = function(v) ELI.esp.glow.color_end = v end })

    EspL:AddSlider("ESPGlowTransp", { Text = "glow transparency", Min = 0, Max = 1, Default = 1, Rounding = 2,
        Callback = function(v) ELI.esp.glow.transparency = v end })

    EspL:AddSlider("ESPGlowRot", { Text = "glow rotation", Min = 0, Max = 360, Default = 90, Rounding = 0,
        Callback = function(v) ELI.esp.glow.rotation = v end })

    EspL:AddSlider("ESPGlowSpeed", { Text = "glow speed", Min = 0, Max = 20, Default = 2, Rounding = 1,
        Callback = function(v) ELI.esp.glow.speed = v end })

    EspL:AddToggle("ESPGlowAnimated", { Text = "animated glow", Default = false,
        Callback = function(v) ELI.esp.glow.animated = v end })

    -- Fill
    local FillT = EspR:AddToggle("ESPFill", { Text = "box fill", Default = false,
        Callback = function(v) ELI.esp.filled.enable = v end })
    FillT:AddColorPicker("ESPFillColorStart", { Default = Color3.new(1,1,1),
        Callback = function(v) ELI.esp.filled.color_start = v end })
    FillT:AddColorPicker("ESPFillColorEnd", { Default = Color3.new(1,1,1),
        Callback = function(v) ELI.esp.filled.color_end = v end })

    EspR:AddSlider("ESPFillTransp", { Text = "fill transparency", Min = 0, Max = 1, Default = 0.75, Rounding = 2,
        Callback = function(v) ELI.esp.filled.transparency = v end })

    EspR:AddToggle("ESPFillHitFlash", { Text = "hit flash", Default = false,
        Callback = function(v) ELI.esp.filled.hit_flash = v end })
        :AddColorPicker("ESPFillHitColor", { Default = Color3.fromRGB(255,40,40),
            Callback = function(v) ELI.esp.filled.hit_color = v end })

    EspR:AddSlider("ESPFillHitTime", { Text = "hit flash time", Min = 0.05, Max = 2, Default = 0.3, Rounding = 2,
        Callback = function(v) ELI.esp.filled.hit_time = v end })

    -- Visible check highlight
    EspR:AddToggle("ESPVisible", { Text = "visible check", Default = false,
        Callback = function(v) ELI.esp.visible.enable = v end })
        :AddColorPicker("ESPVisibleColor", { Default = Color3.fromRGB(60,255,90),
            Callback = function(v) ELI.esp.visible.color = v end })

    -- Highlight
    local HiT = EspR:AddToggle("ESPHighlight", { Text = "highlight", Default = false,
        Callback = function(v) ELI.esp.highlight.enable = v end })
    HiT:AddColorPicker("ESPHighFill", { Default = Color3.fromRGB(120,81,166),
        Callback = function(v) ELI.esp.highlight.fill_color = v end })
    HiT:AddColorPicker("ESPHighOutline", { Default = Color3.fromRGB(255,255,255),
        Callback = function(v) ELI.esp.highlight.outline_color = v end })

    EspR:AddSlider("ESPHighFillTransp", { Text = "highlight fill transparency", Min = 0, Max = 1, Default = 0.55, Rounding = 2,
        Callback = function(v) ELI.esp.highlight.fill_transparency = v end })

    -- Health
    EspR:AddToggle("ESPHealth", { Text = "healthbar", Default = false,
        Callback = function(v) ELI.esp.health.enable = v end })

    EspR:AddSlider("ESPHealthWidth", { Text = "healthbar width", Min = 1, Max = 10, Default = 3, Rounding = 0,
        Callback = function(v) ELI.esp.health.width = v end })

    -- Text
    EspL:AddDivider()
    EspL:AddLabel("text options")

    EspL:AddToggle("ESPName", { Text = "name", Default = false,
        Callback = function(v) ELI.esp.text.name.enable = v end })
        :AddColorPicker("ESPNameColor", { Default = Color3.new(1,1,1),
            Callback = function(v) ELI.esp.text.name.color = v end })

    EspL:AddToggle("ESPStuds", { Text = "distance", Default = false,
        Callback = function(v) ELI.esp.text.studs.enable = v end })
        :AddColorPicker("ESPStudsColor", { Default = Color3.new(1,1,1),
            Callback = function(v) ELI.esp.text.studs.color = v end })

    EspL:AddToggle("ESPTool", { Text = "weapon label", Default = false,
        Callback = function(v) ELI.esp.text.tool.enable = v end })
        :AddColorPicker("ESPToolColor", { Default = Color3.new(1,1,1),
            Callback = function(v) ELI.esp.text.tool.color = v end })

    EspL:AddSlider("ESPTextSize", { Text = "text size", Min = 6, Max = 24, Default = 9, Rounding = 0,
        Callback = function(v) ELI.esp.text.size = v end })

    EspL:AddToggle("ESPTextGradient", { Text = "text gradient", Default = false,
        Callback = function(v) ELI.esp.text.gradient = v end })

    EspL:AddToggle("ESPTextFlow", { Text = "text flow animation", Default = false,
        Callback = function(v) ELI.esp.text.flow = v end })

    EspL:AddSlider("ESPTextFlowSpeed", { Text = "flow speed", Min = 0.1, Max = 10, Default = 1, Rounding = 1,
        Callback = function(v) ELI.esp.text.flow_speed = v end })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- VISUALS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local VLeft  = Tabs.Visuals:AddLeftGroupbox("visual effects")
    local VRight = Tabs.Visuals:AddRightGroupbox("viewmodel")

    -- Damage numbers
    VLeft:AddToggle("DmgNumEnable", { Text = "damage numbers", Default = false,
        Callback = function(v) ELI.damage_numbers.enable = v end })

    VLeft:AddToggle("DmgNumRemove", { Text = "remove in-game numbers", Default = false,
        Callback = function(v) ELI.damage_numbers.remove_ingame = v end })

    VLeft:AddDropdown("DmgNumColorType", { Text = "color type",
        Values = {"Gradient","Solid"}, Default = 1,
        Callback = function(v) ELI.damage_numbers.color_type = v end })

    VLeft:AddColorPicker("DmgNumColor1", { Text = "color 1", Default = Color3.fromRGB(255,80,80),
        Callback = function(v) ELI.damage_numbers.color1 = v end })

    VLeft:AddColorPicker("DmgNumColor2", { Text = "color 2", Default = Color3.fromRGB(255,210,90),
        Callback = function(v) ELI.damage_numbers.color2 = v end })

    VLeft:AddSlider("DmgNumDuration", { Text = "duration", Min = 0.1, Max = 5, Default = 0.8, Rounding = 1,
        Callback = function(v) ELI.damage_numbers.duration = v end })

    VLeft:AddSlider("DmgNumRise", { Text = "rise amount", Min = 0, Max = 150, Default = 42, Rounding = 0,
        Callback = function(v) ELI.damage_numbers.rise = v end })

    VLeft:AddSlider("DmgNumSize", { Text = "text size", Min = 8, Max = 48, Default = 18, Rounding = 0,
        Callback = function(v) ELI.damage_numbers.text_size = v end })

    -- Death effects
    VLeft:AddDivider()
    VLeft:AddLabel("death effects")

    VLeft:AddToggle("DeathEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.death_effects.enable = v end })

    VLeft:AddDropdown("DeathType", { Text = "type",
        Values = {"Explosion","Firework","Sparkle","Shatter","Vortex"}, Default = 1,
        Callback = function(v) ELI.death_effects.type = v end })
        :AddColorPicker("DeathColor", { Default = Color3.fromRGB(120,81,166),
            Callback = function(v) ELI.death_effects.color = v end })

    -- Trajectory
    VLeft:AddDivider()
    VLeft:AddLabel("trajectory")

    VLeft:AddToggle("TrajEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.trajectory.enable = v end })

    VLeft:AddToggle("TrajAllWeapons", { Text = "all weapons", Default = false,
        Callback = function(v) ELI.trajectory.all_weapons = v end })

    VLeft:AddSlider("TrajSpeed", { Text = "speed", Min = 0, Max = 500, Default = 90, Rounding = 0,
        Callback = function(v) ELI.trajectory.speed = v end })

    VLeft:AddSlider("TrajArcUp", { Text = "arc up", Min = 0, Max = 100, Default = 10, Rounding = 0,
        Callback = function(v) ELI.trajectory.arc_up = v end })

    VLeft:AddColorPicker("TrajColor", { Text = "color", Default = Color3.fromRGB(120,81,166),
        Callback = function(v) ELI.trajectory.color = v end })

    -- Bullet tracers
    VLeft:AddDivider()
    VLeft:AddLabel("bullet tracers")

    VLeft:AddToggle("TracersEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.bullet_tracers.enable = v end })
        :AddColorPicker("TracersColorStart", { Default = Color3.fromRGB(255,255,255),
            Callback = function(v) ELI.bullet_tracers.color_start = v end })
        :AddColorPicker("TracersColorEnd", { Default = Color3.fromRGB(255,255,255),
            Callback = function(v) ELI.bullet_tracers.color_end = v end })

    VLeft:AddDropdown("TracersTexture", { Text = "texture",
        Values = {"lightning","sparkle","beam","smoke"}, Default = 1,
        Callback = function(v) ELI.bullet_tracers.texture = v end })

    VLeft:AddSlider("TracersSpeed", { Text = "speed", Min = 0, Max = 20, Default = 3, Rounding = 1,
        Callback = function(v) ELI.bullet_tracers.speed = v end })

    VLeft:AddSlider("TracersLifetime", { Text = "lifetime", Min = 0.1, Max = 10, Default = 1.5, Rounding = 1,
        Callback = function(v) ELI.bullet_tracers.life_time = v end })

    VLeft:AddSlider("TracersGlow", { Text = "glow", Min = 0, Max = 20, Default = 4, Rounding = 1,
        Callback = function(v) ELI.bullet_tracers.glow = v end })

    VLeft:AddSlider("TracersWidth0", { Text = "width start", Min = 0.01, Max = 5, Default = 0.35, Rounding = 2,
        Callback = function(v) ELI.bullet_tracers.width0 = v end })

    VLeft:AddSlider("TracersWidth1", { Text = "width end", Min = 0.01, Max = 5, Default = 0.15, Rounding = 2,
        Callback = function(v) ELI.bullet_tracers.width1 = v end })

    VLeft:AddToggle("TracersCurve", { Text = "curve around walls", Default = false,
        Callback = function(v) ELI.bullet_tracers.curve_around = v end })

    VLeft:AddToggle("TracersThroughWalls", { Text = "through walls", Default = false,
        Callback = function(v) ELI.bullet_tracers.through_walls = v end })

    VLeft:AddToggle("TracersSpring", { Text = "spring expand", Default = false,
        Callback = function(v) ELI.bullet_tracers.spring_expand = v end })

    -- Custom hit sounds / effects
    VLeft:AddDivider()
    VLeft:AddLabel("hit effects")

    VLeft:AddToggle("HitSoundEnable", { Text = "custom hitsound", Default = false,
        Callback = function(v) ELI.custom_hitsounds.enable = v end })

    VLeft:AddToggle("HitSoundRemove", { Text = "remove default hitsound", Default = false,
        Callback = function(v) ELI.custom_hitsounds.remove_default_hitsound = v end })

    VLeft:AddSlider("HitSoundVolume", { Text = "volume", Min = 0, Max = 10, Default = 3, Rounding = 1,
        Callback = function(v) ELI.custom_hitsounds.volume = v end })

    VLeft:AddSlider("HitSoundPitch", { Text = "pitch", Min = 0.1, Max = 5, Default = 1, Rounding = 2,
        Callback = function(v) ELI.custom_hitsounds.pitch = v end })

    VLeft:AddToggle("HitEffectEnable", { Text = "custom hit effect", Default = false,
        Callback = function(v) ELI.custom_hiteffects.enable = v end })
        :AddColorPicker("HitEffectColor", { Default = Color3.fromRGB(255,0,0),
            Callback = function(v) ELI.custom_hiteffects.color = v end })

    -- Hit notify
    VLeft:AddDivider()
    VLeft:AddLabel("hit notify")

    VLeft:AddToggle("HitNotifyEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.hit_notify.enable = v end })

    VLeft:AddSlider("HitNotifyDuration", { Text = "duration", Min = 0.5, Max = 10, Default = 3, Rounding = 1,
        Callback = function(v) ELI.hit_notify.duration = v end })

    VLeft:AddInput("HitNotifyMsg", { Text = "message", Default = "Hit {target} for {damage}", Placeholder = "Hit {target} for {damage}",
        Callback = function(v) ELI.hit_notify.msg = v end })

    -- Viewmodel (right col)
    VRight:AddLabel("viewmodel chams")

    local WChamsT = VRight:AddToggle("WChamsEnable", { Text = "weapon chams", Default = false,
        Callback = function(v) ELI.viewmodel_chams.weapon_chams.enable = v end })
    WChamsT:AddColorPicker("WChamsColor", { Default = Color3.fromRGB(255,255,255),
        Callback = function(v) ELI.viewmodel_chams.weapon_chams.color = v end })

    VRight:AddDropdown("WChamsMaterial", { Text = "weapon material",
        Values = {"Neon","ForceField","Glass","Metal","Wood","SmoothPlastic"}, Default = 1,
        Callback = function(v) ELI.viewmodel_chams.weapon_chams.material = v end })

    VRight:AddSlider("WChamsTransp", { Text = "weapon transparency", Min = 0, Max = 1, Default = 0, Rounding = 2,
        Callback = function(v) ELI.viewmodel_chams.weapon_chams.transparency = v end })

    VRight:AddDivider()

    local AChamsT = VRight:AddToggle("AChamsEnable", { Text = "arm chams", Default = false,
        Callback = function(v) ELI.viewmodel_chams.arm_chams.enable = v end })
    AChamsT:AddColorPicker("AChamsColor", { Default = Color3.fromRGB(255,255,255),
        Callback = function(v) ELI.viewmodel_chams.arm_chams.color = v end })

    VRight:AddDropdown("AChamsMaterial", { Text = "arm material",
        Values = {"Neon","ForceField","Glass","Metal","Wood","SmoothPlastic"}, Default = 1,
        Callback = function(v) ELI.viewmodel_chams.arm_chams.material = v end })

    VRight:AddSlider("AChamsTransp", { Text = "arm transparency", Min = 0, Max = 1, Default = 0, Rounding = 2,
        Callback = function(v) ELI.viewmodel_chams.arm_chams.transparency = v end })

    VRight:AddToggle("AChamsInvisible", { Text = "invisible arms", Default = false,
        Callback = function(v) ELI.viewmodel_chams.arm_chams.invisible = v end })

    VRight:AddDivider()

    local WHiT = VRight:AddToggle("WHiEnable", { Text = "weapon highlight", Default = false,
        Callback = function(v) ELI.viewmodel_chams.weapon_highlight.enable = v end })
    WHiT:AddColorPicker("WHiFillColor", { Default = Color3.fromRGB(255,255,255),
        Callback = function(v) ELI.viewmodel_chams.weapon_highlight.color = v end })
    WHiT:AddColorPicker("WHiOutlineColor", { Default = Color3.fromRGB(255,255,255),
        Callback = function(v) ELI.viewmodel_chams.weapon_highlight.outline_color = v end })

    VRight:AddDivider()
    VRight:AddLabel("viewmodel offset")

    VRight:AddToggle("VMOffsetEnable", { Text = "viewmodel override", Default = false,
        Callback = function(v) ELI.viewmodel_offsets.enable = v end })

    VRight:AddSlider("VMOffsetX", { Text = "x", Min = -5, Max = 5, Default = 0, Rounding = 2,
        Callback = function(v) ELI.viewmodel_offsets.x = v end })

    VRight:AddSlider("VMOffsetY", { Text = "y", Min = -5, Max = 5, Default = 0, Rounding = 2,
        Callback = function(v) ELI.viewmodel_offsets.y = v end })

    VRight:AddSlider("VMOffsetZ", { Text = "z", Min = -5, Max = 5, Default = 0, Rounding = 2,
        Callback = function(v) ELI.viewmodel_offsets.z = v end })

    -- Motion blur / stretched res / FOV changer
    VRight:AddDivider()
    VRight:AddLabel("camera")

    VRight:AddToggle("FOVEnable", { Text = "fov changer", Default = false,
        Callback = function(v) ELI.fov_changer.enable = v end })

    VRight:AddSlider("FOVValue", { Text = "fov", Min = 1, Max = 120, Default = 80, Rounding = 0,
        Callback = function(v) ELI.fov_changer.fov = v end })

    VRight:AddToggle("StretchedResEnable", { Text = "stretched res", Default = false,
        Callback = function(v) ELI.stretched_res.enable = v end })

    VRight:AddSlider("StretchedResAmt", { Text = "stretch amount", Min = 0.01, Max = 2, Default = 0.20, Rounding = 2,
        Callback = function(v) ELI.stretched_res.stretched_res_amount = v end })

    VRight:AddToggle("MotionBlurEnable", { Text = "motion blur", Default = false,
        Callback = function(v) ELI.motion_blur.enable = v end })

    VRight:AddSlider("MotionBlurIntensity", { Text = "intensity", Min = 0, Max = 2, Default = 0.5, Rounding = 2,
        Callback = function(v) ELI.motion_blur.intensity = v end })

    VRight:AddSlider("MotionBlurSens", { Text = "sensitivity", Min = 0, Max = 5, Default = 1, Rounding = 2,
        Callback = function(v) ELI.motion_blur.sensitivity = v end })

    -- Weather
    VRight:AddDivider()
    VRight:AddLabel("weather")

    VRight:AddToggle("WeatherEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.weather.enable = v end })

    VRight:AddDropdown("WeatherType", { Text = "type",
        Values = {"snow","rain","light rain"}, Default = 1,
        Callback = function(v) ELI.weather.type = v end })
        :AddColorPicker("WeatherColor", { Default = Color3.fromRGB(255,255,255),
            Callback = function(v) ELI.weather.color = v end })

    VRight:AddSlider("WeatherRate", { Text = "rate", Min = 0, Max = 2000, Default = 100, Rounding = 0,
        Callback = function(v) ELI.weather.rate = v end })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- WORLD TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local WL = Tabs.World:AddLeftGroupbox("lighting")
    local WR = Tabs.World:AddRightGroupbox("atmosphere / post-fx")

    WL:AddToggle("FogEnable", { Text = "fog", Default = false,
        Callback = function(v) ELI.world.fog = v end })
        :AddColorPicker("FogColor", { Default = Color3.fromRGB(255,255,255),
            Callback = function(v) ELI.world.fog_color = v end })

    WL:AddSlider("FogStart", { Text = "fog start", Min = 0, Max = 5000, Default = 150, Rounding = 0,
        Callback = function(v) ELI.world.fog_start = v end })

    WL:AddSlider("FogEnd", { Text = "fog end", Min = 0, Max = 10000, Default = 550, Rounding = 0,
        Callback = function(v) ELI.world.fog_end = v end })

    WL:AddToggle("AmbientEnable", { Text = "ambient", Default = false,
        Callback = function(v) ELI.world.ambient = v end })
        :AddColorPicker("AmbientColor", { Default = Color3.fromRGB(255,255,255),
            Callback = function(v) ELI.world.ambient_color = v end })

    WL:AddToggle("ClockEnable", { Text = "time of day", Default = false,
        Callback = function(v) ELI.world.clock = v end })

    WL:AddSlider("ClockTime", { Text = "clock time", Min = 0, Max = 24, Default = 14, Rounding = 1,
        Callback = function(v) ELI.world.clock_time = v end })

    WL:AddToggle("BrightnessEnable", { Text = "brightness", Default = false,
        Callback = function(v) ELI.world.brightness = v end })

    WL:AddSlider("BrightnessLevel", { Text = "brightness level", Min = 0, Max = 10, Default = 1, Rounding = 2,
        Callback = function(v) ELI.world.brightness_level = v end })

    WL:AddToggle("ExposureEnable", { Text = "exposure compensation", Default = false,
        Callback = function(v) ELI.world.exposure = v end })

    WL:AddSlider("ExposureLevel", { Text = "exposure", Min = -5, Max = 5, Default = 0, Rounding = 2,
        Callback = function(v) ELI.world.exposure_level = v end })

    WL:AddToggle("SaturationEnable", { Text = "saturation", Default = false,
        Callback = function(v) ELI.world.saturation = v end })

    WL:AddSlider("SaturationLevel", { Text = "saturation", Min = -1, Max = 1, Default = 0, Rounding = 2,
        Callback = function(v) ELI.world.saturation_level = v end })

    WL:AddSlider("ContrastLevel", { Text = "contrast", Min = -1, Max = 1, Default = 0, Rounding = 2,
        Callback = function(v) ELI.world.contrast_level = v end })

    WL:AddToggle("GlobalShadows", { Text = "global shadows", Default = true,
        Callback = function(v) ELI.world.global_shadows = v end })

    WL:AddToggle("LightingTechEnable", { Text = "lighting technology", Default = false,
        Callback = function(v) ELI.world.lighting_technology = v end })

    WL:AddDropdown("LightingTechMode", { Text = "technology",
        Values = {"Future","ShadowMap","Compatibility","Voxel"}, Default = 1,
        Callback = function(v) ELI.world.lighting_technology_mode = v end })

    -- Atmosphere / post-fx (right)
    WR:AddToggle("AtmosphereEnable", { Text = "atmosphere", Default = false,
        Callback = function(v) ELI.world.atmosphere = v end })

    WR:AddSlider("AtmosphereGlare", { Text = "glare", Min = 0, Max = 10, Default = 1.5, Rounding = 2,
        Callback = function(v) ELI.world.atmosphere_glare = v end })

    WR:AddSlider("AtmosphereHaze", { Text = "haze", Min = 0, Max = 10, Default = 10, Rounding = 2,
        Callback = function(v) ELI.world.atmosphere_haze = v end })

    WR:AddSlider("AtmosphereOffset", { Text = "offset", Min = 0, Max = 1, Default = 0.4, Rounding = 2,
        Callback = function(v) ELI.world.atmosphere_offset = v end })

    WR:AddSlider("AtmosphereDensity", { Text = "density", Min = 0, Max = 1, Default = 0.5, Rounding = 2,
        Callback = function(v) ELI.world.atmosphere_density = v end })

    WR:AddColorPicker("AtmosphereColor", { Text = "atmosphere color", Default = Color3.fromRGB(255,255,255),
        Callback = function(v) ELI.world.atmosphere_color = v end })

    WR:AddToggle("BlurEnable", { Text = "blur", Default = false,
        Callback = function(v) ELI.world.blur = v end })

    WR:AddSlider("BlurSize", { Text = "blur size", Min = 0, Max = 56, Default = 12, Rounding = 0,
        Callback = function(v) ELI.world.blur_size = v end })

    WR:AddToggle("BloomEnable", { Text = "bloom", Default = false,
        Callback = function(v) ELI.world.bloom = v end })

    WR:AddSlider("BloomIntensity", { Text = "bloom intensity", Min = 0, Max = 5, Default = 1, Rounding = 2,
        Callback = function(v) ELI.world.bloom_intensity = v end })

    WR:AddSlider("BloomSize", { Text = "bloom size", Min = 0, Max = 56, Default = 24, Rounding = 0,
        Callback = function(v) ELI.world.bloom_size = v end })

    WR:AddSlider("BloomThreshold", { Text = "bloom threshold", Min = 0, Max = 1, Default = 0.9, Rounding = 2,
        Callback = function(v) ELI.world.bloom_threshold = v end })

    WR:AddToggle("DOFEnable", { Text = "depth of field", Default = false,
        Callback = function(v) ELI.world.depth_of_field = v end })

    WR:AddSlider("DOFFocus", { Text = "dof focus", Min = 0, Max = 150, Default = 25, Rounding = 1,
        Callback = function(v) ELI.world.dof_focus = v end })

    WR:AddSlider("DOFIntensity", { Text = "dof intensity", Min = 0, Max = 1, Default = 0.15, Rounding = 2,
        Callback = function(v) ELI.world.dof_intensity = v end })

    WR:AddToggle("SunRaysEnable", { Text = "sun rays", Default = false,
        Callback = function(v) ELI.world.sun_rays = v end })

    WR:AddSlider("SunRaysIntensity", { Text = "sun rays intensity", Min = 0, Max = 1, Default = 0.25, Rounding = 2,
        Callback = function(v) ELI.world.sun_rays_intensity = v end })

    WR:AddSlider("SunRaysSpread", { Text = "sun rays spread", Min = 0, Max = 1, Default = 1, Rounding = 2,
        Callback = function(v) ELI.world.sun_rays_spread = v end })

    -- Skybox
    WR:AddToggle("SkyboxEnable", { Text = "skybox", Default = false,
        Callback = function(v) ELI.world.skybox = v end })

    WR:AddDropdown("SkyboxSelected", { Text = "skybox preset",
        Values = {"Deep Space","Blissful","Night Sky","Sunset","Candy Land"}, Default = 1,
        Callback = function(v) ELI.world.skybox_selected = v end })

    WR:AddToggle("SkyboxRotate", { Text = "rotate skybox", Default = false,
        Callback = function(v) ELI.world.skybox_rotate = v end })

    WR:AddSlider("SkyboxRotateSpeed", { Text = "rotate speed", Min = 0, Max = 20, Default = 1, Rounding = 2,
        Callback = function(v) ELI.world.skybox_rotate_speed = v end })

    WR:AddToggle("SkyboxRemoveSun", { Text = "remove sun", Default = false,
        Callback = function(v) ELI.world.skybox_remove_sun = v end })

    WR:AddToggle("SkyboxRemoveMoon", { Text = "remove moon", Default = false,
        Callback = function(v) ELI.world.skybox_remove_moon = v end })

    WR:AddToggle("SkyboxRemoveStars", { Text = "remove stars", Default = false,
        Callback = function(v) ELI.world.skybox_remove_stars = v end })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLAYERS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local PL = Tabs.Players:AddLeftGroupbox("player list")
    local PR = Tabs.Players:AddRightGroupbox("thrower esp")

    PL:AddButton({ Text = "Refresh List", Tooltip = "Re-scan current players",
        Func = function() PlayerList:Refresh() end })

    PL:AddButton({ Text = "Destroy List", Confirm = true,
        Func = function() PlayerList:Destroy() end })

    -- Thrower ESP
    PR:AddToggle("ThrowerEnable", { Text = "enable thrower esp", Default = false,
        Callback = function(v) ELI.thrower_esp.enable = v end })

    PR:AddToggle("ThrowerName", { Text = "show name", Default = false,
        Callback = function(v) ELI.thrower_esp.name = v end })
        :AddColorPicker("ThrowerNameColor", { Default = Color3.fromRGB(255,255,255),
            Callback = function(v) ELI.thrower_esp.name_color = v end })

    PR:AddSlider("ThrowerNameSize", { Text = "name size", Min = 6, Max = 24, Default = 14, Rounding = 0,
        Callback = function(v) ELI.thrower_esp.name_size = v end })

    PR:AddToggle("ThrowerImage", { Text = "show image", Default = false,
        Callback = function(v) ELI.thrower_esp.image = v end })

    PR:AddToggle("ThrowerDist", { Text = "show distance", Default = false,
        Callback = function(v) ELI.thrower_esp.distance = v end })
        :AddColorPicker("ThrowerDistColor", { Default = Color3.fromRGB(255,255,255),
            Callback = function(v) ELI.thrower_esp.distance_color = v end })

    PR:AddSlider("ThrowerDistSize", { Text = "distance size", Min = 6, Max = 24, Default = 12, Rounding = 0,
        Callback = function(v) ELI.thrower_esp.distance_size = v end })

    PR:AddDropdown("ThrowerFont", { Text = "font",
        Values = {"ProggyTiny","GothamBold","Code","Roboto"}, Default = 1,
        Callback = function(v) ELI.thrower_esp.font = v end })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- MISC TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local ML = Tabs.Misc:AddLeftGroupbox("movement")
    local MR = Tabs.Misc:AddRightGroupbox("automation")

    ML:AddToggle("FlyEnable", { Text = "fly", Default = false,
        Callback = function(v) ELI.fly.enable = v end })

    ML:AddSlider("FlySpeed", { Text = "fly speed", Min = 1, Max = 500, Default = 50, Rounding = 0,
        Callback = function(v) ELI.fly.speed = v end })

    ML:AddToggle("WalkspeedEnable", { Text = "walkspeed multiplier", Default = false,
        Callback = function(v) ELI.walkspeed.enable = v end })

    ML:AddSlider("WalkspeedMult", { Text = "multiplier", Min = 0.1, Max = 10, Default = 1.5, Rounding = 2,
        Callback = function(v) ELI.walkspeed.multiplier = v end })

    ML:AddToggle("SlideBoostEnable", { Text = "slide boost", Default = false,
        Callback = function(v) ELI.slide_boost.enable = v end })

    ML:AddSlider("SlideBoostSpeed", { Text = "boost speed", Min = 0, Max = 300, Default = 60, Rounding = 0,
        Callback = function(v) ELI.slide_boost.speed = v end })

    ML:AddToggle("AutoSlideEnable", { Text = "auto slide", Default = false,
        Callback = function(v) ELI.auto_slide.enable = v end })

    ML:AddToggle("InfDoubleJump", { Text = "infinite double jump", Default = false,
        Callback = function(v) ELI.infinite_double_jump.enable = v end })

    ML:AddToggle("DoubleJumpHeight", { Text = "custom double jump height", Default = false,
        Callback = function(v) ELI.double_jump_height.enable = v end })

    ML:AddSlider("DoubleJumpHeightVal", { Text = "jump height", Min = 0, Max = 500, Default = 50, Rounding = 0,
        Callback = function(v) ELI.double_jump_height.height = v end })

    ML:AddToggle("ThirdPerson", { Text = "third person", Default = false,
        Callback = function(v) ELI.third_person.enable = v end })

    ML:AddDivider()
    ML:AddLabel("phase")

    ML:AddToggle("PhaseSpamEnable", { Text = "phase spam", Default = false,
        Callback = function(v) ELI.phase_spam.enable = v end })

    ML:AddSlider("PhaseShootTime", { Text = "shoot time", Min = 0, Max = 5, Default = 1, Rounding = 2,
        Callback = function(v) ELI.phase_spam.shoot_time = v end })

    ML:AddSlider("PhaseHideTime", { Text = "hide time", Min = 0, Max = 5, Default = 1, Rounding = 2,
        Callback = function(v) ELI.phase_spam.hide_time = v end })

    ML:AddToggle("PhaseHideEnable", { Text = "phase hide", Default = false,
        Callback = function(v) ELI.phase_hide.enable = v end })

    -- Automation (right col)
    MR:AddToggle("AutoQueueEnable", { Text = "auto queue", Default = false,
        Callback = function(v) ELI.auto_queue.enable = v end })

    MR:AddDropdown("AutoQueueMode", { Text = "queue mode",
        Values = {"Casual","Ranked","Duel","Custom"}, Default = 1,
        Callback = function(v) ELI.auto_queue.queue_mode = v end })

    MR:AddToggle("AutoVoteEnable", { Text = "auto vote map", Default = false,
        Callback = function(v) ELI.auto_vote_map.enable = v end })

    MR:AddInput("AutoVoteMap", { Text = "map name", Placeholder = "map name",
        Callback = function(v) ELI.auto_vote_map.map = v end })

    MR:AddToggle("AutoLoadoutEnable", { Text = "auto loadout", Default = false,
        Callback = function(v) ELI.auto_loadout.enable = v end })

    MR:AddDivider()
    MR:AddLabel("arcade server")

    MR:AddToggle("ArcadeGrabDrops", { Text = "grab drops", Default = false,
        Callback = function(v) ELI.arcade_server.grab_drops = v end })

    MR:AddToggle("ArcadeAutoRespawn", { Text = "auto respawn", Default = false,
        Callback = function(v) ELI.arcade_server.auto_respawn = v end })

    MR:AddDivider()
    MR:AddLabel("removals")

    MR:AddToggle("NoFreeze", { Text = "no freeze effect", Default = false,
        Callback = function(v) ELI.removals.no_freeze_effect = v end })

    MR:AddToggle("NoBurn", { Text = "no burn effect", Default = false,
        Callback = function(v) ELI.removals.no_burn_effect = v end })

    MR:AddToggle("NoFlash", { Text = "no flash effect", Default = false,
        Callback = function(v) ELI.removals.no_flash_effect = v end })

    MR:AddDivider()
    MR:AddLabel("sound spammer")

    MR:AddToggle("SoundSpamEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.sound_spammer.enable = v end })

    MR:AddDropdown("SoundSpamType", { Text = "type",
        Values = {"DoubleJump","Slide","Shot","Footstep"}, Default = 1,
        Callback = function(v) ELI.sound_spammer.type = v end })

    -- Animation spammer
    MR:AddDivider()
    MR:AddLabel("animation")

    MR:AddToggle("AnimEnable", { Text = "animation override", Default = false,
        Callback = function(v) ELI.animation.enable = v end })

    MR:AddInput("AnimSelect", { Text = "animation id", Placeholder = "animation name",
        Callback = function(v) ELI.animation.select_animation = v end })

    MR:AddSlider("AnimSpeed", { Text = "speed", Min = 0.1, Max = 10, Default = 2, Rounding = 2,
        Callback = function(v) ELI.animation.speed = v end })

    -- Textures / Device spoof
    MR:AddDivider()
    MR:AddLabel("textures")

    MR:AddToggle("TexturesEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.textures.enable = v end })

    MR:AddDropdown("TexturesMaterial", { Text = "material",
        Values = {"Brick","Grass","Wood","Metal","Neon","ForceField","SmoothPlastic"}, Default = 1,
        Callback = function(v) ELI.textures.material = v end })
        :AddColorPicker("TexturesColor", { Default = Color3.fromRGB(244,244,244),
            Callback = function(v) ELI.textures.color = v end })

    MR:AddToggle("TexturesViewModel", { Text = "apply to viewmodel", Default = false,
        Callback = function(v) ELI.textures.apply_to_viewmodel = v end })

    MR:AddDivider()
    MR:AddLabel("device spoof")

    MR:AddToggle("DeviceSpoofEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.device_spoof.enable = v end })

    MR:AddDropdown("DeviceSpoofType", { Text = "device type",
        Values = {"MouseKeyboard","Touch","Gamepad"}, Default = 1,
        Callback = function(v) ELI.device_spoof.type = v end })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SPOOF TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local SL = Tabs.Spoof:AddLeftGroupbox("profile spoofing")
    local SR = Tabs.Spoof:AddRightGroupbox("display spoofing")

    SL:AddToggle("LevelSpoofEnable", { Text = "spoof level", Default = false,
        Callback = function(v) ELI.spoof.level.enable = v end })

    SL:AddSlider("LevelSpoofVal", { Text = "level", Min = 1, Max = 999, Default = 9, Rounding = 0,
        Callback = function(v) ELI.spoof.level.value = v end })

    SL:AddToggle("StreakSpoofEnable", { Text = "spoof win streak", Default = false,
        Callback = function(v) ELI.spoof.streak.enable = v end })

    SL:AddSlider("StreakSpoofVal", { Text = "streak", Min = 0, Max = 999, Default = 9, Rounding = 0,
        Callback = function(v) ELI.spoof.streak.value = v end })

    SL:AddToggle("EloSpoofEnable", { Text = "spoof elo", Default = false,
        Callback = function(v) ELI.elo_spoof.enable = v end })

    SL:AddSlider("EloSpoofVal", { Text = "elo", Min = 0, Max = 200000, Default = 60000, Rounding = 0,
        Callback = function(v) ELI.elo_spoof.value = v end })

    SL:AddToggle("RankSpoofEnable", { Text = "spoof rank", Default = false,
        Callback = function(v) ELI.rank_spoof.enable = v end })

    SL:AddDropdown("RankSpoofRank", { Text = "rank",
        Values = {"Bronze","Silver","Gold","Diamond","Onyx","Nemesis","Arch Nemesis"}, Default = 7,
        Callback = function(v) ELI.rank_spoof.rank = v end })

    SL:AddToggle("NameSpoofEnable", { Text = "spoof display name", Default = false,
        Callback = function(v) ELI.name_spoof.enable = v end })

    SL:AddInput("NameSpoofDisplay", { Text = "display name", Placeholder = "display name",
        Callback = function(v) ELI.name_spoof.display = v end })

    SL:AddInput("NameSpoofUsername", { Text = "username", Placeholder = "@username",
        Callback = function(v) ELI.name_spoof.username = v end })

    SL:AddDivider()
    SL:AddLabel("player status spoof")

    SL:AddToggle("StatusSpoofEnable", { Text = "enable", Default = false,
        Callback = function(v) ELI.player_status_spoof.enable = v end })

    SL:AddDropdown("StatusSpoofSelect", { Text = "status",
        Values = {"AFK","Idle","InGame","InQueue","InLobby"}, Default = 1,
        Callback = function(v) ELI.player_status_spoof.select = v end })

    -- Display spoof (right col)
    SR:AddToggle("ProfileSpoofLocalEnable", { Text = "spoof own profile", Default = false,
        Callback = function(v) ELI.profile.spoof_local = v end })

    SR:AddInput("ProfileSpoofLocalName", { Text = "local profile name", Placeholder = "name",
        Callback = function(v) ELI.profile.spoof_local_name = v end })

    SR:AddToggle("ProfileSpoofOtherEnable", { Text = "spoof others' profiles", Default = false,
        Callback = function(v) ELI.profile.spoof_other = v end })

    SR:AddInput("ProfileSpoofOtherName", { Text = "other profile name", Placeholder = "name",
        Callback = function(v) ELI.profile.spoof_other_name = v end })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- UI SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
do
    local UIL = Tabs.UISettings:AddLeftGroupbox("widgets")
    local UIR = Tabs.UISettings:AddRightGroupbox("watermark")

    UIL:AddToggle("WidgetWatermark", { Text = "watermark", Default = true,
        Callback = function(v) pcall(function() Library:SetWatermarkVisibility(v) end) end })

    UIL:AddToggle("WidgetRadar",    { Text = "radar",        Default = false })
    UIL:AddToggle("WidgetPlayerList",{ Text = "player list", Default = false })
    UIL:AddToggle("WidgetVelocity", { Text = "velocity",     Default = false })
    UIL:AddToggle("WidgetClosestPlayer",{ Text = "closest player", Default = false })

    UIR:AddToggle("WatermarkFps",  { Text = "show fps",      Default = true })
    UIR:AddToggle("WatermarkPing", { Text = "show ping",     Default = true })
    UIR:AddToggle("WatermarkTime", { Text = "show time",     Default = true })
    UIR:AddToggle("WatermarkExecutor",{ Text = "show executor", Default = false })
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- SETTINGS TAB
-- ═══════════════════════════════════════════════════════════════════════════════
Tabs.Settings:ApplySettings()
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:ApplyToTab(Tabs.Settings)

local SettingsCustom = Tabs.Settings:AddLeftGroupbox("controls")

SettingsCustom:AddButton("Test Notification", function()
    Library:Notify({ Title = "Elisium", Description = "notification test", Time = 2 })
end)

SettingsCustom:AddButton({ Text = "Unload UI", DoubleClick = true,
    Func = function() Library:Unload() end })

-- ─── Load autoload config ────────────────────────────────────────────────────
SaveManager:LoadAutoloadConfig()

Library:OnUnload(function()
    if getgenv().GLOBAL_TROVE then pcall(function() getgenv().GLOBAL_TROVE:Destroy() end) end
    getgenv().elisium_loaded = false
    getgenv().Library = nil
end)

Library:Notify({ Title = "Elisium → XoneScriptK", Description = "Loaded!", Time = 3 })
