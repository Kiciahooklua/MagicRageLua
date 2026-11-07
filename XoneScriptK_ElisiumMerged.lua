-- XoneScriptK + Elisium Features — Merged UI
-- New UI structure preserved. All Elisium features ported in.

-- getgenv().CoincideMobile = true
-- getgenv().CoincideMobile = false

local Repository = "https://raw.githubusercontent.com/SyndromeXph/XoneScriptK-Library/refs/heads/main/"
local Library = loadstring(game:HttpGet(Repository .. "lib.luau"))()
local SaveManager = loadstring(game:HttpGet(Repository .. "addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(Repository .. "addons/ThemeManager.lua"))()

SaveManager:SetLibrary(Library)
ThemeManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()

local Toggles = Library.Toggles
local Options = Library.Options

local Watermark = Library:Watermark({
    Text = "XoneScriptK | dev",
    Position = UDim2.fromOffset(10, 110),
    IconPosition = "left",
    IconSize = 16,
    Draggable = true
})

local Window = Library:CreateWindow({
    Title = "XoneScriptK",
    Size = UDim2.fromOffset(550, 555)
})

local Preview = Library:PreviewWindow({
    Title = "Preview",
    Width = 240,
    Height = 277,
    BindTab = "Visual"
})
Preview:PositionNextTo(Window)
Preview:SyncWithWindow(Window)

local PlayerList = Library:Playerlist({
    Title = "Players",
    Width = 240,
    Height = 276,
    BindTab = "Players"
})
PlayerList:PositionBelow(Preview)
PlayerList:SyncWithWindow(Window)

local KeybindList = Library:KeybindList({
    Title = "Keybinds",
    Width = 220,
    VisibilityControl = true,
    ShowToggleState = true
})

local Tabs = {
    Legit    = Window:AddTab("legit"),
    Rage     = Window:AddTab("rage"),
    Players  = Window:AddTab("players"),
    Visuals  = Window:AddTab("visuals"),
    Misc     = Window:AddTab("misc"),
    Media    = Window:AddTab("Media"),
    Settings = Window:AddTab("Settings"),
    -- Elisium tabs ported in
    Combat      = Window:AddTab("combat"),
    ESP         = Window:AddTab("esp"),
    World       = Window:AddTab("world"),
    Character   = Window:AddTab("character"),
    Optims      = Window:AddTab("optimizations"),
    Lua         = Window:AddTab("lua"),
}

--============================================================
-- ORIGINAL LEGIT TAB (preserved from new UI)
--============================================================
local LeftBox = Tabs.Legit:AddLeftGroupbox("section")

LeftBox:AddToggle("MyToggle", {
    Text = "Toggle",
    Default = false,
    Tooltip = "A normal toggle",
    Callback = function(Value) print("MyToggle:", Value) end
})

Toggles.MyToggle:OnChanged(function(Value)
    print("MyToggle changed ->", Value)
end)

LeftBox:AddToggle("ToggleKey", { Text = "Toggle2", Default = true })
    :AddKeyPicker("ToggleKeyPicker", {
        Default = "F",
        Mode = "Toggle",
        Text = "Toggle2 key",
        Callback = function(State) print("key pressed, state:", State) end
    })

LeftBox:AddToggle("HoldAim", { Text = "Hold Aim", Default = false })
    :AddKeyPicker("HoldAimKey", { Default = "LeftShift", Mode = "Hold" })

LeftBox:AddToggle("ESPMaster", { Text = "ESP", Default = true })
    :AddColorPicker("ESPMainColor", { Default = Color3.fromRGB(255, 80, 80) })

Options.ESPMainColor:OnChanged(function(Color) print("ESP color:", Color) end)

LeftBox:AddToggle("RiskyOption", {
    Text = "Risky Option",
    Default = true,
    Risky = true,
    Tooltip = "This can get you banned"
})

LeftBox:AddDivider()
LeftBox:AddLabel("sliders / dropdowns:")

LeftBox:AddSlider("MySlider", {
    Text = "Test Slider", Min = 0, Max = 100, Default = 50, Rounding = 0,
    Tooltip = "Drag to adjust",
    Callback = function(Value) print("slider:", Value) end
})

LeftBox:AddSlider("FloatSlider", {
    Text = "Float Slider", Min = 0, Max = 1, Default = 0.5, Rounding = 2, Step = 0.05
})

LeftBox:AddDropdown("MyDropdown", {
    Text = "Dropdown",
    Values = { "Value 1", "Value 2", "Value 3" },
    Default = 1,
    Callback = function(Value) print("dropdown:", Value) end
})

LeftBox:AddDropdown("MyMultiDropdown", {
    Text = "Multi Dropdown",
    Values = { "ESP", "Tracers", "Boxes", "Names" },
    Multi = true,
    Default = { ["ESP"] = true, ["Boxes"] = true },
    Callback = function(Value) print("multi:", Value.ESP == true) end
})

LeftBox:AddInput("MyTextbox", {
    Text = "Textbox", Default = "", Placeholder = "type here...",
    Callback = function(Value) print("input:", Value) end
})

LeftBox:AddKeyPicker("AimKey", {
    Text = "Aim Key", Default = "LeftShift", Mode = "Hold",
    Tooltip = "Click to rebind, right-click to clear",
    Callback = function(State) print("aim key state:", State) end
})

LeftBox:AddKeyPicker("MenuKey", { Text = "Menu Key", Default = "Insert", Mode = "Toggle" })

LeftBox:AddColorPicker("MyColor", {
    Text = "Color", Default = Color3.fromRGB(57, 114, 236), Transparency = 0,
    Callback = function(Color) print("color:", Color) end
})

LeftBox:AddButton({ Text = "Button", Func = function() print("Button clicked") end })

local SaveLoad = LeftBox:AddButton("Save", function() print("Save") end)
SaveLoad:AddButton("Load", function() print("Load") end)

LeftBox:AddButton({ Text = "Delete", Confirm = true, Func = function() print("DELETED") end })

local RightBox = Tabs.Legit:AddRightGroupbox("section 2")
RightBox:AddLabel("Right column group")

--============================================================
-- ORIGINAL PLAYERS TAB (preserved)
--============================================================
local PlayersBox = Tabs.Players:AddLeftGroupbox("Controls")

PlayersBox:AddButton({
    Text = "Refresh List",
    Tooltip = "Manually re-scan current players",
    Func = function() PlayerList:Refresh() end
})

PlayersBox:AddButton({
    Text = "Destroy List",
    Confirm = true,
    Func = function() PlayerList:Destroy() end
})

--============================================================
-- ORIGINAL VISUALS TAB (preserved)
--============================================================
local EspBox = Tabs.Visuals:AddLeftGroupbox("ESP")

EspBox:AddToggle("ESPEnabled", { Text = "Enabled", Callback = function(S) Preview:Set("Enabled", S) end })

local BoxT = EspBox:AddToggle("ESPBox", { Text = "Box", Callback = function(S) Preview:Set("Box", S) end })
BoxT:AddColorPicker("ESPBoxColorHigh", { Default = Color3.fromRGB(255,255,255), Callback = function(C,A) Preview:Set("BoxColorHigh",C,A) end })
BoxT:AddColorPicker("ESPBoxColorLow",  { Default = Color3.fromRGB(255,255,255), Callback = function(C,A) Preview:Set("BoxColorLow",C,A) end })

local FillT = EspBox:AddToggle("ESPFill", { Text = "Box Fill", Callback = function(S) Preview:Set("Fill", S) end })
FillT:AddColorPicker("ESPFillColorHigh", { Default = Color3.fromRGB(255,255,255), Callback = function(C,A) Preview:Set("FillColorHigh",C,A) end })
FillT:AddColorPicker("ESPFillColorLow",  { Default = Color3.fromRGB(255,255,255), Callback = function(C,A) Preview:Set("FillColorLow",C,A) end })

EspBox:AddToggle("ESPGlow", { Text = "Box Glow", Callback = function(S) Preview:Set("Glow", S) end })
    :AddColorPicker("ESPGlowColor", { Default = Color3.fromRGB(255,255,255), Callback = function(C,A) Preview:Set("GlowColorHigh",C,A) end })

EspBox:AddToggle("ESPHealth",     { Text = "Healthbar",      Callback = function(S) Preview:Set("Healthbar", S) end })
EspBox:AddToggle("ESPHealthText", { Text = "Healthbar Text", Callback = function(S) Preview:Set("HealthbarText", S) end })
EspBox:AddToggle("ESPNames", { Text = "Names", Callback = function(S) Preview:Set("Name", S) end })
    :AddColorPicker("ESPNameColor", { Default = Color3.fromRGB(255,255,255), Callback = function(C) Preview:Set("NameColor", C) end })
EspBox:AddToggle("ESPDistance", { Text = "Distance", Callback = function(S) Preview:Set("Distance", S) end })
EspBox:AddToggle("ESPWeapon",   { Text = "Weapon",   Callback = function(S) Preview:Set("Weapon", S) end })
EspBox:AddToggle("ESPFlags",    { Text = "Flags",    Callback = function(S) Preview:Set("Flags", S) end })

EspBox:AddSlider("BoxRotation", {
    Text = "Box Rotation", Min = -180, Max = 180, Default = 90, Suffix = "°",
    Callback = function(V) Preview:Set("BoxRotation", V) end
})

--============================================================
-- ORIGINAL MISC TAB (preserved)
--============================================================
local MiscBox = Tabs.Misc:AddLeftGroupbox("Demo")

local DemoTabbox = MiscBox:AddTabbox()
local TMain  = DemoTabbox:AddTab("Main")
local TOther = DemoTabbox:AddTab("Other")
TMain:AddLabel("This is the first tabbox page", true)
TMain:AddToggle("TabboxToggle", { Text = "Tabbox Toggle", Callback = function(V) print("tabbox toggle:", V) end })
TOther:AddLabel("Content of the second page", true)
TOther:AddSlider("TabboxSlider", { Text = "Tabbox Slider", Min = 0, Max = 100, Default = 30 })

MiscBox:AddLabel("Loading animation (Library:CreateLoading)\nExample is at the top of the script, enabled by default.", true)

--============================================================
-- ORIGINAL MEDIA TAB (preserved)
--============================================================
local MediaBox = Tabs.Media:AddLeftGroupbox("Media")

local DemoModel = Instance.new("Part")
DemoModel.Name = "ViewportDemo"
DemoModel.Shape = Enum.PartType.Ball
DemoModel.Size = Vector3.new(2, 2, 2)
DemoModel.Color = Color3.fromRGB(128, 128, 128)
DemoModel.Material = Enum.Material.Neon

MediaBox:AddViewport("DemoViewport", {
    Object = DemoModel, Height = 180, Interactive = true, Clone = true, AutoFocus = true
})

MediaBox:AddImage("DemoImage", {
    Image = "rbxassetid://136469174415866",
    Height = 100,
    ScaleType = Enum.ScaleType.Fit,
    BackgroundTransparency = 1
})

local PlaybackBox = Tabs.Media:AddRightGroupbox("Playback")

local CustomLabel = Instance.new("TextLabel")
CustomLabel.Size = UDim2.fromScale(1, 1)
CustomLabel.Active = true
CustomLabel.BackgroundColor3 = Color3.fromRGB(21, 21, 21)
CustomLabel.BorderSizePixel = 0
CustomLabel.Text = "Custom GUI embedded with AddUIPassthrough"
CustomLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
CustomLabel.TextSize = 12
CustomLabel.Font = Enum.Font.Code

PlaybackBox:AddUIPassthrough("CustomLabel", { Instance = CustomLabel, Height = 42 })

local CustomMenu = Library:AddContextMenu(CustomLabel, UDim2.fromOffset(190, 0), function()
    return { 0, CustomLabel.AbsoluteSize.Y + 4 }
end, 1)

CustomMenu:AddLabel("Custom GUI Actions")
CustomMenu:AddButton({ Text = "Change Text", KeepOpen = true, Func = function()
    CustomLabel.Text = "Text changed by the context menu"
end })
CustomMenu:AddDivider()
CustomMenu:AddButton("Reset Text", function()
    CustomLabel.Text = "Custom GUI embedded with AddUIPassthrough"
end)
CustomMenu:Bind()

Library:OnUnload(function() DemoModel:Destroy() end)

--============================================================
-- ORIGINAL SETTINGS TAB (preserved)
--============================================================
Tabs.Settings:ApplySettings()
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:ApplyToTab(Tabs.Settings)

local CustomBox = Tabs.Settings:AddLeftGroupbox("My Section")
CustomBox:AddButton("Test Notification", function() Library:Notify("Hello there", 4) end)
CustomBox:AddButton({ Text = "My Button", Func = function() print("custom settings button") end })
CustomBox:AddButton({ Text = "Unload UI", DoubleClick = true, Func = function() Library:Unload() end })

--============================================================
-- ══ ELISIUM FEATURES ══
-- All ported below. Tabs added above in Tabs table.
--============================================================

--============================================================
-- COMBAT TAB — silent aim, aimbot, triggerbot, guns, targeting, ragebot
--============================================================
local combat_tab = Tabs.Combat

-- Left tabbox: silent aim + aimbot
local aim_tabs = combat_tab:AddLeftTabbox()

-- ── SILENT AIM ──
local silentaim_tab = aim_tabs:AddTab("silent aim")

silentaim_tab:AddToggle("silent_aim_enable", {
    Text = "enable", Default = false,
    Callback = function(v)
        if getgenv().ELI then getgenv().ELI.silent_aim.enable = v end
    end
}):AddKeyPicker("silent_aim_keybind", { Default = "...", Text = "silent aim", NoUI = false })

silentaim_tab:AddToggle("closest_part_enable", {
    Text = "closest part", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.closest_part = v end end
})

silentaim_tab:AddToggle("silent_aim_visualize", {
    Text = "visualize", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.visualize = v end end
})

silentaim_tab:AddToggle("show_fov_enable", {
    Text = "show fov", Default = false, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.show_fov = v end end
}):AddColorPicker("fov_color", {
    Title = "fov color", Default = Color3.fromRGB(120, 81, 166),
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_color = v end end
}):AddColorPicker("fov_color2", {
    Title = "fov color 2", Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_color2 = v end end
})

silentaim_tab:AddToggle("silent_aim_follow_gunpoint", {
    Text = "follow gunpoint", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.follow_gunpoint = v end end
})

silentaim_tab:AddToggle("silent_aim_follow_target", {
    Text = "follow target", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.follow_target = v end end
})

silentaim_tab:AddToggle("show_fill_enable", {
    Text = "show fill", Default = false, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.show_fill = v end end
}):AddColorPicker("fill_color_primary", {
    Title = "fill color", Default = Color3.fromRGB(120, 81, 166),
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_fill_color = v end end
}):AddColorPicker("fill_color_secondary", {
    Title = "fill color 2", Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_fill_color2 = v end end
})

silentaim_tab:AddSlider("silent_aim_fov_radius", {
    Text = "radius", Default = 180, Suffix = "px", Min = 1, Max = 600, Rounding = 0, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_radius = v end end
})

silentaim_tab:AddSlider("silent_aim_fill_transparency", {
    Text = "fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_fill_transparency = v end end
})

silentaim_tab:AddSlider("silent_aim_fov_transparency", {
    Text = "fov transparency", Default = 0.2, Min = 0, Max = 1, Rounding = 2, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_outline_transparency = v end end
})

silentaim_tab:AddSlider("silent_aim_fov_thickness", {
    Text = "thickness", Default = 2, Min = 1, Max = 10, Rounding = 0, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_thickness = v end end
})

silentaim_tab:AddSlider("silent_aim_rotation_speed", {
    Text = "rotation speed", Default = 90, Min = 0, Max = 360, Rounding = 0, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.fov_rotation_speed = v end end
})

silentaim_tab:AddSlider("silent_aim_hit_chance", {
    Text = "hit chance", Default = 100, Min = 1, Max = 100, Rounding = 0,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.hit_chance = v end end
})

silentaim_tab:AddSlider("silent_aim_lerp", {
    Text = "lerp", Default = 0, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.lerp = v end end
})

-- ── AIMBOT ──
local aimbot_tab = aim_tabs:AddTab("aimbot")

aimbot_tab:AddToggle("aimbot_enable", {
    Text = "enable", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.enable = v end end
}):AddKeyPicker("aimbot_keybind", { Default = "...", Text = "aimbot", NoUI = false })

aimbot_tab:AddToggle("aimbot_show_fov_enable", {
    Text = "show fov", Default = false, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.show_fov = v end end
}):AddColorPicker("aimbot_fov_color", {
    Title = "fov color", Default = Color3.fromRGB(120, 81, 166),
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_color = v end end
}):AddColorPicker("aimbot_fov_color2", {
    Title = "fov color 2", Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_color2 = v end end
})

aimbot_tab:AddToggle("aimbot_follow_gunpoint", {
    Text = "follow gunpoint", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.follow_gunpoint = v end end
})

aimbot_tab:AddToggle("aimbot_follow_target", {
    Text = "follow target", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.follow_target = v end end
})

aimbot_tab:AddToggle("aimbot_closest_part", {
    Text = "closest part", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.closest_part = v end end
})

aimbot_tab:AddToggle("aimbot_show_fill_enable", {
    Text = "show fill", Default = false, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.show_fill = v end end
}):AddColorPicker("aimbot_fill_color_primary", {
    Title = "fill color", Default = Color3.fromRGB(120, 81, 166),
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_fill_color = v end end
}):AddColorPicker("aimbot_fill_color_secondary", {
    Title = "fill color 2", Default = Color3.fromRGB(255, 255, 255),
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_fill_color2 = v end end
})

aimbot_tab:AddSlider("aimbot_fov_radius", {
    Text = "radius", Default = 180, Suffix = "px", Min = 1, Max = 600, Rounding = 0, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_radius = v end end
})

aimbot_tab:AddSlider("aimbot_fill_transparency", {
    Text = "fill transparency", Default = 0.6, Min = 0, Max = 1, Rounding = 2, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_fill_transparency = v end end
})

aimbot_tab:AddSlider("aimbot_fov_transparency", {
    Text = "fov transparency", Default = 0.2, Min = 0, Max = 1, Rounding = 2, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_outline_transparency = v end end
})

aimbot_tab:AddSlider("aimbot_fov_thickness", {
    Text = "thickness", Default = 2, Min = 1, Max = 10, Rounding = 0, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_thickness = v end end
})

aimbot_tab:AddSlider("aimbot_rotation_speed", {
    Text = "rotation speed", Default = 90, Min = 0, Max = 360, Rounding = 0, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.fov_rotation_speed = v end end
})

aimbot_tab:AddSlider("aimbot_smoothing", {
    Text = "smoothing", Suffix = "s", Default = 1, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.smoothing = v end end
})

aimbot_tab:AddSlider("aimbot_lerp", {
    Text = "lerp", Default = 0, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.aimbot.lerp = v end end
})

-- ── TRIGGERBOT (right groupbox) ──
local triggerbot_tab = combat_tab:AddRightGroupbox("triggerbot")

triggerbot_tab:AddToggle("triggerbot_enable", {
    Text = "enable", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.triggerbot.enable = v end end
}):AddKeyPicker("triggerbot_keybind", { Default = "...", Text = "triggerbot", NoUI = false })

triggerbot_tab:AddToggle("triggerbot_team_check", {
    Text = "team check", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.triggerbot.team_check = v end end
})

triggerbot_tab:AddSlider("triggerbot_reaction_time", {
    Text = "reaction time", Default = 0.05, Min = 0, Max = 2, Rounding = 2, Suffix = "s",
    Callback = function(v) if getgenv().ELI then getgenv().ELI.triggerbot.reaction_time = v end end
})

triggerbot_tab:AddSlider("triggerbot_shoot_delay", {
    Text = "shoot delay", Default = 0.1, Min = 0, Max = 2, Rounding = 2, Suffix = "s",
    Callback = function(v) if getgenv().ELI then getgenv().ELI.triggerbot.shoot_delay = v end end
})

triggerbot_tab:AddSlider("triggerbot_max_distance", {
    Text = "max distance", Default = 2500, Min = 1, Max = 2500, Rounding = 0, Suffix = "studs",
    Callback = function(v) if getgenv().ELI then getgenv().ELI.triggerbot.max_distance = v end end
})

-- ── GUNS (right groupbox) ──
local guns_tab = combat_tab:AddRightGroupbox("guns")

guns_tab:AddToggle("no_muzzle_flash_enable", {
    Text = "no muzzle flash", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.guns.no_muzzle_flash = v end end
})

guns_tab:AddToggle("no_spread_enable", {
    Text = "no spread", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.guns.no_spread = v end end
})

guns_tab:AddToggle("force_modifier_enable", {
    Text = "force modifier", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.guns.force_modifier_enable = v end end
})

guns_tab:AddSlider("force_modifier_value", {
    Text = "", Suffix = "x", Default = 0, Min = 0, Max = 1, Rounding = 2, Visible = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.guns.force_modifier_v = v end end
})

-- ── TARGETING (left groupbox) ──
local targeting_tab = combat_tab:AddLeftGroupbox("targeting")

targeting_tab:AddToggle("visible_only_enable", {
    Text = "visible only", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.targeting.visible_only = v end end
})

targeting_tab:AddToggle("auto_shoot_enable", {
    Text = "auto shoot", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.targeting.auto_shoot = v end end
})

targeting_tab:AddToggle("anti_katana_enable", {
    Text = "anti katana", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.targeting.anti_katana = v end end
}):AddKeyPicker("anti_katana_keybind", { Default = "...", Text = "anti katana", NoUI = false })

targeting_tab:AddToggle("anti_riot_shield_enable", {
    Text = "anti riot shield", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.silent_aim.riot_shield = v end end
}):AddKeyPicker("anti_riot_shield_keybind", { Default = "...", Text = "anti riot shield", NoUI = false })

targeting_tab:AddDropdown("targeting_hit_part", {
    Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    Default = 1, Multi = false, Text = "hit part",
    Callback = function(v) if getgenv().ELI then getgenv().ELI.targeting.part = v end end
})

targeting_tab:AddSlider("max_distance", {
    Text = "max distance", Default = 100, Min = 100, Max = 700, Rounding = 0,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.targeting.max_distance = v end end
})

--============================================================
-- RAGE TAB — ragebot
--============================================================
local ragebot_tab = Tabs.Rage:AddRightGroupbox("ragebot")
ragebot_tab:AddLabel("warning: ragebot is detected - use at your own risk", true)

ragebot_tab:AddToggle("ragebot_enable", {
    Text = "enable", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.ragebot.enable = v end end
})

ragebot_tab:AddToggle("ragebot_ffa_mode", {
    Text = "ffa mode", Default = false,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.ragebot.ffa_mode = v end end
})

ragebot_tab:AddSlider("ragebot_x", {
    Text = "x offset", Default = 7, Min = 1, Max = 10, Rounding = 1,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.ragebot.x = v end end
})

ragebot_tab:AddSlider("ragebot_y", {
    Text = "y offset", Default = 7, Min = 1, Max = 10, Rounding = 1,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.ragebot.y = v end end
})

ragebot_tab:AddSlider("ragebot_z", {
    Text = "z offset", Default = 7, Min = 1, Max = 10, Rounding = 1,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.ragebot.z = v end end
})

ragebot_tab:AddToggle("ragebot_prediction", {
    Text = "prediction", Default = true,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.ragebot.prediction = v end end
})

ragebot_tab:AddSlider("ragebot_prediction_amount", {
    Text = "prediction strength", Default = 1, Min = 0, Max = 3, Rounding = 2,
    Callback = function(v) if getgenv().ELI then getgenv().ELI.ragebot.prediction_amount = v end end
})

--============================================================
-- ESP TAB — full ESP groupbox + throwable ESP
--============================================================
local esp_groupbox = Tabs.ESP:AddLeftGroupbox("esp")

esp_groupbox:AddToggle("esp_enable", { Text = "enabled", Default = false })
esp_groupbox:AddToggle("esp_team_check", { Text = "team check", Default = false })

esp_groupbox:AddToggle("esp_box_enable", { Text = "box", Default = false })
    :AddColorPicker("esp_box_color",         { Default = Color3.fromRGB(255,255,255) })
    :AddColorPicker("esp_box_outline_color", { Default = Color3.fromRGB(0,0,0) })
    :AddColorPicker("esp_box_inline_color",  { Default = Color3.fromRGB(0,0,0) })

esp_groupbox:AddToggle("esp_glow_enable", { Text = "glow", Default = false })
    :AddColorPicker("esp_glow_color_start", { Default = Color3.fromRGB(120,81,166) })
    :AddColorPicker("esp_glow_color_end",   { Default = Color3.fromRGB(255,255,255) })

esp_groupbox:AddSlider("esp_glow_transparency", { Text = "glow transparency", Default = 0.5, Min = 0, Max = 1, Rounding = 2 })
esp_groupbox:AddSlider("esp_box_thickness",     { Text = "box thickness",     Default = 1,   Min = 1, Max = 5, Rounding = 0 })

esp_groupbox:AddToggle("esp_name_enable", { Text = "names", Default = false })
    :AddColorPicker("esp_name_color", { Default = Color3.fromRGB(255,255,255) })

esp_groupbox:AddToggle("esp_studs_enable", { Text = "distance", Default = false })
    :AddColorPicker("esp_studs_color", { Default = Color3.fromRGB(255,255,255) })

esp_groupbox:AddToggle("esp_tool_enable", { Text = "weapon", Default = false })
    :AddColorPicker("esp_tool_color", { Default = Color3.fromRGB(255,255,255) })

esp_groupbox:AddDropdown("esp_tool_position", {
    Values = {"Top", "Bottom", "Left", "Right"}, Default = 2, Text = "weapon position"
})

esp_groupbox:AddToggle("esp_filled_enable", { Text = "fill", Default = false })
    :AddColorPicker("esp_filled_color_start", { Default = Color3.fromRGB(120,81,166) })
    :AddColorPicker("esp_filled_color_end",   { Default = Color3.fromRGB(255,255,255) })

esp_groupbox:AddToggle("esp_filled_hitflash", { Text = "hit flash", Default = false })
    :AddColorPicker("esp_filled_hitcolor", { Default = Color3.fromRGB(255,0,0) })

esp_groupbox:AddToggle("esp_visible_enable", { Text = "visible check", Default = false })
    :AddColorPicker("esp_visible_color", { Default = Color3.fromRGB(0,255,0) })

esp_groupbox:AddToggle("esp_highlight_enable", { Text = "highlight", Default = false })
    :AddColorPicker("esp_highlight_fill",    { Default = Color3.fromRGB(120,81,166) })
    :AddColorPicker("esp_highlight_outline", { Default = Color3.fromRGB(255,255,255) })

esp_groupbox:AddSlider("esp_highlight_fill_transparency",    { Text = "highlight fill alpha",    Default = 0.5, Min = 0, Max = 1, Rounding = 2 })
esp_groupbox:AddSlider("esp_highlight_outline_transparency", { Text = "highlight outline alpha", Default = 0.5, Min = 0, Max = 1, Rounding = 2 })
esp_groupbox:AddSlider("esp_filled_transparency",            { Text = "fill alpha",              Default = 0.5, Min = 0, Max = 1, Rounding = 2 })

esp_groupbox:AddToggle("esp_filled_animated", { Text = "animated fill", Default = false })
esp_groupbox:AddSlider("esp_filled_rotation", { Text = "fill rotation", Default = 0,  Min = 0, Max = 360, Rounding = 0 })
esp_groupbox:AddSlider("esp_filled_speed",    { Text = "fill speed",    Default = 1,  Min = 0, Max = 10,  Rounding = 1 })

esp_groupbox:AddToggle("esp_health_enable", { Text = "healthbar", Default = false })
    :AddColorPicker("esp_health_color_high", { Default = Color3.fromRGB(0,255,0) })
    :AddColorPicker("esp_health_color_mid",  { Default = Color3.fromRGB(255,255,0) })
    :AddColorPicker("esp_health_color_low",  { Default = Color3.fromRGB(255,0,0) })

esp_groupbox:AddSlider("esp_health_width", { Text = "health bar width", Default = 2, Min = 1, Max = 6, Rounding = 0 })
esp_groupbox:AddSlider("esp_health_gap",   { Text = "health bar gap",   Default = 2, Min = 0, Max = 8, Rounding = 0 })
esp_groupbox:AddSlider("esp_text_size",    { Text = "text size",        Default = 11, Min = 8, Max = 24, Rounding = 0 })

esp_groupbox:AddToggle("esp_text_gradient", { Text = "text gradient", Default = false })
    :AddColorPicker("esp_text_gradient_color1", { Default = Color3.fromRGB(120,81,166) })
    :AddColorPicker("esp_text_gradient_color2", { Default = Color3.fromRGB(255,255,255) })

esp_groupbox:AddToggle("esp_text_flow",  { Text = "text flow", Default = false })
esp_groupbox:AddSlider("esp_text_flow_speed", { Text = "flow speed", Default = 2, Min = 0, Max = 10, Rounding = 1 })
esp_groupbox:AddSlider("esp_max_dist",   { Text = "max distance", Default = 500, Min = 50, Max = 2500, Rounding = 0, Suffix = "studs" })

-- Throwable ESP (right)
local esp_throwable_tab = Tabs.ESP:AddRightGroupbox("throwable esp")

esp_throwable_tab:AddToggle("thrower_esp_enable", { Text = "enable", Default = false })

esp_throwable_tab:AddToggle("thrower_esp_name", { Text = "name", Default = false })
    :AddColorPicker("thrower_esp_name_color", { Default = Color3.fromRGB(255,255,255) })

esp_throwable_tab:AddSlider("thrower_esp_name_size",     { Text = "name size",     Default = 11, Min = 8, Max = 24, Rounding = 0 })
esp_throwable_tab:AddToggle("thrower_esp_distance",      { Text = "distance",      Default = false })
    :AddColorPicker("thrower_esp_distance_color", { Default = Color3.fromRGB(255,255,255) })
esp_throwable_tab:AddSlider("thrower_esp_distance_size", { Text = "distance size", Default = 11, Min = 8, Max = 24, Rounding = 0 })
esp_throwable_tab:AddToggle("thrower_esp_image",         { Text = "icon",          Default = false })
esp_throwable_tab:AddDropdown("thrower_esp_select", {
    Values = {"Grenade", "Flashbang", "Smoke"}, Default = 1, Text = "type"
})
esp_throwable_tab:AddDropdown("thrower_esp_font", {
    Values = {"Gotham", "GothamBold", "Code", "Arcade", "RobotoMono"}, Default = 1, Text = "font"
})

--============================================================
-- WORLD TAB — color correction, weather, atmosphere, removals,
--             textures, shaders, quality, camera
--============================================================
local world_tab = Tabs.World
local world_main_tab = world_tab:AddLeftTabbox()

-- ── COLOR CORRECTION ──
local color_correction_tab = world_main_tab:AddTab("color correction")

color_correction_tab:AddToggle("world_fog", { Text = "fog", Default = false })
    :AddColorPicker("fog_color", { Default = Color3.fromRGB(200,200,200) })
color_correction_tab:AddSlider("fog_start", { Text = "fog start", Default = 0,    Min = 0,    Max = 10000, Rounding = 0 })
color_correction_tab:AddSlider("fog_end",   { Text = "fog end",   Default = 10000, Min = 0,    Max = 10000, Rounding = 0 })

color_correction_tab:AddToggle("world_ambient", { Text = "ambient", Default = false })
    :AddColorPicker("ambient_color", { Default = Color3.fromRGB(70,70,70) })

color_correction_tab:AddToggle("world_clock",    { Text = "time of day", Default = false })
color_correction_tab:AddSlider("clock_time",     { Text = "time",        Default = 14, Min = 0, Max = 24, Rounding = 1 })

color_correction_tab:AddToggle("world_brightness",  { Text = "brightness",  Default = false })
color_correction_tab:AddSlider("brightness_level",  { Text = "level",       Default = 1,   Min = 0, Max = 10,  Rounding = 2 })

color_correction_tab:AddToggle("world_exposure", { Text = "exposure", Default = false })
color_correction_tab:AddSlider("exposure_level", { Text = "level",    Default = 0,   Min = -5, Max = 5, Rounding = 2 })

color_correction_tab:AddToggle("world_color_shift_top", { Text = "color shift top", Default = false })
    :AddColorPicker("color_shift_top_color", { Default = Color3.fromRGB(255,255,255) })

color_correction_tab:AddToggle("world_color_shift_bottom", { Text = "color shift bottom", Default = false })
    :AddColorPicker("color_shift_bottom_color", { Default = Color3.fromRGB(0,0,0) })

color_correction_tab:AddToggle("world_skybox", { Text = "skybox", Default = false })
color_correction_tab:AddDropdown("world_skybox_selected", {
    Values = {"Dawn", "Day", "Dusk", "Night", "Neon City", "Space"}, Default = 2, Text = "skybox"
})
color_correction_tab:AddToggle("world_skybox_rotate",         { Text = "rotate skybox", Default = false })
color_correction_tab:AddSlider("world_skybox_rotate_speed",   { Text = "rotate speed",  Default = 1, Min = 0, Max = 20, Rounding = 1 })
color_correction_tab:AddDropdown("world_skybox_rotate_direction", {
    Values = {"CW", "CCW"}, Default = 1, Text = "direction"
})
color_correction_tab:AddDropdown("world_skybox_rotate_method", {
    Values = {"Pivot", "Spin"}, Default = 1, Text = "method"
})
color_correction_tab:AddToggle("world_skybox_remove_sun",   { Text = "remove sun",   Default = false })
color_correction_tab:AddToggle("world_skybox_remove_moon",  { Text = "remove moon",  Default = false })
color_correction_tab:AddToggle("world_skybox_remove_stars", { Text = "remove stars", Default = false })

-- ── ATMOSPHERE ──
local atmosphere_tab = world_main_tab:AddTab("atmosphere")

atmosphere_tab:AddToggle("world_atmosphere", { Text = "atmosphere", Default = false })
    :AddColorPicker("world_atmosphere_color", { Default = Color3.fromRGB(199,199,199) })
    :AddColorPicker("world_atmosphere_decay", { Default = Color3.fromRGB(90,90,90) })

for _, property in ipairs({"density", "offset", "glare", "haze"}) do
    atmosphere_tab:AddSlider("world_atmosphere_" .. property, {
        Text = property, Default = 0.3, Min = 0, Max = 1, Rounding = 2
    })
end

-- ── WEATHER (right groupbox) ──
local weather_tab = world_tab:AddRightGroupbox("weather")

weather_tab:AddToggle("weather_enabled", { Text = "enable", Default = false })
    :AddColorPicker("weather_color", { Default = Color3.fromRGB(200,200,200) })
weather_tab:AddDropdown("weather_type", {
    Values = {"Rain", "Snow", "Hail", "Ash"}, Default = 1, Text = "type"
})
weather_tab:AddSlider("weather_rate", { Text = "rate", Default = 50, Min = 1, Max = 500, Rounding = 0 })

-- ── WORLD REMOVALS (right groupbox) ──
local removals_tab = world_tab:AddRightGroupbox("world removals")
removals_tab:AddToggle("anti_flashbang_enable", { Text = "anti flashbang", Default = false })

-- ── WORLD TEXTURES (left groupbox) ──
local textures_tab = world_tab:AddLeftGroupbox("world textures")
textures_tab:AddToggle("textures_enable", { Text = "enable", Default = false })
textures_tab:AddDropdown("textures_material", {
    Values = {"SmoothPlastic", "Glass", "Neon", "Metal", "DiamondPlate", "Foil", "Air"},
    Default = 1, Text = "material"
})
textures_tab:AddLabel("texture color"):AddColorPicker("textures_color", { Default = Color3.fromRGB(255,255,255) })
textures_tab:AddToggle("textures_apply_to_viewmodel", { Text = "apply to viewmodel", Default = false })

-- ── SHADERS (left groupbox) ──
local shaders_tab = world_tab:AddLeftGroupbox("shaders")

shaders_tab:AddToggle("shader_blur",         { Text = "blur",   Default = false })
shaders_tab:AddSlider("shader_blur_size",    { Text = "size",   Default = 24, Min = 0, Max = 56, Rounding = 0 })

shaders_tab:AddToggle("shader_bloom",             { Text = "bloom",     Default = false })
shaders_tab:AddSlider("shader_bloom_intensity",   { Text = "intensity", Default = 1,  Min = 0, Max = 5, Rounding = 2 })
shaders_tab:AddSlider("shader_bloom_size",        { Text = "size",      Default = 24, Min = 0, Max = 56, Rounding = 0 })
shaders_tab:AddSlider("shader_bloom_threshold",   { Text = "threshold", Default = 1,  Min = 0, Max = 2, Rounding = 2 })

shaders_tab:AddToggle("shader_dof",               { Text = "depth of field", Default = false })
shaders_tab:AddSlider("shader_dof_focus",         { Text = "focus",          Default = 50, Min = 0, Max = 300, Rounding = 0 })
shaders_tab:AddSlider("shader_dof_intensity",     { Text = "intensity",      Default = 1,  Min = 0, Max = 1, Rounding = 2 })

shaders_tab:AddToggle("shader_sun_rays",          { Text = "sun rays",  Default = false })
shaders_tab:AddSlider("shader_sun_rays_intensity",{ Text = "intensity", Default = 0.25, Min = 0, Max = 1, Rounding = 2 })
shaders_tab:AddSlider("shader_sun_rays_spread",   { Text = "spread",    Default = 1,    Min = 0, Max = 1, Rounding = 2 })

shaders_tab:AddToggle("shader_saturation", { Text = "saturation / tint", Default = false })
    :AddColorPicker("shader_tint", { Default = Color3.fromRGB(255,255,255) })
shaders_tab:AddSlider("shader_saturation_level", { Text = "saturation", Default = 1,  Min = -1, Max = 2, Rounding = 2 })
shaders_tab:AddSlider("shader_contrast_level",   { Text = "contrast",   Default = 0,  Min = -1, Max = 1, Rounding = 2 })

-- ── QUALITY (left groupbox) ──
local quality_tab = world_tab:AddLeftGroupbox("quality")

quality_tab:AddDropdown("world_lighting_technology_mode", {
    Values = {"Future", "ShadowMap", "Voxel", "Compatibility"}, Default = 1, Text = "lighting tech"
})
quality_tab:AddToggle("world_lighting_technology", { Text = "force lighting tech", Default = false })
quality_tab:AddToggle("world_global_shadows",      { Text = "global shadows",      Default = false })
quality_tab:AddToggle("world_env_diffuse",         { Text = "env diffuse",         Default = false })
quality_tab:AddSlider("world_env_diffuse_scale",   { Text = "diffuse scale",       Default = 1, Min = 0, Max = 2, Rounding = 2 })
quality_tab:AddToggle("world_env_specular",        { Text = "env specular",        Default = false })
quality_tab:AddSlider("world_env_specular_scale",  { Text = "specular scale",      Default = 1, Min = 0, Max = 2, Rounding = 2 })
quality_tab:AddToggle("world_outdoor_ambient",     { Text = "outdoor ambient",     Default = false })
    :AddColorPicker("world_outdoor_ambient_color", { Default = Color3.fromRGB(127,127,127) })

-- ── CAMERA (right groupbox) ──
local camera_tab = world_tab:AddRightGroupbox("camera")

camera_tab:AddToggle("third_person_enable", { Text = "third person", Default = false })
    :AddKeyPicker("third_person_keybind", { Default = "...", Text = "third person", NoUI = false })
camera_tab:AddToggle("stretched_res_enable",  { Text = "stretched resolution", Default = false })
camera_tab:AddSlider("stretched_res_amount",  { Text = "stretch amount",       Default = 0.75, Min = 0.5, Max = 1, Rounding = 2 })
camera_tab:AddToggle("fov_changer_enable",    { Text = "fov changer",          Default = false })
camera_tab:AddSlider("fov_changer_fov",       { Text = "fov",                  Default = 70, Min = 10, Max = 120, Rounding = 0 })

--============================================================
-- CHARACTER TAB — movement, fly, emote player, crosshair, chams
--============================================================
local char_tab = Tabs.Character

-- ── MOVEMENT (right groupbox) ──
local movement_tab = char_tab:AddRightGroupbox("movement")

movement_tab:AddToggle("walkspeed_enable", { Text = "walkspeed", Default = false })
    :AddKeyPicker("walkspeed_keybind", { Default = "...", Text = "walkspeed", NoUI = false })
movement_tab:AddSlider("walkspeed_multiplier", { Text = "multiplier", Default = 1, Min = 0.5, Max = 5, Rounding = 1 })

movement_tab:AddToggle("infinite_double_jump_enable", { Text = "infinite jump", Default = false })
    :AddKeyPicker("infinite_double_jump_keybind", { Default = "...", Text = "infinite jump", NoUI = false })

movement_tab:AddToggle("slide_boost_enable", { Text = "slide boost", Default = false })
    :AddKeyPicker("slide_boost_keybind", { Default = "...", Text = "slide boost", NoUI = false })
movement_tab:AddSlider("slide_boost_spped", { Text = "boost speed", Default = 50, Min = 10, Max = 200, Rounding = 0 })

movement_tab:AddToggle("double_jump_height_enable", { Text = "jump height", Default = false })
movement_tab:AddToggle("auto_slide_enable",         { Text = "auto slide",  Default = false })

-- ── CHARACTER (left groupbox) ──
local character_tab1 = char_tab:AddLeftGroupbox("character")

character_tab1:AddToggle("fly_enable", { Text = "fly", Default = false })
    :AddKeyPicker("fly_keybind", { Default = "...", Text = "fly", NoUI = false })
character_tab1:AddSlider("fly_speed_value", { Text = "fly speed", Default = 50, Min = 5, Max = 300, Rounding = 0 })

-- ── EMOTE PLAYER (left groupbox) ──
local anim_tab = char_tab:AddLeftGroupbox("emote player")

anim_tab:AddToggle("animation_enable", { Text = "enable", Default = false })
anim_tab:AddDropdown("animation_droadsa", {
    Values = {"Wave", "Point", "Laugh", "Cheer", "Dance1", "Dance2", "Dance3"},
    Default = 1, Text = "emote"
})
anim_tab:AddInput("animation_custom_id", { Text = "custom anim id", Placeholder = "rbxassetid://..." })
anim_tab:AddSlider("animation_speed", { Text = "speed", Default = 1, Min = 0.1, Max = 5, Rounding = 1 })

-- ── CHAMS (right tabbox) ──
local enhance_box = char_tab:AddRightTabbox()
local chams_tab = enhance_box:AddTab("chams")

chams_tab:AddToggle("ChamsEnable",     { Text = "enable",      Default = false })
chams_tab:AddToggle("ChamsTeamCheck",  { Text = "team check",  Default = false })
chams_tab:AddDropdown("ChamsMode", {
    Values = {"Enemies", "Allies", "All"}, Default = 1, Text = "mode"
})
chams_tab:AddLabel("fill"):AddColorPicker("ChamsFill", { Default = Color3.fromRGB(120,81,166) })
chams_tab:AddLabel("outline"):AddColorPicker("ChamsOutline", { Default = Color3.fromRGB(255,255,255) })
chams_tab:AddDropdown("ChamsMaterial", {
    Values = {"ForceField", "Neon", "Glass", "SmoothPlastic"}, Default = 1, Text = "material"
})
chams_tab:AddToggle("ChamsStripTextures", { Text = "strip textures", Default = false })
chams_tab:AddToggle("ChamsGhost",         { Text = "ghost chams",    Default = false })

-- ── CROSSHAIR (left tabbox) ──
local crosshair_tabbox = char_tab:AddLeftTabbox()

local crosshair_box = crosshair_tabbox:AddTab("crosshair")
crosshair_box:AddToggle("CrosshairEnable", { Text = "enable", Default = false })
    :AddColorPicker("CrosshairColor", { Default = Color3.fromRGB(255,255,255) })
crosshair_box:AddDropdown("CrosshairStyle", {
    Values = {"Cross", "Dot", "Circle", "Diamond", "Custom"}, Default = 1, Text = "style"
})
crosshair_box:AddToggle("CrosshairLines",    { Text = "lines",    Default = true })
crosshair_box:AddSlider("CrosshairRotation", { Text = "rotation", Default = 0,  Min = 0, Max = 360, Rounding = 0 })
crosshair_box:AddSlider("CrosshairLength",   { Text = "length",   Default = 6,  Min = 1, Max = 30, Rounding = 0 })
crosshair_box:AddSlider("CrosshairThickness",{ Text = "thickness",Default = 2,  Min = 1, Max = 10, Rounding = 0 })
crosshair_box:AddSlider("CrosshairGap",      { Text = "gap",      Default = 3,  Min = 0, Max = 20, Rounding = 0 })
crosshair_box:AddToggle("CrosshairOutline",  { Text = "outline",  Default = false })
    :AddColorPicker("CrosshairOutlineColor", { Default = Color3.fromRGB(0,0,0) })
crosshair_box:AddToggle("CrosshairTopLine",    { Text = "top line",    Default = true })
crosshair_box:AddToggle("CrosshairBottomLine", { Text = "bottom line", Default = true })

local lines_box = crosshair_tabbox:AddTab("lines")
lines_box:AddToggle("CrosshairDot",         { Text = "dot",          Default = false })
lines_box:AddToggle("CrosshairLineOutline", { Text = "line outline", Default = false })
lines_box:AddToggle("CrosshairTop",         { Text = "top",          Default = true })
lines_box:AddToggle("CrosshairBottom",      { Text = "bottom",       Default = true })
lines_box:AddToggle("CrosshairLeft",        { Text = "left",         Default = true })
lines_box:AddToggle("CrosshairRight",       { Text = "right",        Default = true })

local effects_box = crosshair_tabbox:AddTab("effects")
effects_box:AddToggle("CrosshairRotating",    { Text = "rotating", Default = false })
effects_box:AddSlider("CrosshairRotatingSpeed",{ Text = "speed",   Default = 90, Min = 1, Max = 720, Rounding = 0 })
effects_box:AddToggle("CrosshairSpread",       { Text = "spread",  Default = false })
effects_box:AddSlider("CrosshairSpreadScale",  { Text = "scale",   Default = 1, Min = 0, Max = 5, Rounding = 1 })
effects_box:AddToggle("CrosshairAnimation",    { Text = "animation",   Default = false })
effects_box:AddDropdown("CrosshairAnimationMode", {
    Values = {"Pulse", "Bounce", "Fade"}, Default = 1, Text = "anim mode"
})
effects_box:AddSlider("CrosshairAnimationSpeed", { Text = "anim speed", Default = 1, Min = 0.1, Max = 5, Rounding = 1 })
effects_box:AddToggle("CrosshairFade", { Text = "fade", Default = false })
    :AddColorPicker("CrosshairFadeColor", { Default = Color3.fromRGB(255,0,0) })
effects_box:AddToggle("CrosshairFollowTarget",   { Text = "follow target",  Default = false })
effects_box:AddDropdown("CrosshairFollowSource", { Values = {"Closest", "Locked"}, Default = 1, Text = "source" })
effects_box:AddToggle("CrosshairShimmer",        { Text = "shimmer",        Default = false })
effects_box:AddSlider("CrosshairShimmerSpeed",   { Text = "shimmer speed",  Default = 1, Min = 0.1, Max = 5, Rounding = 1 })

local text_box = crosshair_tabbox:AddTab("text")
text_box:AddToggle("CrosshairTextEnable", { Text = "enable", Default = false })
    :AddColorPicker("CrosshairTextColor", { Default = Color3.fromRGB(255,255,255) })
text_box:AddInput("CrosshairTextContent",  { Text = "text", Placeholder = "+" })
text_box:AddDropdown("CrosshairTextFont",  { Values = {"Gotham","GothamBold","Code","Arcade"}, Default = 1, Text = "font" })
text_box:AddSlider("CrosshairTextSize",    { Text = "size",   Default = 14, Min = 8, Max = 36, Rounding = 0 })
text_box:AddSlider("CrosshairTextOffset",  { Text = "offset", Default = 0,  Min = -20, Max = 20, Rounding = 0 })
text_box:AddToggle("CrosshairTextOutline", { Text = "outline",   Default = false })
text_box:AddToggle("CrosshairTextAnimation",{ Text = "animation", Default = false })

--============================================================
-- VISUALS TAB (Elisium features added to right side)
-- Left side already has ESP from new UI.
-- Adding Elisium visual features on right.
--============================================================

-- Target HUD
local target_hud_box = Tabs.Visuals:AddRightGroupbox("target hud")
target_hud_box:AddToggle("target_hud_enable", { Text = "enable", Default = false })
target_hud_box:AddDropdown("target_hud_method",   { Values = {"Closest","Locked"}, Default = 1, Text = "method" })
target_hud_box:AddDropdown("target_hud_position", { Values = {"TopLeft","TopRight","BottomLeft","BottomRight","Center"}, Default = 1, Text = "position" })
target_hud_box:AddSlider("target_hud_offset_x",   { Text = "offset x", Default = 0,  Min = -500, Max = 500, Rounding = 0 })
target_hud_box:AddSlider("target_hud_offset_y",   { Text = "offset y", Default = 0,  Min = -500, Max = 500, Rounding = 0 })
target_hud_box:AddSlider("target_hud_scale",      { Text = "scale",    Default = 1,  Min = 0.5,  Max = 3,   Rounding = 1 })

-- Disable animations
local disable_anims_tab = Tabs.Visuals:AddRightGroupbox("disable animation")
disable_anims_tab:AddToggle("disable_anims_enable", { Text = "enable", Default = false })
disable_anims_tab:AddDropdown("disable_anims_select", {
    Values = {"All", "Walk", "Run", "Jump", "Idle", "Swim", "Climb"}, Default = 1, Multi = true, Text = "animations"
})

-- Motion blur
local motion_blur_tab = Tabs.Visuals:AddRightGroupbox("motion blur")
motion_blur_tab:AddToggle("motion_blur_enable",    { Text = "enable",      Default = false })
motion_blur_tab:AddSlider("motion_blur_intensity", { Text = "intensity",   Default = 0.5, Min = 0, Max = 1, Rounding = 2 })
motion_blur_tab:AddSlider("motion_blur_sensitivity",{ Text = "sensitivity", Default = 1,   Min = 0, Max = 5, Rounding = 1 })

-- Death effects
local death_tab = Tabs.Visuals:AddRightGroupbox("death effects")
death_tab:AddToggle("death_effects_enable", { Text = "enable", Default = false })
    :AddColorPicker("death_effects_color", { Default = Color3.fromRGB(255,0,0) })
death_tab:AddDropdown("death_effects_type", {
    Values = {"Ragdoll", "Dissolve", "Explode", "Freeze"}, Default = 1, Text = "effect type"
})

-- Damage numbers
local dmg_tab = Tabs.Visuals:AddRightGroupbox("damage numbers")
dmg_tab:AddToggle("damage_numbers_enable", { Text = "enable", Default = false })
    :AddColorPicker("damage_numbers_color1", { Default = Color3.fromRGB(255,255,255) })
    :AddColorPicker("damage_numbers_color2", { Default = Color3.fromRGB(255,0,0) })
dmg_tab:AddToggle("damage_numbers_remove_ingame", { Text = "remove in-game numbers", Default = false })
dmg_tab:AddDropdown("damage_numbers_color_type", {
    Values = {"Static","Gradient","Health"}, Default = 1, Text = "color type"
})
dmg_tab:AddDropdown("damage_numbers_font", {
    Values = {"Gotham","GothamBold","Code","Arcade","RobotoMono"}, Default = 1, Text = "font"
})
dmg_tab:AddSlider("damage_numbers_text_size", { Text = "text size", Default = 14, Min = 8, Max = 36, Rounding = 0 })
dmg_tab:AddSlider("damage_numbers_rise",      { Text = "rise",      Default = 50, Min = 0, Max = 200, Rounding = 0 })
dmg_tab:AddSlider("damage_numbers_duration",  { Text = "duration",  Default = 1,  Min = 0.1, Max = 5, Rounding = 1 })

-- Hit notify
local notify_hit_tab = Tabs.Visuals:AddRightGroupbox("hit notify")
notify_hit_tab:AddToggle("hit_notify_enable",  { Text = "enable",   Default = false })
notify_hit_tab:AddSlider("hit_notify_duration",{ Text = "duration", Default = 1, Min = 0.1, Max = 5, Rounding = 1 })
notify_hit_tab:AddInput("hit_notify_msg",       { Text = "message",  Default = "hit!", Placeholder = "hit!" })

-- Trajectory
local traj_tab = Tabs.Visuals:AddRightGroupbox("trajectory")
traj_tab:AddToggle("trajectory_enable", { Text = "enable", Default = false })
    :AddColorPicker("trajectory_color", { Default = Color3.fromRGB(255,255,0) })
traj_tab:AddToggle("trajectory_all_weapons", { Text = "all weapons",Default = false })
traj_tab:AddSlider("trajectory_speed",   { Text = "speed",    Default = 100, Min = 10, Max = 1000, Rounding = 0 })
traj_tab:AddSlider("trajectory_arc_up",  { Text = "arc up",   Default = 10,  Min = 0,  Max = 100,  Rounding = 0 })

-- Bullet tracers (sub-section in visuals)
local tracers_box = Tabs.Visuals:AddLeftGroupbox("bullet tracers")
tracers_box:AddToggle("bullet_tracers_enable", { Text = "enable", Default = false })
    :AddColorPicker("bullet_tracers_color_start", { Default = Color3.fromRGB(120,81,166) })
    :AddColorPicker("bullet_tracers_color_end",   { Default = Color3.fromRGB(255,255,255) })
tracers_box:AddToggle("bullet_tracers_curve",         { Text = "curve",        Default = false })
tracers_box:AddToggle("bullet_tracers_through_walls", { Text = "through walls",Default = false })
tracers_box:AddSlider("bullet_tracers_curve_height",  { Text = "curve height", Default = 5,   Min = 0,   Max = 50,  Rounding = 0 })
tracers_box:AddDropdown("bullet_tracers_texture", {
    Values = {"Line","Beam","Neon","Dashed"}, Default = 1, Text = "texture"
})
tracers_box:AddSlider("bullet_tracers_speed",    { Text = "speed",    Default = 500, Min = 50,  Max = 2000, Rounding = 0 })
tracers_box:AddSlider("bullet_tracers_lifetime", { Text = "lifetime", Default = 0.3, Min = 0.1, Max = 2,   Rounding = 1 })
tracers_box:AddSlider("bullet_tracers_width0",   { Text = "width start",Default = 0.1, Min = 0.01,Max = 1, Rounding = 2 })
tracers_box:AddSlider("bullet_tracers_width1",   { Text = "width end",  Default = 0.05,Min = 0.01,Max = 1, Rounding = 2 })

-- Hitsound
local sound_box = Tabs.Visuals:AddLeftGroupbox("hitsounds")
sound_box:AddToggle("hitsound_enable",                 { Text = "enable",                Default = false })
sound_box:AddToggle("disable_default_hitsound_enable", { Text = "disable default sound", Default = false })
sound_box:AddDropdown("hitsound_selected", {
    Values = {"Quake", "CS:GO", "Skeet", "Roblox"}, Default = 1, Text = "hitsound"
})
sound_box:AddSlider("hitsound_volume", { Text = "volume", Default = 0.5, Min = 0, Max = 1, Rounding = 2 })
sound_box:AddSlider("hitsound_pitch",  { Text = "pitch",  Default = 1,   Min = 0.5, Max = 2, Rounding = 1 })

--============================================================
-- MISC TAB — Elisium misc features (spoof, troll, utility, arcade)
-- Keep original demo group, add Elisium features.
--============================================================

-- Auto vote map
local auto_tabbox = Tabs.Misc:AddRightTabbox()
local auto_vote_map = auto_tabbox:AddTab("auto vote map")
auto_vote_map:AddToggle("auto_vote_map_enable", { Text = "enable", Default = false })
auto_vote_map:AddDropdown("auto_vote_map", {
    Values = {"Arena","Big Graveyard","Docks","Splash","Bridge","Crossroads","Big Crossroads",
              "Big Backrooms","Battleground","Big Arena","Construction","Playground","Onyx",
              "Graveyard","Big Splash","Big Onyx","Backrooms","Station","Dimension"},
    Default = 1, Text = "map"
})

-- Troll tab
local troll_tab = Tabs.Misc:AddLeftTabbox()

local device_spoof_tab = troll_tab:AddTab("device spoof")
device_spoof_tab:AddToggle("device_spoof_enable", { Text = "enable", Default = false })
device_spoof_tab:AddDropdown("device_spoof_type", {
    Values = {"Touch","MouseKeyboard","Gamepad","VR"}, Default = 2, Text = "type"
})

local sound_spammer_tab = troll_tab:AddTab("sound spammer")
sound_spammer_tab:AddToggle("sound_spammer_enable", { Text = "enable", Default = false })
sound_spammer_tab:AddDropdown("sound_spammer_type", {
    Values = {"DoubleJump","Slide"}, Default = 1, Text = "sound type"
})

-- Spoof tabbox
local spooftabthing = Tabs.Misc:AddRightTabbox()

local streak_spoof = spooftabthing:AddTab("streak")
streak_spoof:AddToggle("streak_spoof_enable", { Text = "spoof", Default = false })
streak_spoof:AddInput("streak_spoof_text", { Default = "9", Numeric = true, Text = "value" })

local level_spoof = spooftabthing:AddTab("level")
level_spoof:AddToggle("level_spoof_enable", { Text = "spoof", Default = false })
level_spoof:AddInput("level_spoof_text", { Default = "9", Numeric = true, Text = "value" })

local rank_spoof = spooftabthing:AddTab("rank")
rank_spoof:AddToggle("rank_spoof_enable", { Text = "spoof (not working)", Default = false })
rank_spoof:AddDropdown("rank_spoof_value", {
    Values = {"Bronze","Silver","Gold","Diamond","Onyx","Nemesis","Arch Nemesis"}, Default = 7, Text = "rank"
})

local elo_spoof = spooftabthing:AddTab("elo")
elo_spoof:AddToggle("elo_spoof_enable", { Text = "spoof (not working)", Default = false })
elo_spoof:AddInput("elo_spoof_text", { Default = "60000", Numeric = true, Text = "value" })

local name_spoof = spooftabthing:AddTab("name")
name_spoof:AddToggle("name_spoof_enable", { Text = "spoof", Default = false })
name_spoof:AddInput("name_spoof_display",  { Default = "", Text = "display name",  Placeholder = "display name" })
name_spoof:AddInput("name_spoof_username", { Default = "", Text = "username",       Placeholder = "username" })

-- Utility tabbox
local utility_tab = Tabs.Misc:AddLeftTabbox()

local auto_loadout_tab = utility_tab:AddTab("auto loadout")
auto_loadout_tab:AddToggle("auto_loadout_enable", { Text = "enable", Default = false })
for _, class in ipairs({"Primary","Secondary","Melee","Utility"}) do
    auto_loadout_tab:AddDropdown("auto_loadout_class_" .. class:lower(), {
        Values = {}, AllowNull = true, Text = class:lower()
    })
end

local auto_queue_tab = utility_tab:AddTab("auto queue")
auto_queue_tab:AddToggle("auto_queue_enable", { Text = "enable", Default = false })
auto_queue_tab:AddDropdown("auto_queue_mode", {
    Values = {"1v1","2v2","3v3","4v4","5v5","2v2_beginner"}, Default = 1, Text = "queue mode"
})

-- Arcade server
local arcade_server_tab = Tabs.Misc:AddRightGroupbox("arcade server")
arcade_server_tab:AddToggle("grab_drops_enable",   { Text = "grab drops",   Default = false })
arcade_server_tab:AddToggle("auto_respawn_enable",  { Text = "auto respawn", Default = false })

-- Cosmetics
local cosmetics_box = Tabs.Misc:AddRightGroupbox("cosmetics")
cosmetics_box:AddToggle("AnySkinMode", { Text = "any skin", Default = false })
cosmetics_box:AddButton("cosmetic changer", function() end)

-- Name spoof (local/other tabbox in misc)
local spoof_box = Tabs.Misc:AddLeftTabbox()
local localTab = spoof_box:AddTab("local")
local otherTab = spoof_box:AddTab("other")

localTab:AddToggle("SpoofLocal", { Text = "spoof local", Default = false })
localTab:AddInput("SpoofLocalName", { Default = "", Text = "name", Placeholder = "display name" })

otherTab:AddToggle("SpoofOther", { Text = "spoof other", Default = false })
otherTab:AddInput("SpoofOtherName", { Default = "", Text = "name", Placeholder = "player name" })

--============================================================
-- OPTIMIZATIONS TAB
--============================================================
local opt_tab = Tabs.Optims

local boost_box = opt_tab:AddLeftGroupbox("fps boost")
boost_box:AddToggle("opt_no_particles",   { Text = "remove particles & effects", Default = false })
boost_box:AddToggle("opt_no_shadows",     { Text = "no shadows",                 Default = false })
boost_box:AddToggle("opt_no_postfx",      { Text = "no post effects",            Default = false })
boost_box:AddToggle("opt_low_quality",    { Text = "low quality",                Default = false })
boost_box:AddToggle("opt_no_atmosphere",  { Text = "no atmosphere",              Default = false })
boost_box:AddToggle("opt_no_textures",    { Text = "no textures",                Default = false })
boost_box:AddButton("quick boost (all)", function()
    for _, id in ipairs({"opt_no_particles","opt_no_shadows","opt_no_postfx","opt_low_quality","opt_no_atmosphere","opt_no_textures"}) do
        if Toggles[id] then Toggles[id]:SetValue(true) end
    end
end)

local fr_box = opt_tab:AddRightGroupbox("frame rate")
fr_box:AddToggle("opt_fps_cap_enable", { Text = "fps cap", Default = false })
fr_box:AddSlider("opt_fps_cap",        { Text = "fps",     Default = 60, Min = 10, Max = 400, Rounding = 0 })

local ff_box = opt_tab:AddRightGroupbox("fflags injector")
ff_box:AddButton("inject fps boost fflags", function() end)
ff_box:AddInput("opt_fflag_custom", { Text = "custom fflag", Placeholder = "FFlag..." })
ff_box:AddButton("inject custom fflags",   function() end)
ff_box:AddButton("save preset to file",    function() end)

--============================================================
-- LUA TAB — executor + lua configs
--============================================================
local lua_tab = Tabs.Lua

local exec_box = lua_tab:AddLeftGroupbox("executor")
-- Minimal executor stub — wire to your own code editor widget if available
exec_box:AddButton("execute",  function() end)
exec_box:AddButton("clear",    function() end)

local cfg_box = lua_tab:AddRightGroupbox("lua configs")
cfg_box:AddInput("lua_name",    { Text = "lua name",   Placeholder = "my script" })
cfg_box:AddDropdown("lua_list", { Text = "saved luas", Values = {}, AllowNull = true })
cfg_box:AddButton("save lua",       function() end)
cfg_box:AddButton("load lua",       function() end)
cfg_box:AddButton("execute lua",    function() end)
cfg_box:AddButton("delete lua",     function() end)
cfg_box:AddButton("refresh list",   function() end)
cfg_box:AddButton("set as autoload",function() end)
cfg_box:AddButton("clear autoload", function() end)

--============================================================
-- SETTINGS TAB — Elisium UI settings merged in
--============================================================
local menu_box = Tabs.Settings:AddLeftGroupbox("menu")
menu_box:AddLabel("menu bind"):AddKeyPicker("MenuKeybind", { Default = "Insert", Mode = "Toggle", Text = "menu" })
menu_box:AddToggle("menu_blur",         { Text = "menu blur",        Default = true })
menu_box:AddToggle("show_keybind_menu", { Text = "show keybind menu",Default = false })
menu_box:AddButton("unload", function() Library:Unload() end)

local auto_load_box = Tabs.Settings:AddLeftGroupbox("auto load")
auto_load_box:AddToggle("auto_load_enable",   { Text = "auto load",   Default = false })
auto_load_box:AddToggle("silent_load_enable", { Text = "silent load", Default = false })

-- Widgets
local widgets_box = Tabs.Settings:AddLeftGroupbox("widgets")
widgets_box:AddToggle("WidgetWatermark",    { Text = "watermark",     Default = true  })
widgets_box:AddToggle("WidgetAppearance",   { Text = "appearance",    Default = true  })
widgets_box:AddToggle("WidgetRadar",        { Text = "radar",         Default = false })
widgets_box:AddToggle("WidgetPlayerList",   { Text = "player list",   Default = false })
widgets_box:AddToggle("WidgetVelocity",     { Text = "velocity",      Default = false })
widgets_box:AddToggle("WidgetClosestPlayer",{ Text = "closest player",Default = false })

-- Watermark options
local wm_box = Tabs.Settings:AddRightGroupbox("watermark")
wm_box:AddToggle("WatermarkFps",      { Text = "show fps",      Default = true  })
wm_box:AddToggle("WatermarkPing",     { Text = "show ping",     Default = true  })
wm_box:AddToggle("WatermarkTime",     { Text = "show time",     Default = true  })
wm_box:AddToggle("WatermarkExecutor", { Text = "show executor", Default = false })

-- Notifications
local notifications_box = Tabs.Settings:AddRightGroupbox("notifications")
notifications_box:AddToggle("notify_force_color", { Text = "force color", Default = false })
    :AddColorPicker("notify_color", { Default = Color3.fromRGB(120,81,166) })
notifications_box:AddSlider("notify_x",           { Text = "x offset",     Default = 0,   Min = 0, Max = 500, Rounding = 0 })
notifications_box:AddSlider("notify_y",           { Text = "y offset",     Default = 0,   Min = 0, Max = 500, Rounding = 0 })
notifications_box:AddSlider("notify_transparency",{ Text = "transparency", Default = 0,   Min = 0, Max = 1,   Rounding = 2 })
notifications_box:AddDropdown("notify_alignment", { Values = {"Left","Center","Right"}, Default = 1, Text = "alignment" })
notifications_box:AddDropdown("notify_side",      { Values = {"Left","Right"},          Default = 2, Text = "side"      })
notifications_box:AddButton("send notification",  function() Library:Notify("test notification", 3) end)

--============================================================
-- FINALIZE
--============================================================
SaveManager:LoadAutoloadConfig()

Library:Notify({ Title = "XoneScriptK", Description = "Loaded! All features ported.", Time = 3 })
