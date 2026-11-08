local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

-- SETTINGS
local UI_SCALE = 0.55
local ACCENT = Color3.fromRGB(145, 95, 255)
local BG = Color3.fromRGB(15, 15, 19)
local BLUE = Color3.fromRGB(0, 185, 255)

local LOCKED_COLOR = Color3.fromRGB(255, 65, 65)
local UNLOCKED_COLOR = Color3.fromRGB(65, 220, 115)

-- RESIZE SETTINGS
local MIN_WIDTH = 280
local MIN_HEIGHT = 200
local RESIZE_SIZE = 48
local RESIZE_COLOR = Color3.fromRGB(65, 145, 225)

-- DRAG SETTINGS
local TITLE_DRAG_HEIGHT = 30
local EDGE_DRAG_WIDTH = 8
local BOTTOM_DRAG_HEIGHT = 10

-- DROPDOWN SETTINGS
local DROPDOWN_OPTION_HEIGHT = 16
local DROPDOWN_TEXT_SIZE = 14
local DROPDOWN_MAX_HEIGHT = 88

-- MOBILE CONTROL SETTINGS
local CONTROL_WIDTH = 88
local CONTROL_HEIGHT = 30

-- STATES
local UILocked = false
local UIVisible = true
local ControlsUnlocked = false
local ResizingWindow = false
local UnloadCleanupDone = false

local MainFrame
local ResizeHandle
local Scale
local LibraryGui
local InputBlocker
local BackgroundBlur

local DragZones = {}
local DragConnections = {}
local ControlConnections = {}

-- GUI ROOTS
local function GetRoots()
    local Roots = {PlayerGui, CoreGui}
    pcall(function()
        if gethui then
            table.insert(Roots, gethui())
        end
    end)
    return Roots
end

local function GetScreenGuis()
    local Found = {}
    for _, Root in ipairs(GetRoots()) do
        pcall(function()
            for _, Obj in ipairs(Root:GetDescendants()) do
                if Obj:IsA("ScreenGui") and Obj.Name ~= "CloudCompactControls" then
                    Found[Obj] = true
                end
            end
        end)
    end
    return Found
end

local ExistingGuis = GetScreenGuis()

-- RESIZE HANDLE INPUT CHECK
local function IsOverResizeHandle(Position)
    if not ResizeHandle or not ResizeHandle.Parent then return false end
    local P = ResizeHandle.AbsolutePosition
    local S = ResizeHandle.AbsoluteSize
    return Position.X >= P.X and Position.X <= P.X + S.X
        and Position.Y >= P.Y and Position.Y <= P.Y + S.Y
end

-- LOAD LIBRARY
local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/gut7899/Other/refs/heads/main/Cloude/Library.lua"
))()

pcall(function()
    if Library.Theme and Library.Theme["Accent"] then
        ACCENT = Library.Theme["Accent"]
    end
end)

-- COMPACT DROPDOWN SETTINGS
local OriginalDropdown = Library.Dropdown

if type(OriginalDropdown) == "function" then
    Library.Dropdown = function(Self, Params)
        local Dropdown = OriginalDropdown(Self, Params)
        if not Dropdown then return Dropdown end

        local function StyleOption(Option)
            pcall(function()
                local Button = Option.Button.Instance
                local Text = Option.Text.Instance
                Button.Size = UDim2.new(1, 0, 0, DROPDOWN_OPTION_HEIGHT)
                Text.TextSize = DROPDOWN_TEXT_SIZE
                Text.Size = UDim2.new(1, -4, 0, DROPDOWN_OPTION_HEIGHT)
            end)
        end

        local function StyleDropdown()
            pcall(function()
                local Holder = Dropdown.Holder.Instance
                local Padding = Holder:FindFirstChildOfClass("UIPadding")
                if Padding then
                    Padding.PaddingTop = UDim.new(0, 4)
                    Padding.PaddingBottom = UDim.new(0, 4)
                    Padding.PaddingLeft = UDim.new(0, 7)
                    Padding.PaddingRight = UDim.new(0, 7)
                end
                local Layout = Holder:FindFirstChildOfClass("UIListLayout")
                if Layout then Layout.Padding = UDim.new(0, 1) end
                Holder.ClipsDescendants = true
                Dropdown.MaxSize = DROPDOWN_MAX_HEIGHT
            end)
            for _, Option in pairs(Dropdown.Options) do
                StyleOption(Option)
            end
        end

        StyleDropdown()
        return Dropdown
    end
end

Library.MakeDraggable = function(Self) return end
Library.MakeResizeable = function(Self, Minimum) return end

-- WINDOW
local Window = Library:Window({
    Name = "cloudeeeeeee ui lol"
})

local Watermark = Window:Watermark({
    Name = "watermark",
    SubName = "watermark subname"
})

local KeybindList = Window:KeybindList({
    Name = "keybinds",
})

-- TABS
local CombatTab    = Window:Page({Name = "Combat"})
local MiscTab      = Window:Page({Name = "Misc"})
local VisualsTab   = Window:Page({Name = "Visuals"})
local PlayersTab   = Window:Page({Name = "Players"})
local ESPTab       = Window:Page({Name = "ESP"})
local WorldTab     = Window:Page({Name = "World"})
local CharTab      = Window:Page({Name = "Character"})
local OptsTab      = Window:Page({Name = "Optimizations"})

Window:InitWindow()

-- FIND LIBRARY GUI
local function FindMainFrame(ScreenGui)
    local BestFrame
    local BestArea = 0
    for _, Obj in ipairs(ScreenGui:GetDescendants()) do
        if Obj:IsA("Frame") and Obj.Visible then
            local Size = Obj.AbsoluteSize
            local Area = Size.X * Size.Y
            if Area > BestArea then
                BestArea = Area
                BestFrame = Obj
            end
        end
    end
    return BestFrame, BestArea
end

local function FindLibraryGui()
    local BestNewGui
    local BestNewArea = 0
    local BestGui
    local BestArea = 0

    for _, Root in ipairs(GetRoots()) do
        pcall(function()
            for _, Obj in ipairs(Root:GetDescendants()) do
                if Obj:IsA("ScreenGui") and Obj.Name ~= "CloudCompactControls" then
                    local Frame, Area = FindMainFrame(Obj)
                    if Frame then
                        if Area > BestArea then
                            BestArea = Area
                            BestGui = Obj
                        end
                        if not ExistingGuis[Obj] and Area > BestNewArea then
                            BestNewArea = Area
                            BestNewGui = Obj
                        end
                    end
                end
            end
        end)
    end

    LibraryGui = BestNewGui or BestGui
    if LibraryGui then
        MainFrame = FindMainFrame(LibraryGui)
    end
end

for i = 1, 40 do
    FindLibraryGui()
    if LibraryGui and MainFrame then break end
    task.wait(0.25)
end

-- APPLY SCALE
if MainFrame then
    Scale = MainFrame:FindFirstChildOfClass("UIScale")
    if not Scale then
        Scale = Instance.new("UIScale")
        Scale.Parent = MainFrame
    end
    Scale.Scale = UI_SCALE
    pcall(function() MainFrame.Draggable = false end)
else
    warn("Could not find library window.")
end

-- CONTROL GUI
local ControlGui = Instance.new("ScreenGui")
ControlGui.Name = "CloudCompactControls"
ControlGui.ResetOnSpawn = false
ControlGui.IgnoreGuiInset = false
ControlGui.DisplayOrder = 10000
ControlGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
ControlGui.Parent = PlayerGui

-- BACKGROUND BLUR
BackgroundBlur = Instance.new("BlurEffect")
BackgroundBlur.Name = "CloudUIBackgroundBlur"
BackgroundBlur.Size = 14
BackgroundBlur.Enabled = true
BackgroundBlur.Parent = Lighting

-- CLEANUP
local function CleanupCustomControls()
    if UnloadCleanupDone then return end
    UnloadCleanupDone = true
    ResizingWindow = false

    for _, Connection in ipairs(DragConnections) do
        pcall(function() Connection:Disconnect() end)
    end
    for _, Connection in ipairs(ControlConnections) do
        pcall(function() Connection:Disconnect() end)
    end

    table.clear(DragConnections)
    table.clear(ControlConnections)
    table.clear(DragZones)

    if BackgroundBlur then
        BackgroundBlur:Destroy()
        BackgroundBlur = nil
    end
    if InputBlocker then
        InputBlocker:Destroy()
        InputBlocker = nil
    end
    if ControlGui and ControlGui.Parent then
        ControlGui:Destroy()
    end
end

if LibraryGui then LibraryGui.Destroying:Connect(CleanupCustomControls) end
if MainFrame then MainFrame.Destroying:Connect(CleanupCustomControls) end

-- MOBILE BUTTON CREATOR
local function CreateMobileButton(Name, Text, StartPosition)
    local Outer = Instance.new("Frame")
    Outer.Name = Name .. "Outer"
    Outer.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Outer.BorderSizePixel = 0
    Outer.Position = StartPosition
    Outer.Size = UDim2.fromOffset(CONTROL_WIDTH, CONTROL_HEIGHT)
    Outer.ZIndex = 300
    Outer.Parent = ControlGui
    Outer.Active = true

    local AccentFrame = Instance.new("Frame")
    AccentFrame.Name = Name .. "Accent"
    AccentFrame.BackgroundColor3 = ACCENT
    AccentFrame.BorderSizePixel = 0
    AccentFrame.Position = UDim2.fromOffset(1, 1)
    AccentFrame.Size = UDim2.new(1, -2, 1, -2)
    AccentFrame.ZIndex = 301
    AccentFrame.Parent = Outer

    local Inner = Instance.new("Frame")
    Inner.Name = Name .. "Inner"
    Inner.BackgroundColor3 = Color3.fromRGB(8, 8, 12)
    Inner.BorderSizePixel = 0
    Inner.Position = UDim2.fromOffset(1, 1)
    Inner.Size = UDim2.new(1, -2, 1, -2)
    Inner.ZIndex = 302
    Inner.Parent = AccentFrame

    local GradientOverlay = Instance.new("Frame")
    GradientOverlay.Name = Name .. "Gradient"
    GradientOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
    GradientOverlay.BorderSizePixel = 0
    GradientOverlay.Size = UDim2.fromScale(1, 1)
    GradientOverlay.ZIndex = 303
    GradientOverlay.Parent = Inner

    local Gradient = Instance.new("UIGradient")
    Gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.90),
        NumberSequenceKeypoint.new(1, 1)
    })
    Gradient.Rotation = 90
    Gradient.Parent = GradientOverlay

    local Button = Instance.new("TextButton")
    Button.Name = Name .. "Btn"
    Button.BackgroundTransparency = 1
    Button.Size = UDim2.fromScale(1, 1)
    Button.Font = Enum.Font.Code
    Button.Text = Text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 13
    Button.ZIndex = 304
    Button.Parent = Inner
    Button.Active = true
    Button.AutoButtonColor = false

    return Outer, Button, AccentFrame
end

local ToggleOuter, ToggleButton, ToggleAccent =
    CreateMobileButton("Toggle", "Toggle UI", UDim2.fromOffset(10, 10))

local LockOuter, LockButton, LockAccent =
    CreateMobileButton("Lock", "Unlock UI", UDim2.fromOffset(10, 50))

-- UPDATE ACCENT
local function UpdateControlAccent(Color)
    if typeof(Color) ~= "Color3" then return end
    ACCENT = Color
    if ToggleAccent and ToggleAccent.Parent then
        ToggleAccent.BackgroundColor3 = Color
    end
    if LockAccent and LockAccent.Parent then
        LockAccent.BackgroundColor3 = Color
    end
    if LockButton and LockButton.Parent and ControlsUnlocked then
        LockButton.TextColor3 = Color
    end
end

local OriginalChangeTheme = Library.ChangeTheme
if type(OriginalChangeTheme) == "function" then
    Library.ChangeTheme = function(Self, ThemeName, Color, ...)
        local Results = table.pack(OriginalChangeTheme(Self, ThemeName, Color, ...))
        if ThemeName == "Accent" then UpdateControlAccent(Color) end
        return table.unpack(Results, 1, Results.n)
    end
end

pcall(function()
    if Library.Theme and Library.Theme["Accent"] then
        UpdateControlAccent(Library.Theme["Accent"])
    else
        UpdateControlAccent(ACCENT)
    end
end)

-- CLOSE OPEN POPUPS
local function ForceClosePopups()
    pcall(function()
        if Window and Window.ClosePopups then Window:ClosePopups() end
    end)
    pcall(function()
        if Library.OpenFrames then
            for Popup, Value in pairs(Library.OpenFrames) do
                if Value and Value.Items then
                    for _, Name in ipairs({"OptionHolder","ColorpickerWindow","KeybindWindow"}) do
                        local Item = Value.Items[Name]
                        if Item and Item.Instance then Item.Instance.Visible = false end
                    end
                end
                Library.OpenFrames[Popup] = nil
            end
        end
    end)
end

-- TOGGLE UI
local function ToggleMainUI()
    if UnloadCleanupDone or ResizingWindow then return end
    if not MainFrame or not MainFrame.Parent then FindLibraryGui() end
    if not MainFrame then warn("Main window was not found.") return end

    UIVisible = not UIVisible
    if not UIVisible then
        ForceClosePopups()
        MainFrame.Visible = false
        if BackgroundBlur then BackgroundBlur.Enabled = false end
    else
        MainFrame.Visible = true
        if BackgroundBlur then BackgroundBlur.Enabled = true end
    end
end

-- LOCK BUTTON
local function UpdateLockButton()
    if ControlsUnlocked then
        LockButton.Text = "Lock UI"
        LockButton.TextColor3 = ACCENT
    else
        LockButton.Text = "Unlock UI"
        LockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end

    LockAccent.BackgroundColor3 = ACCENT
    if UILocked then ResizingWindow = false end

    for _, Zone in ipairs(DragZones) do
        Zone.Active = not UILocked and not ResizingWindow
    end
    if ResizeHandle then
        ResizeHandle.Active = not UILocked
        ResizeHandle.Selectable = not UILocked
    end
end

-- MOBILE BUTTON INPUT
local function BindMobileButton(Button, Outer, ClickAction)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    local HasMoved = false

    Button.InputBegan:Connect(function(Input)
        if ResizingWindow then return end
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.Touch then return end

        Dragging = true
        HasMoved = false
        DragStart = Input.Position
        StartPosition = Outer.Position
        DragInput = Input

        local EndConnection
        EndConnection = Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                if EndConnection then EndConnection:Disconnect() end
                if not HasMoved and not ResizingWindow then ClickAction() end
            end
        end)
        table.insert(ControlConnections, EndConnection)
    end)

    local MoveConnection = UserInputService.InputChanged:Connect(function(Input)
        if not Dragging or not ControlsUnlocked or ResizingWindow then return end
        local IsMouseMove = Input.UserInputType == Enum.UserInputType.MouseMovement
        local IsTouchMove = Input.UserInputType == Enum.UserInputType.Touch and Input == DragInput
        if not IsMouseMove and not IsTouchMove then return end

        local Delta = Input.Position - DragStart
        if Delta.Magnitude > 3 then HasMoved = true end

        if ControlsUnlocked and HasMoved then
            Outer.Position = UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        end
    end)

    table.insert(ControlConnections, MoveConnection)
end

BindMobileButton(ToggleButton, ToggleOuter, ToggleMainUI)
BindMobileButton(LockButton, LockOuter, function()
    ControlsUnlocked = not ControlsUnlocked
    UILocked = not ControlsUnlocked
    UpdateLockButton()
end)

-- CUSTOM RESIZE HANDLE
local function CreateResizeHandle()
    if not MainFrame then return end
    local Old = MainFrame:FindFirstChild("CloudCustomResize")
    if Old then Old:Destroy() end

    InputBlocker = Instance.new("TextButton")
    InputBlocker.Name = "CloudResizeInputBlocker"
    InputBlocker.Size = UDim2.fromScale(1, 1)
    InputBlocker.Position = UDim2.fromScale(0, 0)
    InputBlocker.BackgroundTransparency = 1
    InputBlocker.BorderSizePixel = 0
    InputBlocker.Text = ""
    InputBlocker.AutoButtonColor = false
    InputBlocker.Active = true
    InputBlocker.Selectable = false
    InputBlocker.Visible = false
    InputBlocker.ZIndex = 999998
    InputBlocker.Parent = LibraryGui

    local Handle = Instance.new("TextButton")
    Handle.Name = "CloudCustomResize"
    Handle.Size = UDim2.fromOffset(RESIZE_SIZE, RESIZE_SIZE)
    Handle.AnchorPoint = Vector2.new(1, 1)
    Handle.Position = UDim2.new(1, 0, 1, 0)
    Handle.BackgroundTransparency = 1
    Handle.BorderSizePixel = 0
    Handle.Text = ""
    Handle.AutoButtonColor = false
    Handle.ClipsDescendants = true
    Handle.Active = true
    Handle.Selectable = false
    Handle.ZIndex = 999999
    Handle.Parent = MainFrame

    local Circle = Instance.new("Frame")
    Circle.Name = "BlueQuarterCircle"
    Circle.Size = UDim2.fromOffset(RESIZE_SIZE * 2, RESIZE_SIZE * 2)
    Circle.Position = UDim2.fromOffset(0, 0)
    Circle.BackgroundColor3 = RESIZE_COLOR
    Circle.BackgroundTransparency = 0.7
    Circle.BorderSizePixel = 0
    Circle.ClipsDescendants = true
    Circle.Active = false
    Circle.Selectable = false
    Circle.ZIndex = 999999
    Circle.Parent = Handle

    local Round = Instance.new("UICorner")
    Round.CornerRadius = UDim.new(1, 0)
    Round.Parent = Circle

    local Outline = Instance.new("UIStroke")
    Outline.Color = Color3.fromRGB(0, 0, 0)
    Outline.Thickness = 1.5
    Outline.Transparency = 0.7
    Outline.Parent = Circle

    local LINE_COUNT = 10
    local LINE_THICKNESS = 1
    local LINE_TRANSPARENCY = 0.65
    local LINE_ANIMATION_TIME = 1.8
    local LINE_STAGGER = 0.12

    for i = 1, LINE_COUNT do
        local Line = Instance.new("Frame")
        Line.Name = "AnimatedResizeLine_" .. i
        Line.AnchorPoint = Vector2.new(0.5, 0.5)
        Line.Size = UDim2.new(1.8, 0, 0, LINE_THICKNESS)
        local LineY = 3 + ((i - 1) * 6)
        Line.Position = UDim2.fromOffset(-45, LineY)
        Line.Rotation = 45
        Line.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Line.BackgroundTransparency = LINE_TRANSPARENCY
        Line.BorderSizePixel = 0
        Line.Active = false
        Line.ZIndex = 1000000
        Line.Parent = Circle

        task.spawn(function()
            task.wait((i - 1) * LINE_STAGGER)
            while Line.Parent and Circle.Parent do
                Line.Position = UDim2.fromOffset(-45, LineY)
                local Tween = TweenService:Create(Line,
                    TweenInfo.new(LINE_ANIMATION_TIME, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut),
                    {Position = UDim2.fromOffset(45, LineY)})
                Tween:Play()
                Tween.Completed:Wait()
                if not Line.Parent or not Circle.Parent then break end
                task.wait(0.05)
            end
        end)
    end

    ResizeHandle = Handle

    local Resizing = false
    local StartInput
    local StartWidth
    local StartHeight
    local ActiveTouch
    local ActiveInputType

    local function SetResizeInputLock(Value)
        ResizingWindow = Value
        if InputBlocker then InputBlocker.Visible = Value end
        ToggleButton.Active = not Value
        LockButton.Active = not Value
        for _, Zone in ipairs(DragZones) do
            Zone.Active = not Value and not UILocked
        end
    end

    Handle.InputBegan:Connect(function(Input)
        if UILocked or not UIVisible or Resizing then return end
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.Touch then return end

        Resizing = true
        SetResizeInputLock(true)
        StartInput = Input.Position
        ActiveInputType = Input.UserInputType
        if ActiveInputType == Enum.UserInputType.Touch then ActiveTouch = Input end

        local CurrentScale = UI_SCALE
        if Scale and Scale.Scale > 0 then CurrentScale = Scale.Scale end
        StartWidth = MainFrame.AbsoluteSize.X / CurrentScale
        StartHeight = MainFrame.AbsoluteSize.Y / CurrentScale
    end)

    local MoveConnection = UserInputService.InputChanged:Connect(function(Input)
        if not Resizing or UILocked or not MainFrame then return end
        local IsMouseMove = ActiveInputType == Enum.UserInputType.MouseButton1
            and Input.UserInputType == Enum.UserInputType.MouseMovement
        local IsTouchMove = ActiveInputType == Enum.UserInputType.Touch
            and Input.UserInputType == Enum.UserInputType.Touch
            and Input == ActiveTouch

        if not IsMouseMove and not IsTouchMove then return end

        local CurrentScale = UI_SCALE
        if Scale and Scale.Scale > 0 then CurrentScale = Scale.Scale end
        local Delta = Input.Position - StartInput
        local NewWidth = math.max(MIN_WIDTH, StartWidth + Delta.X / CurrentScale)
        local NewHeight = math.max(MIN_HEIGHT, StartHeight + Delta.Y / CurrentScale)
        MainFrame.Size = UDim2.fromOffset(NewWidth, NewHeight)
    end)

    local EndConnection = UserInputService.InputEnded:Connect(function(Input)
        local IsMouseRelease = ActiveInputType == Enum.UserInputType.MouseButton1
            and Input.UserInputType == Enum.UserInputType.MouseButton1
        local IsTouchRelease = ActiveInputType == Enum.UserInputType.Touch
            and Input.UserInputType == Enum.UserInputType.Touch
            and Input == ActiveTouch

        if IsMouseRelease or IsTouchRelease then
            Resizing = false
            ActiveTouch = nil
            ActiveInputType = nil
            SetResizeInputLock(false)
        end
    end)

    table.insert(DragConnections, MoveConnection)
    table.insert(DragConnections, EndConnection)
    return Handle
end

-- DRAG ZONES
local function CreateDragZone(Name, Size, Position, ZIndex)
    if not MainFrame then return end

    local Zone = Instance.new("TextButton")
    Zone.Name = "CloudDragZone_" .. Name
    Zone.Size = Size
    Zone.Position = Position
    Zone.BackgroundTransparency = 1
    Zone.BorderSizePixel = 0
    Zone.Text = ""
    Zone.AutoButtonColor = false
    Zone.Active = true
    Zone.Selectable = false
    Zone.ZIndex = ZIndex or 450
    Zone.Parent = MainFrame

    table.insert(DragZones, Zone)

    local Dragging = false
    local DragStart
    local StartPosition
    local ActiveTouch

    Zone.InputBegan:Connect(function(Input)
        if UILocked or not UIVisible or ResizingWindow then return end
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.Touch then return end
        if IsOverResizeHandle(Input.Position) then return end

        Dragging = true
        DragStart = Input.Position
        StartPosition = MainFrame.Position
        if Input.UserInputType == Enum.UserInputType.Touch then ActiveTouch = Input end
    end)

    local MoveConnection = UserInputService.InputChanged:Connect(function(Input)
        if not Dragging or UILocked or ResizingWindow then return end
        local MouseMove = Input.UserInputType == Enum.UserInputType.MouseMovement
        local TouchMove = Input.UserInputType == Enum.UserInputType.Touch and Input == ActiveTouch
        if not MouseMove and not TouchMove then return end

        local Delta = Input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end)

    local EndConnection = UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or (Input.UserInputType == Enum.UserInputType.Touch and Input == ActiveTouch) then
            Dragging = false
            ActiveTouch = nil
        end
    end)

    table.insert(DragConnections, MoveConnection)
    table.insert(DragConnections, EndConnection)
    return Zone
end

-- CREATE DRAG ZONES AND RESIZER
if MainFrame then
    for _, Obj in ipairs(MainFrame:GetChildren()) do
        if Obj.Name:match("^CloudDragZone_") or Obj.Name == "CloudCustomResize" then
            Obj:Destroy()
        end
    end

    CreateDragZone("Title",
        UDim2.new(1, -RESIZE_SIZE, 0, TITLE_DRAG_HEIGHT),
        UDim2.new(0, 0, 0, 0), 450)
    CreateDragZone("Left",
        UDim2.new(0, EDGE_DRAG_WIDTH, 1, -TITLE_DRAG_HEIGHT - BOTTOM_DRAG_HEIGHT),
        UDim2.new(0, 0, 0, TITLE_DRAG_HEIGHT), 450)
    CreateDragZone("Right",
        UDim2.new(0, EDGE_DRAG_WIDTH, 1, -TITLE_DRAG_HEIGHT - BOTTOM_DRAG_HEIGHT),
        UDim2.new(1, -EDGE_DRAG_WIDTH, 0, TITLE_DRAG_HEIGHT), 450)
    CreateDragZone("Bottom",
        UDim2.new(1, -RESIZE_SIZE, 0, BOTTOM_DRAG_HEIGHT),
        UDim2.new(0, 0, 1, -BOTTOM_DRAG_HEIGHT), 450)

    CreateResizeHandle()
end

UpdateLockButton()

-- ============================================================
-- COMBAT TAB -- SUBTABS
-- ============================================================

local AimbotSubTab  = CombatTab:SubPage({Name = "Aimbot"})
local SilentSubTab  = CombatTab:SubPage({Name = "Silent Aim"})
local TriggerSubTab = CombatTab:SubPage({Name = "Triggerbot"})
local RagebotSubTab = CombatTab:SubPage({Name = "Ragebot"})
local WeaponsSubTab = CombatTab:SubPage({Name = "Weapons"})
local TargetSubTab  = CombatTab:SubPage({Name = "Targeting"})

-- ---- AIMBOT ----
local AimSection = AimbotSubTab:Section({Name = "Aimbot", Side = 1})
do
    AimSection:Toggle({
        Name = "Enable",
        Flag = "aimbot_enable",
        Default = false,
        Tooltip = "Toggle aimbot on/off",
        Callback = function(v) end
    }):Keybind({
        Name = "Aimbot Key",
        Flag = "aimbot_keybind",
        Default = Enum.KeyCode.Q,
        Callback = function(v) end
    })

    AimSection:Toggle({
        Name = "Show FOV",
        Flag = "aimbot_show_fov_enable",
        Default = false,
        Tooltip = "Draw FOV circle on screen",
        Callback = function(v) end
    })

    AimSection:Toggle({
        Name = "Show FOV Fill",
        Flag = "aimbot_show_fill_enable",
        Default = false,
        Tooltip = "Fill FOV circle",
        Callback = function(v) end
    })

    AimSection:Toggle({
        Name = "Follow Gunpoint",
        Flag = "aimbot_follow_gunpoint",
        Default = false,
        Tooltip = "Aim from gun barrel",
        Callback = function(v) end
    })

    AimSection:Toggle({
        Name = "Follow Target",
        Flag = "aimbot_follow_target",
        Default = false,
        Tooltip = "Predict target movement",
        Callback = function(v) end
    })

    AimSection:Toggle({
        Name = "Closest Part",
        Flag = "aimbot_closest_part",
        Default = false,
        Tooltip = "Aim at closest hit part",
        Callback = function(v) end
    })

    AimSection:Slider({
        Name = "FOV Radius",
        Flag = "aimbot_fov_radius",
        Min = 10,
        Max = 500,
        Default = 150,
        Suffix = "px",
        Decimals = 0,
        Callback = function(v) end
    })

    AimSection:Slider({
        Name = "FOV Transparency",
        Flag = "aimbot_fov_transparency",
        Min = 0,
        Max = 1,
        Default = 0.5,
        Suffix = "",
        Decimals = 1,
        Callback = function(v) end
    })

    AimSection:Slider({
        Name = "FOV Thickness",
        Flag = "aimbot_fov_thickness",
        Min = 1,
        Max = 10,
        Default = 1,
        Suffix = "px",
        Decimals = 0,
        Callback = function(v) end
    })

    AimSection:Slider({
        Name = "Fill Transparency",
        Flag = "aimbot_fill_transparency",
        Min = 0,
        Max = 1,
        Default = 0.8,
        Suffix = "",
        Decimals = 1,
        Callback = function(v) end
    })

    AimSection:Slider({
        Name = "Rotation Speed",
        Flag = "aimbot_rotation_speed",
        Min = 1,
        Max = 100,
        Default = 50,
        Suffix = "",
        Decimals = 0,
        Callback = function(v) end
    })

    AimSection:Slider({
        Name = "Smoothing",
        Flag = "aimbot_smoothing",
        Min = 0,
        Max = 1,
        Default = 0.1,
        Suffix = "",
        Decimals = 2,
        Callback = function(v) end
    })

    AimSection:Slider({
        Name = "Lerp",
        Flag = "aimbot_lerp",
        Min = 0,
        Max = 1,
        Default = 0.2,
        Suffix = "",
        Decimals = 2,
        Callback = function(v) end
    })
end

-- ---- SILENT AIM ----
local SilentSection = SilentSubTab:Section({Name = "Silent Aim", Side = 1})
do
    SilentSection:Toggle({
        Name = "Enable",
        Flag = "silent_aim_enable",
        Default = false,
        Tooltip = "Raycast-redirect silent aim",
        Callback = function(v) end
    }):Keybind({
        Name = "Silent Aim Key",
        Flag = "silent_aim_keybind",
        Default = Enum.KeyCode.Unknown,
        Callback = function(v) end
    })

    SilentSection:Toggle({
        Name = "Closest Part",
        Flag = "closest_part_enable",
        Default = false,
        Callback = function(v) end
    })

    SilentSection:Toggle({
        Name = "Visualize",
        Flag = "silent_aim_visualize",
        Default = false,
        Callback = function(v) end
    })

    SilentSection:Toggle({
        Name = "Show FOV",
        Flag = "show_fov_enable",
        Default = false,
        Callback = function(v) end
    })

    SilentSection:Toggle({
        Name = "Show Fill",
        Flag = "show_fill_enable",
        Default = false,
        Callback = function(v) end
    })

    SilentSection:Toggle({
        Name = "Follow Gunpoint",
        Flag = "silent_aim_follow_gunpoint",
        Default = false,
        Callback = function(v) end
    })

    SilentSection:Toggle({
        Name = "Follow Target",
        Flag = "silent_aim_follow_target",
        Default = false,
        Callback = function(v) end
    })

    SilentSection:Slider({
        Name = "FOV Radius",
        Flag = "silent_aim_fov_radius",
        Min = 10,
        Max = 500,
        Default = 150,
        Suffix = "px",
        Decimals = 0,
        Callback = function(v) end
    })

    SilentSection:Slider({
        Name = "FOV Transparency",
        Flag = "silent_aim_fov_transparency",
        Min = 0,
        Max = 1,
        Default = 0.5,
        Suffix = "",
        Decimals = 1,
        Callback = function(v) end
    })

    SilentSection:Slider({
        Name = "FOV Thickness",
        Flag = "silent_aim_fov_thickness",
        Min = 1,
        Max = 10,
        Default = 1,
        Suffix = "px",
        Decimals = 0,
        Callback = function(v) end
    })

    SilentSection:Slider({
        Name = "Fill Transparency",
        Flag = "silent_aim_fill_transparency",
        Min = 0,
        Max = 1,
        Default = 0.8,
        Suffix = "",
        Decimals = 1,
        Callback = function(v) end
    })

    SilentSection:Slider({
        Name = "Rotation Speed",
        Flag = "silent_aim_rotation_speed",
        Min = 1,
        Max = 100,
        Default = 50,
        Suffix = "",
        Decimals = 0,
        Callback = function(v) end
    })

    SilentSection:Slider({
        Name = "Hit Chance %",
        Flag = "silent_aim_hit_chance",
        Min = 1,
        Max = 100,
        Default = 100,
        Suffix = "%",
        Decimals = 0,
        Callback = function(v) end
    })

    SilentSection:Slider({
        Name = "Lerp",
        Flag = "silent_aim_lerp",
        Min = 0,
        Max = 1,
        Default = 0.2,
        Suffix = "",
        Decimals = 2,
        Callback = function(v) end
    })
end

-- ---- TRIGGERBOT ----
local TrigSection = TriggerSubTab:Section({Name = "Triggerbot", Side = 1})
do
    TrigSection:Toggle({
        Name = "Enable",
        Flag = "triggerbot_enable",
        Default = false,
        Tooltip = "Auto-shoot on target",
        Callback = function(v) end
    }):Keybind({
        Name = "Triggerbot Key",
        Flag = "triggerbot_keybind",
        Default = Enum.KeyCode.Unknown,
        Callback = function(v) end
    })

    TrigSection:Toggle({
        Name = "Team Check",
        Flag = "triggerbot_team_check",
        Default = true,
        Callback = function(v) end
    })

    TrigSection:Slider({
        Name = "Reaction Time",
        Flag = "triggerbot_reaction_time",
        Min = 0,
        Max = 500,
        Default = 50,
        Suffix = "ms",
        Decimals = 0,
        Callback = function(v) end
    })

    TrigSection:Slider({
        Name = "Shoot Delay",
        Flag = "triggerbot_shoot_delay",
        Min = 0,
        Max = 500,
        Default = 0,
        Suffix = "ms",
        Decimals = 0,
        Callback = function(v) end
    })

    TrigSection:Slider({
        Name = "Max Distance",
        Flag = "triggerbot_max_distance",
        Min = 10,
        Max = 2000,
        Default = 500,
        Suffix = "st",
        Decimals = 0,
        Callback = function(v) end
    })
end

-- ---- RAGEBOT ----
local RageSection = RagebotSubTab:Section({Name = "Ragebot", Side = 1})
do
    RageSection:Label({Name = "Warning: Ragebot may be detected"})

    RageSection:Toggle({
        Name = "Enable",
        Flag = "ragebot_enable",
        Default = false,
        Tooltip = "Toggle ragebot",
        Callback = function(v) end
    }):Keybind({
        Name = "Ragebot Key",
        Flag = "ragebot_keybind",
        Default = Enum.KeyCode.Unknown,
        Callback = function(v) end
    })

    RageSection:Toggle({
        Name = "FFA Mode",
        Flag = "ragebot_ffa_mode",
        Default = false,
        Callback = function(v) end
    })

    RageSection:Toggle({
        Name = "Prediction",
        Flag = "ragebot_prediction",
        Default = false,
        Callback = function(v) end
    })

    RageSection:Slider({
        Name = "Prediction Amount",
        Flag = "ragebot_prediction_amount",
        Min = 0,
        Max = 10,
        Default = 1,
        Suffix = "",
        Decimals = 1,
        Callback = function(v) end
    })

    RageSection:Slider({
        Name = "Offset X",
        Flag = "ragebot_x",
        Min = -5,
        Max = 5,
        Default = 0,
        Suffix = "",
        Decimals = 1,
        Callback = function(v) end
    })

    RageSection:Slider({
        Name = "Offset Y",
        Flag = "ragebot_y",
        Min = -5,
        Max = 5,
        Default = 0,
        Suffix = "",
        Decimals = 1,
        Callback = function(v) end
    })

    RageSection:Slider({
        Name = "Offset Z",
        Flag = "ragebot_z",
        Min = -5,
        Max = 5,
        Default = 0,
        Suffix = "",
        Decimals = 1,
        Callback = function(v) end
    })
end

-- ---- WEAPONS ----
local GunsSection = WeaponsSubTab:Section({Name = "Gun Mods", Side = 1})
do
    GunsSection:Toggle({
        Name = "No Muzzle Flash",
        Flag = "no_muzzle_flash_enable",
        Default = false,
        Callback = function(v) end
    })

    GunsSection:Toggle({
        Name = "No Spread",
        Flag = "no_spread_enable",
        Default = false,
        Callback = function(v) end
    })
end

-- ---- TARGETING ----
local TargetSection = TargetSubTab:Section({Name = "Targeting", Side = 1})
do
    TargetSection:Toggle({
        Name = "Visible Only",
        Flag = "visible_only_enable",
        Default = false,
        Callback = function(v) end
    })

    TargetSection:Toggle({
        Name = "Auto Shoot",
        Flag = "auto_shoot_enable",
        Default = false,
        Callback = function(v) end
    })

    TargetSection:Toggle({
        Name = "Anti Katana",
        Flag = "anti_katana_enable",
        Default = false,
        Callback = function(v) end
    })

    TargetSection:Toggle({
        Name = "Anti Riot Shield",
        Flag = "anti_riot_shield_enable",
        Default = false,
        Callback = function(v) end
    })

    TargetSection:Dropdown({
        Name = "Hit Part",
        Flag = "targeting_hit_part",
        Default = "Head",
        Items = {"Head", "Torso", "Random", "Closest"},
        Callback = function(v) end
    })

    TargetSection:Slider({
        Name = "Max Distance",
        Flag = "max_distance",
        Min = 10,
        Max = 2000,
        Default = 500,
        Suffix = "st",
        Decimals = 0,
        Callback = function(v) end
    })
end

-- ============================================================
-- ESP TAB
-- ============================================================

local ESPSection      = ESPTab:Section({Name = "Player ESP", Side = 1})
local ESPColSection   = ESPTab:Section({Name = "ESP Colors", Side = 2})
local ThrowSection    = ESPTab:Section({Name = "Throwable ESP", Side = 1})

do
    -- main toggles
    ESPSection:Toggle({
        Name = "Enable",
        Flag = "esp_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Team Check",
        Flag = "esp_team_check",
        Default = true,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Box",
        Flag = "esp_box_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Glow",
        Flag = "esp_glow_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Name",
        Flag = "esp_name_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Studs Distance",
        Flag = "esp_studs_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Tool",
        Flag = "esp_tool_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Dropdown({
        Name = "Tool Position",
        Flag = "esp_tool_position",
        Default = "Bottom",
        Items = {"Bottom", "Top", "Left", "Right"},
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Filled Box",
        Flag = "esp_filled_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Filled Hit Flash",
        Flag = "esp_filled_hitflash",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Filled Animated",
        Flag = "esp_filled_animated",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Visible Check",
        Flag = "esp_visible_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Highlight",
        Flag = "esp_highlight_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Health Bar",
        Flag = "esp_health_enable",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Text Gradient",
        Flag = "esp_text_gradient",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Toggle({
        Name = "Text Flow",
        Flag = "esp_text_flow",
        Default = false,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Glow Transparency",
        Flag = "esp_glow_transparency",
        Min = 0, Max = 1, Default = 0.5,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Box Thickness",
        Flag = "esp_box_thickness",
        Min = 1, Max = 5, Default = 1,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Highlight Fill Alpha",
        Flag = "esp_highlight_fill_transparency",
        Min = 0, Max = 1, Default = 0.5,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Highlight Outline Alpha",
        Flag = "esp_highlight_outline_transparency",
        Min = 0, Max = 1, Default = 0.5,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Filled Transparency",
        Flag = "esp_filled_transparency",
        Min = 0, Max = 1, Default = 0.7,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Filled Rotation",
        Flag = "esp_filled_rotation",
        Min = 0, Max = 360, Default = 0,
        Suffix = "°", Decimals = 0,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Filled Speed",
        Flag = "esp_filled_speed",
        Min = 0.1, Max = 10, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Health Bar Width",
        Flag = "esp_health_width",
        Min = 1, Max = 10, Default = 2,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Health Bar Gap",
        Flag = "esp_health_gap",
        Min = 0, Max = 20, Default = 2,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Text Size",
        Flag = "esp_text_size",
        Min = 8, Max = 24, Default = 13,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Text Flow Speed",
        Flag = "esp_text_flow_speed",
        Min = 0.1, Max = 5, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    ESPSection:Slider({
        Name = "Max Distance",
        Flag = "esp_max_dist",
        Min = 10, Max = 2000, Default = 500,
        Suffix = "st", Decimals = 0,
        Callback = function(v) end
    })
end

-- throwable esp
do
    ThrowSection:Toggle({
        Name = "Enable",
        Flag = "thrower_esp_enable",
        Default = false,
        Callback = function(v) end
    })

    ThrowSection:Toggle({
        Name = "Show Name",
        Flag = "thrower_esp_name",
        Default = false,
        Callback = function(v) end
    })

    ThrowSection:Toggle({
        Name = "Show Distance",
        Flag = "thrower_esp_distance",
        Default = false,
        Callback = function(v) end
    })

    ThrowSection:Toggle({
        Name = "Show Image",
        Flag = "thrower_esp_image",
        Default = false,
        Callback = function(v) end
    })

    ThrowSection:Slider({
        Name = "Name Size",
        Flag = "thrower_esp_name_size",
        Min = 8, Max = 24, Default = 13,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    ThrowSection:Slider({
        Name = "Distance Size",
        Flag = "thrower_esp_distance_size",
        Min = 8, Max = 24, Default = 13,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    ThrowSection:Dropdown({
        Name = "Filter",
        Flag = "thrower_esp_select",
        Default = "All",
        Items = {"All", "Grenades", "Traps", "Other"},
        Callback = function(v) end
    })

    ThrowSection:Dropdown({
        Name = "Font",
        Flag = "thrower_esp_font",
        Default = "Default",
        Items = {"Default", "Monospace", "Bold", "Italic"},
        Callback = function(v) end
    })
end

-- ============================================================
-- VISUALS TAB
-- ============================================================

local ChamsSubTab    = VisualsTab:SubPage({Name = "Chams"})
local VMSubTab       = VisualsTab:SubPage({Name = "Viewmodel"})
local CrosshairSubTab = VisualsTab:SubPage({Name = "Crosshair"})
local HUDSubTab      = VisualsTab:SubPage({Name = "HUD"})
local FXSubTab       = VisualsTab:SubPage({Name = "Effects"})

-- ---- CHAMS ----
local ChamsSection = ChamsSubTab:Section({Name = "Chams", Side = 1})
do
    ChamsSection:Toggle({
        Name = "Enable",
        Flag = "ChamsEnable",
        Default = false,
        Callback = function(v) end
    })

    ChamsSection:Toggle({
        Name = "Team Check",
        Flag = "ChamsTeamCheck",
        Default = true,
        Callback = function(v) end
    })

    ChamsSection:Dropdown({
        Name = "Mode",
        Flag = "ChamsMode",
        Default = "Box",
        Items = {"Box", "Outlined", "Filled"},
        Callback = function(v) end
    })

    ChamsSection:Dropdown({
        Name = "Material",
        Flag = "ChamsMaterial",
        Default = "Neon",
        Items = {"Neon", "Glass", "ForceField", "SmoothPlastic"},
        Callback = function(v) end
    })

    ChamsSection:Toggle({
        Name = "Strip Textures",
        Flag = "ChamsStripTextures",
        Default = false,
        Callback = function(v) end
    })

    ChamsSection:Toggle({
        Name = "Ghost (through walls)",
        Flag = "ChamsGhost",
        Default = false,
        Callback = function(v) end
    })

    ChamsSection:Label({Name = "Fill Color"}):Colorpicker({
        Flag = "ChamsFill",
        Default = Color3.fromRGB(255, 100, 100),
        Callback = function(v) end
    })

    ChamsSection:Label({Name = "Outline Color"}):Colorpicker({
        Flag = "ChamsOutline",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(v) end
    })
end

-- ---- VIEWMODEL ----
local VMSection = VMSubTab:Section({Name = "Viewmodel", Side = 1})
local TracerSection = VMSubTab:Section({Name = "Bullet Tracers", Side = 2})

do
    VMSection:Toggle({
        Name = "Viewmodel Offsets",
        Flag = "viewmodel_offsets",
        Default = false,
        Callback = function(v) end
    })

    VMSection:Slider({
        Name = "Offset X",
        Flag = "viewmodel_offset_x",
        Min = -5, Max = 5, Default = 0,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })

    VMSection:Slider({
        Name = "Offset Y",
        Flag = "viewmodel_offset_y",
        Min = -5, Max = 5, Default = 0,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })

    VMSection:Slider({
        Name = "Offset Z",
        Flag = "viewmodel_offset_z",
        Min = -5, Max = 5, Default = 0,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })
end

do
    TracerSection:Toggle({
        Name = "Enable",
        Flag = "bullet_tracers_enable",
        Default = false,
        Callback = function(v) end
    })

    TracerSection:Toggle({
        Name = "Curved",
        Flag = "bullet_tracers_curve",
        Default = false,
        Callback = function(v) end
    })

    TracerSection:Toggle({
        Name = "Through Walls",
        Flag = "bullet_tracers_through_walls",
        Default = false,
        Callback = function(v) end
    })

    TracerSection:Toggle({
        Name = "Spring Expand",
        Flag = "bullet_tracers_spring_expand",
        Default = false,
        Callback = function(v) end
    })

    TracerSection:Dropdown({
        Name = "Texture",
        Flag = "bullet_tracers_texture",
        Default = "Default",
        Items = {"Default", "Neon", "Sparkle", "Smoke"},
        Callback = function(v) end
    })

    TracerSection:Slider({
        Name = "Curve Height",
        Flag = "bullet_tracers_curve_height",
        Min = 0, Max = 50, Default = 10,
        Suffix = "", Decimals = 0,
        Callback = function(v) end
    })

    TracerSection:Slider({
        Name = "Speed",
        Flag = "bullet_tracers_speed",
        Min = 0.1, Max = 10, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    TracerSection:Slider({
        Name = "Position Lerp Speed",
        Flag = "bullet_tracers_position_lerp_speed",
        Min = 0.01, Max = 1, Default = 0.1,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })

    TracerSection:Slider({
        Name = "Width Start",
        Flag = "bullet_tracers_width0",
        Min = 0.01, Max = 2, Default = 0.1,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })

    TracerSection:Slider({
        Name = "Width End",
        Flag = "bullet_tracers_width1",
        Min = 0.01, Max = 2, Default = 0.05,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })

    TracerSection:Slider({
        Name = "Expand Speed",
        Flag = "bullet_tracers_expand_speed",
        Min = 0.1, Max = 20, Default = 5,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    TracerSection:Slider({
        Name = "Expand Damper",
        Flag = "bullet_tracers_expand_damper",
        Min = 0.1, Max = 5, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })
end

-- ---- CROSSHAIR ----
local CrossSection  = CrosshairSubTab:Section({Name = "Crosshair",  Side = 1})
local CrossLines    = CrosshairSubTab:Section({Name = "Lines",       Side = 2})
local CrossEffects  = CrosshairSubTab:Section({Name = "Effects",     Side = 2})

do
    CrossSection:Toggle({
        Name = "Enable",
        Flag = "CrosshairEnable",
        Default = false,
        Callback = function(v) end
    })

    CrossSection:Dropdown({
        Name = "Style",
        Flag = "CrosshairStyle",
        Default = "Cross",
        Items = {"Cross", "Dot", "Circle", "T-Shape"},
        Callback = function(v) end
    })

    CrossSection:Toggle({
        Name = "Lines",
        Flag = "CrosshairLines",
        Default = true,
        Callback = function(v) end
    })

    CrossSection:Toggle({
        Name = "Outline",
        Flag = "CrosshairOutline",
        Default = false,
        Callback = function(v) end
    })

    CrossSection:Toggle({
        Name = "Top Line",
        Flag = "CrosshairTopLine",
        Default = true,
        Callback = function(v) end
    })

    CrossSection:Toggle({
        Name = "Bottom Line",
        Flag = "CrosshairBottomLine",
        Default = true,
        Callback = function(v) end
    })

    CrossSection:Slider({
        Name = "Rotation",
        Flag = "CrosshairRotation",
        Min = 0, Max = 360, Default = 0,
        Suffix = "°", Decimals = 0,
        Callback = function(v) end
    })

    CrossSection:Slider({
        Name = "Length",
        Flag = "CrosshairLength",
        Min = 1, Max = 50, Default = 10,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    CrossSection:Slider({
        Name = "Thickness",
        Flag = "CrosshairThickness",
        Min = 1, Max = 10, Default = 2,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    CrossSection:Slider({
        Name = "Gap",
        Flag = "CrosshairGap",
        Min = 0, Max = 20, Default = 4,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })
end

do
    CrossLines:Toggle({Name = "Dot",         Flag = "CrosshairDot",         Default = false, Callback = function(v) end})
    CrossLines:Toggle({Name = "Line Outline",Flag = "CrosshairLineOutline",  Default = false, Callback = function(v) end})
    CrossLines:Toggle({Name = "Top",         Flag = "CrosshairTop",         Default = true,  Callback = function(v) end})
    CrossLines:Toggle({Name = "Bottom",      Flag = "CrosshairBottom",      Default = true,  Callback = function(v) end})
    CrossLines:Toggle({Name = "Left",        Flag = "CrosshairLeft",        Default = true,  Callback = function(v) end})
    CrossLines:Toggle({Name = "Right",       Flag = "CrosshairRight",       Default = true,  Callback = function(v) end})
end

do
    CrossEffects:Toggle({
        Name = "Rotating",
        Flag = "CrosshairRotating",
        Default = false,
        Callback = function(v) end
    })

    CrossEffects:Slider({
        Name = "Rotating Speed",
        Flag = "CrosshairRotatingSpeed",
        Min = 1, Max = 500, Default = 60,
        Suffix = "", Decimals = 0,
        Callback = function(v) end
    })

    CrossEffects:Toggle({
        Name = "Spread",
        Flag = "CrosshairSpread",
        Default = false,
        Callback = function(v) end
    })

    CrossEffects:Slider({
        Name = "Spread Scale",
        Flag = "CrosshairSpreadScale",
        Min = 0.1, Max = 5, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    CrossEffects:Toggle({
        Name = "Animation",
        Flag = "CrosshairAnimation",
        Default = false,
        Callback = function(v) end
    })

    CrossEffects:Dropdown({
        Name = "Animation Mode",
        Flag = "CrosshairAnimationMode",
        Default = "Bounce",
        Items = {"Bounce", "Pulse", "Spin", "Fade"},
        Callback = function(v) end
    })
end

-- ---- HUD ----
local HUDSection    = HUDSubTab:Section({Name = "Target HUD", Side = 1})
local DmgSection    = HUDSubTab:Section({Name = "Damage Numbers", Side = 2})

do
    HUDSection:Toggle({
        Name = "Enable",
        Flag = "target_hud_enable",
        Default = false,
        Callback = function(v) end
    })

    HUDSection:Dropdown({
        Name = "Method",
        Flag = "target_hud_method",
        Default = "BillboardGui",
        Items = {"BillboardGui", "Drawing"},
        Callback = function(v) end
    })

    HUDSection:Dropdown({
        Name = "Position",
        Flag = "target_hud_position",
        Default = "Top",
        Items = {"Top", "Bottom", "Left", "Right", "Center"},
        Callback = function(v) end
    })

    HUDSection:Slider({
        Name = "Offset X",
        Flag = "target_hud_offset_x",
        Min = -500, Max = 500, Default = 0,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    HUDSection:Slider({
        Name = "Offset Y",
        Flag = "target_hud_offset_y",
        Min = -500, Max = 500, Default = 0,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    HUDSection:Slider({
        Name = "Scale",
        Flag = "target_hud_scale",
        Min = 0.1, Max = 3, Default = 1,
        Suffix = "x", Decimals = 1,
        Callback = function(v) end
    })
end

do
    DmgSection:Toggle({
        Name = "Enable",
        Flag = "damage_numbers_enable",
        Default = false,
        Callback = function(v) end
    })

    DmgSection:Toggle({
        Name = "Remove In-Game Numbers",
        Flag = "damage_numbers_remove_ingame",
        Default = false,
        Callback = function(v) end
    })

    DmgSection:Dropdown({
        Name = "Color Type",
        Flag = "damage_numbers_color_type",
        Default = "Fixed",
        Items = {"Fixed", "Health Gradient", "Random"},
        Callback = function(v) end
    })

    DmgSection:Dropdown({
        Name = "Font",
        Flag = "damage_numbers_font",
        Default = "GothamBold",
        Items = {"GothamBold", "Code", "RobotoMono", "Arcade"},
        Callback = function(v) end
    })

    DmgSection:Slider({
        Name = "Text Size",
        Flag = "damage_numbers_text_size",
        Min = 8, Max = 36, Default = 16,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    DmgSection:Slider({
        Name = "Rise Speed",
        Flag = "damage_numbers_rise",
        Min = 0.1, Max = 10, Default = 2,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    DmgSection:Slider({
        Name = "Duration",
        Flag = "damage_numbers_duration",
        Min = 0.1, Max = 5, Default = 1,
        Suffix = "s", Decimals = 1,
        Callback = function(v) end
    })
end

-- ---- EFFECTS ----
local DeathSection  = FXSubTab:Section({Name = "Death Effects",    Side = 1})
local TrajSection   = FXSubTab:Section({Name = "Trajectory",       Side = 1})
local BlurSection   = FXSubTab:Section({Name = "Motion Blur",      Side = 2})
local HitsndSection = FXSubTab:Section({Name = "Hitsound",         Side = 2})
local AnimSection   = FXSubTab:Section({Name = "Animations",       Side = 2})

do
    DeathSection:Toggle({
        Name = "Death Effects",
        Flag = "death_effects_enable",
        Default = false,
        Callback = function(v) end
    })

    DeathSection:Dropdown({
        Name = "Effect Type",
        Flag = "death_effects_type",
        Default = "Explosion",
        Items = {"Explosion", "Dissolve", "Implode", "Ragdoll"},
        Callback = function(v) end
    })
end

do
    TrajSection:Toggle({
        Name = "Enable",
        Flag = "trajectory_enable",
        Default = false,
        Callback = function(v) end
    })

    TrajSection:Toggle({
        Name = "All Weapons",
        Flag = "trajectory_all_weapons",
        Default = false,
        Callback = function(v) end
    })

    TrajSection:Slider({
        Name = "Speed",
        Flag = "trajectory_speed",
        Min = 1, Max = 500, Default = 100,
        Suffix = "", Decimals = 0,
        Callback = function(v) end
    })

    TrajSection:Slider({
        Name = "Arc Up",
        Flag = "trajectory_arc_up",
        Min = 0, Max = 50, Default = 5,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })
end

do
    BlurSection:Toggle({
        Name = "Motion Blur",
        Flag = "motion_blur_enable",
        Default = false,
        Callback = function(v) end
    })

    BlurSection:Slider({
        Name = "Intensity",
        Flag = "motion_blur_intensity",
        Min = 0, Max = 1, Default = 0.5,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    BlurSection:Slider({
        Name = "Sensitivity",
        Flag = "motion_blur_sensitivity",
        Min = 0.1, Max = 10, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })
end

do
    HitsndSection:Toggle({
        Name = "Custom Hitsound",
        Flag = "hitsound_enable",
        Default = false,
        Callback = function(v) end
    })

    HitsndSection:Toggle({
        Name = "Disable Default Hitsound",
        Flag = "disable_default_hitsound_enable",
        Default = false,
        Callback = function(v) end
    })

    HitsndSection:Dropdown({
        Name = "Sound",
        Flag = "hitsound_selected",
        Default = "Default",
        Items = {"Default", "Minecraft", "CS:GO", "Skeet", "Quake"},
        Callback = function(v) end
    })

    HitsndSection:Slider({
        Name = "Volume",
        Flag = "hitsound_volume",
        Min = 0, Max = 1, Default = 0.5,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    HitsndSection:Slider({
        Name = "Pitch",
        Flag = "hitsound_pitch",
        Min = 0.1, Max = 5, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })
end

do
    AnimSection:Toggle({
        Name = "Disable Animations",
        Flag = "disable_anims_enable",
        Default = false,
        Callback = function(v) end
    })

    AnimSection:Dropdown({
        Name = "Animation Type",
        Flag = "disable_anims_select",
        Default = "All",
        Items = {"All", "Walk", "Idle", "Jump", "Fall"},
        Callback = function(v) end
    })
end

-- ============================================================
-- WORLD TAB
-- ============================================================

local SkySubTab     = WorldTab:SubPage({Name = "Sky & Color"})
local WeatherSubTab = WorldTab:SubPage({Name = "Weather"})
local ShaderSubTab  = WorldTab:SubPage({Name = "Shaders"})
local QualitySubTab = WorldTab:SubPage({Name = "Quality"})
local CamSubTab     = WorldTab:SubPage({Name = "Camera"})
local TextureSubTab = WorldTab:SubPage({Name = "Textures"})
local RemovalSubTab = WorldTab:SubPage({Name = "Removals"})

-- ---- SKY & COLOR ----
local FogSection  = SkySubTab:Section({Name = "Fog & Lighting",  Side = 1})
local SkySection  = SkySubTab:Section({Name = "Skybox",          Side = 2})
local AtmoSection = SkySubTab:Section({Name = "Atmosphere",      Side = 2})

do
    FogSection:Toggle({Name = "Fog",          Flag = "world_fog",        Default = false, Callback = function(v) end})
    FogSection:Toggle({Name = "Ambient",      Flag = "world_ambient",    Default = false, Callback = function(v) end})
    FogSection:Toggle({Name = "Clock Time",   Flag = "world_clock",      Default = false, Callback = function(v) end})
    FogSection:Toggle({Name = "Brightness",   Flag = "world_brightness", Default = false, Callback = function(v) end})
    FogSection:Toggle({Name = "Exposure",     Flag = "world_exposure",   Default = false, Callback = function(v) end})

    FogSection:Slider({
        Name = "Fog Start",
        Flag = "fog_start",
        Min = 0, Max = 2000, Default = 0,
        Suffix = "st", Decimals = 0,
        Callback = function(v) end
    })

    FogSection:Slider({
        Name = "Clock Time",
        Flag = "clock_time",
        Min = 0, Max = 24, Default = 14,
        Suffix = "h", Decimals = 1,
        Callback = function(v) end
    })

    FogSection:Slider({
        Name = "Brightness",
        Flag = "brightness_level",
        Min = 0, Max = 10, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    FogSection:Slider({
        Name = "Exposure",
        Flag = "exposure_level",
        Min = -5, Max = 5, Default = 0,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })
end

do
    SkySection:Toggle({Name = "Skybox",          Flag = "world_skybox",             Default = false, Callback = function(v) end})
    SkySection:Toggle({Name = "Rotate Skybox",   Flag = "world_skybox_rotate",      Default = false, Callback = function(v) end})
    SkySection:Toggle({Name = "Remove Sun",      Flag = "world_skybox_remove_sun",  Default = false, Callback = function(v) end})
    SkySection:Toggle({Name = "Remove Moon",     Flag = "world_skybox_remove_moon", Default = false, Callback = function(v) end})
    SkySection:Toggle({Name = "Remove Stars",    Flag = "world_skybox_remove_stars",Default = false, Callback = function(v) end})

    SkySection:Dropdown({
        Name = "Skybox Preset",
        Flag = "world_skybox_selected",
        Default = "Default",
        Items = {"Default", "Bliss", "Night City", "Arctic", "Desert"},
        Callback = function(v) end
    })

    SkySection:Dropdown({
        Name = "Rotate Direction",
        Flag = "world_skybox_rotate_direction",
        Default = "CW",
        Items = {"CW", "CCW"},
        Callback = function(v) end
    })

    SkySection:Dropdown({
        Name = "Rotate Method",
        Flag = "world_skybox_rotate_method",
        Default = "CFrame",
        Items = {"CFrame", "Lighting"},
        Callback = function(v) end
    })

    SkySection:Slider({
        Name = "Rotate Speed",
        Flag = "world_skybox_rotate_speed",
        Min = 0.01, Max = 10, Default = 1,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })
end

do
    AtmoSection:Toggle({
        Name = "Custom Atmosphere",
        Flag = "world_atmosphere",
        Default = false,
        Callback = function(v) end
    })

    for _, prop in ipairs({"Density", "Offset", "Glare", "Haze"}) do
        AtmoSection:Slider({
            Name = prop,
            Flag = "world_atmosphere_" .. prop:lower(),
            Min = 0, Max = 1, Default = 0.5,
            Suffix = "", Decimals = 2,
            Callback = function(v) end
        })
    end
end

-- ---- WEATHER ----
local WeatherSection = WeatherSubTab:Section({Name = "Weather", Side = 1})
do
    WeatherSection:Toggle({
        Name = "Enable",
        Flag = "weather_enabled",
        Default = false,
        Callback = function(v) end
    })

    WeatherSection:Dropdown({
        Name = "Type",
        Flag = "weather_type",
        Default = "Rain",
        Items = {"Rain", "Snow", "Fog", "Storm"},
        Callback = function(v) end
    })

    WeatherSection:Slider({
        Name = "Rate",
        Flag = "weather_rate",
        Min = 1, Max = 500, Default = 100,
        Suffix = "", Decimals = 0,
        Callback = function(v) end
    })
end

-- ---- SHADERS ----
local ShaderSection = ShaderSubTab:Section({Name = "Shaders", Side = 1})
do
    ShaderSection:Toggle({Name = "Blur",        Flag = "shader_blur",           Default = false, Callback = function(v) end})
    ShaderSection:Toggle({Name = "Bloom",       Flag = "shader_bloom",          Default = false, Callback = function(v) end})
    ShaderSection:Toggle({Name = "DoF",         Flag = "shader_dof",            Default = false, Callback = function(v) end})
    ShaderSection:Toggle({Name = "Sun Rays",    Flag = "shader_sun_rays",       Default = false, Callback = function(v) end})
    ShaderSection:Toggle({Name = "Saturation",  Flag = "shader_saturation",     Default = false, Callback = function(v) end})

    ShaderSection:Slider({Name = "Blur Size",         Flag = "shader_blur_size",         Min = 0, Max = 56, Default = 24, Suffix = "", Decimals = 0, Callback = function(v) end})
    ShaderSection:Slider({Name = "Bloom Intensity",   Flag = "shader_bloom_intensity",   Min = 0, Max = 1,  Default = 0.5, Suffix = "", Decimals = 2, Callback = function(v) end})
    ShaderSection:Slider({Name = "Bloom Size",        Flag = "shader_bloom_size",        Min = 1, Max = 56, Default = 24, Suffix = "", Decimals = 0, Callback = function(v) end})
    ShaderSection:Slider({Name = "Bloom Threshold",   Flag = "shader_bloom_threshold",   Min = 0, Max = 2,  Default = 0.95, Suffix = "", Decimals = 2, Callback = function(v) end})
    ShaderSection:Slider({Name = "DoF Focus",         Flag = "shader_dof_focus",         Min = 0, Max = 200, Default = 50, Suffix = "", Decimals = 0, Callback = function(v) end})
    ShaderSection:Slider({Name = "DoF Intensity",     Flag = "shader_dof_intensity",     Min = 0, Max = 1,  Default = 0.5, Suffix = "", Decimals = 2, Callback = function(v) end})
    ShaderSection:Slider({Name = "Sun Rays Intensity",Flag = "shader_sun_rays_intensity",Min = 0, Max = 1,  Default = 0.25, Suffix = "", Decimals = 2, Callback = function(v) end})
    ShaderSection:Slider({Name = "Sun Rays Spread",   Flag = "shader_sun_rays_spread",   Min = 0, Max = 1,  Default = 0.5, Suffix = "", Decimals = 2, Callback = function(v) end})
    ShaderSection:Slider({Name = "Saturation Level",  Flag = "shader_saturation_level",  Min = -1, Max = 2, Default = 0, Suffix = "", Decimals = 2, Callback = function(v) end})
    ShaderSection:Slider({Name = "Contrast Level",    Flag = "shader_contrast_level",    Min = -1, Max = 2, Default = 0, Suffix = "", Decimals = 2, Callback = function(v) end})
end

-- ---- QUALITY ----
local QualitySection = QualitySubTab:Section({Name = "Lighting Quality", Side = 1})
do
    QualitySection:Toggle({Name = "Override Technology", Flag = "world_lighting_technology",  Default = false, Callback = function(v) end})
    QualitySection:Toggle({Name = "Global Shadows",      Flag = "world_global_shadows",        Default = false, Callback = function(v) end})
    QualitySection:Toggle({Name = "Env Specular",        Flag = "world_env_specular",          Default = false, Callback = function(v) end})
    QualitySection:Toggle({Name = "Outdoor Ambient",     Flag = "world_outdoor_ambient",       Default = false, Callback = function(v) end})

    QualitySection:Dropdown({
        Name = "Technology Mode",
        Flag = "world_lighting_technology_mode",
        Default = "ShadowMap",
        Items = {"Compatibility", "ShadowMap", "Future"},
        Callback = function(v) end
    })

    QualitySection:Slider({
        Name = "Env Specular Scale",
        Flag = "world_env_specular_scale",
        Min = 0, Max = 1, Default = 0.75,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })
end

-- ---- CAMERA ----
local CamSection = CamSubTab:Section({Name = "Camera", Side = 1})
do
    CamSection:Toggle({
        Name = "Third Person",
        Flag = "third_person_enable",
        Default = false,
        Callback = function(v) end
    })

    CamSection:Toggle({
        Name = "Stretched Res",
        Flag = "stretched_res_enable",
        Default = false,
        Callback = function(v) end
    })

    CamSection:Toggle({
        Name = "FOV Changer",
        Flag = "fov_changer_enable",
        Default = false,
        Callback = function(v) end
    })

    CamSection:Slider({
        Name = "Stretched Amount",
        Flag = "stretched_res_amount",
        Min = 0.1, Max = 3, Default = 1,
        Suffix = "x", Decimals = 1,
        Callback = function(v) end
    })

    CamSection:Slider({
        Name = "FOV",
        Flag = "fov_changer_fov",
        Min = 1, Max = 120, Default = 70,
        Suffix = "°", Decimals = 0,
        Callback = function(v) end
    })
end

-- ---- TEXTURES ----
local TexSection = TextureSubTab:Section({Name = "Textures", Side = 1})
do
    TexSection:Toggle({
        Name = "Custom Textures",
        Flag = "textures_enable",
        Default = false,
        Callback = function(v) end
    })

    TexSection:Toggle({
        Name = "Apply to Viewmodel",
        Flag = "textures_apply_to_viewmodel",
        Default = false,
        Callback = function(v) end
    })

    TexSection:Dropdown({
        Name = "Material",
        Flag = "textures_material",
        Default = "SmoothPlastic",
        Items = {"SmoothPlastic", "Neon", "Glass", "Metal", "Wood"},
        Callback = function(v) end
    })

    TexSection:Label({Name = "Texture Color"}):Colorpicker({
        Flag = "textures_color",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(v) end
    })
end

-- ---- REMOVALS ----
local RemSection = RemovalSubTab:Section({Name = "Removals", Side = 1})
do
    RemSection:Toggle({
        Name = "Anti-Flashbang",
        Flag = "anti_flashbang_enable",
        Default = false,
        Callback = function(v) end
    })
end

-- ============================================================
-- CHARACTER TAB
-- ============================================================

local VMCSubTab    = CharTab:SubPage({Name = "Viewmodel Changer"})
local SkinSubTab   = CharTab:SubPage({Name = "Skin"})
local SpoofSubTab  = CharTab:SubPage({Name = "Spoof"})

-- ---- VMC ----
local VMCMain = VMCSubTab:Section({Name = "Enable", Side = 1})
local VMCBody = VMCSubTab:Section({Name = "Body",   Side = 1})
local VMCItem = VMCSubTab:Section({Name = "Item",   Side = 2})

do
    VMCMain:Toggle({Name = "Enable VMC",           Flag = "vmc_enable",              Default = false, Callback = function(v) end})
    VMCBody:Toggle({Name = "Custom Appearance",    Flag = "vmc_appearance",          Default = false, Callback = function(v) end})
    VMCBody:Toggle({Name = "Body Color",           Flag = "vmc_body_color",          Default = false, Callback = function(v) end})
    VMCBody:Toggle({Name = "Body Material",        Flag = "vmc_body_material",       Default = false, Callback = function(v) end})
    VMCBody:Toggle({Name = "Disable Clothes",      Flag = "vmc_body_disable_clothes",Default = false, Callback = function(v) end})

    VMCBody:Dropdown({
        Name = "Body Material",
        Flag = "vmc_body_material_type",
        Default = "SmoothPlastic",
        Items = {"SmoothPlastic", "Neon", "ForceField", "Glass"},
        Callback = function(v) end
    })

    VMCBody:Slider({
        Name = "Body Transparency",
        Flag = "vmc_body_transparency",
        Min = 0, Max = 1, Default = 0,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    VMCItem:Toggle({Name = "Item Color",    Flag = "vmc_item_color",    Default = false, Callback = function(v) end})
    VMCItem:Toggle({Name = "Item Material", Flag = "vmc_item_material", Default = false, Callback = function(v) end})

    VMCItem:Dropdown({
        Name = "Item Material",
        Flag = "vmc_item_material_type",
        Default = "SmoothPlastic",
        Items = {"SmoothPlastic", "Neon", "ForceField", "Glass"},
        Callback = function(v) end
    })

    VMCItem:Slider({
        Name = "Item Transparency",
        Flag = "vmc_item_transparency",
        Min = 0, Max = 1, Default = 0,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })
end

-- ---- SKIN ----
local SkinSection = SkinSubTab:Section({Name = "Skin", Side = 1})
do
    SkinSection:Toggle({
        Name = "Any Skin Mode",
        Flag = "AnySkinMode",
        Default = false,
        Callback = function(v) end
    })
end

-- ---- SPOOF ----
local SpoofSection  = SpoofSubTab:Section({Name = "Stats Spoof", Side = 1})
local SpoofSection2 = SpoofSubTab:Section({Name = "Name Spoof",  Side = 2})
local SpoofSection3 = SpoofSubTab:Section({Name = "Device",      Side = 2})

do
    SpoofSection:Toggle({Name = "Streak Spoof",  Flag = "streak_spoof_enable", Default = false, Callback = function(v) end})
    SpoofSection:Toggle({Name = "Level Spoof",   Flag = "level_spoof_enable",  Default = false, Callback = function(v) end})
    SpoofSection:Toggle({Name = "Rank Spoof",    Flag = "rank_spoof_enable",   Default = false, Callback = function(v) end})
    SpoofSection:Toggle({Name = "ELO Spoof",     Flag = "elo_spoof_enable",    Default = false, Callback = function(v) end})
    SpoofSection:Toggle({Name = "Other Spoof",   Flag = "SpoofOther",          Default = false, Callback = function(v) end})

    SpoofSection:Dropdown({
        Name = "Rank",
        Flag = "rank_spoof_value",
        Default = "Bronze",
        Items = {"Bronze", "Silver", "Gold", "Platinum", "Diamond", "Elite"},
        Callback = function(v) end
    })

    SpoofSection2:Toggle({
        Name = "Name Spoof",
        Flag = "name_spoof_enable",
        Default = false,
        Callback = function(v) end
    })

    SpoofSection2:Textbox({
        Name = "Spoofed Name",
        Flag = "name_spoof_value",
        Default = "Player",
        Numeric = false,
        Finished = true,
        Callback = function(v) end
    })

    SpoofSection3:Toggle({
        Name = "Device Spoof",
        Flag = "device_spoof_enable",
        Default = false,
        Callback = function(v) end
    })

    SpoofSection3:Dropdown({
        Name = "Device Type",
        Flag = "device_spoof_type",
        Default = "Mobile",
        Items = {"Mobile", "Tablet", "Console", "Desktop"},
        Callback = function(v) end
    })
end

-- ============================================================
-- MISC TAB
-- ============================================================

local AutoSubTab    = MiscTab:SubPage({Name = "Auto"})
local ArcadeSubTab  = MiscTab:SubPage({Name = "Arcade"})
local SoundSubTab   = MiscTab:SubPage({Name = "Sound"})

local AutoSection   = AutoSubTab:Section({Name = "Auto Features",  Side = 1})
local AutoLoadout   = AutoSubTab:Section({Name = "Auto Loadout",   Side = 2})

do
    AutoSection:Toggle({Name = "Auto Vote Map",  Flag = "auto_vote_map_enable",  Default = false, Callback = function(v) end})
    AutoSection:Toggle({Name = "Auto Queue",     Flag = "auto_queue_enable",     Default = false, Callback = function(v) end})
    AutoSection:Toggle({Name = "Auto Respawn",   Flag = "auto_respawn_enable",   Default = false, Callback = function(v) end})

    AutoSection:Dropdown({
        Name = "Vote Map",
        Flag = "auto_vote_map",
        Default = "Any",
        Items = {"Any", "Dust2", "Mirage", "Inferno", "Nuke"},
        Callback = function(v) end
    })

    AutoSection:Dropdown({
        Name = "Queue Mode",
        Flag = "auto_queue_mode",
        Default = "Casual",
        Items = {"Casual", "Ranked", "Team Deathmatch"},
        Callback = function(v) end
    })

    AutoLoadout:Toggle({
        Name = "Auto Loadout",
        Flag = "auto_loadout_enable",
        Default = false,
        Callback = function(v) end
    })

    for _, class in ipairs({"Assault", "Support", "Sniper", "SMG"}) do
        AutoLoadout:Dropdown({
            Name = class .. " Class",
            Flag = "auto_loadout_class_" .. class:lower(),
            Default = "Default",
            Items = {"Default", "Custom1", "Custom2"},
            Callback = function(v) end
        })
    end
end

local ArcadeSection = ArcadeSubTab:Section({Name = "Arcade Server", Side = 1})
do
    ArcadeSection:Toggle({Name = "Grab Drops",   Flag = "grab_drops_enable",    Default = false, Callback = function(v) end})
    ArcadeSection:Toggle({Name = "Auto Respawn", Flag = "auto_respawn_enable",  Default = false, Callback = function(v) end})
end

local SoundSection = SoundSubTab:Section({Name = "Sound Spammer", Side = 1})
do
    SoundSection:Toggle({
        Name = "Sound Spammer",
        Flag = "sound_spammer_enable",
        Default = false,
        Callback = function(v) end
    })

    SoundSection:Dropdown({
        Name = "Sound Type",
        Flag = "sound_spammer_type",
        Default = "Bruh",
        Items = {"Bruh", "Vine Boom", "Airhorn", "Discord", "Windows XP"},
        Callback = function(v) end
    })
end

-- ============================================================
-- OPTIMIZATIONS TAB
-- ============================================================

local BoostSection = OptsTab:Section({Name = "Performance Boost", Side = 1})
local FPSSection   = OptsTab:Section({Name = "FPS Cap",           Side = 2})

do
    BoostSection:Toggle({Name = "No Particles",   Flag = "opt_no_particles",  Default = false, Callback = function(v) end})
    BoostSection:Toggle({Name = "No Shadows",     Flag = "opt_no_shadows",    Default = false, Callback = function(v) end})
    BoostSection:Toggle({Name = "No Post FX",     Flag = "opt_no_postfx",     Default = false, Callback = function(v) end})
    BoostSection:Toggle({Name = "Low Quality",    Flag = "opt_low_quality",   Default = false, Callback = function(v) end})
    BoostSection:Toggle({Name = "No Atmosphere",  Flag = "opt_no_atmosphere", Default = false, Callback = function(v) end})
    BoostSection:Toggle({Name = "No Textures",    Flag = "opt_no_textures",   Default = false, Callback = function(v) end})

    FPSSection:Toggle({
        Name = "FPS Cap",
        Flag = "opt_fps_cap_enable",
        Default = false,
        Callback = function(v) end
    })

    FPSSection:Slider({
        Name = "FPS Limit",
        Flag = "opt_fps_cap",
        Min = 15, Max = 240, Default = 60,
        Suffix = "fps", Decimals = 0,
        Callback = function(v) end
    })

    FPSSection:Label({
        Name = "Note: Raising past 60 on mobile requires FFlag injector + rejoin"
    })
end

-- ============================================================
-- CHARACTER TAB -- MOVEMENT (was missing)
-- ============================================================

local MoveSubTab   = CharTab:SubPage({Name = "Movement"})
local AnimSubTab   = CharTab:SubPage({Name = "Animations"})

local MoveSection  = MoveSubTab:Section({Name = "Movement", Side = 1})
local FlySection   = MoveSubTab:Section({Name = "Fly",      Side = 2})

do
    MoveSection:Toggle({
        Name = "Walkspeed",
        Flag = "walkspeed_enable",
        Default = false,
        Callback = function(v) end
    }):Keybind({
        Name = "Walkspeed Key",
        Flag = "walkspeed_keybind",
        Default = Enum.KeyCode.Unknown,
        Callback = function(v) end
    })

    MoveSection:Slider({
        Name = "Speed Multiplier",
        Flag = "walkspeed_multiplier",
        Min = 0.1, Max = 10, Default = 1.5,
        Suffix = "x", Decimals = 1,
        Callback = function(v) end
    })

    MoveSection:Toggle({
        Name = "Infinite Double Jump",
        Flag = "infinite_double_jump_enable",
        Default = false,
        Callback = function(v) end
    })

    MoveSection:Toggle({
        Name = "Double Jump Height",
        Flag = "double_jump_height_enable",
        Default = false,
        Callback = function(v) end
    })

    MoveSection:Toggle({
        Name = "Auto Slide",
        Flag = "auto_slide_enable",
        Default = false,
        Callback = function(v) end
    })

    MoveSection:Toggle({
        Name = "Slide Boost",
        Flag = "slide_boost_enable",
        Default = false,
        Callback = function(v) end
    }):Keybind({
        Name = "Slide Boost Key",
        Flag = "slide_boost_keybind",
        Default = Enum.KeyCode.Unknown,
        Callback = function(v) end
    })

    MoveSection:Slider({
        Name = "Slide Boost Speed",
        Flag = "slide_boost_spped",
        Min = 1, Max = 200, Default = 50,
        Suffix = "", Decimals = 0,
        Callback = function(v) end
    })
end

do
    FlySection:Toggle({
        Name = "Fly",
        Flag = "fly_enable",
        Default = false,
        Callback = function(v) end
    }):Keybind({
        Name = "Fly Key",
        Flag = "fly_keybind",
        Default = Enum.KeyCode.Unknown,
        Callback = function(v) end
    })

    FlySection:Slider({
        Name = "Fly Speed",
        Flag = "fly_speed_value",
        Min = 1, Max = 500, Default = 50,
        Suffix = "", Decimals = 0,
        Callback = function(v) end
    })
end

-- ---- ANIMATIONS ----
local AnimSection2 = AnimSubTab:Section({Name = "Animations", Side = 1})
do
    AnimSection2:Toggle({
        Name = "Custom Animation",
        Flag = "animation_enable",
        Default = false,
        Callback = function(v) end
    })

    AnimSection2:Dropdown({
        Name = "Animation ID",
        Flag = "animation_droadsa",
        Default = "Default",
        Items = {"Default", "Rthro", "Normal", "Ninja", "Cartoony"},
        Callback = function(v) end
    })

    AnimSection2:Slider({
        Name = "Animation Speed",
        Flag = "animation_speed",
        Min = 0.1, Max = 10, Default = 1,
        Suffix = "x", Decimals = 1,
        Callback = function(v) end
    })
end

-- ============================================================
-- WEAPONS TAB -- MISSING: Force Modifier
-- ============================================================

local ForceSection = WeaponsSubTab:Section({Name = "Force Modifier", Side = 2})
do
    ForceSection:Toggle({
        Name = "Force Modifier",
        Flag = "force_modifier_enable",
        Default = false,
        Callback = function(v) end
    })

    ForceSection:Slider({
        Name = "Force Value",
        Flag = "force_modifier_value",
        Min = 0, Max = 100, Default = 1,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })
end

-- ============================================================
-- VISUALS -- MISSING: Hit Notify
-- ============================================================

local HitNotifySection = HUDSubTab:Section({Name = "Hit Notify", Side = 2})
do
    HitNotifySection:Toggle({
        Name = "Hit Notify",
        Flag = "hit_notify_enable",
        Default = false,
        Callback = function(v) end
    })

    HitNotifySection:Slider({
        Name = "Duration",
        Flag = "hit_notify_duration",
        Min = 0.1, Max = 10, Default = 1,
        Suffix = "s", Decimals = 1,
        Callback = function(v) end
    })

    HitNotifySection:Textbox({
        Name = "Message",
        Flag = "hit_notify_msg",
        Default = "{dmg}",
        Numeric = false,
        Finished = true,
        Callback = function(v) end
    })

    HitNotifySection:Label({Name = "Tokens: {dmg} {hp} {player}"})
end

-- ============================================================
-- WORLD -- MISSING: fog_end, color_shift, env_diffuse, tracer lifetime
-- ============================================================

-- patch fog_end into existing fog section by adding a new side-2 section
local FogExtra = SkySubTab:Section({Name = "Fog End", Side = 2})
do
    FogExtra:Slider({
        Name = "Fog End",
        Flag = "fog_end",
        Min = 0, Max = 10000, Default = 1000,
        Suffix = "st", Decimals = 0,
        Callback = function(v) end
    })

    FogExtra:Toggle({
        Name = "Color Shift Top",
        Flag = "world_color_shift_top",
        Default = false,
        Callback = function(v) end
    })

    FogExtra:Toggle({
        Name = "Color Shift Bottom",
        Flag = "world_color_shift_bottom",
        Default = false,
        Callback = function(v) end
    })
end

-- patch env_diffuse into quality section
local DiffuseSection = QualitySubTab:Section({Name = "Env Diffuse", Side = 2})
do
    DiffuseSection:Toggle({
        Name = "Env Diffuse",
        Flag = "world_env_diffuse",
        Default = false,
        Callback = function(v) end
    })

    DiffuseSection:Slider({
        Name = "Diffuse Scale",
        Flag = "world_env_diffuse_scale",
        Min = 0, Max = 1, Default = 0.75,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })
end

-- patch bullet_tracers_lifetime into tracer section
local TracerExtra = VMSubTab:Section({Name = "Tracer Extras", Side = 2})
do
    TracerExtra:Slider({
        Name = "Lifetime",
        Flag = "bullet_tracers_lifetime",
        Min = 0.1, Max = 10, Default = 1,
        Suffix = "s", Decimals = 1,
        Callback = function(v) end
    })
end

-- ---- VIEWMODEL CHAMS (prefix-based: vm_arm / vm_weapon) ----
local VMChamsSubTab = VisualsTab:SubPage({Name = "VM Chams"})

local function BuildVMChamsSection(SubTab, prefix, labelPrefix, isArms)
    local sec = SubTab:Section({Name = labelPrefix .. " Chams", Side = isArms and 1 or 2})

    sec:Toggle({
        Name = "Enable Chams",
        Flag = prefix .. "_chams_enable",
        Default = false,
        Callback = function(v) end
    }):Colorpicker({
        Flag = prefix .. "_chams_color",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(v) end
    })

    sec:Dropdown({
        Name = "Material",
        Flag = prefix .. "_chams_material",
        Default = "Neon",
        Items = {"Neon", "Glass", "ForceField", "SmoothPlastic"},
        Callback = function(v) end
    })

    sec:Slider({
        Name = "Transparency",
        Flag = prefix .. "_chams_transparency",
        Min = 0, Max = 1, Default = 0,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })

    if isArms then
        sec:Toggle({
            Name = "Invisible Arms",
            Flag = prefix .. "_chams_invisible",
            Default = false,
            Callback = function(v) end
        })
    end

    sec:Toggle({
        Name = "Highlight",
        Flag = prefix .. "_highlight_enable",
        Default = false,
        Callback = function(v) end
    }):Colorpicker({
        Flag = prefix .. "_highlight_color",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(v) end
    })

    sec:Slider({
        Name = "Highlight Fill Alpha",
        Flag = prefix .. "_highlight_fill",
        Min = 0, Max = 1, Default = 0.5,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })

    sec:Slider({
        Name = "Highlight Outline Alpha",
        Flag = prefix .. "_highlight_outline",
        Min = 0, Max = 1, Default = 0,
        Suffix = "", Decimals = 2,
        Callback = function(v) end
    })
end

BuildVMChamsSection(VMChamsSubTab, "vm_arm",    "Arm",    true)
BuildVMChamsSection(VMChamsSubTab, "vm_weapon", "Weapon", false)

-- ============================================================
-- SETTINGS TAB (UI/meta flags -- was entirely missing)
-- ============================================================

local SettingsTab      = Window:Page({Name = "Settings"})

local UISection        = SettingsTab:SubPage({Name = "UI"})
local WidgetSubTab     = SettingsTab:SubPage({Name = "Widgets"})
local NotifySubTab     = SettingsTab:SubPage({Name = "Notifications"})
local LoaderSubTab     = SettingsTab:SubPage({Name = "Loader"})
local ThemeSubTab      = SettingsTab:SubPage({Name = "Theme"})

-- ---- UI SETTINGS ----
local MenuSection      = UISection:Section({Name = "Menu",      Side = 1})
local WatermarkSection = UISection:Section({Name = "Watermark", Side = 2})

do
    MenuSection:Toggle({
        Name = "Menu Blur",
        Flag = "MenuBlurToggle",
        Default = true,
        Callback = function(v) end
    })

    MenuSection:Toggle({
        Name = "Overlay Glow",
        Flag = "OverlayGlowToggle",
        Default = false,
        Callback = function(v) end
    })

    MenuSection:Label({Name = "Glow Color"}):Colorpicker({
        Flag = "OverlayGlowColor",
        Default = Color3.fromRGB(145, 95, 255),
        Callback = function(v) end
    })

    MenuSection:Toggle({
        Name = "Keybind List",
        Flag = "KeybindListToggle",
        Default = true,
        Callback = function(v) end
    })

    MenuSection:Toggle({
        Name = "Show Keybind Menu",
        Flag = "show_keybind_menu",
        Default = false,
        Callback = function(v) end
    })

    MenuSection:Toggle({
        Name = "Anonymous Mode",
        Flag = "AnonymousModeToggle",
        Default = false,
        Tooltip = "Hides your name from watermark",
        Callback = function(v) end
    })

    MenuSection:Label({Name = "Menu Bind"}):Keybind({
        Name = "MenuKeybind",
        Flag = "MenuKeybind",
        Default = Enum.KeyCode.RightShift,
        Callback = function(v) end
    })
end

do
    WatermarkSection:Toggle({
        Name = "Watermark",
        Flag = "WatermarkToggle",
        Default = true,
        Callback = function(v) end
    })

    WatermarkSection:Toggle({
        Name = "Show FPS",
        Flag = "WatermarkFps",
        Default = true,
        Callback = function(v) end
    })

    WatermarkSection:Toggle({
        Name = "Show Ping",
        Flag = "WatermarkPing",
        Default = true,
        Callback = function(v) end
    })

    WatermarkSection:Toggle({
        Name = "Show Time",
        Flag = "WatermarkTime",
        Default = false,
        Callback = function(v) end
    })

    WatermarkSection:Toggle({
        Name = "Show Executor",
        Flag = "WatermarkExecutor",
        Default = false,
        Callback = function(v) end
    })
end

-- ---- WIDGETS ----
local WidgetSection = WidgetSubTab:Section({Name = "Overlay Widgets", Side = 1})
do
    WidgetSection:Toggle({
        Name = "Watermark Widget",
        Flag = "WidgetWatermark",
        Default = false,
        Callback = function(v) end
    })

    WidgetSection:Toggle({
        Name = "Appearance Widget",
        Flag = "WidgetAppearance",
        Default = false,
        Callback = function(v) end
    })

    WidgetSection:Toggle({
        Name = "Radar",
        Flag = "WidgetRadar",
        Default = false,
        Callback = function(v) end
    })

    WidgetSection:Toggle({
        Name = "Player List",
        Flag = "WidgetPlayerList",
        Default = false,
        Callback = function(v) end
    })

    WidgetSection:Toggle({
        Name = "Velocity",
        Flag = "WidgetVelocity",
        Default = false,
        Callback = function(v) end
    })

    WidgetSection:Toggle({
        Name = "Closest Player",
        Flag = "WidgetClosestPlayer",
        Default = false,
        Callback = function(v) end
    })
end

-- ---- NOTIFICATIONS ----
local NotifySection = NotifySubTab:Section({Name = "Notifications", Side = 1})
do
    NotifySection:Toggle({
        Name = "Force Color",
        Flag = "notify_force_color",
        Default = false,
        Callback = function(v) end
    })

    NotifySection:Slider({
        Name = "Position X",
        Flag = "notify_x",
        Min = 0, Max = 2000, Default = 20,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    NotifySection:Slider({
        Name = "Position Y",
        Flag = "notify_y",
        Min = 0, Max = 2000, Default = 20,
        Suffix = "px", Decimals = 0,
        Callback = function(v) end
    })

    NotifySection:Slider({
        Name = "Transparency",
        Flag = "notify_transparency",
        Min = 0, Max = 1, Default = 0,
        Suffix = "", Decimals = 1,
        Callback = function(v) end
    })

    NotifySection:Dropdown({
        Name = "Alignment",
        Flag = "notify_alignment",
        Default = "Left",
        Items = {"Left", "Center", "Right"},
        Callback = function(v) end
    })

    NotifySection:Dropdown({
        Name = "Side",
        Flag = "notify_side",
        Default = "Bottom",
        Items = {"Top", "Bottom"},
        Callback = function(v) end
    })
end

-- ---- LOADER ----
local LoaderSection = LoaderSubTab:Section({Name = "Loader", Side = 1})
do
    LoaderSection:Toggle({
        Name = "Auto Load Config",
        Flag = "auto_load_enable",
        Default = false,
        Callback = function(v) end
    })

    LoaderSection:Toggle({
        Name = "Silent Load",
        Flag = "silent_load_enable",
        Default = false,
        Callback = function(v) end
    })
end

-- ---- THEME ----
local ThemeSection = ThemeSubTab:Section({Name = "Theme Manager", Side = 1})
local SaveSection  = ThemeSubTab:Section({Name = "Config Manager", Side = 2})
do
    ThemeSection:Dropdown({
        Name = "Preset",
        Flag = "ThemeManager_ThemeList",
        Default = "elisium",
        Items = {"elisium", "default", "dark", "light", "midnight"},
        Callback = function(v) end
    })

    ThemeSection:Dropdown({
        Name = "UI Font",
        Flag = "ThemeManager_UIFont",
        Default = "Monospace",
        Items = {"Monospace", "GothamBold", "Code", "Roboto"},
        Callback = function(v) end
    })

    ThemeSection:Dropdown({
        Name = "Custom Themes",
        Flag = "ThemeManager_CustomThemeList",
        Default = "None",
        Items = {"None"},
        Callback = function(v) end
    })

    ThemeSection:Textbox({
        Name = "Custom Theme Name",
        Flag = "ThemeManager_CustomThemeName",
        Default = "my_theme",
        Numeric = false,
        Finished = true,
        Callback = function(v) end
    })

    SaveSection:Dropdown({
        Name = "Config List",
        Flag = "SaveManager_ConfigList",
        Default = "None",
        Items = {"None"},
        Callback = function(v) end
    })

    SaveSection:Textbox({
        Name = "Config Name",
        Flag = "SaveManager_ConfigName",
        Default = "config1",
        Numeric = false,
        Finished = true,
        Callback = function(v) end
    })

    SaveSection:Button()
        :Add("Save Config", function() end)
        :Add("Load Config", function() end)
        :Add("Delete Config", function() end)
end

-- ---- LUA MANAGER ----
local LuaSection = LoaderSubTab:Section({Name = "Lua Manager", Side = 2})
do
    LuaSection:Dropdown({
        Name = "Saved Luas",
        Flag = "lua_list",
        Default = "None",
        Items = {"None"},
        Callback = function(v) end
    })

    LuaSection:Button()
        :Add("Execute Selected", function() end)
        :Add("Refresh List", function() end)
end

-- ---- PLAYER LIST OVERLAY ----
local PlayerListSection = WidgetSubTab:Section({Name = "Player List", Side = 2})
do
    PlayerListSection:Dropdown({
        Name = "Player Status Filter",
        Flag = "PlayerListStatus",
        Default = "All",
        Items = {"All", "Enemy", "Friendly"},
        Callback = function(v) end
    })
end

-- menu_blur (alias used internally by Elisium's settings page)
-- already covered by MenuBlurToggle; this stub keeps the flag present
-- Flag: menu_blur maps to same toggle as MenuBlurToggle

-- ============================================================
-- EXAMPLE SECTION (original kept)
-- ============================================================

local ExampleSection = AimbotSubTab:Section({Name = "Debug / Example", Side = 2})

do
    ExampleSection:Toggle({
        Name = "Toggle",
        Flag = "Toggle",
        Default = false,
        Tooltip = "test tooltip",
        Callback = function(Value)
            print(Value)
        end
    })

    ExampleSection:Button()
        :Add("button a", function() print("a") end)
        :Add("button b", function() print("b") end)

    ExampleSection:Slider({
        Name = "Slider",
        Flag = "Slider",
        Min = 1,
        Max = 100,
        Tooltip = "test tooltip",
        Default = 50,
        Suffix = "%",
        Decimals = 1,
        Callback = function(Value) print(Value) end
    })

    ExampleSection:Dropdown({
        Name = "Dropdown",
        Flag = "Dropdown",
        Tooltip = "test tooltip",
        Default = "Value2",
        Items = {"Value", "Value2", "Value3", "Value4", "Value5", "Value6"},
        Multi = false,
        Callback = function(Value) print(Value) end
    })

    ExampleSection:Divider("divider")

    ExampleSection:Label({Name = "label", Tooltip = "test tooltip"})

    ExampleSection:Label({Name = "picker", Tooltip = "test tooltip"}):Colorpicker({
        Flag = "Colorpicker",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(Value) print(Value) end
    })

    ExampleSection:Label({Name = "picker"}):Keybind({
        Name = "Keybind",
        Flag = "Keybind",
        Default = Enum.KeyCode.X,
        Callback = function(Value) print(Value) end
    })

    ExampleSection:Label({Name = "picker"}):Keybind({
        Name = "Keybind 2",
        Flag = "Keybind 2",
        Default = Enum.KeyCode.X,
        Callback = function(Value) print(Value) end
    })

    ExampleSection:Label({Name = "picker"}):Keybind({
        Name = "Keybind 3",
        Flag = "Keybind 3",
        Default = Enum.KeyCode.X,
        Callback = function(Value) print(Value) end
    })

    ExampleSection:Paragraph({
        Name = "paragraph",
        Tooltip = "test tooltip",
        Description = "paragraph description",
    })

    ExampleSection:RangeSlider({
        Name = "rangee sliderrr",
        Flag = "asdasdas",
        Default = {3, 5},
        Tooltip = "",
        Min = 0.1,
        Max = 10,
        Decimals = 0.1,
        Callback = function(i, v) print(i, v) end
    })

    ExampleSection:Textbox({
        Name = "Textbox",
        Flag = "Textbox",
        Tooltip = "test tooltip",
        Default = "Value",
        Numeric = false,
        Finished = false,
        Callback = function(Value) print(Value) end
    })
end

-- NOTIFICATION
Library:Notification(
    "Elisium UI loaded",
    5,
    ACCENT
)
