-- XoneScriptK + Elisium Features (Merged)
-- New UI shell kept intact. All Elisium feature callbacks wired to ELI state table.
-- Requires the game environment (Roblox executor) to run.

-- ============================================================
-- LIBRARY BOOTSTRAP
-- ============================================================
local Repository = "https://raw.githubusercontent.com/SyndromeXph/XoneScriptK-Library/refs/heads/main/"
local Library    = loadstring(game:HttpGet(Repository .. "lib.luau"))()
local SaveManager = loadstring(game:HttpGet(Repository .. "addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(Repository .. "addons/ThemeManager.lua"))()

SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()

local Toggles = Library.Toggles
local Options  = Library.Options

-- ============================================================
-- SERVICES & LOCALS
-- ============================================================
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local UserInput    = game:GetService("UserInputService")
local Lighting     = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local Camera       = workspace.CurrentCamera
local LocalPlayer  = Players.LocalPlayer

-- ============================================================
-- ELI STATE TABLE  (mirrors Elisium's internal state)
-- ============================================================
local ELI = {
    -- combat
    silent_aim = {
        enable = false, closest_part = false, visualize = false,
        show_fov = false, show_fill = false, fov_color = Color3.fromRGB(120,81,166),
        fov_color2 = Color3.new(1,1,1), fov_fill_color = Color3.fromRGB(120,81,166),
        fov_fill_color2 = Color3.new(1,1,1), fov_radius = 180, fov_fill_transparency = 0.6,
        fov_outline_transparency = 0.2, fov_thickness = 2, fov_rotation_speed = 90,
        hit_chance = 100, lerp = 0, follow_gunpoint = false, follow_target = false,
        riot_shield = false,
    },
    aimbot = {
        enable = false, follow_gunpoint = false, follow_target = false,
        closest_part = false, show_fov = false, show_fill = false,
        fov_color = Color3.fromRGB(120,81,166), fov_color2 = Color3.new(1,1,1),
        fov_fill_color = Color3.fromRGB(120,81,166), fov_fill_color2 = Color3.new(1,1,1),
        fov_radius = 180, fov_fill_transparency = 0.6, fov_outline_transparency = 0.2,
        fov_thickness = 2, fov_rotation_speed = 90, smoothing = 1, lerp = 0,
    },
    triggerbot = {
        enable = false, team_check = false, reaction_time = 0.05,
        shoot_delay = 0.1, max_distance = 2500,
    },
    guns = {
        no_muzzle_flash = false, no_spread = false,
        force_modifier_enable = false, force_modifier_v = 0,
    },
    targeting = {
        visible_only = false, auto_shoot = false,
        anti_katana = false, anti_riot_shield = false,
        part = "Head", max_distance = 100,
    },
    ragebot = {
        enable = false, ffa_mode = false,
        x = 7, y = 7, z = 7,
        prediction = true, prediction_amount = 1,
    },
    -- visuals
    target_hud = {
        enable = false, target_method = "silent aim",
        position_mode = "static", offset_x = 0, offset_y = 0, scale = 1,
    },
    disable_anims = { enable = false, select = {} },
    motion_blur   = { enable = false, intensity = 0.5, sensitivity = 1 },
    -- esp
    esp = {
        enable = false, team_check = true, max_dist = 25000,
        box = { enable = false, color = Color3.new(1,1,1), outline = Color3.new(0,0,0),
                inline = Color3.new(0,0,0), thickness = 1 },
        glow = { enable = false, color_start = Color3.new(1,1,1), color_end = Color3.new(1,1,1),
                 transparency = 1 },
        name  = { enable = false },
        studs = { enable = false },
        tool  = { enable = false, position = "right" },
        filled = { enable = false, color_start = Color3.new(1,1,1), color_end = Color3.new(1,1,1),
                   transparency = 0.75, hit_flash = false, hit_color = Color3.fromRGB(255,40,40),
                   animated = false, rotation = 90, speed = 2 },
        visible   = { enable = false, color = Color3.fromRGB(60,255,90) },
        highlight = { enable = false, fill_color = Color3.fromRGB(120,81,166),
                      outline_color = Color3.new(1,1,1), fill_transparency = 0.55,
                      outline_transparency = 0 },
        health = { enable = false, color_high = Color3.fromRGB(0,255,0),
                   color_mid = Color3.fromRGB(255,255,0), color_low = Color3.fromRGB(255,0,0),
                   width = 3, gap = 5 },
        text = { size = 9, gradient = false, gradient_color1 = Color3.fromRGB(120,81,166),
                 gradient_color2 = Color3.new(1,1,1), flow = false, flow_speed = 1,
                 name = { enable = false, color = Color3.new(1,1,1) },
                 studs = { enable = false, color = Color3.new(1,1,1) },
                 tool = { enable = false, color = Color3.new(1,1,1), position = "right" } },
    },
    thrower_esp = { enable = false, name = false, distance = false, image = false },
    -- world
    weather = { enable = false, color = Color3.new(1,1,1), type = "snow", rate = 100 },
    world = {
        atmosphere = false, atmosphere_color = Color3.new(1,1,1),
        atmosphere_decay = Color3.new(1,1,1),
        lighting_technology_mode = "Future", lighting_technology = false,
        global_shadows = true, env_diffuse = false, env_diffuse_scale = 1,
        env_specular = false, env_specular_scale = 1, outdoor_ambient = false,
        outdoor_ambient_color = Color3.fromRGB(70,70,70),
    },
    textures = {
        enable = false, material = "Plastic", color = Color3.new(1,1,1),
        apply_to_viewmodel = false,
    },
    -- camera
    third_person    = { enable = false },
    stretched_res   = { enable = false, stretched_res_amount = 0.20 },
    fov_changer     = { enable = false, fov = 80 },
    -- character
    walkspeed      = { enable = false, multiplier = 1.5 },
    fly            = { enable = false, speed = 50 },
    slide_boost    = { enable = false, speed = 60 },
    infinite_double_jump = { enable = false },
    double_jump_height   = { enable = false, height = 50 },
    auto_slide     = { enable = false },
    animation      = { enable = false, emote = "Meditate" },
    -- misc
    auto_vote_map  = { enable = false, map = "Arena" },
    device_spoof   = { enable = false, type = "MouseKeyboard" },
    sound_spammer  = { enable = false, type = "DoubleJump" },
    spoof = {
        streak = { enable = false, value = 9 },
        level  = { enable = false, value = 9 },
    },
    rank_spoof = { enable = false, rank = "Arch Nemesis" },
    elo_spoof  = { enable = false, value = 60000 },
    name_spoof = { enable = false, display = "", username = "" },
    auto_loadout = {
        enable = false,
        loadout = { primary = "", secondary = "", melee = "", utility = "" },
    },
    auto_queue = { enable = false, queue_mode = "1v1" },
    arcade_server = { grab_drops = false },
    -- optimizations
    optimizations = {
        no_particles = false, no_shadows = false,
        no_postfx = false, no_textures = false,
    },
};

-- ============================================================
-- WEATHER SYSTEM (functional)
-- ============================================================
local weatherEmitter = nil;
local weatherConn    = nil;

local function stopWeather()
    if weatherConn then weatherConn:Disconnect(); weatherConn = nil; end
    if weatherEmitter then weatherEmitter:Destroy(); weatherEmitter = nil; end
end

local function startWeather()
    stopWeather();
    local cfg = ELI.weather;
    if not cfg.enable then return end;

    local gui = Instance.new("ScreenGui");
    gui.Name = "EliWeather";
    gui.ResetOnSpawn = false;
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Global;
    gui.DisplayOrder = 9999;
    pcall(function()
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui");
    end);

    local function spawnDrop()
        local drop = Instance.new("Frame");
        drop.BackgroundColor3 = cfg.color;
        drop.BorderSizePixel  = 0;
        drop.AnchorPoint      = Vector2.new(0.5, 0);
        drop.Position         = UDim2.fromScale(math.random(), 0);

        local isSnow = cfg.type == "snow";
        local isLightRain = cfg.type == "light rain";

        local w = isSnow and math.random(3,6) or (isLightRain and 1 or 2);
        local h = isSnow and math.random(3,6) or math.random(14,22);
        drop.Size = UDim2.fromOffset(w, h);
        if isSnow then
            local corner = Instance.new("UICorner");
            corner.CornerRadius = UDim.new(1,0);
            corner.Parent = drop;
        end;
        drop.Parent = gui;

        local duration = math.random(10, 20) / 10;
        local tween = TweenService:Create(drop, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
            Position = UDim2.new(drop.Position.X.Scale + (isSnow and (math.random(-10,10)/100) or 0.02), 0, 1.05, 0);
        });
        tween:Play();
        tween.Completed:Connect(function()
            pcall(function() drop:Destroy() end);
        end);
    end;

    weatherEmitter = gui;
    local interval = 1 / (cfg.rate / 10);
    weatherConn = RunService.Heartbeat:Connect(function(dt)
        if not ELI.weather.enable then stopWeather(); return end;
        local drops = math.ceil(dt / interval);
        for _ = 1, drops do
            pcall(spawnDrop);
        end;
    end);
end;

-- ============================================================
-- WALKSPEED SYSTEM
-- ============================================================
local walkspeed_base = 16;
local walkspeed_applying = false;
local function walkspeedApply(humanoid)
    if not ELI.walkspeed.enable then return end;
    walkspeed_applying = true;
    humanoid.WalkSpeed = walkspeed_base * ELI.walkspeed.multiplier;
    walkspeed_applying = false;
end;
local function walkspeedBind(humanoid)
    walkspeed_base = humanoid.WalkSpeed;
    humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if walkspeed_applying then return end;
        walkspeed_base = humanoid.WalkSpeed;
        walkspeedApply(humanoid);
    end);
    walkspeedApply(humanoid);
end;
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character;
    local hum  = char and char:FindFirstChildOfClass("Humanoid");
    if not hum then return end;
    if ELI.walkspeed.enable then
        local desired = walkspeed_base * ELI.walkspeed.multiplier;
        if math.abs(hum.WalkSpeed - desired) > 0.05 then
            walkspeed_applying = true;
            hum.WalkSpeed = desired;
            walkspeed_applying = false;
        end;
    end;
end);
LocalPlayer.CharacterAdded:Connect(function(char)
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5);
    if hum then walkspeedBind(hum) end;
end);
if LocalPlayer.Character then
    local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid");
    if hum then walkspeedBind(hum) end;
end;

-- ============================================================
-- FLY SYSTEM
-- ============================================================
local flyConn = nil;
local function stopFly()
    if flyConn then flyConn:Disconnect(); flyConn = nil; end;
end;
local function startFly()
    stopFly();
    flyConn = RunService.Heartbeat:Connect(function(dt)
        if not ELI.fly.enable then stopFly(); return end;
        local char = LocalPlayer.Character;
        local hrp  = char and char:FindFirstChild("HumanoidRootPart");
        if not hrp then return end;
        local mv = Vector3.zero;
        if UserInput:IsKeyDown(Enum.KeyCode.W) then mv += Camera.CFrame.LookVector end;
        if UserInput:IsKeyDown(Enum.KeyCode.S) then mv -= Camera.CFrame.LookVector end;
        if UserInput:IsKeyDown(Enum.KeyCode.A) then mv -= Camera.CFrame.RightVector end;
        if UserInput:IsKeyDown(Enum.KeyCode.D) then mv += Camera.CFrame.RightVector end;
        if UserInput:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end;
        if UserInput:IsKeyDown(Enum.KeyCode.LeftShift) then mv -= Vector3.new(0,1,0) end;
        if mv.Magnitude > 0 then
            hrp.CFrame += mv.Unit * ELI.fly.speed * dt;
        end;
        hrp.AssemblyLinearVelocity  = Vector3.zero;
        hrp.AssemblyAngularVelocity = Vector3.zero;
    end);
end;

-- ============================================================
-- FOV CHANGER SYSTEM
-- ============================================================
local defaultFOV = Camera.FieldOfView;
RunService.RenderStepped:Connect(function()
    if ELI.fov_changer.enable then
        Camera.FieldOfView = ELI.fov_changer.fov;
    else
        Camera.FieldOfView = defaultFOV;
    end;
end);

-- ============================================================
-- MOTION BLUR SYSTEM
-- ============================================================
local motionBlur = Instance.new("BlurEffect");
motionBlur.Name = "EliMotionBlur";
motionBlur.Size = 0;
motionBlur.Enabled = false;
motionBlur.Parent = Lighting;
local mbLook = Camera.CFrame.LookVector;
RunService.RenderStepped:Connect(function(dt)
    local cfg = ELI.motion_blur;
    if not cfg.enable then
        if motionBlur.Enabled then motionBlur.Enabled = false; motionBlur.Size = 0; end;
        mbLook = Camera.CFrame.LookVector;
        return;
    end;
    motionBlur.Enabled = true;
    local look  = Camera.CFrame.LookVector;
    local delta = (look - mbLook).Magnitude;
    mbLook = look;
    local target = math.clamp(delta / math.max(dt, 1/240) * (cfg.sensitivity or 1) * cfg.intensity * 0.35, 0, 56 * cfg.intensity);
    motionBlur.Size = motionBlur.Size + (target - motionBlur.Size) * math.min(dt * 20, 1);
end);

-- ============================================================
-- WATERMARK
-- ============================================================
local Watermark = Library:Watermark({
    Text = "XoneScriptK | Elisium",
    Position = UDim2.fromOffset(10, 110),
    IconPosition = "left",
    IconSize = 16,
    Draggable = true,
});

-- ============================================================
-- WINDOW
-- ============================================================
local Window = Library:CreateWindow({
    Title = "XoneScriptK",
    Size  = UDim2.fromOffset(580, 580),
});

local Preview = Library:PreviewWindow({
    Title = "Preview", Width = 240, Height = 277, BindTab = "Visual"
});
Preview:PositionNextTo(Window);
Preview:SyncWithWindow(Window);

local PlayerList = Library:Playerlist({
    Title = "Players", Width = 240, Height = 276, BindTab = "Players"
});
PlayerList:PositionBelow(Preview);
PlayerList:SyncWithWindow(Window);

local KeybindList = Library:KeybindList({
    Title = "Keybinds", Width = 220, VisibilityControl = true, ShowToggleState = true
});

-- ============================================================
-- TABS
-- ============================================================
local Tabs = {
    Combat       = Window:AddTab("combat"),
    Visuals      = Window:AddTab("visuals"),
    ESP          = Window:AddTab("esp"),
    World        = Window:AddTab("world"),
    Character    = Window:AddTab("character"),
    Misc         = Window:AddTab("misc"),
    Optimizations= Window:AddTab("optimizations"),
    Settings     = Window:AddTab("settings"),
};

-- ============================================================
-- COMBAT TAB
-- ============================================================
do
    -- LEFT TABBOX: silent aim / aimbot
    local aimTabbox = Tabs.Combat:AddLeftTabbox();

    -- SILENT AIM
    local saTab = aimTabbox:AddTab("silent aim");
    saTab:AddToggle("silent_aim_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.silent_aim.enable = v; end
    }):AddKeyPicker("silent_aim_keybind", {
        Default = "None", Text = "silent aim", Mode = "Toggle",
        Callback = function(v) end;
    });
    saTab:AddToggle("closest_part_enable", {
        Text = "closest part", Default = false,
        Callback = function(v) ELI.silent_aim.closest_part = v; end
    });
    saTab:AddToggle("silent_aim_visualize", {
        Text = "visualize", Default = false,
        Callback = function(v) ELI.silent_aim.visualize = v; end
    });
    saTab:AddToggle("silent_aim_follow_gunpoint", {
        Text = "follow gunpoint", Default = false,
        Callback = function(v) ELI.silent_aim.follow_gunpoint = v; end
    });
    saTab:AddToggle("silent_aim_follow_target", {
        Text = "follow target", Default = false,
        Callback = function(v) ELI.silent_aim.follow_target = v; end
    });
    saTab:AddSlider("silent_aim_hit_chance", {
        Text = "hit chance", Default = 100, Min = 1, Max = 100, Rounding = 0,
        Callback = function(v) ELI.silent_aim.hit_chance = v; end
    });
    saTab:AddSlider("silent_aim_lerp", {
        Text = "lerp", Default = 0, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.silent_aim.lerp = v; end
    });
    saTab:AddToggle("show_fov_enable", {
        Text = "show fov", Default = false,
        Callback = function(v) ELI.silent_aim.show_fov = v; end
    }):AddColorPicker("fov_color", {
        Default = Color3.fromRGB(120,81,166), Title = "fov color",
        Callback = function(v) ELI.silent_aim.fov_color = v; end
    }):AddColorPicker("fov_color2", {
        Default = Color3.new(1,1,1), Title = "fov color 2",
        Callback = function(v) ELI.silent_aim.fov_color2 = v; end
    });
    saTab:AddSlider("silent_aim_fov_radius", {
        Text = "fov radius", Default = 180, Min = 1, Max = 600, Rounding = 0, Suffix = "px",
        Callback = function(v) ELI.silent_aim.fov_radius = v; end
    });
    saTab:AddSlider("silent_aim_fov_transparency", {
        Text = "fov transparency", Default = 0.2, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.silent_aim.fov_outline_transparency = v; end
    });
    saTab:AddSlider("silent_aim_fov_thickness", {
        Text = "thickness", Default = 2, Min = 1, Max = 10, Rounding = 0,
        Callback = function(v) ELI.silent_aim.fov_thickness = v; end
    });
    saTab:AddSlider("silent_aim_rotation_speed", {
        Text = "rotation speed", Default = 90, Min = 0, Max = 360, Rounding = 0,
        Callback = function(v) ELI.silent_aim.fov_rotation_speed = v; end
    });
    saTab:AddToggle("show_fill_enable", {
        Text = "show fill", Default = false,
        Callback = function(v) ELI.silent_aim.show_fill = v; end
    }):AddColorPicker("fill_color_primary", {
        Default = Color3.fromRGB(120,81,166), Title = "fill color",
        Callback = function(v) ELI.silent_aim.fov_fill_color = v; end
    }):AddColorPicker("fill_color_secondary", {
        Default = Color3.new(1,1,1), Title = "fill color 2",
        Callback = function(v) ELI.silent_aim.fov_fill_color2 = v; end
    });
    saTab:AddSlider("silent_aim_fill_transparency", {
        Text = "fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.silent_aim.fov_fill_transparency = v; end
    });

    -- AIMBOT
    local abTab = aimTabbox:AddTab("aimbot");
    abTab:AddToggle("aimbot_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.aimbot.enable = v; end
    }):AddKeyPicker("aimbot_keybind", {
        Default = "None", Text = "aimbot", Mode = "Hold",
        Callback = function(v) end;
    });
    abTab:AddToggle("aimbot_follow_gunpoint", {
        Text = "follow gunpoint", Default = false,
        Callback = function(v) ELI.aimbot.follow_gunpoint = v; end
    });
    abTab:AddToggle("aimbot_follow_target", {
        Text = "follow target", Default = false,
        Callback = function(v) ELI.aimbot.follow_target = v; end
    });
    abTab:AddToggle("aimbot_closest_part", {
        Text = "closest part", Default = false,
        Callback = function(v) ELI.aimbot.closest_part = v; end
    });
    abTab:AddSlider("aimbot_smoothing", {
        Text = "smoothing", Default = 1, Min = 0, Max = 1, Rounding = 2, Suffix = "s",
        Callback = function(v) ELI.aimbot.smoothing = v; end
    });
    abTab:AddSlider("aimbot_lerp", {
        Text = "lerp", Default = 0, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.aimbot.lerp = v; end
    });
    abTab:AddToggle("aimbot_show_fov_enable", {
        Text = "show fov", Default = false,
        Callback = function(v) ELI.aimbot.show_fov = v; end
    }):AddColorPicker("aimbot_fov_color", {
        Default = Color3.fromRGB(120,81,166), Title = "fov color",
        Callback = function(v) ELI.aimbot.fov_color = v; end
    }):AddColorPicker("aimbot_fov_color2", {
        Default = Color3.new(1,1,1), Title = "fov color 2",
        Callback = function(v) ELI.aimbot.fov_color2 = v; end
    });
    abTab:AddSlider("aimbot_fov_radius", {
        Text = "fov radius", Default = 180, Min = 1, Max = 600, Rounding = 0, Suffix = "px",
        Callback = function(v) ELI.aimbot.fov_radius = v; end
    });
    abTab:AddSlider("aimbot_fov_transparency", {
        Text = "fov transparency", Default = 0.2, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.aimbot.fov_outline_transparency = v; end
    });
    abTab:AddSlider("aimbot_fov_thickness", {
        Text = "thickness", Default = 2, Min = 1, Max = 10, Rounding = 0,
        Callback = function(v) ELI.aimbot.fov_thickness = v; end
    });
    abTab:AddSlider("aimbot_rotation_speed", {
        Text = "rotation speed", Default = 90, Min = 0, Max = 360, Rounding = 0,
        Callback = function(v) ELI.aimbot.fov_rotation_speed = v; end
    });
    abTab:AddToggle("aimbot_show_fill_enable", {
        Text = "show fill", Default = false,
        Callback = function(v) ELI.aimbot.show_fill = v; end
    }):AddColorPicker("aimbot_fill_color_primary", {
        Default = Color3.fromRGB(120,81,166), Title = "fill color",
        Callback = function(v) ELI.aimbot.fov_fill_color = v; end
    }):AddColorPicker("aimbot_fill_color_secondary", {
        Default = Color3.new(1,1,1), Title = "fill color 2",
        Callback = function(v) ELI.aimbot.fov_fill_color2 = v; end
    });
    abTab:AddSlider("aimbot_fill_transparency", {
        Text = "fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.aimbot.fov_fill_transparency = v; end
    });

    -- RIGHT: TRIGGERBOT
    local tbTab = Tabs.Combat:AddRightGroupbox("triggerbot");
    tbTab:AddToggle("triggerbot_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.triggerbot.enable = v; end
    }):AddKeyPicker("triggerbot_keybind", {
        Default = "None", Text = "triggerbot", Mode = "Hold",
        Callback = function(v) end;
    });
    tbTab:AddToggle("triggerbot_team_check", {
        Text = "team check", Default = false,
        Callback = function(v) ELI.triggerbot.team_check = v; end
    });
    tbTab:AddSlider("triggerbot_reaction_time", {
        Text = "reaction time", Default = 0.05, Min = 0, Max = 2, Rounding = 2, Suffix = "s",
        Callback = function(v) ELI.triggerbot.reaction_time = v; end
    });
    tbTab:AddSlider("triggerbot_shoot_delay", {
        Text = "shoot delay", Default = 0.1, Min = 0, Max = 2, Rounding = 2, Suffix = "s",
        Callback = function(v) ELI.triggerbot.shoot_delay = v; end
    });
    tbTab:AddSlider("triggerbot_max_distance", {
        Text = "max distance", Default = 2500, Min = 1, Max = 2500, Rounding = 0, Suffix = "studs",
        Callback = function(v) ELI.triggerbot.max_distance = v; end
    });

    -- RIGHT: GUNS
    local gunsTab = Tabs.Combat:AddRightGroupbox("guns");
    gunsTab:AddToggle("no_muzzle_flash_enable", {
        Text = "no muzzle flash", Default = false,
        Callback = function(v) ELI.guns.no_muzzle_flash = v; end
    });
    gunsTab:AddToggle("no_spread_enable", {
        Text = "no spread", Default = false,
        Callback = function(v) ELI.guns.no_spread = v; end
    });
    gunsTab:AddToggle("force_modifier_enable", {
        Text = "force modifier", Default = false,
        Callback = function(v) ELI.guns.force_modifier_enable = v; end
    });
    gunsTab:AddSlider("force_modifier_value", {
        Text = "modifier", Default = 0, Min = 0, Max = 1, Rounding = 2, Suffix = "x",
        Callback = function(v) ELI.guns.force_modifier_v = v; end
    });

    -- LEFT: TARGETING
    local tgtTab = Tabs.Combat:AddLeftGroupbox("targeting");
    tgtTab:AddToggle("visible_only_enable", {
        Text = "visible only", Default = false,
        Callback = function(v) ELI.targeting.visible_only = v; end
    });
    tgtTab:AddToggle("auto_shoot_enable", {
        Text = "auto shoot", Default = false,
        Callback = function(v) ELI.targeting.auto_shoot = v; end
    });
    tgtTab:AddToggle("anti_katana_enable", {
        Text = "anti katana", Default = false,
        Callback = function(v) ELI.targeting.anti_katana = v; end
    }):AddKeyPicker("anti_katana_keybind", {
        Default = "None", Text = "anti katana", Mode = "Toggle",
        Callback = function(v) end;
    });
    tgtTab:AddToggle("anti_riot_shield_enable", {
        Text = "anti riot shield", Default = false,
        Callback = function(v) ELI.targeting.anti_riot_shield = v; end
    }):AddKeyPicker("anti_riot_shield_keybind", {
        Default = "None", Text = "anti riot shield", Mode = "Toggle",
        Callback = function(v) end;
    });
    tgtTab:AddDropdown("targeting_hit_part", {
        Text = "hit part", Default = 1,
        Values = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
        Callback = function(v) ELI.targeting.part = v; end
    });
    tgtTab:AddSlider("max_distance", {
        Text = "max distance", Default = 100, Min = 100, Max = 700, Rounding = 0,
        Callback = function(v) ELI.targeting.max_distance = v; end
    });

    -- RIGHT: RAGEBOT
    local rbTab = Tabs.Combat:AddRightGroupbox("ragebot");
    rbTab:AddLabel("warning: ragebot is detected - use at your own risk", true);
    rbTab:AddToggle("ragebot_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.ragebot.enable = v; end
    });
    rbTab:AddToggle("ragebot_ffa_mode", {
        Text = "ffa mode", Default = false,
        Callback = function(v) ELI.ragebot.ffa_mode = v; end
    });
    rbTab:AddSlider("ragebot_x", {
        Text = "x offset", Default = 7, Min = 1, Max = 10, Rounding = 1,
        Callback = function(v) ELI.ragebot.x = v; end
    });
    rbTab:AddSlider("ragebot_y", {
        Text = "y offset", Default = 7, Min = 1, Max = 10, Rounding = 1,
        Callback = function(v) ELI.ragebot.y = v; end
    });
    rbTab:AddSlider("ragebot_z", {
        Text = "z offset", Default = 7, Min = 1, Max = 10, Rounding = 1,
        Callback = function(v) ELI.ragebot.z = v; end
    });
    rbTab:AddToggle("ragebot_prediction", {
        Text = "prediction", Default = true,
        Callback = function(v) ELI.ragebot.prediction = v; end
    });
    rbTab:AddSlider("ragebot_prediction_amount", {
        Text = "prediction strength", Default = 1, Min = 0, Max = 3, Rounding = 2,
        Callback = function(v) ELI.ragebot.prediction_amount = v; end
    });
end

-- ============================================================
-- VISUALS TAB
-- ============================================================
do
    -- TARGET HUD
    local hudBox = Tabs.Visuals:AddLeftGroupbox("target hud");
    hudBox:AddToggle("target_hud_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.target_hud.enable = v; end
    });
    hudBox:AddDropdown("target_hud_method", {
        Text = "target method", Default = 1, Values = { "silent aim", "aimbot" },
        Callback = function(v) ELI.target_hud.target_method = v; end
    });
    hudBox:AddDropdown("target_hud_position", {
        Text = "position", Default = 1, Values = { "static", "center", "gunpoint", "target" },
        Callback = function(v) ELI.target_hud.position_mode = v; end
    });
    hudBox:AddSlider("target_hud_offset_x", {
        Text = "offset x", Default = 0, Min = -500, Max = 500, Rounding = 0,
        Callback = function(v) ELI.target_hud.offset_x = v; end
    });
    hudBox:AddSlider("target_hud_offset_y", {
        Text = "offset y", Default = 0, Min = -500, Max = 500, Rounding = 0,
        Callback = function(v) ELI.target_hud.offset_y = v; end
    });
    hudBox:AddSlider("target_hud_scale", {
        Text = "size", Default = 1, Min = 0.5, Max = 2.5, Rounding = 2,
        Callback = function(v) ELI.target_hud.scale = v; end
    });

    -- DISABLE ANIMATIONS
    local animBox = Tabs.Visuals:AddLeftGroupbox("disable animation");
    animBox:AddToggle("disable_anims_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.disable_anims.enable = v; end
    });
    animBox:AddDropdown("disable_anims_select", {
        Text = "types", Default = {}, Multi = true,
        Values = { "bobbing","landing","sway","equip","inspect","sliding","shoot","impulse","aim","sprint","attack","charge","reload","throw" },
        Callback = function(v)
            local t = {};
            for k, val in next, v do t[#t+1] = type(k)=="number" and val or k; end;
            ELI.disable_anims.select = t;
        end
    });

    -- MOTION BLUR
    local mbBox = Tabs.Visuals:AddLeftGroupbox("motion blur");
    mbBox:AddToggle("motion_blur_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.motion_blur.enable = v; end
    });
    mbBox:AddSlider("motion_blur_intensity", {
        Text = "intensity", Default = 0.5, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.motion_blur.intensity = v; end
    });
    mbBox:AddSlider("motion_blur_sensitivity", {
        Text = "sensitivity", Default = 1, Min = 0.1, Max = 5, Rounding = 2,
        Callback = function(v) ELI.motion_blur.sensitivity = v; end
    });
end

-- ============================================================
-- ESP TAB
-- ============================================================
do
    local espBox = Tabs.ESP:AddLeftGroupbox("esp");
    espBox:AddToggle("esp_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.esp.enable = v; end
    });
    espBox:AddToggle("esp_team_check", {
        Text = "team check", Default = true,
        Callback = function(v) ELI.esp.team_check = v; end
    });

    -- BOX
    espBox:AddToggle("esp_box_enable", {
        Text = "box", Default = false,
        Callback = function(v) ELI.esp.box.enable = v; end
    }):AddColorPicker("esp_box_color", {
        Default = Color3.new(1,1,1), Title = "box color",
        Callback = function(v) ELI.esp.box.color = v; end
    }):AddColorPicker("esp_box_outline_color", {
        Default = Color3.new(0,0,0), Title = "outline",
        Callback = function(v) ELI.esp.box.outline = v; end
    }):AddColorPicker("esp_box_inline_color", {
        Default = Color3.new(0,0,0), Title = "inline",
        Callback = function(v) ELI.esp.box.inline = v; end
    });
    espBox:AddSlider("esp_box_thickness", {
        Text = "box thickness", Default = 1, Min = 1, Max = 5, Rounding = 0,
        Callback = function(v) ELI.esp.box.thickness = v; end
    });

    -- GLOW
    espBox:AddToggle("esp_glow_enable", {
        Text = "glow box", Default = false,
        Callback = function(v) ELI.esp.glow.enable = v; end
    }):AddColorPicker("esp_glow_color_start", {
        Default = Color3.new(1,1,1), Title = "glow start",
        Callback = function(v) ELI.esp.glow.color_start = v; end
    }):AddColorPicker("esp_glow_color_end", {
        Default = Color3.new(1,1,1), Title = "glow end",
        Callback = function(v) ELI.esp.glow.color_end = v; end
    });
    espBox:AddSlider("esp_glow_transparency", {
        Text = "glow transparency", Default = 1, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.esp.glow.transparency = v; end
    });

    -- NAME / DISTANCE / WEAPON
    espBox:AddToggle("esp_name_enable", {
        Text = "name", Default = false,
        Callback = function(v) ELI.esp.text.name.enable = v; end
    }):AddColorPicker("esp_name_color", {
        Default = Color3.new(1,1,1), Title = "name color",
        Callback = function(v) ELI.esp.text.name.color = v; end
    });
    espBox:AddToggle("esp_studs_enable", {
        Text = "distance", Default = false,
        Callback = function(v) ELI.esp.text.studs.enable = v; end
    }):AddColorPicker("esp_studs_color", {
        Default = Color3.new(1,1,1), Title = "distance color",
        Callback = function(v) ELI.esp.text.studs.color = v; end
    });
    espBox:AddToggle("esp_tool_enable", {
        Text = "weapon", Default = false,
        Callback = function(v) ELI.esp.text.tool.enable = v; end
    }):AddColorPicker("esp_tool_color", {
        Default = Color3.new(1,1,1), Title = "weapon color",
        Callback = function(v) ELI.esp.text.tool.color = v; end
    });
    espBox:AddDropdown("esp_tool_position", {
        Text = "weapon position", Default = 3, Values = { "top","bottom","right" },
        Callback = function(v) ELI.esp.text.tool.position = v; end
    });

    -- FILLED
    espBox:AddToggle("esp_filled_enable", {
        Text = "filled", Default = false,
        Callback = function(v) ELI.esp.filled.enable = v; end
    }):AddColorPicker("esp_filled_color_start", {
        Default = Color3.new(1,1,1), Title = "fill start",
        Callback = function(v) ELI.esp.filled.color_start = v; end
    }):AddColorPicker("esp_filled_color_end", {
        Default = Color3.new(1,1,1), Title = "fill end",
        Callback = function(v) ELI.esp.filled.color_end = v; end
    });
    espBox:AddSlider("esp_filled_transparency", {
        Text = "fill transparency", Default = 0.75, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.esp.filled.transparency = v; end
    });
    espBox:AddToggle("esp_filled_hitflash", {
        Text = "hit flash", Default = false,
        Callback = function(v) ELI.esp.filled.hit_flash = v; end
    }):AddColorPicker("esp_filled_hitcolor", {
        Default = Color3.fromRGB(255,40,40), Title = "hit color",
        Callback = function(v) ELI.esp.filled.hit_color = v; end
    });
    espBox:AddToggle("esp_filled_animated", {
        Text = "animated fill", Default = false,
        Callback = function(v) ELI.esp.filled.animated = v; end
    });
    espBox:AddSlider("esp_filled_rotation", {
        Text = "fill rotation", Default = 90, Min = 0, Max = 360, Rounding = 0,
        Callback = function(v) ELI.esp.filled.rotation = v; end
    });
    espBox:AddSlider("esp_filled_speed", {
        Text = "fill speed", Default = 2, Min = 0, Max = 10, Rounding = 1,
        Callback = function(v) ELI.esp.filled.speed = v; end
    });

    -- VISIBLE
    espBox:AddToggle("esp_visible_enable", {
        Text = "visible color", Default = false,
        Callback = function(v) ELI.esp.visible.enable = v; end
    }):AddColorPicker("esp_visible_color", {
        Default = Color3.fromRGB(60,255,90), Title = "visible color",
        Callback = function(v) ELI.esp.visible.color = v; end
    });

    -- HIGHLIGHT
    espBox:AddToggle("esp_highlight_enable", {
        Text = "highlight", Default = false,
        Callback = function(v) ELI.esp.highlight.enable = v; end
    }):AddColorPicker("esp_highlight_fill", {
        Default = Color3.fromRGB(120,81,166), Title = "fill color",
        Callback = function(v) ELI.esp.highlight.fill_color = v; end
    }):AddColorPicker("esp_highlight_outline", {
        Default = Color3.new(1,1,1), Title = "outline color",
        Callback = function(v) ELI.esp.highlight.outline_color = v; end
    });
    espBox:AddSlider("esp_highlight_fill_transparency", {
        Text = "highlight fill transparency", Default = 0.55, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.esp.highlight.fill_transparency = v; end
    });
    espBox:AddSlider("esp_highlight_outline_transparency", {
        Text = "highlight outline transparency", Default = 0, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) ELI.esp.highlight.outline_transparency = v; end
    });

    -- HEALTH BAR
    espBox:AddToggle("esp_health_enable", {
        Text = "health bar", Default = false,
        Callback = function(v) ELI.esp.health.enable = v; end
    }):AddColorPicker("esp_health_color_high", {
        Default = Color3.fromRGB(0,255,0), Title = "health top",
        Callback = function(v) ELI.esp.health.color_high = v; end
    }):AddColorPicker("esp_health_color_mid", {
        Default = Color3.fromRGB(255,255,0), Title = "health mid",
        Callback = function(v) ELI.esp.health.color_mid = v; end
    }):AddColorPicker("esp_health_color_low", {
        Default = Color3.fromRGB(255,0,0), Title = "health bot",
        Callback = function(v) ELI.esp.health.color_low = v; end
    });
    espBox:AddSlider("esp_health_width", {
        Text = "bar width", Default = 3, Min = 1, Max = 10, Rounding = 0,
        Callback = function(v) ELI.esp.health.width = v; end
    });
    espBox:AddSlider("esp_health_gap", {
        Text = "bar gap", Default = 5, Min = 1, Max = 20, Rounding = 0,
        Callback = function(v) ELI.esp.health.gap = v; end
    });

    -- TEXT
    espBox:AddSlider("esp_text_size", {
        Text = "text size", Default = 9, Min = 6, Max = 16, Rounding = 0,
        Callback = function(v) ELI.esp.text.size = v; end
    });
    espBox:AddToggle("esp_text_gradient", {
        Text = "gradient text", Default = false,
        Callback = function(v) ELI.esp.text.gradient = v; end
    }):AddColorPicker("esp_text_gradient_color1", {
        Default = Color3.fromRGB(120,81,166), Title = "color 1",
        Callback = function(v) ELI.esp.text.gradient_color1 = v; end
    }):AddColorPicker("esp_text_gradient_color2", {
        Default = Color3.new(1,1,1), Title = "color 2",
        Callback = function(v) ELI.esp.text.gradient_color2 = v; end
    });
    espBox:AddToggle("esp_text_flow", {
        Text = "flow animation", Default = false,
        Callback = function(v) ELI.esp.text.flow = v; end
    });
    espBox:AddSlider("esp_text_flow_speed", {
        Text = "flow speed", Default = 1, Min = 0.1, Max = 5, Rounding = 1,
        Callback = function(v) ELI.esp.text.flow_speed = v; end
    });
    espBox:AddSlider("esp_max_dist", {
        Text = "max distance", Default = 25000, Min = 100, Max = 25000, Rounding = 0, Suffix = "studs",
        Callback = function(v) ELI.esp.max_dist = v; end
    });

    -- THROWABLE ESP (right column)
    local throwBox = Tabs.ESP:AddRightGroupbox("throwable esp");
    throwBox:AddToggle("thrower_esp_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.thrower_esp.enable = v; end
    });
    throwBox:AddToggle("thrower_esp_name", {
        Text = "name", Default = false,
        Callback = function(v) ELI.thrower_esp.name = v; end
    });
    throwBox:AddToggle("thrower_esp_distance", {
        Text = "distance", Default = false,
        Callback = function(v) ELI.thrower_esp.distance = v; end
    });
    throwBox:AddToggle("thrower_esp_image", {
        Text = "image", Default = false,
        Callback = function(v) ELI.thrower_esp.image = v; end
    });
end

-- ============================================================
-- WORLD TAB
-- ============================================================
do
    -- WEATHER (right group)
    local weatherBox = Tabs.World:AddRightGroupbox("weather");
    weatherBox:AddToggle("weather_enabled", {
        Text = "enable", Default = false,
        Callback = function(v)
            ELI.weather.enable = v;
            if v then startWeather() else stopWeather() end;
        end
    }):AddColorPicker("weather_color", {
        Default = Color3.new(1,1,1),
        Callback = function(v)
            ELI.weather.color = v;
            if ELI.weather.enable then startWeather() end;
        end
    });
    weatherBox:AddDropdown("weather_type", {
        Text = "type", Values = { "snow","rain","light rain" }, Default = 1,
        Callback = function(v)
            ELI.weather.type = v;
            if ELI.weather.enable then startWeather() end;
        end
    });
    weatherBox:AddSlider("weather_rate", {
        Text = "rate", Default = 100, Min = 100, Max = 300, Rounding = 0,
        Callback = function(v)
            ELI.weather.rate = v;
        end
    });

    -- WORLD REMOVALS
    local removalsBox = Tabs.World:AddRightGroupbox("world removals");
    removalsBox:AddToggle("anti_flashbang_enable", {
        Text = "anti flashbang", Default = false,
        Callback = function(v)
            ELI.world.anti_flashbang = v;
            -- functional: destroy flashbang effects when they appear
            if v then
                _G._eli_flash1 = workspace.ChildAdded:Connect(function(child)
                    if child.Name == "FlashbangEffect" then
                        pcall(function() child:Destroy() end);
                    end;
                end);
                _G._eli_flash2 = LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
                    if child.Name == "FlashbangGui" then
                        pcall(function() child:Destroy() end);
                    end;
                end);
            else
                if _G._eli_flash1 then _G._eli_flash1:Disconnect(); end;
                if _G._eli_flash2 then _G._eli_flash2:Disconnect(); end;
            end;
        end
    });

    -- WORLD TEXTURES
    local texBox = Tabs.World:AddLeftGroupbox("world textures");
    texBox:AddToggle("textures_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.textures.enable = v; end
    });
    texBox:AddDropdown("textures_material", {
        Text = "material", Default = 1,
        Values = { "Plastic","Wood","Brick","Cobblestone","Concrete","Grass","Metal","Sand","Ice","Marble","Minecraft" },
        Callback = function(v) ELI.textures.material = v; end
    });
    texBox:AddColorPicker("textures_color", {
        Text = "color", Default = Color3.new(1,1,1),
        Callback = function(v) ELI.textures.color = v; end
    });
    texBox:AddToggle("textures_apply_to_viewmodel", {
        Text = "apply to viewmodel", Default = false,
        Callback = function(v) ELI.textures.apply_to_viewmodel = v; end
    });

    -- QUALITY
    local qualityBox = Tabs.World:AddLeftGroupbox("quality");
    qualityBox:AddDropdown("world_lighting_technology_mode", {
        Text = "lighting technology", Default = 4,
        Values = { "Legacy","Voxel","ShadowMap","Future" },
        Callback = function(v)
            ELI.world.lighting_technology_mode = v;
            if ELI.world.lighting_technology then
                pcall(function() Lighting.Technology = Enum.Technology[v]; end);
            end;
        end
    });
    qualityBox:AddToggle("world_lighting_technology", {
        Text = "apply lighting technology", Default = false,
        Callback = function(v)
            ELI.world.lighting_technology = v;
            pcall(function()
                if v then
                    Lighting.Technology = Enum.Technology[ELI.world.lighting_technology_mode];
                else
                    Lighting.Technology = Enum.Technology.Future;
                end;
            end);
        end
    });
    qualityBox:AddToggle("world_global_shadows", {
        Text = "global shadows", Default = true,
        Callback = function(v)
            ELI.world.global_shadows = v;
            pcall(function() Lighting.GlobalShadows = v; end);
        end
    });
    qualityBox:AddToggle("world_env_diffuse", {
        Text = "environment diffuse", Default = false,
        Callback = function(v)
            ELI.world.env_diffuse = v;
            pcall(function()
                Lighting.EnvironmentDiffuseScale = v and ELI.world.env_diffuse_scale or 1;
            end);
        end
    });
    qualityBox:AddSlider("world_env_diffuse_scale", {
        Text = "diffuse scale", Default = 1, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v)
            ELI.world.env_diffuse_scale = v;
            if ELI.world.env_diffuse then
                pcall(function() Lighting.EnvironmentDiffuseScale = v; end);
            end;
        end
    });
    qualityBox:AddToggle("world_env_specular", {
        Text = "environment specular", Default = false,
        Callback = function(v)
            ELI.world.env_specular = v;
            pcall(function()
                Lighting.EnvironmentSpecularScale = v and ELI.world.env_specular_scale or 1;
            end);
        end
    });
    qualityBox:AddSlider("world_env_specular_scale", {
        Text = "specular scale", Default = 1, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v)
            ELI.world.env_specular_scale = v;
            if ELI.world.env_specular then
                pcall(function() Lighting.EnvironmentSpecularScale = v; end);
            end;
        end
    });
    qualityBox:AddToggle("world_outdoor_ambient", {
        Text = "outdoor ambient", Default = false,
        Callback = function(v)
            ELI.world.outdoor_ambient = v;
            pcall(function()
                Lighting.OutdoorAmbient = v and ELI.world.outdoor_ambient_color or Color3.fromRGB(127,127,127);
            end);
        end
    }):AddColorPicker("world_outdoor_ambient_color", {
        Default = Color3.fromRGB(70,70,70),
        Callback = function(v)
            ELI.world.outdoor_ambient_color = v;
            if ELI.world.outdoor_ambient then
                pcall(function() Lighting.OutdoorAmbient = v; end);
            end;
        end
    });

    -- CAMERA
    local camBox = Tabs.World:AddRightGroupbox("camera");
    camBox:AddToggle("third_person_enable", {
        Text = "third person", Default = false,
        Callback = function(v)
            ELI.third_person.enable = v;
            -- basic third person: shift camera back
            if v then
                Camera.CameraType = Enum.CameraType.Custom;
            end;
        end
    }):AddKeyPicker("third_person_keybind", {
        Default = "None", Text = "third person", Mode = "Toggle",
        Callback = function(v) end;
    });
    camBox:AddToggle("stretched_res_enable", {
        Text = "stretched res", Default = false,
        Callback = function(v) ELI.stretched_res.enable = v; end
    });
    camBox:AddSlider("stretched_res_amount", {
        Text = "amount", Default = 0.20, Min = 0.1, Max = 1, Rounding = 2,
        Callback = function(v) ELI.stretched_res.stretched_res_amount = v; end
    });
    camBox:AddToggle("fov_changer_enable", {
        Text = "fov changer", Default = false,
        Callback = function(v)
            ELI.fov_changer.enable = v;
            if not v then Camera.FieldOfView = defaultFOV; end;
        end
    });
    camBox:AddSlider("fov_changer_fov", {
        Text = "fov", Default = 80, Min = 10, Max = 140, Rounding = 0,
        Callback = function(v) ELI.fov_changer.fov = v; end
    });
end

-- ============================================================
-- CHARACTER TAB
-- ============================================================
do
    -- LEFT: CHARACTER (fly, slide boost)
    local charBox = Tabs.Character:AddLeftGroupbox("character");
    charBox:AddToggle("fly_enable", {
        Text = "fly", Default = false,
        Callback = function(v)
            ELI.fly.enable = v;
            if v then startFly() else stopFly() end;
        end
    }):AddKeyPicker("fly_keybind", {
        Default = "None", Text = "fly", Mode = "Toggle",
        Callback = function(v) end;
    });
    charBox:AddSlider("fly_speed_value", {
        Text = "fly speed", Default = 50, Min = 10, Max = 200, Rounding = 1,
        Callback = function(v) ELI.fly.speed = v; end
    });
    charBox:AddToggle("slide_boost_enable2", {
        Text = "slide boost", Default = false,
        Callback = function(v) ELI.slide_boost.enable = v; end
    }):AddKeyPicker("slide_boost_keybind2", {
        Default = "None", Text = "slide boost", Mode = "Hold",
        Callback = function(v) end;
    });
    charBox:AddSlider("slide_boost_speed", {
        Text = "speed", Default = 60, Min = 1, Max = 100, Rounding = 0,
        Callback = function(v) ELI.slide_boost.speed = v; end
    });

    -- LEFT: EMOTE PLAYER
    local animBox = Tabs.Character:AddLeftGroupbox("emote player");
    animBox:AddToggle("animation_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.animation.enable = v; end
    });
    animBox:AddDropdown("animation_emote", {
        Text = "emote", Default = 1,
        Values = { "Meditate","Orbit","Floss","OJ","Kicking Feet","Take the L","Hype" },
        Callback = function(v) ELI.animation.emote = v; end
    });

    -- RIGHT: MOVEMENT
    local movBox = Tabs.Character:AddRightGroupbox("movement");
    movBox:AddToggle("walkspeed_enable", {
        Text = "walkspeed", Default = false,
        Callback = function(v) ELI.walkspeed.enable = v; end
    }):AddKeyPicker("walkspeed_keybind", {
        Default = "None", Text = "walkspeed", Mode = "Toggle",
        Callback = function(v) end;
    });
    movBox:AddSlider("walkspeed_multiplier", {
        Text = "multiplier", Default = 1.5, Min = 1, Max = 10, Rounding = 2, Suffix = "x",
        Callback = function(v) ELI.walkspeed.multiplier = v; end
    });
    movBox:AddToggle("infinite_double_jump_enable", {
        Text = "infinite double jump", Default = false,
        Callback = function(v) ELI.infinite_double_jump.enable = v; end
    }):AddKeyPicker("infinite_double_jump_keybind", {
        Default = "None", Text = "infinite double jump", Mode = "Toggle",
        Callback = function(v) end;
    });
    movBox:AddToggle("slide_boost_enable", {
        Text = "slide boost", Default = false,
        Callback = function(v) ELI.slide_boost.enable = v; end
    }):AddKeyPicker("slide_boost_keybind", {
        Default = "None", Text = "slide boost", Mode = "Hold",
        Callback = function(v) end;
    });
    movBox:AddToggle("double_jump_height_enable", {
        Text = "double jump height", Default = false,
        Callback = function(v) ELI.double_jump_height.enable = v; end
    });
    movBox:AddSlider("double_jump_height_value", {
        Text = "height", Default = 50, Min = 1, Max = 150, Rounding = 1,
        Callback = function(v) ELI.double_jump_height.height = v; end
    });
    movBox:AddToggle("auto_slide_enable", {
        Text = "auto slide", Default = false,
        Callback = function(v) ELI.auto_slide.enable = v; end
    });
end

-- ============================================================
-- MISC TAB
-- ============================================================
do
    -- LEFT TABBOX: device spoof / sound spammer
    local trollTabbox = Tabs.Misc:AddLeftTabbox();

    local deviceTab = trollTabbox:AddTab("device spoof");
    deviceTab:AddToggle("device_spoof_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.device_spoof.enable = v; end
    });
    deviceTab:AddDropdown("device_spoof_type", {
        Text = "type", Default = 2,
        Values = { "Touch","MouseKeyboard","Gamepad","VR" },
        Callback = function(v) ELI.device_spoof.type = v; end
    });

    local soundTab = trollTabbox:AddTab("sound spammer");
    soundTab:AddToggle("sound_spammer_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.sound_spammer.enable = v; end
    });
    soundTab:AddDropdown("sound_spammer_type", {
        Text = "sound type", Default = 1,
        Values = { "DoubleJump","Slide" },
        Callback = function(v) ELI.sound_spammer.type = v; end
    });

    -- LEFT TABBOX: auto loadout / auto queue
    local utilityTabbox = Tabs.Misc:AddLeftTabbox();

    local autoLoadout = utilityTabbox:AddTab("auto loadout");
    autoLoadout:AddToggle("auto_loadout_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.auto_loadout.enable = v; end
    });
    autoLoadout:AddDropdown("auto_loadout_primary", {
        Text = "primary", Default = 1, Values = { "none" },
        Callback = function(v) ELI.auto_loadout.loadout.primary = v; end
    });
    autoLoadout:AddDropdown("auto_loadout_secondary", {
        Text = "secondary", Default = 1, Values = { "none" },
        Callback = function(v) ELI.auto_loadout.loadout.secondary = v; end
    });
    autoLoadout:AddDropdown("auto_loadout_melee", {
        Text = "melee", Default = 1, Values = { "none" },
        Callback = function(v) ELI.auto_loadout.loadout.melee = v; end
    });
    autoLoadout:AddDropdown("auto_loadout_utility", {
        Text = "utility", Default = 1, Values = { "none" },
        Callback = function(v) ELI.auto_loadout.loadout.utility = v; end
    });

    local autoQueue = utilityTabbox:AddTab("auto queue");
    autoQueue:AddToggle("auto_queue_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.auto_queue.enable = v; end
    });
    autoQueue:AddDropdown("auto_queue_mode", {
        Text = "queue mode", Default = 1,
        Values = { "1v1","2v2","3v3","4v4","5v5","2v2_beginner" },
        Callback = function(v) ELI.auto_queue.queue_mode = v; end
    });

    -- RIGHT TABBOX: auto vote / spoofs
    local autoTabbox = Tabs.Misc:AddRightTabbox();

    local autoVote = autoTabbox:AddTab("auto vote map");
    autoVote:AddToggle("auto_vote_map_enable", {
        Text = "enable", Default = false,
        Callback = function(v) ELI.auto_vote_map.enable = v; end
    });
    autoVote:AddDropdown("auto_vote_map", {
        Text = "map", Default = 1,
        Values = { "Arena","Big Graveyard","Docks","Splash","Bridge","Crossroads","Big Crossroads","Big Backrooms","Battleground","Big Arena","Construction","Playground","Onyx","Graveyard","Big Splash","Big Onyx","Backrooms","Station","Dimension" },
        Callback = function(v) ELI.auto_vote_map.map = v; end
    });

    -- RIGHT TABBOX: spoofs
    local spoofTabbox = Tabs.Misc:AddRightTabbox();

    local streakSpoof = spoofTabbox:AddTab("streak");
    streakSpoof:AddToggle("streak_spoof_enable", {
        Text = "spoof", Default = false,
        Callback = function(v) ELI.spoof.streak.enable = v; end
    });
    streakSpoof:AddInput("streak_spoof_text", {
        Text = "value", Default = "9", Numeric = true,
        Callback = function(v) ELI.spoof.streak.value = tonumber(v) or 9; end
    });

    local levelSpoof = spoofTabbox:AddTab("level");
    levelSpoof:AddToggle("level_spoof_enable", {
        Text = "spoof", Default = false,
        Callback = function(v) ELI.spoof.level.enable = v; end
    });
    levelSpoof:AddInput("level_spoof_text", {
        Text = "value", Default = "9", Numeric = true,
        Callback = function(v) ELI.spoof.level.value = tonumber(v) or 9; end
    });

    local rankSpoof = spoofTabbox:AddTab("rank");
    rankSpoof:AddToggle("rank_spoof_enable", {
        Text = "spoof (not working)", Default = false,
        Callback = function(v) ELI.rank_spoof.enable = v; end
    });
    rankSpoof:AddDropdown("rank_spoof_value", {
        Text = "rank", Default = 7,
        Values = { "Bronze","Silver","Gold","Diamond","Onyx","Nemesis","Arch Nemesis" },
        Callback = function(v) ELI.rank_spoof.rank = v; end
    });

    local eloSpoof = spoofTabbox:AddTab("elo");
    eloSpoof:AddToggle("elo_spoof_enable", {
        Text = "spoof (not working)", Default = false,
        Callback = function(v) ELI.elo_spoof.enable = v; end
    });
    eloSpoof:AddInput("elo_spoof_text", {
        Text = "value", Default = "60000", Numeric = true,
        Callback = function(v) ELI.elo_spoof.value = tonumber(v) or 60000; end
    });

    local nameSpoof = spoofTabbox:AddTab("name");
    nameSpoof:AddToggle("name_spoof_enable", {
        Text = "spoof", Default = false,
        Callback = function(v) ELI.name_spoof.enable = v; end
    });
    nameSpoof:AddInput("name_spoof_display", {
        Text = "display name", Default = "", Placeholder = "display name",
        Callback = function(v) ELI.name_spoof.display = v or ""; end
    });
    nameSpoof:AddInput("name_spoof_username", {
        Text = "username", Default = "", Placeholder = "username",
        Callback = function(v) ELI.name_spoof.username = v or ""; end
    });

    -- ARCADE SERVER
    local arcadeBox = Tabs.Misc:AddRightGroupbox("arcade server");
    arcadeBox:AddToggle("grab_drops_enable", {
        Text = "grab drops", Default = false,
        Callback = function(v) ELI.arcade_server.grab_drops = v; end
    });
end

-- ============================================================
-- OPTIMIZATIONS TAB
-- ============================================================
do
    local function applyOpt(kind)
        if kind == "particles" then
            if ELI.optimizations.no_particles then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                        v.Enabled = false;
                    end;
                end;
            end;
        elseif kind == "shadows" then
            pcall(function() Lighting.GlobalShadows = not ELI.optimizations.no_shadows; end);
        elseif kind == "postfx" then
            for _, v in pairs(Lighting:GetDescendants()) do
                if v:IsA("PostEffect") then v.Enabled = not ELI.optimizations.no_postfx; end;
            end;
        end;
    end;

    local boostBox = Tabs.Optimizations:AddLeftGroupbox("fps boost");
    boostBox:AddToggle("opt_no_particles", {
        Text = "remove particles & effects", Default = false,
        Callback = function(v)
            ELI.optimizations.no_particles = v;
            applyOpt("particles");
        end
    });
    boostBox:AddToggle("opt_no_shadows", {
        Text = "disable shadows", Default = false,
        Callback = function(v)
            ELI.optimizations.no_shadows = v;
            applyOpt("shadows");
        end
    });
    boostBox:AddToggle("opt_no_postfx", {
        Text = "disable post processing", Default = false,
        Callback = function(v)
            ELI.optimizations.no_postfx = v;
            applyOpt("postfx");
        end
    });
    boostBox:AddToggle("opt_no_textures", {
        Text = "disable textures", Default = false,
        Callback = function(v)
            ELI.optimizations.no_textures = v;
            if v then
                for _, part in pairs(workspace:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function() part.Material = Enum.Material.SmoothPlastic; end);
                    end;
                end;
            end;
        end
    });
end

-- ============================================================
-- SETTINGS TAB
-- ============================================================
Tabs.Settings:ApplySettings()
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:ApplyToTab(Tabs.Settings)

local settingsCustomBox = Tabs.Settings:AddLeftGroupbox("actions");
settingsCustomBox:AddButton("Test Notification", function()
    Library:Notify({ Title = "XoneScriptK", Description = "Test notification!", Time = 3 });
end);
settingsCustomBox:AddButton({
    Text = "Unload UI", DoubleClick = true,
    Func = function()
        stopWeather();
        stopFly();
        Library:Unload();
    end
});

-- ============================================================
-- AUTOLOAD + NOTIFY
-- ============================================================
SaveManager:LoadAutoloadConfig()

Library:Notify({ Title = "XoneScriptK", Description = "Elisium features loaded!", Time = 3 });
