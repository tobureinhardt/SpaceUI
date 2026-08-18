local Assets = {
    Functions = {},
    Config = {},
    Notifications = {},
    MainBackground = {},
    Pages = {},
    Dashboard = {},
    SettingsPage = {},
    ArrayList = {},
    Font = {},
    Main = {ToggleVisibility = nil}
}



Assets.Shortcut = {}
local Shortcut = Assets.Shortcut

local SpaceUI

-- ── Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local TextChatService = game:GetService("TextChatService")
local LocalPlayer = Players.LocalPlayer

local info = TweenInfo.new(0.6, Enum.EasingStyle.Exponential)
local DRAG_INFO = TweenInfo.new(0.35, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local RESIZE_INFO = TweenInfo.new(0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

-- ── TopbarPlus Loader (Executor port — Therealtobu/Topbar-Plus-For-Executor)
local function LoadTopbarPlus()
    if SpaceUI.TopbarPlus then return SpaceUI.TopbarPlus end
    local success, Icon = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Therealtobu/Topbar-Plus-For-Executor/main/init.lua"))()
    end)
    if success and Icon then
        SpaceUI.TopbarPlus = Icon
        return Icon
    else
        warn("[SpaceUI/Shortcut] TopbarPlus failed to load:", Icon)
        return nil
    end
end
Shortcut.LoadTopbarPlus = LoadTopbarPlus

-- ── Keycodes List
Shortcut.Keycode = {
    Enum.KeyCode.A, Enum.KeyCode.B, Enum.KeyCode.C, Enum.KeyCode.D, Enum.KeyCode.E,
    Enum.KeyCode.F, Enum.KeyCode.G, Enum.KeyCode.H, Enum.KeyCode.I, Enum.KeyCode.J,
    Enum.KeyCode.K, Enum.KeyCode.L, Enum.KeyCode.M, Enum.KeyCode.N, Enum.KeyCode.O,
    Enum.KeyCode.P, Enum.KeyCode.Q, Enum.KeyCode.R, Enum.KeyCode.S, Enum.KeyCode.T,
    Enum.KeyCode.U, Enum.KeyCode.V, Enum.KeyCode.W, Enum.KeyCode.X, Enum.KeyCode.Y,
    Enum.KeyCode.Z,
    Enum.KeyCode.Zero, Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three,
    Enum.KeyCode.Four, Enum.KeyCode.Five, Enum.KeyCode.Six, Enum.KeyCode.Seven,
    Enum.KeyCode.Eight, Enum.KeyCode.Nine,
    Enum.KeyCode.Semicolon, Enum.KeyCode.Equals, Enum.KeyCode.Comma, Enum.KeyCode.Minus,
    Enum.KeyCode.Period, Enum.KeyCode.Slash, Enum.KeyCode.Backquote, Enum.KeyCode.LeftBracket,
    Enum.KeyCode.BackSlash, Enum.KeyCode.RightBracket, Enum.KeyCode.Quote,
    Enum.KeyCode.KeypadZero, Enum.KeyCode.KeypadOne, Enum.KeyCode.KeypadTwo,
    Enum.KeyCode.KeypadThree, Enum.KeyCode.KeypadFour, Enum.KeyCode.KeypadFive,
    Enum.KeyCode.KeypadSix, Enum.KeyCode.KeypadSeven, Enum.KeyCode.KeypadEight,
    Enum.KeyCode.KeypadNine, Enum.KeyCode.KeypadPeriod, Enum.KeyCode.KeypadDivide,
    Enum.KeyCode.KeypadMultiply, Enum.KeyCode.KeypadMinus, Enum.KeyCode.KeypadPlus,
    Enum.KeyCode.KeypadEnter, Enum.KeyCode.KeypadEquals,
    Enum.KeyCode.Backspace, Enum.KeyCode.Tab, Enum.KeyCode.Clear, Enum.KeyCode.Return,
    Enum.KeyCode.Pause, Enum.KeyCode.Escape, Enum.KeyCode.Space, Enum.KeyCode.Delete,
    Enum.KeyCode.Insert, Enum.KeyCode.Home, Enum.KeyCode.End, Enum.KeyCode.PageUp,
    Enum.KeyCode.PageDown, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left,
    Enum.KeyCode.Right, Enum.KeyCode.LeftShift, Enum.KeyCode.RightShift,
    Enum.KeyCode.LeftControl, Enum.KeyCode.RightControl, Enum.KeyCode.LeftAlt, Enum.KeyCode.RightAlt,
    Enum.KeyCode.LeftMeta, Enum.KeyCode.RightMeta, Enum.KeyCode.CapsLock,
    Enum.KeyCode.NumLock, Enum.KeyCode.ScrollLock,
    Enum.KeyCode.F1, Enum.KeyCode.F2, Enum.KeyCode.F3, Enum.KeyCode.F4,
    Enum.KeyCode.F5, Enum.KeyCode.F6, Enum.KeyCode.F7, Enum.KeyCode.F8,
    Enum.KeyCode.F9, Enum.KeyCode.F10, Enum.KeyCode.F11, Enum.KeyCode.F12,
    Enum.KeyCode.F13, Enum.KeyCode.F14, Enum.KeyCode.F15,
}

-- ── Saving & State Management
local SessionSaved = {
    Shortcuts = {
        ["Action-1"] = "Unlinked(ShortcutService)",
        ["Action-2"] = "Unlinked(ShortcutService)",
        ["Action-3"] = "Unlinked(ShortcutService)",
        ["Action-4"] = "Unlinked(ShortcutService)",
        ["Action-5"] = "Unlinked(ShortcutService)",
        ["Action-6"] = "Unlinked(ShortcutService)",
        ["Action-7"] = "Unlinked(ShortcutService)",
        ["Action-8"] = "Unlinked(ShortcutService)",
    },
    Settings = {
        TopbarEnabled = true,
        Theme = "Dark",
        Keycode = "F4",
        MouseLocked = false,
    }
}

Shortcut.Saving = {}
function Shortcut.Saving:Get(key: string)
    if not SessionSaved[key] then
        if key == "Shortcuts" then
            SessionSaved["Shortcuts"] = {
                ["Action-1"] = "Unlinked(ShortcutService)",
                ["Action-2"] = "Unlinked(ShortcutService)",
                ["Action-3"] = "Unlinked(ShortcutService)",
                ["Action-4"] = "Unlinked(ShortcutService)",
                ["Action-5"] = "Unlinked(ShortcutService)",
                ["Action-6"] = "Unlinked(ShortcutService)",
                ["Action-7"] = "Unlinked(ShortcutService)",
                ["Action-8"] = "Unlinked(ShortcutService)",
            }
        elseif key == "Settings" then
            SessionSaved["Settings"] = {
                TopbarEnabled = true,
                Theme = "Dark",
                Keycode = "F4",
                MouseLocked = false,
            }
        end
    end
    return SessionSaved[key]
end

function Shortcut.Saving.Update(key: string, value: any)
    SessionSaved[key] = value
end

function Shortcut.Saving.ServerGetSession()
    return SessionSaved
end

-- ── CustomShortcuts Registry
local CustomShortcuts = {
    Icons = {
        Unlinked = "rbxassetid://11963369532",
        Unavailable = "rbxassetid://12967414792",
        NoIcon = "rbxassetid://11295287500",
    },
    ShortcutRemoved = Instance.new("BindableEvent"),
    ShortcutAdded = Instance.new("BindableEvent"),
}
Shortcut.CustomShortcuts = CustomShortcuts

local RegisteredShortcuts = {}
local SRShortcuts = {}
local ShortcutCategories = {}

function CustomShortcuts:GetRegisteredShortcuts()
    return RegisteredShortcuts, SRShortcuts
end

function CustomShortcuts:GetSpecificShortcut(name)
    if RegisteredShortcuts[name] then
        for _, item in ipairs(SRShortcuts) do
            if item.Name == name then
                return item
            end
        end
    end
    return nil
end

function CustomShortcuts.GetCategories()
    return ShortcutCategories
end

function CustomShortcuts:RegisterShortcut(name, infoTable)
    if not RegisteredShortcuts[name] then
        RegisteredShortcuts[name] = true
        local category = infoTable.Category or "SHORTCUTSERVICE-UNAVAILABLECATEGORY"
        if not table.find(ShortcutCategories, category) then
            table.insert(ShortcutCategories, category)
        end
        local entry = {
            Name = name,
            Icon = infoTable.Icon or CustomShortcuts.Icons.NoIcon,
            Alias = infoTable.Alias or name,
            Access = infoTable.Access or {"Team"},
            Category = category,
            IsShortcutService = infoTable.ShortcutService or false,
            Callbacks = {
                infoTable.Callback or function()
                    if Assets.Notifications then
                        Assets.Notifications.Send({
                            Description = "Shortcut " .. tostring(name) .. " activated!",
                            Duration = 2.5
                        })
                    end
                end
            }
        }
        table.insert(SRShortcuts, entry)
        CustomShortcuts.ShortcutAdded:Fire(name, infoTable)
    end
    return RegisteredShortcuts[name]
end

function CustomShortcuts:UnregisterShortcut(name)
    if RegisteredShortcuts[name] then
        CustomShortcuts.ShortcutRemoved:Fire(name, RegisteredShortcuts[name])
        RegisteredShortcuts[name] = nil
        for idx, item in ipairs(SRShortcuts) do
            if item.Name == name then
                table.remove(SRShortcuts, idx)
                break
            end
        end
    end
end

function CustomShortcuts:Addcallback(name, callback)
    if RegisteredShortcuts[name] then
        for _, item in ipairs(SRShortcuts) do
            if item.Name == name then
                table.insert(item.Callbacks, callback)
                break
            end
        end
    end
end

-- ── WindowControl Class (Window Drag, Resize, Focus Manager)
local WindowControl = {}
WindowControl.__index = WindowControl

local activeWindows = {}
local baseZIndex = 100

local function clampAxis(axis, minSizeAxis, maxSizeAxis)
    local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    if vp[axis] > minSizeAxis then
        return math.clamp(maxSizeAxis, minSizeAxis, vp[axis])
    else
        return minSizeAxis + 50
    end
end

local function applyFocusVisuals(windowInstance, isFocused)
    local ui = windowInstance.UI
    if not ui then return end
    local frame = ui:FindFirstChild("frame") or ui
    local wc = frame:FindFirstChild("WindowControl")
    local top = wc and wc:FindFirstChild("Top")
    local enable = wc and wc:FindFirstChild("Enable")

    if enable then
        enable.Visible = not isFocused and windowInstance.DisableOthersWhenFocused
    end

    if top then
        local header = top:FindFirstChild("header")
        if header then
            header.TextTransparency = isFocused and 0 or 0.4
        end
    end
end

local function bringToFront(windowInstance)
    for i, win in ipairs(activeWindows) do
        if win == windowInstance then
            table.remove(activeWindows, i)
            break
        end
    end
    table.insert(activeWindows, 1, windowInstance)

    for i, win in ipairs(activeWindows) do
        local isTop = (i == 1)
        if not win.LockedZIndex and win.UI then
            local targetZ = baseZIndex + (#activeWindows - i)
            win.UI.LayoutOrder = targetZ
            win.UI.ZIndex = targetZ
        end
        applyFocusVisuals(win, isTop)
    end
end

function WindowControl:InitFocusLogic()
    local ui = self.UI
    if not ui then return end
    local frame = ui:FindFirstChild("frame") or ui
    local wc = frame:FindFirstChild("WindowControl")
    local enable = wc and wc:FindFirstChild("Enable")

    if enable then
        table.insert(self.Connections, enable.MouseButton1Click:Connect(function()
            bringToFront(self)
        end))
    end
end

function WindowControl:InitDragLogic()
    local ui = self.UI
    if not ui then return end
    local frame = ui:FindFirstChild("frame") or ui
    local wc = frame:FindFirstChild("WindowControl")
    local top = wc and wc:FindFirstChild("Top")
    local protection = wc and wc:FindFirstChild("Interaction_Protection")

    if not top then return end

    local dragging = false
    local dragOffset = Vector2.new()

    table.insert(self.Connections, top.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            if protection then protection.Visible = true end
            bringToFront(self)
            local mousePos = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
            dragOffset = mousePos - top.AbsolutePosition
        end
    end))

    table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if protection then protection.Visible = false end
        end
    end))

    table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
        local screenSize = workspace.CurrentCamera.ViewportSize
        local frameSize = frame.AbsoluteSize
        local mousePos = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
        local newTopLeft = mousePos - dragOffset
        local clamped = Vector2.new(
            math.clamp(newTopLeft.X, 0, screenSize.X - frameSize.X + 100),
            math.clamp(newTopLeft.Y, 0, screenSize.Y - frameSize.Y + 100)
        )
        local finalCenter = clamped + frameSize / 2
        TweenService:Create(ui, DRAG_INFO, {
            Position = UDim2.new(0, finalCenter.X, 0, finalCenter.Y)
        }):Play()
    end))
end

function WindowControl:InitResizeLogic(minSize, maxSize, customResizeInfo)
    local ui = self.UI
    if not ui then return end
    if minSize == maxSize then return end
    local frame = ui:FindFirstChild("frame") or ui
    local wc = frame:FindFirstChild("WindowControl")
    local bottom = wc and wc:FindFirstChild("Bottom")
    local resizeHandle = bottom and bottom:FindFirstChild("Resize")
    if not resizeHandle then return end

    resizeHandle.Visible = true
    local resizeInfo = customResizeInfo or RESIZE_INFO
    local resizing = false
    local startPos = Vector2.new()
    local startSize = UDim2.new()
    local ELASTIC = 45

    table.insert(self.Connections, resizeHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true
            startPos = UserInputService:GetMouseLocation()
            startSize = ui.Size
            bringToFront(self)
        end
    end))

    table.insert(self.Connections, UserInputService.InputEnded:Connect(function(input)
        if not resizing then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = false
            local w = math.clamp(ui.Size.X.Offset, minSize.X, maxSize.X)
            local h = math.clamp(ui.Size.Y.Offset, minSize.Y, maxSize.Y)
            if ui.Size.X.Offset ~= w or ui.Size.Y.Offset ~= h then
                TweenService:Create(ui, DRAG_INFO, {
                    Size = UDim2.new(0, w, 0, h)
                }):Play()
            end
        end
    end))

    table.insert(self.Connections, UserInputService.InputChanged:Connect(function(input)
        if not resizing then return end
        local delta = UserInputService:GetMouseLocation() - startPos
        local rawW = startSize.X.Offset + delta.X * 2
        local rawH = startSize.Y.Offset + delta.Y * 2
        local finalW = math.clamp(rawW, minSize.X - ELASTIC, maxSize.X + ELASTIC)
        local finalH = math.clamp(rawH, minSize.Y - ELASTIC, maxSize.Y + ELASTIC)
        TweenService:Create(ui, resizeInfo, {
            Size = UDim2.new(0, finalW, 0, finalH)
        }):Play()
    end))
end

function WindowControl.new(templateUi, parent, options)
    if not templateUi then
        warn("WindowControl: templateUi is nil")
        return nil
    end
    options = options or {}
    local self = setmetatable({}, WindowControl)
    self.Id = HttpService:GenerateGUID(false)
    self.Connections = {}
    self.DisableOthersWhenFocused = options.DisableOthersWhenFocused or false
    self.LockedZIndex = options.LockedZIndex or false
    self.UI = templateUi:Clone()
    self.UI.Name = "ManagedWindow_" .. self.Id
    self.UI.Parent = parent or templateUi.Parent

    self:InitFocusLogic()
    self:InitDragLogic()

    if options.MinSize and options.MaxSize then
        local min = options.MinSize
        local max = Vector2.new(
            clampAxis("X", min.X, options.MaxSize.X),
            clampAxis("Y", min.Y, options.MaxSize.Y)
        )
        self:InitResizeLogic(min, max, options.ResizeInfo)
    end

    bringToFront(self)
    return self
end

function WindowControl:Destroy()
    for i, win in ipairs(activeWindows) do
        if win == self then
            table.remove(activeWindows, i)
            break
        end
    end
    for _, conn in pairs(self.Connections) do
        conn:Disconnect()
    end
    self.Connections = {}
    if self.UI then
        self.UI:Destroy()
        self.UI = nil
    end
    for i = #activeWindows, 1, -1 do
        local win = activeWindows[i]
        local targetZ = baseZIndex + (#activeWindows - i)
        if win.UI then
            win.UI.LayoutOrder = targetZ
            win.UI.ZIndex = targetZ
        end
        applyFocusVisuals(win, i == 1)
    end
end
Shortcut.WindowControl = WindowControl

-- ── Prompts Class (Context Menu Options Popup)
local Prompts = {}
local IsCAPromptOn = false
local PromptOverride = nil

local function CalculatePromptPosition(ref)
    local mouse = UserInputService:GetMouseLocation()
    local viewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    local padding = 0
    local finalSize = ref.AbsoluteSize
    local overflowY = (mouse.Y + padding + finalSize.Y) > viewportSize.Y
    local overflowX = (mouse.X + padding + finalSize.X) > viewportSize.X
    local rawX = mouse.X + (overflowX and -(finalSize.X + padding) or padding)
    local rawY = mouse.Y + (overflowY and -(finalSize.Y + padding) or padding)
    rawX = math.clamp(rawX, padding, math.max(padding, viewportSize.X - finalSize.X - padding))
    rawY = math.clamp(rawY, padding, math.max(padding, viewportSize.Y - finalSize.Y - padding))
    return Vector2.new(rawX, rawY)
end

function Prompts.PromptOptions(data)
    if not data or not data.Inputs or IsCAPromptOn then return nil end
    if PromptOverride then PromptOverride() end
    IsCAPromptOn = true

    local ui = Shortcut.UI
    if not ui or not ui:FindFirstChild("context_actions") then
        IsCAPromptOn = false
        return nil
    end

    local frame_ContextActions = ui.context_actions
    local ContextActions = frame_ContextActions.UI
    local Replica = frame_ContextActions.Replica
    local CancelBtn = frame_ContextActions:FindFirstChild("Cancel")

    -- Clean old dynamic options while keeping templates inside UIListLayout
    for _, v in pairs(ContextActions.Content:GetChildren()) do
        if not (v:IsA("UIListLayout") or v:IsA("UICorner") or v:IsA("UIPadding")) then
            v:Destroy()
        end
    end
    for _, v in pairs(Replica.Content:GetChildren()) do
        if not (v:IsA("UIListLayout") or v:IsA("UICorner") or v:IsA("UIPadding")) then
            v:Destroy()
        end
    end

    local Proceeded, Cancelled, SelectedOption = false, false, nil
    local connected = {}
    local finishEvent = Instance.new("BindableEvent")

    local function finish(value, cancel)
        if Proceeded or Cancelled then return end
        if cancel then
            Cancelled = true
        else
            SelectedOption = value
            Proceeded = true
        end
        finishEvent:Fire()
    end
    PromptOverride = function() finish(nil, true) end

    local templateStorage = ContextActions.Content:FindFirstChild("UIListLayout")
    local actionTemplate = templateStorage and templateStorage:FindFirstChild("Action")
    local headTemplate = templateStorage and templateStorage:FindFirstChild("head")

    if data.Header and headTemplate then
        local h1 = headTemplate:Clone()
        h1.Text = data.Header
        h1.Visible = true
        h1.Parent = ContextActions.Content
        local h2 = h1:Clone()
        h2.Parent = Replica.Content
    end

    for _, inp in pairs(data.Inputs) do
        local option
        if actionTemplate then
            option = actionTemplate:Clone()
            option.Visible = true
            if option:FindFirstChild("Icon") then
                if inp.Icon then
                    option.Icon.Image = inp.Icon
                    option.Icon.Visible = true
                else
                    option.Icon.Visible = false
                end
            end
            if option:FindFirstChild("TextValue") then
                option.TextValue.Text = inp.Text or ""
            end
        else
            option = Instance.new("ImageButton")
            option.Size = UDim2.new(1, 0, 0, 36)
            option.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
            option.BackgroundTransparency = 0
            local corner = Instance.new("UICorner", option)
            corner.CornerRadius = UDim.new(0, 6)
            local txt = Instance.new("TextLabel", option)
            txt.Name = "TextValue"
            txt.Size = UDim2.new(1, -10, 1, 0)
            txt.Position = UDim2.new(0, 10, 0, 0)
            txt.Text = inp.Text or ""
            txt.TextColor3 = Color3.fromRGB(255, 255, 255)
            txt.TextXAlignment = Enum.TextXAlignment.Left
            txt.BackgroundTransparency = 1
            txt.Font = Enum.Font.SourceSans
            txt.TextSize = 14
        end

        option.Parent = ContextActions.Content
        local repOption = option:Clone()
        repOption.Parent = Replica.Content

        table.insert(connected, option.MouseButton1Click:Connect(function()
            finish(inp.Text)
        end))
    end

    Replica.Visible = true
    RunService.RenderStepped:Wait()
    local calculated = CalculatePromptPosition(Replica)
    Replica.Visible = false

    -- Vị trí đích (điểm dừng cuối của animation trượt lên)
    local targetPos = UDim2.fromOffset(calculated.X, calculated.Y)
    -- Vị trí bắt đầu: lệch xuống dưới 12px so với đích, y hệt bản gốc (rbxmx Prompts.lua)
    -- để tạo hiệu ứng trượt lên (slide-up) kết hợp với fade-in, thay vì đứng yên chỉ fade.
    local startPos = UDim2.fromOffset(calculated.X, calculated.Y + 12)

    frame_ContextActions.Visible = true
    frame_ContextActions.ZIndex = 999999
    ContextActions.Visible = true
    ContextActions.Interactable = true
    ContextActions.Position = startPos
    ContextActions.ImageTransparency = 1
    ContextActions.Content.GroupTransparency = 1

    TweenService:Create(ContextActions, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), { ImageTransparency = 0 }):Play()
    TweenService:Create(ContextActions.Content, TweenInfo.new(0.25, Enum.EasingStyle.Exponential), { GroupTransparency = 0 }):Play()
    TweenService:Create(ContextActions, TweenInfo.new(0.35, Enum.EasingStyle.Exponential), { Position = targetPos }):Play()

    if CancelBtn then
        CancelBtn.Visible = true
        table.insert(connected, CancelBtn.MouseButton1Click:Connect(function()
            finish(nil, true)
        end))
    end

    -- Mouse: đóng ngay khi BẤM XUỐNG (InputBegan) ngoài vùng popup — đúng bản gốc.
    table.insert(connected, frame_ContextActions.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
            local mousePos = UserInputService:GetMouseLocation()
            local absPos = ContextActions.AbsolutePosition
            local absSize = ContextActions.AbsoluteSize
            local isInside = mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X
                and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y
            if not isInside then
                finish(nil, true)
            end
        end
    end))

    table.insert(connected, frame_ContextActions.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            local pos = input.Position
            local absPos = ContextActions.AbsolutePosition
            local absSize = ContextActions.AbsoluteSize
            local inside = pos.X >= absPos.X and pos.X <= absPos.X + absSize.X
                and pos.Y >= absPos.Y and pos.Y <= absPos.Y + absSize.Y
            if not inside then
                finish(nil, true)
            end
        end
    end))

    finishEvent.Event:Wait()
    PromptOverride = nil
    finishEvent:Destroy()
    ContextActions.Interactable = false

    for _, signal in pairs(connected) do
        signal:Disconnect()
    end
    table.clear(connected)

    TweenService:Create(ContextActions, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { ImageTransparency = 1 }):Play()
    TweenService:Create(ContextActions.Content, TweenInfo.new(0.2, Enum.EasingStyle.Exponential), { GroupTransparency = 1 }):Play()
    TweenService:Create(ContextActions, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), { Position = startPos }):Play()
    task.delay(0.2, function()
        ContextActions.Visible = false
        frame_ContextActions.Visible = false
        IsCAPromptOn = false
    end)

    if Proceeded then return SelectedOption end
    return nil
end
Shortcut.Prompts = Prompts

-- ── UI Builder for Shortcuts ScreenGui
function Shortcut.BuildUI(parentGui)
    local ShortcutsGui = Instance.new("ScreenGui")
    ShortcutsGui.Name = "Shortcuts"
    ShortcutsGui.ResetOnSpawn = false
    ShortcutsGui.DisplayOrder = 9999
    ShortcutsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local NODE = {}
    
    NODE[1] = Instance.new("Frame")
    NODE[1].Name = "context_actions"
    NODE[1].Active = false
    NODE[1].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[1].AutomaticSize = Enum.AutomaticSize.None
    NODE[1].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[1].BackgroundTransparency = 1
    NODE[1].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[1].BorderMode = Enum.BorderMode.Outline
    NODE[1].BorderSizePixel = 0
    NODE[1].ClipsDescendants = false
    NODE[1].Interactable = true
    NODE[1].LayoutOrder = 0
    NODE[1].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[1].Rotation = 0
    NODE[1].Selectable = false
    NODE[1].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[1].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[1].Visible = true
    NODE[1].ZIndex = 999999999
    NODE[2] = Instance.new("ImageLabel")
    NODE[2].Name = "UI"
    NODE[2].Image = "rbxassetid://109207734544898"
    NODE[2].ImageColor3 = Color3.fromRGB(0, 0, 0)
    NODE[2].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[2].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[2].ImageTransparency = 0
    NODE[2].ResampleMode = Enum.ResamplerMode.Default
    NODE[2].ScaleType = Enum.ScaleType.Slice
    NODE[2].SliceCenter = Rect.new(300, 300, 300, 300)
    NODE[2].SliceScale = 0.150000006
    NODE[2].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[2].Active = false
    NODE[2].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[2].AutomaticSize = Enum.AutomaticSize.XY
    NODE[2].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[2].BackgroundTransparency = 1
    NODE[2].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[2].BorderMode = Enum.BorderMode.Outline
    NODE[2].BorderSizePixel = 0
    NODE[2].ClipsDescendants = false
    NODE[2].Interactable = true
    NODE[2].LayoutOrder = 0
    NODE[2].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[2].Rotation = 0
    NODE[2].Selectable = false
    NODE[2].Size = UDim2.new(0.0, 50, 0.0, 50)
    NODE[2].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[2].Visible = false
    NODE[2].ZIndex = 999999999
    NODE[3] = Instance.new("UIPadding")
    NODE[3].Name = "UIPadding"
    NODE[3].PaddingBottom = UDim.new(0.0, 30)
    NODE[3].PaddingLeft = UDim.new(0.0, 30)
    NODE[3].PaddingRight = UDim.new(0.0, 30)
    NODE[3].PaddingTop = UDim.new(0.0, 30)
    NODE[3].Parent = NODE[2]
    NODE[4] = Instance.new("CanvasGroup")
    NODE[4].Name = "Content"
    NODE[4].GroupColor3 = Color3.fromRGB(255, 255, 255)
    NODE[4].GroupTransparency = 0
    NODE[4].Active = false
    NODE[4].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[4].AutomaticSize = Enum.AutomaticSize.XY
    NODE[4].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NODE[4].BackgroundTransparency = 0
    NODE[4].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[4].BorderMode = Enum.BorderMode.Outline
    NODE[4].BorderSizePixel = 0
    NODE[4].ClipsDescendants = true
    NODE[4].Interactable = true
    NODE[4].LayoutOrder = 0
    NODE[4].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[4].Rotation = 0
    NODE[4].Selectable = false
    NODE[4].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[4].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[4].Visible = true
    NODE[4].ZIndex = 1
    NODE[5] = Instance.new("UICorner")
    NODE[5].Name = "UICorner"
    NODE[5].CornerRadius = UDim.new(0.0, 8)
    NODE[5].CornerRadius = UDim.new(0.0, 8)
    NODE[5].CornerRadius = UDim.new(0.0, 8)
    NODE[5].CornerRadius = UDim.new(0.0, 8)
    NODE[5].Parent = NODE[4]
    NODE[6] = Instance.new("UIListLayout")
    NODE[6].Name = "UIListLayout"
    NODE[6].HorizontalFlex = Enum.UIFlexAlignment.Fill
    NODE[6].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[6].Padding = UDim.new(0.0, 0)
    NODE[6].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[6].Wraps = true
    NODE[6].FillDirection = Enum.FillDirection.Vertical
    NODE[6].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[6].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[6].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[7] = Instance.new("ImageButton")
    NODE[7].Name = "Role"
    NODE[7].HoverImage = ""
    NODE[7].Image = ""
    NODE[7].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[7].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[7].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[7].ImageTransparency = 0
    NODE[7].PressedImage = ""
    NODE[7].ResampleMode = Enum.ResamplerMode.Default
    NODE[7].ScaleType = Enum.ScaleType.Stretch
    NODE[7].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[7].SliceScale = 1
    NODE[7].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[7].AutoButtonColor = true
    NODE[7].Modal = false
    NODE[7].Selected = false
    NODE[7].Active = true
    NODE[7].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[7].AutomaticSize = Enum.AutomaticSize.X
    NODE[7].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NODE[7].BackgroundTransparency = 0
    NODE[7].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[7].BorderMode = Enum.BorderMode.Outline
    NODE[7].BorderSizePixel = 0
    NODE[7].ClipsDescendants = false
    NODE[7].Interactable = true
    NODE[7].LayoutOrder = 255
    NODE[7].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[7].Rotation = 0
    NODE[7].Selectable = true
    NODE[7].Size = UDim2.new(0.0, 0, 0.0, 50)
    NODE[7].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[7].Visible = true
    NODE[7].ZIndex = 1
    NODE[8] = Instance.new("UIPadding")
    NODE[8].Name = "UIPadding"
    NODE[8].PaddingBottom = UDim.new(0.0, 0)
    NODE[8].PaddingLeft = UDim.new(0.0, 20)
    NODE[8].PaddingRight = UDim.new(0.0, 20)
    NODE[8].PaddingTop = UDim.new(0.0, 0)
    NODE[8].Parent = NODE[7]
    NODE[9] = Instance.new("TextLabel")
    NODE[9].Name = "TextRank"
    NODE[9].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[9].LineHeight = 1
    NODE[9].MaxVisibleGraphemes = -1
    NODE[9].OpenTypeFeatures = ""
    NODE[9].RichText = false
    NODE[9].Text = "#1 Sigma"
    NODE[9].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[9].TextDirection = Enum.TextDirection.LeftToRight
    NODE[9].TextScaled = false
    NODE[9].TextSize = 15
    NODE[9].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[9].TextStrokeTransparency = 1
    NODE[9].TextTransparency = 0
    NODE[9].TextTruncate = Enum.TextTruncate.None
    NODE[9].TextWrapped = false
    NODE[9].TextXAlignment = Enum.TextXAlignment.Left
    NODE[9].TextYAlignment = Enum.TextYAlignment.Center
    NODE[9].Active = false
    NODE[9].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[9].AutomaticSize = Enum.AutomaticSize.X
    NODE[9].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[9].BackgroundTransparency = 1
    NODE[9].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[9].BorderMode = Enum.BorderMode.Outline
    NODE[9].BorderSizePixel = 0
    NODE[9].ClipsDescendants = false
    NODE[9].Interactable = true
    NODE[9].LayoutOrder = 0
    NODE[9].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[9].Rotation = 0
    NODE[9].Selectable = false
    NODE[9].Size = UDim2.new(0.0, 0, 0.0, 10)
    NODE[9].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[9].Visible = true
    NODE[9].ZIndex = 1
    NODE[10] = Instance.new("UIFlexItem")
    NODE[10].Name = "UIFlexItem"
    NODE[10].FlexMode = Enum.UIFlexMode.Fill
    NODE[10].GrowRatio = 0
    NODE[10].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[10].ShrinkRatio = 0
    NODE[10].Parent = NODE[9]
    NODE[9].Parent = NODE[7]
    NODE[11] = Instance.new("UIListLayout")
    NODE[11].Name = "UIListLayout"
    NODE[11].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[11].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[11].Padding = UDim.new(0.0, 15)
    NODE[11].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[11].Wraps = false
    NODE[11].FillDirection = Enum.FillDirection.Horizontal
    NODE[11].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[11].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[11].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[11].Parent = NODE[7]
    NODE[12] = Instance.new("TextLabel")
    NODE[12].Name = "TextValue"
    NODE[12].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[12].LineHeight = 1
    NODE[12].MaxVisibleGraphemes = -1
    NODE[12].OpenTypeFeatures = ""
    NODE[12].RichText = false
    NODE[12].Text = "0"
    NODE[12].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[12].TextDirection = Enum.TextDirection.LeftToRight
    NODE[12].TextScaled = false
    NODE[12].TextSize = 15
    NODE[12].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[12].TextStrokeTransparency = 1
    NODE[12].TextTransparency = 0
    NODE[12].TextTruncate = Enum.TextTruncate.None
    NODE[12].TextWrapped = false
    NODE[12].TextXAlignment = Enum.TextXAlignment.Center
    NODE[12].TextYAlignment = Enum.TextYAlignment.Center
    NODE[12].Active = false
    NODE[12].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[12].AutomaticSize = Enum.AutomaticSize.X
    NODE[12].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[12].BackgroundTransparency = 1
    NODE[12].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[12].BorderMode = Enum.BorderMode.Outline
    NODE[12].BorderSizePixel = 0
    NODE[12].ClipsDescendants = false
    NODE[12].Interactable = true
    NODE[12].LayoutOrder = 0
    NODE[12].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[12].Rotation = 0
    NODE[12].Selectable = false
    NODE[12].Size = UDim2.new(0.0, 0, 0.0, 10)
    NODE[12].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[12].Visible = true
    NODE[12].ZIndex = 1
    NODE[12].Parent = NODE[7]
    NODE[7].Parent = NODE[6]
    NODE[13] = Instance.new("TextLabel")
    NODE[13].Name = "head"
    NODE[13].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[13].LineHeight = 1
    NODE[13].MaxVisibleGraphemes = -1
    NODE[13].OpenTypeFeatures = ""
    NODE[13].RichText = false
    NODE[13].Text = "Community Ranks"
    NODE[13].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[13].TextDirection = Enum.TextDirection.LeftToRight
    NODE[13].TextScaled = false
    NODE[13].TextSize = 14
    NODE[13].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[13].TextStrokeTransparency = 1
    NODE[13].TextTransparency = 0.800000012
    NODE[13].TextTruncate = Enum.TextTruncate.None
    NODE[13].TextWrapped = false
    NODE[13].TextXAlignment = Enum.TextXAlignment.Center
    NODE[13].TextYAlignment = Enum.TextYAlignment.Center
    NODE[13].Active = false
    NODE[13].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[13].AutomaticSize = Enum.AutomaticSize.XY
    NODE[13].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[13].BackgroundTransparency = 1
    NODE[13].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[13].BorderMode = Enum.BorderMode.Outline
    NODE[13].BorderSizePixel = 0
    NODE[13].ClipsDescendants = false
    NODE[13].Interactable = true
    NODE[13].LayoutOrder = -999
    NODE[13].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[13].Rotation = 0
    NODE[13].Selectable = false
    NODE[13].Size = UDim2.new(0.0, 0, 0.0, 20)
    NODE[13].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[13].Visible = true
    NODE[13].ZIndex = 1
    NODE[14] = Instance.new("UIPadding")
    NODE[14].Name = "UIPadding"
    NODE[14].PaddingBottom = UDim.new(0.0, 5)
    NODE[14].PaddingLeft = UDim.new(0.0, 30)
    NODE[14].PaddingRight = UDim.new(0.0, 30)
    NODE[14].PaddingTop = UDim.new(0.0, 9)
    NODE[14].Parent = NODE[13]
    NODE[13].Parent = NODE[6]
    NODE[15] = Instance.new("ImageButton")
    NODE[15].Name = "Close"
    NODE[15].HoverImage = ""
    NODE[15].Image = ""
    NODE[15].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[15].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[15].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[15].ImageTransparency = 0
    NODE[15].PressedImage = ""
    NODE[15].ResampleMode = Enum.ResamplerMode.Default
    NODE[15].ScaleType = Enum.ScaleType.Stretch
    NODE[15].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[15].SliceScale = 1
    NODE[15].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[15].AutoButtonColor = true
    NODE[15].Modal = false
    NODE[15].Selected = false
    NODE[15].Active = true
    NODE[15].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[15].AutomaticSize = Enum.AutomaticSize.X
    NODE[15].BackgroundColor3 = Color3.fromRGB(229, 42, 42)
    NODE[15].BackgroundTransparency = 0
    NODE[15].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[15].BorderMode = Enum.BorderMode.Outline
    NODE[15].BorderSizePixel = 0
    NODE[15].ClipsDescendants = false
    NODE[15].Interactable = true
    NODE[15].LayoutOrder = 999999999
    NODE[15].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[15].Rotation = 0
    NODE[15].Selectable = true
    NODE[15].Size = UDim2.new(0.0, 0, 0.0, 40)
    NODE[15].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[15].Visible = true
    NODE[15].ZIndex = 1
    NODE[16] = Instance.new("UIPadding")
    NODE[16].Name = "UIPadding"
    NODE[16].PaddingBottom = UDim.new(0.0, 0)
    NODE[16].PaddingLeft = UDim.new(0.0, 20)
    NODE[16].PaddingRight = UDim.new(0.0, 20)
    NODE[16].PaddingTop = UDim.new(0.0, 0)
    NODE[16].Parent = NODE[15]
    NODE[17] = Instance.new("ImageLabel")
    NODE[17].Name = "Icon"
    NODE[17].Image = "rbxassetid://11293981586"
    NODE[17].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[17].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[17].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[17].ImageTransparency = 0
    NODE[17].ResampleMode = Enum.ResamplerMode.Default
    NODE[17].ScaleType = Enum.ScaleType.Stretch
    NODE[17].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[17].SliceScale = 1
    NODE[17].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[17].Active = false
    NODE[17].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[17].AutomaticSize = Enum.AutomaticSize.None
    NODE[17].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[17].BackgroundTransparency = 1
    NODE[17].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[17].BorderMode = Enum.BorderMode.Outline
    NODE[17].BorderSizePixel = 0
    NODE[17].ClipsDescendants = false
    NODE[17].Interactable = true
    NODE[17].LayoutOrder = 0
    NODE[17].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[17].Rotation = 0
    NODE[17].Selectable = false
    NODE[17].Size = UDim2.new(0.0, 16, 0.0, 16)
    NODE[17].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[17].Visible = false
    NODE[17].ZIndex = 1
    NODE[17].Parent = NODE[15]
    NODE[18] = Instance.new("TextLabel")
    NODE[18].Name = "TextValue"
    NODE[18].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[18].LineHeight = 1
    NODE[18].MaxVisibleGraphemes = -1
    NODE[18].OpenTypeFeatures = ""
    NODE[18].RichText = false
    NODE[18].Text = "Close"
    NODE[18].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[18].TextDirection = Enum.TextDirection.LeftToRight
    NODE[18].TextScaled = false
    NODE[18].TextSize = 15
    NODE[18].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[18].TextStrokeTransparency = 1
    NODE[18].TextTransparency = 0
    NODE[18].TextTruncate = Enum.TextTruncate.None
    NODE[18].TextWrapped = false
    NODE[18].TextXAlignment = Enum.TextXAlignment.Center
    NODE[18].TextYAlignment = Enum.TextYAlignment.Center
    NODE[18].Active = false
    NODE[18].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[18].AutomaticSize = Enum.AutomaticSize.X
    NODE[18].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[18].BackgroundTransparency = 1
    NODE[18].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[18].BorderMode = Enum.BorderMode.Outline
    NODE[18].BorderSizePixel = 0
    NODE[18].ClipsDescendants = false
    NODE[18].Interactable = true
    NODE[18].LayoutOrder = 0
    NODE[18].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[18].Rotation = 0
    NODE[18].Selectable = false
    NODE[18].Size = UDim2.new(0.0, 0, 0.0, 10)
    NODE[18].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[18].Visible = true
    NODE[18].ZIndex = 1
    NODE[18].Parent = NODE[15]
    NODE[19] = Instance.new("UIListLayout")
    NODE[19].Name = "UIListLayout"
    NODE[19].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[19].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[19].Padding = UDim.new(0.0, 8)
    NODE[19].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[19].Wraps = false
    NODE[19].FillDirection = Enum.FillDirection.Horizontal
    NODE[19].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[19].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[19].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[19].Parent = NODE[15]
    NODE[15].Parent = NODE[6]
    NODE[20] = Instance.new("ImageButton")
    NODE[20].Name = "Action"
    NODE[20].HoverImage = ""
    NODE[20].Image = ""
    NODE[20].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[20].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[20].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[20].ImageTransparency = 0
    NODE[20].PressedImage = ""
    NODE[20].ResampleMode = Enum.ResamplerMode.Default
    NODE[20].ScaleType = Enum.ScaleType.Stretch
    NODE[20].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[20].SliceScale = 1
    NODE[20].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[20].AutoButtonColor = true
    NODE[20].Modal = false
    NODE[20].Selected = false
    NODE[20].Active = true
    NODE[20].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[20].AutomaticSize = Enum.AutomaticSize.X
    NODE[20].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NODE[20].BackgroundTransparency = 0
    NODE[20].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[20].BorderMode = Enum.BorderMode.Outline
    NODE[20].BorderSizePixel = 0
    NODE[20].ClipsDescendants = false
    NODE[20].Interactable = true
    NODE[20].LayoutOrder = 0
    NODE[20].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[20].Rotation = 0
    NODE[20].Selectable = true
    NODE[20].Size = UDim2.new(0.0, 0, 0.0, 50)
    NODE[20].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[20].Visible = true
    NODE[20].ZIndex = 1
    NODE[21] = Instance.new("UIPadding")
    NODE[21].Name = "UIPadding"
    NODE[21].PaddingBottom = UDim.new(0.0, 0)
    NODE[21].PaddingLeft = UDim.new(0.0, 20)
    NODE[21].PaddingRight = UDim.new(0.0, 20)
    NODE[21].PaddingTop = UDim.new(0.0, 0)
    NODE[21].Parent = NODE[20]
    NODE[22] = Instance.new("ImageLabel")
    NODE[22].Name = "Icon"
    NODE[22].Image = "rbxassetid://11422930956"
    NODE[22].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[22].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[22].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[22].ImageTransparency = 0
    NODE[22].ResampleMode = Enum.ResamplerMode.Default
    NODE[22].ScaleType = Enum.ScaleType.Stretch
    NODE[22].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[22].SliceScale = 1
    NODE[22].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[22].Active = false
    NODE[22].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[22].AutomaticSize = Enum.AutomaticSize.None
    NODE[22].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[22].BackgroundTransparency = 1
    NODE[22].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[22].BorderMode = Enum.BorderMode.Outline
    NODE[22].BorderSizePixel = 0
    NODE[22].ClipsDescendants = false
    NODE[22].Interactable = true
    NODE[22].LayoutOrder = 0
    NODE[22].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[22].Rotation = 0
    NODE[22].Selectable = false
    NODE[22].Size = UDim2.new(0.0, 16, 0.0, 16)
    NODE[22].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[22].Visible = true
    NODE[22].ZIndex = 1
    NODE[23] = Instance.new("UICorner")
    NODE[23].Name = "UICorner"
    NODE[23].CornerRadius = UDim.new(0.0, 0)
    NODE[23].CornerRadius = UDim.new(0.0, 0)
    NODE[23].CornerRadius = UDim.new(0.0, 0)
    NODE[23].CornerRadius = UDim.new(0.0, 0)
    NODE[23].Parent = NODE[22]
    NODE[22].Parent = NODE[20]
    NODE[24] = Instance.new("TextLabel")
    NODE[24].Name = "TextValue"
    NODE[24].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[24].LineHeight = 1
    NODE[24].MaxVisibleGraphemes = -1
    NODE[24].OpenTypeFeatures = ""
    NODE[24].RichText = false
    NODE[24].Text = "Select Category"
    NODE[24].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[24].TextDirection = Enum.TextDirection.LeftToRight
    NODE[24].TextScaled = false
    NODE[24].TextSize = 15
    NODE[24].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[24].TextStrokeTransparency = 1
    NODE[24].TextTransparency = 0
    NODE[24].TextTruncate = Enum.TextTruncate.None
    NODE[24].TextWrapped = false
    NODE[24].TextXAlignment = Enum.TextXAlignment.Center
    NODE[24].TextYAlignment = Enum.TextYAlignment.Center
    NODE[24].Active = false
    NODE[24].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[24].AutomaticSize = Enum.AutomaticSize.X
    NODE[24].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[24].BackgroundTransparency = 1
    NODE[24].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[24].BorderMode = Enum.BorderMode.Outline
    NODE[24].BorderSizePixel = 0
    NODE[24].ClipsDescendants = false
    NODE[24].Interactable = true
    NODE[24].LayoutOrder = 0
    NODE[24].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[24].Rotation = 0
    NODE[24].Selectable = false
    NODE[24].Size = UDim2.new(0.0, 0, 0.0, 10)
    NODE[24].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[24].Visible = true
    NODE[24].ZIndex = 1
    NODE[24].Parent = NODE[20]
    NODE[25] = Instance.new("UIListLayout")
    NODE[25].Name = "UIListLayout"
    NODE[25].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[25].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[25].Padding = UDim.new(0.0, 8)
    NODE[25].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[25].Wraps = false
    NODE[25].FillDirection = Enum.FillDirection.Horizontal
    NODE[25].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[25].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[25].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[25].Parent = NODE[20]
    NODE[20].Parent = NODE[6]
    NODE[26] = Instance.new("Frame")
    NODE[26].Name = "PrimaryActions"
    NODE[26].Active = false
    NODE[26].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[26].AutomaticSize = Enum.AutomaticSize.X
    NODE[26].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[26].BackgroundTransparency = 1
    NODE[26].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[26].BorderMode = Enum.BorderMode.Outline
    NODE[26].BorderSizePixel = 0
    NODE[26].ClipsDescendants = false
    NODE[26].Interactable = true
    NODE[26].LayoutOrder = -99
    NODE[26].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[26].Rotation = 0
    NODE[26].Selectable = false
    NODE[26].Size = UDim2.new(0.0, 0, 0.0, 50)
    NODE[26].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[26].Visible = true
    NODE[26].ZIndex = 1
    NODE[27] = Instance.new("UIListLayout")
    NODE[27].Name = "UIListLayout"
    NODE[27].HorizontalFlex = Enum.UIFlexAlignment.Fill
    NODE[27].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[27].Padding = UDim.new(0.0, 0)
    NODE[27].VerticalFlex = Enum.UIFlexAlignment.Fill
    NODE[27].Wraps = true
    NODE[27].FillDirection = Enum.FillDirection.Vertical
    NODE[27].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[27].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[27].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[27].Parent = NODE[26]
    NODE[26].Parent = NODE[6]
    NODE[6].Parent = NODE[4]
    NODE[4].Parent = NODE[2]
    NODE[2].Parent = NODE[1]
    NODE[28] = Instance.new("ImageLabel")
    NODE[28].Name = "Replica"
    NODE[28].Image = "rbxassetid://109207734544898"
    NODE[28].ImageColor3 = Color3.fromRGB(0, 0, 0)
    NODE[28].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[28].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[28].ImageTransparency = 1
    NODE[28].ResampleMode = Enum.ResamplerMode.Default
    NODE[28].ScaleType = Enum.ScaleType.Slice
    NODE[28].SliceCenter = Rect.new(300, 300, 300, 300)
    NODE[28].SliceScale = 0.150000006
    NODE[28].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[28].Active = false
    NODE[28].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[28].AutomaticSize = Enum.AutomaticSize.XY
    NODE[28].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[28].BackgroundTransparency = 1
    NODE[28].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[28].BorderMode = Enum.BorderMode.Outline
    NODE[28].BorderSizePixel = 0
    NODE[28].ClipsDescendants = false
    NODE[28].Interactable = true
    NODE[28].LayoutOrder = 0
    NODE[28].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[28].Rotation = 0
    NODE[28].Selectable = false
    NODE[28].Size = UDim2.new(0.0, 50, 0.0, 50)
    NODE[28].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[28].Visible = false
    NODE[28].ZIndex = -999
    NODE[29] = Instance.new("UIPadding")
    NODE[29].Name = "UIPadding"
    NODE[29].PaddingBottom = UDim.new(0.0, 30)
    NODE[29].PaddingLeft = UDim.new(0.0, 30)
    NODE[29].PaddingRight = UDim.new(0.0, 30)
    NODE[29].PaddingTop = UDim.new(0.0, 30)
    NODE[29].Parent = NODE[28]
    NODE[30] = Instance.new("CanvasGroup")
    NODE[30].Name = "Content"
    NODE[30].GroupColor3 = Color3.fromRGB(255, 255, 255)
    NODE[30].GroupTransparency = 1
    NODE[30].Active = false
    NODE[30].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[30].AutomaticSize = Enum.AutomaticSize.XY
    NODE[30].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NODE[30].BackgroundTransparency = 0
    NODE[30].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[30].BorderMode = Enum.BorderMode.Outline
    NODE[30].BorderSizePixel = 0
    NODE[30].ClipsDescendants = true
    NODE[30].Interactable = false
    NODE[30].LayoutOrder = 0
    NODE[30].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[30].Rotation = 0
    NODE[30].Selectable = false
    NODE[30].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[30].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[30].Visible = true
    NODE[30].ZIndex = 1
    NODE[31] = Instance.new("UICorner")
    NODE[31].Name = "UICorner"
    NODE[31].CornerRadius = UDim.new(0.0, 8)
    NODE[31].CornerRadius = UDim.new(0.0, 8)
    NODE[31].CornerRadius = UDim.new(0.0, 8)
    NODE[31].CornerRadius = UDim.new(0.0, 8)
    NODE[31].Parent = NODE[30]
    NODE[32] = Instance.new("UIListLayout")
    NODE[32].Name = "UIListLayout"
    NODE[32].HorizontalFlex = Enum.UIFlexAlignment.Fill
    NODE[32].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[32].Padding = UDim.new(0.0, 0)
    NODE[32].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[32].Wraps = true
    NODE[32].FillDirection = Enum.FillDirection.Vertical
    NODE[32].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[32].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[32].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[33] = Instance.new("Frame")
    NODE[33].Name = "PrimaryActions"
    NODE[33].Active = false
    NODE[33].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[33].AutomaticSize = Enum.AutomaticSize.X
    NODE[33].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[33].BackgroundTransparency = 1
    NODE[33].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[33].BorderMode = Enum.BorderMode.Outline
    NODE[33].BorderSizePixel = 0
    NODE[33].ClipsDescendants = false
    NODE[33].Interactable = true
    NODE[33].LayoutOrder = -99
    NODE[33].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[33].Rotation = 0
    NODE[33].Selectable = false
    NODE[33].Size = UDim2.new(0.0, 0, 0.0, 50)
    NODE[33].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[33].Visible = true
    NODE[33].ZIndex = 1
    NODE[34] = Instance.new("UIListLayout")
    NODE[34].Name = "UIListLayout"
    NODE[34].HorizontalFlex = Enum.UIFlexAlignment.Fill
    NODE[34].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[34].Padding = UDim.new(0.0, 0)
    NODE[34].VerticalFlex = Enum.UIFlexAlignment.Fill
    NODE[34].Wraps = true
    NODE[34].FillDirection = Enum.FillDirection.Vertical
    NODE[34].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[34].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[34].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[34].Parent = NODE[33]
    NODE[33].Parent = NODE[32]
    NODE[35] = Instance.new("ImageButton")
    NODE[35].Name = "Action"
    NODE[35].HoverImage = ""
    NODE[35].Image = ""
    NODE[35].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[35].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[35].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[35].ImageTransparency = 0
    NODE[35].PressedImage = ""
    NODE[35].ResampleMode = Enum.ResamplerMode.Default
    NODE[35].ScaleType = Enum.ScaleType.Stretch
    NODE[35].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[35].SliceScale = 1
    NODE[35].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[35].AutoButtonColor = true
    NODE[35].Modal = false
    NODE[35].Selected = false
    NODE[35].Active = true
    NODE[35].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[35].AutomaticSize = Enum.AutomaticSize.X
    NODE[35].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NODE[35].BackgroundTransparency = 0
    NODE[35].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[35].BorderMode = Enum.BorderMode.Outline
    NODE[35].BorderSizePixel = 0
    NODE[35].ClipsDescendants = false
    NODE[35].Interactable = true
    NODE[35].LayoutOrder = 0
    NODE[35].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[35].Rotation = 0
    NODE[35].Selectable = true
    NODE[35].Size = UDim2.new(0.0, 0, 0.0, 50)
    NODE[35].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[35].Visible = true
    NODE[35].ZIndex = 1
    NODE[36] = Instance.new("UIPadding")
    NODE[36].Name = "UIPadding"
    NODE[36].PaddingBottom = UDim.new(0.0, 0)
    NODE[36].PaddingLeft = UDim.new(0.0, 20)
    NODE[36].PaddingRight = UDim.new(0.0, 20)
    NODE[36].PaddingTop = UDim.new(0.0, 0)
    NODE[36].Parent = NODE[35]
    NODE[37] = Instance.new("ImageLabel")
    NODE[37].Name = "Icon"
    NODE[37].Image = "rbxassetid://11422930956"
    NODE[37].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[37].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[37].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[37].ImageTransparency = 0
    NODE[37].ResampleMode = Enum.ResamplerMode.Default
    NODE[37].ScaleType = Enum.ScaleType.Stretch
    NODE[37].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[37].SliceScale = 1
    NODE[37].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[37].Active = false
    NODE[37].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[37].AutomaticSize = Enum.AutomaticSize.None
    NODE[37].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[37].BackgroundTransparency = 1
    NODE[37].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[37].BorderMode = Enum.BorderMode.Outline
    NODE[37].BorderSizePixel = 0
    NODE[37].ClipsDescendants = false
    NODE[37].Interactable = true
    NODE[37].LayoutOrder = 0
    NODE[37].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[37].Rotation = 0
    NODE[37].Selectable = false
    NODE[37].Size = UDim2.new(0.0, 16, 0.0, 16)
    NODE[37].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[37].Visible = true
    NODE[37].ZIndex = 1
    NODE[37].Parent = NODE[35]
    NODE[38] = Instance.new("TextLabel")
    NODE[38].Name = "TextValue"
    NODE[38].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[38].LineHeight = 1
    NODE[38].MaxVisibleGraphemes = -1
    NODE[38].OpenTypeFeatures = ""
    NODE[38].RichText = false
    NODE[38].Text = "Select Category"
    NODE[38].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[38].TextDirection = Enum.TextDirection.LeftToRight
    NODE[38].TextScaled = false
    NODE[38].TextSize = 15
    NODE[38].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[38].TextStrokeTransparency = 1
    NODE[38].TextTransparency = 0
    NODE[38].TextTruncate = Enum.TextTruncate.None
    NODE[38].TextWrapped = false
    NODE[38].TextXAlignment = Enum.TextXAlignment.Center
    NODE[38].TextYAlignment = Enum.TextYAlignment.Center
    NODE[38].Active = false
    NODE[38].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[38].AutomaticSize = Enum.AutomaticSize.X
    NODE[38].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[38].BackgroundTransparency = 1
    NODE[38].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[38].BorderMode = Enum.BorderMode.Outline
    NODE[38].BorderSizePixel = 0
    NODE[38].ClipsDescendants = false
    NODE[38].Interactable = true
    NODE[38].LayoutOrder = 0
    NODE[38].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[38].Rotation = 0
    NODE[38].Selectable = false
    NODE[38].Size = UDim2.new(0.0, 0, 0.0, 10)
    NODE[38].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[38].Visible = true
    NODE[38].ZIndex = 1
    NODE[38].Parent = NODE[35]
    NODE[39] = Instance.new("UIListLayout")
    NODE[39].Name = "UIListLayout"
    NODE[39].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[39].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[39].Padding = UDim.new(0.0, 8)
    NODE[39].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[39].Wraps = false
    NODE[39].FillDirection = Enum.FillDirection.Horizontal
    NODE[39].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[39].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[39].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[39].Parent = NODE[35]
    NODE[35].Parent = NODE[32]
    NODE[40] = Instance.new("ImageButton")
    NODE[40].Name = "Close"
    NODE[40].HoverImage = ""
    NODE[40].Image = ""
    NODE[40].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[40].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[40].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[40].ImageTransparency = 0
    NODE[40].PressedImage = ""
    NODE[40].ResampleMode = Enum.ResamplerMode.Default
    NODE[40].ScaleType = Enum.ScaleType.Stretch
    NODE[40].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[40].SliceScale = 1
    NODE[40].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[40].AutoButtonColor = true
    NODE[40].Modal = false
    NODE[40].Selected = false
    NODE[40].Active = true
    NODE[40].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[40].AutomaticSize = Enum.AutomaticSize.X
    NODE[40].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NODE[40].BackgroundTransparency = 0
    NODE[40].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[40].BorderMode = Enum.BorderMode.Outline
    NODE[40].BorderSizePixel = 0
    NODE[40].ClipsDescendants = false
    NODE[40].Interactable = true
    NODE[40].LayoutOrder = 999999999
    NODE[40].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[40].Rotation = 0
    NODE[40].Selectable = true
    NODE[40].Size = UDim2.new(0.0, 0, 0.0, 40)
    NODE[40].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[40].Visible = true
    NODE[40].ZIndex = 1
    NODE[41] = Instance.new("UIPadding")
    NODE[41].Name = "UIPadding"
    NODE[41].PaddingBottom = UDim.new(0.0, 0)
    NODE[41].PaddingLeft = UDim.new(0.0, 20)
    NODE[41].PaddingRight = UDim.new(0.0, 20)
    NODE[41].PaddingTop = UDim.new(0.0, 0)
    NODE[41].Parent = NODE[40]
    NODE[42] = Instance.new("ImageLabel")
    NODE[42].Name = "Icon"
    NODE[42].Image = "rbxassetid://11293981586"
    NODE[42].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[42].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[42].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[42].ImageTransparency = 0
    NODE[42].ResampleMode = Enum.ResamplerMode.Default
    NODE[42].ScaleType = Enum.ScaleType.Stretch
    NODE[42].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[42].SliceScale = 1
    NODE[42].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[42].Active = false
    NODE[42].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[42].AutomaticSize = Enum.AutomaticSize.None
    NODE[42].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[42].BackgroundTransparency = 1
    NODE[42].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[42].BorderMode = Enum.BorderMode.Outline
    NODE[42].BorderSizePixel = 0
    NODE[42].ClipsDescendants = false
    NODE[42].Interactable = true
    NODE[42].LayoutOrder = 0
    NODE[42].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[42].Rotation = 0
    NODE[42].Selectable = false
    NODE[42].Size = UDim2.new(0.0, 16, 0.0, 16)
    NODE[42].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[42].Visible = false
    NODE[42].ZIndex = 1
    NODE[42].Parent = NODE[40]
    NODE[43] = Instance.new("TextLabel")
    NODE[43].Name = "TextValue"
    NODE[43].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[43].LineHeight = 1
    NODE[43].MaxVisibleGraphemes = -1
    NODE[43].OpenTypeFeatures = ""
    NODE[43].RichText = false
    NODE[43].Text = "Close"
    NODE[43].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[43].TextDirection = Enum.TextDirection.LeftToRight
    NODE[43].TextScaled = false
    NODE[43].TextSize = 15
    NODE[43].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[43].TextStrokeTransparency = 1
    NODE[43].TextTransparency = 0
    NODE[43].TextTruncate = Enum.TextTruncate.None
    NODE[43].TextWrapped = false
    NODE[43].TextXAlignment = Enum.TextXAlignment.Center
    NODE[43].TextYAlignment = Enum.TextYAlignment.Center
    NODE[43].Active = false
    NODE[43].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[43].AutomaticSize = Enum.AutomaticSize.X
    NODE[43].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[43].BackgroundTransparency = 1
    NODE[43].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[43].BorderMode = Enum.BorderMode.Outline
    NODE[43].BorderSizePixel = 0
    NODE[43].ClipsDescendants = false
    NODE[43].Interactable = true
    NODE[43].LayoutOrder = 0
    NODE[43].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[43].Rotation = 0
    NODE[43].Selectable = false
    NODE[43].Size = UDim2.new(0.0, 0, 0.0, 10)
    NODE[43].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[43].Visible = true
    NODE[43].ZIndex = 1
    NODE[43].Parent = NODE[40]
    NODE[44] = Instance.new("UIListLayout")
    NODE[44].Name = "UIListLayout"
    NODE[44].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[44].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[44].Padding = UDim.new(0.0, 8)
    NODE[44].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[44].Wraps = false
    NODE[44].FillDirection = Enum.FillDirection.Horizontal
    NODE[44].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[44].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[44].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[44].Parent = NODE[40]
    NODE[40].Parent = NODE[32]
    NODE[45] = Instance.new("ImageButton")
    NODE[45].Name = "Role"
    NODE[45].HoverImage = ""
    NODE[45].Image = ""
    NODE[45].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[45].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[45].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[45].ImageTransparency = 0
    NODE[45].PressedImage = ""
    NODE[45].ResampleMode = Enum.ResamplerMode.Default
    NODE[45].ScaleType = Enum.ScaleType.Stretch
    NODE[45].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[45].SliceScale = 1
    NODE[45].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[45].AutoButtonColor = true
    NODE[45].Modal = false
    NODE[45].Selected = false
    NODE[45].Active = true
    NODE[45].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[45].AutomaticSize = Enum.AutomaticSize.X
    NODE[45].BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    NODE[45].BackgroundTransparency = 0
    NODE[45].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[45].BorderMode = Enum.BorderMode.Outline
    NODE[45].BorderSizePixel = 0
    NODE[45].ClipsDescendants = false
    NODE[45].Interactable = true
    NODE[45].LayoutOrder = 255
    NODE[45].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[45].Rotation = 0
    NODE[45].Selectable = true
    NODE[45].Size = UDim2.new(0.0, 0, 0.0, 50)
    NODE[45].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[45].Visible = true
    NODE[45].ZIndex = 1
    NODE[46] = Instance.new("UIPadding")
    NODE[46].Name = "UIPadding"
    NODE[46].PaddingBottom = UDim.new(0.0, 0)
    NODE[46].PaddingLeft = UDim.new(0.0, 20)
    NODE[46].PaddingRight = UDim.new(0.0, 20)
    NODE[46].PaddingTop = UDim.new(0.0, 0)
    NODE[46].Parent = NODE[45]
    NODE[47] = Instance.new("TextLabel")
    NODE[47].Name = "TextRank"
    NODE[47].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[47].LineHeight = 1
    NODE[47].MaxVisibleGraphemes = -1
    NODE[47].OpenTypeFeatures = ""
    NODE[47].RichText = false
    NODE[47].Text = "#1 Sigma"
    NODE[47].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[47].TextDirection = Enum.TextDirection.LeftToRight
    NODE[47].TextScaled = false
    NODE[47].TextSize = 15
    NODE[47].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[47].TextStrokeTransparency = 1
    NODE[47].TextTransparency = 0
    NODE[47].TextTruncate = Enum.TextTruncate.None
    NODE[47].TextWrapped = false
    NODE[47].TextXAlignment = Enum.TextXAlignment.Left
    NODE[47].TextYAlignment = Enum.TextYAlignment.Center
    NODE[47].Active = false
    NODE[47].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[47].AutomaticSize = Enum.AutomaticSize.X
    NODE[47].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[47].BackgroundTransparency = 1
    NODE[47].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[47].BorderMode = Enum.BorderMode.Outline
    NODE[47].BorderSizePixel = 0
    NODE[47].ClipsDescendants = false
    NODE[47].Interactable = true
    NODE[47].LayoutOrder = 0
    NODE[47].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[47].Rotation = 0
    NODE[47].Selectable = false
    NODE[47].Size = UDim2.new(0.0, 0, 0.0, 10)
    NODE[47].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[47].Visible = true
    NODE[47].ZIndex = 1
    NODE[48] = Instance.new("UIFlexItem")
    NODE[48].Name = "UIFlexItem"
    NODE[48].FlexMode = Enum.UIFlexMode.Fill
    NODE[48].GrowRatio = 0
    NODE[48].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[48].ShrinkRatio = 0
    NODE[48].Parent = NODE[47]
    NODE[47].Parent = NODE[45]
    NODE[49] = Instance.new("UIListLayout")
    NODE[49].Name = "UIListLayout"
    NODE[49].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[49].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[49].Padding = UDim.new(0.0, 15)
    NODE[49].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[49].Wraps = false
    NODE[49].FillDirection = Enum.FillDirection.Horizontal
    NODE[49].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[49].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[49].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[49].Parent = NODE[45]
    NODE[50] = Instance.new("TextLabel")
    NODE[50].Name = "TextValue"
    NODE[50].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[50].LineHeight = 1
    NODE[50].MaxVisibleGraphemes = -1
    NODE[50].OpenTypeFeatures = ""
    NODE[50].RichText = false
    NODE[50].Text = "0"
    NODE[50].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[50].TextDirection = Enum.TextDirection.LeftToRight
    NODE[50].TextScaled = false
    NODE[50].TextSize = 15
    NODE[50].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[50].TextStrokeTransparency = 1
    NODE[50].TextTransparency = 0
    NODE[50].TextTruncate = Enum.TextTruncate.None
    NODE[50].TextWrapped = false
    NODE[50].TextXAlignment = Enum.TextXAlignment.Center
    NODE[50].TextYAlignment = Enum.TextYAlignment.Center
    NODE[50].Active = false
    NODE[50].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[50].AutomaticSize = Enum.AutomaticSize.X
    NODE[50].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[50].BackgroundTransparency = 1
    NODE[50].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[50].BorderMode = Enum.BorderMode.Outline
    NODE[50].BorderSizePixel = 0
    NODE[50].ClipsDescendants = false
    NODE[50].Interactable = true
    NODE[50].LayoutOrder = 0
    NODE[50].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[50].Rotation = 0
    NODE[50].Selectable = false
    NODE[50].Size = UDim2.new(0.0, 0, 0.0, 10)
    NODE[50].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[50].Visible = true
    NODE[50].ZIndex = 1
    NODE[50].Parent = NODE[45]
    NODE[45].Parent = NODE[32]
    NODE[51] = Instance.new("TextLabel")
    NODE[51].Name = "head"
    NODE[51].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[51].LineHeight = 1
    NODE[51].MaxVisibleGraphemes = -1
    NODE[51].OpenTypeFeatures = ""
    NODE[51].RichText = false
    NODE[51].Text = "Community Ranks"
    NODE[51].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[51].TextDirection = Enum.TextDirection.LeftToRight
    NODE[51].TextScaled = false
    NODE[51].TextSize = 14
    NODE[51].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[51].TextStrokeTransparency = 1
    NODE[51].TextTransparency = 0.800000012
    NODE[51].TextTruncate = Enum.TextTruncate.None
    NODE[51].TextWrapped = false
    NODE[51].TextXAlignment = Enum.TextXAlignment.Center
    NODE[51].TextYAlignment = Enum.TextYAlignment.Center
    NODE[51].Active = false
    NODE[51].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[51].AutomaticSize = Enum.AutomaticSize.XY
    NODE[51].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[51].BackgroundTransparency = 1
    NODE[51].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[51].BorderMode = Enum.BorderMode.Outline
    NODE[51].BorderSizePixel = 0
    NODE[51].ClipsDescendants = false
    NODE[51].Interactable = true
    NODE[51].LayoutOrder = -999
    NODE[51].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[51].Rotation = 0
    NODE[51].Selectable = false
    NODE[51].Size = UDim2.new(0.0, 0, 0.0, 20)
    NODE[51].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[51].Visible = true
    NODE[51].ZIndex = 1
    NODE[52] = Instance.new("UIPadding")
    NODE[52].Name = "UIPadding"
    NODE[52].PaddingBottom = UDim.new(0.0, 5)
    NODE[52].PaddingLeft = UDim.new(0.0, 30)
    NODE[52].PaddingRight = UDim.new(0.0, 30)
    NODE[52].PaddingTop = UDim.new(0.0, 9)
    NODE[52].Parent = NODE[51]
    NODE[51].Parent = NODE[32]
    NODE[32].Parent = NODE[30]
    NODE[30].Parent = NODE[28]
    NODE[28].Parent = NODE[1]
    NODE[53] = Instance.new("ImageButton")
    NODE[53].Name = "Cancel"
    NODE[53].HoverImage = ""
    NODE[53].Image = ""
    NODE[53].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[53].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[53].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[53].ImageTransparency = 0
    NODE[53].PressedImage = ""
    NODE[53].ResampleMode = Enum.ResamplerMode.Default
    NODE[53].ScaleType = Enum.ScaleType.Stretch
    NODE[53].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[53].SliceScale = 1
    NODE[53].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[53].AutoButtonColor = false
    NODE[53].Modal = false
    NODE[53].Selected = false
    NODE[53].Active = true
    NODE[53].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[53].AutomaticSize = Enum.AutomaticSize.None
    NODE[53].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[53].BackgroundTransparency = 1
    NODE[53].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[53].BorderMode = Enum.BorderMode.Outline
    NODE[53].BorderSizePixel = 0
    NODE[53].ClipsDescendants = false
    NODE[53].Interactable = true
    NODE[53].LayoutOrder = 0
    NODE[53].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[53].Rotation = 0
    NODE[53].Selectable = true
    NODE[53].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[53].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[53].Visible = false
    NODE[53].ZIndex = 1
    NODE[53].Parent = NODE[1]
    NODE[1].Parent = ShortcutsGui
    NODE[54] = Instance.new("Frame")
    NODE[54].Name = "Menu"
    NODE[54].Active = false
    NODE[54].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[54].AutomaticSize = Enum.AutomaticSize.None
    NODE[54].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[54].BackgroundTransparency = 1
    NODE[54].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[54].BorderMode = Enum.BorderMode.Outline
    NODE[54].BorderSizePixel = 0
    NODE[54].ClipsDescendants = false
    NODE[54].Interactable = true
    NODE[54].LayoutOrder = 0
    NODE[54].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[54].Rotation = 0
    NODE[54].Selectable = false
    NODE[54].Size = UDim2.new(0.899999976, 0, 0.899999976, 0)
    NODE[54].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[54].Visible = true
    NODE[54].ZIndex = 1
    NODE[55] = Instance.new("CanvasGroup")
    NODE[55].Name = "main"
    NODE[55].GroupColor3 = Color3.fromRGB(255, 255, 255)
    NODE[55].GroupTransparency = 0
    NODE[55].Active = false
    NODE[55].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[55].AutomaticSize = Enum.AutomaticSize.None
    NODE[55].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[55].BackgroundTransparency = 1
    NODE[55].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[55].BorderMode = Enum.BorderMode.Outline
    NODE[55].BorderSizePixel = 0
    NODE[55].ClipsDescendants = true
    NODE[55].Interactable = true
    NODE[55].LayoutOrder = 0
    NODE[55].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[55].Rotation = 0
    NODE[55].Selectable = false
    NODE[55].Size = UDim2.new(0.0, 400, 0.0, 400)
    NODE[55].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[55].Visible = true
    NODE[55].ZIndex = 1
    NODE[56] = Instance.new("ImageLabel")
    NODE[56].Name = "Background"
    NODE[56].Image = ""
    NODE[56].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[56].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[56].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[56].ImageTransparency = 0
    NODE[56].ResampleMode = Enum.ResamplerMode.Default
    NODE[56].ScaleType = Enum.ScaleType.Stretch
    NODE[56].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[56].SliceScale = 1
    NODE[56].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[56].Active = false
    NODE[56].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[56].AutomaticSize = Enum.AutomaticSize.None
    NODE[56].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[56].BackgroundTransparency = 0
    NODE[56].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[56].BorderMode = Enum.BorderMode.Outline
    NODE[56].BorderSizePixel = 0
    NODE[56].ClipsDescendants = false
    NODE[56].Interactable = true
    NODE[56].LayoutOrder = 0
    NODE[56].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[56].Rotation = 0
    NODE[56].Selectable = false
    NODE[56].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[56].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[56].Visible = true
    NODE[56].ZIndex = 1
    NODE[57] = Instance.new("TextButton")
    NODE[57].Name = "Action-1"
    NODE[57].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[57].LineHeight = 1
    NODE[57].MaxVisibleGraphemes = -1
    NODE[57].OpenTypeFeatures = ""
    NODE[57].RichText = false
    NODE[57].Text = ""
    NODE[57].TextColor3 = Color3.fromRGB(0, 0, 0)
    NODE[57].TextDirection = Enum.TextDirection.LeftToRight
    NODE[57].TextScaled = false
    NODE[57].TextSize = 14
    NODE[57].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[57].TextStrokeTransparency = 1
    NODE[57].TextTransparency = 0
    NODE[57].TextTruncate = Enum.TextTruncate.None
    NODE[57].TextWrapped = false
    NODE[57].TextXAlignment = Enum.TextXAlignment.Center
    NODE[57].TextYAlignment = Enum.TextYAlignment.Center
    NODE[57].AutoButtonColor = false
    NODE[57].Modal = false
    NODE[57].Selected = false
    NODE[57].Active = true
    NODE[57].AnchorPoint = Vector2.new(0.5, 1.0)
    NODE[57].AutomaticSize = Enum.AutomaticSize.None
    NODE[57].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[57].BackgroundTransparency = 1
    NODE[57].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[57].BorderMode = Enum.BorderMode.Outline
    NODE[57].BorderSizePixel = 0
    NODE[57].ClipsDescendants = false
    NODE[57].Interactable = true
    NODE[57].LayoutOrder = 1
    NODE[57].Position = UDim2.new(0.5, 0, 1.0, 0)
    NODE[57].Rotation = 0
    NODE[57].Selectable = true
    NODE[57].Size = UDim2.new(0.0, 100, 0.0, 100)
    NODE[57].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[57].Visible = true
    NODE[57].ZIndex = 1
    NODE[57]:SetAttribute("Rotation", 180.0)
    NODE[57]:SetAttribute("Action", "Unlinked(ShortcutService)")
    NODE[57].Parent = NODE[56]
    NODE[58] = Instance.new("TextButton")
    NODE[58].Name = "Action-6"
    NODE[58].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[58].LineHeight = 1
    NODE[58].MaxVisibleGraphemes = -1
    NODE[58].OpenTypeFeatures = ""
    NODE[58].RichText = false
    NODE[58].Text = ""
    NODE[58].TextColor3 = Color3.fromRGB(0, 0, 0)
    NODE[58].TextDirection = Enum.TextDirection.LeftToRight
    NODE[58].TextScaled = false
    NODE[58].TextSize = 14
    NODE[58].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[58].TextStrokeTransparency = 1
    NODE[58].TextTransparency = 0
    NODE[58].TextTruncate = Enum.TextTruncate.None
    NODE[58].TextWrapped = false
    NODE[58].TextXAlignment = Enum.TextXAlignment.Center
    NODE[58].TextYAlignment = Enum.TextYAlignment.Center
    NODE[58].AutoButtonColor = false
    NODE[58].Modal = false
    NODE[58].Selected = false
    NODE[58].Active = true
    NODE[58].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[58].AutomaticSize = Enum.AutomaticSize.None
    NODE[58].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[58].BackgroundTransparency = 1
    NODE[58].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[58].BorderMode = Enum.BorderMode.Outline
    NODE[58].BorderSizePixel = 0
    NODE[58].ClipsDescendants = false
    NODE[58].Interactable = true
    NODE[58].LayoutOrder = 1
    NODE[58].Position = UDim2.new(0.772760332, 0, 0.239499971, 0)
    NODE[58].Rotation = 45
    NODE[58].Selectable = true
    NODE[58].Size = UDim2.new(0.0, 100, 0.0, 100)
    NODE[58].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[58].Visible = true
    NODE[58].ZIndex = 1
    NODE[58]:SetAttribute("Rotation", 45.0)
    NODE[58]:SetAttribute("Action", "Unlinked(ShortcutService)")
    NODE[58].Parent = NODE[56]
    NODE[59] = Instance.new("TextButton")
    NODE[59].Name = "Action-4"
    NODE[59].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[59].LineHeight = 1
    NODE[59].MaxVisibleGraphemes = -1
    NODE[59].OpenTypeFeatures = ""
    NODE[59].RichText = false
    NODE[59].Text = ""
    NODE[59].TextColor3 = Color3.fromRGB(0, 0, 0)
    NODE[59].TextDirection = Enum.TextDirection.LeftToRight
    NODE[59].TextScaled = false
    NODE[59].TextSize = 14
    NODE[59].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[59].TextStrokeTransparency = 1
    NODE[59].TextTransparency = 0
    NODE[59].TextTruncate = Enum.TextTruncate.None
    NODE[59].TextWrapped = false
    NODE[59].TextXAlignment = Enum.TextXAlignment.Center
    NODE[59].TextYAlignment = Enum.TextYAlignment.Center
    NODE[59].AutoButtonColor = false
    NODE[59].Modal = false
    NODE[59].Selected = false
    NODE[59].Active = true
    NODE[59].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[59].AutomaticSize = Enum.AutomaticSize.None
    NODE[59].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[59].BackgroundTransparency = 1
    NODE[59].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[59].BorderMode = Enum.BorderMode.Outline
    NODE[59].BorderSizePixel = 0
    NODE[59].ClipsDescendants = false
    NODE[59].Interactable = true
    NODE[59].LayoutOrder = 0
    NODE[59].Position = UDim2.new(0.238749921, 0, 0.238749996, 0)
    NODE[59].Rotation = 45
    NODE[59].Selectable = true
    NODE[59].Size = UDim2.new(0.0, 97, 0.0, 99)
    NODE[59].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[59].Visible = true
    NODE[59].ZIndex = 1
    NODE[59]:SetAttribute("Rotation", 315.0)
    NODE[59]:SetAttribute("Action", "Unlinked(ShortcutService)")
    NODE[59].Parent = NODE[56]
    NODE[60] = Instance.new("TextButton")
    NODE[60].Name = "Action-8"
    NODE[60].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[60].LineHeight = 1
    NODE[60].MaxVisibleGraphemes = -1
    NODE[60].OpenTypeFeatures = ""
    NODE[60].RichText = false
    NODE[60].Text = ""
    NODE[60].TextColor3 = Color3.fromRGB(0, 0, 0)
    NODE[60].TextDirection = Enum.TextDirection.LeftToRight
    NODE[60].TextScaled = false
    NODE[60].TextSize = 14
    NODE[60].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[60].TextStrokeTransparency = 1
    NODE[60].TextTransparency = 0
    NODE[60].TextTruncate = Enum.TextTruncate.None
    NODE[60].TextWrapped = false
    NODE[60].TextXAlignment = Enum.TextXAlignment.Center
    NODE[60].TextYAlignment = Enum.TextYAlignment.Center
    NODE[60].AutoButtonColor = false
    NODE[60].Modal = false
    NODE[60].Selected = false
    NODE[60].Active = true
    NODE[60].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[60].AutomaticSize = Enum.AutomaticSize.None
    NODE[60].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[60].BackgroundTransparency = 1
    NODE[60].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[60].BorderMode = Enum.BorderMode.Outline
    NODE[60].BorderSizePixel = 0
    NODE[60].ClipsDescendants = false
    NODE[60].Interactable = true
    NODE[60].LayoutOrder = 0
    NODE[60].Position = UDim2.new(0.764999986, 0, 0.757499993, 0)
    NODE[60].Rotation = 45
    NODE[60].Selectable = true
    NODE[60].Size = UDim2.new(0.0, 100, 0.0, 100)
    NODE[60].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[60].Visible = true
    NODE[60].ZIndex = 1
    NODE[60]:SetAttribute("Rotation", 135.0)
    NODE[60]:SetAttribute("Action", "Unlinked(ShortcutService)")
    NODE[60].Parent = NODE[56]
    NODE[61] = Instance.new("TextButton")
    NODE[61].Name = "Action-5"
    NODE[61].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[61].LineHeight = 1
    NODE[61].MaxVisibleGraphemes = -1
    NODE[61].OpenTypeFeatures = ""
    NODE[61].RichText = false
    NODE[61].Text = ""
    NODE[61].TextColor3 = Color3.fromRGB(0, 0, 0)
    NODE[61].TextDirection = Enum.TextDirection.LeftToRight
    NODE[61].TextScaled = false
    NODE[61].TextSize = 14
    NODE[61].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[61].TextStrokeTransparency = 1
    NODE[61].TextTransparency = 0
    NODE[61].TextTruncate = Enum.TextTruncate.None
    NODE[61].TextWrapped = false
    NODE[61].TextXAlignment = Enum.TextXAlignment.Center
    NODE[61].TextYAlignment = Enum.TextYAlignment.Center
    NODE[61].AutoButtonColor = false
    NODE[61].Modal = false
    NODE[61].Selected = false
    NODE[61].Active = true
    NODE[61].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[61].AutomaticSize = Enum.AutomaticSize.None
    NODE[61].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[61].BackgroundTransparency = 1
    NODE[61].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[61].BorderMode = Enum.BorderMode.Outline
    NODE[61].BorderSizePixel = 0
    NODE[61].ClipsDescendants = false
    NODE[61].Interactable = true
    NODE[61].LayoutOrder = 0
    NODE[61].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[61].Rotation = 0
    NODE[61].Selectable = true
    NODE[61].Size = UDim2.new(0.0, 100, 0.0, 100)
    NODE[61].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[61].Visible = true
    NODE[61].ZIndex = 1
    NODE[61]:SetAttribute("Rotation", 360.0)
    NODE[61]:SetAttribute("Action", "Unlinked(ShortcutService)")
    NODE[61].Parent = NODE[56]
    NODE[62] = Instance.new("TextButton")
    NODE[62].Name = "Action-3"
    NODE[62].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[62].LineHeight = 1
    NODE[62].MaxVisibleGraphemes = -1
    NODE[62].OpenTypeFeatures = ""
    NODE[62].RichText = false
    NODE[62].Text = ""
    NODE[62].TextColor3 = Color3.fromRGB(0, 0, 0)
    NODE[62].TextDirection = Enum.TextDirection.LeftToRight
    NODE[62].TextScaled = false
    NODE[62].TextSize = 14
    NODE[62].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[62].TextStrokeTransparency = 1
    NODE[62].TextTransparency = 0
    NODE[62].TextTruncate = Enum.TextTruncate.None
    NODE[62].TextWrapped = false
    NODE[62].TextXAlignment = Enum.TextXAlignment.Center
    NODE[62].TextYAlignment = Enum.TextYAlignment.Center
    NODE[62].AutoButtonColor = false
    NODE[62].Modal = false
    NODE[62].Selected = false
    NODE[62].Active = true
    NODE[62].AnchorPoint = Vector2.new(0.0, 0.5)
    NODE[62].AutomaticSize = Enum.AutomaticSize.None
    NODE[62].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[62].BackgroundTransparency = 1
    NODE[62].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[62].BorderMode = Enum.BorderMode.Outline
    NODE[62].BorderSizePixel = 0
    NODE[62].ClipsDescendants = false
    NODE[62].Interactable = true
    NODE[62].LayoutOrder = 0
    NODE[62].Position = UDim2.new(0.0, 0, 0.5, 0)
    NODE[62].Rotation = 0
    NODE[62].Selectable = true
    NODE[62].Size = UDim2.new(0.0, 100, 0.0, 100)
    NODE[62].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[62].Visible = true
    NODE[62].ZIndex = 1
    NODE[62]:SetAttribute("Rotation", 270.0)
    NODE[62]:SetAttribute("Action", "Unlinked(ShortcutService)")
    NODE[62].Parent = NODE[56]
    NODE[63] = Instance.new("TextButton")
    NODE[63].Name = "Action-7"
    NODE[63].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[63].LineHeight = 1
    NODE[63].MaxVisibleGraphemes = -1
    NODE[63].OpenTypeFeatures = ""
    NODE[63].RichText = false
    NODE[63].Text = ""
    NODE[63].TextColor3 = Color3.fromRGB(0, 0, 0)
    NODE[63].TextDirection = Enum.TextDirection.LeftToRight
    NODE[63].TextScaled = false
    NODE[63].TextSize = 14
    NODE[63].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[63].TextStrokeTransparency = 1
    NODE[63].TextTransparency = 0
    NODE[63].TextTruncate = Enum.TextTruncate.None
    NODE[63].TextWrapped = false
    NODE[63].TextXAlignment = Enum.TextXAlignment.Center
    NODE[63].TextYAlignment = Enum.TextYAlignment.Center
    NODE[63].AutoButtonColor = false
    NODE[63].Modal = false
    NODE[63].Selected = false
    NODE[63].Active = true
    NODE[63].AnchorPoint = Vector2.new(1.0, 0.5)
    NODE[63].AutomaticSize = Enum.AutomaticSize.None
    NODE[63].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[63].BackgroundTransparency = 1
    NODE[63].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[63].BorderMode = Enum.BorderMode.Outline
    NODE[63].BorderSizePixel = 0
    NODE[63].ClipsDescendants = false
    NODE[63].Interactable = true
    NODE[63].LayoutOrder = 0
    NODE[63].Position = UDim2.new(1.0, 0, 0.5, 0)
    NODE[63].Rotation = 0
    NODE[63].Selectable = true
    NODE[63].Size = UDim2.new(0.0, 100, 0.0, 100)
    NODE[63].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[63].Visible = true
    NODE[63].ZIndex = 1
    NODE[63]:SetAttribute("Rotation", 90.0)
    NODE[63]:SetAttribute("Action", "Unlinked(ShortcutService)")
    NODE[63].Parent = NODE[56]
    NODE[64] = Instance.new("TextButton")
    NODE[64].Name = "Action-2"
    NODE[64].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[64].LineHeight = 1
    NODE[64].MaxVisibleGraphemes = -1
    NODE[64].OpenTypeFeatures = ""
    NODE[64].RichText = false
    NODE[64].Text = ""
    NODE[64].TextColor3 = Color3.fromRGB(0, 0, 0)
    NODE[64].TextDirection = Enum.TextDirection.LeftToRight
    NODE[64].TextScaled = false
    NODE[64].TextSize = 14
    NODE[64].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[64].TextStrokeTransparency = 1
    NODE[64].TextTransparency = 0
    NODE[64].TextTruncate = Enum.TextTruncate.None
    NODE[64].TextWrapped = false
    NODE[64].TextXAlignment = Enum.TextXAlignment.Center
    NODE[64].TextYAlignment = Enum.TextYAlignment.Center
    NODE[64].AutoButtonColor = false
    NODE[64].Modal = false
    NODE[64].Selected = false
    NODE[64].Active = true
    NODE[64].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[64].AutomaticSize = Enum.AutomaticSize.None
    NODE[64].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[64].BackgroundTransparency = 1
    NODE[64].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[64].BorderMode = Enum.BorderMode.Outline
    NODE[64].BorderSizePixel = 0
    NODE[64].ClipsDescendants = false
    NODE[64].Interactable = true
    NODE[64].LayoutOrder = 0
    NODE[64].Position = UDim2.new(0.233250126, 0, 0.768249989, 0)
    NODE[64].Rotation = 45
    NODE[64].Selectable = true
    NODE[64].Size = UDim2.new(0.0, 100, 0.0, 100)
    NODE[64].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[64].Visible = true
    NODE[64].ZIndex = 1
    NODE[64]:SetAttribute("Rotation", 225.0)
    NODE[64]:SetAttribute("Action", "Unlinked(ShortcutService)")
    NODE[64].Parent = NODE[56]
    NODE[65] = Instance.new("TextButton")
    NODE[65].Name = "Close"
    NODE[65].FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular)
    NODE[65].LineHeight = 1
    NODE[65].MaxVisibleGraphemes = -1
    NODE[65].OpenTypeFeatures = ""
    NODE[65].RichText = false
    NODE[65].Text = ""
    NODE[65].TextColor3 = Color3.fromRGB(255, 65, 68)
    NODE[65].TextDirection = Enum.TextDirection.LeftToRight
    NODE[65].TextScaled = true
    NODE[65].TextSize = 14
    NODE[65].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[65].TextStrokeTransparency = 1
    NODE[65].TextTransparency = 0
    NODE[65].TextTruncate = Enum.TextTruncate.None
    NODE[65].TextWrapped = true
    NODE[65].TextXAlignment = Enum.TextXAlignment.Center
    NODE[65].TextYAlignment = Enum.TextYAlignment.Center
    NODE[65].AutoButtonColor = true
    NODE[65].Modal = false
    NODE[65].Selected = false
    NODE[65].Active = true
    NODE[65].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[65].AutomaticSize = Enum.AutomaticSize.None
    NODE[65].BackgroundColor3 = Color3.fromRGB(255, 65, 68)
    NODE[65].BackgroundTransparency = 0
    NODE[65].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[65].BorderMode = Enum.BorderMode.Outline
    NODE[65].BorderSizePixel = 0
    NODE[65].ClipsDescendants = false
    NODE[65].Interactable = true
    NODE[65].LayoutOrder = 0
    NODE[65].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[65].Rotation = 0
    NODE[65].Selectable = true
    NODE[65].Size = UDim2.new(0.5, 2, 0.5, 2)
    NODE[65].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[65].Visible = true
    NODE[65].ZIndex = 5
    NODE[66] = Instance.new("UICorner")
    NODE[66].Name = "UICorner"
    NODE[66].CornerRadius = UDim.new(0.0, 2500)
    NODE[66].CornerRadius = UDim.new(0.0, 2500)
    NODE[66].CornerRadius = UDim.new(0.0, 2500)
    NODE[66].CornerRadius = UDim.new(0.0, 2500)
    NODE[66].Parent = NODE[65]
    NODE[67] = Instance.new("ImageLabel")
    NODE[67].Name = "Close"
    NODE[67].Image = "rbxassetid://70449303391980"
    NODE[67].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[67].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[67].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[67].ImageTransparency = 0
    NODE[67].ResampleMode = Enum.ResamplerMode.Default
    NODE[67].ScaleType = Enum.ScaleType.Stretch
    NODE[67].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[67].SliceScale = 1
    NODE[67].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[67].Active = false
    NODE[67].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[67].AutomaticSize = Enum.AutomaticSize.None
    NODE[67].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[67].BackgroundTransparency = 1
    NODE[67].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[67].BorderMode = Enum.BorderMode.Outline
    NODE[67].BorderSizePixel = 0
    NODE[67].ClipsDescendants = false
    NODE[67].Interactable = true
    NODE[67].LayoutOrder = 0
    NODE[67].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[67].Rotation = 0
    NODE[67].Selectable = false
    NODE[67].Size = UDim2.new(0.0, 25, 0.0, 25)
    NODE[67].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[67].Visible = true
    NODE[67].ZIndex = 10
    NODE[67].Parent = NODE[65]
    NODE[65].Parent = NODE[56]
    NODE[68] = Instance.new("Frame")
    NODE[68].Name = "Hover"
    NODE[68].Active = false
    NODE[68].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[68].AutomaticSize = Enum.AutomaticSize.None
    NODE[68].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[68].BackgroundTransparency = 1
    NODE[68].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[68].BorderMode = Enum.BorderMode.Outline
    NODE[68].BorderSizePixel = 0
    NODE[68].ClipsDescendants = false
    NODE[68].Interactable = true
    NODE[68].LayoutOrder = 0
    NODE[68].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[68].Rotation = 225
    NODE[68].Selectable = false
    NODE[68].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[68].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[68].Visible = true
    NODE[68].ZIndex = 2
    NODE[69] = Instance.new("ImageLabel")
    NODE[69].Name = "Tint"
    NODE[69].Image = "rbxassetid://113595381510795"
    NODE[69].ImageColor3 = Color3.fromRGB(10, 10, 10)
    NODE[69].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[69].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[69].ImageTransparency = 0
    NODE[69].ResampleMode = Enum.ResamplerMode.Default
    NODE[69].ScaleType = Enum.ScaleType.Stretch
    NODE[69].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[69].SliceScale = 1
    NODE[69].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[69].Active = false
    NODE[69].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[69].AutomaticSize = Enum.AutomaticSize.None
    NODE[69].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[69].BackgroundTransparency = 1
    NODE[69].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[69].BorderMode = Enum.BorderMode.Outline
    NODE[69].BorderSizePixel = 0
    NODE[69].ClipsDescendants = false
    NODE[69].Interactable = true
    NODE[69].LayoutOrder = 0
    NODE[69].Position = UDim2.new(0.5, 0, 0.0, -1)
    NODE[69].Rotation = 0
    NODE[69].Selectable = false
    NODE[69].Size = UDim2.new(0.389999986, -3, 0.273000002, 0)
    NODE[69].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[69].Visible = true
    NODE[69].ZIndex = 1
    NODE[69].Parent = NODE[68]
    NODE[68].Parent = NODE[56]
    NODE[70] = Instance.new("UICorner")
    NODE[70].Name = "UICorner"
    NODE[70].CornerRadius = UDim.new(0.0, 2500)
    NODE[70].CornerRadius = UDim.new(0.0, 2500)
    NODE[70].CornerRadius = UDim.new(0.0, 2500)
    NODE[70].CornerRadius = UDim.new(0.0, 2500)
    NODE[70].Parent = NODE[56]
    NODE[56].Parent = NODE[55]
    NODE[71] = Instance.new("Frame")
    NODE[71].Name = "Icons"
    NODE[71].Active = false
    NODE[71].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[71].AutomaticSize = Enum.AutomaticSize.None
    NODE[71].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[71].BackgroundTransparency = 1
    NODE[71].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[71].BorderMode = Enum.BorderMode.Outline
    NODE[71].BorderSizePixel = 0
    NODE[71].ClipsDescendants = false
    NODE[71].Interactable = true
    NODE[71].LayoutOrder = 0
    NODE[71].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[71].Rotation = 0
    NODE[71].Selectable = false
    NODE[71].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[71].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[71].Visible = true
    NODE[71].ZIndex = 5
    NODE[72] = Instance.new("ImageLabel")
    NODE[72].Name = "Action-3"
    NODE[72].Image = "rbxassetid://11963369532"
    NODE[72].ImageColor3 = Color3.fromRGB(215, 215, 215)
    NODE[72].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[72].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[72].ImageTransparency = 0
    NODE[72].ResampleMode = Enum.ResamplerMode.Default
    NODE[72].ScaleType = Enum.ScaleType.Stretch
    NODE[72].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[72].SliceScale = 1
    NODE[72].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[72].Active = false
    NODE[72].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[72].AutomaticSize = Enum.AutomaticSize.None
    NODE[72].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[72].BackgroundTransparency = 1
    NODE[72].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[72].BorderMode = Enum.BorderMode.Outline
    NODE[72].BorderSizePixel = 0
    NODE[72].ClipsDescendants = false
    NODE[72].Interactable = true
    NODE[72].LayoutOrder = 0
    NODE[72].Position = UDim2.new(0.125, 0, 0.5, 0)
    NODE[72].Rotation = 0
    NODE[72].Selectable = false
    NODE[72].Size = UDim2.new(0.100000001, 0, 0.100000001, 0)
    NODE[72].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[72].Visible = true
    NODE[72].ZIndex = 1
    NODE[73] = Instance.new("UIAspectRatioConstraint")
    NODE[73].Name = "UIAspectRatioConstraint"
    NODE[73].AspectRatio = 1
    NODE[73].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[73].DominantAxis = Enum.DominantAxis.Width
    NODE[73].Parent = NODE[72]
    NODE[74] = Instance.new("ImageLabel")
    NODE[74].Name = "UtilitiesCustomCommand"
    NODE[74].Image = "rbxassetid://11963369532"
    NODE[74].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[74].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[74].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[74].ImageTransparency = 0
    NODE[74].ResampleMode = Enum.ResamplerMode.Default
    NODE[74].ScaleType = Enum.ScaleType.Stretch
    NODE[74].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[74].SliceScale = 1
    NODE[74].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[74].Active = false
    NODE[74].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[74].AutomaticSize = Enum.AutomaticSize.None
    NODE[74].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[74].BackgroundTransparency = 0
    NODE[74].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[74].BorderMode = Enum.BorderMode.Outline
    NODE[74].BorderSizePixel = 0
    NODE[74].ClipsDescendants = false
    NODE[74].Interactable = true
    NODE[74].LayoutOrder = 0
    NODE[74].Position = UDim2.new(1.0, 10, 1.0, 10)
    NODE[74].Rotation = 0
    NODE[74].Selectable = false
    NODE[74].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
    NODE[74].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[74].Visible = false
    NODE[74].ZIndex = 1
    NODE[75] = Instance.new("UIAspectRatioConstraint")
    NODE[75].Name = "UIAspectRatioConstraint"
    NODE[75].AspectRatio = 1
    NODE[75].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[75].DominantAxis = Enum.DominantAxis.Width
    NODE[75].Parent = NODE[74]
    NODE[74].Parent = NODE[72]
    NODE[72].Parent = NODE[71]
    NODE[76] = Instance.new("ImageLabel")
    NODE[76].Name = "Action-8"
    NODE[76].Image = "rbxassetid://11963369532"
    NODE[76].ImageColor3 = Color3.fromRGB(215, 215, 215)
    NODE[76].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[76].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[76].ImageTransparency = 0
    NODE[76].ResampleMode = Enum.ResamplerMode.Default
    NODE[76].ScaleType = Enum.ScaleType.Stretch
    NODE[76].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[76].SliceScale = 1
    NODE[76].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[76].Active = false
    NODE[76].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[76].AutomaticSize = Enum.AutomaticSize.None
    NODE[76].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[76].BackgroundTransparency = 1
    NODE[76].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[76].BorderMode = Enum.BorderMode.Outline
    NODE[76].BorderSizePixel = 0
    NODE[76].ClipsDescendants = false
    NODE[76].Interactable = true
    NODE[76].LayoutOrder = 0
    NODE[76].Position = UDim2.new(0.764999986, 0, 0.762000024, 0)
    NODE[76].Rotation = 0
    NODE[76].Selectable = false
    NODE[76].Size = UDim2.new(0.100000001, 0, 0.100000001, 0)
    NODE[76].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[76].Visible = true
    NODE[76].ZIndex = 1
    NODE[77] = Instance.new("UIAspectRatioConstraint")
    NODE[77].Name = "UIAspectRatioConstraint"
    NODE[77].AspectRatio = 1
    NODE[77].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[77].DominantAxis = Enum.DominantAxis.Width
    NODE[77].Parent = NODE[76]
    NODE[78] = Instance.new("ImageLabel")
    NODE[78].Name = "UtilitiesCustomCommand"
    NODE[78].Image = "rbxassetid://11963369532"
    NODE[78].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[78].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[78].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[78].ImageTransparency = 0
    NODE[78].ResampleMode = Enum.ResamplerMode.Default
    NODE[78].ScaleType = Enum.ScaleType.Stretch
    NODE[78].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[78].SliceScale = 1
    NODE[78].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[78].Active = false
    NODE[78].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[78].AutomaticSize = Enum.AutomaticSize.None
    NODE[78].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[78].BackgroundTransparency = 0
    NODE[78].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[78].BorderMode = Enum.BorderMode.Outline
    NODE[78].BorderSizePixel = 0
    NODE[78].ClipsDescendants = false
    NODE[78].Interactable = true
    NODE[78].LayoutOrder = 0
    NODE[78].Position = UDim2.new(1.0, 10, 1.0, 10)
    NODE[78].Rotation = 0
    NODE[78].Selectable = false
    NODE[78].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
    NODE[78].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[78].Visible = false
    NODE[78].ZIndex = 1
    NODE[79] = Instance.new("UIAspectRatioConstraint")
    NODE[79].Name = "UIAspectRatioConstraint"
    NODE[79].AspectRatio = 1
    NODE[79].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[79].DominantAxis = Enum.DominantAxis.Width
    NODE[79].Parent = NODE[78]
    NODE[78].Parent = NODE[76]
    NODE[76].Parent = NODE[71]
    NODE[80] = Instance.new("ImageLabel")
    NODE[80].Name = "Action-5"
    NODE[80].Image = "rbxassetid://11963369532"
    NODE[80].ImageColor3 = Color3.fromRGB(215, 215, 215)
    NODE[80].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[80].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[80].ImageTransparency = 0
    NODE[80].ResampleMode = Enum.ResamplerMode.Default
    NODE[80].ScaleType = Enum.ScaleType.Stretch
    NODE[80].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[80].SliceScale = 1
    NODE[80].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[80].Active = false
    NODE[80].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[80].AutomaticSize = Enum.AutomaticSize.None
    NODE[80].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[80].BackgroundTransparency = 1
    NODE[80].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[80].BorderMode = Enum.BorderMode.Outline
    NODE[80].BorderSizePixel = 0
    NODE[80].ClipsDescendants = false
    NODE[80].Interactable = true
    NODE[80].LayoutOrder = 0
    NODE[80].Position = UDim2.new(0.5, 0, 0.125, 0)
    NODE[80].Rotation = 0
    NODE[80].Selectable = false
    NODE[80].Size = UDim2.new(0.100000001, 0, 0.100000001, 0)
    NODE[80].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[80].Visible = true
    NODE[80].ZIndex = 1
    NODE[81] = Instance.new("UIAspectRatioConstraint")
    NODE[81].Name = "UIAspectRatioConstraint"
    NODE[81].AspectRatio = 1
    NODE[81].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[81].DominantAxis = Enum.DominantAxis.Width
    NODE[81].Parent = NODE[80]
    NODE[82] = Instance.new("ImageLabel")
    NODE[82].Name = "UtilitiesCustomCommand"
    NODE[82].Image = "rbxassetid://11963369532"
    NODE[82].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[82].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[82].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[82].ImageTransparency = 0
    NODE[82].ResampleMode = Enum.ResamplerMode.Default
    NODE[82].ScaleType = Enum.ScaleType.Stretch
    NODE[82].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[82].SliceScale = 1
    NODE[82].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[82].Active = false
    NODE[82].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[82].AutomaticSize = Enum.AutomaticSize.None
    NODE[82].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[82].BackgroundTransparency = 0
    NODE[82].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[82].BorderMode = Enum.BorderMode.Outline
    NODE[82].BorderSizePixel = 0
    NODE[82].ClipsDescendants = false
    NODE[82].Interactable = true
    NODE[82].LayoutOrder = 0
    NODE[82].Position = UDim2.new(1.0, 10, 1.0, 10)
    NODE[82].Rotation = 0
    NODE[82].Selectable = false
    NODE[82].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
    NODE[82].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[82].Visible = false
    NODE[82].ZIndex = 1
    NODE[83] = Instance.new("UIAspectRatioConstraint")
    NODE[83].Name = "UIAspectRatioConstraint"
    NODE[83].AspectRatio = 1
    NODE[83].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[83].DominantAxis = Enum.DominantAxis.Width
    NODE[83].Parent = NODE[82]
    NODE[82].Parent = NODE[80]
    NODE[80].Parent = NODE[71]
    NODE[84] = Instance.new("ImageLabel")
    NODE[84].Name = "Action-4"
    NODE[84].Image = "rbxassetid://11963369532"
    NODE[84].ImageColor3 = Color3.fromRGB(215, 215, 215)
    NODE[84].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[84].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[84].ImageTransparency = 0
    NODE[84].ResampleMode = Enum.ResamplerMode.Default
    NODE[84].ScaleType = Enum.ScaleType.Stretch
    NODE[84].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[84].SliceScale = 1
    NODE[84].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[84].Active = false
    NODE[84].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[84].AutomaticSize = Enum.AutomaticSize.None
    NODE[84].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[84].BackgroundTransparency = 1
    NODE[84].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[84].BorderMode = Enum.BorderMode.Outline
    NODE[84].BorderSizePixel = 0
    NODE[84].ClipsDescendants = false
    NODE[84].Interactable = true
    NODE[84].LayoutOrder = 0
    NODE[84].Position = UDim2.new(0.230000004, 0, 0.230000004, 0)
    NODE[84].Rotation = 0
    NODE[84].Selectable = false
    NODE[84].Size = UDim2.new(0.100000001, 0, 0.100000001, 0)
    NODE[84].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[84].Visible = true
    NODE[84].ZIndex = 1
    NODE[85] = Instance.new("UIAspectRatioConstraint")
    NODE[85].Name = "UIAspectRatioConstraint"
    NODE[85].AspectRatio = 1
    NODE[85].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[85].DominantAxis = Enum.DominantAxis.Width
    NODE[85].Parent = NODE[84]
    NODE[86] = Instance.new("ImageLabel")
    NODE[86].Name = "UtilitiesCustomCommand"
    NODE[86].Image = "rbxassetid://11963369532"
    NODE[86].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[86].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[86].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[86].ImageTransparency = 0
    NODE[86].ResampleMode = Enum.ResamplerMode.Default
    NODE[86].ScaleType = Enum.ScaleType.Stretch
    NODE[86].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[86].SliceScale = 1
    NODE[86].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[86].Active = false
    NODE[86].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[86].AutomaticSize = Enum.AutomaticSize.None
    NODE[86].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[86].BackgroundTransparency = 0
    NODE[86].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[86].BorderMode = Enum.BorderMode.Outline
    NODE[86].BorderSizePixel = 0
    NODE[86].ClipsDescendants = false
    NODE[86].Interactable = true
    NODE[86].LayoutOrder = 0
    NODE[86].Position = UDim2.new(1.0, 10, 1.0, 10)
    NODE[86].Rotation = 0
    NODE[86].Selectable = false
    NODE[86].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
    NODE[86].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[86].Visible = false
    NODE[86].ZIndex = 1
    NODE[87] = Instance.new("UIAspectRatioConstraint")
    NODE[87].Name = "UIAspectRatioConstraint"
    NODE[87].AspectRatio = 1
    NODE[87].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[87].DominantAxis = Enum.DominantAxis.Width
    NODE[87].Parent = NODE[86]
    NODE[86].Parent = NODE[84]
    NODE[84].Parent = NODE[71]
    NODE[88] = Instance.new("ImageLabel")
    NODE[88].Name = "Action-6"
    NODE[88].Image = "rbxassetid://11963369532"
    NODE[88].ImageColor3 = Color3.fromRGB(215, 215, 215)
    NODE[88].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[88].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[88].ImageTransparency = 0
    NODE[88].ResampleMode = Enum.ResamplerMode.Default
    NODE[88].ScaleType = Enum.ScaleType.Stretch
    NODE[88].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[88].SliceScale = 1
    NODE[88].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[88].Active = false
    NODE[88].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[88].AutomaticSize = Enum.AutomaticSize.None
    NODE[88].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[88].BackgroundTransparency = 1
    NODE[88].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[88].BorderMode = Enum.BorderMode.Outline
    NODE[88].BorderSizePixel = 0
    NODE[88].ClipsDescendants = false
    NODE[88].Interactable = true
    NODE[88].LayoutOrder = 0
    NODE[88].Position = UDim2.new(0.764999986, 0, 0.230000004, 0)
    NODE[88].Rotation = 0
    NODE[88].Selectable = false
    NODE[88].Size = UDim2.new(0.100000001, 0, 0.100000001, 0)
    NODE[88].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[88].Visible = true
    NODE[88].ZIndex = 1
    NODE[89] = Instance.new("UIAspectRatioConstraint")
    NODE[89].Name = "UIAspectRatioConstraint"
    NODE[89].AspectRatio = 1
    NODE[89].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[89].DominantAxis = Enum.DominantAxis.Width
    NODE[89].Parent = NODE[88]
    NODE[90] = Instance.new("ImageLabel")
    NODE[90].Name = "UtilitiesCustomCommand"
    NODE[90].Image = "rbxassetid://11963369532"
    NODE[90].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[90].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[90].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[90].ImageTransparency = 0
    NODE[90].ResampleMode = Enum.ResamplerMode.Default
    NODE[90].ScaleType = Enum.ScaleType.Stretch
    NODE[90].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[90].SliceScale = 1
    NODE[90].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[90].Active = false
    NODE[90].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[90].AutomaticSize = Enum.AutomaticSize.None
    NODE[90].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[90].BackgroundTransparency = 0
    NODE[90].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[90].BorderMode = Enum.BorderMode.Outline
    NODE[90].BorderSizePixel = 0
    NODE[90].ClipsDescendants = false
    NODE[90].Interactable = true
    NODE[90].LayoutOrder = 0
    NODE[90].Position = UDim2.new(1.0, 10, 1.0, 10)
    NODE[90].Rotation = 0
    NODE[90].Selectable = false
    NODE[90].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
    NODE[90].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[90].Visible = false
    NODE[90].ZIndex = 1
    NODE[91] = Instance.new("UIAspectRatioConstraint")
    NODE[91].Name = "UIAspectRatioConstraint"
    NODE[91].AspectRatio = 1
    NODE[91].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[91].DominantAxis = Enum.DominantAxis.Width
    NODE[91].Parent = NODE[90]
    NODE[90].Parent = NODE[88]
    NODE[88].Parent = NODE[71]
    NODE[92] = Instance.new("ImageLabel")
    NODE[92].Name = "Action-7"
    NODE[92].Image = "rbxassetid://11963369532"
    NODE[92].ImageColor3 = Color3.fromRGB(215, 215, 215)
    NODE[92].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[92].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[92].ImageTransparency = 0
    NODE[92].ResampleMode = Enum.ResamplerMode.Default
    NODE[92].ScaleType = Enum.ScaleType.Stretch
    NODE[92].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[92].SliceScale = 1
    NODE[92].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[92].Active = false
    NODE[92].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[92].AutomaticSize = Enum.AutomaticSize.None
    NODE[92].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[92].BackgroundTransparency = 1
    NODE[92].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[92].BorderMode = Enum.BorderMode.Outline
    NODE[92].BorderSizePixel = 0
    NODE[92].ClipsDescendants = false
    NODE[92].Interactable = true
    NODE[92].LayoutOrder = 0
    NODE[92].Position = UDim2.new(0.875, 0, 0.5, 0)
    NODE[92].Rotation = 0
    NODE[92].Selectable = false
    NODE[92].Size = UDim2.new(0.100000001, 0, 0.100000001, 0)
    NODE[92].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[92].Visible = true
    NODE[92].ZIndex = 1
    NODE[93] = Instance.new("UIAspectRatioConstraint")
    NODE[93].Name = "UIAspectRatioConstraint"
    NODE[93].AspectRatio = 1
    NODE[93].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[93].DominantAxis = Enum.DominantAxis.Width
    NODE[93].Parent = NODE[92]
    NODE[94] = Instance.new("ImageLabel")
    NODE[94].Name = "UtilitiesCustomCommand"
    NODE[94].Image = "rbxassetid://11963369532"
    NODE[94].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[94].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[94].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[94].ImageTransparency = 0
    NODE[94].ResampleMode = Enum.ResamplerMode.Default
    NODE[94].ScaleType = Enum.ScaleType.Stretch
    NODE[94].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[94].SliceScale = 1
    NODE[94].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[94].Active = false
    NODE[94].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[94].AutomaticSize = Enum.AutomaticSize.None
    NODE[94].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[94].BackgroundTransparency = 0
    NODE[94].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[94].BorderMode = Enum.BorderMode.Outline
    NODE[94].BorderSizePixel = 0
    NODE[94].ClipsDescendants = false
    NODE[94].Interactable = true
    NODE[94].LayoutOrder = 0
    NODE[94].Position = UDim2.new(1.0, 10, 1.0, 10)
    NODE[94].Rotation = 0
    NODE[94].Selectable = false
    NODE[94].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
    NODE[94].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[94].Visible = false
    NODE[94].ZIndex = 1
    NODE[95] = Instance.new("UIAspectRatioConstraint")
    NODE[95].Name = "UIAspectRatioConstraint"
    NODE[95].AspectRatio = 1
    NODE[95].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[95].DominantAxis = Enum.DominantAxis.Width
    NODE[95].Parent = NODE[94]
    NODE[94].Parent = NODE[92]
    NODE[92].Parent = NODE[71]
    NODE[96] = Instance.new("ImageLabel")
    NODE[96].Name = "Action-2"
    NODE[96].Image = "rbxassetid://11963369532"
    NODE[96].ImageColor3 = Color3.fromRGB(215, 215, 215)
    NODE[96].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[96].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[96].ImageTransparency = 0
    NODE[96].ResampleMode = Enum.ResamplerMode.Default
    NODE[96].ScaleType = Enum.ScaleType.Stretch
    NODE[96].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[96].SliceScale = 1
    NODE[96].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[96].Active = false
    NODE[96].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[96].AutomaticSize = Enum.AutomaticSize.None
    NODE[96].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[96].BackgroundTransparency = 1
    NODE[96].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[96].BorderMode = Enum.BorderMode.Outline
    NODE[96].BorderSizePixel = 0
    NODE[96].ClipsDescendants = false
    NODE[96].Interactable = true
    NODE[96].LayoutOrder = 0
    NODE[96].Position = UDim2.new(0.239999995, 0, 0.754999995, 0)
    NODE[96].Rotation = 0
    NODE[96].Selectable = false
    NODE[96].Size = UDim2.new(0.100000001, 0, 0.100000001, 0)
    NODE[96].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[96].Visible = true
    NODE[96].ZIndex = 1
    NODE[97] = Instance.new("UIAspectRatioConstraint")
    NODE[97].Name = "UIAspectRatioConstraint"
    NODE[97].AspectRatio = 1
    NODE[97].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[97].DominantAxis = Enum.DominantAxis.Width
    NODE[97].Parent = NODE[96]
    NODE[98] = Instance.new("ImageLabel")
    NODE[98].Name = "UtilitiesCustomCommand"
    NODE[98].Image = "rbxassetid://11963369532"
    NODE[98].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[98].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[98].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[98].ImageTransparency = 0
    NODE[98].ResampleMode = Enum.ResamplerMode.Default
    NODE[98].ScaleType = Enum.ScaleType.Stretch
    NODE[98].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[98].SliceScale = 1
    NODE[98].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[98].Active = false
    NODE[98].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[98].AutomaticSize = Enum.AutomaticSize.None
    NODE[98].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[98].BackgroundTransparency = 0
    NODE[98].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[98].BorderMode = Enum.BorderMode.Outline
    NODE[98].BorderSizePixel = 0
    NODE[98].ClipsDescendants = false
    NODE[98].Interactable = true
    NODE[98].LayoutOrder = 0
    NODE[98].Position = UDim2.new(1.0, 10, 1.0, 10)
    NODE[98].Rotation = 0
    NODE[98].Selectable = false
    NODE[98].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
    NODE[98].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[98].Visible = false
    NODE[98].ZIndex = 1
    NODE[99] = Instance.new("UIAspectRatioConstraint")
    NODE[99].Name = "UIAspectRatioConstraint"
    NODE[99].AspectRatio = 1
    NODE[99].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[99].DominantAxis = Enum.DominantAxis.Width
    NODE[99].Parent = NODE[98]
    NODE[98].Parent = NODE[96]
    NODE[96].Parent = NODE[71]
    NODE[100] = Instance.new("ImageLabel")
    NODE[100].Name = "Action-1"
    NODE[100].Image = "rbxassetid://11963369532"
    NODE[100].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[100].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[100].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[100].ImageTransparency = 0
    NODE[100].ResampleMode = Enum.ResamplerMode.Default
    NODE[100].ScaleType = Enum.ScaleType.Stretch
    NODE[100].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[100].SliceScale = 1
    NODE[100].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[100].Active = false
    NODE[100].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[100].AutomaticSize = Enum.AutomaticSize.None
    NODE[100].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[100].BackgroundTransparency = 1
    NODE[100].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[100].BorderMode = Enum.BorderMode.Outline
    NODE[100].BorderSizePixel = 0
    NODE[100].ClipsDescendants = false
    NODE[100].Interactable = true
    NODE[100].LayoutOrder = 0
    NODE[100].Position = UDim2.new(0.5, 0, 0.875, 0)
    NODE[100].Rotation = 0
    NODE[100].Selectable = false
    NODE[100].Size = UDim2.new(0.100000001, 0, 0.100000001, 0)
    NODE[100].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[100].Visible = true
    NODE[100].ZIndex = 1
    NODE[101] = Instance.new("UIAspectRatioConstraint")
    NODE[101].Name = "UIAspectRatioConstraint"
    NODE[101].AspectRatio = 1
    NODE[101].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[101].DominantAxis = Enum.DominantAxis.Width
    NODE[101].Parent = NODE[100]
    NODE[102] = Instance.new("ImageLabel")
    NODE[102].Name = "UtilitiesCustomCommand"
    NODE[102].Image = "rbxassetid://11963369532"
    NODE[102].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[102].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[102].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[102].ImageTransparency = 0
    NODE[102].ResampleMode = Enum.ResamplerMode.Default
    NODE[102].ScaleType = Enum.ScaleType.Stretch
    NODE[102].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[102].SliceScale = 1
    NODE[102].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[102].Active = false
    NODE[102].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[102].AutomaticSize = Enum.AutomaticSize.None
    NODE[102].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[102].BackgroundTransparency = 0
    NODE[102].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[102].BorderMode = Enum.BorderMode.Outline
    NODE[102].BorderSizePixel = 0
    NODE[102].ClipsDescendants = false
    NODE[102].Interactable = true
    NODE[102].LayoutOrder = 0
    NODE[102].Position = UDim2.new(1.0, 10, 1.0, 10)
    NODE[102].Rotation = 0
    NODE[102].Selectable = false
    NODE[102].Size = UDim2.new(0.600000024, 0, 0.600000024, 0)
    NODE[102].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[102].Visible = false
    NODE[102].ZIndex = 1
    NODE[103] = Instance.new("UIAspectRatioConstraint")
    NODE[103].Name = "UIAspectRatioConstraint"
    NODE[103].AspectRatio = 1
    NODE[103].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[103].DominantAxis = Enum.DominantAxis.Width
    NODE[103].Parent = NODE[102]
    NODE[102].Parent = NODE[100]
    NODE[100].Parent = NODE[71]
    NODE[71].Parent = NODE[55]
    NODE[55].Parent = NODE[54]
    NODE[54].Parent = ShortcutsGui
    NODE[104] = Instance.new("Frame")
    NODE[104].Name = "<< Modals >>"
    NODE[104].Active = false
    NODE[104].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[104].AutomaticSize = Enum.AutomaticSize.None
    NODE[104].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[104].BackgroundTransparency = 1
    NODE[104].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[104].BorderMode = Enum.BorderMode.Outline
    NODE[104].BorderSizePixel = 0
    NODE[104].ClipsDescendants = false
    NODE[104].Interactable = true
    NODE[104].LayoutOrder = 0
    NODE[104].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[104].Rotation = 0
    NODE[104].Selectable = false
    NODE[104].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[104].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[104].Visible = true
    NODE[104].ZIndex = 1
    NODE[105] = Instance.new("ImageLabel")
    NODE[105].Name = "<< ShortcutParameter >>"
    NODE[105].Image = "rbxassetid://72548733587158"
    NODE[105].ImageColor3 = Color3.fromRGB(0, 0, 0)
    NODE[105].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[105].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[105].ImageTransparency = 0
    NODE[105].ResampleMode = Enum.ResamplerMode.Default
    NODE[105].ScaleType = Enum.ScaleType.Slice
    NODE[105].SliceCenter = Rect.new(300, 300, 300, 300)
    NODE[105].SliceScale = 0.5
    NODE[105].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[105].Active = false
    NODE[105].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[105].AutomaticSize = Enum.AutomaticSize.None
    NODE[105].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[105].BackgroundTransparency = 1
    NODE[105].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[105].BorderMode = Enum.BorderMode.Outline
    NODE[105].BorderSizePixel = 0
    NODE[105].ClipsDescendants = false
    NODE[105].Interactable = true
    NODE[105].LayoutOrder = 0
    NODE[105].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[105].Rotation = 0
    NODE[105].Selectable = true
    NODE[105].Size = UDim2.new(0.0, 500, 0.0, 650)
    NODE[105].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[105].Visible = false
    NODE[105].ZIndex = 9
    NODE[106] = Instance.new("ImageButton")
    NODE[106].Name = "frame"
    NODE[106].HoverImage = ""
    NODE[106].Image = "rbxassetid://125088425775676"
    NODE[106].ImageColor3 = Color3.fromRGB(18, 18, 18)
    NODE[106].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[106].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[106].ImageTransparency = 0
    NODE[106].PressedImage = ""
    NODE[106].ResampleMode = Enum.ResamplerMode.Default
    NODE[106].ScaleType = Enum.ScaleType.Slice
    NODE[106].SliceCenter = Rect.new(512, 512, 512, 512)
    NODE[106].SliceScale = 0.119999997
    NODE[106].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[106].AutoButtonColor = false
    NODE[106].Modal = true
    NODE[106].Selected = false
    NODE[106].Active = true
    NODE[106].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[106].AutomaticSize = Enum.AutomaticSize.None
    NODE[106].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[106].BackgroundTransparency = 1
    NODE[106].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[106].BorderMode = Enum.BorderMode.Outline
    NODE[106].BorderSizePixel = 0
    NODE[106].ClipsDescendants = false
    NODE[106].Interactable = true
    NODE[106].LayoutOrder = 0
    NODE[106].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[106].Rotation = 0
    NODE[106].Selectable = true
    NODE[106].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[106].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[106].Visible = true
    NODE[106].ZIndex = 1
    NODE[107] = Instance.new("CanvasGroup")
    NODE[107].Name = "content"
    NODE[107].GroupColor3 = Color3.fromRGB(255, 255, 255)
    NODE[107].GroupTransparency = 0
    NODE[107].Active = false
    NODE[107].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[107].AutomaticSize = Enum.AutomaticSize.None
    NODE[107].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[107].BackgroundTransparency = 1
    NODE[107].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[107].BorderMode = Enum.BorderMode.Outline
    NODE[107].BorderSizePixel = 0
    NODE[107].ClipsDescendants = true
    NODE[107].Interactable = true
    NODE[107].LayoutOrder = 0
    NODE[107].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[107].Rotation = 0
    NODE[107].Selectable = false
    NODE[107].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[107].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[107].Visible = true
    NODE[107].ZIndex = 1
    NODE[108] = Instance.new("UICorner")
    NODE[108].Name = "corner"
    NODE[108].CornerRadius = UDim.new(0.0, 36)
    NODE[108].CornerRadius = UDim.new(0.0, 36)
    NODE[108].CornerRadius = UDim.new(0.0, 36)
    NODE[108].CornerRadius = UDim.new(0.0, 36)
    NODE[108].Parent = NODE[107]
    NODE[109] = Instance.new("UIPadding")
    NODE[109].Name = "padding"
    NODE[109].PaddingBottom = UDim.new(0.0, 0)
    NODE[109].PaddingLeft = UDim.new(0.0, 10)
    NODE[109].PaddingRight = UDim.new(0.0, 10)
    NODE[109].PaddingTop = UDim.new(0.0, 10)
    NODE[109].Parent = NODE[107]
    NODE[110] = Instance.new("ScrollingFrame")
    NODE[110].Name = "scroll"
    NODE[110].AutomaticCanvasSize = Enum.AutomaticSize.Y
    NODE[110].BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
    NODE[110].CanvasPosition = Vector2.new(0.0, 0.0)
    NODE[110].CanvasSize = UDim2.new(0.0, 0, 0.0, 0)
    NODE[110].ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    NODE[110].HorizontalScrollBarInset = 0
    NODE[110].MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    NODE[110].ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    NODE[110].ScrollBarImageTransparency = 1
    NODE[110].ScrollBarThickness = 0
    NODE[110].ScrollingDirection = Enum.ScrollingDirection.Y
    NODE[110].ScrollingEnabled = true
    NODE[110].TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
    NODE[110].VerticalScrollBarInset = 0
    NODE[110].VerticalScrollBarPosition = 0
    NODE[110].Active = true
    NODE[110].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[110].AutomaticSize = Enum.AutomaticSize.None
    NODE[110].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[110].BackgroundTransparency = 1
    NODE[110].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[110].BorderMode = Enum.BorderMode.Outline
    NODE[110].BorderSizePixel = 0
    NODE[110].ClipsDescendants = false
    NODE[110].Interactable = true
    NODE[110].LayoutOrder = 0
    NODE[110].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[110].Rotation = 0
    NODE[110].Selectable = true
    NODE[110].Size = UDim2.new(1.0, 0, 1.0, -70)
    NODE[110].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[110].Visible = true
    NODE[110].ZIndex = 1
    NODE[111] = Instance.new("UIListLayout")
    NODE[111].Name = "list"
    NODE[111].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[111].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[111].Padding = UDim.new(0.0, 10)
    NODE[111].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[111].Wraps = false
    NODE[111].FillDirection = Enum.FillDirection.Vertical
    NODE[111].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[111].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[111].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[112] = Instance.new("ImageButton")
    NODE[112].Name = "template"
    NODE[112].HoverImage = ""
    NODE[112].Image = ""
    NODE[112].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[112].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[112].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[112].ImageTransparency = 0
    NODE[112].PressedImage = ""
    NODE[112].ResampleMode = Enum.ResamplerMode.Default
    NODE[112].ScaleType = Enum.ScaleType.Fit
    NODE[112].SliceCenter = Rect.new(512, 512, 512, 512)
    NODE[112].SliceScale = 0.0399999991
    NODE[112].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[112].AutoButtonColor = true
    NODE[112].Modal = false
    NODE[112].Selected = false
    NODE[112].Active = true
    NODE[112].AnchorPoint = Vector2.new(0.5, 1.0)
    NODE[112].AutomaticSize = Enum.AutomaticSize.None
    NODE[112].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[112].BackgroundTransparency = 0
    NODE[112].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[112].BorderMode = Enum.BorderMode.Outline
    NODE[112].BorderSizePixel = 0
    NODE[112].ClipsDescendants = true
    NODE[112].Interactable = true
    NODE[112].LayoutOrder = 0
    NODE[112].Position = UDim2.new(0.5, 0, 1.0, 0)
    NODE[112].Rotation = 0
    NODE[112].Selectable = true
    NODE[112].Size = UDim2.new(1.0, 0, 0.0, 44)
    NODE[112].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[112].Visible = true
    NODE[112].ZIndex = 1
    NODE[113] = Instance.new("Folder")
    NODE[113].Name = "util"
    NODE[114] = Instance.new("CanvasGroup")
    NODE[114].Name = "Glow"
    NODE[114].GroupColor3 = Color3.fromRGB(255, 255, 255)
    NODE[114].GroupTransparency = 0
    NODE[114].Active = false
    NODE[114].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[114].AutomaticSize = Enum.AutomaticSize.None
    NODE[114].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[114].BackgroundTransparency = 1
    NODE[114].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[114].BorderMode = Enum.BorderMode.Outline
    NODE[114].BorderSizePixel = 0
    NODE[114].ClipsDescendants = true
    NODE[114].Interactable = true
    NODE[114].LayoutOrder = 0
    NODE[114].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[114].Rotation = 0
    NODE[114].Selectable = false
    NODE[114].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[114].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[114].Visible = true
    NODE[114].ZIndex = -9999
    NODE[115] = Instance.new("Frame")
    NODE[115].Name = "Texture"
    NODE[115].Active = false
    NODE[115].AnchorPoint = Vector2.new(1.0, 0.0)
    NODE[115].AutomaticSize = Enum.AutomaticSize.None
    NODE[115].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[115].BackgroundTransparency = 1
    NODE[115].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[115].BorderMode = Enum.BorderMode.Outline
    NODE[115].BorderSizePixel = 0
    NODE[115].ClipsDescendants = false
    NODE[115].Interactable = true
    NODE[115].LayoutOrder = 0
    NODE[115].Position = UDim2.new(1.0, 0, 0.0, 0)
    NODE[115].Rotation = 0
    NODE[115].Selectable = false
    NODE[115].Size = UDim2.new(0.0, 50, 0.0, 50)
    NODE[115].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[115].Visible = true
    NODE[115].ZIndex = 1
    NODE[116] = Instance.new("ImageLabel")
    NODE[116].Name = "Glow"
    NODE[116].Image = "rbxassetid://122971705612181"
    NODE[116].ImageColor3 = Color3.fromRGB(19, 255, 35)
    NODE[116].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[116].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[116].ImageTransparency = 0
    NODE[116].ResampleMode = Enum.ResamplerMode.Default
    NODE[116].ScaleType = Enum.ScaleType.Stretch
    NODE[116].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[116].SliceScale = 1
    NODE[116].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[116].Active = false
    NODE[116].AnchorPoint = Vector2.new(1.0, 0.5)
    NODE[116].AutomaticSize = Enum.AutomaticSize.None
    NODE[116].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[116].BackgroundTransparency = 1
    NODE[116].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[116].BorderMode = Enum.BorderMode.Outline
    NODE[116].BorderSizePixel = 0
    NODE[116].ClipsDescendants = false
    NODE[116].Interactable = true
    NODE[116].LayoutOrder = 0
    NODE[116].Position = UDim2.new(6.0, 0, 0.439999998, 0)
    NODE[116].Rotation = 0
    NODE[116].Selectable = false
    NODE[116].Size = UDim2.new(0.0, 224, 0.0, 150)
    NODE[116].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[116].Visible = true
    NODE[116].ZIndex = 1
    NODE[117] = Instance.new("UIScale")
    NODE[117].Name = "scale"
    NODE[117].Scale = 1
    NODE[117].Parent = NODE[116]
    NODE[116].Parent = NODE[115]
    NODE[115].Parent = NODE[114]
    NODE[118] = Instance.new("UICorner")
    NODE[118].Name = "corner"
    NODE[118].CornerRadius = UDim.new(0.0, 20)
    NODE[118].CornerRadius = UDim.new(0.0, 20)
    NODE[118].CornerRadius = UDim.new(0.0, 20)
    NODE[118].CornerRadius = UDim.new(0.0, 20)
    NODE[118].Parent = NODE[114]
    NODE[114].Parent = NODE[113]
    NODE[113].Parent = NODE[112]
    NODE[119] = Instance.new("UICorner")
    NODE[119].Name = "corner"
    NODE[119].CornerRadius = UDim.new(0.0, 20)
    NODE[119].CornerRadius = UDim.new(0.0, 20)
    NODE[119].CornerRadius = UDim.new(0.0, 20)
    NODE[119].CornerRadius = UDim.new(0.0, 20)
    NODE[119].Parent = NODE[112]
    NODE[120] = Instance.new("Frame")
    NODE[120].Name = "content"
    NODE[120].Active = false
    NODE[120].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[120].AutomaticSize = Enum.AutomaticSize.None
    NODE[120].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[120].BackgroundTransparency = 1
    NODE[120].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[120].BorderMode = Enum.BorderMode.Outline
    NODE[120].BorderSizePixel = 0
    NODE[120].ClipsDescendants = false
    NODE[120].Interactable = true
    NODE[120].LayoutOrder = 0
    NODE[120].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[120].Rotation = 0
    NODE[120].Selectable = false
    NODE[120].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[120].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[120].Visible = true
    NODE[120].ZIndex = 1
    NODE[121] = Instance.new("ImageLabel")
    NODE[121].Name = "emblem"
    NODE[121].Image = "rbxasset://studio_svg_textures/Shared/Placeholder/Dark/Standard/Placeholder.png"
    NODE[121].ImageColor3 = Color3.fromRGB(34, 34, 34)
    NODE[121].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[121].ImageRectSize = Vector2.new(16.0, 16.0)
    NODE[121].ImageTransparency = 1
    NODE[121].ResampleMode = Enum.ResamplerMode.Default
    NODE[121].ScaleType = Enum.ScaleType.Fit
    NODE[121].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[121].SliceScale = 1
    NODE[121].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[121].Active = false
    NODE[121].AnchorPoint = Vector2.new(0.0, 0.5)
    NODE[121].AutomaticSize = Enum.AutomaticSize.None
    NODE[121].BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    NODE[121].BackgroundTransparency = 1
    NODE[121].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[121].BorderMode = Enum.BorderMode.Outline
    NODE[121].BorderSizePixel = 0
    NODE[121].ClipsDescendants = false
    NODE[121].Interactable = true
    NODE[121].LayoutOrder = 1
    NODE[121].Position = UDim2.new(0.0, 0, 0.5, 0)
    NODE[121].Rotation = 0
    NODE[121].Selectable = false
    NODE[121].Size = UDim2.new(0.0, 26, 0.0, 26)
    NODE[121].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[121].Visible = true
    NODE[121].ZIndex = 1
    NODE[122] = Instance.new("UICorner")
    NODE[122].Name = "corner"
    NODE[122].CornerRadius = UDim.new(0.0, 8)
    NODE[122].CornerRadius = UDim.new(0.0, 8)
    NODE[122].CornerRadius = UDim.new(0.0, 8)
    NODE[122].CornerRadius = UDim.new(0.0, 8)
    NODE[122].Parent = NODE[121]
    NODE[123] = Instance.new("ImageLabel")
    NODE[123].Name = "icon"
    NODE[123].Image = "rbxasset://studio_svg_textures/Shared/Placeholder/Dark/Standard/Placeholder.png"
    NODE[123].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[123].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[123].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[123].ImageTransparency = 0
    NODE[123].ResampleMode = Enum.ResamplerMode.Default
    NODE[123].ScaleType = Enum.ScaleType.Fit
    NODE[123].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[123].SliceScale = 1
    NODE[123].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[123].Active = false
    NODE[123].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[123].AutomaticSize = Enum.AutomaticSize.None
    NODE[123].BackgroundColor3 = Color3.fromRGB(34, 34, 34)
    NODE[123].BackgroundTransparency = 1
    NODE[123].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[123].BorderMode = Enum.BorderMode.Outline
    NODE[123].BorderSizePixel = 0
    NODE[123].ClipsDescendants = false
    NODE[123].Interactable = true
    NODE[123].LayoutOrder = 1
    NODE[123].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[123].Rotation = 0
    NODE[123].Selectable = false
    NODE[123].Size = UDim2.new(0.0, 20, 0.0, 20)
    NODE[123].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[123].Visible = true
    NODE[123].ZIndex = 1
    NODE[123].Parent = NODE[121]
    NODE[121].Parent = NODE[120]
    NODE[124] = Instance.new("TextLabel")
    NODE[124].Name = "value"
    NODE[124].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
    NODE[124].LineHeight = 1
    NODE[124].MaxVisibleGraphemes = -1
    NODE[124].OpenTypeFeatures = ""
    NODE[124].RichText = false
    NODE[124].Text = "Hello Sir!"
    NODE[124].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[124].TextDirection = Enum.TextDirection.LeftToRight
    NODE[124].TextScaled = false
    NODE[124].TextSize = 13
    NODE[124].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[124].TextStrokeTransparency = 1
    NODE[124].TextTransparency = 0
    NODE[124].TextTruncate = Enum.TextTruncate.None
    NODE[124].TextWrapped = true
    NODE[124].TextXAlignment = Enum.TextXAlignment.Left
    NODE[124].TextYAlignment = Enum.TextYAlignment.Top
    NODE[124].Active = false
    NODE[124].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[124].AutomaticSize = Enum.AutomaticSize.Y
    NODE[124].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    NODE[124].BackgroundTransparency = 1
    NODE[124].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[124].BorderMode = Enum.BorderMode.Outline
    NODE[124].BorderSizePixel = 0
    NODE[124].ClipsDescendants = false
    NODE[124].Interactable = true
    NODE[124].LayoutOrder = 2
    NODE[124].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[124].Rotation = 0
    NODE[124].Selectable = false
    NODE[124].Size = UDim2.new(0.0, 20, 0.0, 0)
    NODE[124].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[124].Visible = true
    NODE[124].ZIndex = 1
    NODE[125] = Instance.new("UIFlexItem")
    NODE[125].Name = "flex"
    NODE[125].FlexMode = Enum.UIFlexMode.Fill
    NODE[125].GrowRatio = 0
    NODE[125].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[125].ShrinkRatio = 0
    NODE[125].Parent = NODE[124]
    NODE[124].Parent = NODE[120]
    NODE[126] = Instance.new("UIListLayout")
    NODE[126].Name = "list"
    NODE[126].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[126].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[126].Padding = UDim.new(0.0, 8)
    NODE[126].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[126].Wraps = false
    NODE[126].FillDirection = Enum.FillDirection.Horizontal
    NODE[126].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[126].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[126].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[126].Parent = NODE[120]
    NODE[127] = Instance.new("UIPadding")
    NODE[127].Name = "padding"
    NODE[127].PaddingBottom = UDim.new(0.0, 8)
    NODE[127].PaddingLeft = UDim.new(0.0, 12)
    NODE[127].PaddingRight = UDim.new(0.0, 50)
    NODE[127].PaddingTop = UDim.new(0.0, 8)
    NODE[127].Parent = NODE[120]
    NODE[120].Parent = NODE[112]
    NODE[112].Parent = NODE[111]
    NODE[111].Parent = NODE[110]
    NODE[128] = Instance.new("UIPadding")
    NODE[128].Name = "padding"
    NODE[128].PaddingBottom = UDim.new(0.0, 10)
    NODE[128].PaddingLeft = UDim.new(0.0, 10)
    NODE[128].PaddingRight = UDim.new(0.0, 10)
    NODE[128].PaddingTop = UDim.new(0.0, 50)
    NODE[128].Parent = NODE[110]
    NODE[110].Parent = NODE[107]
    NODE[129] = Instance.new("Frame")
    NODE[129].Name = "bottom"
    NODE[129].Active = false
    NODE[129].AnchorPoint = Vector2.new(0.5, 1.0)
    NODE[129].AutomaticSize = Enum.AutomaticSize.None
    NODE[129].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[129].BackgroundTransparency = 0
    NODE[129].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[129].BorderMode = Enum.BorderMode.Outline
    NODE[129].BorderSizePixel = 0
    NODE[129].ClipsDescendants = false
    NODE[129].Interactable = true
    NODE[129].LayoutOrder = 0
    NODE[129].Position = UDim2.new(0.5, 0, 1.0, 0)
    NODE[129].Rotation = 0
    NODE[129].Selectable = true
    NODE[129].Size = UDim2.new(1.0, 0, 0.0, 90)
    NODE[129].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[129].Visible = true
    NODE[129].ZIndex = 2
    NODE[130] = Instance.new("UIListLayout")
    NODE[130].Name = "list"
    NODE[130].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[130].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[130].Padding = UDim.new(0.0, -20)
    NODE[130].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[130].Wraps = false
    NODE[130].FillDirection = Enum.FillDirection.Horizontal
    NODE[130].HorizontalAlignment = Enum.HorizontalAlignment.Right
    NODE[130].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[130].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[130].Parent = NODE[129]
    NODE[131] = Instance.new("UIPadding")
    NODE[131].Name = "padding"
    NODE[131].PaddingBottom = UDim.new(0.0, 0)
    NODE[131].PaddingLeft = UDim.new(0.0, 0)
    NODE[131].PaddingRight = UDim.new(0.0, 0)
    NODE[131].PaddingTop = UDim.new(0.0, 0)
    NODE[131].Parent = NODE[129]
    NODE[132] = Instance.new("UIGradient")
    NODE[132].Name = "gradient"
    NODE[132].Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)) })
    NODE[132].Enabled = true
    NODE[132].Offset = Vector2.new(0.0, 0.0)
    NODE[132].Rotation = -90
    NODE[132].Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0.0, 0.0), NumberSequenceKeypoint.new(1.0, 1.0) })
    NODE[132].Parent = NODE[129]
    NODE[133] = Instance.new("ImageLabel")
    NODE[133].Name = "Search"
    NODE[133].Image = "rbxassetid://72548733587158"
    NODE[133].ImageColor3 = Color3.fromRGB(0, 0, 0)
    NODE[133].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[133].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[133].ImageTransparency = 0.5
    NODE[133].ResampleMode = Enum.ResamplerMode.Default
    NODE[133].ScaleType = Enum.ScaleType.Slice
    NODE[133].SliceCenter = Rect.new(300, 300, 300, 300)
    NODE[133].SliceScale = 1
    NODE[133].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[133].Active = false
    NODE[133].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[133].AutomaticSize = Enum.AutomaticSize.None
    NODE[133].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[133].BackgroundTransparency = 1
    NODE[133].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[133].BorderMode = Enum.BorderMode.Outline
    NODE[133].BorderSizePixel = 0
    NODE[133].ClipsDescendants = false
    NODE[133].Interactable = true
    NODE[133].LayoutOrder = 1
    NODE[133].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[133].Rotation = 0
    NODE[133].Selectable = false
    NODE[133].Size = UDim2.new(0.0, 0, 0.0, 70)
    NODE[133].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[133].Visible = true
    NODE[133].ZIndex = 1
    NODE[134] = Instance.new("ImageButton")
    NODE[134].Name = "Field"
    NODE[134].HoverImage = ""
    NODE[134].Image = ""
    NODE[134].ImageColor3 = Color3.fromRGB(27, 27, 27)
    NODE[134].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[134].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[134].ImageTransparency = 0
    NODE[134].PressedImage = ""
    NODE[134].ResampleMode = Enum.ResamplerMode.Default
    NODE[134].ScaleType = Enum.ScaleType.Slice
    NODE[134].SliceCenter = Rect.new(512, 512, 512, 512)
    NODE[134].SliceScale = 1
    NODE[134].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[134].AutoButtonColor = false
    NODE[134].Modal = false
    NODE[134].Selected = false
    NODE[134].Active = true
    NODE[134].AnchorPoint = Vector2.new(0.0, 0.5)
    NODE[134].AutomaticSize = Enum.AutomaticSize.None
    NODE[134].BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    NODE[134].BackgroundTransparency = 0
    NODE[134].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[134].BorderMode = Enum.BorderMode.Outline
    NODE[134].BorderSizePixel = 0
    NODE[134].ClipsDescendants = true
    NODE[134].Interactable = true
    NODE[134].LayoutOrder = 1
    NODE[134].Position = UDim2.new(0.0, 0, 0.5, 0)
    NODE[134].Rotation = 0
    NODE[134].Selectable = true
    NODE[134].Size = UDim2.new(1.0, 0, 0.0, 34)
    NODE[134].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[134].Visible = true
    NODE[134].ZIndex = 1
    NODE[135] = Instance.new("TextBox")
    NODE[135].Name = "textbox"
    NODE[135].ClearTextOnFocus = true
    NODE[135].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[135].LineHeight = 1
    NODE[135].MaxVisibleGraphemes = -1
    NODE[135].MultiLine = false
    NODE[135].OpenTypeFeatures = ""
    NODE[135].PlaceholderColor3 = Color3.fromRGB(56, 56, 56)
    NODE[135].PlaceholderText = "Search..."
    NODE[135].RichText = false
    NODE[135].ShowNativeInput = true
    NODE[135].Text = ""
    NODE[135].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[135].TextDirection = Enum.TextDirection.LeftToRight
    NODE[135].TextEditable = true
    NODE[135].TextScaled = false
    NODE[135].TextSize = 15
    NODE[135].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[135].TextStrokeTransparency = 1
    NODE[135].TextTransparency = 0
    NODE[135].TextTruncate = Enum.TextTruncate.None
    NODE[135].TextWrapped = false
    NODE[135].TextXAlignment = Enum.TextXAlignment.Left
    NODE[135].TextYAlignment = Enum.TextYAlignment.Center
    NODE[135].Active = true
    NODE[135].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[135].AutomaticSize = Enum.AutomaticSize.X
    NODE[135].BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    NODE[135].BackgroundTransparency = 1
    NODE[135].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[135].BorderMode = Enum.BorderMode.Outline
    NODE[135].BorderSizePixel = 0
    NODE[135].ClipsDescendants = false
    NODE[135].Interactable = true
    NODE[135].LayoutOrder = 1
    NODE[135].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[135].Rotation = 0
    NODE[135].Selectable = true
    NODE[135].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[135].SizeConstraint = Enum.SizeConstraint.RelativeYY
    NODE[135].Visible = true
    NODE[135].ZIndex = 1
    NODE[136] = Instance.new("UIFlexItem")
    NODE[136].Name = "flex"
    NODE[136].FlexMode = Enum.UIFlexMode.Fill
    NODE[136].GrowRatio = 0
    NODE[136].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[136].ShrinkRatio = 0
    NODE[136].Parent = NODE[135]
    NODE[135].Parent = NODE[134]
    NODE[137] = Instance.new("UIListLayout")
    NODE[137].Name = "list"
    NODE[137].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[137].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[137].Padding = UDim.new(0.0, 10)
    NODE[137].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[137].Wraps = false
    NODE[137].FillDirection = Enum.FillDirection.Horizontal
    NODE[137].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[137].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[137].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[137].Parent = NODE[134]
    NODE[138] = Instance.new("UIScale")
    NODE[138].Name = "scale"
    NODE[138].Scale = 1
    NODE[138].Parent = NODE[134]
    NODE[139] = Instance.new("UIPadding")
    NODE[139].Name = "padding"
    NODE[139].PaddingBottom = UDim.new(0.0, 0)
    NODE[139].PaddingLeft = UDim.new(0.0, 20)
    NODE[139].PaddingRight = UDim.new(0.0, 20)
    NODE[139].PaddingTop = UDim.new(0.0, 0)
    NODE[139].Parent = NODE[134]
    NODE[140] = Instance.new("UICorner")
    NODE[140].Name = "corner"
    NODE[140].CornerRadius = UDim.new(1.0, 0)
    NODE[140].CornerRadius = UDim.new(1.0, 0)
    NODE[140].CornerRadius = UDim.new(1.0, 0)
    NODE[140].CornerRadius = UDim.new(1.0, 0)
    NODE[140].Parent = NODE[134]
    NODE[134].Parent = NODE[133]
    NODE[141] = Instance.new("UIFlexItem")
    NODE[141].Name = "flex"
    NODE[141].FlexMode = Enum.UIFlexMode.Fill
    NODE[141].GrowRatio = 0
    NODE[141].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[141].ShrinkRatio = 0
    NODE[141].Parent = NODE[133]
    NODE[142] = Instance.new("UIPadding")
    NODE[142].Name = "padding"
    NODE[142].PaddingBottom = UDim.new(0.0, 0)
    NODE[142].PaddingLeft = UDim.new(0.0, 20)
    NODE[142].PaddingRight = UDim.new(0.0, 20)
    NODE[142].PaddingTop = UDim.new(0.0, 0)
    NODE[142].Parent = NODE[133]
    NODE[133].Parent = NODE[129]
    NODE[143] = Instance.new("ImageLabel")
    NODE[143].Name = "Select"
    NODE[143].Image = "rbxassetid://72548733587158"
    NODE[143].ImageColor3 = Color3.fromRGB(0, 0, 0)
    NODE[143].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[143].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[143].ImageTransparency = 0.5
    NODE[143].ResampleMode = Enum.ResamplerMode.Default
    NODE[143].ScaleType = Enum.ScaleType.Slice
    NODE[143].SliceCenter = Rect.new(300, 300, 300, 300)
    NODE[143].SliceScale = 1
    NODE[143].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[143].Active = false
    NODE[143].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[143].AutomaticSize = Enum.AutomaticSize.X
    NODE[143].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[143].BackgroundTransparency = 1
    NODE[143].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[143].BorderMode = Enum.BorderMode.Outline
    NODE[143].BorderSizePixel = 0
    NODE[143].ClipsDescendants = true
    NODE[143].Interactable = true
    NODE[143].LayoutOrder = 3
    NODE[143].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[143].Rotation = 0
    NODE[143].Selectable = false
    NODE[143].Size = UDim2.new(0.0, 128, 0.0, 70)
    NODE[143].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[143].Visible = true
    NODE[143].ZIndex = 1
    NODE[144] = Instance.new("TextButton")
    NODE[144].Name = "Button"
    NODE[144].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    NODE[144].LineHeight = 1
    NODE[144].MaxVisibleGraphemes = -1
    NODE[144].OpenTypeFeatures = ""
    NODE[144].RichText = false
    NODE[144].Text = "Select"
    NODE[144].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[144].TextDirection = Enum.TextDirection.LeftToRight
    NODE[144].TextScaled = false
    NODE[144].TextSize = 15
    NODE[144].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[144].TextStrokeTransparency = 1
    NODE[144].TextTransparency = 0
    NODE[144].TextTruncate = Enum.TextTruncate.None
    NODE[144].TextWrapped = false
    NODE[144].TextXAlignment = Enum.TextXAlignment.Center
    NODE[144].TextYAlignment = Enum.TextYAlignment.Center
    NODE[144].AutoButtonColor = true
    NODE[144].Modal = false
    NODE[144].Selected = false
    NODE[144].Active = true
    NODE[144].AnchorPoint = Vector2.new(0.0, 0.5)
    NODE[144].AutomaticSize = Enum.AutomaticSize.X
    NODE[144].BackgroundColor3 = Color3.fromRGB(0, 140, 255)
    NODE[144].BackgroundTransparency = 0
    NODE[144].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[144].BorderMode = Enum.BorderMode.Outline
    NODE[144].BorderSizePixel = 0
    NODE[144].ClipsDescendants = false
    NODE[144].Interactable = true
    NODE[144].LayoutOrder = 0
    NODE[144].Position = UDim2.new(0.0, 0, 0.5, 0)
    NODE[144].Rotation = 0
    NODE[144].Selectable = true
    NODE[144].Size = UDim2.new(1.0, 0, 0.0, 34)
    NODE[144].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[144].Visible = true
    NODE[144].ZIndex = 1
    NODE[145] = Instance.new("UIListLayout")
    NODE[145].Name = "list"
    NODE[145].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[145].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[145].Padding = UDim.new(0.0, 10)
    NODE[145].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[145].Wraps = false
    NODE[145].FillDirection = Enum.FillDirection.Horizontal
    NODE[145].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[145].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[145].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[145].Parent = NODE[144]
    NODE[146] = Instance.new("UIPadding")
    NODE[146].Name = "padding"
    NODE[146].PaddingBottom = UDim.new(0.0, 0)
    NODE[146].PaddingLeft = UDim.new(0.0, 24)
    NODE[146].PaddingRight = UDim.new(0.0, 24)
    NODE[146].PaddingTop = UDim.new(0.0, 0)
    NODE[146].Parent = NODE[144]
    NODE[147] = Instance.new("UICorner")
    NODE[147].Name = "corner"
    NODE[147].CornerRadius = UDim.new(1.0, 0)
    NODE[147].CornerRadius = UDim.new(1.0, 0)
    NODE[147].CornerRadius = UDim.new(1.0, 0)
    NODE[147].CornerRadius = UDim.new(1.0, 0)
    NODE[147].Parent = NODE[144]
    NODE[148] = Instance.new("UIScale")
    NODE[148].Name = "scale"
    NODE[148].Scale = 1
    NODE[148].Parent = NODE[144]
    NODE[144].Parent = NODE[143]
    NODE[149] = Instance.new("UIPadding")
    NODE[149].Name = "padding"
    NODE[149].PaddingBottom = UDim.new(0.0, 0)
    NODE[149].PaddingLeft = UDim.new(0.0, 20)
    NODE[149].PaddingRight = UDim.new(0.0, 20)
    NODE[149].PaddingTop = UDim.new(0.0, 0)
    NODE[149].Parent = NODE[143]
    NODE[143].Parent = NODE[129]
    NODE[129].Parent = NODE[107]
    NODE[107].Parent = NODE[106]
    NODE[150] = Instance.new("TextLabel")
    NODE[150].Name = "loading"
    NODE[150].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[150].LineHeight = 1
    NODE[150].MaxVisibleGraphemes = -1
    NODE[150].OpenTypeFeatures = ""
    NODE[150].RichText = false
    NODE[150].Text = "Loading..."
    NODE[150].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[150].TextDirection = Enum.TextDirection.LeftToRight
    NODE[150].TextScaled = false
    NODE[150].TextSize = 15
    NODE[150].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[150].TextStrokeTransparency = 1
    NODE[150].TextTransparency = 0.800000012
    NODE[150].TextTruncate = Enum.TextTruncate.None
    NODE[150].TextWrapped = false
    NODE[150].TextXAlignment = Enum.TextXAlignment.Center
    NODE[150].TextYAlignment = Enum.TextYAlignment.Center
    NODE[150].Active = false
    NODE[150].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[150].AutomaticSize = Enum.AutomaticSize.None
    NODE[150].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[150].BackgroundTransparency = 1
    NODE[150].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[150].BorderMode = Enum.BorderMode.Outline
    NODE[150].BorderSizePixel = 0
    NODE[150].ClipsDescendants = false
    NODE[150].Interactable = true
    NODE[150].LayoutOrder = 0
    NODE[150].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[150].Rotation = 0
    NODE[150].Selectable = false
    NODE[150].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[150].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[150].Visible = false
    NODE[150].ZIndex = 1
    NODE[150].Parent = NODE[106]
    NODE[151] = Instance.new("Frame")
    NODE[151].Name = "WindowControl"
    NODE[151].Active = false
    NODE[151].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[151].AutomaticSize = Enum.AutomaticSize.None
    NODE[151].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[151].BackgroundTransparency = 1
    NODE[151].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[151].BorderMode = Enum.BorderMode.Outline
    NODE[151].BorderSizePixel = 0
    NODE[151].ClipsDescendants = false
    NODE[151].Interactable = true
    NODE[151].LayoutOrder = 0
    NODE[151].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[151].Rotation = 0
    NODE[151].Selectable = false
    NODE[151].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[151].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[151].Visible = true
    NODE[151].ZIndex = 99999
    NODE[152] = Instance.new("Frame")
    NODE[152].Name = "Top"
    NODE[152].Active = false
    NODE[152].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[152].AutomaticSize = Enum.AutomaticSize.None
    NODE[152].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[152].BackgroundTransparency = 1
    NODE[152].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[152].BorderMode = Enum.BorderMode.Outline
    NODE[152].BorderSizePixel = 0
    NODE[152].ClipsDescendants = false
    NODE[152].Interactable = true
    NODE[152].LayoutOrder = 0
    NODE[152].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[152].Rotation = 0
    NODE[152].Selectable = false
    NODE[152].Size = UDim2.new(1.0, 0, 0.0, 50)
    NODE[152].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[152].Visible = true
    NODE[152].ZIndex = 99
    NODE[153] = Instance.new("UIPadding")
    NODE[153].Name = "padding"
    NODE[153].PaddingBottom = UDim.new(0.0, 0)
    NODE[153].PaddingLeft = UDim.new(0.0, 25)
    NODE[153].PaddingRight = UDim.new(0.0, 10)
    NODE[153].PaddingTop = UDim.new(0.0, 22)
    NODE[153].Parent = NODE[152]
    NODE[154] = Instance.new("UIListLayout")
    NODE[154].Name = "list"
    NODE[154].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[154].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[154].Padding = UDim.new(0.0, 10)
    NODE[154].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[154].Wraps = false
    NODE[154].FillDirection = Enum.FillDirection.Horizontal
    NODE[154].HorizontalAlignment = Enum.HorizontalAlignment.Right
    NODE[154].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[154].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[154].Parent = NODE[152]
    NODE[155] = Instance.new("TextLabel")
    NODE[155].Name = "header"
    NODE[155].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    NODE[155].LineHeight = 1
    NODE[155].MaxVisibleGraphemes = -1
    NODE[155].OpenTypeFeatures = ""
    NODE[155].RichText = false
    NODE[155].Text = "Select Shortcut"
    NODE[155].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[155].TextDirection = Enum.TextDirection.LeftToRight
    NODE[155].TextScaled = true
    NODE[155].TextSize = 18
    NODE[155].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[155].TextStrokeTransparency = 1
    NODE[155].TextTransparency = 0
    NODE[155].TextTruncate = Enum.TextTruncate.None
    NODE[155].TextWrapped = true
    NODE[155].TextXAlignment = Enum.TextXAlignment.Left
    NODE[155].TextYAlignment = Enum.TextYAlignment.Top
    NODE[155].Active = false
    NODE[155].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[155].AutomaticSize = Enum.AutomaticSize.X
    NODE[155].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[155].BackgroundTransparency = 1
    NODE[155].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[155].BorderMode = Enum.BorderMode.Outline
    NODE[155].BorderSizePixel = 0
    NODE[155].ClipsDescendants = false
    NODE[155].Interactable = true
    NODE[155].LayoutOrder = 0
    NODE[155].Position = UDim2.new(0.0, 0, 0.0, -6)
    NODE[155].Rotation = 0
    NODE[155].Selectable = false
    NODE[155].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[155].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[155].Visible = true
    NODE[155].ZIndex = 900
    NODE[156] = Instance.new("UITextSizeConstraint")
    NODE[156].Name = "UITextSizeConstraint"
    NODE[156].MaxTextSize = 17
    NODE[156].MinTextSize = 1
    NODE[156].Parent = NODE[155]
    NODE[155].Parent = NODE[152]
    NODE[157] = Instance.new("Frame")
    NODE[157].Name = "Close"
    NODE[157].Active = false
    NODE[157].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[157].AutomaticSize = Enum.AutomaticSize.None
    NODE[157].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[157].BackgroundTransparency = 1
    NODE[157].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[157].BorderMode = Enum.BorderMode.Outline
    NODE[157].BorderSizePixel = 0
    NODE[157].ClipsDescendants = false
    NODE[157].Interactable = true
    NODE[157].LayoutOrder = 4
    NODE[157].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[157].Rotation = 0
    NODE[157].Selectable = false
    NODE[157].Size = UDim2.new(1.20000005, 0, 1.20000005, 0)
    NODE[157].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[157].Visible = true
    NODE[157].ZIndex = 1
    NODE[158] = Instance.new("UIAspectRatioConstraint")
    NODE[158].Name = "UIAspectRatioConstraint"
    NODE[158].AspectRatio = 1
    NODE[158].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[158].DominantAxis = Enum.DominantAxis.Width
    NODE[158].Parent = NODE[157]
    NODE[159] = Instance.new("TextButton")
    NODE[159].Name = "ButtonHitbox"
    NODE[159].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
    NODE[159].LineHeight = 1
    NODE[159].MaxVisibleGraphemes = -1
    NODE[159].OpenTypeFeatures = ""
    NODE[159].RichText = false
    NODE[159].Text = ""
    NODE[159].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[159].TextDirection = Enum.TextDirection.LeftToRight
    NODE[159].TextScaled = true
    NODE[159].TextSize = 14
    NODE[159].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[159].TextStrokeTransparency = 0.5
    NODE[159].TextTransparency = 0.5
    NODE[159].TextTruncate = Enum.TextTruncate.None
    NODE[159].TextWrapped = true
    NODE[159].TextXAlignment = Enum.TextXAlignment.Center
    NODE[159].TextYAlignment = Enum.TextYAlignment.Center
    NODE[159].AutoButtonColor = true
    NODE[159].Modal = false
    NODE[159].Selected = false
    NODE[159].Active = true
    NODE[159].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[159].AutomaticSize = Enum.AutomaticSize.None
    NODE[159].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[159].BackgroundTransparency = 0
    NODE[159].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[159].BorderMode = Enum.BorderMode.Outline
    NODE[159].BorderSizePixel = 0
    NODE[159].ClipsDescendants = false
    NODE[159].Interactable = true
    NODE[159].LayoutOrder = 0
    NODE[159].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[159].Rotation = 0
    NODE[159].Selectable = true
    NODE[159].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[159].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[159].Visible = true
    NODE[159].ZIndex = 1
    NODE[160] = Instance.new("ImageLabel")
    NODE[160].Name = "icon"
    NODE[160].Image = "rbxassetid://11293981586"
    NODE[160].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[160].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[160].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[160].ImageTransparency = 0
    NODE[160].ResampleMode = Enum.ResamplerMode.Default
    NODE[160].ScaleType = Enum.ScaleType.Stretch
    NODE[160].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[160].SliceScale = 1
    NODE[160].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[160].Active = false
    NODE[160].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[160].AutomaticSize = Enum.AutomaticSize.None
    NODE[160].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[160].BackgroundTransparency = 1
    NODE[160].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[160].BorderMode = Enum.BorderMode.Outline
    NODE[160].BorderSizePixel = 0
    NODE[160].ClipsDescendants = false
    NODE[160].Interactable = true
    NODE[160].LayoutOrder = 0
    NODE[160].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[160].Rotation = 0
    NODE[160].Selectable = false
    NODE[160].Size = UDim2.new(0.850000024, 0, 0.850000024, 0)
    NODE[160].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[160].Visible = true
    NODE[160].ZIndex = 1
    NODE[160].Parent = NODE[159]
    NODE[161] = Instance.new("UICorner")
    NODE[161].Name = "UICorner"
    NODE[161].CornerRadius = UDim.new(0.0, 100)
    NODE[161].CornerRadius = UDim.new(0.0, 100)
    NODE[161].CornerRadius = UDim.new(0.0, 100)
    NODE[161].CornerRadius = UDim.new(0.0, 100)
    NODE[161].Parent = NODE[159]
    NODE[162] = Instance.new("UIPadding")
    NODE[162].Name = "UIPadding"
    NODE[162].PaddingBottom = UDim.new(0.0, 7)
    NODE[162].PaddingLeft = UDim.new(0.0, 7)
    NODE[162].PaddingRight = UDim.new(0.0, 7)
    NODE[162].PaddingTop = UDim.new(0.0, 7)
    NODE[162].Parent = NODE[159]
    NODE[159].Parent = NODE[157]
    NODE[163] = Instance.new("UIPadding")
    NODE[163].Name = "UIPadding"
    NODE[163].PaddingBottom = UDim.new(0.0, 9)
    NODE[163].PaddingLeft = UDim.new(0.0, -5)
    NODE[163].PaddingRight = UDim.new(0.0, 5)
    NODE[163].PaddingTop = UDim.new(0.0, -9)
    NODE[163].Parent = NODE[157]
    NODE[157].Parent = NODE[152]
    NODE[164] = Instance.new("Frame")
    NODE[164].Name = "space"
    NODE[164].Active = false
    NODE[164].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[164].AutomaticSize = Enum.AutomaticSize.None
    NODE[164].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[164].BackgroundTransparency = 1
    NODE[164].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[164].BorderMode = Enum.BorderMode.Outline
    NODE[164].BorderSizePixel = 0
    NODE[164].ClipsDescendants = false
    NODE[164].Interactable = true
    NODE[164].LayoutOrder = 1
    NODE[164].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[164].Rotation = 0
    NODE[164].Selectable = false
    NODE[164].Size = UDim2.new(0.0, 0, 0.0, 0)
    NODE[164].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[164].Visible = true
    NODE[164].ZIndex = 1
    NODE[165] = Instance.new("UIFlexItem")
    NODE[165].Name = "UIFlexItem"
    NODE[165].FlexMode = Enum.UIFlexMode.Fill
    NODE[165].GrowRatio = 0
    NODE[165].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[165].ShrinkRatio = 0
    NODE[165].Parent = NODE[164]
    NODE[164].Parent = NODE[152]
    NODE[166] = Instance.new("Frame")
    NODE[166].Name = "Category"
    NODE[166].Active = false
    NODE[166].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[166].AutomaticSize = Enum.AutomaticSize.None
    NODE[166].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[166].BackgroundTransparency = 1
    NODE[166].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[166].BorderMode = Enum.BorderMode.Outline
    NODE[166].BorderSizePixel = 0
    NODE[166].ClipsDescendants = false
    NODE[166].Interactable = true
    NODE[166].LayoutOrder = 2
    NODE[166].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[166].Rotation = 0
    NODE[166].Selectable = false
    NODE[166].Size = UDim2.new(1.20000005, 0, 1.20000005, 0)
    NODE[166].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[166].Visible = true
    NODE[166].ZIndex = 1
    NODE[167] = Instance.new("UIAspectRatioConstraint")
    NODE[167].Name = "UIAspectRatioConstraint"
    NODE[167].AspectRatio = 1
    NODE[167].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[167].DominantAxis = Enum.DominantAxis.Width
    NODE[167].Parent = NODE[166]
    NODE[168] = Instance.new("TextButton")
    NODE[168].Name = "ButtonHitbox"
    NODE[168].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
    NODE[168].LineHeight = 1
    NODE[168].MaxVisibleGraphemes = -1
    NODE[168].OpenTypeFeatures = ""
    NODE[168].RichText = false
    NODE[168].Text = ""
    NODE[168].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[168].TextDirection = Enum.TextDirection.LeftToRight
    NODE[168].TextScaled = true
    NODE[168].TextSize = 14
    NODE[168].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[168].TextStrokeTransparency = 0.5
    NODE[168].TextTransparency = 0.5
    NODE[168].TextTruncate = Enum.TextTruncate.None
    NODE[168].TextWrapped = true
    NODE[168].TextXAlignment = Enum.TextXAlignment.Center
    NODE[168].TextYAlignment = Enum.TextYAlignment.Center
    NODE[168].AutoButtonColor = true
    NODE[168].Modal = false
    NODE[168].Selected = false
    NODE[168].Active = true
    NODE[168].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[168].AutomaticSize = Enum.AutomaticSize.None
    NODE[168].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[168].BackgroundTransparency = 0
    NODE[168].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[168].BorderMode = Enum.BorderMode.Outline
    NODE[168].BorderSizePixel = 0
    NODE[168].ClipsDescendants = false
    NODE[168].Interactable = true
    NODE[168].LayoutOrder = 0
    NODE[168].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[168].Rotation = 0
    NODE[168].Selectable = true
    NODE[168].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[168].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[168].Visible = true
    NODE[168].ZIndex = 1
    NODE[169] = Instance.new("ImageLabel")
    NODE[169].Name = "icon"
    NODE[169].Image = "rbxassetid://14187789126"
    NODE[169].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[169].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[169].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[169].ImageTransparency = 0
    NODE[169].ResampleMode = Enum.ResamplerMode.Default
    NODE[169].ScaleType = Enum.ScaleType.Stretch
    NODE[169].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[169].SliceScale = 1
    NODE[169].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[169].Active = false
    NODE[169].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[169].AutomaticSize = Enum.AutomaticSize.None
    NODE[169].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[169].BackgroundTransparency = 1
    NODE[169].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[169].BorderMode = Enum.BorderMode.Outline
    NODE[169].BorderSizePixel = 0
    NODE[169].ClipsDescendants = false
    NODE[169].Interactable = true
    NODE[169].LayoutOrder = 0
    NODE[169].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[169].Rotation = 0
    NODE[169].Selectable = false
    NODE[169].Size = UDim2.new(1.20000005, 0, 1.20000005, 0)
    NODE[169].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[169].Visible = true
    NODE[169].ZIndex = 1
    NODE[169].Parent = NODE[168]
    NODE[170] = Instance.new("UICorner")
    NODE[170].Name = "UICorner"
    NODE[170].CornerRadius = UDim.new(0.0, 100)
    NODE[170].CornerRadius = UDim.new(0.0, 100)
    NODE[170].CornerRadius = UDim.new(0.0, 100)
    NODE[170].CornerRadius = UDim.new(0.0, 100)
    NODE[170].Parent = NODE[168]
    NODE[171] = Instance.new("UIPadding")
    NODE[171].Name = "UIPadding"
    NODE[171].PaddingBottom = UDim.new(0.0, 7)
    NODE[171].PaddingLeft = UDim.new(0.0, 7)
    NODE[171].PaddingRight = UDim.new(0.0, 7)
    NODE[171].PaddingTop = UDim.new(0.0, 7)
    NODE[171].Parent = NODE[168]
    NODE[168].Parent = NODE[166]
    NODE[172] = Instance.new("UIPadding")
    NODE[172].Name = "UIPadding"
    NODE[172].PaddingBottom = UDim.new(0.0, 9)
    NODE[172].PaddingLeft = UDim.new(0.0, 5)
    NODE[172].PaddingRight = UDim.new(0.0, -5)
    NODE[172].PaddingTop = UDim.new(0.0, -9)
    NODE[172].Parent = NODE[166]
    NODE[166].Parent = NODE[152]
    NODE[152].Parent = NODE[151]
    NODE[173] = Instance.new("ImageButton")
    NODE[173].Name = "Interaction_Protection"
    NODE[173].HoverImage = ""
    NODE[173].Image = ""
    NODE[173].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[173].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[173].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[173].ImageTransparency = 0
    NODE[173].PressedImage = ""
    NODE[173].ResampleMode = Enum.ResamplerMode.Default
    NODE[173].ScaleType = Enum.ScaleType.Stretch
    NODE[173].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[173].SliceScale = 1
    NODE[173].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[173].AutoButtonColor = true
    NODE[173].Modal = false
    NODE[173].Selected = false
    NODE[173].Active = true
    NODE[173].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[173].AutomaticSize = Enum.AutomaticSize.None
    NODE[173].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[173].BackgroundTransparency = 1
    NODE[173].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[173].BorderMode = Enum.BorderMode.Outline
    NODE[173].BorderSizePixel = 0
    NODE[173].ClipsDescendants = false
    NODE[173].Interactable = true
    NODE[173].LayoutOrder = 0
    NODE[173].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[173].Rotation = 0
    NODE[173].Selectable = true
    NODE[173].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[173].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[173].Visible = true
    NODE[173].ZIndex = 1
    NODE[173].Parent = NODE[151]
    NODE[174] = Instance.new("ImageButton")
    NODE[174].Name = "Enable"
    NODE[174].HoverImage = ""
    NODE[174].Image = ""
    NODE[174].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[174].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[174].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[174].ImageTransparency = 0
    NODE[174].PressedImage = ""
    NODE[174].ResampleMode = Enum.ResamplerMode.Default
    NODE[174].ScaleType = Enum.ScaleType.Stretch
    NODE[174].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[174].SliceScale = 1
    NODE[174].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[174].AutoButtonColor = true
    NODE[174].Modal = false
    NODE[174].Selected = false
    NODE[174].Active = true
    NODE[174].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[174].AutomaticSize = Enum.AutomaticSize.None
    NODE[174].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[174].BackgroundTransparency = 1
    NODE[174].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[174].BorderMode = Enum.BorderMode.Outline
    NODE[174].BorderSizePixel = 0
    NODE[174].ClipsDescendants = false
    NODE[174].Interactable = true
    NODE[174].LayoutOrder = 0
    NODE[174].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[174].Rotation = 0
    NODE[174].Selectable = true
    NODE[174].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[174].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[174].Visible = true
    NODE[174].ZIndex = 1
    NODE[174].Parent = NODE[151]
    NODE[175] = Instance.new("Frame")
    NODE[175].Name = "Bottom"
    NODE[175].Active = false
    NODE[175].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[175].AutomaticSize = Enum.AutomaticSize.None
    NODE[175].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[175].BackgroundTransparency = 1
    NODE[175].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[175].BorderMode = Enum.BorderMode.Outline
    NODE[175].BorderSizePixel = 0
    NODE[175].ClipsDescendants = false
    NODE[175].Interactable = true
    NODE[175].LayoutOrder = 0
    NODE[175].Position = UDim2.new(1.0, -3, 1.0, -3)
    NODE[175].Rotation = 0
    NODE[175].Selectable = false
    NODE[175].Size = UDim2.new(0.0, 50, 0.0, 50)
    NODE[175].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[175].Visible = true
    NODE[175].ZIndex = 99
    NODE[176] = Instance.new("UIListLayout")
    NODE[176].Name = "list"
    NODE[176].HorizontalFlex = Enum.UIFlexAlignment.Fill
    NODE[176].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[176].Padding = UDim.new(0.0, 0)
    NODE[176].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[176].Wraps = false
    NODE[176].FillDirection = Enum.FillDirection.Horizontal
    NODE[176].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[176].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[176].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[176].Parent = NODE[175]
    NODE[177] = Instance.new("ImageButton")
    NODE[177].Name = "Resize"
    NODE[177].HoverImage = ""
    NODE[177].Image = ""
    NODE[177].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[177].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[177].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[177].ImageTransparency = 0
    NODE[177].PressedImage = ""
    NODE[177].ResampleMode = Enum.ResamplerMode.Default
    NODE[177].ScaleType = Enum.ScaleType.Stretch
    NODE[177].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[177].SliceScale = 1
    NODE[177].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[177].AutoButtonColor = false
    NODE[177].Modal = false
    NODE[177].Selected = false
    NODE[177].Active = true
    NODE[177].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[177].AutomaticSize = Enum.AutomaticSize.None
    NODE[177].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[177].BackgroundTransparency = 1
    NODE[177].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[177].BorderMode = Enum.BorderMode.Outline
    NODE[177].BorderSizePixel = 0
    NODE[177].ClipsDescendants = false
    NODE[177].Interactable = true
    NODE[177].LayoutOrder = 0
    NODE[177].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[177].Rotation = 0
    NODE[177].Selectable = true
    NODE[177].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[177].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[177].Visible = true
    NODE[177].ZIndex = 1
    NODE[178] = Instance.new("ImageLabel")
    NODE[178].Name = "icon"
    NODE[178].Image = "rbxassetid://86527207319523"
    NODE[178].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[178].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[178].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[178].ImageTransparency = 0
    NODE[178].ResampleMode = Enum.ResamplerMode.Default
    NODE[178].ScaleType = Enum.ScaleType.Slice
    NODE[178].SliceCenter = Rect.new(51, 52, 51, 52)
    NODE[178].SliceScale = 0.5
    NODE[178].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[178].Active = false
    NODE[178].AnchorPoint = Vector2.new(1.0, 1.0)
    NODE[178].AutomaticSize = Enum.AutomaticSize.None
    NODE[178].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[178].BackgroundTransparency = 1
    NODE[178].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[178].BorderMode = Enum.BorderMode.Outline
    NODE[178].BorderSizePixel = 0
    NODE[178].ClipsDescendants = false
    NODE[178].Interactable = true
    NODE[178].LayoutOrder = 0
    NODE[178].Position = UDim2.new(1.0, 0, 1.0, 0)
    NODE[178].Rotation = 0
    NODE[178].Selectable = false
    NODE[178].Size = UDim2.new(0.0, 18, 0.0, 18)
    NODE[178].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[178].Visible = true
    NODE[178].ZIndex = 1
    NODE[179] = Instance.new("UIScale")
    NODE[179].Name = "scale"
    NODE[179].Scale = 1
    NODE[179].Parent = NODE[178]
    NODE[178].Parent = NODE[177]
    NODE[180] = Instance.new("UIPadding")
    NODE[180].Name = "padding"
    NODE[180].PaddingBottom = UDim.new(0.0, 8)
    NODE[180].PaddingLeft = UDim.new(0.0, 0)
    NODE[180].PaddingRight = UDim.new(0.0, 8)
    NODE[180].PaddingTop = UDim.new(0.0, 0)
    NODE[180].Parent = NODE[177]
    NODE[177].Parent = NODE[175]
    NODE[175].Parent = NODE[151]
    NODE[151].Parent = NODE[106]
    NODE[181] = Instance.new("ImageLabel")
    NODE[181].Name = "fade"
    NODE[181].Image = "rbxassetid://125088425775676"
    NODE[181].ImageColor3 = Color3.fromRGB(18, 18, 18)
    NODE[181].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[181].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[181].ImageTransparency = 1
    NODE[181].ResampleMode = Enum.ResamplerMode.Default
    NODE[181].ScaleType = Enum.ScaleType.Slice
    NODE[181].SliceCenter = Rect.new(512, 512, 512, 512)
    NODE[181].SliceScale = 1
    NODE[181].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[181].Active = false
    NODE[181].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[181].AutomaticSize = Enum.AutomaticSize.None
    NODE[181].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[181].BackgroundTransparency = 0
    NODE[181].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[181].BorderMode = Enum.BorderMode.Outline
    NODE[181].BorderSizePixel = 0
    NODE[181].ClipsDescendants = false
    NODE[181].Interactable = true
    NODE[181].LayoutOrder = 0
    NODE[181].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[181].Rotation = 0
    NODE[181].Selectable = true
    NODE[181].Size = UDim2.new(1.0, 0, 0.0, 70)
    NODE[181].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[181].Visible = true
    NODE[181].ZIndex = 1
    NODE[182] = Instance.new("UIGradient")
    NODE[182].Name = "gradient"
    NODE[182].Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)) })
    NODE[182].Enabled = true
    NODE[182].Offset = Vector2.new(0.0, 0.0)
    NODE[182].Rotation = 90
    NODE[182].Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0.0, 0.0), NumberSequenceKeypoint.new(1.0, 1.0) })
    NODE[182].Parent = NODE[181]
    NODE[183] = Instance.new("UICorner")
    NODE[183].Name = "UICorner"
    NODE[183].CornerRadius = UDim.new(0.0, 33)
    NODE[183].CornerRadius = UDim.new(0.0, 33)
    NODE[183].CornerRadius = UDim.new(0.0, 33)
    NODE[183].CornerRadius = UDim.new(0.0, 33)
    NODE[183].Parent = NODE[181]
    NODE[181].Parent = NODE[106]
    NODE[184] = Instance.new("CanvasGroup")
    NODE[184].Name = "Category"
    NODE[184].GroupColor3 = Color3.fromRGB(255, 255, 255)
    NODE[184].GroupTransparency = 0
    NODE[184].Active = false
    NODE[184].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[184].AutomaticSize = Enum.AutomaticSize.None
    NODE[184].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[184].BackgroundTransparency = 1
    NODE[184].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[184].BorderMode = Enum.BorderMode.Outline
    NODE[184].BorderSizePixel = 0
    NODE[184].ClipsDescendants = true
    NODE[184].Interactable = true
    NODE[184].LayoutOrder = 0
    NODE[184].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[184].Rotation = 0
    NODE[184].Selectable = false
    NODE[184].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[184].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[184].Visible = true
    NODE[184].ZIndex = 999
    NODE[185] = Instance.new("UICorner")
    NODE[185].Name = "corner"
    NODE[185].CornerRadius = UDim.new(0.0, 36)
    NODE[185].CornerRadius = UDim.new(0.0, 36)
    NODE[185].CornerRadius = UDim.new(0.0, 36)
    NODE[185].CornerRadius = UDim.new(0.0, 36)
    NODE[185].Parent = NODE[184]
    NODE[186] = Instance.new("Frame")
    NODE[186].Name = "content"
    NODE[186].Active = false
    NODE[186].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[186].AutomaticSize = Enum.AutomaticSize.None
    NODE[186].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[186].BackgroundTransparency = 1
    NODE[186].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[186].BorderMode = Enum.BorderMode.Outline
    NODE[186].BorderSizePixel = 0
    NODE[186].ClipsDescendants = true
    NODE[186].Interactable = true
    NODE[186].LayoutOrder = 0
    NODE[186].Position = UDim2.new(0.5, 0, 1.0, 0)
    NODE[186].Rotation = 0
    NODE[186].Selectable = false
    NODE[186].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[186].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[186].Visible = true
    NODE[186].ZIndex = 1
    NODE[187] = Instance.new("ImageButton")
    NODE[187].Name = "Category"
    NODE[187].HoverImage = ""
    NODE[187].Image = ""
    NODE[187].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[187].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[187].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[187].ImageTransparency = 0
    NODE[187].PressedImage = ""
    NODE[187].ResampleMode = Enum.ResamplerMode.Default
    NODE[187].ScaleType = Enum.ScaleType.Stretch
    NODE[187].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[187].SliceScale = 1
    NODE[187].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[187].AutoButtonColor = false
    NODE[187].Modal = false
    NODE[187].Selected = false
    NODE[187].Active = false
    NODE[187].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[187].AutomaticSize = Enum.AutomaticSize.None
    NODE[187].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[187].BackgroundTransparency = 0
    NODE[187].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[187].BorderMode = Enum.BorderMode.Outline
    NODE[187].BorderSizePixel = 0
    NODE[187].ClipsDescendants = false
    NODE[187].Interactable = true
    NODE[187].LayoutOrder = 0
    NODE[187].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[187].Rotation = 0
    NODE[187].Selectable = false
    NODE[187].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[187].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[187].Visible = true
    NODE[187].ZIndex = 1
    NODE[188] = Instance.new("UICorner")
    NODE[188].Name = "corner"
    NODE[188].CornerRadius = UDim.new(0.0, 36)
    NODE[188].CornerRadius = UDim.new(0.0, 36)
    NODE[188].CornerRadius = UDim.new(0.0, 36)
    NODE[188].CornerRadius = UDim.new(0.0, 36)
    NODE[188].Parent = NODE[187]
    NODE[189] = Instance.new("ScrollingFrame")
    NODE[189].Name = "container"
    NODE[189].AutomaticCanvasSize = Enum.AutomaticSize.Y
    NODE[189].BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
    NODE[189].CanvasPosition = Vector2.new(0.0, 0.0)
    NODE[189].CanvasSize = UDim2.new(0.0, 0, 0.0, 0)
    NODE[189].ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
    NODE[189].HorizontalScrollBarInset = 0
    NODE[189].MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
    NODE[189].ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
    NODE[189].ScrollBarImageTransparency = 0
    NODE[189].ScrollBarThickness = 0
    NODE[189].ScrollingDirection = Enum.ScrollingDirection.Y
    NODE[189].ScrollingEnabled = true
    NODE[189].TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
    NODE[189].VerticalScrollBarInset = 0
    NODE[189].VerticalScrollBarPosition = 0
    NODE[189].Active = true
    NODE[189].AnchorPoint = Vector2.new(0.5, 1.0)
    NODE[189].AutomaticSize = Enum.AutomaticSize.None
    NODE[189].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[189].BackgroundTransparency = 1
    NODE[189].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[189].BorderMode = Enum.BorderMode.Outline
    NODE[189].BorderSizePixel = 0
    NODE[189].ClipsDescendants = false
    NODE[189].Interactable = true
    NODE[189].LayoutOrder = 0
    NODE[189].Position = UDim2.new(0.5, 0, 1.0, 0)
    NODE[189].Rotation = 0
    NODE[189].Selectable = true
    NODE[189].Size = UDim2.new(1.0, 0, 0.5, 50)
    NODE[189].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[189].Visible = true
    NODE[189].ZIndex = 1
    NODE[190] = Instance.new("UIListLayout")
    NODE[190].Name = "UIListLayout"
    NODE[190].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[190].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[190].Padding = UDim.new(0.0, 8)
    NODE[190].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[190].Wraps = false
    NODE[190].FillDirection = Enum.FillDirection.Vertical
    NODE[190].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[190].SortOrder = Enum.SortOrder.Name
    NODE[190].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[191] = Instance.new("ImageButton")
    NODE[191].Name = "template"
    NODE[191].HoverImage = ""
    NODE[191].Image = ""
    NODE[191].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[191].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[191].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[191].ImageTransparency = 0
    NODE[191].PressedImage = ""
    NODE[191].ResampleMode = Enum.ResamplerMode.Default
    NODE[191].ScaleType = Enum.ScaleType.Fit
    NODE[191].SliceCenter = Rect.new(512, 512, 512, 512)
    NODE[191].SliceScale = 0.0399999991
    NODE[191].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[191].AutoButtonColor = true
    NODE[191].Modal = false
    NODE[191].Selected = false
    NODE[191].Active = true
    NODE[191].AnchorPoint = Vector2.new(0.5, 1.0)
    NODE[191].AutomaticSize = Enum.AutomaticSize.Y
    NODE[191].BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    NODE[191].BackgroundTransparency = 0
    NODE[191].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[191].BorderMode = Enum.BorderMode.Outline
    NODE[191].BorderSizePixel = 0
    NODE[191].ClipsDescendants = true
    NODE[191].Interactable = true
    NODE[191].LayoutOrder = 0
    NODE[191].Position = UDim2.new(0.5, 0, 1.0, 0)
    NODE[191].Rotation = 0
    NODE[191].Selectable = true
    NODE[191].Size = UDim2.new(1.0, 0, 0.0, 44)
    NODE[191].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[191].Visible = true
    NODE[191].ZIndex = 1
    NODE[192] = Instance.new("UIListLayout")
    NODE[192].Name = "list"
    NODE[192].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[192].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[192].Padding = UDim.new(0.0, 8)
    NODE[192].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[192].Wraps = false
    NODE[192].FillDirection = Enum.FillDirection.Horizontal
    NODE[192].HorizontalAlignment = Enum.HorizontalAlignment.Center
    NODE[192].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[192].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[192].Parent = NODE[191]
    NODE[193] = Instance.new("UICorner")
    NODE[193].Name = "corner"
    NODE[193].CornerRadius = UDim.new(0.0, 20)
    NODE[193].CornerRadius = UDim.new(0.0, 20)
    NODE[193].CornerRadius = UDim.new(0.0, 20)
    NODE[193].CornerRadius = UDim.new(0.0, 20)
    NODE[193].Parent = NODE[191]
    NODE[194] = Instance.new("UIPadding")
    NODE[194].Name = "padding"
    NODE[194].PaddingBottom = UDim.new(0.0, 8)
    NODE[194].PaddingLeft = UDim.new(0.0, 12)
    NODE[194].PaddingRight = UDim.new(0.0, 12)
    NODE[194].PaddingTop = UDim.new(0.0, 8)
    NODE[194].Parent = NODE[191]
    NODE[195] = Instance.new("TextLabel")
    NODE[195].Name = "value"
    NODE[195].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
    NODE[195].LineHeight = 1
    NODE[195].MaxVisibleGraphemes = -1
    NODE[195].OpenTypeFeatures = ""
    NODE[195].RichText = false
    NODE[195].Text = "All Shortcuts"
    NODE[195].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[195].TextDirection = Enum.TextDirection.LeftToRight
    NODE[195].TextScaled = false
    NODE[195].TextSize = 13
    NODE[195].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[195].TextStrokeTransparency = 1
    NODE[195].TextTransparency = 0
    NODE[195].TextTruncate = Enum.TextTruncate.None
    NODE[195].TextWrapped = true
    NODE[195].TextXAlignment = Enum.TextXAlignment.Center
    NODE[195].TextYAlignment = Enum.TextYAlignment.Top
    NODE[195].Active = false
    NODE[195].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[195].AutomaticSize = Enum.AutomaticSize.Y
    NODE[195].BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    NODE[195].BackgroundTransparency = 1
    NODE[195].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[195].BorderMode = Enum.BorderMode.Outline
    NODE[195].BorderSizePixel = 0
    NODE[195].ClipsDescendants = false
    NODE[195].Interactable = true
    NODE[195].LayoutOrder = 2
    NODE[195].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[195].Rotation = 0
    NODE[195].Selectable = false
    NODE[195].Size = UDim2.new(0.0, 20, 0.0, 0)
    NODE[195].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[195].Visible = true
    NODE[195].ZIndex = 1
    NODE[196] = Instance.new("UIFlexItem")
    NODE[196].Name = "flex"
    NODE[196].FlexMode = Enum.UIFlexMode.Fill
    NODE[196].GrowRatio = 0
    NODE[196].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[196].ShrinkRatio = 0
    NODE[196].Parent = NODE[195]
    NODE[195].Parent = NODE[191]
    NODE[191].Parent = NODE[190]
    NODE[190].Parent = NODE[189]
    NODE[197] = Instance.new("UIPadding")
    NODE[197].Name = "UIPadding"
    NODE[197].PaddingBottom = UDim.new(0.0, 75)
    NODE[197].PaddingLeft = UDim.new(0.0, 24)
    NODE[197].PaddingRight = UDim.new(0.0, 24)
    NODE[197].PaddingTop = UDim.new(0.0, 0)
    NODE[197].Parent = NODE[189]
    NODE[198] = Instance.new("TextLabel")
    NODE[198].Name = "Select Category"
    NODE[198].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
    NODE[198].LineHeight = 1
    NODE[198].MaxVisibleGraphemes = -1
    NODE[198].OpenTypeFeatures = ""
    NODE[198].RichText = false
    NODE[198].Text = "Select Category"
    NODE[198].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[198].TextDirection = Enum.TextDirection.LeftToRight
    NODE[198].TextScaled = true
    NODE[198].TextSize = 14
    NODE[198].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[198].TextStrokeTransparency = 1
    NODE[198].TextTransparency = 0
    NODE[198].TextTruncate = Enum.TextTruncate.None
    NODE[198].TextWrapped = true
    NODE[198].TextXAlignment = Enum.TextXAlignment.Center
    NODE[198].TextYAlignment = Enum.TextYAlignment.Center
    NODE[198].Active = false
    NODE[198].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[198].AutomaticSize = Enum.AutomaticSize.None
    NODE[198].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[198].BackgroundTransparency = 1
    NODE[198].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[198].BorderMode = Enum.BorderMode.Outline
    NODE[198].BorderSizePixel = 0
    NODE[198].ClipsDescendants = false
    NODE[198].Interactable = true
    NODE[198].LayoutOrder = 0
    NODE[198].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[198].Rotation = 0
    NODE[198].Selectable = false
    NODE[198].Size = UDim2.new(1.0, 0, 0.0, 30)
    NODE[198].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[198].Visible = true
    NODE[198].ZIndex = 1
    NODE[199] = Instance.new("UITextSizeConstraint")
    NODE[199].Name = "UITextSizeConstraint"
    NODE[199].MaxTextSize = 18
    NODE[199].MinTextSize = 1
    NODE[199].Parent = NODE[198]
    NODE[198].Parent = NODE[189]
    NODE[189].Parent = NODE[187]
    NODE[187].Parent = NODE[186]
    NODE[200] = Instance.new("ImageLabel")
    NODE[200].Name = "fade"
    NODE[200].Image = "rbxassetid://125088425775676"
    NODE[200].ImageColor3 = Color3.fromRGB(18, 18, 18)
    NODE[200].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[200].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[200].ImageTransparency = 1
    NODE[200].ResampleMode = Enum.ResamplerMode.Default
    NODE[200].ScaleType = Enum.ScaleType.Slice
    NODE[200].SliceCenter = Rect.new(512, 512, 512, 512)
    NODE[200].SliceScale = 1
    NODE[200].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[200].Active = false
    NODE[200].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[200].AutomaticSize = Enum.AutomaticSize.None
    NODE[200].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[200].BackgroundTransparency = 0
    NODE[200].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[200].BorderMode = Enum.BorderMode.Outline
    NODE[200].BorderSizePixel = 0
    NODE[200].ClipsDescendants = false
    NODE[200].Interactable = true
    NODE[200].LayoutOrder = 0
    NODE[200].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[200].Rotation = 0
    NODE[200].Selectable = true
    NODE[200].Size = UDim2.new(1.0, 0, 0.0, 70)
    NODE[200].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[200].Visible = true
    NODE[200].ZIndex = 2
    NODE[201] = Instance.new("UIGradient")
    NODE[201].Name = "gradient"
    NODE[201].Color = ColorSequence.new({ ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)) })
    NODE[201].Enabled = true
    NODE[201].Offset = Vector2.new(0.0, 0.0)
    NODE[201].Rotation = 90
    NODE[201].Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0.0, 0.0), NumberSequenceKeypoint.new(1.0, 1.0) })
    NODE[201].Parent = NODE[200]
    NODE[202] = Instance.new("UICorner")
    NODE[202].Name = "UICorner"
    NODE[202].CornerRadius = UDim.new(0.0, 33)
    NODE[202].CornerRadius = UDim.new(0.0, 33)
    NODE[202].CornerRadius = UDim.new(0.0, 33)
    NODE[202].CornerRadius = UDim.new(0.0, 33)
    NODE[202].Parent = NODE[200]
    NODE[200].Parent = NODE[186]
    NODE[186].Parent = NODE[184]
    NODE[184].Parent = NODE[106]
    NODE[106].Parent = NODE[105]
    NODE[203] = Instance.new("UIScale")
    NODE[203].Name = "scale"
    NODE[203].Scale = 1
    NODE[203].Parent = NODE[105]
    NODE[204] = Instance.new("UIPadding")
    NODE[204].Name = "padding"
    NODE[204].PaddingBottom = UDim.new(0.0, 75)
    NODE[204].PaddingLeft = UDim.new(0.0, 75)
    NODE[204].PaddingRight = UDim.new(0.0, 75)
    NODE[204].PaddingTop = UDim.new(0.0, 75)
    NODE[204].Parent = NODE[105]
    NODE[205] = Instance.new("UIListLayout")
    NODE[205].Name = "list"
    NODE[205].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[205].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[205].Padding = UDim.new(0.0, 0)
    NODE[205].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[205].Wraps = false
    NODE[205].FillDirection = Enum.FillDirection.Vertical
    NODE[205].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[205].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[205].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[205].Parent = NODE[105]
    NODE[105].Parent = NODE[104]
    NODE[104].Parent = ShortcutsGui
    NODE[206] = Instance.new("CanvasGroup")
    NODE[206].Name = "Settings"
    NODE[206].GroupColor3 = Color3.fromRGB(255, 255, 255)
    NODE[206].GroupTransparency = 0
    NODE[206].Active = false
    NODE[206].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[206].AutomaticSize = Enum.AutomaticSize.None
    NODE[206].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[206].BackgroundTransparency = 0
    NODE[206].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[206].BorderMode = Enum.BorderMode.Outline
    NODE[206].BorderSizePixel = 0
    NODE[206].ClipsDescendants = true
    NODE[206].Interactable = true
    NODE[206].LayoutOrder = 0
    NODE[206].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[206].Rotation = 0
    NODE[206].Selectable = false
    NODE[206].Size = UDim2.new(0.0, 400, 0.0, 225)
    NODE[206].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[206].Visible = false
    NODE[206].ZIndex = 9999
    NODE[207] = Instance.new("UICorner")
    NODE[207].Name = "UICorner"
    NODE[207].CornerRadius = UDim.new(0.0, 26)
    NODE[207].CornerRadius = UDim.new(0.0, 26)
    NODE[207].CornerRadius = UDim.new(0.0, 26)
    NODE[207].CornerRadius = UDim.new(0.0, 26)
    NODE[207].Parent = NODE[206]
    NODE[208] = Instance.new("Frame")
    NODE[208].Name = "Configuration"
    NODE[208].Active = false
    NODE[208].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[208].AutomaticSize = Enum.AutomaticSize.Y
    NODE[208].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[208].BackgroundTransparency = 1
    NODE[208].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[208].BorderMode = Enum.BorderMode.Outline
    NODE[208].BorderSizePixel = 0
    NODE[208].ClipsDescendants = false
    NODE[208].Interactable = true
    NODE[208].LayoutOrder = 1
    NODE[208].Position = UDim2.new(0.0, 0, 0.0, 43)
    NODE[208].Rotation = 0
    NODE[208].Selectable = false
    NODE[208].Size = UDim2.new(1.0, 0, 0.0, 0)
    NODE[208].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[208].Visible = true
    NODE[208].ZIndex = 1
    NODE[209] = Instance.new("CanvasGroup")
    NODE[209].Name = "Container"
    NODE[209].GroupColor3 = Color3.fromRGB(255, 255, 255)
    NODE[209].GroupTransparency = 0
    NODE[209].Active = false
    NODE[209].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[209].AutomaticSize = Enum.AutomaticSize.Y
    NODE[209].BackgroundColor3 = Color3.fromRGB(27, 27, 27)
    NODE[209].BackgroundTransparency = 1
    NODE[209].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[209].BorderMode = Enum.BorderMode.Outline
    NODE[209].BorderSizePixel = 0
    NODE[209].ClipsDescendants = true
    NODE[209].Interactable = true
    NODE[209].LayoutOrder = 2
    NODE[209].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[209].Rotation = 0
    NODE[209].Selectable = false
    NODE[209].Size = UDim2.new(1.0, 0, 0.0, 0)
    NODE[209].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[209].Visible = true
    NODE[209].ZIndex = 1
    NODE[210] = Instance.new("UICorner")
    NODE[210].Name = "UICorner"
    NODE[210].CornerRadius = UDim.new(0.0, 16)
    NODE[210].CornerRadius = UDim.new(0.0, 16)
    NODE[210].CornerRadius = UDim.new(0.0, 16)
    NODE[210].CornerRadius = UDim.new(0.0, 16)
    NODE[210].Parent = NODE[209]
    NODE[211] = Instance.new("ImageButton")
    NODE[211].Name = "TopbarEnabled"
    NODE[211].HoverImage = ""
    NODE[211].Image = ""
    NODE[211].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[211].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[211].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[211].ImageTransparency = 0
    NODE[211].PressedImage = ""
    NODE[211].ResampleMode = Enum.ResamplerMode.Default
    NODE[211].ScaleType = Enum.ScaleType.Stretch
    NODE[211].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[211].SliceScale = 1
    NODE[211].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[211].AutoButtonColor = true
    NODE[211].Modal = false
    NODE[211].Selected = false
    NODE[211].Active = true
    NODE[211].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[211].AutomaticSize = Enum.AutomaticSize.None
    NODE[211].BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    NODE[211].BackgroundTransparency = 0
    NODE[211].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[211].BorderMode = Enum.BorderMode.Outline
    NODE[211].BorderSizePixel = 0
    NODE[211].ClipsDescendants = false
    NODE[211].Interactable = true
    NODE[211].LayoutOrder = 3
    NODE[211].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[211].Rotation = 0
    NODE[211].Selectable = true
    NODE[211].Size = UDim2.new(1.0, 0, 0.0, 40)
    NODE[211].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[211].Visible = true
    NODE[211].ZIndex = 1
    NODE[212] = Instance.new("TextLabel")
    NODE[212].Name = "Label"
    NODE[212].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[212].LineHeight = 1
    NODE[212].MaxVisibleGraphemes = -1
    NODE[212].OpenTypeFeatures = ""
    NODE[212].RichText = false
    NODE[212].Text = "Topbar Enabled"
    NODE[212].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[212].TextDirection = Enum.TextDirection.LeftToRight
    NODE[212].TextScaled = false
    NODE[212].TextSize = 14
    NODE[212].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[212].TextStrokeTransparency = 1
    NODE[212].TextTransparency = 0
    NODE[212].TextTruncate = Enum.TextTruncate.None
    NODE[212].TextWrapped = false
    NODE[212].TextXAlignment = Enum.TextXAlignment.Center
    NODE[212].TextYAlignment = Enum.TextYAlignment.Center
    NODE[212].Active = false
    NODE[212].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[212].AutomaticSize = Enum.AutomaticSize.X
    NODE[212].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[212].BackgroundTransparency = 1
    NODE[212].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[212].BorderMode = Enum.BorderMode.Outline
    NODE[212].BorderSizePixel = 0
    NODE[212].ClipsDescendants = false
    NODE[212].Interactable = true
    NODE[212].LayoutOrder = 0
    NODE[212].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[212].Rotation = 0
    NODE[212].Selectable = false
    NODE[212].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[212].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[212].Visible = true
    NODE[212].ZIndex = 1
    NODE[212].Parent = NODE[211]
    NODE[213] = Instance.new("UIListLayout")
    NODE[213].Name = "UIListLayout"
    NODE[213].HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
    NODE[213].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[213].Padding = UDim.new(0.0, 20)
    NODE[213].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[213].Wraps = false
    NODE[213].FillDirection = Enum.FillDirection.Horizontal
    NODE[213].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[213].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[213].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[213].Parent = NODE[211]
    NODE[214] = Instance.new("UIPadding")
    NODE[214].Name = "UIPadding"
    NODE[214].PaddingBottom = UDim.new(0.0, 0)
    NODE[214].PaddingLeft = UDim.new(0.0, 20)
    NODE[214].PaddingRight = UDim.new(0.0, 20)
    NODE[214].PaddingTop = UDim.new(0.0, 0)
    NODE[214].Parent = NODE[211]
    NODE[215] = Instance.new("TextLabel")
    NODE[215].Name = "Value"
    NODE[215].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[215].LineHeight = 1
    NODE[215].MaxVisibleGraphemes = -1
    NODE[215].OpenTypeFeatures = ""
    NODE[215].RichText = false
    NODE[215].Text = "Yes"
    NODE[215].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[215].TextDirection = Enum.TextDirection.LeftToRight
    NODE[215].TextScaled = false
    NODE[215].TextSize = 14
    NODE[215].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[215].TextStrokeTransparency = 1
    NODE[215].TextTransparency = 0
    NODE[215].TextTruncate = Enum.TextTruncate.None
    NODE[215].TextWrapped = false
    NODE[215].TextXAlignment = Enum.TextXAlignment.Center
    NODE[215].TextYAlignment = Enum.TextYAlignment.Center
    NODE[215].Active = false
    NODE[215].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[215].AutomaticSize = Enum.AutomaticSize.X
    NODE[215].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[215].BackgroundTransparency = 1
    NODE[215].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[215].BorderMode = Enum.BorderMode.Outline
    NODE[215].BorderSizePixel = 0
    NODE[215].ClipsDescendants = false
    NODE[215].Interactable = true
    NODE[215].LayoutOrder = 0
    NODE[215].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[215].Rotation = 0
    NODE[215].Selectable = false
    NODE[215].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[215].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[215].Visible = true
    NODE[215].ZIndex = 1
    NODE[215].Parent = NODE[211]
    NODE[211].Parent = NODE[209]
    NODE[216] = Instance.new("ImageButton")
    NODE[216].Name = "Theme"
    NODE[216].HoverImage = ""
    NODE[216].Image = ""
    NODE[216].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[216].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[216].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[216].ImageTransparency = 0
    NODE[216].PressedImage = ""
    NODE[216].ResampleMode = Enum.ResamplerMode.Default
    NODE[216].ScaleType = Enum.ScaleType.Stretch
    NODE[216].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[216].SliceScale = 1
    NODE[216].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[216].AutoButtonColor = true
    NODE[216].Modal = false
    NODE[216].Selected = false
    NODE[216].Active = true
    NODE[216].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[216].AutomaticSize = Enum.AutomaticSize.None
    NODE[216].BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    NODE[216].BackgroundTransparency = 0
    NODE[216].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[216].BorderMode = Enum.BorderMode.Outline
    NODE[216].BorderSizePixel = 0
    NODE[216].ClipsDescendants = false
    NODE[216].Interactable = true
    NODE[216].LayoutOrder = 6
    NODE[216].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[216].Rotation = 0
    NODE[216].Selectable = true
    NODE[216].Size = UDim2.new(1.0, 0, 0.0, 40)
    NODE[216].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[216].Visible = true
    NODE[216].ZIndex = 1
    NODE[217] = Instance.new("TextLabel")
    NODE[217].Name = "Label"
    NODE[217].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[217].LineHeight = 1
    NODE[217].MaxVisibleGraphemes = -1
    NODE[217].OpenTypeFeatures = ""
    NODE[217].RichText = false
    NODE[217].Text = "Theme"
    NODE[217].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[217].TextDirection = Enum.TextDirection.LeftToRight
    NODE[217].TextScaled = false
    NODE[217].TextSize = 14
    NODE[217].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[217].TextStrokeTransparency = 1
    NODE[217].TextTransparency = 0
    NODE[217].TextTruncate = Enum.TextTruncate.None
    NODE[217].TextWrapped = false
    NODE[217].TextXAlignment = Enum.TextXAlignment.Center
    NODE[217].TextYAlignment = Enum.TextYAlignment.Center
    NODE[217].Active = false
    NODE[217].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[217].AutomaticSize = Enum.AutomaticSize.X
    NODE[217].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[217].BackgroundTransparency = 1
    NODE[217].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[217].BorderMode = Enum.BorderMode.Outline
    NODE[217].BorderSizePixel = 0
    NODE[217].ClipsDescendants = false
    NODE[217].Interactable = true
    NODE[217].LayoutOrder = 0
    NODE[217].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[217].Rotation = 0
    NODE[217].Selectable = false
    NODE[217].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[217].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[217].Visible = true
    NODE[217].ZIndex = 1
    NODE[217].Parent = NODE[216]
    NODE[218] = Instance.new("UIListLayout")
    NODE[218].Name = "UIListLayout"
    NODE[218].HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
    NODE[218].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[218].Padding = UDim.new(0.0, 20)
    NODE[218].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[218].Wraps = false
    NODE[218].FillDirection = Enum.FillDirection.Horizontal
    NODE[218].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[218].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[218].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[218].Parent = NODE[216]
    NODE[219] = Instance.new("UIPadding")
    NODE[219].Name = "UIPadding"
    NODE[219].PaddingBottom = UDim.new(0.0, 0)
    NODE[219].PaddingLeft = UDim.new(0.0, 20)
    NODE[219].PaddingRight = UDim.new(0.0, 20)
    NODE[219].PaddingTop = UDim.new(0.0, 0)
    NODE[219].Parent = NODE[216]
    NODE[220] = Instance.new("TextLabel")
    NODE[220].Name = "Value"
    NODE[220].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[220].LineHeight = 1
    NODE[220].MaxVisibleGraphemes = -1
    NODE[220].OpenTypeFeatures = ""
    NODE[220].RichText = false
    NODE[220].Text = "Dark"
    NODE[220].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[220].TextDirection = Enum.TextDirection.LeftToRight
    NODE[220].TextScaled = false
    NODE[220].TextSize = 14
    NODE[220].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[220].TextStrokeTransparency = 1
    NODE[220].TextTransparency = 0.800000012
    NODE[220].TextTruncate = Enum.TextTruncate.None
    NODE[220].TextWrapped = false
    NODE[220].TextXAlignment = Enum.TextXAlignment.Center
    NODE[220].TextYAlignment = Enum.TextYAlignment.Center
    NODE[220].Active = false
    NODE[220].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[220].AutomaticSize = Enum.AutomaticSize.X
    NODE[220].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[220].BackgroundTransparency = 1
    NODE[220].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[220].BorderMode = Enum.BorderMode.Outline
    NODE[220].BorderSizePixel = 0
    NODE[220].ClipsDescendants = false
    NODE[220].Interactable = true
    NODE[220].LayoutOrder = 0
    NODE[220].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[220].Rotation = 0
    NODE[220].Selectable = false
    NODE[220].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[220].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[220].Visible = true
    NODE[220].ZIndex = 1
    NODE[220].Parent = NODE[216]
    NODE[216].Parent = NODE[209]
    NODE[221] = Instance.new("ImageButton")
    NODE[221].Name = "Keybind"
    NODE[221].HoverImage = ""
    NODE[221].Image = ""
    NODE[221].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[221].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[221].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[221].ImageTransparency = 0
    NODE[221].PressedImage = ""
    NODE[221].ResampleMode = Enum.ResamplerMode.Default
    NODE[221].ScaleType = Enum.ScaleType.Stretch
    NODE[221].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[221].SliceScale = 1
    NODE[221].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[221].AutoButtonColor = true
    NODE[221].Modal = false
    NODE[221].Selected = false
    NODE[221].Active = true
    NODE[221].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[221].AutomaticSize = Enum.AutomaticSize.None
    NODE[221].BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    NODE[221].BackgroundTransparency = 0
    NODE[221].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[221].BorderMode = Enum.BorderMode.Outline
    NODE[221].BorderSizePixel = 0
    NODE[221].ClipsDescendants = false
    NODE[221].Interactable = true
    NODE[221].LayoutOrder = 5
    NODE[221].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[221].Rotation = 0
    NODE[221].Selectable = true
    NODE[221].Size = UDim2.new(1.0, 0, 0.0, 40)
    NODE[221].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[221].Visible = true
    NODE[221].ZIndex = 1
    NODE[222] = Instance.new("TextLabel")
    NODE[222].Name = "Label"
    NODE[222].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[222].LineHeight = 1
    NODE[222].MaxVisibleGraphemes = -1
    NODE[222].OpenTypeFeatures = ""
    NODE[222].RichText = false
    NODE[222].Text = "Open Keybind"
    NODE[222].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[222].TextDirection = Enum.TextDirection.LeftToRight
    NODE[222].TextScaled = false
    NODE[222].TextSize = 14
    NODE[222].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[222].TextStrokeTransparency = 1
    NODE[222].TextTransparency = 0
    NODE[222].TextTruncate = Enum.TextTruncate.None
    NODE[222].TextWrapped = false
    NODE[222].TextXAlignment = Enum.TextXAlignment.Center
    NODE[222].TextYAlignment = Enum.TextYAlignment.Center
    NODE[222].Active = false
    NODE[222].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[222].AutomaticSize = Enum.AutomaticSize.X
    NODE[222].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[222].BackgroundTransparency = 1
    NODE[222].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[222].BorderMode = Enum.BorderMode.Outline
    NODE[222].BorderSizePixel = 0
    NODE[222].ClipsDescendants = false
    NODE[222].Interactable = true
    NODE[222].LayoutOrder = 0
    NODE[222].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[222].Rotation = 0
    NODE[222].Selectable = false
    NODE[222].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[222].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[222].Visible = true
    NODE[222].ZIndex = 1
    NODE[222].Parent = NODE[221]
    NODE[223] = Instance.new("UIListLayout")
    NODE[223].Name = "UIListLayout"
    NODE[223].HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
    NODE[223].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[223].Padding = UDim.new(0.0, 20)
    NODE[223].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[223].Wraps = false
    NODE[223].FillDirection = Enum.FillDirection.Horizontal
    NODE[223].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[223].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[223].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[223].Parent = NODE[221]
    NODE[224] = Instance.new("UIPadding")
    NODE[224].Name = "UIPadding"
    NODE[224].PaddingBottom = UDim.new(0.0, 0)
    NODE[224].PaddingLeft = UDim.new(0.0, 20)
    NODE[224].PaddingRight = UDim.new(0.0, 20)
    NODE[224].PaddingTop = UDim.new(0.0, 0)
    NODE[224].Parent = NODE[221]
    NODE[225] = Instance.new("TextLabel")
    NODE[225].Name = "Value"
    NODE[225].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[225].LineHeight = 1
    NODE[225].MaxVisibleGraphemes = -1
    NODE[225].OpenTypeFeatures = ""
    NODE[225].RichText = false
    NODE[225].Text = "F4"
    NODE[225].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[225].TextDirection = Enum.TextDirection.LeftToRight
    NODE[225].TextScaled = false
    NODE[225].TextSize = 14
    NODE[225].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[225].TextStrokeTransparency = 1
    NODE[225].TextTransparency = 0
    NODE[225].TextTruncate = Enum.TextTruncate.None
    NODE[225].TextWrapped = false
    NODE[225].TextXAlignment = Enum.TextXAlignment.Center
    NODE[225].TextYAlignment = Enum.TextYAlignment.Center
    NODE[225].Active = false
    NODE[225].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[225].AutomaticSize = Enum.AutomaticSize.X
    NODE[225].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[225].BackgroundTransparency = 1
    NODE[225].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[225].BorderMode = Enum.BorderMode.Outline
    NODE[225].BorderSizePixel = 0
    NODE[225].ClipsDescendants = false
    NODE[225].Interactable = true
    NODE[225].LayoutOrder = 0
    NODE[225].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[225].Rotation = 0
    NODE[225].Selectable = false
    NODE[225].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[225].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[225].Visible = true
    NODE[225].ZIndex = 1
    NODE[225].Parent = NODE[221]
    NODE[221].Parent = NODE[209]
    NODE[226] = Instance.new("ImageButton")
    NODE[226].Name = "AutomaticallyLockMouse"
    NODE[226].HoverImage = ""
    NODE[226].Image = ""
    NODE[226].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[226].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[226].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[226].ImageTransparency = 0
    NODE[226].PressedImage = ""
    NODE[226].ResampleMode = Enum.ResamplerMode.Default
    NODE[226].ScaleType = Enum.ScaleType.Stretch
    NODE[226].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[226].SliceScale = 1
    NODE[226].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[226].AutoButtonColor = true
    NODE[226].Modal = false
    NODE[226].Selected = false
    NODE[226].Active = true
    NODE[226].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[226].AutomaticSize = Enum.AutomaticSize.None
    NODE[226].BackgroundColor3 = Color3.fromRGB(8, 8, 8)
    NODE[226].BackgroundTransparency = 0
    NODE[226].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[226].BorderMode = Enum.BorderMode.Outline
    NODE[226].BorderSizePixel = 0
    NODE[226].ClipsDescendants = false
    NODE[226].Interactable = true
    NODE[226].LayoutOrder = 4
    NODE[226].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[226].Rotation = 0
    NODE[226].Selectable = true
    NODE[226].Size = UDim2.new(1.0, 0, 0.0, 40)
    NODE[226].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[226].Visible = true
    NODE[226].ZIndex = 1
    NODE[227] = Instance.new("TextLabel")
    NODE[227].Name = "Label"
    NODE[227].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[227].LineHeight = 1
    NODE[227].MaxVisibleGraphemes = -1
    NODE[227].OpenTypeFeatures = ""
    NODE[227].RichText = false
    NODE[227].Text = "Automatically Lock Mouse"
    NODE[227].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[227].TextDirection = Enum.TextDirection.LeftToRight
    NODE[227].TextScaled = false
    NODE[227].TextSize = 14
    NODE[227].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[227].TextStrokeTransparency = 1
    NODE[227].TextTransparency = 0
    NODE[227].TextTruncate = Enum.TextTruncate.None
    NODE[227].TextWrapped = false
    NODE[227].TextXAlignment = Enum.TextXAlignment.Center
    NODE[227].TextYAlignment = Enum.TextYAlignment.Center
    NODE[227].Active = false
    NODE[227].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[227].AutomaticSize = Enum.AutomaticSize.X
    NODE[227].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[227].BackgroundTransparency = 1
    NODE[227].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[227].BorderMode = Enum.BorderMode.Outline
    NODE[227].BorderSizePixel = 0
    NODE[227].ClipsDescendants = false
    NODE[227].Interactable = true
    NODE[227].LayoutOrder = 0
    NODE[227].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[227].Rotation = 0
    NODE[227].Selectable = false
    NODE[227].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[227].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[227].Visible = true
    NODE[227].ZIndex = 1
    NODE[227].Parent = NODE[226]
    NODE[228] = Instance.new("UIListLayout")
    NODE[228].Name = "UIListLayout"
    NODE[228].HorizontalFlex = Enum.UIFlexAlignment.SpaceBetween
    NODE[228].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[228].Padding = UDim.new(0.0, 20)
    NODE[228].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[228].Wraps = false
    NODE[228].FillDirection = Enum.FillDirection.Horizontal
    NODE[228].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[228].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[228].VerticalAlignment = Enum.VerticalAlignment.Center
    NODE[228].Parent = NODE[226]
    NODE[229] = Instance.new("UIPadding")
    NODE[229].Name = "UIPadding"
    NODE[229].PaddingBottom = UDim.new(0.0, 0)
    NODE[229].PaddingLeft = UDim.new(0.0, 20)
    NODE[229].PaddingRight = UDim.new(0.0, 20)
    NODE[229].PaddingTop = UDim.new(0.0, 0)
    NODE[229].Parent = NODE[226]
    NODE[230] = Instance.new("TextLabel")
    NODE[230].Name = "Value"
    NODE[230].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
    NODE[230].LineHeight = 1
    NODE[230].MaxVisibleGraphemes = -1
    NODE[230].OpenTypeFeatures = ""
    NODE[230].RichText = false
    NODE[230].Text = "Yes"
    NODE[230].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[230].TextDirection = Enum.TextDirection.LeftToRight
    NODE[230].TextScaled = false
    NODE[230].TextSize = 14
    NODE[230].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[230].TextStrokeTransparency = 1
    NODE[230].TextTransparency = 0
    NODE[230].TextTruncate = Enum.TextTruncate.None
    NODE[230].TextWrapped = false
    NODE[230].TextXAlignment = Enum.TextXAlignment.Center
    NODE[230].TextYAlignment = Enum.TextYAlignment.Center
    NODE[230].Active = false
    NODE[230].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[230].AutomaticSize = Enum.AutomaticSize.X
    NODE[230].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[230].BackgroundTransparency = 1
    NODE[230].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[230].BorderMode = Enum.BorderMode.Outline
    NODE[230].BorderSizePixel = 0
    NODE[230].ClipsDescendants = false
    NODE[230].Interactable = true
    NODE[230].LayoutOrder = 0
    NODE[230].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[230].Rotation = 0
    NODE[230].Selectable = false
    NODE[230].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[230].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[230].Visible = true
    NODE[230].ZIndex = 1
    NODE[230].Parent = NODE[226]
    NODE[226].Parent = NODE[209]
    NODE[231] = Instance.new("UIListLayout")
    NODE[231].Name = "UIListLayout"
    NODE[231].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[231].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[231].Padding = UDim.new(0.0, 1)
    NODE[231].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[231].Wraps = false
    NODE[231].FillDirection = Enum.FillDirection.Vertical
    NODE[231].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[231].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[231].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[231].Parent = NODE[209]
    NODE[209].Parent = NODE[208]
    NODE[232] = Instance.new("UIPadding")
    NODE[232].Name = "UIPadding"
    NODE[232].PaddingBottom = UDim.new(0.0, 8)
    NODE[232].PaddingLeft = UDim.new(0.0, 12)
    NODE[232].PaddingRight = UDim.new(0.0, 12)
    NODE[232].PaddingTop = UDim.new(0.0, 8)
    NODE[232].Parent = NODE[208]
    NODE[233] = Instance.new("UIListLayout")
    NODE[233].Name = "UIListLayout"
    NODE[233].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[233].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[233].Padding = UDim.new(0.0, 10)
    NODE[233].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[233].Wraps = false
    NODE[233].FillDirection = Enum.FillDirection.Vertical
    NODE[233].HorizontalAlignment = Enum.HorizontalAlignment.Left
    NODE[233].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[233].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[233].Parent = NODE[208]
    NODE[208].Parent = NODE[206]
    NODE[234] = Instance.new("Frame")
    NODE[234].Name = "WindowControl"
    NODE[234].Active = false
    NODE[234].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[234].AutomaticSize = Enum.AutomaticSize.None
    NODE[234].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[234].BackgroundTransparency = 1
    NODE[234].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[234].BorderMode = Enum.BorderMode.Outline
    NODE[234].BorderSizePixel = 0
    NODE[234].ClipsDescendants = false
    NODE[234].Interactable = true
    NODE[234].LayoutOrder = 0
    NODE[234].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[234].Rotation = 0
    NODE[234].Selectable = false
    NODE[234].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[234].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[234].Visible = true
    NODE[234].ZIndex = 99999
    NODE[235] = Instance.new("Frame")
    NODE[235].Name = "Top"
    NODE[235].Active = false
    NODE[235].AnchorPoint = Vector2.new(0.5, 0.0)
    NODE[235].AutomaticSize = Enum.AutomaticSize.None
    NODE[235].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[235].BackgroundTransparency = 1
    NODE[235].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[235].BorderMode = Enum.BorderMode.Outline
    NODE[235].BorderSizePixel = 0
    NODE[235].ClipsDescendants = false
    NODE[235].Interactable = true
    NODE[235].LayoutOrder = 0
    NODE[235].Position = UDim2.new(0.5, 0, 0.0, 0)
    NODE[235].Rotation = 0
    NODE[235].Selectable = false
    NODE[235].Size = UDim2.new(1.0, 0, 0.0, 50)
    NODE[235].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[235].Visible = true
    NODE[235].ZIndex = 1
    NODE[236] = Instance.new("UIPadding")
    NODE[236].Name = "padding"
    NODE[236].PaddingBottom = UDim.new(0.0, 0)
    NODE[236].PaddingLeft = UDim.new(0.0, 25)
    NODE[236].PaddingRight = UDim.new(0.0, 10)
    NODE[236].PaddingTop = UDim.new(0.0, 22)
    NODE[236].Parent = NODE[235]
    NODE[237] = Instance.new("UIListLayout")
    NODE[237].Name = "list"
    NODE[237].HorizontalFlex = Enum.UIFlexAlignment.None
    NODE[237].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[237].Padding = UDim.new(0.0, 10)
    NODE[237].VerticalFlex = Enum.UIFlexAlignment.None
    NODE[237].Wraps = false
    NODE[237].FillDirection = Enum.FillDirection.Horizontal
    NODE[237].HorizontalAlignment = Enum.HorizontalAlignment.Right
    NODE[237].SortOrder = Enum.SortOrder.LayoutOrder
    NODE[237].VerticalAlignment = Enum.VerticalAlignment.Top
    NODE[237].Parent = NODE[235]
    NODE[238] = Instance.new("TextLabel")
    NODE[238].Name = "header"
    NODE[238].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
    NODE[238].LineHeight = 1
    NODE[238].MaxVisibleGraphemes = -1
    NODE[238].OpenTypeFeatures = ""
    NODE[238].RichText = false
    NODE[238].Text = "Configuration"
    NODE[238].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[238].TextDirection = Enum.TextDirection.LeftToRight
    NODE[238].TextScaled = true
    NODE[238].TextSize = 18
    NODE[238].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[238].TextStrokeTransparency = 1
    NODE[238].TextTransparency = 0
    NODE[238].TextTruncate = Enum.TextTruncate.None
    NODE[238].TextWrapped = true
    NODE[238].TextXAlignment = Enum.TextXAlignment.Left
    NODE[238].TextYAlignment = Enum.TextYAlignment.Top
    NODE[238].Active = false
    NODE[238].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[238].AutomaticSize = Enum.AutomaticSize.X
    NODE[238].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[238].BackgroundTransparency = 1
    NODE[238].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[238].BorderMode = Enum.BorderMode.Outline
    NODE[238].BorderSizePixel = 0
    NODE[238].ClipsDescendants = false
    NODE[238].Interactable = true
    NODE[238].LayoutOrder = 0
    NODE[238].Position = UDim2.new(0.0, 0, 0.0, -6)
    NODE[238].Rotation = 0
    NODE[238].Selectable = false
    NODE[238].Size = UDim2.new(0.0, 0, 1.0, 0)
    NODE[238].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[238].Visible = true
    NODE[238].ZIndex = 900
    NODE[239] = Instance.new("UITextSizeConstraint")
    NODE[239].Name = "UITextSizeConstraint"
    NODE[239].MaxTextSize = 17
    NODE[239].MinTextSize = 1
    NODE[239].Parent = NODE[238]
    NODE[238].Parent = NODE[235]
    NODE[240] = Instance.new("Frame")
    NODE[240].Name = "Close"
    NODE[240].Active = false
    NODE[240].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[240].AutomaticSize = Enum.AutomaticSize.None
    NODE[240].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[240].BackgroundTransparency = 1
    NODE[240].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[240].BorderMode = Enum.BorderMode.Outline
    NODE[240].BorderSizePixel = 0
    NODE[240].ClipsDescendants = false
    NODE[240].Interactable = true
    NODE[240].LayoutOrder = 4
    NODE[240].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[240].Rotation = 0
    NODE[240].Selectable = false
    NODE[240].Size = UDim2.new(1.20000005, 0, 1.20000005, 0)
    NODE[240].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[240].Visible = true
    NODE[240].ZIndex = 1
    NODE[241] = Instance.new("UIAspectRatioConstraint")
    NODE[241].Name = "UIAspectRatioConstraint"
    NODE[241].AspectRatio = 1
    NODE[241].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[241].DominantAxis = Enum.DominantAxis.Width
    NODE[241].Parent = NODE[240]
    NODE[242] = Instance.new("TextButton")
    NODE[242].Name = "ButtonHitbox"
    NODE[242].FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
    NODE[242].LineHeight = 1
    NODE[242].MaxVisibleGraphemes = -1
    NODE[242].OpenTypeFeatures = ""
    NODE[242].RichText = false
    NODE[242].Text = ""
    NODE[242].TextColor3 = Color3.fromRGB(255, 255, 255)
    NODE[242].TextDirection = Enum.TextDirection.LeftToRight
    NODE[242].TextScaled = true
    NODE[242].TextSize = 14
    NODE[242].TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NODE[242].TextStrokeTransparency = 0.5
    NODE[242].TextTransparency = 0.5
    NODE[242].TextTruncate = Enum.TextTruncate.None
    NODE[242].TextWrapped = true
    NODE[242].TextXAlignment = Enum.TextXAlignment.Center
    NODE[242].TextYAlignment = Enum.TextYAlignment.Center
    NODE[242].AutoButtonColor = true
    NODE[242].Modal = false
    NODE[242].Selected = false
    NODE[242].Active = true
    NODE[242].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[242].AutomaticSize = Enum.AutomaticSize.None
    NODE[242].BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    NODE[242].BackgroundTransparency = 0
    NODE[242].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[242].BorderMode = Enum.BorderMode.Outline
    NODE[242].BorderSizePixel = 0
    NODE[242].ClipsDescendants = false
    NODE[242].Interactable = true
    NODE[242].LayoutOrder = 0
    NODE[242].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[242].Rotation = 0
    NODE[242].Selectable = true
    NODE[242].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[242].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[242].Visible = true
    NODE[242].ZIndex = 1
    NODE[243] = Instance.new("ImageLabel")
    NODE[243].Name = "icon"
    NODE[243].Image = "rbxassetid://11293981586"
    NODE[243].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[243].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[243].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[243].ImageTransparency = 0
    NODE[243].ResampleMode = Enum.ResamplerMode.Default
    NODE[243].ScaleType = Enum.ScaleType.Stretch
    NODE[243].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[243].SliceScale = 1
    NODE[243].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[243].Active = false
    NODE[243].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[243].AutomaticSize = Enum.AutomaticSize.None
    NODE[243].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[243].BackgroundTransparency = 1
    NODE[243].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[243].BorderMode = Enum.BorderMode.Outline
    NODE[243].BorderSizePixel = 0
    NODE[243].ClipsDescendants = false
    NODE[243].Interactable = true
    NODE[243].LayoutOrder = 0
    NODE[243].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[243].Rotation = 0
    NODE[243].Selectable = false
    NODE[243].Size = UDim2.new(0.850000024, 0, 0.850000024, 0)
    NODE[243].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[243].Visible = true
    NODE[243].ZIndex = 1
    NODE[243].Parent = NODE[242]
    NODE[244] = Instance.new("UICorner")
    NODE[244].Name = "UICorner"
    NODE[244].CornerRadius = UDim.new(0.0, 100)
    NODE[244].CornerRadius = UDim.new(0.0, 100)
    NODE[244].CornerRadius = UDim.new(0.0, 100)
    NODE[244].CornerRadius = UDim.new(0.0, 100)
    NODE[244].Parent = NODE[242]
    NODE[245] = Instance.new("UIPadding")
    NODE[245].Name = "UIPadding"
    NODE[245].PaddingBottom = UDim.new(0.0, 7)
    NODE[245].PaddingLeft = UDim.new(0.0, 7)
    NODE[245].PaddingRight = UDim.new(0.0, 7)
    NODE[245].PaddingTop = UDim.new(0.0, 7)
    NODE[245].Parent = NODE[242]
    NODE[242].Parent = NODE[240]
    NODE[246] = Instance.new("UIPadding")
    NODE[246].Name = "UIPadding"
    NODE[246].PaddingBottom = UDim.new(0.0, 9)
    NODE[246].PaddingLeft = UDim.new(0.0, -5)
    NODE[246].PaddingRight = UDim.new(0.0, 5)
    NODE[246].PaddingTop = UDim.new(0.0, -9)
    NODE[246].Parent = NODE[240]
    NODE[240].Parent = NODE[235]
    NODE[247] = Instance.new("Frame")
    NODE[247].Name = "space"
    NODE[247].Active = false
    NODE[247].AnchorPoint = Vector2.new(0.0, 0.0)
    NODE[247].AutomaticSize = Enum.AutomaticSize.None
    NODE[247].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[247].BackgroundTransparency = 1
    NODE[247].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[247].BorderMode = Enum.BorderMode.Outline
    NODE[247].BorderSizePixel = 0
    NODE[247].ClipsDescendants = false
    NODE[247].Interactable = true
    NODE[247].LayoutOrder = 1
    NODE[247].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[247].Rotation = 0
    NODE[247].Selectable = false
    NODE[247].Size = UDim2.new(0.0, 0, 0.0, 0)
    NODE[247].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[247].Visible = true
    NODE[247].ZIndex = 1
    NODE[248] = Instance.new("UIFlexItem")
    NODE[248].Name = "UIFlexItem"
    NODE[248].FlexMode = Enum.UIFlexMode.Fill
    NODE[248].GrowRatio = 0
    NODE[248].ItemLineAlignment = Enum.ItemLineAlignment.Automatic
    NODE[248].ShrinkRatio = 0
    NODE[248].Parent = NODE[247]
    NODE[247].Parent = NODE[235]
    NODE[249] = Instance.new("Frame")
    NODE[249].Name = "Category"
    NODE[249].Active = false
    NODE[249].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[249].AutomaticSize = Enum.AutomaticSize.None
    NODE[249].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[249].BackgroundTransparency = 1
    NODE[249].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[249].BorderMode = Enum.BorderMode.Outline
    NODE[249].BorderSizePixel = 0
    NODE[249].ClipsDescendants = false
    NODE[249].Interactable = true
    NODE[249].LayoutOrder = 2
    NODE[249].Position = UDim2.new(0.0, 0, 0.0, 0)
    NODE[249].Rotation = 0
    NODE[249].Selectable = false
    NODE[249].Size = UDim2.new(1.20000005, 0, 1.20000005, 0)
    NODE[249].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[249].Visible = true
    NODE[249].ZIndex = 1
    NODE[250] = Instance.new("UIAspectRatioConstraint")
    NODE[250].Name = "UIAspectRatioConstraint"
    NODE[250].AspectRatio = 1
    NODE[250].AspectType = Enum.AspectType.FitWithinMaxSize
    NODE[250].DominantAxis = Enum.DominantAxis.Width
    NODE[250].Parent = NODE[249]
    NODE[251] = Instance.new("UIPadding")
    NODE[251].Name = "UIPadding"
    NODE[251].PaddingBottom = UDim.new(0.0, 9)
    NODE[251].PaddingLeft = UDim.new(0.0, 5)
    NODE[251].PaddingRight = UDim.new(0.0, -5)
    NODE[251].PaddingTop = UDim.new(0.0, -9)
    NODE[251].Parent = NODE[249]
    NODE[249].Parent = NODE[235]
    NODE[235].Parent = NODE[234]
    NODE[252] = Instance.new("ImageButton")
    NODE[252].Name = "Interaction_Protection"
    NODE[252].HoverImage = ""
    NODE[252].Image = ""
    NODE[252].ImageColor3 = Color3.fromRGB(255, 255, 255)
    NODE[252].ImageRectOffset = Vector2.new(0.0, 0.0)
    NODE[252].ImageRectSize = Vector2.new(0.0, 0.0)
    NODE[252].ImageTransparency = 0
    NODE[252].PressedImage = ""
    NODE[252].ResampleMode = Enum.ResamplerMode.Default
    NODE[252].ScaleType = Enum.ScaleType.Stretch
    NODE[252].SliceCenter = Rect.new(0, 0, 0, 0)
    NODE[252].SliceScale = 1
    NODE[252].TileSize = UDim2.new(1.0, 0, 1.0, 0)
    NODE[252].AutoButtonColor = false
    NODE[252].Modal = false
    NODE[252].Selected = false
    NODE[252].Active = true
    NODE[252].AnchorPoint = Vector2.new(0.5, 0.5)
    NODE[252].AutomaticSize = Enum.AutomaticSize.None
    NODE[252].BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NODE[252].BackgroundTransparency = 1
    NODE[252].BorderColor3 = Color3.fromRGB(0, 0, 0)
    NODE[252].BorderMode = Enum.BorderMode.Outline
    NODE[252].BorderSizePixel = 0
    NODE[252].ClipsDescendants = false
    NODE[252].Interactable = true
    NODE[252].LayoutOrder = 0
    NODE[252].Position = UDim2.new(0.5, 0, 0.5, 0)
    NODE[252].Rotation = 0
    NODE[252].Selectable = true
    NODE[252].Size = UDim2.new(1.0, 0, 1.0, 0)
    NODE[252].SizeConstraint = Enum.SizeConstraint.RelativeXY
    NODE[252].Visible = false
    NODE[252].ZIndex = 1
    NODE[252].Parent = NODE[234]
    NODE[234].Parent = NODE[206]
    NODE[206].Parent = ShortcutsGui

    ShortcutsGui.Parent = parentGui

    return ShortcutsGui
end

-- ── Main Shortcut Logic & Handlers
function Shortcut.Init()
    if Shortcut.Initialized then return end
    Shortcut.Initialized = true

    local parentContainer = Assets.Functions.gethui and Assets.Functions.gethui() or game:GetService("CoreGui")
    local ShortcutsGui = Shortcut.BuildUI(parentContainer)
    Shortcut.UI = ShortcutsGui

    local Menu = ShortcutsGui.Menu
    local main = ShortcutsGui.Menu.main
    local ActionsContainer = ShortcutsGui.Menu.main.Background
    local ActionsIcon = ShortcutsGui.Menu.main.Icons
    local Modals = ShortcutsGui["<< Modals >>"]
    local ActionSelection = ActionsContainer.Hover
    local SettingsUI = ShortcutsGui.Settings

    Menu.Visible = false
    SettingsUI.Visible = false

    local IsMobileOrTablet = UserInputService.TouchEnabled
    local IsMobile = false
    local IsTablet = false

    local function CheckDevice()
        if IsMobileOrTablet then
            local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
            if vp.X + vp.Y < 1300 then
                IsMobile = true
                return
            end
            IsTablet = true
        else
            IsMobile = false
            IsTablet = false
        end
    end
    CheckDevice()
    if IsMobile then
        Menu.Size = UDim2.fromOffset(350, 350)
    end

    local function deepCopy(original)
        local copy = {}
        for key, value in pairs(original) do
            if type(value) == "table" then
                copy[key] = deepCopy(value)
            else
                copy[key] = value
            end
        end
        return copy
    end

    local function UpdateShortcuts()
        local ShortcutsData = Shortcut.Saving:Get("Shortcuts")
        for id, action in pairs(ShortcutsData) do
            local itemInfo = CustomShortcuts:GetSpecificShortcut(action)
            local actionButton = ActionsContainer:FindFirstChild(id)
            local actionImage = ActionsIcon:FindFirstChild(id)
            if actionButton and actionImage and itemInfo then
                actionButton:SetAttribute("Action", itemInfo.Name)
                if itemInfo.Category == "CustomCommands" then
                    actionImage.Image = "rbxassetid://11432834409"
                    if actionImage:FindFirstChild("UtilitiesCustomCommand") then
                        actionImage.UtilitiesCustomCommand.Image = itemInfo.Icon
                        actionImage.UtilitiesCustomCommand.Visible = true
                    end
                else
                    if actionImage:FindFirstChild("UtilitiesCustomCommand") then
                        actionImage.UtilitiesCustomCommand.Visible = false
                    end
                    actionImage.Image = itemInfo.Icon
                end
            end
        end
    end
    Shortcut.UpdateShortcuts = UpdateShortcuts

    local OpenFunction, CloseFunction, MenuVisible = nil, nil, false
    local lastHovered = nil
    local currentTween = nil
    local currentColorTween = nil
    local selectedAction = nil
    local AllowPositionChange = true

    local function GetActionButtons()
        local buttons = {}
        for _, child in pairs(ActionsContainer:GetChildren()) do
            if child:IsA("TextButton") and child:GetAttribute("Rotation") ~= nil then
                table.insert(buttons, child)
            end
        end
        table.sort(buttons, function(a, b)
            return (a:GetAttribute("Rotation") or 0) < (b:GetAttribute("Rotation") or 0)
        end)
        return buttons
    end

    local function GetMouseAngle()
        local center = ActionsContainer.AbsolutePosition + (ActionsContainer.AbsoluteSize / 2)
        local mousePos = UserInputService:GetMouseLocation() - GuiService:GetGuiInset()
        local delta = mousePos - center
        if delta.Magnitude < 40 then return nil, nil end
        local angle = math.deg(math.atan2(delta.Y, delta.X)) + 90
        angle = (angle % 360 + 360) % 360
        return angle, delta.Magnitude
    end

    local function GetHoveredAction()
        local angle, magnitude = GetMouseAngle()
        if not angle then return nil end
        local buttons = GetActionButtons()
        if #buttons == 0 then return nil end
        local closest = nil
        local closestDelta = math.huge
        for _, button in pairs(buttons) do
            local buttonAngle = button:GetAttribute("Rotation") or 0
            buttonAngle = (buttonAngle % 360 + 360) % 360
            local diff = math.abs(((angle - buttonAngle + 180) % 360) - 180)
            if diff < closestDelta then
                closestDelta = diff
                closest = button
            end
        end
        return closest
    end

    local function TweenToAction(action, forced)
        if not action then
            if lastHovered then
                local lastUCC = ActionsIcon:FindFirstChild(lastHovered.Name)
                if lastUCC and lastUCC:FindFirstChild("UtilitiesCustomCommand") then
                    if currentColorTween then currentColorTween:Cancel() end
                    currentColorTween = TweenService:Create(lastUCC.UtilitiesCustomCommand, info, {
                        BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                    })
                    currentColorTween:Play()
                end
            end
            lastHovered = nil
            return
        end

        if action == lastHovered and not forced then return end

        if lastHovered and lastHovered ~= action then
            local lastUCC = ActionsIcon:FindFirstChild(lastHovered.Name)
            if lastUCC and lastUCC:FindFirstChild("UtilitiesCustomCommand") then
                if currentColorTween then currentColorTween:Cancel() end
                TweenService:Create(lastUCC.UtilitiesCustomCommand, info, {
                    BackgroundColor3 = Color3.fromRGB(18, 18, 18)
                }):Play()
            end
        end

        lastHovered = action
        local UCC = ActionsIcon:FindFirstChild(action.Name)

        task.spawn(function()
            local targetRotation = action:GetAttribute("Rotation") or 0
            local currentRotation = ActionSelection.Rotation
            local delta = ((targetRotation - currentRotation) % 360)
            if delta > 180 then delta = delta - 360 end

            if currentTween then currentTween:Cancel() end
            currentTween = TweenService:Create(ActionSelection, info, {
                Rotation = currentRotation + delta
            })
            currentTween:Play()

            if UCC and UCC:FindFirstChild("UtilitiesCustomCommand") and UCC.UtilitiesCustomCommand.Visible then
                if currentColorTween then currentColorTween:Cancel() end
                currentColorTween = TweenService:Create(UCC.UtilitiesCustomCommand, info, {
                    BackgroundColor3 = Color3.fromRGB(10, 10, 10)
                })
                currentColorTween:Play()
            end
        end)
    end

    local function OnWheelClosed()
        selectedAction = nil
        lastHovered = nil
    end

    local lastOpenTime = 0
    local OPEN_COOLDOWN = 0.15

    local function OpenInterface()
        local MouseLocked = Shortcut.Saving:Get("Settings") and Shortcut.Saving:Get("Settings").MouseLocked
        if MouseLocked then
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
        end
        main.Position = UDim2.new(0.5, 0, 0.5, 0)
        if IsMobile then
            main.Size = UDim2.new(0, 250, 0, 250)
        else
            main.Size = UDim2.new(0, 350, 0, 350)
        end
        MenuVisible = true
        UpdateShortcuts()

        if IsMobileOrTablet then
            lastOpenTime = os.clock()
        end

        Menu.Visible = true
        task.spawn(function()
            if AllowPositionChange then
                TweenService:Create(main, info, { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
            end
            main.Interactable = true
            TweenService:Create(main, info, { GroupTransparency = 0 }):Play()
            TweenService:Create(main, info, {
                Size = IsMobile and UDim2.new(0, 350, 0, 350) or UDim2.new(0, 450, 0, 450)
            }):Play()
            OnWheelClosed()
            task.wait(0.02)
            if MouseLocked then
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end
        end)
    end

    local function CloseInterface()
        MenuVisible = false
        task.spawn(function()
            main.Interactable = false
            TweenService:Create(main, info, { GroupTransparency = 1 }):Play()
            if IsMobile then
                TweenService:Create(main, info, { Size = UDim2.new(0, 250, 0, 250) }):Play()
            else
                TweenService:Create(main, info, { Size = UDim2.new(0, 350, 0, 350) }):Play()
            end
            if AllowPositionChange then
                TweenService:Create(main, info, { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
            end
            task.wait(0.6)
            if not MenuVisible then
                Menu.Visible = false
            end
        end)
    end

    OpenFunction = OpenInterface
    CloseFunction = CloseInterface
    Shortcut.Open = OpenInterface
    Shortcut.Close = CloseInterface
    Shortcut.Toggle = function()
        if MenuVisible then CloseInterface() else OpenInterface() end
    end

    -- Parameter Selection Window
    function Shortcut.ShortcutsParameter(state)
        if not state then return nil end
        local canceled, selected, clicked, selectedasset = false, nil, false, nil
        local _, ShortcutsList = CustomShortcuts:GetRegisteredShortcuts()
        local templateUi = Modals:FindFirstChild("<< ShortcutParameter >>")
        if not templateUi then return nil end

        local windowInstance = WindowControl.new(templateUi, Modals, {
            MinSize = Vector2.new(480, 450),
            MaxSize = Vector2.new(500, 600),
        })
        local ui = windowInstance.UI
        ui.Name = "ParameterShortcutSession"

        task.spawn(function()
            if CloseFunction and MenuVisible then CloseFunction() end
            local startSize = Vector2.new(clampAxis("X", 250, 500), clampAxis("Y", 300, 600)) * 0.6
            local targetSize = Vector2.new(clampAxis("X", 250, 500), clampAxis("Y", 350, 600))

            ui.Size = UDim2.new(0, math.min(startSize.X, 500), 0, startSize.Y)
            ui.Position = UDim2.new(0.5, 0, 0.5, 0)
            ui.Visible = true
            ui.Interactable = false

            ui.frame.content.Visible = true
            ui.frame.fade.Visible = true
            ui.frame.WindowControl.Visible = true
            ui.frame.content.GroupTransparency = 1
            ui.ImageTransparency = 0

            TweenService:Create(ui.frame, info, { ImageTransparency = 0 }):Play()
            TweenService:Create(ui, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {
                Size = UDim2.new(0, targetSize.X, 0, targetSize.Y)
            }):Play()
            ui.Interactable = true
        end)

        -- Populate shortcut items
        task.spawn(function()
            for _, i in pairs(ui.frame.content.scroll:GetChildren()) do
                if i:HasTag("ShortcutsParameterAsset") then i:Destroy() end
            end
            for _, i in pairs(ShortcutsList) do
                if i.IsShortcutService then continue end
                local cs = ui.frame.content.scroll.list.template:Clone()
                table.insert(windowInstance.Connections, cs.MouseButton1Click:Connect(function()
                    if selectedasset ~= cs then
                        if selectedasset and selectedasset:FindFirstChild("util") and selectedasset.util:FindFirstChild("Glow") then
                            TweenService:Create(selectedasset.util.Glow.Texture.Glow, info, { Position = UDim2.new(6, 0, 0.5, 0) }):Play()
                        end
                        selected = i.Name
                        selectedasset = cs
                        if cs:FindFirstChild("util") and cs.util:FindFirstChild("Glow") then
                            TweenService:Create(cs.util.Glow.Texture.Glow, info, { Position = UDim2.new(3, 0, 0.5, 0) }):Play()
                        end
                    end
                end))

                local tag = ""
                if i.Category == "CustomCommands" then
                    tag = " [Custom Commands]"
                elseif i.Category and i.Category ~= "SpaceUI" and i.Category ~= "SHORTCUTSERVICE-UNAVAILABLECATEGORY" then
                    tag = " [" .. tostring(i.Category) .. "]"
                end

                cs.content.value.Text = tostring(i.Alias or i.Name) .. tag
                cs.content.emblem.icon.Image = i.Icon or CustomShortcuts.Icons.NoIcon
                cs.Parent = ui.frame.content.scroll
                cs.Name = "ShortcutsParameterAsset"
                cs.Visible = true
                cs:AddTag("Category-" .. tostring(i.Category or "Uncategorized"))
                cs:AddTag("ShortcutsParameterAsset")
            end

            -- Live search filtering
            local searchBox = ui.frame.content.bottom.Search.Field.textbox
            searchBox:GetPropertyChangedSignal("Text"):Connect(function()
                local filter = string.lower(searchBox.Text)
                for _, asset in pairs(ui.frame.content.scroll:GetChildren()) do
                    if asset:HasTag("ShortcutsParameterAsset") then
                        local itemText = string.lower(asset.content.value.Text)
                        if filter == "" or string.find(itemText, filter, 1, true) then
                            asset.Visible = true
                        else
                            asset.Visible = false
                        end
                    end
                end
            end)

            TweenService:Create(ui.frame.loading, info, { TextTransparency = 1 }):Play()
            TweenService:Create(ui.frame.content, info, { GroupTransparency = 0 }):Play()
        end)

        table.insert(windowInstance.Connections, ui.frame.WindowControl.Top.Close.ButtonHitbox.MouseButton1Click:Connect(function()
            canceled = true
        end))

        table.insert(windowInstance.Connections, ui.frame.content.bottom.Select.Button.MouseButton1Click:Connect(function()
            if not selected then return end
            clicked = true
        end))

        -- Category drawer popup
        local categoryvisible = false
        table.insert(windowInstance.Connections, ui.frame.WindowControl.Top.Category.ButtonHitbox.MouseButton1Click:Connect(function()
            if not categoryvisible then
                categoryvisible = true
                for _, i in pairs(ui.frame.Category.content.Category.container:GetChildren()) do
                    if i:HasTag("ShortcutsParameterAsset") then i:Destroy() end
                end

                local categories = { "All Shortcuts" }
                for _, cat in ipairs(CustomShortcuts.GetCategories()) do
                    table.insert(categories, cat)
                end

                for _, cat in ipairs(categories) do
                    local displayName = cat == "SHORTCUTSERVICE-UNAVAILABLECATEGORY" and "Uncategorized" or cat
                    local tagName = cat == "SHORTCUTSERVICE-UNAVAILABLECATEGORY" and "Uncategorized" or cat
                    local btn = ui.frame.Category.content.Category.container.UIListLayout.template:Clone()
                    btn.value.Text = displayName
                    btn.Name = "ShortcutsParameterAsset"
                    btn:AddTag("ShortcutsParameterAsset")
                    btn.Parent = ui.frame.Category.content.Category.container
                    btn.Visible = true

                    table.insert(windowInstance.Connections, btn.MouseButton1Click:Connect(function()
                        for _, asset in pairs(ui.frame.content.scroll:GetChildren()) do
                            if asset:HasTag("ShortcutsParameterAsset") then
                                if cat == "All Shortcuts" then
                                    asset.Visible = true
                                else
                                    asset.Visible = asset:HasTag("Category-" .. tagName)
                                end
                            end
                        end
                        categoryvisible = false
                        TweenService:Create(ui.frame.Category.content, info, {
                            Position = UDim2.new(0.5, 0, 1, 0)
                        }):Play()
                    end))
                end

                TweenService:Create(ui.frame.Category.content, info, {
                    Position = UDim2.new(0.5, 0, 0, 0)
                }):Play()
            else
                categoryvisible = false
                TweenService:Create(ui.frame.Category.content, info, {
                    Position = UDim2.new(0.5, 0, 1, 0)
                }):Play()
            end
        end))

        repeat
            RunService.RenderStepped:Wait()
        until canceled or (selected and clicked)

        task.spawn(function()
            if OpenFunction and not MenuVisible then OpenFunction() end
            ui.Interactable = false
            local closeSize = Vector2.new(ui.AbsoluteSize.X, ui.AbsoluteSize.Y) * 0.6
            ui.frame.content.Visible = false
            ui.frame.fade.Visible = false
            ui.frame.WindowControl.Visible = false
            ui.frame.Category.Visible = false

            TweenService:Create(ui, info, {
                Size = UDim2.new(0, closeSize.X, 0, closeSize.Y),
                ImageTransparency = 1,
            }):Play()
            TweenService:Create(ui.frame, info, { ImageTransparency = 1 }):Play()
            task.wait(0.3)
            windowInstance:Destroy()
        end)

        if canceled then return nil end
        if selected then return selected end
    end

    -- Action execution helper
    local function OnActionSelected(action)
        if not action or not MenuVisible then return end
        if IsMobileOrTablet and (os.clock() - lastOpenTime < OPEN_COOLDOWN) then return end

        selectedAction = action
        TweenToAction(action, true)
        local ActionName = action:GetAttribute("Action")
        local IsRegistered, RegisteredList = CustomShortcuts:GetRegisteredShortcuts()
        if IsRegistered[ActionName] then
            for _, arg in pairs(RegisteredList) do
                if arg.Name == ActionName then
                    for _, callback in pairs(arg.Callbacks) do
                        task.spawn(callback)
                    end
                end
            end
        end
        CloseInterface()
    end

    -- Radial Wheel Button Events & Context Actions
    ActionsContainer.Close.MouseButton1Click:Connect(function()
        CloseInterface()
        OnWheelClosed()
    end)

    local function OpenSettingsModal()
        CloseInterface()
        AllowPositionChange = false
        Menu.Position = UDim2.new(999, 0, 999, 0)
        OnWheelClosed()
        SettingsUI.Visible = true
        SettingsUI.Interactable = true
        SettingsUI.Size = UDim2.fromOffset(200, 112)
        if SettingsUI:FindFirstChild("WindowControl") then
            SettingsUI.WindowControl.Visible = true
        end
        if SettingsUI:FindFirstChild("Configuration") then
            SettingsUI.Configuration.Visible = true
            local container = SettingsUI.Configuration:FindFirstChild("Container")
            if container then
                container.Visible = true
                for _, row in pairs(container:GetChildren()) do
                    if row:IsA("ImageButton") or row:IsA("Frame") then
                        row.Visible = true
                    end
                end
            end
        end
        TweenService:Create(SettingsUI, info, { BackgroundTransparency = 0 }):Play()
        TweenService:Create(SettingsUI, info, { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()
        TweenService:Create(SettingsUI, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {
            Size = UDim2.fromOffset(400, 225)
        }):Play()
    end

    ActionsContainer.Close.MouseButton2Click:Connect(OpenSettingsModal)
    ActionsContainer.Close.TouchLongPress:Connect(OpenSettingsModal)
    do
        local closePressTime = 0
        local closePressTimer = nil
        ActionsContainer.Close.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                closePressTime = tick()
                if closePressTimer then task.cancel(closePressTimer) end
                closePressTimer = task.delay(0.45, function()
                    if tick() - closePressTime >= 0.4 then
                        OpenSettingsModal()
                    end
                end)
            end
        end)
        ActionsContainer.Close.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                if closePressTimer then
                    task.cancel(closePressTimer)
                    closePressTimer = nil
                end
            end
        end)
    end

    if SettingsUI:FindFirstChild("WindowControl") and SettingsUI.WindowControl:FindFirstChild("Top") and SettingsUI.WindowControl.Top:FindFirstChild("Close") then
        SettingsUI.WindowControl.Top.Close.ButtonHitbox.MouseButton1Click:Connect(function()
            SettingsUI.Interactable = false
            SettingsUI.WindowControl.Visible = false
            SettingsUI.Configuration.Visible = false
            TweenService:Create(SettingsUI, info, { BackgroundTransparency = 1 }):Play()
            TweenService:Create(SettingsUI, info, { Size = UDim2.fromOffset(200, 112) }):Play()
            CloseInterface()
            Menu.Position = UDim2.new(0.5, 0, 0.5, 0)
            AllowPositionChange = true
        end)
    end

    local isLongPressActive = false

    for _, button in pairs(GetActionButtons()) do
        local function TriggerSlotContextMenu()
            isLongPressActive = true
            local option = Prompts.PromptOptions({
                Inputs = {
                    { Text = "Execute Action", Icon = "rbxassetid://11326879610" },
                    { Text = "Replace Action", Icon = "rbxassetid://11326879610" },
                }
            })
            if option == "Replace Action" then
                local newAction = Shortcut.ShortcutsParameter(true)
                if newAction then
                    if newAction == "Unlink Action" then newAction = "Unlinked(ShortcutService)" end
                    local deepcopied = deepCopy(Shortcut.Saving:Get("Shortcuts"))
                    deepcopied[button.Name] = newAction
                    Shortcut.Saving.Update("Shortcuts", deepcopied)
                    UpdateShortcuts()
                    if Assets.Notifications then
                        Assets.Notifications.Send({
                            Description = newAction ~= "Unlinked(ShortcutService)" and ("Replaced shortcut with " .. newAction) or "Unlinked shortcut slot",
                            Duration = 2.5
                        })
                    end
                end
            elseif option == "Execute Action" then
                OnActionSelected(button)
            else
                isLongPressActive = false
            end
        end

        button.MouseButton2Click:Connect(TriggerSlotContextMenu)
        button.TouchLongPress:Connect(TriggerSlotContextMenu)

        button.MouseButton1Click:Connect(function()
            if isLongPressActive then return end
            OnActionSelected(button)
        end)
    end

    if not IsMobileOrTablet then
        RunService.RenderStepped:Connect(function()
            if not MenuVisible or not ActionsContainer.Visible then
                lastHovered = nil
                selectedAction = nil
                return
            end
            if selectedAction then return end
            local hovered = GetHoveredAction()
            TweenToAction(hovered)
        end)

        UserInputService.InputEnded:Connect(function(input, gameProcessed)
            if gameProcessed or not MenuVisible then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                local hovered = GetHoveredAction()
                if hovered then
                    OnActionSelected(hovered or lastHovered)
                end
            end
        end)
    else
        RunService.RenderStepped:Connect(function()
            if not MenuVisible or not ActionsContainer.Visible then
                lastHovered = nil
                selectedAction = nil
                return
            end
            if selectedAction then return end
            local hovered = GetHoveredAction()
            TweenToAction(hovered)
        end)

        UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
            if gameProcessed or not MenuVisible then return end
            if isLongPressActive then
                task.delay(0.1, function()
                    isLongPressActive = false
                end)
                return
            end
            local hovered = GetHoveredAction()
            if hovered then
                OnActionSelected(hovered)
            end
        end)
    end
    -- Settings Configuration UI Handlers
    local function SetupConfiguration()
        local settingsData = Shortcut.Saving:Get("Settings")
        local container = SettingsUI.Configuration.Container

        container.Theme.MouseButton1Click:Connect(function()
            if Assets.Notifications then
                Assets.Notifications.Send({
                    Description = "Theme customization will be available in later builds.",
                    Duration = 3
                })
            end
        end)

        container.AutomaticallyLockMouse.MouseButton1Click:Connect(function()
            local cur = container.AutomaticallyLockMouse.Value.Text == "Yes"
            local nxt = not cur
            container.AutomaticallyLockMouse.Value.Text = nxt and "Yes" or "No"
            local deepcopied = deepCopy(Shortcut.Saving:Get("Settings"))
            deepcopied.MouseLocked = nxt
            Shortcut.Saving.Update("Settings", deepcopied)
        end)

        container.Keybind.MouseButton1Click:Connect(function()
            container.Keybind.Value.Text = "..."
            local conn
            conn = UserInputService.InputBegan:Connect(function(input, gp)
                if input.KeyCode and input.KeyCode ~= Enum.KeyCode.Unknown then
                    conn:Disconnect()
                    container.Keybind.Value.Text = input.KeyCode.Name
                    local deepcopied = deepCopy(Shortcut.Saving:Get("Settings"))
                    deepcopied.Keycode = input.KeyCode.Name
                    Shortcut.Saving.Update("Settings", deepcopied)
                end
            end)
        end)

        container.TopbarEnabled.MouseButton1Click:Connect(function()
            local cur = container.TopbarEnabled.Value.Text == "Yes"
            local nxt = not cur
            container.TopbarEnabled.Value.Text = nxt and "Yes" or "No"
            if Shortcut.TopbarIcon then
                Shortcut.TopbarIcon:setEnabled(nxt)
            end
            local deepcopied = deepCopy(Shortcut.Saving:Get("Settings"))
            deepcopied.TopbarEnabled = nxt
            Shortcut.Saving.Update("Settings", deepcopied)
        end)
    end
    SetupConfiguration()

    -- Keyboard Keycode Trigger
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp or UserInputService:GetFocusedTextBox() then return end
        local settingsData = Shortcut.Saving:Get("Settings")
        local keyName = settingsData and settingsData.Keycode or "F4"
        local targetKey = Enum.KeyCode[keyName]
        if targetKey and inp.KeyCode == targetKey then
            if MenuVisible then
                CloseInterface()
            else
                OpenInterface()
            end
        end
    end)

    -- TopbarPlus Icon Setup
    local function SetupShortcutTopbar()
        local IconLib = LoadTopbarPlus()
        if not IconLib then return end
        local enabledState = Shortcut.Saving:Get("Settings") and Shortcut.Saving:Get("Settings").TopbarEnabled
        if enabledState == nil then enabledState = true end

        local topbarOk, topbarErr = pcall(function()
            local scIcon = IconLib.new()
                :setLabel("Shortcuts")
                :setCaption("Open Shortcuts Menu")
                :oneClick(true)
                :align("Left")
                :setEnabled(enabledState)
            scIcon.selected:Connect(function()
                if MenuVisible then CloseInterface() else OpenInterface() end
            end)
            Shortcut.TopbarIcon = scIcon
        end)
        if not topbarOk then
            warn("[SpaceUI/Shortcut] Failed to create topbar icon:", topbarErr)
        end
    end
    task.spawn(SetupShortcutTopbar)

    -- Chat Command Trigger (!Shortcuts)
    pcall(function()
        if TextChatService and TextChatService.OnIncomingMessage then
            local oldCallback = TextChatService.OnIncomingMessage
            TextChatService.OnIncomingMessage = function(message)
                if oldCallback then pcall(oldCallback, message) end
                if message.TextSource and message.TextSource.UserId == LocalPlayer.UserId then
                    if message.Text == "!Shortcuts" or message.Text == "!shortcuts" then
                        Shortcut.Toggle()
                    end
                end
            end
        end
    end)
    LocalPlayer.Chatted:Connect(function(msg)
        if msg == "!Shortcuts" or msg == "!shortcuts" then
            Shortcut.Toggle()
        end
    end)

    -- Register default built-in shortcuts
    CustomShortcuts:RegisterShortcut("Unlink Action", {
        Callback = function() end,
        Category = "ShortcutService",
        Alias = "Unlink Action",
        Icon = "rbxassetid://11963369532"
    })
    CustomShortcuts:RegisterShortcut("Toggle SpaceUI", {
        Callback = function()
            if Assets.Main and Assets.Main.ToggleVisibility then
                local curVis = SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame and SpaceUI.Background.Objects.MainFrame.Visible
                Assets.Main.ToggleVisibility(not curVis)
            end
        end,
        Category = "SpaceUI",
        Alias = "Toggle SpaceUI",
        Icon = "rbxassetid://11295288868"
    })
    CustomShortcuts:RegisterShortcut("Dashboard", {
        Callback = function()
            if SpaceUI.Dashboard and SpaceUI.Dashboard.Toggle then
                SpaceUI.Dashboard.Toggle()
            end
        end,
        Category = "SpaceUI",
        Alias = "Dashboard",
        Icon = "rbxassetid://11293977610"
    })
    CustomShortcuts:RegisterShortcut("Toggle ArrayList", {
        Callback = function()
            if Assets.ArrayList and Assets.ArrayList.Toggle then
                Assets.ArrayList.Toggle()
            end
        end,
        Category = "SpaceUI",
        Alias = "Toggle ArrayList",
        Icon = "rbxassetid://102351199755031"
    })
    CustomShortcuts:RegisterShortcut("Close All Tabs", {
        Callback = function()
            if SpaceUI.Tabs and SpaceUI.Tabs.Functions and SpaceUI.Tabs.Functions.CloseAllTabs then
                SpaceUI.Tabs.Functions.CloseAllTabs()
            end
        end,
        Category = "SpaceUI",
        Alias = "Close All Tabs",
        Icon = "rbxassetid://11293981586"
    })

    UpdateShortcuts()
    print("[SpaceUI Shortcuts]: Radial Menu Engine and Handlers Loaded Successfully.")
end

-- Helper for Mobile auto-bind to shortcut
function Shortcut.BindModuleToNextSlot(moduleName, aliasName, iconAsset, categoryName, toggleCallback)
    CustomShortcuts:RegisterShortcut(moduleName, {
        Name = moduleName,
        Alias = aliasName or moduleName,
        Icon = iconAsset or "rbxassetid://11295288868",
        Category = categoryName or "SpaceUI",
        Callback = toggleCallback
    })
    
    local shortcutsData = Shortcut.Saving:Get("Shortcuts")
    -- Find first unlinked slot or slot 1
    local targetSlot = nil
    for i = 1, 8 do
        local slotKey = "Action-" .. i
        if not shortcutsData[slotKey] or shortcutsData[slotKey] == "Unlinked" or shortcutsData[slotKey] == "Unlinked(ShortcutService)" then
            targetSlot = slotKey
            break
        end
    end
    if not targetSlot then
        targetSlot = "Action-1"
    end
    
    local deepcopied = {}
    for k, v in pairs(shortcutsData) do deepcopied[k] = v end
    deepcopied[targetSlot] = moduleName
    Shortcut.Saving.Update("Shortcuts", deepcopied)
    if Shortcut.UpdateShortcuts then
        Shortcut.UpdateShortcuts()
    end
    return targetSlot
end

function Shortcut.UnbindModuleFromSlots(moduleName)
    local shortcutsData = Shortcut.Saving:Get("Shortcuts")
    local deepcopied = {}
    local changed = false
    for k, v in pairs(shortcutsData) do
        if v == moduleName then
            deepcopied[k] = "Unlinked(ShortcutService)"
            changed = true
        else
            deepcopied[k] = v
        end
    end
    if changed then
        Shortcut.Saving.Update("Shortcuts", deepcopied)
        if Shortcut.UpdateShortcuts then
            Shortcut.UpdateShortcuts()
        end
    end
end

-- Initialize Hub global if not already set (phải chạy TRƯỚC khi gán SpaceUI.Shortcut,
-- nếu không getgenv().SpaceUI vẫn là nil -> "attempt to index nil with 'Shortcut'")
if not getgenv().SpaceUI then
    getgenv().SpaceUI = {
        Notifications = { Active = {}, Objects = {} },
        Connections = {},
        Corners = {},
        Config = {
            UI = {
                Position = {X = 0.5, Y = 0.5},
                Size = {X = 0.373, Y = 0.683},
                FullScreen = false,
                ToggleKeyCode = "LeftAlt",
                Scale = 1,
                Notifications = true,
                Anim = true,
                ArrayList = false,
                TabColor = {value1 = 40, value2 = 40, value3 = 40},
                TabTransparency = 0.07,
                KeybindTransparency = 0.7,
                KeybindColor = {value1 = 0, value2 = 0, value3 = 0},
                UseAccessibilityButton = true, -- Mặc định dùng Accessibility Button; set false để dùng lại TopbarPlus (API cũ)
            },
            Game = {
                Modules = {},
                Keybinds = {},
                Sliders = {},
                TextBoxes = {},
                MiniToggles = {},
                Dropdowns = {},
                ToggleLists = {},
                ModuleKeybinds = {},
                Other = {}
            }
        },
        Mobile = (game:GetService("UserInputService").TouchEnabled and not game:GetService("UserInputService").MouseEnabled),
        Pages = {},
        Tabs = { Tabs = {}, TabBackground = nil, FocusedTab = nil, ActiveTabs = {} },
        ArrayList = { Objects = {}, Loaded = false },
        Background = nil,
        Pageselector = nil,
        Dashboard = nil,
        CurrentOpenTab = {},
        ControlsVisible = false,
        IsAllowedToHoverTabButton = false,
        CurrntInputChangeCallback = function() end,
        InputEndFunc = nil,
        GameSave = "GameSave",
        Dev = false,
    }

    -- Auto-scale theo mobile: ported từ Loader.lua gốc (Night). Khi thiết bị là
    -- mobile, đổi Size mặc định của dashboard cho vừa màn hình dọc, và tính Scale
    -- theo ViewportSize.X thực tế thay vì luôn dùng Scale = 1 cố định (nguyên nhân
    -- UI hiện to/lệch trên mobile giống hệt PC).
    if getgenv().SpaceUI.Mobile then
        getgenv().SpaceUI.Config.UI.Size = {X = 0.7, Y = 0.9}

        local AutoScaleCamera = workspace.CurrentCamera
        if AutoScaleCamera then
            local vpX = AutoScaleCamera.ViewportSize.X
            if 0.4 >= (vpX / 1000) - 0.1 then
                getgenv().SpaceUI.Config.UI.Scale = 0.4
            else
                getgenv().SpaceUI.Config.UI.Scale = (vpX / 1000) - 0.1
            end
        end
    end
end
-- Gán vào biến SpaceUI đã forward-declare ở đầu file (không dùng `local` lại ở đây,
-- nếu không sẽ tạo 1 local mới che khuất upvalue mà các hàm phía trên đã capture).
SpaceUI = getgenv().SpaceUI

-- Export global table (chạy SAU khi getgenv().SpaceUI đã chắc chắn tồn tại)
getgenv().SpaceUI.Shortcut = Shortcut

do
    SpaceUI.Tabs.ActiveTabs = SpaceUI.Tabs.ActiveTabs or {}

    local _FocusTweenService = game:GetService("TweenService")

    local tabFocusTweens = setmetatable({}, {__mode = "k"})
    local function playFocusTween(tab, imageTransparency, shadowTransparency)
        if tabFocusTweens[tab] then
            for _, t in tabFocusTweens[tab] do
                t:Cancel()
            end
        end
        local info = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local t1 = _FocusTweenService:Create(tab.Objects.ActualTab, info, {ImageTransparency = imageTransparency})
        local t2 = _FocusTweenService:Create(tab.Objects.TabFocusShadow, info, {ImageTransparency = shadowTransparency})
        tabFocusTweens[tab] = {t1, t2}
        t1:Play()
        t2:Play()
    end

    function SpaceUI.Tabs.CaptureFocus(tab)
        if not tab or not tab.Objects or not tab.Objects.ActualTab then return end
        if SpaceUI.Tabs.FocusedTab == tab then return end

        SpaceUI.Tabs.FocusedTab = tab
        tab.Objects.ActualTab.ZIndex = 2
        -- Tab được focus: đục đúng theo config gốc (không solid). Shadow LUÔN giữ
        -- ẩn (1, không phải 0.1 như trước) - hiệu ứng shadow khi focus không hợp
        -- thẩm mỹ theo yêu cầu, bỏ hẳn dù logic ZIndex/ImageTransparency chính vẫn
        -- giữ nguyên.
        playFocusTween(tab, SpaceUI.Config.UI.TabTransparency, 1)

        for i, v in SpaceUI.Tabs.ActiveTabs do
            if v ~= tab then
                SpaceUI.Tabs.RemoveFocus(v)
            end
        end
    end

    function SpaceUI.Tabs.RemoveFocus(tab, skipTween)
        if not tab or not tab.Objects or not tab.Objects.ActualTab then return end
        if SpaceUI.Tabs.FocusedTab == tab then
            SpaceUI.Tabs.FocusedTab = nil
        end
        tab.Objects.ActualTab.ZIndex = 1

        -- Auto-skip tween khi tab đang đóng hoặc đã đóng: close animation
        -- đang tween ImageTransparency → 1, nếu ta tween → 0 ở đây sẽ
        -- tạo 2 tween chạy song song trên cùng property theo hướng ngược
        -- nhau, khiến tab khựng/flash ở cuối animation đóng.
        if not skipTween and tab.Opened == false then
            skipTween = true
        end

        if skipTween then
            if tabFocusTweens[tab] then
                for _, t in tabFocusTweens[tab] do
                    t:Cancel()
                end
                tabFocusTweens[tab] = nil
            end
            tab.Objects.TabFocusShadow.ImageTransparency = 1
        else
            -- Tab mất focus: solid hoàn toàn (hết xuyên thấu), shadow tắt hẳn.
            playFocusTween(tab, 0, 1)
        end
    end

    function SpaceUI.Tabs.ActivateTab(tab)
        if table.find(SpaceUI.Tabs.ActiveTabs, tab) then return end
        table.insert(SpaceUI.Tabs.ActiveTabs, tab)
    end

    function SpaceUI.Tabs.DeactivateTab(tab)
        local pos = table.find(SpaceUI.Tabs.ActiveTabs, tab)
        if not pos then return end
        if SpaceUI.Tabs.FocusedTab == tab then
            SpaceUI.Tabs.RemoveFocus(tab)
        end
        table.remove(SpaceUI.Tabs.ActiveTabs, pos)
    end
end

do
    SpaceUI.Peek = {
        Active = false,
        Cards = {},         -- {Tab, IsDashboard, Frame, Scale, HitCatcher, BaseOffsetX, OriginalPosition, OriginalSize, OriginalZIndex, OriginalAnchorPoint, SavedDescendantZIndex}
        Overlay = nil,       -- input-catcher trong suốt phía sau (bấm ra ngoài = thoát, kéo ngang = cuộn)
        Blur = nil,          -- BlurEffect làm mờ nét nền 3D
        ScrollX = 0,         -- độ lệch cuộn ngang hiện tại (pixel viewport thật, luôn <= 0), dùng khi > CARDS_PER_PAGE card
        PosScaleCompensate = 1, -- 1/Config.UI.Scale tại lần Enter() gần nhất - bù Offset trước khi gán Position (xem giải thích ở Enter)
        Connections = {},    -- connection riêng của phiên Peek hiện tại, disconnect sạch khi Exit
    }

    local TweenService = game:GetService("TweenService")

    local peekTweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
    local peekFastInfo = TweenInfo.new(0.3, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)

    -- Ma trận cố định: tối đa 3 cột x 2 hàng = 6 card mỗi "trang". <=6 card thì vừa
    -- khít 1 màn hình (tự chia hàng cân đối). >6 card thì layout 3x2 này kéo dài
    -- thêm cột nhóm tiếp theo sang phải, bọc trong ScrollingFrame cuộn ngang vô hạn
    -- (giống iPad app switcher), không còn giới hạn số tab tối đa nào cả.
    local MAX_COLS = 3
    local MAX_ROWS = 2
    local CARDS_PER_PAGE = MAX_COLS * MAX_ROWS

    -- Với N <= CARDS_PER_PAGE: chia thành số hàng ít nhất cần thiết (tối đa
    -- MAX_COLS mỗi hàng), CÂN ĐỐI các hàng cho đều nhau thay vì lấp đầy hàng đầu
    -- rồi dồn phần lẻ xuống hàng cuối. Vd: 5 -> {3,2}; 4 -> {4} (<=MAX_COLS nên 1
    -- hàng); 7 -> không vào nhánh này (đã > CARDS_PER_PAGE, xử lý ở nhánh scroll).
    local function computeRows(count)
        if count <= MAX_COLS then
            return {count}
        end
        local rowCount = math.ceil(count / MAX_COLS)
        local base = math.floor(count / rowCount)
        local remainder = count % rowCount
        local rows = {}
        for r = 1, rowCount do
            -- Phân đều phần dư vào các hàng ĐẦU để hàng cuối không bị lẻ nhất
            -- (vd 5 -> rowCount=2, base=2, remainder=1 -> {3,2})
            rows[r] = base + (r <= remainder and 1 or 0)
        end
        return rows
    end

    local function collectPeekTargets()
        local targets = {}
        if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame
            and SpaceUI.Background.Objects.MainFrame.Visible then
            table.insert(targets, {Tab = nil, IsDashboard = true, Frame = SpaceUI.Background.Objects.MainFrame})
        end
        if SpaceUI.CurrentOpenTab then
            for _, tab in SpaceUI.CurrentOpenTab do
                if tab and tab.Objects and tab.Objects.ActualTab then
                    table.insert(targets, {Tab = tab, IsDashboard = false, Frame = tab.Objects.ActualTab})
                end
            end
        end
        return targets
    end

    local function ensureOverlay()
        if SpaceUI.Peek.Overlay then return SpaceUI.Peek.Overlay end

        local Lighting = game:GetService("Lighting")
        local blur = Lighting:FindFirstChild("SpaceUIPeekBlur")
        if not blur then
            blur = Instance.new("BlurEffect")
            blur.Name = "SpaceUIPeekBlur"
            blur.Size = 0
            blur.Parent = Lighting
        end

        local overlay = Instance.new("TextButton")
        overlay.Name = "PeekInputCatcher"
        overlay.Text = ""
        overlay.AutoButtonColor = false
        overlay.BackgroundTransparency = 1
        overlay.BorderSizePixel = 0
        overlay.Size = UDim2.fromScale(1, 1)
        overlay.Position = UDim2.fromScale(0, 0)
        overlay.ZIndex = -100
        overlay.Parent = SpaceUI.Background.Objects.MainScreenGui

        SpaceUI.Peek.Overlay = overlay
        SpaceUI.Peek.Blur = blur
        return overlay
    end

    -- HitCatcher nằm TRÊN CÙNG (ZIndex cao hơn hẳn nội dung đã boost), trong suốt
    -- hoàn toàn (BackgroundTransparency = 1) để nhìn xuyên thấy nội dung thật bên
    -- dưới, nhưng chặn TOÀN BỘ input thật của tab (nút, list...) trong lúc peek -
    -- chỉ tồn tại trong lúc peek đang Active, bị Destroy ngay khi Exit. Đồng thời
    -- là nơi bắt drag-scroll ngang: vì nó luôn ở TRÊN CÙNG, input bắt đầu từ bất
    -- kỳ card nào (không chỉ vùng trống) đều phải qua đây trước - overlay phía
    -- sau sẽ không bao giờ nhận được input nếu chỉ gắn ở overlay.
    local PEEK_HITCATCHER_ZINDEX = 5000
    local DRAG_THRESHOLD_PX = 8 -- di chuyển quá ngưỡng này mới coi là kéo (scroll), dưới đó là tap (chọn card)

    local function attachHitCatcher(card)
        local hit = Instance.new("TextButton")
        hit.Name = "PeekHitCatcher"
        hit.Text = ""
        hit.AutoButtonColor = false
        hit.BackgroundTransparency = 1
        hit.Size = UDim2.fromScale(1, 1)
        hit.Position = UDim2.fromScale(0, 0)
        hit.ZIndex = PEEK_HITCATCHER_ZINDEX
        hit.Parent = card.Frame
        card.HitCatcher = hit
        return hit
    end

    -- Nâng ZIndex từng GuiObject con thật lên cao hơn overlay dim (nhưng vẫn thấp
    -- hơn HitCatcher ở trên cùng), để chữ/icon không bị lớp nào khác che khuất.
    local PEEK_CONTENT_ZINDEX_BOOST = 2000

    local function boostDescendantZIndex(root, savedList)
        for _, obj in root:GetDescendants() do
            -- TabFocusShadow là hiệu ứng viền mờ TRANG TRÍ của Leaflet focus system
            -- (ZIndex = -10 cố định, nằm dưới cùng theo thiết kế gốc để tạo shadow mờ
            -- phía sau tab đang focus - xem CaptureFocus/RemoveFocus). Nó không chứa
            -- chữ/nội dung cần đọc nên không cần "nổi lên" trong Peek. Boost ZIndex nó
            -- +2000 làm nó nhảy từ -10 lên ~1990 (rất cao, NỔI HẲN LÊN TRÊN thay vì làm
            -- nền mờ phía dưới) - đây chính là "viền đậm màu dính trong tab" đã gặp.
            -- Loại trừ nó khỏi savedList/boost hoàn toàn: giữ nguyên ZIndex=-10 xuyên
            -- suốt Peek, không cần restore vì chưa từng bị đổi.
            if obj:IsA("GuiObject") and obj.Name ~= "PeekHitCatcher" and obj.Name ~= "TabFocusShadow" then
                table.insert(savedList, {Object = obj, ZIndex = obj.ZIndex})
                obj.ZIndex = obj.ZIndex + PEEK_CONTENT_ZINDEX_BOOST
            end
        end
    end

    local function restoreDescendantZIndex(savedList)
        for _, entry in savedList do
            if entry.Object and entry.Object.Parent then
                entry.Object.ZIndex = entry.ZIndex
            end
        end
        table.clear(savedList)
    end

    -- Gắn (hoặc tái sử dụng) 1 UIScale lên chính frame ngoài cùng của card. Size/
    -- Position THẬT của frame KHÔNG hề bị đổi - chỉ UIScale.Scale thay đổi, giống
    -- hệt cách macOS/iPadOS Stage Manager scale-down window thật chứ không resize.
    -- Trả thêm "wasPreExisting": true nếu frame đã có sẵn UIScale từ trước (vd
    -- TabScale của hệ thống mở/đóng tab, hay MainFrameScale của Dashboard) - Peek
    -- chỉ được MƯỢN tạm UIScale đó, KHÔNG được Destroy khi Exit, vì đó là instance
    -- sống lâu dài mà code animation mở/đóng gốc đang giữ tham chiếu (closure) -
    -- Destroy nó thì animation gốc từ sau vĩnh viễn không còn tác dụng nữa dù
    -- không hề báo lỗi gì (set Scale trên Instance đã bị Destroy là hợp lệ,
    -- chỉ đơn giản là không còn hiển thị vì đã rời khỏi cây UI).
    local function ensureUIScale(frame)
        local scale = frame:FindFirstChildOfClass("UIScale")
        if scale then
            return scale, true
        end
        scale = Instance.new("UIScale")
        scale.Scale = 1
        scale.Parent = frame
        return scale, false
    end

    local DRAG_TWEEN_INFO = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

    local function applyScrollX(instant)
        local tweenInfo = instant and TweenInfo.new(0) or DRAG_TWEEN_INFO
        local compensate = SpaceUI.Peek.PosScaleCompensate or 1
        for _, card in SpaceUI.Peek.Cards do
            if card.BaseOffsetX and card.Frame and card.Frame.Parent then
                local pos = card.Frame.Position
                TweenService:Create(card.Frame, tweenInfo, {
                    Position = UDim2.new(pos.X.Scale, (card.BaseOffsetX + SpaceUI.Peek.ScrollX) * compensate, pos.Y.Scale, pos.Y.Offset),
                }):Play()
            end
        end
    end

    -- Toàn bộ input trong lúc Peek (chọn card / kéo cuộn ngang / bấm ra ngoài để
    -- thoát) xử lý qua 1 state chung duy nhất, lắng nghe UserInputService toàn
    -- cục thay vì event riêng trên từng Instance. Lý do: HitCatcher (ZIndex cao
    -- nhất) luôn nhận input trước overlay phía sau, nên nếu chỉ gắn drag lên
    -- overlay thì kéo bắt đầu từ TRÊN card (không phải vùng trống) sẽ không bao
    -- giờ kích hoạt được - đây đúng là bug đã gặp trước đó.
    local function attachPeekInput(overlay, maxScrollX)
        local pressed = false
        local dragging = false      -- vượt DRAG_THRESHOLD_PX -> true, khóa lại là kéo chứ không phải tap
        local pressStartX = 0
        local scrollStartX = 0

        -- Dò card bằng point-in-rect thủ công theo AbsolutePosition/AbsoluteSize
        -- của HitCatcher, KHÔNG dùng GetGuiObjectsAtPosition nữa. Lý do: hàm đó
        -- phải gọi trên đúng 1 BasePlayerGui (PlayerGui/StarterGui), trong khi UI
        -- của SpaceUI lại nằm dưới Assets.Functions.gethui() (CoreGui hoặc
        -- container ẩn tuỳ executor) - KHÔNG chắc là đúng PlayerGui thật, nên dò
        -- kiểu đó rất dễ không ra kết quả gì, khiến tap trúng card vẫn bị tính
        -- như trúng vùng trống. Point-in-rect thủ công chỉ dựa theo toạ độ hiển
        -- thị thật nên không phụ thuộc UI đang nằm dưới container nào cả. Duyệt
        -- ngược mảng Cards để ưu tiên card có ZIndex cao hơn (thêm sau) nếu lỡ
        -- chồng lấn nhau trong lúc đang tween vị trí.
        local function findCardAtPosition(pos)
            for i = #SpaceUI.Peek.Cards, 1, -1 do
                local card = SpaceUI.Peek.Cards[i]
                local hit = card.HitCatcher
                if hit and hit.Parent then
                    local topLeft = hit.AbsolutePosition
                    local size = hit.AbsoluteSize
                    if pos.X >= topLeft.X and pos.X <= topLeft.X + size.X
                        and pos.Y >= topLeft.Y and pos.Y <= topLeft.Y + size.Y then
                        return card
                    end
                end
            end
            return nil
        end

        local function onInputBegan(input, gameProcessed)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            pressed = true
            dragging = false
            pressStartX = input.Position.X
            scrollStartX = SpaceUI.Peek.ScrollX
        end

        local function onInputChanged(input)
            if not pressed then return end
            if input.UserInputType ~= Enum.UserInputType.MouseMovement
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            local delta = input.Position.X - pressStartX
            if not dragging and math.abs(delta) >= DRAG_THRESHOLD_PX and maxScrollX > 0 then
                dragging = true
            end
            if dragging then
                local newScrollX = math.clamp(scrollStartX + delta, -maxScrollX, 0)
                SpaceUI.Peek.ScrollX = newScrollX
                applyScrollX(true)
            end
        end

        local function onInputEnded(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then
                return
            end
            if not pressed then return end
            local wasDragging = dragging
            pressed = false
            dragging = false
            if wasDragging then
                -- Kết thúc kéo: chỉ dừng cuộn, không chọn card nào cả, dù ngón
                -- tay đang thả ở đúng vị trí 1 card.
                return
            end
            -- Không kéo (di chuyển dưới ngưỡng) => coi là tap thật. Chỉ thoát
            -- Peek khi tap TRÚNG đúng 1 card (tự động focus tab đó luôn). Bấm ra
            -- vùng trống/background KHÔNG còn tắt Peek nữa - muốn tắt Peek mà
            -- không đổi tab thì bấm lại nút/keybind mở Peek (gọi thẳng
            -- SpaceUI.Peek.Toggle(), không đi qua nhánh tap trong hàm này).
            local pos = input.Position
            local card = findCardAtPosition(pos)
            if card then
                SpaceUI.Peek.Exit(card)
            end
        end

        table.insert(SpaceUI.Peek.Connections, UserInputService.InputBegan:Connect(onInputBegan))
        table.insert(SpaceUI.Peek.Connections, UserInputService.InputChanged:Connect(onInputChanged))
        table.insert(SpaceUI.Peek.Connections, UserInputService.InputEnded:Connect(onInputEnded))
    end

    function SpaceUI.Peek.Exit(chosen)
        if not SpaceUI.Peek.Active then return end
        SpaceUI.Peek.Active = false

        for _, conn in SpaceUI.Peek.Connections do
            conn:Disconnect()
        end
        table.clear(SpaceUI.Peek.Connections)
        SpaceUI.Peek.ScrollX = 0

        if SpaceUI.Peek.Blur then
            TweenService:Create(SpaceUI.Peek.Blur, peekFastInfo, {Size = 0}):Play()
        end
        if SpaceUI.Peek.Overlay then
            local ov = SpaceUI.Peek.Overlay
            task.delay(peekFastInfo.Time, function()
                if ov and ov.Parent then ov:Destroy() end
            end)
            SpaceUI.Peek.Overlay = nil
        end

        -- Khôi phục Parent theo ĐÚNG THỨ TỰ ỔN ĐỊNH (Dashboard trước, rồi theo thứ
        -- tự SpaceUI.CurrentOpenTab) thay vì thứ tự ngẫu nhiên của SpaceUI.Peek.Cards
        -- (vốn chỉ theo thứ tự globalIndex lúc dựng lưới Peek, có thể khác thứ tự
        -- gốc), để Children list của TabBackground/MainScreenGui được tái tạo đúng
        -- thứ tự tương đối như trước khi vào Peek.
        local restoreOrder = {}
        if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame then
            for _, card in SpaceUI.Peek.Cards do
                if card.IsDashboard then
                    table.insert(restoreOrder, card)
                end
            end
        end
        if SpaceUI.CurrentOpenTab then
            for _, tab in SpaceUI.CurrentOpenTab do
                for _, card in SpaceUI.Peek.Cards do
                    if card.Tab == tab then
                        table.insert(restoreOrder, card)
                        break
                    end
                end
            end
        end
        -- An toàn: bất kỳ card nào lọt lưới ở trên (không khớp Dashboard/CurrentOpenTab
        -- vì lý do gì đó) vẫn được thêm vào cuối, không bị bỏ sót khỏi vòng lặp restore.
        for _, card in SpaceUI.Peek.Cards do
            local found = false
            for _, c in restoreOrder do
                if c == card then found = true break end
            end
            if not found then
                table.insert(restoreOrder, card)
            end
        end

        -- BƯỚC 1: trả TẤT CẢ frame về đúng Parent/Position/Size/ZIndex GỐC trước -
        -- kể cả card sẽ được chọn (chosen). CaptureFocus/RemoveFocus (BƯỚC 2, xem
        -- dưới) sẽ chạy SAU KHI toàn bộ cây UI đã ổn định lại đúng vị trí ban đầu,
        -- không còn ai đang nằm ở MainScreenGui nữa - đây là điểm mấu chốt: gọi
        -- CaptureFocus TRƯỚC khi trả Parent (như code cũ) khiến ZIndex=2 được set
        -- trong lúc frame còn ở sai cây UI, rồi bị cuốn theo vòng lặp trả Parent
        -- phía sau ghi đè mất hiệu lực.
        for _, card in restoreOrder do
            if card.HitCatcher then
                card.HitCatcher:Destroy()
                card.HitCatcher = nil
            end
            local frame = card.Frame
            if frame and frame.Parent then
                if card.OriginalParent then
                    frame.Parent = card.OriginalParent
                end
                frame.ZIndex = card.OriginalZIndex or frame.ZIndex
                if card.Scale then
                    TweenService:Create(card.Scale, peekTweenInfo, {Scale = 1}):Play()
                end
                frame.AnchorPoint = card.OriginalAnchorPoint or frame.AnchorPoint
                TweenService:Create(frame, peekTweenInfo, {
                    Position = card.OriginalPosition,
                    Size = card.OriginalSize,
                }):Play()
                if card.ScaleOwnedByPeek then
                    task.delay(peekTweenInfo.Time, function()
                        if card.Scale and card.Scale.Parent then
                            card.Scale:Destroy()
                        end
                    end)
                end
            end
        end

        -- BƯỚC 2: CaptureFocus/RemoveFocus chạy SAU CÙNG, khi mọi frame đã ở đúng
        -- Parent/ZIndex gốc ổn định - set lại ZIndex=2 cho card được chọn ĐÚNG LÚC,
        -- không còn ai phía sau ghi đè lại nữa.
        if chosen then
            if chosen.Tab then
                SpaceUI.Tabs.CaptureFocus(chosen.Tab)
                if SpaceUI.Tabs.TabBackground then
                    SpaceUI.Tabs.TabBackground.ZIndex = 2
                end
                if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame then
                    SpaceUI.Background.Objects.MainFrame.ZIndex = 1
                end
            elseif chosen.IsDashboard then
                if SpaceUI.Tabs.FocusedTab then
                    SpaceUI.Tabs.RemoveFocus(SpaceUI.Tabs.FocusedTab)
                end
                if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame then
                    SpaceUI.Background.Objects.MainFrame.ZIndex = 2
                end
                if SpaceUI.Tabs.TabBackground then
                    SpaceUI.Tabs.TabBackground.ZIndex = 1
                end
            end
        end

        table.clear(SpaceUI.Peek.Cards)
    end

    -- Tự sửa các TabFocusShadow đã bị kẹt ZIndex cao từ NHỮNG LẦN PEEK TRƯỚC khi
    -- có fix loại trừ TabFocusShadow khỏi boostDescendantZIndex (xem hàm đó). Nếu
    -- Peek từng chạy trong phiên hiện tại bằng code cũ, restoreDescendantZIndex có
    -- thể không khớp đúng thứ tự khiến ZIndex của nó kẹt vĩnh viễn ở mức cao
    -- (~1990+) thay vì -10 như thiết kế gốc. Quét 1 lần mỗi khi Enter() được gọi,
    -- chỉ sửa những cái đang lệch bất thường (> 100, ngưỡng an toàn - shadow hợp
    -- lệ theo thiết kế gốc luôn là số âm, không đụng tới bất kỳ tab nào đang đúng).
    local function healStuckFocusShadows()
        if not SpaceUI.CurrentOpenTab then return end
        for _, tab in SpaceUI.CurrentOpenTab do
            if tab and tab.Objects and tab.Objects.TabFocusShadow then
                local shadow = tab.Objects.TabFocusShadow
                if shadow.ZIndex > 100 then
                    shadow.ZIndex = -10
                end
            end
        end
        if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame then
            local mainFrame = SpaceUI.Background.Objects.MainFrame
            local shadow = mainFrame:FindFirstChild("TabFocusShadow")
            if shadow and shadow.ZIndex > 100 then
                shadow.ZIndex = -10
            end
        end
    end

    function SpaceUI.Peek.Enter()
        if SpaceUI.Peek.Active then return true end

        local targets = collectPeekTargets()
        if #targets == 0 then return false, "no_open_tabs" end

        healStuckFocusShadows()

        SpaceUI.Peek.Active = true
        SpaceUI.Peek.ScrollX = 0
        table.clear(SpaceUI.Peek.Cards)

        local mainScreenGui = SpaceUI.Background.Objects.MainScreenGui
        -- screenSize = viewport THẬT (mainScreenGui.AbsoluteSize), không chia/nhân gì
        -- với uiScale. scaleFactor (bên dưới, trong vòng lặp dựng UI) được tính từ
        -- designSize - kích thước THIẾT KẾ GỐC của từng frame, suy trực tiếp từ
        -- frame.Size (UDim2) * screenSize, KHÔNG đọc frame.AbsoluteSize. Lý do: mọi
        -- frame ở đây (ActualTab, MainFrame) đều có sẵn 1 UIScale riêng (TabScale,
        -- MainFrameScale - dùng cho animation mở/đóng khác) mà ensureUIScale() sẽ MƯỢN
        -- tạm; AbsoluteSize phụ thuộc chặt vào giá trị hiện tại của UIScale đó TẠI ĐÚNG
        -- THỜI ĐIỂM đọc - có thể đang dở dang animation (1.2 -> 1) nên không ổn định.
        -- frame.Size (đặt bởi code UI, không đổi bởi UIScale) + screenSize (cố định)
        -- loại bỏ hoàn toàn phụ thuộc timing/UIScale này - designSize luôn đúng, và
        -- vì Peek GHI ĐÈ TUYỆT ĐỐI Scale = scaleFactor (không cộng dồn), giá trị Scale
        -- cũ của UIScale mượn được trước đó không còn quan trọng nữa.
        --
        -- Position (Offset pixel cellCenterXPx/cellCenterYPx) thì khác: nó không hề
        -- "chứa sẵn" uiScale như cách AbsoluteSize từng có, nên khi MainScreenGuiScale
        -- nhân thêm uiScale lúc render (sau khi frame re-parent thẳng vào MainScreenGui,
        -- con trực tiếp), kết quả BỊ CO THẬT về góc trên-trái theo đúng tỉ lệ uiScale -
        -- đây là bug "lệch lên trên" khi uiScale < 1 (mobile). Phải bù NGƯỢC 1/uiScale
        -- vào cellCenterXPx/Y trước khi gán Position (xem posScaleCompensate bên dưới)
        -- để MainScreenGuiScale nhân lại đúng 1 lần, ra đúng pixel thật mong muốn -
        -- độc lập hoàn toàn với cách tính scaleFactor ở trên.
        local uiScale = SpaceUI.Config.UI.Scale
        if not uiScale or uiScale <= 0 then uiScale = 1 end
        local posScaleCompensate = 1 / uiScale
        SpaceUI.Peek.PosScaleCompensate = posScaleCompensate
        local screenSize = mainScreenGui.AbsoluteSize

        local overlay = ensureOverlay()

        SpaceUI.Peek.Blur.Size = 0
        TweenService:Create(SpaceUI.Peek.Blur, peekTweenInfo, {Size = 18}):Play()

        local outerPad = 0.06
        local gutterPx = screenSize.X * 0.03
        local gutterPxY = screenSize.Y * 0.03

        local needsScroll = #targets > CARDS_PER_PAGE

        local pageW = screenSize.X * (1 - outerPad * 2)
        local pageH = screenSize.Y * (1 - outerPad * 2)
        local cellW = (pageW - gutterPx * (MAX_COLS - 1)) / MAX_COLS
        local cellH = (pageH - gutterPxY * (MAX_ROWS - 1)) / MAX_ROWS

        local pages = {}
        if needsScroll then
            local idx = 1
            while idx <= #targets do
                local pageTargets = {}
                for k = idx, math.min(idx + CARDS_PER_PAGE - 1, #targets) do
                    table.insert(pageTargets, targets[k])
                end
                table.insert(pages, pageTargets)
                idx = idx + CARDS_PER_PAGE
            end
        else
            pages = {targets}
        end

        local globalIndex = 0
        local maxPageWidthPx = 0

        for pageIdx, pageTargets in pages do
            -- Tính designSize (kích thước THIẾT KẾ GỐC, hoàn toàn không phụ thuộc bất kỳ
            -- UIScale nào - kể cả UIScale có sẵn trên frame như TabScale/MainFrameScale
            -- mà ensureUIScale() sẽ MƯỢN tạm bên dưới) trực tiếp từ frame.Size (UDim2)
            -- nhân với screenSize (viewport thật). KHÔNG dùng frame.AbsoluteSize: giá trị
            -- đó phụ thuộc chặt vào ĐÚNG THỜI ĐIỂM đọc (có thể đọc giữa lúc TabScale/
            -- MainFrameScale đang tween dở dang do animation mở/đóng tab khác, hoặc đã
            -- bị chính UIScale đó co sẵn) - dùng nó làm scaleFactor không ổn định, có
            -- lúc cho ra scaleFactor quá lớn (kẹp trần ở 1, card không co đủ, tràn cạnh/
            -- đụng nhau đúng như đã quan sát). frame.Size (UDim2, đặt bởi code UI, không
            -- đổi bởi bất kỳ UIScale nào) + screenSize (cố định, đọc 1 lần) loại bỏ hoàn
            -- toàn sự phụ thuộc vào timing/UIScale runtime này. Parent của mọi frame ở
            -- đây (TabBackground cho tab thường, MainScreenGui cho Dashboard) đều
            -- fromScale(1,1) full màn hình, nên %Scale của frame.Size nhân thẳng với
            -- screenSize (viewport thật) là đúng, không cần quy đổi qua parent trung gian.
            local pageDesignSizes = {}
            for k, target in pageTargets do
                local sz = target.Frame.Size
                pageDesignSizes[k] = Vector2.new(
                    sz.X.Scale * screenSize.X + sz.X.Offset,
                    sz.Y.Scale * screenSize.Y + sz.Y.Offset
                )
            end

            local baseRows = computeRows(#pageTargets)
            local rows = baseRows
            local pageOffsetXPx = needsScroll and ((pageIdx - 1) * (pageW + gutterPx)) or 0
            local pageWidthPx = 0

            -- Căn giữa theo chiều dọc: trước đây hàng luôn bắt đầu từ Y=0 của
            -- pageH (như thể luôn có đủ MAX_ROWS hàng), nên khi trang chỉ có 1
            -- hàng (dưới 3 tab) hoặc bất kỳ số hàng nào ít hơn MAX_ROWS, khối card
            -- bị dồn lên phía trên thay vì nằm giữa. Tính offset để cả khối hàng
            -- luôn nằm giữa pageH - khi đủ MAX_ROWS hàng thì offset = 0 (không đổi
            -- hành vi cũ cho case đã đúng).
            local numRows = #rows
            local totalRowsHeightPx = numRows * cellH + (numRows - 1) * gutterPxY
            local rowsOffsetYPx = (pageH - totalRowsHeightPx) / 2

            local rowStartIdx = 1
            for rowIdx, itemsInRow in rows do
                -- cellW cố định theo lưới MAX_COLS (không phải theo itemsInRow của hàng
                -- này) - card CO NHỎ TỰ DO để vừa cellW x cellH (xem scaleFactor bên dưới),
                -- không xuống hàng khi to. Layout hàng/cột (số card mỗi hàng) luôn cố định
                -- theo computeRows, độc lập với kích thước thật của card.
                local rowWidthPx = itemsInRow * cellW + (itemsInRow - 1) * gutterPx
                pageWidthPx = math.max(pageWidthPx, rowWidthPx)
                local rowOffsetXPx = (pageW - rowWidthPx) / 2

                for c = 1, itemsInRow do
                    globalIndex += 1
                    local target = pageTargets[rowStartIdx + c - 1]
                    local frame = target.Frame

                    -- Dùng lại giá trị đã tính ở pageDesignSizes (đọc frame.Size 1 lần duy
                    -- nhất, trước khi bất kỳ frame nào trong trang bị re-parent hay UIScale
                    -- nào bị đổi) - xem giải thích đầy đủ ở chỗ tính pageDesignSizes.
                    local designSize = pageDesignSizes[rowStartIdx + c - 1]

                    local card = {
                        Tab = target.Tab,
                        IsDashboard = target.IsDashboard,
                        Frame = frame,
                        OriginalParent = frame.Parent,
                        OriginalPosition = frame.Position,
                        OriginalSize = frame.Size,
                        OriginalZIndex = frame.ZIndex,
                        OriginalAnchorPoint = frame.AnchorPoint,
                        SavedDescendantZIndex = {},
                    }
                    table.insert(SpaceUI.Peek.Cards, card)

                    -- Re-parent frame ra thẳng MainScreenGui trong lúc Peek: frame gốc
                    -- (ActualTab, MainFrame) tính Position/Size theo % của PARENT THẬT của
                    -- nó (TabBackground/dashboard - nhỏ hơn nhiều so với toàn màn hình), nhưng
                    -- lưới Peek tính cellCenterXPx/outerPad theo screenSize = viewport thật
                    -- (mainScreenGui.AbsoluteSize, không chia/nhân uiScale gì cả). Hai hệ quy
                    -- chiếu khác nhau khiến card bị lệch góc trên-trái và chồng lấn nếu không
                    -- re-parent - phải đưa frame ra đúng hệ quy chiếu MainScreenGui trước khi
                    -- áp Position kiểu pixel-tuyệt-đối. Không cần layer/UIScale bù riêng nào cả:
                    -- MainScreenGuiScale (uiScale) sẽ tự nhân lên Position/Size pixel-tuyệt-đối
                    -- này lúc render - đây là hành vi ĐÚNG và CẦN THIẾT (không phải bug): nó quy
                    -- đổi pixel-viewport-thật sang đúng không gian hiển thị cuối cùng trên màn
                    -- hình mobile đã bị scale UI xuống, y hệt cách MainFrame gốc vẫn luôn hiển
                    -- thị đúng dù nằm dưới MainScreenGuiScale.
                    frame.Parent = SpaceUI.Background.Objects.MainScreenGui

                    frame.ZIndex = 500 + globalIndex
                    -- KHÔNG còn gọi boostDescendantZIndex ở đây nữa: với
                    -- ZIndexBehavior = Sibling đã bật cho MainScreenGui, HitCatcher
                    -- (ZIndex=5000, con trực tiếp của frame) tự động nổi trên mọi
                    -- anh em khác trong cùng frame mà không cần đụng ZIndex của
                    -- chúng. Trước đây boost +2000 vào TOÀN BỘ descendants (bao gồm
                    -- cả bên trong 1 tab con nếu Dashboard/MainFrame cũng nằm trong
                    -- targets) từng gây kẹt ZIndex ở mức hàng nghìn sau khi restore,
                    -- vô hiệu hóa cơ chế so sánh 1 vs 2 của CaptureFocus.
                    attachHitCatcher(card)

                    local scaleInst, scaleWasPreExisting = ensureUIScale(frame)
                    card.Scale = scaleInst
                    card.ScaleOwnedByPeek = not scaleWasPreExisting
                    local scaleFactor = 1
                    if designSize.X > 0 and designSize.Y > 0 then
                        scaleFactor = math.min(cellW / designSize.X, cellH / designSize.Y, 1)
                    end
                    TweenService:Create(scaleInst, peekTweenInfo, {Scale = scaleFactor}):Play()

                    local cellCenterXPx = pageOffsetXPx + rowOffsetXPx + (c - 1) * (cellW + gutterPx) + cellW / 2
                    local cellCenterYPx = rowsOffsetYPx + (rowIdx - 1) * (cellH + gutterPxY) + cellH / 2

                    -- BaseOffsetX lưu ở "không gian viewport thật" (CHƯA bù posScaleCompensate)
                    -- - khớp đơn vị với SpaceUI.Peek.ScrollX (tính trực tiếp từ input.Position.X,
                    -- luôn là pixel màn hình thật) và maxScrollX (tính từ pageW cũng viewport
                    -- thật). Bù posScaleCompensate chỉ áp DUY NHẤT lúc gán vào Position thật sự
                    -- (ở đây và trong applyScrollX bên trên) - không lưu sẵn vào BaseOffsetX, để
                    -- (BaseOffsetX + ScrollX) cộng đúng trong cùng 1 không gian trước khi bù.
                    card.BaseOffsetX = cellCenterXPx

                    frame.AnchorPoint = Vector2.new(0.5, 0.5)
                    -- Nhân bù posScaleCompensate (1/uiScale) vào Offset trước khi gán Position:
                    -- MainScreenGuiScale sẽ nhân lại đúng 1 lần uiScale lúc render, đưa Offset
                    -- hiển thị cuối cùng về đúng pixel thật mong muốn (xem giải thích đầy đủ ở
                    -- chỗ khai báo posScaleCompensate, đầu hàm Enter). Component Scale (outerPad)
                    -- của UDim2 KHÔNG cần bù - nó tính theo % kích thước MainScreenGui, vốn đã là
                    -- viewport thật và không bị UIScale của chính nó tự áp lên chính nó.
                    TweenService:Create(frame, peekTweenInfo, {
                        Position = UDim2.new(outerPad, cellCenterXPx * posScaleCompensate, outerPad, cellCenterYPx * posScaleCompensate),
                    }):Play()
                end
                rowStartIdx += itemsInRow
            end

            maxPageWidthPx = math.max(maxPageWidthPx, pageOffsetXPx + pageWidthPx)
        end

        local maxScrollX = needsScroll and math.max(0, maxPageWidthPx - pageW) or 0
        attachPeekInput(overlay, maxScrollX)

        return true
    end

    function SpaceUI.Peek.Toggle()
        if SpaceUI.Peek.Active then
            SpaceUI.Peek.Exit(nil)
            return true
        end
        local ok, reason = SpaceUI.Peek.Enter()
        if not ok and Assets.Notifications and Assets.Notifications.Send then
            if reason == "no_open_tabs" then
                Assets.Notifications.Send({
                    Description = "Không có tab nào đang mở để hiện Peek.",
                    Duration = 3,
                })
            end
        end
        return ok
    end
end

local safe_cloneref = function(ref: Instance) return ref end
pcall(function()
    if getgenv and getgenv().cloneref then
        safe_cloneref = getgenv().cloneref
    elseif cloneref then
        safe_cloneref = cloneref
    end
end)
Assets.Functions.cloneref = safe_cloneref

local PlayersSV = safe_cloneref(game:GetService("Players"))
local HttpService = safe_cloneref(game:GetService("HttpService"))
local TweenService = safe_cloneref(game:GetService("TweenService"))
local UserInputService = safe_cloneref(game:GetService("UserInputService"))
local Workspace = safe_cloneref(game:GetService("Workspace"))
local TextService = safe_cloneref(game:GetService("TextService"))

local UserCamera = Workspace.CurrentCamera
local LocalPlayer = PlayersSV.LocalPlayer

do
    Assets.Functions.clonefunction = clonefunction or function(func: any) return func end

    Assets.Functions.gethui = gethui or function() return LocalPlayer:FindFirstChildWhichIsA("PlayerGui") end
    Assets.Functions.GenerateString = function(chars : number) : string
        local str = ""
        for i = 0, chars do
            str = str..string.char(math.random(33,126))
        end
        return str
    end
    Assets.Functions.GetGameInfo = function()
        local gameinfo = game:HttpGet("https://games.roblox.com/v1/games?universeIds="..tostring(game.GameId))
        if gameinfo then
            local dencgameinfo = HttpService:JSONDecode(gameinfo)
            if dencgameinfo and dencgameinfo.data and dencgameinfo.data[1] then
                return dencgameinfo.data[1]                
            else
                return "no game info after json"
            end
        else
            return "no game info returned"
        end
    end
    Assets.Functions.LoadFile = function(file : string, githublink : string)
        if SpaceUI.Dev and isfile(file) then
            return loadstring(readfile(file))()
        else
            local suc, err = pcall(function() 
                file = http.request({
                    Url = githublink,
                    Method = "GET"
                }).Body
            end)
            if suc and not err and file and not tostring(file):lower():find("404: not found") then
                return loadstring(file)()
            end
        end
        return "error"
    end
    Assets.Functions.IsAlive = function(plr: Player)
        plr = plr or LocalPlayer
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hum = plr.Character:FindFirstChildWhichIsA("Humanoid")
            if hum and hum.Health > 0.1 then
                return true
            end
        end
        return false
    end
    Assets.Functions.GetModule = function(name: string)
        if name and Hub and SpaceUI.Tabs and SpaceUI.Tabs.Tabs then
            for i,v in SpaceUI.Tabs.Tabs do
                if v.Modules and v.Modules[name] then
                    return v.Modules[name]
                end
            end
        end
        return
    end
    Assets.Functions.GetAllModules = function()
        local modules = {}
        if SpaceUI.Tabs and SpaceUI.Tabs.Tabs then
            for i,v in SpaceUI.Tabs.Tabs do
                if v.Modules then
                    for i2, v2 in v.Modules do 
                        modules[i2] = v2
                    end
                end
            end
        end
        return modules
    end
    Assets.Functions.GetNearestPlr = function(tplr, teamcheck)
        tplr = tplr or LocalPlayer
        local lastpos, plr = math.huge, nil
        for i,v in PlayersSV:GetPlayers() do
            if teamcheck and v.Team ~= tplr.Team or not teamcheck then
                if v and v ~= tplr and Assets.Functions.IsAlive(v) and Assets.Functions.IsAlive(tplr) then
                    local dist = (tplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if lastpos > dist then
                        lastpos = dist
                        plr = v
                    end
                end
            end
        end
        return plr, lastpos
    end
    Assets.Functions.GetNearestPlrToMouse = function(Data: {Team: boolean, Limit: number, Exclude: {}, Extras: {}})
        Data = {
            Team = Data and Data.Team or false,
            Limit = Data and Data.Limit or math.huge,
            Exclude = Data and Data.Exclude or {},
            Extras = Data and Data.Extras or {}
        }

        local RData = {Player = nil, Distance = math.huge, PlayerDist = math.huge}
        local Players = {}
        for i,v in PlayersSV:GetPlayers() do
            if Assets.Functions.IsAlive(v) then
                if Data.Team and v.Team ~= LocalPlayer.Team or not Data.Team then
                    table.insert(Players, v.Character)
                end
            end
        end

        for i,v in Data.Extras do
            table.insert(Players, v)
        end

        for i,v in Players do
            if not table.find(Data.Exclude, v) then
                local Part = v:FindFirstChild("HumanoidRootPart") or v.PrimaryPart
                if Part then
                    local screenpos, onscreen = UserCamera:WorldToScreenPoint(Part.Position)
                    if screenpos and onscreen then
                        local mouse = LocalPlayer:GetMouse()
                        local mousepos = mouse.Hit.Position
                        local mag = (mousepos - Part.Position).Magnitude
                        local plrdist = (Part.Position - Part.Position).Magnitude
                        if Data.Limit >= mag and RData.Distance >= mag and (RData.Distance == mag and RData.PlayerDist >= plrdist or RData.Distance ~= mag) then
                            RData = {
                                Player = PlayersSV:GetPlayerFromCharacter(v),
                                Character = v,
                                Distance = mag,
                                PlayerDist = plrdist
                            }
                        end
                    end
                end
            end
        end
        return RData
    end
end

do
    Assets.Config.Save = function(File, data)
        writefile("SpaceUI/Config/"..File..".json", HttpService:JSONEncode(data))
    end
    
    Assets.Config.Load = function(File, set)
        if isfile("SpaceUI/Config/"..File..".json") then
            local data = readfile("SpaceUI/Config/"..File..".json")
            local data2 = HttpService:JSONDecode(data)
            if set then
                SpaceUI.Config[set] = data2
                if set == "Game" then
                    local allmodules = Assets.Functions.GetAllModules()
                    for i,v in allmodules do
                        for i2, v2 in v.Settings do
                            if v2.Type then
                                if data2[v2.Type] then
                                    if data2[v2.Type][v2.Flag] ~= nil then
                                        v2.Functions.SetValue(data2[v2.Type][v2.Flag], false)
                                    elseif data2[v2.Type][v2.Flag] == nil and v2.Default ~= nil then
                                        v2.Functions.SetValue(v2.Default, false)
                                    elseif data2[v2.Type][v2.Flag] == false then
                                        v2.Functions.SetValue(false, false)
                                    end
                                else
                                    if v2.Default ~= nil then
                                        v2.Functions.SetValue(v2.Default, false)
                                    end
                                end
                            end
                        end

                        if data2.Keybinds and data2.Keybinds[i] then
                            if v.Functions and v.Functions.BindKeybind then
                                v.Functions.BindKeybind(data2.Keybinds[i], false)
                            end
                        end
                        if data2.Modules and data2.Modules[i] or data2.Modules and v.Default and data2.Modules[i] == nil then
                            if not v.Data.Enabled then
                                v.Functions.Toggle(true, false, false, false, true)
                            end
                        else
                            if v.Data.Enabled then
                                v.Functions.Toggle(false, false, false, false, true)
                            end
                        end
                    end

                    if SpaceUI.Config.Game.Other.TabPos then
                        for i,v in SpaceUI.Tabs.Tabs do
                            local tabpos = SpaceUI.Config.Game.Other.TabPos[i]
                            if tabpos and v.Objects and v.Objects.ActualTab then
                                local tab = v.Objects.ActualTab
                                if tabpos.X then
                                    tab.Position = UDim2.fromScale(tabpos.X, tab.Position.Y.Scale)
                                end
                                if tabpos.Y then
                                    tab.Position = UDim2.fromScale(tab.Position.X.Scale, tabpos.Y)
                                end
                            end
                        end
                    end
                end
            end
            return data2
        end
        return "no file"
    end
    
end

local function GetTextBounds(str: string, font: Font, textsize: number)
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = str
    Params.Font = font
    Params.Size = textsize
    Params.Width = 1e9
    Params.RichText = false
    
    return TextService:GetTextBoundsAsync(Params)
end

do
    type FontFamily = {
        name: string,
        faces: { FontFace },
    }
    
    type FontFace = {
        name: string,
        file: string,
        weight: number,
        style: string?,
    }

    Assets.Font.Download = function(Name: string, Font: string)
        local data = game:HttpGet(Font)
        if not isfile("SpaceUI/Assets/Fonts/"..Name..".ttf") then
            if data and not tostring(data):find("404") then
                writefile("SpaceUI/Assets/Fonts/"..Name..".ttf", data)
            else
                return false
            end
        end
        return true
    end

    local family_cache = {}
    Assets.Font.create_family = function(name: string, faces: { FontFace })
        local family = { name = name, faces = {} }

        for i, face in next, faces do
            local rbx_face = {
                name = assert(face.name, "Face #"..tostring(i).." is invalid (no name field)"),
                weight = assert(face.weight, "Face #"..tostring(i).." is invalid (no weight field)"),
                style = face.style or "normal",
                assetId = getcustomasset(face.file),
            }

            table.insert(family.faces, rbx_face)
        end

        writefile("SpaceUI/Assets/Fonts/"..name..".json", HttpService:JSONEncode(family))

        local id = getcustomasset("SpaceUI/Assets/Fonts/"..name..".json")
        family_cache[name] = id

        return id
    end

    Assets.Font.get_family = function(name: string)
        local id = assert(family_cache[name], "Family "..tostring(name).." not found!")

        return id
    end
end

do

    Assets.Notifications.Send = function(data: any)
        local NotificationData = {
            Description = data.Description or "This is a notification",
            Duration = data.Duration or 5,
            Flag = data.Flag,
            Running = true,
            Objects = {},
            Functions = {},
            Connections = {}
        }

        local flag = NotificationData.Flag or NotificationData.Description
        for i, v in SpaceUI.Notifications.Active do
            if v.Objects.Notification then
                TweenService:Create(v.Objects.Notification, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(v.Objects.Notification.Position.X.Scale, v.Objects.Notification.Position.X.Offset, v.Objects.Notification.Position.Y.Scale, v.Objects.Notification.Position.Y.Offset + 50)}):Play()
            end
        end
        

        NotificationData.Objects.Notification = Instance.new("ImageButton", SpaceUI.Notifications.Objects.NotificationGui)
        NotificationData.Objects.Notification.AnchorPoint = Vector2.new(0.5, 0)
        NotificationData.Objects.Notification.AutoButtonColor = false
        NotificationData.Objects.Notification.AutomaticSize = Enum.AutomaticSize.X
        NotificationData.Objects.Notification.BackgroundColor3 = Color3.fromRGB(79, 79, 79)
        NotificationData.Objects.Notification.BackgroundTransparency = 0.05
        NotificationData.Objects.Notification.Position = UDim2.new(0.5, 0, -1, 30)
        NotificationData.Objects.Notification.Size = UDim2.new(0, 0, 0, 40)
        NotificationData.Objects.Notification.ZIndex = 10
        NotificationData.Objects.Notification.Image = "rbxassetid://16294030997"
        NotificationData.Objects.Notification.ScaleType = Enum.ScaleType.Crop
        NotificationData.Objects.Notification.ImageColor3 = Color3.fromRGB(80, 80, 80)
        NotificationData.Objects.Notification.ClipsDescendants = true
        Instance.new("UICorner", NotificationData.Objects.Notification).CornerRadius = UDim.new(0, 100)

        local NotificationPadding = Instance.new("UIPadding", NotificationData.Objects.Notification)
        NotificationPadding.PaddingBottom = UDim.new(0, 5)
        NotificationPadding.PaddingLeft = UDim.new(0, 20)
        NotificationPadding.PaddingRight = UDim.new(0, 20)
        NotificationPadding.PaddingTop = UDim.new(0, 5)

        local NotificationStroke = Instance.new("UIStroke", NotificationData.Objects.Notification)
        NotificationStroke.Color = Color3.fromRGB(255, 255, 255)
        local NotificationStrokeGradient = Instance.new("UIGradient", NotificationStroke)
        NotificationStrokeGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.694, 0), NumberSequenceKeypoint.new(1, 0.869, 0)}
        NotificationStrokeGradient.Rotation = 80

        local CloseButton = Instance.new("ImageButton", NotificationData.Objects.Notification)
        CloseButton.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseButton.BackgroundTransparency = 1
        CloseButton.Position = UDim2.new(0, 8, 0.5, 0)
        CloseButton.Size = UDim2.new(0, 16, 0, 16)
        CloseButton.ZIndex = 10
        CloseButton.Image = "rbxassetid://11295275950"
        CloseButton.ScaleType = Enum.ScaleType.Fit
        CloseButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
        CloseButton.AutoButtonColor = false


        local TimeLine = Instance.new("ImageLabel", NotificationData.Objects.Notification)
        TimeLine.AnchorPoint = Vector2.new(0.5, 1)
        TimeLine.BackgroundTransparency = 1
        TimeLine.Position = UDim2.fromScale(0.5, 1)
        TimeLine.Size = UDim2.new(0.1, 50, 0, 2)
        TimeLine.ZIndex = 10
        TimeLine.Image = "rbxassetid://16294678871"
        TimeLine.ScaleType = Enum.ScaleType.Slice
        TimeLine.SliceCenter = Rect.new(206, 206, 206, 206)
        TimeLine.ImageColor3 = Color3.fromRGB(255, 255, 255)
        TimeLine.ImageTransparency = 0.8
        TimeLine.Visible = false

        local TimeLineBar = Instance.new("ImageLabel", TimeLine)
        TimeLineBar.AnchorPoint = Vector2.new(0, 0.5)
        TimeLineBar.BackgroundTransparency = 1
        TimeLineBar.Position = UDim2.fromScale(0, 0.5)
        TimeLineBar.Size = UDim2.fromScale(0, 2)
        TimeLineBar.Image = "rbxassetid://16294678871"
        TimeLineBar.BorderSizePixel = 0
        TimeLineBar.ScaleType = Enum.ScaleType.Slice
        TimeLineBar.SliceCenter = Rect.new(206, 206, 206, 206)
        TimeLineBar.ImageTransparency = 0.2
        TimeLineBar.ZIndex = 10

        NotificationData.Objects.NotificationDescription = Instance.new("TextLabel", NotificationData.Objects.Notification)
        NotificationData.Objects.NotificationDescription.AutomaticSize = Enum.AutomaticSize.X
        NotificationData.Objects.NotificationDescription.BackgroundTransparency = 1
        NotificationData.Objects.NotificationDescription.Position = UDim2.fromOffset(26, 0)
        NotificationData.Objects.NotificationDescription.Size = UDim2.fromScale(0, 1)
        NotificationData.Objects.NotificationDescription.ZIndex = 10
        NotificationData.Objects.NotificationDescription.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
        NotificationData.Objects.NotificationDescription.Text = NotificationData.Description
        NotificationData.Objects.NotificationDescription.TextColor3 = Color3.fromRGB(255, 255, 255)
        NotificationData.Objects.NotificationDescription.TextSize = 15
        NotificationData.Objects.NotificationDescription.TextTransparency = 0.2

        NotificationData.Functions.Remove = function(anim: boolean)
            if not SpaceUI.Notifications or not SpaceUI.Notifications.Active then return end
            for i,v in NotificationData.Connections do
                v:Disconnect()
                if table.find(SpaceUI.Connections, v) then
                    table.remove(SpaceUI.Connections, table.find(SpaceUI.Connections, v))
                end
            end

            for i, v in SpaceUI.Notifications.Active do
                if v.Objects.Notification and v.Objects.Notification.Position.Y.Offset > NotificationData.Objects.Notification.Position.Y.Offset then
                    TweenService:Create(v.Objects.Notification, TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(v.Objects.Notification.Position.X.Scale, v.Objects.Notification.Position.X.Offset, v.Objects.Notification.Position.Y.Scale, v.Objects.Notification.Position.Y.Offset - 50)}):Play()
                end
            end

            if anim then
                TweenService:Create(TimeLineBar, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
                for i,v in NotificationData.Objects.Notification:GetChildren() do
                    if v:IsA("ImageButton") or v:IsA("ImageLabel") then
                        TweenService:Create(v, TweenInfo.new(0.15), {ImageTransparency = 1, BackgroundTransparency = 1}):Play()
                    elseif v:IsA("TextLabel") then
                        TweenService:Create(v, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
                    end
                end
                task.wait(0.05)
                TweenService:Create(NotificationData.Objects.Notification, TweenInfo.new(0.2), {ImageTransparency = 1, BackgroundTransparency = 1}):Play()
                task.wait(0.22)
            end

            NotificationData.Objects.Notification:Destroy()
            if SpaceUI.Notifications and SpaceUI.Notifications.Active then
                SpaceUI.Notifications.Active[flag] = nil
            end
            table.clear(NotificationData)
        end
        
        NotificationData.Connections.conhover = NotificationData.Objects.Notification.MouseEnter:Connect(function()
            TimeLine.Visible = true
            CloseButton.Image = "rbxassetid://11293981586"
        end)
        
        NotificationData.Connections.unconhover = NotificationData.Objects.Notification.MouseLeave:Connect(function()
            TimeLine.Visible = false
            CloseButton.Image = "rbxassetid://11295275950"
        end)

        NotificationData.Connections.closecon = CloseButton.MouseButton1Click:Connect(function() NotificationData.Functions.Remove(true) end)

        table.insert(SpaceUI.Connections, NotificationData.Connections.conhover)
        table.insert(SpaceUI.Connections, NotificationData.Connections.unconhover)
        table.insert(SpaceUI.Connections, NotificationData.Connections.closecon)

        TweenService:Create(NotificationData.Objects.Notification, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 30)}):Play()
        if SpaceUI.Notifications.Active[flag] then
            flag = NotificationData.Description..tostring(math.random(0, 1000000000))
            SpaceUI.Notifications.Active[flag] = NotificationData
        else
            SpaceUI.Notifications.Active[flag] = NotificationData
        end

        local duration = NotificationData.Duration
        local start = os.clock()
        task.spawn(function()
            while (os.clock() - start) < duration do
                if not SpaceUI.Notifications or not SpaceUI.Notifications.Active or not SpaceUI.Notifications.Active[flag] then return end
                local progress = (os.clock() - start) / duration
                TimeLineBar.Size = UDim2.new(progress, 0, 0, 2)
                task.wait()
            end
            if SpaceUI.Notifications and SpaceUI.Notifications.Active and SpaceUI.Notifications.Active[flag] then
                NotificationData.Functions.Remove(true)
            end
        end)

        return NotificationData
    end
end


do    
    Assets.MainBackground.Init = function()
        local InitInfo = {
            Functions = {Resize = nil, Drag = nil}, 
            Data = {Resizing = false, Dragging = false, LastInputPosition = nil, IsToggleAnimating = false}, 
            Objects = {},
            NavigationButtons = {},
            WindowControls = {IsOpened = false, Instances = {}},
            MobileButtons = {indxs = {}, Buttons = {}}
        }
    
        SpaceUI.Notifications.Objects.NotificationGui = Instance.new("ScreenGui", Assets.Functions.gethui())
        SpaceUI.Notifications.Objects.NotificationGui.ResetOnSpawn = false
        SpaceUI.Notifications.Objects.NotificationGui.IgnoreGuiInset = true
        SpaceUI.Notifications.Objects.NotificationGui.DisplayOrder = 10000
        if SpaceUI.Mobile then
            Instance.new("UIScale", SpaceUI.Notifications.Objects.NotificationGui).Scale = SpaceUI.Config.UI.Scale
        end

        SpaceUI.ArrayList.Objects.ArrayGui = Instance.new("ScreenGui", Assets.Functions.gethui())
        SpaceUI.ArrayList.Objects.ArrayGui.ResetOnSpawn = false
        SpaceUI.ArrayList.Objects.ArrayGui.DisplayOrder = 10000
        SpaceUI.ArrayList.Objects.ArrayGui.Enabled = false
        if SpaceUI.Config.UI.ArrayList == nil then
            SpaceUI.Config.UI.ArrayList = false
        end
    
        InitInfo.Objects.MainScreenGui = Instance.new("ScreenGui", Assets.Functions.gethui())
        InitInfo.Objects.MainScreenGui.ResetOnSpawn = false
        InitInfo.Objects.MainScreenGui.IgnoreGuiInset = true
        InitInfo.Objects.MainScreenGui.DisplayOrder = 10000
        -- QUAN TRỌNG: Roblox mặc định ZIndexBehavior = Global (KHÔNG phải Sibling).
        -- Ở chế độ Global, ZIndex so sánh TUYỆT ĐỐI xuyên suốt toàn bộ cây GUI, không
        -- giới hạn trong phạm vi anh em cùng cha - nghĩa là 1 con cháu sâu bên trong
        -- có ZIndex cao (vd TabPrism=1000, TabDragCanvas=10000000) sẽ đè lên MỌI thứ
        -- khác có ZIndex thấp hơn dù ở NHÁNH CÂY HOÀN TOÀN KHÁC, kể cả tab đang được
        -- CaptureFocus set ZIndex=2 để bring-to-front. Đặt Sibling để ZIndex chỉ so
        -- sánh giữa các con TRỰC TIẾP cùng 1 cha (đúng như cách CaptureFocus/RemoveFocus
        -- (ZIndex 1 vs 2 giữa các ActualTab cùng cha TabBackground) được thiết kế để
        -- hoạt động).
        InitInfo.Objects.MainScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        -- Ép force auto-scale mobile NGAY TẠI ĐÂY, tại đúng điểm Scale/Size thực sự
        -- được dùng để tạo UI - ghi đè bất kỳ giá trị Config.UI.Scale/Size nào đã tồn
        -- tại từ trước (config đã lưu từ lần chạy cũ, giá trị mặc định static, hoặc do
        -- đoạn set sớm ở đầu file không chạy vì lý do thứ tự/gate khác). Không phụ
        -- thuộc bất kỳ điều kiện "chỉ set nếu chưa tồn tại" nào nữa.
        if SpaceUI.Mobile then
            SpaceUI.Config.UI.Size = {X = 0.7, Y = 0.9}
            local ForceScaleCamera = workspace.CurrentCamera
            if ForceScaleCamera then
                local vpX = ForceScaleCamera.ViewportSize.X
                if 0.4 >= (vpX / 1000) - 0.1 then
                    SpaceUI.Config.UI.Scale = 0.4
                else
                    SpaceUI.Config.UI.Scale = (vpX / 1000) - 0.1
                end
            else
                SpaceUI.Config.UI.Scale = 0.4
            end
        end

        InitInfo.Objects.MainScreenGuiScale = Instance.new("UIScale", InitInfo.Objects.MainScreenGui)
        InitInfo.Objects.MainScreenGuiScale.Scale = SpaceUI.Config.UI.Scale
            
        InitInfo.Objects.MainFrame = Instance.new("ImageButton", InitInfo.Objects.MainScreenGui)
        InitInfo.Objects.MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.MainFrame.AutoButtonColor = false
        InitInfo.Objects.MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
        InitInfo.Objects.MainFrame.BackgroundTransparency = 1
        InitInfo.Objects.MainFrame.Position = UDim2.fromScale(SpaceUI.Config.UI.Position.X, SpaceUI.Config.UI.Position.Y)
        InitInfo.Objects.MainFrame.Size = UDim2.fromScale(SpaceUI.Config.UI.Size.X, SpaceUI.Config.UI.Size.Y)
        InitInfo.Objects.MainFrame.Image = "rbxassetid://16255699706"
        InitInfo.Objects.MainFrame.ImageTransparency = 1
        InitInfo.Objects.MainFrame.ScaleType = Enum.ScaleType.Crop
        InitInfo.Objects.MainFrame.Visible = false
        local mainframecorner = Instance.new("UICorner", InitInfo.Objects.MainFrame)
        mainframecorner.CornerRadius = UDim.new(0, 20)
        InitInfo.Objects.MainFrameScale = Instance.new("UIScale", InitInfo.Objects.MainFrame)
        InitInfo.Objects.MainFrameScale.Scale = 1.2
        table.insert(SpaceUI.Corners, mainframecorner)
    
        InitInfo.Objects.PageHolder = Instance.new("Frame", InitInfo.Objects.MainFrame)
        InitInfo.Objects.PageHolder.BackgroundTransparency = 1
        InitInfo.Objects.PageHolder.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.PageHolder.Size = UDim2.fromScale(1, 1)
        InitInfo.Objects.PageHolder.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.PageHolder.ClipsDescendants = true
        -- PageHolder đã ClipsDescendants=true (cắt các trang/panel con) nhưng bản thân
        -- nó là hình chữ nhật vuông - không có UICorner nên cắt VUÔNG, không theo đúng
        -- góc bo 20px của MainFrame (mainframecorner ở trên). MainFrame tự nó không
        -- ClipsDescendants (không thể bật, vì DropShadow là con trực tiếp của MainFrame
        -- và CỐ Ý tràn ra ngoài 88px mỗi chiều để đổ bóng lan rộng - bật clip trên
        -- MainFrame sẽ cắt cụt luôn DropShadow). Thêm UICorner cùng bán kính ngay trên
        -- PageHolder: nội dung bên trong (panel/tab) giờ bị cắt đúng theo góc bo tròn,
        -- không còn lòi 4 góc vuông ra ngoài viền MainFrame nữa - không đụng DropShadow.
        local pageHolderCorner = Instance.new("UICorner", InitInfo.Objects.PageHolder)
        pageHolderCorner.CornerRadius = UDim.new(0, 20)
        table.insert(SpaceUI.Corners, pageHolderCorner)
    
        do
            -- TopbarPlus được tạo trong Main.Load
            

            InitInfo.Objects.MobileKeybindFolder = Instance.new("Folder", InitInfo.Objects.MainScreenGui)
            InitInfo.Functions.CreateMobileButton = function(info)
                local MobileButtonInfo = {
                    Name = info.Name or "mobile button",
                    Flag = info.Flag or "flagbutton",
                    Callbacks = info.Callbacks or {Began = function() end, End = function() end},
                    Instances = {},
                    Connections = {},
                    Functions = {},
                    Data = {Position = {X = 0.062, Y = 0.418}, CurrIndex = 1, NextChange = "Y", Dragging = false},
                }

                if not MobileButtonInfo.Callbacks.Began then
                    MobileButtonInfo.Callbacks.Began = function() end
                end

                if not MobileButtonInfo.Callbacks.End then
                    MobileButtonInfo.Callbacks.End = function() end
                end
    
                if #InitInfo.MobileButtons.indxs > 0 then
                    MobileButtonInfo.Data.CurrIndex = #InitInfo.MobileButtons.indxs + 1
                    local curinfo = InitInfo.MobileButtons.indxs[#InitInfo.MobileButtons.indxs]
                    if curinfo and curinfo.Data and curinfo.Data.Position then
                        local pos = curinfo.Data.Position
                        MobileButtonInfo.Data.Position.X = pos.X
                        if curinfo.Data.NextChange == "Y" then
                            MobileButtonInfo.Data.Position.Y = pos.Y + 0.082
                            MobileButtonInfo.Data.NextChange = "X"
                        else
                            MobileButtonInfo.Data.Position.X = pos.X + 0.048
                        end
                    end
                end
    
                MobileButtonInfo.Instances.MainBG = Instance.new("TextButton", InitInfo.Objects.MobileKeybindFolder)
                MobileButtonInfo.Instances.MainBG.AutoButtonColor = false
                MobileButtonInfo.Instances.MainBG.AnchorPoint = Vector2.new(0.5,0.5)
                MobileButtonInfo.Instances.MainBG.BackgroundTransparency = 0.2
                MobileButtonInfo.Instances.MainBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
                MobileButtonInfo.Instances.MainBG.BorderSizePixel = 0
                MobileButtonInfo.Instances.MainBG.Position = UDim2.fromScale(MobileButtonInfo.Data.Position.X, MobileButtonInfo.Data.Position.Y)
                MobileButtonInfo.Instances.MainBG.Size = UDim2.fromScale(0.049, 0.086)
                MobileButtonInfo.Instances.MainBG.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                MobileButtonInfo.Instances.MainBG.Text = MobileButtonInfo.Name
                MobileButtonInfo.Instances.MainBG.TextScaled = true
                MobileButtonInfo.Instances.MainBG.ZIndex = 1000000
                MobileButtonInfo.Instances.MainBG.TextColor3 = Color3.fromRGB(255,255,255)
                MobileButtonInfo.Instances.MainBG.Draggable = true
    
                Instance.new("UICorner", MobileButtonInfo.Instances.MainBG).CornerRadius = UDim.new(0, 5)

                local button = Instance.new("ImageButton", MobileButtonInfo.Instances.MainBG)
                button.AnchorPoint = Vector2.new(0.5, 0.5)
                button.Size = UDim2.fromScale(1, 1)
                button.Position = UDim2.fromScale(0.5, 0.5)
                button.ZIndex = 10000000
                button.ImageTransparency = 1
                button.BackgroundTransparency = 1
    
                MobileButtonInfo.Functions.Destroy = function()
                    InitInfo.MobileButtons.Buttons[MobileButtonInfo.Flag] = nil
                    InitInfo.MobileButtons.indxs[MobileButtonInfo.Data.CurrIndex] = nil
    
                    MobileButtonInfo.Instances.MainBG:Destroy()
                    for i,v in MobileButtonInfo.Connections do
                        if table.find(SpaceUI.Connections, v) then
                            table.remove(SpaceUI.Connections, table.find(SpaceUI.Connections, v))
                        end
                        v:Disconnect()
                    end
    
                    local nextbutton = InitInfo.MobileButtons[MobileButtonInfo.Data.CurrIndex + 1]
                    if nextbutton and nextbutton.Data then
                        nextbutton.Data.CurrIndex -= 1
                    end
    
                    
                    table.clear(MobileButtonInfo)
                end

                MobileButtonInfo.Functions.Drag = function(mouseStart: Vector2 | Vector3 | nil, frameStart: UDim2, input: InputObject?)
                    pcall(function()
                        if UserCamera then
                            local Viewport = UserCamera.ViewportSize
                            local Delta = Vector2.new(0, 0)
                            local FrameSize = MobileButtonInfo.Instances.MainBG.AbsoluteSize
                            if mouseStart and input then
                                Delta = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(mouseStart.X, mouseStart.Y))
                            end
                
                            local newX = math.clamp(frameStart.X.Scale + (Delta.X / Viewport.X), FrameSize.X / Viewport.X / 2, 1 - FrameSize.X / Viewport.X / 2)
                            local newY = math.clamp(frameStart.Y.Scale + (Delta.Y / Viewport.Y), FrameSize.Y / Viewport.Y / 2, 1 - FrameSize.Y / Viewport.Y / 2)
                
                            local Position = UDim2.new(newX, 0, newY, 0)
                            MobileButtonInfo.Instances.MainBG.Position = Position 
                            MobileButtonInfo.Data.Position = {X = newX, Y = newY}           
                        end
                    end)
                end

                local InputStarting, FrameStarting, HoldTime = nil, nil, 0
                local dragcon = button.InputBegan:Connect(function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then

                        MobileButtonInfo.Callbacks.Began(MobileButtonInfo)

                        SpaceUI.InputEndFunc = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                                local hold = (tick()-HoldTime) >= 0.8
                                MobileButtonInfo.Callbacks.End(MobileButtonInfo, hold)
                                HoldTime = 0
                                SpaceUI.CurrntInputChangeCallback = function() end
                                SpaceUI.InputEndFunc = nil
                                
                                if hold then
                                    MobileButtonInfo.Data.Dragging, InputStarting, FrameStarting = false, input.Position, MobileButtonInfo.Instances.MainBG.Position

                                    if not SpaceUI.Config.Game.Other.MobileButtonPos then 
                                        SpaceUI.Config.Game.Other.MobileButtonPos = {}
                                    end

                                    SpaceUI.Config.Game.Other.MobileButtonPos[MobileButtonInfo.Flag] = {X = FrameStarting.X.Scale, Y = FrameStarting.Y.Scale}
                                    Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                                end
                            end
                        end

                        HoldTime = tick()
                        repeat task.wait() until tick() - HoldTime >= 0.8 or HoldTime == 0
                        if HoldTime >= 0.8 then
                            MobileButtonInfo.Data.Dragging, InputStarting, FrameStarting = true, input.Position, MobileButtonInfo.Instances.MainBG.Position
                            SpaceUI.CurrntInputChangeCallback = function(input)
                                if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
                                    if MobileButtonInfo.Data.Dragging and not SpaceUI.Config.UI.FullScreen then
                                        MobileButtonInfo.Functions.Drag(InputStarting, FrameStarting, input)
                                    end
                                end
                            end
                        end

                    end
                end)

                table.insert(SpaceUI.Connections, dragcon)
                table.insert(MobileButtonInfo.Connections, dragcon)

                if SpaceUI.Config.Game.Other.MobileButtonPos and SpaceUI.Config.Game.Other.MobileButtonPos[MobileButtonInfo.Flag] then
                    local pos = SpaceUI.Config.Game.Other.MobileButtonPos[MobileButtonInfo.Flag]
                    if pos.X then
                        MobileButtonInfo.Instances.MainBG.Position = UDim2.fromScale(pos.X, MobileButtonInfo.Instances.MainBG.Position.Y.Scale)
                    end
                    if pos.Y then
                        MobileButtonInfo.Instances.MainBG.Position = UDim2.fromScale(MobileButtonInfo.Instances.MainBG.Position.X.Scale, pos.Y)
                    end
                end
            
    
                InitInfo.MobileButtons.indxs[MobileButtonInfo.Data.CurrIndex] = MobileButtonInfo
                InitInfo.MobileButtons.Buttons[MobileButtonInfo.Flag] = MobileButtonInfo
                return MobileButtonInfo
            end
        end
    
        InitInfo.Objects.DropShadow = Instance.new("ImageLabel", InitInfo.Objects.MainFrame)
        InitInfo.Objects.DropShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.DropShadow.BackgroundTransparency = 1
        InitInfo.Objects.DropShadow.BorderSizePixel = 0
        InitInfo.Objects.DropShadow.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.DropShadow.Size = UDim2.new(1, 88, 1, 88)
        InitInfo.Objects.DropShadow.ZIndex = -10
        InitInfo.Objects.DropShadow.Image = "rbxassetid://16286730454"
        InitInfo.Objects.DropShadow.ScaleType = Enum.ScaleType.Slice
        InitInfo.Objects.DropShadow.SliceCenter = Rect.new(512, 512, 512, 512)
        InitInfo.Objects.DropShadow.SliceScale = 0.19
    
        local ZoomFrame = Instance.new("Frame", InitInfo.Objects.MainFrame)
        ZoomFrame.Size = UDim2.fromScale(1, 1)
        ZoomFrame.BackgroundTransparency = 1
        ZoomFrame.ZIndex = 100000
        table.insert(SpaceUI.Connections, ZoomFrame.MouseWheelForward:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) and SpaceUI.Background.Objects.MainFrame.Visible then
                SpaceUI.Config.UI.Scale = SpaceUI.Config.UI.Scale + 0.05
                if SpaceUI.Config.UI.Scale > 3 then
                    SpaceUI.Config.UI.Scale = 3
                end
                InitInfo.Objects.MainScreenGuiScale.Scale = SpaceUI.Config.UI.Scale
                Assets.Config.Save("UI", SpaceUI.Config.UI)
            end
        end))
    
        table.insert(SpaceUI.Connections, ZoomFrame.MouseWheelBackward:Connect(function()
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) and SpaceUI.Background.Objects.MainFrame.Visible then
                SpaceUI.Config.UI.Scale = SpaceUI.Config.UI.Scale - 0.05
                if SpaceUI.Config.UI.Scale < 0.4 then
                    SpaceUI.Config.UI.Scale = 0.4
                end
                InitInfo.Objects.MainScreenGuiScale.Scale = SpaceUI.Config.UI.Scale
                Assets.Config.Save("UI", SpaceUI.Config.UI)
            end
        end))

        -- API để chỉnh Scale UI bằng tay (vd sau khi auto-scale mobile đã set giá trị
        -- ban đầu, người dùng hoặc script khác vẫn có thể ép lại 1 giá trị cụ thể).
        -- Dùng chung khoảng clamp 0.4 - 3 với scroll wheel để nhất quán.
        Assets.Functions.SetScale = function(value: number)
            value = math.clamp(value, 0.4, 3)
            SpaceUI.Config.UI.Scale = value
            InitInfo.Objects.MainScreenGuiScale.Scale = value
            Assets.Config.Save("UI", SpaceUI.Config.UI)
            return value
        end
    
        InitInfo.Objects.NavigationButtons = Instance.new("Frame", InitInfo.Objects.MainFrame)
        InitInfo.Objects.NavigationButtons.BackgroundTransparency = 1
        InitInfo.Objects.NavigationButtons.Position = UDim2.fromScale(0.025, 0.091)
        InitInfo.Objects.NavigationButtons.Size = UDim2.fromScale(0.074, 0.058)
        InitInfo.Objects.NavigationButtons.BorderSizePixel = 0
        local navlist = Instance.new("UIListLayout", InitInfo.Objects.NavigationButtons)
        navlist.Padding = UDim.new(0, 10)
        navlist.FillDirection = Enum.FillDirection.Horizontal
    
        InitInfo.Objects.WindowControls = Instance.new("CanvasGroup", InitInfo.Objects.MainFrame)
        InitInfo.Objects.WindowControls.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.WindowControls.BackgroundTransparency = 1
        InitInfo.Objects.WindowControls.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.WindowControls.Size = UDim2.fromScale(1, 1)
        InitInfo.Objects.WindowControls.ZIndex = 2
    
        local MainControlsWindow = Instance.new("Frame", InitInfo.Objects.WindowControls)
        MainControlsWindow.AnchorPoint = Vector2.new(1, 1)
        MainControlsWindow.BackgroundTransparency = 1
        MainControlsWindow.Position = UDim2.fromScale(1, 1)
        MainControlsWindow.Size = UDim2.fromOffset(100, 50)
    
        local MainWindowControlList = Instance.new("UIListLayout", MainControlsWindow)
        MainWindowControlList.FillDirection = Enum.FillDirection.Horizontal
        MainWindowControlList.SortOrder = Enum.SortOrder.LayoutOrder
        MainWindowControlList.HorizontalFlex = Enum.UIFlexAlignment.Fill
    
    
        InitInfo.Functions.CreateNavigationButton = function(Data: any)
            local buttondata = {
                Button = nil,
                Name = Data.Name or "Button",
                Icon = Data.Icon or "",
                Callback = Data.Callback or function() end
            }
    
            buttondata.Button = Instance.new("ImageButton", InitInfo.Objects.NavigationButtons)
            buttondata.Button.AutoButtonColor = false
            buttondata.Button.BackgroundTransparency = 0.9
            buttondata.Button.Size = UDim2.fromOffset(40, 40)
            buttondata.Button.Image = ""
            Instance.new("UICorner",buttondata.Button).CornerRadius = UDim.new(1,0)
    
            local hovergradient = Instance.new("UIGradient", buttondata.Button)
            hovergradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0,0), NumberSequenceKeypoint.new(1, 0.331, 0)}
            hovergradient.Enabled = false
    
            local iconimage = Instance.new("ImageLabel", buttondata.Button)
            iconimage.AnchorPoint = Vector2.new(0.5, 0.5)
            iconimage.BackgroundTransparency = 1
            iconimage.BorderSizePixel = 0
            iconimage.Position = UDim2.fromScale(0.5, 0.5)
            iconimage.Size = UDim2.fromScale(0.45, 0.45)
            iconimage.Image = buttondata.Icon
            local iconscale = Instance.new("UIScale", iconimage)
    
            table.insert(SpaceUI.Connections, buttondata.Button.MouseEnter:Connect(function()
                hovergradient.Enabled = true
                TweenService:Create(iconscale, TweenInfo.new(0.15), {Scale = 1.2}):Play()
            end))
            table.insert(SpaceUI.Connections, buttondata.Button.MouseLeave:Connect(function()
                hovergradient.Enabled = false
                TweenService:Create(iconscale, TweenInfo.new(0.15), {Scale = 1}):Play()
            end))
            table.insert(SpaceUI.Connections, buttondata.Button.MouseButton1Click:Connect(function() 
                buttondata.Callback(buttondata)
                TweenService:Create(iconscale, TweenInfo.new(0.15), {Scale = 1.4}):Play()
                task.wait(0.15)
                TweenService:Create(iconscale, TweenInfo.new(0.15), {Scale = 1}):Play()
            end))
    
            InitInfo.NavigationButtons[Data.Name] = buttondata
            return buttondata
        end
    
        InitInfo.Functions.CreateWindowControlButton = function(Data: any)
            local buttondata = {
                Name = Data.Name or "Button",
                Icon = Data.Icon or "",
                Drag = Data.IsDrag or false,
                LayoutOrder = Data.LayoutOrder or 1,
                Visible = Data.Visible or false,
                Objects = {Button = nil, Selection = nil},
                Callbacks = Data.Callbacks or {Clicked = function() end, InputBegan = function() end}
            }
    
            local HasInput = true
            if not buttondata.Callbacks.Clicked then
                buttondata.Callbacks.Clicked = function() end
            elseif not buttondata.Callbacks.InputBegan then
                HasInput = false
                buttondata.Callbacks.InputBegan = function() end
            elseif not buttondata.Callbacks.InputBegan and not buttondata.Callbacks.Clicked then
                HasInput = false
                buttondata.Callbacks.InputBegan = function() end
                buttondata.Callbacks.Clicked = function() end
            end
    
            if buttondata.Drag then
                buttondata.Objects.Button = Instance.new("ImageButton", InitInfo.Objects.WindowControls)
                buttondata.Objects.Button.AnchorPoint = Vector2.new(0.5, 0)
                buttondata.Objects.Button.AutoButtonColor = false
                buttondata.Objects.Button.BackgroundTransparency = 1
                buttondata.Objects.Button.BorderSizePixel = 0
                buttondata.Objects.Button.Position = UDim2.fromScale(0.5, 0)
                buttondata.Objects.Button.Size = UDim2.fromOffset(60, 40)
                buttondata.Objects.Button.ZIndex = 10
                
                local dragicon = Instance.new("ImageLabel", buttondata.Objects.Button)
                dragicon.AnchorPoint = Vector2.new(0.5, 0)
                dragicon.BackgroundTransparency = 1
                dragicon.BorderSizePixel = 0
                dragicon.Position = UDim2.fromScale(0.5, 0)
                dragicon.Size = UDim2.fromScale(1, 0.75)
                dragicon.ZIndex = 10
                dragicon.Image = "rbxassetid://12974354535"
                dragicon.ImageTransparency = 0.5
                dragicon.ScaleType = Enum.ScaleType.Fit
    
                table.insert(SpaceUI.Connections, buttondata.Objects.Button.MouseButton1Click:Connect(function()
                    buttondata.Callbacks.Clicked(buttondata)
                end))
            else
                buttondata.Objects.Button = Instance.new("ImageButton", MainControlsWindow)
                buttondata.Objects.Button.AutoButtonColor = false
                buttondata.Objects.Button.BackgroundTransparency = 1
                buttondata.Objects.Button.LayoutOrder = buttondata.LayoutOrder
                buttondata.Objects.Button.Size = UDim2.fromOffset(50, 50)
                buttondata.Objects.Button.ZIndex = 10
        
                buttondata.Objects.ActualIcon = Instance.new("ImageLabel", buttondata.Objects.Button)
                buttondata.Objects.ActualIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                buttondata.Objects.ActualIcon.BackgroundTransparency = 1
                buttondata.Objects.ActualIcon.BorderSizePixel = 0
                buttondata.Objects.ActualIcon.Position = UDim2.fromScale(0.5, 0.5)
                buttondata.Objects.ActualIcon.Size = UDim2.fromOffset(20, 20)
                buttondata.Objects.ActualIcon.Image = buttondata.Icon
                buttondata.Objects.ActualIcon.ImageTransparency = 0.2
                buttondata.Objects.ActualIcon.ScaleType = Enum.ScaleType.Fit
                local ActualIconScale = Instance.new("UIScale", buttondata.Objects.ActualIcon)
        
                buttondata.Objects.Selection = Instance.new("ImageLabel", buttondata.Objects.Button)
                buttondata.Objects.Selection.AnchorPoint = Vector2.new(0.5, 0.5)
                buttondata.Objects.Selection.BackgroundTransparency = 1
                buttondata.Objects.Selection.BorderSizePixel = 0
                buttondata.Objects.Selection.Position = UDim2.fromScale(0.5, 0.5)
                buttondata.Objects.Selection.Size = UDim2.fromOffset(40, 40)
                buttondata.Objects.Selection.Image = "rbxassetid://18412474498"
                buttondata.Objects.Selection.ImageTransparency = 1
                buttondata.Objects.Selection.ScaleType = Enum.ScaleType.Fit
    
                table.insert(SpaceUI.Connections, buttondata.Objects.Button.MouseButton1Click:Connect(function()
                    buttondata.Callbacks.Clicked(buttondata)
                    TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 0.5}):Play()
        
                    TweenService:Create(buttondata.Objects.Selection, TweenInfo.new(0.15), {ImageTransparency = 0.9}):Play()
                    TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 1}):Play()
                end))
    
                if not SpaceUI.Mobile then
                    table.insert(SpaceUI.Connections, buttondata.Objects.Button.MouseEnter:Connect(function()
                        buttondata.Objects.Selection.ImageTransparency = 1
                        ActualIconScale.Scale = 1.2
    
                        TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 1.2}):Play()
                        TweenService:Create(buttondata.Objects.Selection, TweenInfo.new(0.15), {ImageTransparency = 0.8}):Play()
                    end))

                    -- Hover-press: scale xuống lúc giữ chuột, trước khi Callbacks.Clicked chạy
                    -- (port từ window_handler bản gốc: controls.resize.MouseButton1Down)
                    table.insert(SpaceUI.Connections, buttondata.Objects.Button.MouseButton1Down:Connect(function()
                        TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 0.5}):Play()

                        TweenService:Create(buttondata.Objects.Selection, TweenInfo.new(0.15), {ImageTransparency = 0.9}):Play()
                    end))
    
                    table.insert(SpaceUI.Connections, buttondata.Objects.Button.MouseLeave:Connect(function()
                        TweenService:Create(ActualIconScale, TweenInfo.new(0.15), {Scale = 1}):Play()
                        TweenService:Create(buttondata.Objects.Selection, TweenInfo.new(0.15), {ImageTransparency = 1}):Play()
                        task.wait(0.15)
                        buttondata.Objects.Selection.ImageTransparency = 1
                        ActualIconScale.Scale = 1
                    end))
                end
    
            end
    
            if HasInput then
                table.insert(SpaceUI.Connections, buttondata.Objects.Button.InputBegan:Connect(buttondata.Callbacks.InputBegan))
            end
        
            InitInfo.WindowControls.Instances[buttondata.Name] = buttondata
            return buttondata
        end
    
        table.insert(SpaceUI.Connections, UserInputService.InputEnded:Connect(function(input)
            if SpaceUI.InputEndFunc then
                SpaceUI.InputEndFunc(input)
            end
        end))
    
        InitInfo.Functions.Resize = function(input : InputObject)
            if InitInfo.Data.Resizing and not SpaceUI.Config.UI.FullScreen then
                if not UserCamera then return end
                local delta = input.Position - InitInfo.Data.LastInputPosition
        
                local sensitivity = 0.008
        
                local scaleX = delta.X * sensitivity
                local scaleY = delta.Y * sensitivity
        
                local minScale = 0.15
                local maxScaleX = 0.95
                local maxScaleY = 0.95
        
                local newScaleX = math.clamp(InitInfo.Objects.MainFrame.Size.X.Scale + scaleX, minScale, maxScaleX)
                local newScaleY = math.clamp(InitInfo.Objects.MainFrame.Size.Y.Scale + scaleY, minScale, maxScaleY)
        
                TweenService:Create(InitInfo.Objects.MainFrame, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Size = UDim2.fromScale(newScaleX, newScaleY)}):Play()
                InitInfo.Data.LastInputPosition = input.Position
                SpaceUI.Config.UI.Size = {X = newScaleX, Y = newScaleY}
            end
        end
    
        InitInfo.Functions.Drag = function(mouseStart: Vector2 | Vector3 | nil, frameStart: UDim2, input: InputObject?)
            -- lowww taper fadeee
            pcall(function()
                if UserCamera then
                    local Viewport = UserCamera.ViewportSize
                    local Delta = Vector2.new(0, 0)
                    local FrameSize = InitInfo.Objects.MainFrame.AbsoluteSize
                    if mouseStart and input then
                        Delta = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(mouseStart.X, mouseStart.Y))
                    end
        
                    local newX = math.clamp(frameStart.X.Scale + (Delta.X / Viewport.X), FrameSize.X / Viewport.X / 2, 1 - FrameSize.X / Viewport.X / 2)
                    local newY = math.clamp(frameStart.Y.Scale + (Delta.Y / Viewport.Y), FrameSize.Y / Viewport.Y / 2, 1 - FrameSize.Y / Viewport.Y / 2)
        
                    local Position = UDim2.new(newX, 0, newY, 0)
                    InitInfo.Objects.MainFrame.Position = Position
    
                    SpaceUI.Config.UI.Position = {X = newX, Y = newY}
                end
            end)
        end
    
    
        SpaceUI.CurrntInputChangeCallback = function() end 
        table.insert(SpaceUI.Connections, UserInputService.InputChanged:Connect(function(input)
            SpaceUI.CurrntInputChangeCallback(input)
        end))
    
    
        InitInfo.Functions.CreateNavigationButton({
            Name = "Close", 
            Icon = "rbxassetid://11293981586", 
            Callback = function()
                if Assets.Main and Assets.Main.ToggleVisibility then
                    Assets.Main.ToggleVisibility(false)
                    Assets.Notifications.Send({
                        Description = "SpaceUI Library has been minimized!",
                        Duration = 5
                    })
                end
            end
        })
    
        local forcefullscreen = false
        InitInfo.Functions.CreateWindowControlButton({
            Name = "FullScreen", 
            Icon = "rbxassetid://11295287158", 
            LayoutOrder = 1, 
            Callbacks = {
                Clicked = function(self)
                    if not forcefullscreen then
                        SpaceUI.Config.UI.FullScreen = not SpaceUI.Config.UI.FullScreen
                    end
                    
                    if SpaceUI.Config.UI.FullScreen or forcefullscreen then
                        if not forcefullscreen then
                            SpaceUI.Config.UI.Position = {X = InitInfo.Objects.MainFrame.Position.X.Scale, Y = InitInfo.Objects.MainFrame.Position.Y.Scale}
                            SpaceUI.Config.UI.Size = {X = InitInfo.Objects.MainFrame.Size.X.Scale, Y = InitInfo.Objects.MainFrame.Size.Y.Scale}
                            SpaceUI.Config.UI.Scale = InitInfo.Objects.MainFrameScale.Scale
                        else
                            SpaceUI.Config.UI.FullScreen = true
                            forcefullscreen = false
                        end
    
                        TweenService:Create(InitInfo.Objects.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(.5, .5), Size = UDim2.fromScale(1, 1)}):Play()
                        for i,v in SpaceUI.Corners do
                            TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {CornerRadius = UDim.new(0, 0)}):Play()
                        end
                        TweenService:Create(InitInfo.Objects.MainFrameScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = 1}):Play()
                        self.Objects.ActualIcon.Image = "rbxassetid://11422140434"
                        InitInfo.WindowControls.Instances.Resize.Objects.ActualIcon.ImageTransparency = 0.5
                    else
                        self.Objects.ActualIcon.Image = "rbxassetid://11295287158"
                        InitInfo.WindowControls.Instances.Resize.Objects.ActualIcon.ImageTransparency = 0.2
                        TweenService:Create(InitInfo.Objects.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(SpaceUI.Config.UI.Position.X, SpaceUI.Config.UI.Position.Y), Size = UDim2.fromScale(SpaceUI.Config.UI.Size.X, SpaceUI.Config.UI.Size.Y)}):Play()
                        for i,v in SpaceUI.Corners do
                            TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {CornerRadius = UDim.new(0, 20)}):Play()
                        end
                        TweenService:Create(InitInfo.Objects.MainFrameScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = SpaceUI.Config.UI.Scale}):Play()
                    end
                
                    Assets.Config.Save("UI", SpaceUI.Config.UI)
                    
                end
            }
        })
    
    
        local InputStarting, FrameStarting = nil, nil
        InitInfo.Functions.CreateWindowControlButton({
            Name = "Drag", 
            IsDrag = true, 
            Callbacks = {
                InputBegan = function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                        if SpaceUI.Config.UI.FullScreen then 
    
                            SpaceUI.Config.UI.FullScreen = false
    
                            InitInfo.WindowControls.Instances.FullScreen.Objects.ActualIcon.Image = "rbxassetid://11295287158"
                            InitInfo.WindowControls.Instances.Resize.Objects.ActualIcon.ImageTransparency = 0.2
    
                            TweenService:Create(InitInfo.Objects.MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(SpaceUI.Config.UI.Position.X, SpaceUI.Config.UI.Position.Y), Size = UDim2.fromScale(SpaceUI.Config.UI.Size.X, SpaceUI.Config.UI.Size.Y)}):Play()
                            for i,v in SpaceUI.Corners do
                                TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {CornerRadius = UDim.new(0, 20)}):Play()
                            end
                            TweenService:Create(InitInfo.Objects.MainFrameScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = SpaceUI.Config.UI.Scale}):Play()
                        end
    
                        InitInfo.Data.Dragging, InputStarting, FrameStarting = true, input.Position, InitInfo.Objects.MainFrame.Position
                        SpaceUI.CurrntInputChangeCallback = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
                                if InitInfo.Data.Dragging and not SpaceUI.Config.UI.FullScreen then
                                    InitInfo.Functions.Drag(InputStarting, FrameStarting, input)
                                end
                            end
                        end
                        SpaceUI.InputEndFunc = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                                InitInfo.Data.Dragging, InputStarting, FrameStarting = false, input.Position, InitInfo.Objects.MainFrame.Position
                                SpaceUI.CurrntInputChangeCallback = function() end
                                Assets.Config.Save("UI", SpaceUI.Config.UI)
                                SpaceUI.InputEndFunc = nil
                            end
                        end
                    end
                end,
                Clicked = function(self)
                    SpaceUI.ControlsVisible = not SpaceUI.ControlsVisible
                    if SpaceUI.ControlsVisible then
                        MainControlsWindow.Visible = true
                        TweenService:Create(MainControlsWindow, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(1, 1), Size = UDim2.fromOffset(100, 50)}):Play()
                    else
                        TweenService:Create(MainControlsWindow, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, 100, 1, 0), Size = UDim2.fromOffset(50, 50)}):Play()
                        task.wait(0.5)
                        MainControlsWindow.Visible = false
                    end
                end
            }
        })
    
        InitInfo.Functions.CreateWindowControlButton({
            Name = "Resize", 
            Icon = "rbxassetid://11295287825", 
            LayoutOrder = 2, 
            Callbacks = {
                InputBegan = function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                        InitInfo.Data.LastInputPosition, InitInfo.Data.Resizing = input.Position, true
                        SpaceUI.CurrntInputChangeCallback = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                                InitInfo.Functions.Resize(input)
                            end
                        end
                        SpaceUI.InputEndFunc = function(input)
                            if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                                InitInfo.Data.Resizing = false
                                SpaceUI.CurrntInputChangeCallback = function() end
                                Assets.Config.Save("UI", SpaceUI.Config.UI)
                                SpaceUI.InputEndFunc = function() end
                            end
                        end
                    end
                end
            }
        })
    
        if SpaceUI.Config.UI.FullScreen then
            forcefullscreen = true
            InitInfo.WindowControls.Instances.FullScreen.Callbacks.Clicked(InitInfo.WindowControls.Instances.FullScreen)
        end
    
        return InitInfo
    end
        
end

do 
    Assets.ArrayList.Init = function()
        local Data = {
            Entries = {},
            Connections = {},
            Functions = {},
            RainbowSpeed = 5000,
            Loaded = true,
            Objects = SpaceUI.ArrayList.Objects
        }


        local Create = function(Class: string, Properties: { [string]: any }): Instance
            local Inst = Instance.new(Class)
            
            for Index, Value in next, Properties do
                if Index ~= 'Children' then
                    Inst[Index] = Value
                end
            end
            
            if Properties.Children then
                for Index, Child in Properties.Children do
                    Child.Name = Index
                    Child.Parent = Inst
                end
            end
            
            return Inst
        end

        local TEXT_SIZE = if SpaceUI.Mobile then 16 else 24
        
        local download = Assets.Font.Download("Product-Sans-Regular", "https://raw.githubusercontent.com/warprbx/HubRewrite/refs/heads/main/Hub/Assets/Fonts/Product-Sans-Regular.ttf")
        if not download then
            return 
        end

        local product_sans_id = Assets.Font.create_family("ProductSans", {
            {
                name = "Regular",
                weight = 400,
                file = "SpaceUI/Assets/Fonts/Product-Sans-Regular.ttf",
            },
        })
        local font = Font.new(product_sans_id)

        type EntryInstance = Frame & {
            Line: Frame,
            MainText: TextLabel
        }
        
        type ModuleEntry = {
            Name: string,
            Instance: EntryInstance?,
        }
        
        local Template = Create("Frame", {
            BackgroundColor3 = Color3.new(),
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(0, 30),
            
            Children = {
                Line = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.fromScale(1, 0),
                    Size = UDim2.new(0, 2, 1, 0),
                    BorderSizePixel = 0,
                }),
                MainText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    FontFace = font,
                    Text = '',
                    TextColor3 = Color3.fromRGB(239, 239, 239),
                    TextSize = TEXT_SIZE,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.fromScale(1, 1),
                }),
                UIPadding = Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 6)
                })
            }
        })
        
        local Holder = Create("Frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 10),
            Size = UDim2.new(0.5, 0, 1, -10),
            Children = {
                UIListLayout = Create("UIListLayout", {
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            },
        })


        function Data.Functions.PushModule(Entry: ModuleEntry)
            local EntryInstance = Template:Clone()
            local MainText = EntryInstance.MainText
            local MainSize = GetTextBounds(Entry.Name, font, TEXT_SIZE)
            
            MainText.Text = Entry.Name
            
            local XSize = MainSize.X + 14
            local YSize = TEXT_SIZE + 6
            
            MainText.Size = UDim2.new(0, MainSize.X, 1, 0)
            
            EntryInstance.Size = UDim2.fromOffset(XSize, YSize)
            EntryInstance.LayoutOrder = #Data.Entries
            EntryInstance.Parent = Holder
                        
            local Index = #Data.Entries + 1
            local _Entry
            _Entry = {
                Name = Entry.Name,
                Instance = EntryInstance,
                Index = Index,
                Deconstruct = function()
                    _Entry.Instance:Destroy()
                    Entry.Instance = nil
                    local Index = table.find(Data.Entries, _Entry)
                    if Index then
                        table.remove(Data.Entries, Index)
                    end
                    Data.Functions.Resort()
                end
                
            }
            
            Data.Entries[Index] = _Entry
            
            Data.Functions.Resort()
            
            return _Entry
        end


        function Data.Functions.Resort()
            table.sort(Data.Entries, function(a: ModuleEntry, b: ModuleEntry)
                local TotalTextA = a.Name
                local TotalTextB = b.Name
                
                local SizeA = GetTextBounds(TotalTextA, font, TEXT_SIZE)
                local SizeB = GetTextBounds(TotalTextB, font, TEXT_SIZE)
        
                return SizeA.X > SizeB.X
            end)
            
            for Index, Entry in next, Data.Entries do
                Entry.Instance.LayoutOrder = Index
            end
        end

        local function Rainbow(Delay: number)
            local time = (os.clock() * 1000 + Delay) / 1000
            local hue = (math.sin(time * 0.5) * 40 + 240) 
            local saturation = math.sin(time * 0.3) * 0.1 + 0.35
            local value = 0.95
            
            return Color3.fromHSV(hue / 360, saturation, value)
        end
        
        local function ArrayListRainbow()
            local Speed = Data.RainbowSpeed
            
            for i, Module in Data.Entries do
                local Color = Rainbow(Speed - i * 250) 
                Module.Instance.MainText.TextColor3 = Color
                Module.Instance.Line.BackgroundColor3 = Color
            end
        end

        function Data.Functions.Toggle(visible: boolean)
            SpaceUI.ArrayList.Objects.ArrayGui.Enabled = visible
            if not visible then
                for i,v in Data.Connections do
                    if table.find(SpaceUI.Connections, v) then
                        table.remove(SpaceUI.Connections, table.find(SpaceUI.Connections, v))
                    end
                    v:Disconnect()
                    Data.Connections[i] = nil
                end
            else
                if not Data.Connections.Rainbow then
                    local r = game:GetService("RunService").RenderStepped:Connect(ArrayListRainbow)
                    table.insert(Data.Connections, r)
                    table.insert(SpaceUI.Connections, r)
                end
            end
        end

        Holder.Parent = SpaceUI.ArrayList.Objects.ArrayGui

        SpaceUI.ArrayList = Data
        return Data
    end
end

do
    
    Assets.Pages.Init = function()
        local InitInfo = {
            Objects = {},
            Data = {},
            Functions = {},
            Connections = {}
        }  
    
        InitInfo.Objects.Pageselector = Instance.new("Frame", SpaceUI.Background.Objects.MainFrame)
        InitInfo.Objects.Pageselector.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.Pageselector.BackgroundTransparency = 0.9
        InitInfo.Objects.Pageselector.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.Pageselector.Size = UDim2.fromScale(1, 1)
        InitInfo.Objects.Pageselector.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        InitInfo.Objects.Pageselector.ZIndex = 40
        InitInfo.Objects.Pageselector.Visible = false
        InitInfo.Objects.Pageselector.ClipsDescendants = false
        InitInfo.Objects.Pageselector.BackgroundTransparency = 1
    
    
        InitInfo.Objects.PageselectorCorner = Instance.new("UICorner", InitInfo.Objects.Pageselector)
        InitInfo.Objects.PageselectorCorner.CornerRadius = UDim.new(0, 20)
        table.insert(SpaceUI.Corners, InitInfo.Objects.PageselectorCorner)
    
        local MainPageselectorMenu = Instance.new("ImageLabel", InitInfo.Objects.Pageselector)
        MainPageselectorMenu.AnchorPoint = Vector2.new(0.5, 0.5)
        MainPageselectorMenu.BackgroundColor3 = Color3.fromRGB(62, 62, 62)
        MainPageselectorMenu.Position = UDim2.new(0, -10, 0.5, 0)
        MainPageselectorMenu.Size = UDim2.new(0, 60, 0, 180)
        MainPageselectorMenu.Image = "rbxassetid://16255699706"
        MainPageselectorMenu.ImageTransparency = 0.8
        MainPageselectorMenu.ScaleType = Enum.ScaleType.Crop
        Instance.new("UICorner", MainPageselectorMenu).CornerRadius = UDim.new(1, 0)
        InitInfo.Objects.MainPageselectorScale = Instance.new("UIScale", MainPageselectorMenu)
        InitInfo.Objects.MainPageselectorScale.Scale = 0.5
        MainPageselectorMenu.ZIndex = 40
        
        local PageselectorShadow = Instance.new("ImageLabel", MainPageselectorMenu)
        PageselectorShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        PageselectorShadow.BackgroundTransparency = 1
        PageselectorShadow.Position = UDim2.fromScale(0.5, 0.5)
        PageselectorShadow.Size = UDim2.new(1, 50, 1, 50)
        PageselectorShadow.Image = "rbxassetid://16264499577"
        PageselectorShadow.ImageTransparency = 0.8
        PageselectorShadow.ScaleType = Enum.ScaleType.Slice
        PageselectorShadow.SliceCenter = Rect.new(379, 379, 379, 379)
    
        InitInfo.Objects.PageselectorButtons = Instance.new("Frame", MainPageselectorMenu)
        InitInfo.Objects.PageselectorButtons.AnchorPoint = Vector2.new(0.5, 0.5)
        InitInfo.Objects.PageselectorButtons.BackgroundTransparency = 1
        InitInfo.Objects.PageselectorButtons.Position = UDim2.fromScale(0.5, 0.5)
        InitInfo.Objects.PageselectorButtons.Size = UDim2.fromScale(1, 1)
        InitInfo.Objects.PageselectorButtons.ZIndex = 40
    
        local PageselectorButtonsLayout = Instance.new("UIListLayout", InitInfo.Objects.PageselectorButtons)
        PageselectorButtonsLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageselectorButtonsLayout.Padding = UDim.new(0, 10)
        PageselectorButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        PageselectorButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
        InitInfo.Functions.ToggleSelectorVisibility = function(visible)
            if visible then
                InitInfo.Objects.Pageselector.Visible = true
                InitInfo.Objects.MainPageselectorScale.Scale = 0.5
                InitInfo.Objects.PageselectorButtons.Parent.Position = UDim2.new(0,0,0.5,0)
                InitInfo.Objects.Pageselector.ClipsDescendants = true
                InitInfo.Objects.Pageselector.BackgroundTransparency = 1
        
                TweenService:Create(InitInfo.Objects.Pageselector, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.9}):Play()
                TweenService:Create(InitInfo.Objects.PageselectorButtons.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, 60, 0.5, 0)}):Play()
                TweenService:Create(InitInfo.Objects.MainPageselectorScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = 1}):Play()
        
            else
                TweenService:Create(InitInfo.Objects.Pageselector, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
                TweenService:Create(InitInfo.Objects.PageselectorButtons.Parent, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Position = UDim2.new(0, -10, 0.5, 0)}):Play()
                TweenService:Create(InitInfo.Objects.MainPageselectorScale, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Scale = 0.5}):Play()
                task.wait(0.15)
                InitInfo.Objects.Pageselector.Visible = false
                InitInfo.Objects.Pageselector.ClipsDescendants = false
            end
        end

    
        SpaceUI.Background.Functions.CreateNavigationButton({
            Name = "Menu", 
            Icon = "rbxassetid://11295285432", 
            Callback = function()
                InitInfo.Functions.ToggleSelectorVisibility(not SpaceUI.Pageselector.Objects.Pageselector.Visible)
            end
        })
    
        SpaceUI.Pageselector = InitInfo
        return InitInfo
    end
    
    Assets.Pages.NewPage = function(Data)
        local PageData = {
            Name = Data.Name or "New Page",
            Icon = Data.Icon or "",
            Objects = {},
            Connections = {},
            Default = Data.Default,
            Selected = Data.Default
        }
    
        if not SpaceUI.Pageselector then Assets.Pages.Init() end
        PageData.Objects.PageselectorButton = Instance.new("ImageButton", SpaceUI.Pageselector.Objects.PageselectorButtons)
        PageData.Objects.PageselectorButton.BackgroundColor3 = Color3.fromRGB(255,255,255)
        PageData.Objects.PageselectorButton.BackgroundTransparency = 1
        PageData.Objects.PageselectorButton.Position = UDim2.fromScale(0.5, 0.5)
        PageData.Objects.PageselectorButton.Size = UDim2.new(0, 50, 0, 50)
        PageData.Objects.PageselectorButton.AutoButtonColor = false
        PageData.Objects.PageselectorButton.ZIndex = 40
        PageData.Objects.PageselectorButton.AutoButtonColor = false
        Instance.new("UICorner", PageData.Objects.PageselectorButton).CornerRadius = UDim.new(1, 0)
        
        local PageselectorButtonIcon = Instance.new("ImageLabel", PageData.Objects.PageselectorButton)
        PageselectorButtonIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        PageselectorButtonIcon.BackgroundTransparency = 1
        PageselectorButtonIcon.Position = UDim2.fromScale(0.5, 0.5)
        PageselectorButtonIcon.Size = UDim2.new(0, 24, 0, 24)
        PageselectorButtonIcon.Image = PageData.Icon
        PageselectorButtonIcon.ImageTransparency = 0.2
        PageselectorButtonIcon.ScaleType = Enum.ScaleType.Fit
        PageselectorButtonIcon.ZIndex = 40
    
        local PageSelectorButtonIconScale = Instance.new("UIScale", PageselectorButtonIcon) 
    
        PageData.Objects.ActualPage = Instance.new("CanvasGroup", SpaceUI.Background.Objects.PageHolder)
        PageData.Objects.ActualPage.AnchorPoint = Vector2.new(0.5, 1)
        PageData.Objects.ActualPage.BackgroundTransparency = 1
        PageData.Objects.ActualPage.Position = UDim2.fromScale(0.5, 1)
        PageData.Objects.ActualPage.Size = UDim2.fromScale(1, 1)
        PageData.Objects.ActualPage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        PageData.Objects.ActualPage.Visible = PageData.Default
        PageData.Objects.ActualPage.ClipsDescendants = true
        if not PageData.Default then
            PageData.Objects.ActualPage.GroupTransparency = 1
            PageData.Objects.ActualPage.Position = UDim2.new(0.5, 0, 1.2, 0)
        end
        
        local Pagepad = Instance.new("UIPadding", PageData.Objects.ActualPage)
        Pagepad.PaddingBottom = UDim.new(0, 20)
        Pagepad.PaddingLeft = UDim.new(0, 10)
        Pagepad.PaddingRight = UDim.new(0, 10)
        Pagepad.PaddingTop = UDim.new(0, 10)
    
        local Header = Instance.new("TextLabel", PageData.Objects.ActualPage)
        Header.AnchorPoint = Vector2.new(0.5, 0)
        Header.BackgroundTransparency = 1
        Header.Position = UDim2.new(0.5, 0, 0, 20)
        Header.Size = UDim2.new(1, 0, 0, 40)
        Header.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
        Header.Text = PageData.Name
        Header.TextColor3 = Color3.fromRGB(255, 255, 255)
        Header.TextSize = 22
        Header.TextXAlignment = Enum.TextXAlignment.Center
    
        local MainFrameScrollPage = Instance.new("ScrollingFrame", PageData.Objects.ActualPage)
        MainFrameScrollPage.AnchorPoint = Vector2.new(0.5, 1)
        MainFrameScrollPage.BackgroundTransparency = 1
        MainFrameScrollPage.Position = UDim2.new(0.5, 0, 1, 30)
        MainFrameScrollPage.Size = UDim2.new(1, 0, 0.87, 0)
        MainFrameScrollPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        MainFrameScrollPage.ScrollBarThickness = 2
        MainFrameScrollPage.ScrollBarImageTransparency = 0.8
        MainFrameScrollPage.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        MainFrameScrollPage.BorderSizePixel = 0
        MainFrameScrollPage.ClipsDescendants = true
        MainFrameScrollPage.CanvasSize = UDim2.new(0,0,0,0)
        MainFrameScrollPage.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
    
        local ScrollPad = Instance.new("UIPadding", MainFrameScrollPage)
        ScrollPad.PaddingBottom = UDim.new(0, 20)
        ScrollPad.PaddingLeft = UDim.new(0, 10)
        ScrollPad.PaddingRight = UDim.new(0, 10)
        ScrollPad.PaddingTop = UDim.new(0, 5)
    
        local ScrollList = Instance.new("UIListLayout", MainFrameScrollPage)
        ScrollList.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollList.Padding = UDim.new(0, 10)
        ScrollList.VerticalAlignment = Enum.VerticalAlignment.Top
        ScrollList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
        table.insert(SpaceUI.Connections, PageData.Objects.PageselectorButton.MouseEnter:Connect(function()
            TweenService:Create(PageData.Objects.PageselectorButton, TweenInfo.new(0.1), {BackgroundTransparency = 0.8}):Play()
            TweenService:Create(PageSelectorButtonIconScale, TweenInfo.new(0.1), {Scale = 1.4}):Play()
        end))
    
        table.insert(SpaceUI.Connections, PageData.Objects.PageselectorButton.MouseLeave:Connect(function()
            TweenService:Create(PageData.Objects.PageselectorButton, TweenInfo.new(0.1), {BackgroundTransparency = 1}):Play()
            TweenService:Create(PageSelectorButtonIconScale, TweenInfo.new(0.1), {Scale = 1}):Play()
        end))
    
        table.insert(SpaceUI.Connections, PageData.Objects.PageselectorButton.MouseButton1Click:Connect(function()  
            SpaceUI.Pageselector.Functions.ToggleSelectorVisibility(false)
            for i,v in SpaceUI.Pages do
                if v.Objects and v.Objects.ActualPage then
                    if v.Objects.ActualPage ~= PageData.Objects.ActualPage then
                        v.Selected = false
                        v.Objects.ActualPage.Visible = false
                        TweenService:Create(v.Objects.ActualPage, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 1.2, 0), GroupTransparency = 1}):Play()
                    else
                        PageData.Selected = true
                        v.Objects.ActualPage.Visible = true
                        TweenService:Create(v.Objects.ActualPage, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 1, 0), GroupTransparency = 0}):Play()
                    end
                end
            end
        end))
    
        SpaceUI.Pages[PageData.Name] = PageData
        return PageData
    end

end

do
    Assets.Dashboard.NewTab = function(data)
        local tab = {
            Name = data and data.Name or "Tab",
            Icon = data and data.Icon or "",
            Dashboard = data and data.Dashboard or SpaceUI.Pages.Dashboard,
            TabInfo = data and data.TabInfo or "Tab",
            Opened = false,
            Objects = {},
            ClipNeeded = false,
            Tweens = {SearchBackGround = nil},
            Connections = {},
            Modules = {},
            Functions = {}, 
            Data = {Dragging = false, SettingsOpen = false, ToggleAnimating = false}
        }

        if not tab.Dashboard then return end
        tab.Objects.DashBoardButton = Instance.new("TextButton", tab.Dashboard.Objects.ActualPage:FindFirstChildWhichIsA("ScrollingFrame"))
        tab.Objects.DashBoardButton.AnchorPoint = Vector2.new(0.5, 0)
        tab.Objects.DashBoardButton.AutoButtonColor = false
        tab.Objects.DashBoardButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        tab.Objects.DashBoardButton.BackgroundTransparency = 0.7
        tab.Objects.DashBoardButton.Size = UDim2.new(1, 0, 0, 80)
        tab.Objects.DashBoardButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
        tab.Objects.DashBoardButton.Text = tab.Name
        tab.Objects.DashBoardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        tab.Objects.DashBoardButton.TextSize = 16
        tab.Objects.DashBoardButton.TextTransparency = 0.2
        tab.Objects.DashBoardButton.TextXAlignment = Enum.TextXAlignment.Left
        tab.Objects.DashBoardButton.TextYAlignment = Enum.TextYAlignment.Top
        Instance.new("UICorner", tab.Objects.DashBoardButton).CornerRadius = UDim.new(0, 12)
        local DashBoardButtonPad = Instance.new("UIPadding", tab.Objects.DashBoardButton)
        DashBoardButtonPad.PaddingBottom = UDim.new(0, 20)
        DashBoardButtonPad.PaddingLeft = UDim.new(0, 80)
        DashBoardButtonPad.PaddingRight = UDim.new(0, 15)
        DashBoardButtonPad.PaddingTop = UDim.new(0, 20)

        local uistroke = Instance.new("UIStroke", tab.Objects.DashBoardButton)
        uistroke.Color = Color3.fromRGB(255, 255, 255)
        uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        local strokegradient = Instance.new("UIGradient", uistroke)
        strokegradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(135, 135, 135)), ColorSequenceKeypoint.new(1, Color3.fromRGB(135, 135, 135))}
        strokegradient.Offset = Vector2.new(-1, 0)
        strokegradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1, 0), NumberSequenceKeypoint.new(0.5, 0, 0), NumberSequenceKeypoint.new(1, 1, 0)})

        local ButtonArrow = Instance.new("ImageLabel", tab.Objects.DashBoardButton)
        ButtonArrow.AnchorPoint = Vector2.new(1, 0.5)
        ButtonArrow.BackgroundTransparency = 1
        ButtonArrow.Position = UDim2.fromScale(1, 0.5)
        ButtonArrow.Size = UDim2.new(0, 20, 0, 20)
        ButtonArrow.Image = "rbxassetid://11419703997"
        ButtonArrow.ImageColor3 = Color3.fromRGB(255, 255, 255)
        ButtonArrow.ImageTransparency = 0.5
        ButtonArrow.ScaleType = Enum.ScaleType.Fit

        local UserIcon = Instance.new("ImageLabel", tab.Objects.DashBoardButton)
        UserIcon.AnchorPoint = Vector2.new(0, 0.5)
        UserIcon.BackgroundTransparency = 1
        UserIcon.BorderSizePixel = 0
        UserIcon.Position = UDim2.new(0, -55, 0.5, 0)
        UserIcon.Size = UDim2.fromOffset(35, 35)
        UserIcon.Image = tab.Icon
        UserIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        UserIcon.ImageTransparency = 0.2
        UserIcon.ScaleType = Enum.ScaleType.Fit

        if not tab.TabInfo then 
            tab.Objects.DashBoardButton.TextYAlignment = Enum.TextYAlignment.Center
            tab.Objects.DashBoardButton.Size = UDim2.new(1, 0, 0, 60)
        else
            local tabinfolabel = Instance.new("TextLabel", tab.Objects.DashBoardButton)
            tabinfolabel.AnchorPoint = Vector2.new(0.5, 1)
            tabinfolabel.BackgroundTransparency = 1
            tabinfolabel.Position = UDim2.fromScale(0.5, 1)
            tabinfolabel.Size = UDim2.new(1, 0, 0, 22)
            tabinfolabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
            tabinfolabel.Text = tab.TabInfo
            tabinfolabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            tabinfolabel.TextTransparency = 0.5
            tabinfolabel.TextSize = 14
            tabinfolabel.TextXAlignment = Enum.TextXAlignment.Left
            tabinfolabel.TextWrapped = true
            Instance.new("UIPadding", tabinfolabel).PaddingLeft = UDim.new(0, 20)

            local tabinfoicon = Instance.new("ImageLabel", tabinfolabel)
            tabinfoicon.AnchorPoint = Vector2.new(0, 0.5)
            tabinfoicon.BackgroundTransparency = 1
            tabinfoicon.Position = UDim2.new(0, -20, 0.5, 0)
            tabinfoicon.Size = UDim2.fromOffset(15, 15)
            tabinfoicon.Image = "rbxassetid://11422155687"
            tabinfoicon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            tabinfoicon.ImageTransparency = 0.5
            tabinfoicon.ScaleType = Enum.ScaleType.Fit
        end

        if tab.Name == "Premium" then
            tab.Tweens.PremiumGradient = TweenService:Create(strokegradient, TweenInfo.new(1.5, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, math.huge, true), {Offset = Vector2.new(1,0)})
            tab.Tweens.PremiumGradient:Play()
        end

        if not SpaceUI.Tabs.TabBackground then
            -- Parent PHẢI là Background.Objects.MainFrame (dashboard), không phải
            -- MainScreenGui (toàn màn hình). So bản gốc Init_lua: TabBackground được
            -- tạo với Night.Background.Objects.MainFrame làm cha, để Size=fromScale(1,1)
            -- tính theo 100% dashboard chứ không phải 100% viewport. Parent sai khiến
            -- ActualTab (0.8, 0.8 theo % của TabBackground) to/lệch hẳn so với dashboard,
            -- và khiến hiệu ứng dim (vốn set trên TabBackground) không nằm đúng layer để
            -- người dùng nhìn thấy nó phủ lên dashboard.
            SpaceUI.Tabs.TabBackground = Instance.new("ImageButton", SpaceUI.Background.Objects.MainFrame)
            SpaceUI.Tabs.TabBackground.AnchorPoint = Vector2.new(0.5, 0.5)
            SpaceUI.Tabs.TabBackground.BackgroundTransparency = 1
            SpaceUI.Tabs.TabBackground.Position = UDim2.fromScale(0.5, 0.5)
            SpaceUI.Tabs.TabBackground.Size = UDim2.fromScale(1, 1)
            -- Image PHẢI có asset ID thật, không được để rỗng: ImageTransparency chỉ
            -- tạo hiệu ứng thị giác khi có Image thật để làm mờ - Image="" khiến toàn
            -- bộ logic dim (đúng property, đúng parent, đúng Visible) không hiện ra
            -- bất kỳ thứ gì nhìn thấy được, dù mọi giá trị bên dưới đều đổi đúng.
            -- Asset ID lấy nguyên từ bản gốc Init_lua (Night.Tabs.TabBackground.Image).
            SpaceUI.Tabs.TabBackground.Image = "rbxassetid://16286761786"
            SpaceUI.Tabs.TabBackground.ScaleType = Enum.ScaleType.Stretch
            SpaceUI.Tabs.TabBackground.ImageTransparency = 1
            SpaceUI.Tabs.TabBackground.Visible = false
            SpaceUI.Tabs.TabBackground.Active = false
            SpaceUI.Tabs.TabBackground.AutoButtonColor = false
            SpaceUI.Tabs.TabBackground.ZIndex = 1

            -- TabBackground là hình chữ nhật vuông góc (không tự thừa hưởng UICorner
            -- 20px của MainFrame) - khi Image hiện lên làm lớp dim, nó tràn ra ngoài
            -- 4 góc bo tròn của MainFrame/PageHolder, trông như 1 khối vuông chồng
            -- lên khung Dashboard đã bo góc. Thêm UICorner cùng bán kính (giống hệt
            -- mainframecorner/pageHolderCorner) để lớp dim khớp đúng viền Dashboard.
            local tabBackgroundCorner = Instance.new("UICorner", SpaceUI.Tabs.TabBackground)
            tabBackgroundCorner.CornerRadius = UDim.new(0, 20)
            table.insert(SpaceUI.Corners, tabBackgroundCorner)
        end

        tab.Objects.ActualTab = Instance.new("ImageButton", SpaceUI.Tabs.TabBackground)
        tab.Objects.ActualTab.AnchorPoint = Vector2.new(0.5, 0.5)
        tab.Objects.ActualTab.BackgroundTransparency = 1
        tab.Objects.ActualTab.Position = UDim2.fromScale(0.5, 0.5)
        tab.Objects.ActualTab.Size = UDim2.fromScale(0.8, 0.8)
        tab.Objects.ActualTab.Image = "rbxassetid://16286719854"
        tab.Objects.ActualTab.ImageColor3 = Color3.fromRGB(SpaceUI.Config.UI.TabColor.value1, SpaceUI.Config.UI.TabColor.value2, SpaceUI.Config.UI.TabColor.value3)
        tab.Objects.ActualTab.ImageTransparency = SpaceUI.Config.UI.TabTransparency
        tab.Objects.ActualTab.ScaleType = Enum.ScaleType.Slice
        tab.Objects.ActualTab.SliceCenter = Rect.new(512, 512, 512, 512)
        tab.Objects.ActualTab.SliceScale = 0.1
        tab.Objects.ActualTab.AutoButtonColor = false
        tab.Objects.ActualTab.Visible = false
        tab.Objects.ActualTab.ZIndex = 1

        -- Viền glow cố định quanh mọi tab, luôn hiện bất kể focus/unfocus (nguyên bản
        -- gốc bị mất trong quá trình sửa ZIndex trước đó - khôi phục y hệt).
        local TabPrism = Instance.new("ImageLabel", tab.Objects.ActualTab)
        TabPrism.AnchorPoint = Vector2.new(0.5, 0.5)
        TabPrism.BackgroundTransparency = 1
        TabPrism.Position = UDim2.fromScale(0.5, 0.5)
        TabPrism.Size = UDim2.new(1, 20, 1, 20)
        TabPrism.ZIndex = 1000
        TabPrism.Image = "rbxassetid://16255699706"
        TabPrism.ImageColor3 = Color3.fromRGB(143, 143, 143)
        TabPrism.ImageTransparency = 0.8
        TabPrism.ScaleType = Enum.ScaleType.Crop
        Instance.new("UICorner", TabPrism).CornerRadius = UDim.new(0, 27)
        local PrismStroke = Instance.new("UIStroke", TabPrism)
        PrismStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        PrismStroke.Color = Color3.fromRGB(255, 255, 255)
        PrismStroke.Transparency = 0.85
        tab.Objects.TabPrism = TabPrism
        tab.Objects.PrismStroke = PrismStroke

        -- Shadow chỉ hiện khi tab được focus (xem CaptureFocus/RemoveFocus). Copy y
        -- hệt property của DropShadow gốc (InitInfo.Objects.DropShadow) - chỉ khác
        -- ImageTransparency mặc định (ẩn) vì cái này cần tween ẩn/hiện theo focus.
        -- Là con trực tiếp của ActualTab để tự động bám Position/Size/Visible theo
        -- tab mà không cần tự bind qua GetPropertyChangedSignal (cách cũ gây lệch vị
        -- trí ngay từ lần mở đầu tiên).
        tab.Objects.TabFocusShadow = Instance.new("ImageLabel", tab.Objects.ActualTab)
        tab.Objects.TabFocusShadow.Name = "TabFocusShadow"
        tab.Objects.TabFocusShadow.AnchorPoint = Vector2.new(0.5, 0.5)
        tab.Objects.TabFocusShadow.BackgroundTransparency = 1
        tab.Objects.TabFocusShadow.BorderSizePixel = 0
        tab.Objects.TabFocusShadow.Position = UDim2.fromScale(0.5, 0.5)
        tab.Objects.TabFocusShadow.Size = UDim2.new(1, 88, 1, 88)
        tab.Objects.TabFocusShadow.ZIndex = -10
        tab.Objects.TabFocusShadow.Image = "rbxassetid://16286730454"
        tab.Objects.TabFocusShadow.ScaleType = Enum.ScaleType.Slice
        tab.Objects.TabFocusShadow.SliceCenter = Rect.new(512, 512, 512, 512)
        tab.Objects.TabFocusShadow.SliceScale = 0.19
        tab.Objects.TabFocusShadow.ImageTransparency = 1

        SpaceUI.Tabs.ActivateTab(tab)

        -- Bấm vào bất kỳ đâu trong tab (kể cả content, không chỉ thanh Drag) sẽ
        -- đưa tab này lên trên các tab khác (Leaflet focus engine).
        table.insert(SpaceUI.Connections, tab.Objects.ActualTab.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                -- Bỏ qua khi Peek đang Active: theo hành vi Roblox đã xác nhận
                -- ("GUIs Sink Input Even When Covered"), InputBegan trên GuiObject
                -- này vẫn bắn dù bị PeekHitCatcher (con, ZIndex cao hơn) che phía
                -- trên khi Peek đang mở - nếu không chặn, CaptureFocus(tab) sẽ chạy
                -- SỚM và SAI THỜI ĐIỂM (lúc frame.Parent còn là MainScreenGui, chưa
                -- được Peek trả về TabBackground), khiến SpaceUI.Tabs.FocusedTab bị
                -- set trước - làm CaptureFocus gọi ĐÚNG LÚC trong Peek.Exit (sau khi
                -- Parent đã ổn định) bị early-return vì FocusedTab đã trùng sẵn, và
                -- tab được chọn trong Peek không thực sự bring-to-front được nữa.
                -- Việc chọn card trong Peek đi qua HitCatcher/attachPeekInput riêng,
                -- tự gọi CaptureFocus đúng cách - chặn nhánh này không ảnh hưởng gì
                -- tới việc bấm chọn tab bên trong Peek.
                if SpaceUI.Peek and SpaceUI.Peek.Active then return end
                SpaceUI.Tabs.CaptureFocus(tab)
            end
        end))

        -- CanvasGroup bao toàn bộ content của tab
        tab.Objects.ContentCanvas = Instance.new("CanvasGroup", tab.Objects.ActualTab)
        tab.Objects.ContentCanvas.AnchorPoint = Vector2.new(0.5, 0.5)
        tab.Objects.ContentCanvas.BackgroundTransparency = 1
        tab.Objects.ContentCanvas.Position = UDim2.fromScale(0.5, 0.5)
        tab.Objects.ContentCanvas.Size = UDim2.fromScale(1, 1)
        tab.Objects.ContentCanvas.ZIndex = 1

        if not SpaceUI.Config.Game.Other.TabPos then 
            SpaceUI.Config.Game.Other.TabPos = {}
        end
        if SpaceUI.Config.Game.Other.TabPos[tab.Name] then
            local pos = SpaceUI.Config.Game.Other.TabPos[tab.Name]
            if pos.X then
                tab.Objects.ActualTab.Position = UDim2.fromScale(pos.X, tab.Objects.ActualTab.Position.Y.Scale)
            end
            if pos.Y then
                tab.Objects.ActualTab.Position = UDim2.fromScale(tab.Objects.ActualTab.Position.X.Scale, pos.Y)
            end
        end

        tab.Objects.TabDragCanvas = Instance.new("CanvasGroup", tab.Objects.ActualTab)
        tab.Objects.TabDragCanvas.Active = false
        tab.Objects.TabDragCanvas.AnchorPoint = Vector2.new(0.5, 0.5)
        tab.Objects.TabDragCanvas.BackgroundTransparency = 1
        tab.Objects.TabDragCanvas.Position = UDim2.fromScale(0.5, 0.5)
        tab.Objects.TabDragCanvas.Size = UDim2.fromScale(1, 1)
        tab.Objects.TabDragCanvas.ZIndex = 10000000

        tab.Objects.DragButton = Instance.new("ImageButton", tab.Objects.TabDragCanvas)
        tab.Objects.DragButton.AnchorPoint = Vector2.new(0.5, 0)
        tab.Objects.DragButton.AutoButtonColor = false
        tab.Objects.DragButton.BackgroundTransparency = 1
        tab.Objects.DragButton.BorderSizePixel = 0
        tab.Objects.DragButton.Position = UDim2.fromScale(0.5, 0)
        tab.Objects.DragButton.Size = UDim2.fromOffset(60, 40)
        tab.Objects.DragButton.ZIndex = 10
        
        local dragicon = Instance.new("ImageLabel", tab.Objects.DragButton)
        dragicon.AnchorPoint = Vector2.new(0.5, 0)
        dragicon.BackgroundTransparency = 1
        dragicon.BorderSizePixel = 0
        dragicon.Position = UDim2.fromScale(0.5, 0)
        dragicon.Size = UDim2.fromScale(1, 0.75)
        dragicon.ZIndex = 10
        dragicon.Image = "rbxassetid://12974354535"
        dragicon.ImageTransparency = 0.5
        dragicon.ScaleType = Enum.ScaleType.Fit

        tab.Functions.Drag = function(mouseStart: Vector2 | Vector3 | nil, frameStart: UDim2, input: InputObject?)
            pcall(function()
                if UserCamera then
                    -- Dùng AbsoluteSize của PARENT THẬT (TabBackground) thay vì
                    -- UserCamera.ViewportSize: Position scale của ActualTab là %
                    -- theo parent, không phải % theo màn hình. Nếu TabBackground
                    -- nhỏ hơn viewport, chia cho ViewportSize làm tab di chuyển
                    -- chậm hơn tay/chuột thật. Cùng pattern với ResizeTab bên dưới.
                    local Viewport = tab.Objects.ActualTab.Parent.AbsoluteSize
                    local Delta = Vector2.new(0, 0)
                    if mouseStart and input then
                        Delta = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(mouseStart.X, mouseStart.Y))
                    end
        
                    local newX = frameStart.X.Scale + (Delta.X / Viewport.X)
                    local newY = frameStart.Y.Scale + (Delta.Y / Viewport.Y)
        
                    tab.Objects.ActualTab.Position = UDim2.fromScale(newX, newY)

                    -- Dim dashboard (chỉ hiệu ứng mờ ImageTransparency) khi tab con nằm
                    -- trong vùng dashboard, mờ hẳn khi tab bị kéo ra rìa/ngoài. KHÔNG còn
                    -- đổi ZIndex xuống -100 nữa: Dashboard (PageHolder) phải LUÔN nằm dưới
                    -- mọi tab con, không có ngoại lệ dù tab nằm trong hay ngoài rìa - việc
                    -- hạ ZIndex TabBackground xuống -100 từng làm Dashboard nổi lên đè cả
                    -- tab con khi không còn tab nào nằm trong vùng Dashboard nữa.
                    local flagged = false
                    for i,v in SpaceUI.Tabs.Tabs do
                        if v.Objects and v.Objects.ActualTab then
                            local Tab = v.Objects.ActualTab
                            local TabPos = Tab.Position
                            if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                if not flagged then
                                    TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
                                end
                            else
                                if v.Objects.ActualTab.Visible then
                                    TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                    flagged = true
                                end
                            end
                        end
                    end

                    if not SpaceUI.Config.Game.Other.TabPos then
                        SpaceUI.Config.Game.Other.TabPos = {}
                    end
                    SpaceUI.Config.Game.Other.TabPos[tab.Name] = {X = newX, Y = newY}
                end
            end)
        end

        local InputStarting, FrameStarting = nil, nil
        table.insert(SpaceUI.Connections, tab.Objects.DragButton.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                SpaceUI.Tabs.CaptureFocus(tab)
                tab.Data.Dragging, InputStarting, FrameStarting = true, input.Position, tab.Objects.ActualTab.Position
                SpaceUI.CurrntInputChangeCallback = function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then  
                        if tab.Data.Dragging then
                            tab.Functions.Drag(InputStarting, FrameStarting, input)
                        end
                    end
                end
                SpaceUI.InputEndFunc = function(input)
                    if (input.UserInputType == Enum.UserInputType.MouseButton1) or (input.UserInputType == Enum.UserInputType.Touch) then
                        tab.Data.Dragging, InputStarting, FrameStarting = false, input.Position, tab.Objects.ActualTab.Position
                        SpaceUI.CurrntInputChangeCallback = function() end

                        Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                        SpaceUI.InputEndFunc = nil
                    end
                end
            end
        end))


        -- ── Tab Resize Handle (góc bottom-right) ─────────────────────────────
        -- Animation hover/press ported nguyên bản từ window_handler (Exe5 rbxmx):
        -- icon.scale + selection.scale, dùng chung info = TweenInfo.new(0.4, Exponential)
        local ResizeInfo = TweenInfo.new(0.4, Enum.EasingStyle.Exponential)

        local TabResizeHandle = Instance.new("ImageButton", tab.Objects.TabDragCanvas)
        TabResizeHandle.Name = "ResizeHandle"
        TabResizeHandle.AnchorPoint = Vector2.new(1, 1)
        TabResizeHandle.Position = UDim2.fromScale(1, 1)
        TabResizeHandle.Size = UDim2.fromOffset(15, 15)
        TabResizeHandle.BackgroundTransparency = 1
        TabResizeHandle.AutoButtonColor = false
        TabResizeHandle.ZIndex = 10000001
        TabResizeHandle.Image = "rbxassetid://11295287825"
        TabResizeHandle.ImageColor3 = Color3.fromRGB(255, 255, 255)
        TabResizeHandle.ImageTransparency = 0.5
        TabResizeHandle.ScaleType = Enum.ScaleType.Fit

        local TabResizeHandleScale = Instance.new("UIScale", TabResizeHandle)
        TabResizeHandleScale.Name = "scale"
        TabResizeHandleScale.Scale = 1

        -- selection: glow/highlight phía sau icon, ẩn mặc định (ImageTransparency = 1)
        local TabResizeSelection = Instance.new("ImageLabel", TabResizeHandle)
        TabResizeSelection.Name = "selection"
        TabResizeSelection.AnchorPoint = Vector2.new(0.5, 0.5)
        TabResizeSelection.Position = UDim2.fromScale(0.5, 0.5)
        TabResizeSelection.Size = UDim2.fromScale(1, 1)
        TabResizeSelection.BackgroundTransparency = 1
        TabResizeSelection.ZIndex = TabResizeHandle.ZIndex - 1
        TabResizeSelection.Image = "rbxassetid://11295287825"
        TabResizeSelection.ImageColor3 = Color3.fromRGB(255, 255, 255)
        TabResizeSelection.ImageTransparency = 1
        TabResizeSelection.ScaleType = Enum.ScaleType.Fit

        local TabResizeSelectionScale = Instance.new("UIScale", TabResizeSelection)
        TabResizeSelectionScale.Name = "scale"
        TabResizeSelectionScale.Scale = 0.5

        table.insert(SpaceUI.Connections, TabResizeHandle.MouseEnter:Connect(function()
            if not tab.Data.Resizing then
                TabResizeSelection.ImageTransparency = 1
                TabResizeSelectionScale.Scale = 0.5

                TweenService:Create(TabResizeHandleScale, ResizeInfo, {Scale = 1.2}):Play()

                TweenService:Create(TabResizeSelection, ResizeInfo, {ImageTransparency = 0.8}):Play()
                TweenService:Create(TabResizeSelectionScale, ResizeInfo, {Scale = 1}):Play()
            end
        end))

        table.insert(SpaceUI.Connections, TabResizeHandle.MouseButton1Down:Connect(function()
            TweenService:Create(TabResizeHandleScale, ResizeInfo, {Scale = 0.5}):Play()

            TweenService:Create(TabResizeSelection, ResizeInfo, {ImageTransparency = 0.9}):Play()
            TweenService:Create(TabResizeSelectionScale, ResizeInfo, {Scale = 0.8}):Play()
        end))

        table.insert(SpaceUI.Connections, TabResizeHandle.MouseLeave:Connect(function()
            if not tab.Data.Resizing then
                TweenService:Create(TabResizeHandleScale, ResizeInfo, {Scale = 1}):Play()

                TweenService:Create(TabResizeSelection, ResizeInfo, {ImageTransparency = 1}):Play()
                TweenService:Create(TabResizeSelectionScale, ResizeInfo, {Scale = 0.5}):Play()
            end
        end))

        tab.Data.Resizing = false
        tab.Data.ResizeLastPos = nil

        tab.Functions.ResizeTab = function(input)
            if not tab.Data.Resizing or not tab.Data.ResizeLastPos then return end
            local delta = input.Position - tab.Data.ResizeLastPos
            local parentSize = tab.Objects.ActualTab.Parent.AbsoluteSize
            local cur = tab.Objects.ActualTab.AbsoluteSize
            local newW = math.clamp(cur.X + delta.X, 280, 950)
            local newH = math.clamp(cur.Y + delta.Y, 280, 950)
            local sx = newW / parentSize.X
            local sy = newH / parentSize.Y
            tab.Objects.ActualTab.Size = UDim2.fromScale(sx, sy)
            tab.Data.ResizeLastPos = input.Position
            if not SpaceUI.Config.Game.Other.TabSize then
                SpaceUI.Config.Game.Other.TabSize = {}
            end
            SpaceUI.Config.Game.Other.TabSize[tab.Name] = {W = sx, H = sy}
        end

        table.insert(SpaceUI.Connections, TabResizeHandle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or
               input.UserInputType == Enum.UserInputType.Touch then
                tab.Data.Resizing = true
                tab.Data.ResizeLastPos = input.Position
                SpaceUI.CurrntInputChangeCallback = function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseMovement or
                       inp.UserInputType == Enum.UserInputType.Touch then
                        tab.Functions.ResizeTab(inp)
                    end
                end
                SpaceUI.InputEndFunc = function(inp)
                    if inp.UserInputType == Enum.UserInputType.MouseButton1 or
                       inp.UserInputType == Enum.UserInputType.Touch then
                        tab.Data.Resizing = false
                        tab.Data.ResizeLastPos = nil
                        SpaceUI.CurrntInputChangeCallback = function() end
                        Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                        SpaceUI.InputEndFunc = nil

                        -- Reset animation handle về trạng thái gốc (tương đương stop() bản gốc)
                        TweenService:Create(TabResizeHandleScale, ResizeInfo, {Scale = 1}):Play()
                        TweenService:Create(TabResizeSelection, ResizeInfo, {ImageTransparency = 1}):Play()
                        TweenService:Create(TabResizeSelectionScale, ResizeInfo, {Scale = 0.5}):Play()
                    end
                end
            end
        end))

        -- Restore saved tab size
        if SpaceUI.Config.Game.Other.TabSize and SpaceUI.Config.Game.Other.TabSize[tab.Name] then
            local s = SpaceUI.Config.Game.Other.TabSize[tab.Name]
            tab.Objects.ActualTab.Size = UDim2.fromScale(s.W, s.H)
        end


        
        local TabPad = Instance.new("UIPadding", tab.Objects.ActualTab)
        TabPad.PaddingBottom = UDim.new(0, 10)
        TabPad.PaddingLeft = UDim.new(0, 10)
        TabPad.PaddingRight = UDim.new(0, 10)
        TabPad.PaddingTop = UDim.new(0, 10)

        local TabScale = Instance.new("UIScale", tab.Objects.ActualTab)
        TabScale.Scale = 0
        
        local TabConstraint = Instance.new("UISizeConstraint", tab.Objects.ActualTab)
        TabConstraint.MaxSize = Vector2.new(1000, 800)

        -- Parent vào ActualTab (sibling của ContentCanvas), không phải vào trong ContentCanvas
        local TabHeader = Instance.new("TextLabel", tab.Objects.ActualTab)
        TabHeader.AnchorPoint = Vector2.new(0.5, 0)
        TabHeader.BackgroundTransparency = 1
        TabHeader.Position = UDim2.fromScale(0.5, 0.04)
        TabHeader.Size = UDim2.new(1, 0, 0, 40)
        TabHeader.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
        TabHeader.Text = tab.Name
        TabHeader.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabHeader.TextSize = 22
        TabHeader.TextTransparency = 0.1
        TabHeader.ZIndex = 2

        local CloseButton = Instance.new("ImageButton", tab.Objects.ContentCanvas)
        CloseButton.AnchorPoint = Vector2.new(1, 0)
        CloseButton.BackgroundColor3 = Color3.fromRGB(SpaceUI.Config.UI.TabColor.value1 + 20, SpaceUI.Config.UI.TabColor.value2 + 20, SpaceUI.Config.UI.TabColor.value3 + 20)
        CloseButton.Position = UDim2.new(1, -5, 0, 5)
        CloseButton.Size = UDim2.fromOffset(30, 30)
        CloseButton.AutoButtonColor = false
        CloseButton.ZIndex = 2
        Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(1, 0)
        tab.Objects.CloseButton = CloseButton

        local CloseButtonIcon = Instance.new("ImageLabel", CloseButton)
        CloseButtonIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        CloseButtonIcon.BackgroundTransparency = 1
        CloseButtonIcon.Position = UDim2.fromScale(0.5, 0.5)
        CloseButtonIcon.Size = UDim2.fromOffset(16, 16)
        CloseButtonIcon.Image = "rbxassetid://11293981586"
        CloseButtonIcon.ImageTransparency = 0.2
        CloseButtonIcon.ZIndex = 2
        CloseButtonIcon.ScaleType = Enum.ScaleType.Fit

        tab.Objects.ScrollFrame = Instance.new("ScrollingFrame", tab.Objects.ContentCanvas)
        tab.Objects.ScrollFrame.AnchorPoint = Vector2.new(0.5, 0)
        tab.Objects.ScrollFrame.BackgroundTransparency = 1
        tab.Objects.ScrollFrame.Position = UDim2.new(0.5, 0, 0.04, 50)
        tab.Objects.ScrollFrame.Size = UDim2.new(1, -10, 1, -70)
        tab.Objects.ScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tab.Objects.ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        tab.Objects.ScrollFrame.ScrollBarThickness = 2
        tab.Objects.ScrollFrame.ScrollingDirection = Enum.ScrollingDirection.Y
        tab.Objects.ScrollFrame.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right
        tab.Objects.ScrollFrame.BorderSizePixel = 0
        tab.Objects.ScrollFrame.ZIndex = 2

        local ScrollFrameList = Instance.new("UIListLayout", tab.Objects.ScrollFrame)
        ScrollFrameList.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollFrameList.Padding = UDim.new(0, 10)
        ScrollFrameList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local ScrollFramePad = Instance.new("UIPadding", tab.Objects.ScrollFrame)
        ScrollFramePad.PaddingBottom = UDim.new(0, 10)
        ScrollFramePad.PaddingLeft = UDim.new(0, 15)
        ScrollFramePad.PaddingRight = UDim.new(0, 15)

        local SearchBar = Instance.new("Frame", tab.Objects.ScrollFrame)
        SearchBar.ZIndex = 2
        SearchBar.AnchorPoint = Vector2.new(0.5, 0)
        SearchBar.BackgroundTransparency = 0.7
        SearchBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        SearchBar.Size = UDim2.new(1, 0, 0, 40)
        SearchBar.LayoutOrder = -1000
        Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(1, 0)

        local SearchBarFocusGradient = Instance.new("UIGradient", SearchBar)
        SearchBarFocusGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(29, 59, 95)), ColorSequenceKeypoint.new(1, Color3.fromRGB(81, 32, 124))}
        SearchBarFocusGradient.Offset = Vector2.new(-0.5, 0)
        SearchBarFocusGradient.Enabled = false

        local SearchBarPadding = Instance.new("UIPadding", SearchBar)
        SearchBarPadding.PaddingLeft = UDim.new(0, 40)

        local SearchBarDepth = Instance.new("ImageLabel", SearchBar)
        SearchBarDepth.AnchorPoint = Vector2.new(0, 0.5)
        SearchBarDepth.BackgroundTransparency = 1
        SearchBarDepth.Position = UDim2.new(0, -40, 0.5, 0)
        SearchBarDepth.Size = UDim2.new(1, 40, 1, 0)
        SearchBarDepth.Image = "rbxassetid://16264857615"
        SearchBarDepth.ImageColor3 = Color3.fromRGB(255, 255, 255)
        SearchBarDepth.ScaleType = Enum.ScaleType.Slice
        SearchBarDepth.SliceCenter = Rect.new(206, 206, 206, 206)
        SearchBarDepth.ZIndex = 2

        local MainSearchBarTextBox = Instance.new("TextBox", SearchBar)
        MainSearchBarTextBox.BackgroundTransparency = 1
        MainSearchBarTextBox.Position = UDim2.fromOffset(0, -1)
        MainSearchBarTextBox.Size = UDim2.new(1, -50, 1, 0)
        MainSearchBarTextBox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
        MainSearchBarTextBox.PlaceholderColor3 = Color3.fromRGB(175, 175, 175)
        MainSearchBarTextBox.PlaceholderText = "Search..."
        MainSearchBarTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
        MainSearchBarTextBox.TextSize = 16
        MainSearchBarTextBox.TextTransparency = 0.2
        MainSearchBarTextBox.TextXAlignment = Enum.TextXAlignment.Left
        MainSearchBarTextBox.Text = ""
        MainSearchBarTextBox.ClearTextOnFocus = false
        MainSearchBarTextBox.ZIndex = 2

        local SearchBarIcon = Instance.new("ImageLabel", SearchBar)
        SearchBarIcon.AnchorPoint = Vector2.new(0, 0.5)
        SearchBarIcon.BackgroundTransparency = 1
        SearchBarIcon.Position = UDim2.new(0, -25, 0.5, 0)
        SearchBarIcon.Size = UDim2.fromOffset(17, 17)
        SearchBarIcon.Image = "rbxassetid://11293977875"
        SearchBarIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        SearchBarIcon.ImageTransparency = 0.5
        SearchBarIcon.ScaleType = Enum.ScaleType.Fit
        SearchBarIcon.ZIndex = 2

        local SearchBarClear = Instance.new("ImageButton", SearchBar)
        SearchBarClear.AnchorPoint = Vector2.new(1, 0.5)
        SearchBarClear.BackgroundTransparency = 1
        SearchBarClear.Position = UDim2.fromScale(1, 0.5)
        SearchBarClear.Size = UDim2.fromOffset(40, 40)
        SearchBarClear.AutoButtonColor = false
        SearchBarClear.ZIndex = 2

        local SearchBarClearIcon = Instance.new("ImageLabel", SearchBarClear)
        SearchBarClearIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        SearchBarClearIcon.BackgroundTransparency = 1
        SearchBarClearIcon.Position = UDim2.fromScale(0.5, 0.5)
        SearchBarClearIcon.Size = UDim2.fromOffset(14, 14)
        SearchBarClearIcon.Image = "rbxassetid://11293981586"
        SearchBarClearIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        SearchBarClearIcon.ImageTransparency = 0.5
        SearchBarClearIcon.ScaleType = Enum.ScaleType.Fit

        local SearchBarClearScale = Instance.new("UIScale", SearchBarClearIcon)
        SearchBarClearScale.Scale = 0


        local resotredback = {backbuttons = {}, keybinds = {}}
        local activeFadeTweens = {}
        local function cancelActiveFadeTweens()
            -- reopen = true (gọi từ Assets.Main.ToggleVisibility khi bật/tắt cả UI)
            -- cố tình bỏ qua debounce ToggleAnimating bên dưới, nên 2 lần gọi
            -- ToggleTab có thể chồng lên nhau và tạo 2 tween chạy song song trên
            -- cùng 1 property (GroupTransparency / ImageTransparency) theo 2 hướng
            -- ngược nhau -> TweenService chốt giá trị cuối cùng nhận được, khiến
            -- tab kẹt lại ở giữa khoảng mờ (nhìn như bị "dim") thay vì tới đích 0
            -- hoặc 1. Huỷ tween cũ trước khi phát tween mới để luôn chỉ có 1 tween
            -- sở hữu mỗi property tại một thời điểm.
            for i = #activeFadeTweens, 1, -1 do
                activeFadeTweens[i]:Cancel()
                table.remove(activeFadeTweens, i)
            end
        end

        tab.Functions.ToggleTab = function(visible, anim, reopen)
            -- Debounce: nếu tab đang giữa animation mở/đóng (0.8s), bỏ qua lời gọi
            -- trùng lặp. Thiếu chốt này khiến 2 animation chạy chồng nhau tranh chấp
            -- ContentCanvas.GroupTransparency / ActualTab.ImageTransparency theo 2
            -- hướng ngược nhau, khiến nó kẹt dim mãi cho tới khi tab mất focus.
            if tab.Data.ToggleAnimating and not reopen then return end
            cancelActiveFadeTweens()
            tab.Data.ToggleAnimating = true
            task.spawn(function()
                -- Nếu Module Settings đang bị kẹt mở (vd: tab bị đóng/dim trước khi bấm Back),
                -- force-close nó về trạng thái bình thường trước khi tiếp tục, để tránh
                -- TabHeader/ScrollFrame bị kẹt ở Position lệch ngoài màn hình.
                if tab.Data.SettingsOpen and tab.Functions.CloseModuleSettings then
                    tab.Functions.CloseModuleSettings()
                end
                tab.Opened = visible
                if visible then
                    -- Mở tab: hiện ngay để animation (fade-in + scale) có thể nhìn thấy được
                    tab.Objects.ActualTab.Visible = true
                    tab.Objects.ScrollFrame.Visible = true
                    SpaceUI.Tabs.CaptureFocus(tab)
                    if not reopen then
                        if not SpaceUI.CurrentOpenTab then
                            SpaceUI.CurrentOpenTab = {tab}
                        else
                            table.insert(SpaceUI.CurrentOpenTab, tab)
                        end
                        if Assets.Main.TrackRecentTab then
                            Assets.Main.TrackRecentTab(tab.Name)
                        end
                        if SpaceUI.AccessibilityButton and SpaceUI.AccessibilityButton.UpdateLabel then
                            SpaceUI.AccessibilityButton.UpdateLabel()
                        end
                    end

                    SpaceUI.Tabs.TabBackground.Visible = true
                    if not tab.Data.SettingsOpen then
                        CloseButton.Visible = true
                    end
                    tab.Objects.TabDragCanvas.Visible = true
                    TabHeader.TextTransparency = 0.1
                    for i,v in resotredback.backbuttons do
                        v.Visible = true
                    end
                    for i,v in resotredback.keybinds do
                        v.Visible = true
                    end
                    table.clear(resotredback.backbuttons)
                    table.clear(resotredback.keybinds)

                    if anim and SpaceUI.Config.UI.Anim then
                        tab.Objects.ActualTab.ImageTransparency = 1
                        tab.Objects.ContentCanvas.GroupTransparency = 1
                        TabScale.Scale = 1.2
                        if tab.Objects.TabPrism then tab.Objects.TabPrism.ImageTransparency = 1 end
                        if tab.Objects.PrismStroke then tab.Objects.PrismStroke.Transparency = 1 end

                        if SpaceUI.Tabs.TabBackground.ImageTransparency < 1 then
                            TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                        end
                        SpaceUI.IsAllowedToHoverTabButton = true

                        local fadeInActualTab = TweenService:Create(tab.Objects.ActualTab, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = SpaceUI.Config.UI.TabTransparency})
                        local fadeInContent = TweenService:Create(tab.Objects.ContentCanvas, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {GroupTransparency = 0})
                        local scaleInTween = TweenService:Create(TabScale, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Scale = 1})
                        table.insert(activeFadeTweens, fadeInActualTab)
                        table.insert(activeFadeTweens, fadeInContent)
                        table.insert(activeFadeTweens, scaleInTween)
                        if tab.Objects.TabPrism then
                            local fadeInPrism = TweenService:Create(tab.Objects.TabPrism, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0.8})
                            table.insert(activeFadeTweens, fadeInPrism)
                            fadeInPrism:Play()
                        end
                        if tab.Objects.PrismStroke then
                            local fadeInStroke = TweenService:Create(tab.Objects.PrismStroke, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Transparency = 0.85})
                            table.insert(activeFadeTweens, fadeInStroke)
                            fadeInStroke:Play()
                        end
                        fadeInActualTab:Play()
                        fadeInContent:Play()
                        scaleInTween:Play()
                        task.wait(0.8)
                    else
                        if SpaceUI.Tabs.TabBackground.ImageTransparency < 1 then
                            TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                        end
                        SpaceUI.IsAllowedToHoverTabButton = true
                        TabScale.Scale = 1
                        tab.Objects.ActualTab.ImageTransparency = SpaceUI.Config.UI.TabTransparency
                        tab.Objects.ContentCanvas.GroupTransparency = 0
                        if tab.Objects.TabPrism then tab.Objects.TabPrism.ImageTransparency = 0.8 end
                        if tab.Objects.PrismStroke then tab.Objects.PrismStroke.Transparency = 0.85 end
                    end
                else
                    if not reopen then
                        table.remove(SpaceUI.CurrentOpenTab, table.find(SpaceUI.CurrentOpenTab, tab))
                        if SpaceUI.AccessibilityButton and SpaceUI.AccessibilityButton.UpdateLabel then
                            SpaceUI.AccessibilityButton.UpdateLabel()
                        end
                    end
                    if SpaceUI.Tabs.FocusedTab == tab then
                        -- skipTween = true: cancel focus tweens mà không tạo tween
                        -- ImageTransparency → 0, tránh conflict với close animation.
                        SpaceUI.Tabs.RemoveFocus(tab, true)
                    end
                    SpaceUI.IsAllowedToHoverTabButton = false
                    CloseButton.Visible = false
                    tab.Objects.TabDragCanvas.Visible = false
                    for i,v in tab.Modules do
                        if v.Objects and v.Objects.BackButton and v.Objects.BackButton.Visible then 
                            v.Objects.BackButton.Visible = false
                            table.insert(resotredback.backbuttons, v.Objects.BackButton)
                        end
                        if v.Objects and v.Objects.KeybindButton and v.Objects.KeybindButton.Visible then
                            v.Objects.KeybindButton.Visible = false
                            table.insert(resotredback.keybinds, v.Objects.KeybindButton)
                        end
                    end
                    TabHeader.TextTransparency = 1
                    if anim and SpaceUI.Config.UI.Anim  then
                        local info = TweenInfo.new(.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
                        local fadeOutActualTab = TweenService:Create(tab.Objects.ActualTab, info, {ImageTransparency = 1})
                        local fadeOutContent = TweenService:Create(tab.Objects.ContentCanvas, info, {GroupTransparency = 1})
                        local scaleOutTween = TweenService:Create(TabScale, info, {Scale = 1.2})
                        table.insert(activeFadeTweens, fadeOutActualTab)
                        table.insert(activeFadeTweens, fadeOutContent)
                        table.insert(activeFadeTweens, scaleOutTween)
                        if tab.Objects.TabPrism then
                            local fadeOutPrism = TweenService:Create(tab.Objects.TabPrism, info, {ImageTransparency = 1})
                            table.insert(activeFadeTweens, fadeOutPrism)
                            fadeOutPrism:Play()
                        end
                        if tab.Objects.PrismStroke then
                            local fadeOutStroke = TweenService:Create(tab.Objects.PrismStroke, info, {Transparency = 1})
                            table.insert(activeFadeTweens, fadeOutStroke)
                            fadeOutStroke:Play()
                        end
                        fadeOutActualTab:Play()
                        fadeOutContent:Play()
                        scaleOutTween:Play()

                        local flagged = false
                        for i,v in SpaceUI.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
                                        SpaceUI.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab then
                                        TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                        SpaceUI.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end

                        task.wait(0.25)
                        tab.Objects.ActualTab.Visible = false
                        tab.Objects.ScrollFrame.Visible = false
                    else
                        TabScale.Scale = 1.2
                        tab.Objects.ActualTab.ImageTransparency = 1
                        tab.Objects.ContentCanvas.GroupTransparency = 1
                        if tab.Objects.TabPrism then tab.Objects.TabPrism.ImageTransparency = 1 end
                        if tab.Objects.PrismStroke then tab.Objects.PrismStroke.Transparency = 1 end
                        local flagged = false
                        for i,v in SpaceUI.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
                                        SpaceUI.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab then
                                        TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                        SpaceUI.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end
                        -- Không anim: ẩn ngay lập tức như hành vi cũ.
                        tab.Objects.ActualTab.Visible = false
                        tab.Objects.ScrollFrame.Visible = false
                    end
                    local cnt = 0 
                    for i,v in SpaceUI.CurrentOpenTab do
                        cnt += 1
                    end
                    if 0 >= cnt then
                        SpaceUI.Tabs.TabBackground.Visible = false
                    end
                end
                tab.Data.ToggleAnimating = false
            end)
        end

        tab.Functions.Search = function(result)
            for i,v in tab.Modules do
                if result == "" then
                    v.Objects.Module.Visible = true
                else
                    if v.Name:lower():find(result:lower()) then
                        v.Objects.Module.Visible = true
                    else
                        v.Objects.Module.Visible = false
                    end
                end
            end
        end

        local dashboardbuttonclickcon = tab.Objects.DashBoardButton.MouseButton1Click:Connect(function()
            TweenService:Create(tab.Objects.DashBoardButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(17,17,17)}):Play()
            local willOpen = not tab.Opened
            tab.Functions.ToggleTab(willOpen, true)
        end)
        table.insert(tab.Connections, dashboardbuttonclickcon)
        table.insert(SpaceUI.Connections, dashboardbuttonclickcon)


        local dashboardbuttonhovercon =  tab.Objects.DashBoardButton.MouseEnter:Connect(function()
            if not SpaceUI.IsAllowedToHoverTabButton then
                TweenService:Create(tab.Objects.DashBoardButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
            end
        end)
        table.insert(tab.Connections, dashboardbuttonhovercon)
        table.insert(SpaceUI.Connections, dashboardbuttonhovercon)

        local dashboardbuttonleavecon = tab.Objects.DashBoardButton.MouseLeave:Connect(function()
            TweenService:Create(tab.Objects.DashBoardButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(0,0,0)}):Play()
        end)
        table.insert(tab.Connections, dashboardbuttonleavecon)
        table.insert(SpaceUI.Connections, dashboardbuttonleavecon)

        local tabclosebuttoncon = CloseButton.MouseButton1Click:Connect(function()
            tab.Functions.ToggleTab(false, true)
        end)
        table.insert(tab.Connections, tabclosebuttoncon)
        table.insert(SpaceUI.Connections, tabclosebuttoncon)

        local searchclearcon =  SearchBarClear.MouseButton1Click:Connect(function()
            MainSearchBarTextBox.Text = ""
            tab.Functions.Search("")
            TweenService:Create(SearchBarClearScale, TweenInfo.new(0.1), {Scale = 0}):Play()
        end)
        table.insert(tab.Connections, searchclearcon)
        table.insert(SpaceUI.Connections, searchclearcon)

        local searchfocuslostcon =  MainSearchBarTextBox.FocusLost:Connect(function()
            tab.Functions.Search(MainSearchBarTextBox.Text)
            if MainSearchBarTextBox.Text ~= "" then
                TweenService:Create(SearchBarClearScale, TweenInfo.new(0.1), {Scale = 1}):Play()
            else
                TweenService:Create(SearchBarClearScale, TweenInfo.new(0.3), {Scale = 0}):Play()
            end
            TweenService:Create(SearchBar, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.7}):Play()
            task.wait(0.3)
            SearchBarFocusGradient.Enabled = false
            if tab.Tweens.SearchBackGround then
                tab.Tweens.SearchBackGround:Cancel()
            end
        end)
        table.insert(tab.Connections, searchfocuslostcon)
        table.insert(SpaceUI.Connections, searchfocuslostcon)

        local searchfocuscon =  MainSearchBarTextBox.Focused:Connect(function()
            SearchBarFocusGradient.Enabled = true
            tab.Tweens.SearchBackGround = TweenService:Create(SearchBarFocusGradient, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, math.huge, true), {Offset = Vector2.new(.5, 0)})
            tab.Tweens.SearchBackGround:Play()

            TweenService:Create(SearchBar, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(255,255,255), BackgroundTransparency = 0}):Play()
        end)
        table.insert(tab.Connections, searchfocuscon)
        table.insert(SpaceUI.Connections, searchfocuscon)

        tab.Functions.NewModule = function(data)
            local ModuleData = {
                Name = data and data.Name or "New Module",
                Description = data and data.Description or "New Module",
                Icon = data and data.Icon or "",
                Default = data and data.Default or false,
                Data = {Enabled = false, Keybind = nil, SettingKeybind = false, ExcludeSettingsVisiblity = {}, SettingsOpen = false, ArrayIndex = nil},
                Button = data and data.Button,
                Flag = data and data.Flag or "New Module",
                Callback = data and data.Callback or function() end,
                Settings = {},
                Objects = {},
                Connections = {},
                Functions = {Toggle = nil, Settings = {}},
            }

            if tab.Name == "Premium" then
                ModuleData.Callback = function(self, callback)
                    if callback then
                        task.wait(0.3)
                        Assets.Notifications.Send({
                            Description = "Contact the developer to purchase or get a trial",
                            Duration = 4
                        })


                        task.wait(0.1)
                        ModuleData.Functions.Toggle(false, false, false, true, true)
                    end
                end
            end

            ModuleData.Objects.Module = Instance.new("ImageButton", tab.Objects.ScrollFrame)
            ModuleData.Objects.Module.AutoButtonColor = false
            ModuleData.Objects.Module.BackgroundTransparency = 0.95
            ModuleData.Objects.Module.Size = UDim2.new(1, 0, 0, 65)
            ModuleData.Objects.Module.ZIndex = 2
            ModuleData.Objects.Module.ImageTransparency = 1
            ModuleData.Objects.Module.ClipsDescendants = true
            Instance.new("UICorner", ModuleData.Objects.Module).CornerRadius = UDim.new(0, 15)
            
            local ModulePadding = Instance.new("UIPadding", ModuleData.Objects.Module)
            ModulePadding.PaddingBottom = UDim.new(0, 10)
            ModulePadding.PaddingLeft = UDim.new(0, 20)
            ModulePadding.PaddingRight = UDim.new(0, 20)
            ModulePadding.PaddingTop = UDim.new(0, 10)
            

            local ModuleIcon = Instance.new("ImageLabel", ModuleData.Objects.Module)
            ModuleIcon.BackgroundTransparency = 1
            ModuleIcon.Position = UDim2.fromOffset(0, 10)
            ModuleIcon.Size = UDim2.fromOffset(25, 25)
            ModuleIcon.Image = ModuleData.Icon
            ModuleIcon.ImageColor3 = Color3.fromRGB(255,255,255)
            ModuleIcon.ScaleType = Enum.ScaleType.Fit
            ModuleIcon.ZIndex = 2

            local ModuleDetails = Instance.new("Frame", ModuleData.Objects.Module)
            ModuleDetails.BackgroundTransparency = 1
            ModuleDetails.Position = UDim2.fromOffset(40, 2)
            ModuleDetails.Size = UDim2.new(1, -40, 0, 40)

            local ModuleDetailsList = Instance.new("UIListLayout", ModuleDetails)
            ModuleDetailsList.SortOrder = Enum.SortOrder.LayoutOrder
            ModuleDetailsList.Padding = UDim.new(0, 2)
            ModuleDetailsList.VerticalAlignment = Enum.VerticalAlignment.Center

            local NameText = Instance.new("TextLabel", ModuleDetails)
            NameText.BackgroundTransparency = 1
            NameText.Size = UDim2.fromScale(1, 0.35)
            NameText.ZIndex = 2
            NameText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
            NameText.Text = ModuleData.Name
            NameText.TextColor3 = Color3.fromRGB(255,255,255)
            NameText.TextSize = 16
            NameText.TextTruncate = Enum.TextTruncate.AtEnd
            NameText.TextXAlignment = Enum.TextXAlignment.Left
            NameText.TextYAlignment = Enum.TextYAlignment.Bottom

            local KeybindInfoText = Instance.new("TextLabel", ModuleDetails)
            KeybindInfoText.AnchorPoint = Vector2.new(0.5, 1)
            KeybindInfoText.BackgroundTransparency = 1
            KeybindInfoText.Size = UDim2.new(0.9, 0, 0, 15)
            KeybindInfoText.ZIndex = 2
            KeybindInfoText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
            KeybindInfoText.Text = "No Keybind Set"
            KeybindInfoText.TextColor3 = Color3.fromRGB(255,255,255)
            KeybindInfoText.TextSize = 14
            KeybindInfoText.TextTransparency = 0.5
            KeybindInfoText.TextXAlignment = Enum.TextXAlignment.Left
            KeybindInfoText.TextWrapped = true

            local KeybindInfoPadding = Instance.new("UIPadding", KeybindInfoText)
            KeybindInfoPadding.PaddingLeft = UDim.new(0, 20)

            local KeybindInfoIcon = Instance.new("ImageLabel", KeybindInfoText)
            KeybindInfoIcon.AnchorPoint = Vector2.new(0, 0.5)
            KeybindInfoIcon.BackgroundTransparency = 1
            KeybindInfoIcon.Position = UDim2.new(0, -20, 0.5, 0)
            KeybindInfoIcon.Size = UDim2.fromOffset(15, 15)
            KeybindInfoIcon.Image = "rbxassetid://11422155687"
            KeybindInfoIcon.ImageColor3 = Color3.fromRGB(255,255,255)
            KeybindInfoIcon.ImageTransparency = 0.5
            KeybindInfoIcon.ScaleType = Enum.ScaleType.Fit
            KeybindInfoIcon.ZIndex = 2

            local Requirements = Instance.new("Frame", ModuleData.Objects.Module)
            Requirements.AnchorPoint = Vector2.new(0.5, 0)
            Requirements.BackgroundTransparency = 1
            Requirements.BorderSizePixel = 0
            Requirements.Position = UDim2.new(0.5, 0, 0, 2)
            Requirements.Size = UDim2.new(1, 0, 0, 165)
            Requirements.Visible = false

            local RequirementsList = Instance.new("UIListLayout", Requirements)
            RequirementsList.SortOrder = Enum.SortOrder.LayoutOrder
            RequirementsList.Padding = UDim.new(0, 10)
            RequirementsList.HorizontalAlignment = Enum.HorizontalAlignment.Right


            local ToggleButton = Instance.new("ImageButton", Requirements)
            ToggleButton.AutoButtonColor = false
            ToggleButton.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
            ToggleButton.Position = UDim2.fromOffset(0, 55)
            ToggleButton.Size = UDim2.fromOffset(40, 40)
            ToggleButton.ZIndex = 2
            Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)

            local ToggleButtonPadding = Instance.new("UIPadding", ToggleButton)
            ToggleButtonPadding.PaddingLeft = UDim.new(0, 10)

            local ToggleButtonEnabledIcon = Instance.new("ImageLabel", ToggleButton)
            ToggleButtonEnabledIcon.BackgroundTransparency = 1
            ToggleButtonEnabledIcon.Position = UDim2.fromScale(0, 0.25)
            ToggleButtonEnabledIcon.Size = UDim2.fromOffset(20, 20)
            ToggleButtonEnabledIcon.ZIndex = 2
            ToggleButtonEnabledIcon.Image = "rbxassetid://3926305904"
            ToggleButtonEnabledIcon.ImageColor3 = Color3.fromRGB(255,255,255)
            ToggleButtonEnabledIcon.ImageRectOffset = Vector2.new(284, 4)
            ToggleButtonEnabledIcon.ImageRectSize = Vector2.new(24, 24)

            local DescriptionText = Instance.new("TextLabel", Requirements)
            DescriptionText.BackgroundTransparency = 1
            DescriptionText.LayoutOrder = 100
            DescriptionText.Size = UDim2.new(1, 0, 0, 20)
            DescriptionText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
            DescriptionText.Text = ModuleData.Description
            DescriptionText.TextColor3 = Color3.fromRGB(255,255,255)
            DescriptionText.TextSize = 12
            DescriptionText.TextTransparency = 0.6
            DescriptionText.TextXAlignment = Enum.TextXAlignment.Left

            local SettingsButton = Instance.new("TextButton", Requirements)
            SettingsButton.AnchorPoint = Vector2.new(0.5, 0)
            SettingsButton.AutoButtonColor = false
            SettingsButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            SettingsButton.BackgroundTransparency = 0.7
            SettingsButton.LayoutOrder = 5
            SettingsButton.Size = UDim2.new(1, 0, 0, 50)
            SettingsButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
            SettingsButton.Text = ModuleData.Name .. " Settings"
            SettingsButton.TextColor3 = Color3.fromRGB(255,255,255)
            SettingsButton.TextSize = 16
            SettingsButton.TextTransparency = 0.2
            SettingsButton.TextXAlignment = Enum.TextXAlignment.Left
            SettingsButton.ZIndex = 2
            SettingsButton.Visible = false
            Instance.new("UICorner", SettingsButton).CornerRadius = UDim.new(0, 12)

            local SettingsButtonPadding = Instance.new("UIPadding", SettingsButton)
            SettingsButtonPadding.PaddingBottom = UDim.new(0, 1)
            SettingsButtonPadding.PaddingLeft = UDim.new(0, 20)
            SettingsButtonPadding.PaddingRight = UDim.new(0, 15)

            local SettingsButtonIcon = Instance.new("ImageLabel", SettingsButton)
            SettingsButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
            SettingsButtonIcon.BackgroundTransparency = 1
            SettingsButtonIcon.Position = UDim2.fromScale(1, 0.5)
            SettingsButtonIcon.Size = UDim2.fromOffset(20, 20)
            SettingsButtonIcon.Image = "rbxassetid://11419703997"
            SettingsButtonIcon.ImageColor3 = Color3.fromRGB(255,255,255)
            SettingsButtonIcon.ImageTransparency = 0.5
            SettingsButtonIcon.ScaleType = Enum.ScaleType.Fit
            SettingsButtonIcon.ZIndex = 2

            local Backbutton = Instance.new("ImageButton", tab.Objects.ContentCanvas)
            Backbutton.BackgroundColor3 = Color3.fromRGB(SpaceUI.Config.UI.TabColor.value1 + 20, SpaceUI.Config.UI.TabColor.value2 + 20, SpaceUI.Config.UI.TabColor.value3 + 20)
            Backbutton.Position = UDim2.new(1.8, 0, 0, 5)
            Backbutton.Size = UDim2.fromOffset(30, 30)
            Backbutton.AutoButtonColor = false
            Backbutton.ZIndex = 2
            Backbutton.Visible = false
            Instance.new("UICorner", Backbutton).CornerRadius = UDim.new(1, 0)
            ModuleData.Objects.BackButton = Backbutton

            local BackButtonIcon = Instance.new("ImageLabel", Backbutton)
            BackButtonIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            BackButtonIcon.BackgroundTransparency = 1
            BackButtonIcon.Position = UDim2.fromScale(0.5, 0.5)
            BackButtonIcon.Size = UDim2.fromOffset(16, 16)
            BackButtonIcon.Image = "rbxassetid://11293981980"
            BackButtonIcon.ImageTransparency = 0.2
            BackButtonIcon.ZIndex = 2
            BackButtonIcon.ScaleType = Enum.ScaleType.Fit

            local ModuleSettingsList = Instance.new("UIListLayout", nil)
            ModuleSettingsList.SortOrder = Enum.SortOrder.LayoutOrder
            ModuleSettingsList.Padding = UDim.new(0, 15)
            ModuleSettingsList.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local ModuleSettings = Instance.new("Folder", ModuleData.Objects.Module)

            local KeyBindButton = Instance.new("TextButton", tab.Objects.ContentCanvas)
            KeyBindButton.AnchorPoint = Vector2.new(0.5, 1)
            KeyBindButton.AutoButtonColor = false
            KeyBindButton.BackgroundColor3 = Color3.fromRGB(SpaceUI.Config.UI.KeybindColor.value1, SpaceUI.Config.UI.KeybindColor.value2, SpaceUI.Config.UI.KeybindColor.value3)
            KeyBindButton.BackgroundTransparency = SpaceUI.Config.UI.KeybindTransparency
            KeyBindButton.Position = UDim2.new(0.5,0,1,-20)
            KeyBindButton.Size = UDim2.new(1, -40, 0, 45)
            KeyBindButton.ZIndex = 2
            KeyBindButton.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.SemiBold)
            KeyBindButton.Text = "CLICK TO BIND"
            KeyBindButton.TextColor3 = Color3.fromRGB(255,255,255)
            KeyBindButton.TextSize = 17
            KeyBindButton.Visible = false
            Instance.new("UICorner", KeyBindButton).CornerRadius = UDim.new(1, 0)
            ModuleData.Objects.KeybindButton = KeyBindButton

            local DropOpen = false
            local db = false
            local DropOpen = false
            local db = false
            local _toggleJustClicked = false

            local function _collapsePanel()
                DropOpen = false
                TweenService:Create(ModuleData.Objects.Module, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 65)}):Play()
                if not ModuleData.Data.Enabled then
                    Requirements.Visible = false
                    TweenService:Create(Requirements, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 2)}):Play()
                else
                    TweenService:Create(DescriptionText, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
                    TweenService:Create(SettingsButton, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
                    TweenService:Create(SettingsButtonIcon, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
                    task.wait(0.5)
                    DescriptionText.Visible = false
                    SettingsButton.Visible = false
                end
            end

            local function _expandPanel()
                DropOpen = true
                DescriptionText.TextTransparency = 0.6
                SettingsButton.TextTransparency = 0.2
                SettingsButton.BackgroundTransparency = 0.7
                SettingsButtonIcon.ImageTransparency = 0.5
                DescriptionText.Visible = true
                SettingsButton.Visible = true
                Requirements.Visible = true
                Requirements.AnchorPoint = Vector2.new(0.5, 1)
                Requirements.Position = UDim2.new(0.5, 0, 1, 2)
                TweenService:Create(Requirements, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 2)}):Play()
                TweenService:Create(ModuleData.Objects.Module, TweenInfo.new(0.5, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 150)}):Play()
            end

            local moduleclickcon = ModuleData.Objects.Module.MouseButton1Click:Connect(function()
                -- ToggleButton click bubble lên đây -> bỏ qua, đã handle ở togglebuttoncon
                if _toggleJustClicked then
                    _toggleJustClicked = false
                    return
                end
                if db then return end
                db = true
                if DropOpen then
                    _collapsePanel()
                else
                    _expandPanel()
                end
                db = false
            end)
            table.insert(SpaceUI.Connections, moduleclickcon)
            table.insert(ModuleData.Connections, moduleclickcon)

                        -- [Shortcut Integration] Auto register module to CustomShortcuts
            pcall(function()
                if Assets.Shortcut and Assets.Shortcut.CustomShortcuts then
                    local sName = ModuleData.Flag or ModuleData.Name
                    Assets.Shortcut.CustomShortcuts:RegisterShortcut(sName, {
                        Name = sName,
                        Alias = ModuleData.Name,
                        Icon = tab.Icon or "rbxassetid://11295288868",
                        Category = tab.Name or "SpaceUI",
                        Callback = function()
                            ModuleData.Functions.Toggle(not ModuleData.Data.Enabled, false, true, true, true)
                        end
                    })
                end
            end)

ModuleData.onToggles = {}
            ModuleData.Functions.Toggle = function(enabled: boolean, override: boolean, notify: boolean, save: boolean, updateArray: boolean)
                if setthreadidentity then
                    setthreadidentity(8)
                end

                if notify == nil then notify = true end
                if enabled == nil or typeof(enabled) == "string" then
                    enabled = not ModuleData.Data.Enabled
                end
                if save == nil then save = true end
                if ModuleData.Button then
                    ModuleData.Callback(ModuleData, true); task.wait(0.1); ModuleData.Callback(ModuleData, false)
                end

                local Array
                pcall(function()
                    if not SpaceUI.ArrayList.Loaded then
                        Array = Assets.ArrayList.Init()
                    else
                        Array = SpaceUI.ArrayList
                    end
                end)

                if enabled then
                    if not ModuleData.Data.Enabled or override then
                        ModuleData.Data.Enabled = enabled
                        task.spawn(function()
                            ModuleData.Callback(ModuleData, enabled)
                        end)

                        task.spawn(function()
                            for i,v in next, ModuleData.onToggles do
                                v(ModuleData, enabled)
                            end
                        end)

                        if updateArray and Array and Array.Functions then
                            pcall(function()
                                ModuleData.Data.ArrayIndex = Array.Functions.PushModule({
                                    Name = ModuleData.Name
                                })
                            end)
                        end

                        if not DropOpen then
                            DescriptionText.Visible = false
                            SettingsButton.Visible = false
                            Requirements.Visible = true
                            Requirements.AnchorPoint = Vector2.new(0.5, 0)
                            Requirements.Position = UDim2.new(0.5, 0, 0, 2)
                        end
                        TweenService:Create(ToggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(32, 175, 77)}):Play()
                        TweenService:Create(ToggleButtonEnabledIcon, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()
                        task.wait(0.05)
                        ToggleButtonEnabledIcon.ImageRectOffset = Vector2.new(644, 204)
                        ToggleButtonEnabledIcon.ImageRectSize = Vector2.new(36, 36)
                        TweenService:Create(ToggleButtonEnabledIcon, TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
                        if notify and SpaceUI.Config.UI.Notifications then
                            Assets.Notifications.Send({
                                Description = ModuleData.Name.." enabled!",
                                Duration = 2.5
                            })
                        end
                    end
                else
                    if ModuleData.Data.Enabled or override then
                        ModuleData.Data.Enabled = enabled
                        task.spawn(function()
                            ModuleData.Callback(ModuleData, enabled)
                            for i,v in next, ModuleData.onToggles do
                                v(ModuleData, enabled)
                            end
                        end)

                        if updateArray and ModuleData.Data.ArrayIndex then
                            pcall(function()
                                local Index = ModuleData.Data.ArrayIndex
                                if Index.Deconstruct then
                                    Index.Deconstruct()
                                end
                            end)
                            ModuleData.Data.ArrayIndex = nil
                        end

                        TweenService:Create(ToggleButton, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(43, 43, 43)}):Play()
                        TweenService:Create(ToggleButtonEnabledIcon, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()
                        task.wait(0.05)
                        ToggleButtonEnabledIcon.ImageRectOffset = Vector2.new(284, 4)
                        ToggleButtonEnabledIcon.ImageRectSize = Vector2.new(24, 24)
                        TweenService:Create(ToggleButtonEnabledIcon, TweenInfo.new(0.1), {ImageTransparency = 0}):Play()
                        if not DropOpen then
                            Requirements.Visible = false
                            DescriptionText.Visible = true
                            SettingsButton.Visible = true
                            Requirements.AnchorPoint = Vector2.new(0.5, 1)
                            Requirements.Position = UDim2.new(0.5, 0, 1, 2)
                        end
                        if notify and SpaceUI.Config.UI.Notifications then
                            Assets.Notifications.Send({
                                Description = ModuleData.Name.." disabled!",
                                Duration = 2.5
                            })
                        end
                    end
                end
                if save then
                    SpaceUI.Config.Game.Modules[ModuleData.Flag] = enabled
                    Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                end
            end

            if SpaceUI.Mobile then
                KeyBindButton.Text = "TAP TO BIND"
            end

            ModuleData.Functions.BindKeybind = function(Bind: string, Save: boolean)
                if not ModuleData.Data.Keybind then
                    local suc = pcall(function()
                        if not SpaceUI.Mobile then
                            ModuleData.Data.Keybind = Enum.KeyCode[Bind]
                            ModuleData.Data.SettingKeybind = false
                            KeybindInfoText.Text = "Set Keybind is: "..Bind
                            KeyBindButton.Text = "Bound to: "..Bind
                        else
                            SpaceUI.Background.Functions.CreateMobileButton({
                                Name = ModuleData.Name,
                                Flag = ModuleData.Flag.."MobileButton",
                                Callbacks = {
                                    End = function(self, drag : boolean)
                                        if drag then return end
                                        ModuleData.Functions.Toggle(nil, false, true, true, true)
                                    end
                                }
                            })
                            KeyBindButton.Text = "TAP TO UNBIND"
                            KeybindInfoText.Text = "Set Keybind is a Button"
                            ModuleData.Data.Keybind = "button"
                        end
                    end)

                    if Save and suc then
                        SpaceUI.Config.Game.Keybinds[ModuleData.Flag] = Bind
                        Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                    end
                end
            end

            ModuleData.Functions.UnbindKeybind = function(Save: boolean)
                if SpaceUI.Mobile then
                    if SpaceUI.Background.MobileButtons and SpaceUI.Background.MobileButtons.Buttons[ModuleData.Flag.."MobileButton"] and SpaceUI.Background.MobileButtons.Buttons[ModuleData.Flag.."MobileButton"].Functions then
                        SpaceUI.Background.MobileButtons.Buttons[ModuleData.Flag.."MobileButton"].Functions.Destroy()
                    end
                    KeyBindButton.Text = "TAP TO BIND"
                else
                    ModuleData.Data.Keybind = nil 
                    KeyBindButton.Text = "CLICK TO BIND" 
                    ModuleData.Data.SettingKeybind = false
                end

                KeybindInfoText.Text = "No Keybind Set"
                SpaceUI.Config.Game.Keybinds[ModuleData.Flag] = nil
                ModuleData.Data.Keybind = nil

                if Save then
                    Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                end
            end

                        local keybindbuttonpresscon = KeyBindButton.MouseButton1Click:Connect(function()
                if SpaceUI.Config.UI.ShortcutEnabled then
                    if ModuleData.Data.Keybind then
                        local sName = ModuleData.Flag or ModuleData.Name
                        if Assets.Shortcut and Assets.Shortcut.UnbindModuleFromSlots then
                            Assets.Shortcut.UnbindModuleFromSlots(sName)
                        end
                        ModuleData.Functions.UnbindKeybind(true)
                        KeyBindButton.Text = SpaceUI.Mobile and "TAP TO BIND" or "CLICK TO BIND"
                        if Assets.Notifications then
                            Assets.Notifications.Send({
                                Description = "Unbound " .. ModuleData.Name .. " from Shortcut!",
                                Duration = 2
                            })
                        end
                    else
                        local sName = ModuleData.Flag or ModuleData.Name
                        local assignedSlot = "Action-1"
                        if Assets.Shortcut and Assets.Shortcut.BindModuleToNextSlot then
                            assignedSlot = Assets.Shortcut.BindModuleToNextSlot(
                                sName,
                                ModuleData.Name,
                                tab.Icon,
                                tab.Name,
                                function()
                                    ModuleData.Functions.Toggle(not ModuleData.Data.Enabled, false, true, true, true)
                                end
                            )
                        end
                        ModuleData.Data.Keybind = assignedSlot
                        KeyBindButton.Text = "BOUND TO " .. string.upper(assignedSlot)
                        KeybindInfoText.Text = "Bound to Shortcut: " .. assignedSlot
                        SpaceUI.Config.Game.Keybinds[ModuleData.Flag] = assignedSlot
                        Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                        if Assets.Notifications then
                            Assets.Notifications.Send({
                                Description = "Bound " .. ModuleData.Name .. " to Shortcut (" .. assignedSlot .. ")! Use Replace Action on the Shortcut wheel to rebind.",
                                Duration = 2.5
                            })
                        end
                    end
                elseif not SpaceUI.Mobile then
                    -- Shortcut đang TẮT trên PC: quay về cách bind cũ bằng bấm phím trực tiếp
                    ModuleData.Data.SettingKeybind = true
                    KeyBindButton.Text = "Press Any Key"
                else
                    -- Shortcut đang TẮT trên Mobile: quay về mobile-button kéo thả cũ
                    if ModuleData.Data.Keybind then
                        ModuleData.Functions.UnbindKeybind(true)
                        KeyBindButton.Text = "TAP TO BIND"
                    else
                        ModuleData.Functions.BindKeybind("Binded", true)
                    end
                end
            end)
            table.insert(SpaceUI.Connections, keybindbuttonpresscon)
            table.insert(ModuleData.Connections, keybindbuttonpresscon)

            if SpaceUI.Config.Game.Keybinds[ModuleData.Flag] then
                if SpaceUI.Config.Game.Keybinds[ModuleData.Flag] == "Binded" and SpaceUI.Mobile then
                    ModuleData.Functions.BindKeybind("Binded", false)
                else
                    ModuleData.Functions.BindKeybind(SpaceUI.Config.Game.Keybinds[ModuleData.Flag], false)
                end
            end

            local keybindinputbegancon = UserInputService.InputBegan:Connect(function(input)
                if input.KeyCode then
                    if ModuleData.Data.SettingKeybind then
                        if ModuleData.Data.Keybind and ModuleData.Data.Keybind == input.KeyCode then
                            ModuleData.Functions.UnbindKeybind(true)
                            return
                        end
                        ModuleData.Functions.BindKeybind(input.KeyCode.Name, true)
                    else
                        if not UserInputService:GetFocusedTextBox() then
                            if ModuleData.Data.Keybind and ModuleData.Data.Keybind == input.KeyCode then
                                ModuleData.Functions.Toggle(not ModuleData.Data.Enabled, false, true, true, true)
                            end
                        end
                    end
                end
            end)
            table.insert(SpaceUI.Connections, keybindinputbegancon)
            table.insert(ModuleData.Connections, keybindinputbegancon)


            local togglebuttoncon = ToggleButton.MouseButton1Click:Connect(function()
                -- Set flag để moduleclickcon bỏ qua event bubble-up này
                _toggleJustClicked = true
                ModuleData.Functions.Toggle(not ModuleData.Data.Enabled, false, true, true, true)
            end)
            table.insert(SpaceUI.Connections, togglebuttoncon)
            table.insert(ModuleData.Connections, togglebuttoncon)

            local currentbackbuttonfunc
            local settingsbuttoncon = SettingsButton.MouseButton1Click:Connect(function()
                tab.Data.SettingsOpen = true
                ModuleData.Data.SettingsOpen = true
                tab.Functions.CloseModuleSettings = function() currentbackbuttonfunc() end
                tab.Objects.ActualTab.ClipsDescendants = true      
                tab.ClipNeeded = true          
                TweenService:Create(tab.Objects.ScrollFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(-1.8, 0, 0.04, 50)}):Play()
                TweenService:Create(TabHeader, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(-1.8, 0.04)}):Play()
                TweenService:Create(CloseButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(-1.8, 0, 0, 5)}):Play()
                TweenService:Create(KeyBindButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(-1.8,0,1,-20)}):Play()
                task.wait(0.2)
                if not tab.Data.SettingsOpen then
                    return
                end
                
                for i,v in tab.Modules do
                    v.Objects.Module.Visible = false
                end
                CloseButton.Visible = false
                Backbutton.Visible = true
                ModuleSettings.Parent = tab.Objects.ScrollFrame
                tab.Objects.ScrollFrame.Size = UDim2.new(1, -10, 1, -160)
                ModuleData.Objects.Module.Size = UDim2.fromScale(1, 1)
                ModuleData.Objects.Module.ZIndex = -1000
                ModuleData.Objects.Module.BackgroundTransparency = 1
                ModuleSettingsList.Parent = ModuleSettings
                tab.Objects.ScrollFrame.Position = UDim2.new(1.8, 0, 0.04, 50)
                TabHeader.Position = UDim2.fromScale(1.8, 0.04)
                KeyBindButton.Position = UDim2.new(1.8,0,1,-20)
                TabHeader.Text = ModuleData.Name .. " Settings"

                SearchBar.Visible = false
                KeyBindButton.Visible = true
                for i,v in ModuleData.Objects.Module:GetChildren() do
                    if v:IsA("Frame") or v:IsA("ImageLabel") then
                        v.Visible = false
                    end
                end
                for i,v in tab.Modules do
                    if v ~= ModuleData then
                        v.Objects.Module.Visible = false
                    end
                end
                for i,v in ModuleData.Settings do
                    if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, v) then
                        v.Objects.MainInstance.Visible = true
                    end
                end

                TweenService:Create(tab.Objects.ScrollFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0.04, 50)}):Play()
                TweenService:Create(TabHeader, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(0.5, 0.04)}):Play()
                TweenService:Create(Backbutton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromOffset(5, 5)}):Play()
                TweenService:Create(KeyBindButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5,0,1,-20)}):Play()
                tab.ClipNeeded = false
                task.wait(0.8)
                if not tab.ClipNeeded then
                    tab.Objects.ActualTab.ClipsDescendants = false
                end
            end)
            table.insert(SpaceUI.Connections, settingsbuttoncon)
            table.insert(ModuleData.Connections, settingsbuttoncon)

            currentbackbuttonfunc = function()
                tab.Data.SettingsOpen = false
                ModuleData.Data.SettingsOpen = false
                if ModuleData.Data.SettingKeybind then
                    ModuleData.Data.SettingKeybind = false
                    KeyBindButton.Text = "CLICK TO BIND"
                end
                tab.Objects.ActualTab.ClipsDescendants = true
                tab.ClipNeeded = true
                ModuleSettings.Parent = ModuleData.Objects.Module
                tab.Objects.ScrollFrame.Size = UDim2.new(1, -10, 1, -70)
                ModuleData.Objects.Module.Size = UDim2.new(1, 0, 0, 150)
                TweenService:Create(tab.Objects.ScrollFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(1.8, 0, 0.04, 50)}):Play()
                TweenService:Create(TabHeader, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(1.8, 0.04)}):Play()
                TweenService:Create(Backbutton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(1.8, 0, 0, 5)}):Play()
                TweenService:Create(KeyBindButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(1.8,0,1,-20)}):Play()
                task.wait(0.2)
                for i,v in tab.Modules do
                    v.Objects.Module.Visible = true
                end
                Backbutton.Visible = false
                CloseButton.Visible = true
                ModuleData.Objects.Module.ZIndex = 2
                tab.Objects.ScrollFrame.Position = UDim2.new(-1.8, 0, 0.04, 50)
                TabHeader.Position = UDim2.fromScale(-1.8, 0.04)
                ModuleSettingsList.Parent = nil
                ModuleData.Objects.Module.BackgroundTransparency = 0.95
                KeyBindButton.Position = UDim2.new(-1.8,0,1,-20)
                KeyBindButton.Visible = false

                TabHeader.Text = tab.Name
                SearchBar.Visible = true
                for i,v in ModuleData.Objects.Module:GetChildren() do
                    if v:IsA("Frame") or v:IsA("ImageLabel") then
                        v.Visible = true
                    end
                end
                for i,v in ModuleData.Settings do
                    v.Objects.MainInstance.Visible = false
                end
                for i,v in tab.Modules do
                    v.Objects.Module.Visible = true
                end


                TweenService:Create(tab.Objects.ScrollFrame, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(0.5, 0, 0.04, 50)}):Play()
                TweenService:Create(TabHeader, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.fromScale(0.5, 0.04)}):Play()
                TweenService:Create(CloseButton, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Position = UDim2.new(1, -5, 0, 5)}):Play()
                tab.ClipNeeded = false
                task.wait(0.8)
                if not tab.ClipNeeded then
                    tab.Objects.ActualTab.ClipsDescendants = false
                end
            end

            local settingsbackbuttoncon = Backbutton.MouseButton1Click:Connect(function() currentbackbuttonfunc() end)
            table.insert(SpaceUI.Connections, settingsbackbuttoncon)
            table.insert(ModuleData.Connections, settingsbackbuttoncon)

            ModuleData.Functions.ConstructSetting = function(data: {Size: number, Description: string, Name: string, ToolTip: string, OnToolTipEdit: any, Layout: boolean})
                local ConstructionData = {
                    Name = data and data.Name or "Setting",
                    Description = data and data.Description or "Setting",
                    ToolTip = data and data.ToolTip or "Tooltip",
                    YSize = data and data.Size or 100,
                    NeedsLayout = data and data.Layout,
                    Objects = {},
                    Functions = {},
                    OnToolTipEdit = data and data.OnToolTipEdit or function() end
                }

                ConstructionData.Objects.MainInstance = Instance.new("ImageButton", ModuleSettings)
                ConstructionData.Objects.MainInstance.AutoButtonColor = false
                ConstructionData.Objects.MainInstance.BackgroundColor3 = Color3.fromRGB(0,0,0)
                ConstructionData.Objects.MainInstance.BackgroundTransparency = 0.8
                ConstructionData.Objects.MainInstance.Size = UDim2.new(1, 0, 0, ConstructionData.YSize)
                ConstructionData.Objects.MainInstance.ImageTransparency = 1
                ConstructionData.Objects.MainInstance.Visible = false
                ConstructionData.Objects.MainInstance.ZIndex = 2
                Instance.new("UICorner", ConstructionData.Objects.MainInstance).CornerRadius = UDim.new(0, 10)
                
                if ConstructionData.NeedsLayout then
                    local layout = Instance.new("UIListLayout", ConstructionData.Objects.MainInstance)
                    layout.Padding = UDim.new(0, 10)
                    layout.SortOrder = Enum.SortOrder.LayoutOrder
                end

                local SettingPadding = Instance.new("UIPadding", ConstructionData.Objects.MainInstance)
                SettingPadding.PaddingBottom = UDim.new(0, 10)
                SettingPadding.PaddingLeft = UDim.new(0, 15)
                SettingPadding.PaddingRight = UDim.new(0, 15)
                SettingPadding.PaddingTop = UDim.new(0, 10)

                local stroke = Instance.new("UIStroke", ConstructionData.Objects.MainInstance)
                stroke.Color = Color3.fromRGB(255, 255, 255)
                stroke.Transparency = 0.95

                local SettingDescLabel = Instance.new("TextLabel", ConstructionData.Objects.MainInstance)
                SettingDescLabel.AnchorPoint = Vector2.new(0, 1)
                SettingDescLabel.BackgroundTransparency = 1
                SettingDescLabel.Position = UDim2.fromScale(0, 1)
                SettingDescLabel.Size = UDim2.new(0.997, 0, 0, 15)
                SettingDescLabel.ZIndex = 2
                SettingDescLabel.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                SettingDescLabel.Text = ConstructionData.Description
                SettingDescLabel.TextColor3 = Color3.fromRGB(255,255,255)
                SettingDescLabel.TextSize = 13
                SettingDescLabel.TextTransparency = 0.6
                SettingDescLabel.TextXAlignment = Enum.TextXAlignment.Left
                SettingDescLabel.LayoutOrder = 3

                local SettingDetails = Instance.new("Frame", ConstructionData.Objects.MainInstance)
                SettingDetails.BackgroundTransparency = 1
                SettingDetails.Size = UDim2.new(0.63, 0, 0, 35)
                SettingDetails.LayoutOrder = 1
                SettingDetails.ZIndex = 2

                local SettingNameText = Instance.new("TextLabel", SettingDetails)
                SettingNameText.ZIndex = 2
                SettingNameText.BackgroundTransparency = 1
                SettingNameText.Size = UDim2.new(0.997, 0, 0, 15)
                SettingNameText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
                SettingNameText.Text = ConstructionData.Name
                SettingNameText.TextColor3 = Color3.fromRGB(255, 255, 255)
                SettingNameText.TextSize = 15
                SettingNameText.TextTransparency = 0.1
                SettingNameText.TextTruncate = Enum.TextTruncate.AtEnd
                SettingNameText.TextXAlignment = Enum.TextXAlignment.Left
                SettingNameText.TextYAlignment = Enum.TextYAlignment.Bottom

                local ToolTip = Instance.new("TextLabel", SettingDetails)
                ToolTip.ZIndex = 2
                ToolTip.AnchorPoint = Vector2.new(0, 1)
                ToolTip.BackgroundTransparency = 1
                ToolTip.Position = UDim2.new(0, 20, 1, 0)
                ToolTip.Size = UDim2.new(0.944, 0, 0, 15)
                ToolTip.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                ToolTip.Text = ConstructionData.ToolTip
                ToolTip.TextColor3 = Color3.fromRGB(255, 255, 255)
                ToolTip.TextSize = 13
                ToolTip.TextTransparency = 0.6
                ToolTip.TextXAlignment = Enum.TextXAlignment.Left

                local ToolTipIcon = Instance.new("ImageLabel", SettingDetails)
                ToolTipIcon.ZIndex = 2
                ToolTipIcon.BackgroundTransparency = 1
                ToolTipIcon.Position = UDim2.fromScale(-0.004, 0.571)
                ToolTipIcon.Size = UDim2.fromOffset(15, 15)
                ToolTipIcon.Image = "rbxassetid://82132857700485"
                ToolTipIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                ToolTipIcon.ImageTransparency = 0.6
                ToolTipIcon.ScaleType = Enum.ScaleType.Stretch

                ConstructionData.Functions.EditToolTip = function(newdata: {ToolTip: string})
                    if newdata.ToolTip then
                        ConstructionData.ToolTip = newdata.ToolTip
                        ToolTip.Text = newdata.ToolTip

                        ConstructionData.OnToolTipEdit({ToolTip = newdata.ToolTip})
                    end
                end

                return ConstructionData
            end
            
            ModuleData.Functions.Settings.TextBox = function(data)
                local TextBoxData = {
                    Name = data and data.Name or "Textbox",
                    PlaceHolderText = data and data.PlaceHolderText or data and data.Name or "",
                    Description = data and data.Description or "Textbox",
                    ToolTip = data and data.ToolTip or "Click to Enter A Value",
                    Flag = data and data.Flag or data and data.Name or "New TextBox",
                    Default = data and data.Default or "",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Type = "TextBoxes",
                    Objects = {},
                    Functions = {}
                }

                if SpaceUI.Config.Game.TextBoxes[TextBoxData.Flag] then
                    TextBoxData.Default = SpaceUI.Config.Game.TextBoxes[TextBoxData.Flag]                
                end
                
                TextBoxData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = TextBoxData.Name,
                    Description = TextBoxData.Description,
                    Size = 125,
                    ToolTip = TextBoxData.ToolTip,
                    Layout = true,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        TextBoxData.ToolTip = new.ToolTip
                    end
                })

                TextBoxData.Objects.MainInstance = TextBoxData.Construction.Objects.MainInstance
                if SpaceUI.Mobile and TextBoxData.ToolTip == "Click to Enter A Value" then
                    TextBoxData.Construction.Functions.EditToolTip({ToolTip = "Tap to Enter A Value"})
                end

                TextBoxData.Functions.EditToolTip = TextBoxData.Construction.Functions.EditToolTip

                TextBoxData.Objects.MainInstance.AutomaticSize = Enum.AutomaticSize.Y

                local ActualTextBoxBox = Instance.new("Frame", TextBoxData.Objects.MainInstance)
                ActualTextBoxBox.ZIndex = 2
                ActualTextBoxBox.AnchorPoint = Vector2.new(1,0.5)
                ActualTextBoxBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                ActualTextBoxBox.BackgroundTransparency = 0.6
                ActualTextBoxBox.Size = UDim2.new(1, 0, 0, 35)
                ActualTextBoxBox.LayoutOrder = 2
                ActualTextBoxBox.AutomaticSize = Enum.AutomaticSize.Y
                Instance.new("UICorner", ActualTextBoxBox).CornerRadius = UDim.new(0, 6)

                local BoxStroke = Instance.new("UIStroke", ActualTextBoxBox)
                BoxStroke.Color = Color3.fromRGB(255,255,255)
                BoxStroke.Transparency = 0.9
                
                local BoxPadding = Instance.new("UIPadding", ActualTextBoxBox)
                BoxPadding.PaddingBottom = UDim.new(0, 12)
                BoxPadding.PaddingLeft = UDim.new(0, 15)
                BoxPadding.PaddingTop = UDim.new(0, 12)

                local ActualTextBox = Instance.new("TextBox", ActualTextBoxBox)
                ActualTextBox.ZIndex = 2
                ActualTextBox.BackgroundTransparency = 1
                ActualTextBox.BorderSizePixel = 0
                ActualTextBox.Position = UDim2.fromScale(0, 0)
                ActualTextBox.Size = UDim2.fromScale(0.98, 0.26)
                ActualTextBox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
                ActualTextBox.PlaceholderColor3 = Color3.fromRGB(140, 140, 140)
                ActualTextBox.Text = TextBoxData.Default
                ActualTextBox.TextColor3 = Color3.fromRGB(255,255,255)
                ActualTextBox.TextSize = 13
                ActualTextBox.TextTransparency = 0.2
                ActualTextBox.TextWrapped = true
                ActualTextBox.TextXAlignment = Enum.TextXAlignment.Left
                ActualTextBox.AutomaticSize = Enum.AutomaticSize.Y

                if TextBoxData.PlaceHolderText and typeof(TextBoxData.PlaceHolderText) == "string" then
                    ActualTextBox.PlaceholderText = TextBoxData.PlaceHolderText
                end

                TextBoxData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, TextBoxData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, TextBoxData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            TextBoxData.Objects.MainInstance.Visible = enabled
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, TextBoxData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, TextBoxData)
                        end
                        TextBoxData.Objects.MainInstance.Visible = false
                    end
                end

                if TextBoxData.Hide then
                    TextBoxData.Functions.SetVisiblity(false)
                end

                TextBoxData.Functions.SetValue = function(text: string, save: boolean)
                    if text and tostring(text) then
                        text = tostring(text)

                        ActualTextBox.Text = text
                        TextBoxData.Callback(TextBoxData, text)
                        SpaceUI.Config.Game.TextBoxes[TextBoxData.Flag] = text
                        if save then
                            Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                        end
                    end
                end

                local actualtextboxfocuslostcon = ActualTextBox.FocusLost:Connect(function() 
                    TextBoxData.Callback(TextBoxData, ActualTextBox.Text)
                    SpaceUI.Config.Game.TextBoxes[TextBoxData.Flag] = ActualTextBox.Text
                    Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                end)
                table.insert(SpaceUI.Connections, actualtextboxfocuslostcon)
                table.insert(ModuleData.Connections, actualtextboxfocuslostcon)

                ModuleData.Settings[TextBoxData.Flag] = TextBoxData
                return TextBoxData
            end

            ModuleData.Functions.Settings.MiniToggle = function(data)
                local MiniToggleData = {
                    Name = data and data.Name or "New MiniToggle",
                    Description = data and data.Description or "MiniToggle",
                    ToolTip = data and data.Tooltip or "Click to toggle",
                    Default = data and data.Default or false,
                    Enabled = false,
                    Flag = data and data.Flag or data and data.Name or "New MiniToggle",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Type = "MiniToggles",
                    Objects = {},
                    Functions = {}
                }

                MiniToggleData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = MiniToggleData.Name,
                    Description = MiniToggleData.Description,
                    Size = 80,
                    Layout = false,
                    ToolTip = MiniToggleData.ToolTip,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        MiniToggleData.ToolTip = new.ToolTip
                    end
                })

                MiniToggleData.Objects.MainInstance = MiniToggleData.Construction.Objects.MainInstance
                if SpaceUI.Mobile and MiniToggleData.ToolTip == "Click to toggle" then
                    MiniToggleData.Construction.Functions.EditToolTip({ToolTip = "Tap to toggle"})
                end
                
                MiniToggleData.Functions.EditToolTip = MiniToggleData.Construction.Functions.EditToolTip

                local ToggleBox = Instance.new("Frame", MiniToggleData.Objects.MainInstance)
                ToggleBox.ZIndex = 2
                ToggleBox.AnchorPoint = Vector2.new(1, 0.5)
                ToggleBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                ToggleBox.BackgroundTransparency = 0.4
                ToggleBox.Position = UDim2.fromScale(1, 0.5)
                ToggleBox.Size = UDim2.fromOffset(36, 21)
                Instance.new("UICorner", ToggleBox).CornerRadius = UDim.new(0, 15)
                
                local ToggleCircle = Instance.new("Frame", ToggleBox)
                ToggleCircle.ZIndex = 2
                ToggleCircle.AnchorPoint = Vector2.new(0, 0.5)
                ToggleCircle.BackgroundColor3 = Color3.fromRGB(34, 34, 34)
                ToggleCircle.Position = UDim2.fromScale(0.05, 0.5)
                ToggleCircle.Size = UDim2.fromOffset(17, 17)
                Instance.new("UICorner", ToggleCircle).CornerRadius = UDim.new(0, 15)

                MiniToggleData.Functions.Toggle = function(enabled, save, override)
                    if enabled and not MiniToggleData.Enabled or override or not enabled and MiniToggleData.Enabled then
                        MiniToggleData.Callback(MiniToggleData, enabled)
                    end
                    if enabled then
                        TweenService:Create(ToggleBox, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(195, 195, 195)}):Play()
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.fromScale(0.95, 0.5)}):Play()
                    else
                        TweenService:Create(ToggleCircle, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.fromScale(0.05, 0.5)}):Play()
                        TweenService:Create(ToggleBox, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.4, BackgroundColor3 = Color3.fromRGB(65, 65, 65)}):Play()

                    end
                    MiniToggleData.Enabled = enabled

                    if save then
                        SpaceUI.Config.Game.MiniToggles[MiniToggleData.Flag] = enabled
                        Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                    end
                end
                MiniToggleData.Functions.SetValue = MiniToggleData.Functions.Toggle

                MiniToggleData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, MiniToggleData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, MiniToggleData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            MiniToggleData.Objects.MainInstance.Visible = enabled
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, MiniToggleData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, MiniToggleData)
                        end
                        MiniToggleData.Objects.MainInstance.Visible = false
                    end
                end

                
                if MiniToggleData.Hide then
                    MiniToggleData.Functions.SetVisiblity(false)
                end

                local minitoggleclickcon = MiniToggleData.Objects.MainInstance.MouseButton1Click:Connect(function()
                    MiniToggleData.Functions.Toggle(not MiniToggleData.Enabled, true)
                end)
                table.insert(SpaceUI.Connections, minitoggleclickcon)
                table.insert(ModuleData.Connections, minitoggleclickcon)

                                -- [Shortcut Integration] Auto register MiniToggle to CustomShortcuts
                pcall(function()
                    if Assets.Shortcut and Assets.Shortcut.CustomShortcuts then
                        local sName = (ModuleData.Flag or ModuleData.Name) .. "_" .. (MiniToggleData.Flag or MiniToggleData.Name)
                        Assets.Shortcut.CustomShortcuts:RegisterShortcut(sName, {
                            Name = sName,
                            Alias = ModuleData.Name .. " - " .. MiniToggleData.Name,
                            Icon = tab.Icon or "rbxassetid://11295288868",
                            Category = tab.Name or "SpaceUI",
                            Callback = function()
                                MiniToggleData.Functions.Toggle(not MiniToggleData.Enabled, true)
                            end
                        })
                    end
                end)

ModuleData.Settings[MiniToggleData.Flag] = MiniToggleData
                return MiniToggleData
            end

            ModuleData.Functions.Settings.Slider = function(data)
                local SliderData = {
                    Name = data and data.Name or "New Slider",
                    Description = data and data.Description or "Slider",
                    ToolTip = data and data.Tooltip or "Slide the circle to edit value",
                    Min = data and tonumber(data.Min) or 0,
                    Max = data and tonumber(data.Max) or 100,
                    Default = data and data.Default or {Value1 = 50, Value2 = 100},
                    Decimals = data and tonumber(data.Decimals) or 0,
                    Multi = data and data.DoubleValue or false,
                    Flag = data and data.Flag or data and data.Name or "New Slider",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Type = "Sliders",
                    Data = {Dragging = false},
                    Tweens = {},
                    Objects = {},
                    Functions = {}
                }


                if SpaceUI.Config.Game.Sliders[SliderData.Flag] then
                    if typeof(SpaceUI.Config.Game.Sliders[SliderData.Flag]) == "table" then
                        SliderData.Default = SpaceUI.Config.Game.Sliders[SliderData.Flag]
                    elseif typeof(SpaceUI.Config.Game.Sliders[SliderData.Flag]) == "number" then
                        SliderData.Default = {Value2 = SpaceUI.Config.Game.Sliders[SliderData.Flag]}
                    end
                else
                    if typeof(SliderData.Default) == "number" then
                        SliderData.Default = {Value2 = SliderData.Default}
                    end
                end

                if not SliderData.Default.Value1 then
                    SliderData.Default.Value1 = SliderData.Min
                end
                if not SliderData.Default.Value2 then
                    SliderData.Default.Value2 = SliderData.Max
                end

                SliderData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = SliderData.Name,
                    Description = SliderData.Description,
                    Size = 100,
                    Layout = false,
                    ToolTip = SliderData.ToolTip,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        SliderData.ToolTip = new.ToolTip
                    end
                })

                SliderData.Objects.MainInstance = SliderData.Construction.Objects.MainInstance
                if SliderData.Multi then
                    SliderData.Construction.Functions.EditToolTip({ToolTip = "Slide a circle to edit the value"})
                end
                
                SliderData.Functions.EditToolTip = SliderData.Construction.Functions.EditToolTip

                local Numbers = Instance.new("Frame", SliderData.Objects.MainInstance)
                Numbers.BackgroundTransparency = 1
                Numbers.Position = UDim2.fromScale(0.59, 0.237)
                Numbers.Size = UDim2.fromScale(0.409, 0.15)
                Numbers.ZIndex = 2

                local NumbersLayout = Instance.new("UIListLayout", Numbers)
                NumbersLayout.Padding = UDim.new(0, 20)
                NumbersLayout.FillDirection = Enum.FillDirection.Horizontal
                NumbersLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
                NumbersLayout.SortOrder = Enum.SortOrder.LayoutOrder

                local SliderValue1
                local SliderValue2 = Instance.new("TextBox", Numbers)
                SliderValue2.AnchorPoint = Vector2.new(0, 0.5)
                SliderValue2.BackgroundTransparency = 1
                SliderValue2.Size = UDim2.new(0.043, 0, 0, 15)
                SliderValue2.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                SliderValue2.Text = tonumber(SliderData.Default.Value2)
                SliderValue2.TextColor3 = Color3.fromRGB(255, 255, 255)
                SliderValue2.TextSize = 13
                SliderValue2.TextTransparency = 0.2
                SliderValue2.TextXAlignment = Enum.TextXAlignment.Right
                SliderValue2.AutomaticSize = Enum.AutomaticSize.X
                SliderValue2.LayoutOrder = 2
                SliderValue2.ZIndex = 2

                local SliderBox = Instance.new("Frame", SliderData.Objects.MainInstance)
                SliderBox.AnchorPoint = Vector2.new(0, 0.5)
                SliderBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                SliderBox.BackgroundTransparency = 0.6
                SliderBox.Position = UDim2.fromScale(0, 0.63)
                SliderBox.Size = UDim2.fromScale(1, 0.05)
                SliderBox.ZIndex = 2
                Instance.new("UICorner", SliderBox).CornerRadius = UDim.new(0, 15)

                local Fill = Instance.new("Frame", SliderBox)
                Fill.AnchorPoint = Vector2.new(0, 0.5)
                Fill.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                Fill.Position = UDim2.fromScale(0, 0.5)
                Fill.Size = UDim2.fromScale(math.clamp((tonumber(SliderValue2.Text)-SliderData.Min)/(SliderData.Max-SliderData.Min), 0, 1), 1)
                Fill.ZIndex = 2
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 15)

                local Circle2 = Instance.new("ImageButton", Fill)
                Circle2.AutoButtonColor = false
                Circle2.AnchorPoint = Vector2.new(0.5,0.5)
                Circle2.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                Circle2.Position = UDim2.fromScale(1, 0.5)
                Circle2.Size = UDim2.fromOffset(10, 10)
                Circle2.ImageTransparency = 1
                Circle2.ZIndex = 2
                Instance.new("UICorner", Circle2).CornerRadius = UDim.new(0, 15)

                SliderData.Functions.SetValue = function(value: number, save: boolean, target: number)

                    if value then
                        local info = {Value1 = SliderData.Default.Value1, Value2 = value}
                        if target == 2 then
                            if SpaceUI.Config.Game.Sliders[SliderData.Flag] and typeof(SpaceUI.Config.Game.Sliders[SliderData.Flag]) == "table" and SpaceUI.Config.Game.Sliders[SliderData.Flag].Value1 then
                                info = {Value1 = SpaceUI.Config.Game.Sliders[SliderData.Flag].Value1, Value2 = value}
                            end

                        elseif target == 1 then
                            info = {Value1 = value, Value2 = SliderData.Default.Value2}
                            if SpaceUI.Config.Game.Sliders[SliderData.Flag] and typeof(SpaceUI.Config.Game.Sliders[SliderData.Flag]) == "table" and SpaceUI.Config.Game.Sliders[SliderData.Flag].Value2 then
                                info = {Value1 = value, Value2 = SpaceUI.Config.Game.Sliders[SliderData.Flag].Value2}
                            end
                        else
                            if typeof(value) == "table" then
                                info = value
                            end
                        end

                        if target == 1 and SliderData.Multi then
                            if tonumber(SliderValue2.Text) < value then return end
                            local val = math.clamp((tonumber(value)-SliderData.Min)/(SliderData.Max-SliderData.Min), 0, 1)
                            local val2 = math.clamp((tonumber(SliderValue2.Text)-SliderData.Min)/(SliderData.Max-SliderData.Min) - val, 0, 1)
                            TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(val2 , 1), Position = UDim2.fromScale(val, 0.5)}):Play()
                            SliderValue1.Text = tostring(value)
                        elseif target == 1 and not SliderData.Multi or target == 2 then
                            if SliderData.Multi and value > tonumber(SliderValue1.Text) or not SliderData.Multi then
                                TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(math.clamp((tonumber(value)-SliderData.Min)/(SliderData.Max-SliderData.Min) - Fill.Position.X.Scale, 0, 1), 1)}):Play()
                                SliderValue2.Text = tostring(value)
                            else
                                return
                            end
                        elseif not target then
                            if SliderData.Multi then
                                if SliderData.Multi and info.Value2 > tonumber(SliderValue1.Text) or not SliderData.Multi then
                                    TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(math.clamp((tonumber(info.Value2)-SliderData.Min)/(SliderData.Max-SliderData.Min) - Fill.Position.X.Scale, 0, 1), 1)}):Play()
                                    SliderValue2.Text = tostring(info.Value2)
                                end

                                if tonumber(SliderValue2.Text) >= info.Value1 then
                                    local val = math.clamp((tonumber(info.Value1)-SliderData.Min)/(SliderData.Max-SliderData.Min), 0, 1)
                                    local val2 = math.clamp((tonumber(SliderValue2.Text)-SliderData.Min)/(SliderData.Max-SliderData.Min) - val, 0, 1)
                                    TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(val2 , 1), Position = UDim2.fromScale(val, 0.5)}):Play()
                                    SliderValue1.Text = tostring(info.Value1)
                                end
                            else
                                TweenService:Create(Fill, TweenInfo.new(0.45), {Size = UDim2.fromScale(math.clamp((tonumber(info.Value2)-SliderData.Min)/(SliderData.Max-SliderData.Min) - Fill.Position.X.Scale, 0, 1), 1)}):Play()
                                SliderValue2.Text = tostring(info.Value2)
                            end
                        end

                        if SliderData.Multi then
                            SliderData.Callback(SliderData, info)
                        else
                            SliderData.Callback(SliderData, tonumber(info.Value2))
                        end

                        if save then
                            SpaceUI.Config.Game.Sliders[SliderData.Flag] = info
                            Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                        end
                    end
                end

                local Circle1
                if SliderData.Multi then

                    SliderValue1 = Instance.new("TextBox", Numbers)
                    SliderValue1.AnchorPoint = Vector2.new(0, 0.5)
                    SliderValue1.BackgroundTransparency = 1
                    SliderValue1.Size = UDim2.new(0.044, 0, 0, 15)
                    SliderValue1.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                    SliderValue1.Text = tonumber(SliderData.Default.Value1)
                    SliderValue1.TextColor3 = Color3.fromRGB(255, 255, 255)
                    SliderValue1.TextSize = 13
                    SliderValue1.TextTransparency = 0.2
                    SliderValue1.TextXAlignment = Enum.TextXAlignment.Left
                    SliderValue1.AutomaticSize = Enum.AutomaticSize.X
                    SliderValue1.LayoutOrder = 0
                    SliderValue1.ZIndex = 2
                    local ValueSplitIcon = Instance.new("ImageLabel", Numbers)
                    ValueSplitIcon.BackgroundTransparency = 1
                    ValueSplitIcon.Size = UDim2.fromOffset(15, 15)
                    ValueSplitIcon.Image = "rbxassetid://136254264936851"
                    ValueSplitIcon.ImageColor3 = Color3.fromRGB(255,255,255)
                    ValueSplitIcon.ImageTransparency = 0.6
                    ValueSplitIcon.ScaleType = Enum.ScaleType.Stretch
                    ValueSplitIcon.LayoutOrder = 1
                    ValueSplitIcon.ZIndex = 2

                    Circle1 = Instance.new("ImageButton", Fill)
                    Circle1.AutoButtonColor = false
                    Circle1.AnchorPoint = Vector2.new(0.5,0.5)
                    Circle1.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                    Circle1.Position = UDim2.fromScale(0, 0.5)
                    Circle1.Size = UDim2.fromOffset(10, 10)
                    Circle1.ImageTransparency = 1
                    Circle1.ZIndex = 2
                    Instance.new("UICorner", Circle1).CornerRadius = UDim.new(0, 15)

                    local sliderdragbuttonclickcon2 =  Circle1.MouseButton1Down:Connect(function()
                        SpaceUI.CurrntInputChangeCallback = function(input)
                            if SliderData.Data.Dragging then
                                local mouse = UserInputService:GetMouseLocation()
                                local relativePos = mouse-SliderBox.AbsolutePosition
                                local percent = math.clamp(relativePos.X/(SliderBox.AbsoluteSize.X - 20), 0, 1)
                                local value = math.floor(((((SliderData.Max - SliderData.Min) * percent) + SliderData.Min) * (10 ^ SliderData.Decimals)) + 0.5) / (10 ^ SliderData.Decimals) 

                                SliderData.Functions.SetValue(value, true, 1)

                            end
                        end
                        SliderData.Data.Dragging = true

                        SpaceUI.InputEndFunc = function(input) 
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                SpaceUI.CurrntInputChangeCallback = function() end
                                SliderData.Data.Dragging = false
                            end
                        end
                    end)
                    table.insert(SpaceUI.Connections, sliderdragbuttonclickcon2)
                    table.insert(ModuleData.Connections, sliderdragbuttonclickcon2)                                
                end

                local sliderdragbuttonclickcon
                if SpaceUI.Mobile and not SliderData.Multi then
                    sliderdragbuttonclickcon = SliderData.Objects.MainInstance.MouseButton1Down:Connect(function()
                        SpaceUI.CurrntInputChangeCallback = function(input)
                            if SliderData.Data.Dragging then
                                local mouse = UserInputService:GetMouseLocation()
                                local relativePos = mouse-SliderBox.AbsolutePosition
                                local percent = math.clamp(relativePos.X/(SliderBox.AbsoluteSize.X - 20), 0, 1)
                                local value = math.floor(((((SliderData.Max - SliderData.Min) * percent) + SliderData.Min) * (10 ^ SliderData.Decimals)) + 0.5) / (10 ^ SliderData.Decimals) 

                                SliderData.Functions.SetValue(value, true, 2)

                            end
                        end
                        SliderData.Data.Dragging = true

                        SpaceUI.InputEndFunc = function(input) 
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                SpaceUI.CurrntInputChangeCallback = function() end
                                SliderData.Data.Dragging = false
                            end
                        end
                    end)
                else
                    sliderdragbuttonclickcon = Circle2.MouseButton1Down:Connect(function()
                        SpaceUI.CurrntInputChangeCallback = function(input)
                            if SliderData.Data.Dragging then
                                local mouse = UserInputService:GetMouseLocation()
                                local relativePos = mouse-SliderBox.AbsolutePosition
                                local percent = math.clamp(relativePos.X/(SliderBox.AbsoluteSize.X - 20), 0, 1)
                                local value = math.floor(((((SliderData.Max - SliderData.Min) * percent) + SliderData.Min) * (10 ^ SliderData.Decimals)) + 0.5) / (10 ^ SliderData.Decimals) 

                                SliderData.Functions.SetValue(value, true, 2)

                            end
                        end
                        SliderData.Data.Dragging = true

                        SpaceUI.InputEndFunc = function(input) 
                            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                                SpaceUI.CurrntInputChangeCallback = function() end
                                SliderData.Data.Dragging = false
                            end
                        end
                    end)
                end
                table.insert(SpaceUI.Connections, sliderdragbuttonclickcon)
                table.insert(ModuleData.Connections, sliderdragbuttonclickcon)
            

                local slidervaluetextchangecon = SliderValue2.FocusLost:Connect(function()
                    if SliderValue2.Text and tonumber(SliderValue2.Text) then
                        SliderData.Functions.SetValue(tonumber(SliderValue2.Text), true, 2)
                    end
                end)
                table.insert(SpaceUI.Connections, slidervaluetextchangecon)
                table.insert(ModuleData.Connections, slidervaluetextchangecon)

                if SliderData.Multi then
                    local slidervaluetextchangecon2 = SliderValue1.FocusLost:Connect(function()
                        if SliderValue1.Text and tonumber(SliderValue1.Text) then
                            SliderData.Functions.SetValue(tonumber(SliderValue1.Text), true, 1)
                        end
                    end)
                    table.insert(SpaceUI.Connections, slidervaluetextchangecon2)
                    table.insert(ModuleData.Connections, slidervaluetextchangecon2)
                end

                SliderData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, SliderData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, SliderData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            SliderData.Objects.MainInstance.Visible = true
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, SliderData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, SliderData)
                        end
                        SliderData.Objects.MainInstance.Visible = false
                    end
                end

                if SliderData.Hide then
                    SliderData.Functions.SetVisiblity(false)
                end

                ModuleData.Settings[SliderData.Flag] = SliderData
                return SliderData
            end

            ModuleData.Functions.Settings.Dropdown = function(data)
                local DropdownData = {
                    Name = data and data.Name or "Dropdown",
                    Description = data and data.Description or "Dropdown",
                    ToolTip = data and data.ToolTip or "Select a option",
                    Default = data and data.Default or "",
                    SelectLimit = data and data.SelectLimit or 1,
                    Options = data and data.Options or {},
                    Flag = data and data.Flag or "Dropdown",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Type = "Dropdowns",
                    Objects = {},
                    Connections = {},
                    Functions = {},
                    Buttons = {Selected = {}, Buttons = {}},
                    Data = {ExtendSize = 0, Opened = false},
                }

                if not SpaceUI.Config.Game.Dropdowns then
                    SpaceUI.Config.Game.Dropdowns = {}
                else
                    if SpaceUI.Config.Game.Dropdowns[DropdownData.Flag] then
                        DropdownData.Default = SpaceUI.Config.Game.Dropdowns[DropdownData.Flag]
                    end
                end

                DropdownData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = DropdownData.Name,
                    Description = DropdownData.Description,
                    Size = 125,
                    Layout = true,
                    ToolTip = DropdownData.ToolTip,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        DropdownData.ToolTip = new.ToolTip
                    end
                })

                DropdownData.Objects.MainInstance = DropdownData.Construction.Objects.MainInstance
                DropdownData.Functions.EditToolTip = DropdownData.Construction.Functions.EditToolTip

                local DropBox = Instance.new("ImageButton", DropdownData.Objects.MainInstance)
                DropBox.AutoButtonColor = false
                DropBox.AnchorPoint = Vector2.new(1, 0.5)
                DropBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                DropBox.BackgroundTransparency = 0.6
                DropBox.LayoutOrder = 2
                DropBox.Size = UDim2.new(1, 0, 0, 35)
                DropBox.ImageTransparency = 1
                DropBox.ClipsDescendants = true
                DropBox.ZIndex = 2
                Instance.new("UICorner", DropBox).CornerRadius = UDim.new(0, 6)
                -- DropBox.AutomaticSize = Enum.AutomaticSize.Y
                
                local BoxStroke = Instance.new("UIStroke", DropBox)
                BoxStroke.Color = Color3.fromRGB(255, 255, 255)
                BoxStroke.Transparency = 0.9

                local Details = Instance.new("Frame", DropBox)
                Details.AnchorPoint = Vector2.new(0.5, 0)
                Details.BackgroundTransparency = 1
                Details.Position = UDim2.fromScale(0.5, 0)
                Details.Size = UDim2.new(1, 0, 0, 35)
                Details.ZIndex = 2

                local SelectedText = Instance.new("TextLabel", Details)
                SelectedText.AnchorPoint = Vector2.new(0, 0.5)
                SelectedText.BackgroundTransparency = 1
                SelectedText.Position = UDim2.fromScale(0.02, 0.5)
                SelectedText.Size = UDim2.new(0.892, 0, 0, 140)
                SelectedText.ZIndex = 2
                SelectedText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                SelectedText.TextSize = 13
                SelectedText.TextColor3 = Color3.fromRGB(255, 255, 255)
                SelectedText.TextTransparency = 0.2
                SelectedText.TextXAlignment = 0.2
                if typeof(DropdownData.Default) == "table" then
                    SelectedText.Text = table.concat(DropdownData.Default, ", ")
                else
                    SelectedText.Text = tostring(DropdownData.Default)
                end

                local DropIcon = Instance.new("ImageLabel", Details)
                DropIcon.AnchorPoint = Vector2.new(1, 0.5)
                DropIcon.BackgroundTransparency = 1
                DropIcon.Position = UDim2.fromScale(0.97, 0.5)      
                DropIcon.Size = UDim2.fromOffset(10, 10)    
                DropIcon.ZIndex = 2
                DropIcon.Image = "rbxassetid://133663094711296"
                DropIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                DropIcon.ImageTransparency = 0.2
                DropIcon.ScaleType = Enum.ScaleType.Fit

                local OptionsList = Instance.new("ScrollingFrame", Details)
                OptionsList.AnchorPoint = Vector2.new(0.5, 0)
                OptionsList.BackgroundTransparency = 1
                OptionsList.Position = UDim2.fromScale(0.5, 1)
                OptionsList.Size = UDim2.fromScale(1, 0)
                OptionsList.ScrollBarThickness = 0
                OptionsList.ScrollBarImageTransparency = 1
                OptionsList.CanvasSize = UDim2.fromScale(0, 0)
                OptionsList.AutomaticCanvasSize = Enum.AutomaticSize.Y
                OptionsList.ZIndex = 2

                local OptionsLayout = Instance.new("UIListLayout", OptionsList)
                OptionsLayout.Padding = UDim.new(0, 2)
                OptionsLayout.VerticalAlignment = Enum.VerticalAlignment.Top

                local OptionsPadding = Instance.new("UIPadding", OptionsList)
                OptionsPadding.PaddingLeft = UDim.new(0, 13)
                OptionsPadding.PaddingTop = UDim.new(0, -5)

                DropdownData.Functions.SetValue = function(NewData: string | {}, Save: boolean)
                    if NewData then
                        local ReturnData = NewData
                        if typeof(NewData) == "string" then
                            if DropdownData.SelectLimit == 1  then
                                table.clear(DropdownData.Buttons.Selected)
                                table.insert(DropdownData.Buttons.Selected, NewData)
                            end

                            SelectedText.Text = NewData
                            if DropdownData.SelectLimit > 1 then
                                ReturnData = {NewData}
                            end
                        elseif typeof(NewData) == "table" then
                            if DropdownData.SelectLimit > 1  then
                                if DropdownData.SelectLimit >= #NewData then
                                    DropdownData.Buttons.Selected = NewData
                                else
                                    DropdownData.Buttons.Selected[#DropdownData.Buttons.Selected] = nil
                                end
                            else
                                table.clear(DropdownData.Buttons.Selected)
                                for i,v in NewData do
                                    table.insert(DropdownData.Buttons.Selected, v)                                        
                                end
                            end

                            if #NewData >= 1 then
                                SelectedText.Text = table.concat(NewData, ", ")
                            else
                                SelectedText.Text = "No Option Selected"
                            end
                        end

                        for i,v in DropdownData.Buttons.Buttons do
                            if table.find(DropdownData.Buttons.Selected, i) then
                                v.CheckMark.Visible = true
                                v.ButtonText.Position = UDim2.fromScale(0.037, 0.5)
                                v.ButtonText.Size = UDim2.fromScale(0.961, 1)
                            else
                                if v.CheckMark.Visible then
                                    v.CheckMark.Visible = false
                                    v.ButtonText.Position = UDim2.fromScale(0, 0.5)
                                    v.ButtonText.Size = UDim2.fromScale(1, 1)
                                end
                            end
                        end

                        DropdownData.Callback(DropdownData, ReturnData)

                        if Save then
                            SpaceUI.Config.Game.Dropdowns[DropdownData.Flag] = ReturnData
                            Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
                        end
                    end
                end

                for i,v in DropdownData.Options do
                    DropdownData.Data.ExtendSize += 22

                    local ButtonInfo = {
                        CheckMark = Instance.new("ImageLabel"),
                        ButtonText = Instance.new("TextLabel"),
                        Functions = {},
                        Connections = {}
                    }

                    local Button = Instance.new("TextButton", OptionsList)
                    Button.AutoButtonColor = false
                    Button.BackgroundTransparency = 1
                    Button.Size = UDim2.new(0.97, 0, 0, 20)
                    Button.Text = ""
                    Button.ZIndex = 2

                    ButtonInfo.ButtonText.Parent = Button
                    ButtonInfo.ButtonText.AnchorPoint = Vector2.new(0, 0.5)
                    ButtonInfo.ButtonText.BackgroundTransparency = 1
                    ButtonInfo.ButtonText.Position = UDim2.fromScale(0, 0.5)
                    ButtonInfo.ButtonText.Size = UDim2.fromScale(1, 1)
                    ButtonInfo.ButtonText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                    ButtonInfo.ButtonText.Text = tostring(v)
                    ButtonInfo.ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
                    ButtonInfo.ButtonText.TextSize = 13
                    ButtonInfo.ButtonText.TextTransparency = 0.2
                    ButtonInfo.ButtonText.TextXAlignment = Enum.TextXAlignment.Left
                    ButtonInfo.ButtonText.ZIndex = 2

                    ButtonInfo.CheckMark.Parent = Button
                    ButtonInfo.CheckMark.AnchorPoint = Vector2.new(0, 0.5)
                    ButtonInfo.CheckMark.BackgroundTransparency = 1
                    ButtonInfo.CheckMark.Position = UDim2.fromScale(0, 0.4)
                    ButtonInfo.CheckMark.Size = UDim2.fromOffset(13, 13)
                    ButtonInfo.CheckMark.Image = "rbxassetid://91799225292383"
                    ButtonInfo.CheckMark.ImageColor3 = Color3.fromRGB(255, 255, 255)
                    ButtonInfo.CheckMark.ImageTransparency = 0.2
                    ButtonInfo.CheckMark.ScaleType = Enum.ScaleType.Stretch
                    ButtonInfo.CheckMark.Visible = false
                    ButtonInfo.CheckMark.ZIndex = 2

                    if typeof(DropdownData.Default) == "table" then
                        if table.find(DropdownData.Default, tostring(v)) then
                            ButtonInfo.CheckMark.Visible = true
                            ButtonInfo.ButtonText.Position = UDim2.fromScale(0.037, 0.5)
                            ButtonInfo.ButtonText.Size = UDim2.fromScale(0.961, 1)
                        end
                    elseif typeof(DropdownData.Default) == "string" then
                        if DropdownData.Default == tostring(v) then
                            ButtonInfo.CheckMark.Visible = true
                            ButtonInfo.ButtonText.Position = UDim2.fromScale(0.037, 0.5)
                            ButtonInfo.ButtonText.Size = UDim2.fromScale(0.961, 1)
                        end
                    end

                    local ClickCon = Button.MouseButton1Down:Connect(function()
                        if DropdownData.SelectLimit > 1 then
                            if not table.find(DropdownData.Buttons.Selected, v) then
                                table.insert(DropdownData.Buttons.Selected, v)                                        
                            else
                                table.remove(DropdownData.Buttons.Selected, table.find(DropdownData.Buttons.Selected, v))
                            end

                            DropdownData.Functions.SetValue(DropdownData.Buttons.Selected, true)
                        else
                            DropdownData.Functions.SetValue(v, true)
                        end
                    end)

                    table.insert(ButtonInfo.Connections, ClickCon)
                    table.insert(DropdownData.Connections, ClickCon)
                    table.insert(SpaceUI.Connections, ClickCon)

                    ButtonInfo.Functions.Destroy = function()
                        for i,v in ButtonInfo.Connections do
                            local con1 = table.find(DropdownData.Connections, v)
                            local con2 = table.find(SpaceUI.Connections, v)
                            v:Disconnect()
                            if con1 then
                                table.remove(DropdownData.Connections, con1)
                            end
                            if con2 then
                                table.remove(SpaceUI.Connections, con2)
                            end
                        end
                    end

                    DropdownData.Buttons.Buttons[v] = ButtonInfo
                end

                local OpenCon = DropBox.MouseButton1Down:Connect(function()
                    DropdownData.Data.Opened = not DropdownData.Data.Opened
                    if DropdownData.Data.Opened then
                        local extend = DropdownData.Data.ExtendSize
                        if extend > 88 then
                            extend = 88
                        end

                        TweenService:Create(DropdownData.Objects.MainInstance, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 125 + extend)}):Play()
                        TweenService:Create(DropBox, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 35 + extend)}):Play()
                        TweenService:Create(OptionsList, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, extend)}):Play()
                    else
                        TweenService:Create(OptionsList, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.fromScale(1, 0)}):Play()
                        TweenService:Create(DropBox, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 35)}):Play()
                        TweenService:Create(DropdownData.Objects.MainInstance, TweenInfo.new(0.45, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 125)}):Play()
                    end
                end)
                table.insert(DropdownData.Connections, OpenCon)
                table.insert(SpaceUI.Connections, OpenCon)


                DropdownData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, DropdownData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, DropdownData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            DropdownData.Objects.MainInstance.Visible = true
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, DropdownData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, DropdownData)
                        end
                        DropdownData.Objects.MainInstance.Visible = false
                    end
                end

                if DropdownData.Hide then
                    DropdownData.Functions.SetVisiblity(false)
                end

                ModuleData.Settings[DropdownData.Flag] = DropdownData
                return DropdownData
            end

            ModuleData.Functions.Settings.Button = function(data: {Name: string, Flag: string, Description: string, ToolTip: string, Hide: boolean, Callback: any})
                local ButtonData = {
                    Name = data and data.Name or "Button",
                    Flag = data and data.Flag or "Button",
                    Description = data and data.Description or "Button",
                    ToolTip = data and data.ToolTip or "Click to Toggle",
                    Hide = data and data.Hide or false,
                    Callback = data and data.Callback or function() end,
                    Connections = {},
                    Functions = {},
                    Objects = {}
                }

                ButtonData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = ButtonData.Name,
                    Description = ButtonData.Description,
                    Size = 80,
                    Layout = false,
                    ToolTip = ButtonData.ToolTip,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        ButtonData.ToolTip = new.ToolTip
                    end
                })
                ButtonData.Objects.MainInstance = ButtonData.Construction.Objects.MainInstance
                ButtonData.Functions.EditToolTip = ButtonData.Construction.Functions.EditToolTip
                if SpaceUI.Mobile and ButtonData.ToolTip == "Click to toggle" then
                    ButtonData.Construction.Functions.EditToolTip({ToolTip = "Tap to toggle"})
                end

                local ClickCon = ButtonData.Objects.MainInstance.MouseButton1Down:Connect(function()
                    ButtonData.Callback(ButtonData)
                end)
                table.insert(ButtonData.Connections, ClickCon)
                table.insert(SpaceUI.Connections, ClickCon)

                ButtonData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, ButtonData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, ButtonData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            ButtonData.Objects.MainInstance.Visible = true
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, ButtonData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, ButtonData)
                        end
                        ButtonData.Objects.MainInstance.Visible = false
                    end
                end

                if ButtonData.Hide then
                    ButtonData.Functions.SetVisiblity(false)
                end

                ModuleData.Settings[ButtonData.Flag] = ButtonData
                return ButtonData
            end

            ModuleData.Functions.Settings.NewSection = function(Data: {Name: string, Flag: string})
                local SectionData = {
                    Name = Data and Data.Name or "Section",
                    Flag = Data and Data.Flag or "Flag", 
                    Objects = {}
                }

                SectionData.Objects.MainInstance = Instance.new("TextLabel", ModuleSettings)
                SectionData.Objects.MainInstance.BackgroundTransparency = 1
                SectionData.Objects.MainInstance.Size = UDim2.new(0.976, 0, 0, 35)
                SectionData.Objects.MainInstance.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
                SectionData.Objects.MainInstance.Text = tostring(SectionData.Name)
                SectionData.Objects.MainInstance.TextColor3 = Color3.fromRGB(255, 255, 255)
                SectionData.Objects.MainInstance.TextSize = 17
                SectionData.Objects.MainInstance.TextTransparency = 0.1
                SectionData.Objects.MainInstance.TextXAlignment = Enum.TextXAlignment.Left
                SectionData.Objects.MainInstance.Visible = false
                SectionData.Objects.MainInstance.ZIndex = 2

                ModuleData.Settings[SectionData.Flag] = SectionData
                return SectionData
            end

            ModuleData.Functions.Settings.Keybind = function(Data: {Name: string, Description: string, Default: string, ToolTip: string, Hide: boolean, Flag: string, Callbacks: {Began: () -> (), End: () -> (), Changed: () -> ()}, Mobile: {Text: string, Default: boolean, Visible: boolean}})
                local KeybindData = {
                    Name = Data and Data.Name or "Keybind",
                    Description = Data and Data.Description or "Keybind",
                    Default = Data and Data.Default or "",
                    Flag = Data and Data.Flag or "FlagKeybind", 
                    Hide = data and data.Hide or false,
                    ToolTip = Data and Data.ToolTip or "Click The Box To Bind",
                    Callbacks = Data and Data.Callbacks or {Began = function() end, End = function() end, Changed = function() end},
                    Data = {Keybind = nil, Binding = false},
                    Mobile = Data and Data.Mobile or {Text = "Keybind", Default = false, Visible = true},
                    Type = "ModuleKeybinds",
                    Functions = {},
                    Objects = {},
                    Connections = {}
                }

                if not KeybindData.Callbacks.Began then
                    KeybindData.Callbacks.Began = function() end
                end
                if not KeybindData.Callbacks.End then
                    KeybindData.Callbacks.End = function() end
                end
                if not KeybindData.Callbacks.Changed then
                    KeybindData.Callbacks.Changed = function() end
                end

                if not SpaceUI.Config.Game.ModuleKeybinds then
                    SpaceUI.Config.Game.ModuleKeybinds = {}
                else
                    if SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag] then
                        if SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag] == "unbinded" then
                            KeybindData.Default = ""
                        else
                            KeybindData.Default = SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag]
                        end
                    else
                        if KeybindData.Mobile.Default then
                            KeybindData.Default = "button"
                        end
                    end
                end

                KeybindData.Construction = ModuleData.Functions.ConstructSetting({
                    Name = KeybindData.Name,
                    Description = KeybindData.Description,
                    Size = 80,
                    Layout = false,
                    ToolTip = KeybindData.Flag,
                    OnToolTipEdit = function(new: {ToolTip: string})
                        KeybindData.ToolTip = new.ToolTip
                    end
                })
                KeybindData.Objects.MainInstance = KeybindData.Construction.Objects.MainInstance

                local KeybindBox = Instance.new("ImageButton", KeybindData.Objects.MainInstance)
                KeybindBox.AnchorPoint = Vector2.new(1, 0.5)
                KeybindBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                KeybindBox.BackgroundTransparency = 0.4
                KeybindBox.Position = UDim2.fromScale(1, 0.5)
                KeybindBox.Size = UDim2.fromOffset(25, 25)
                KeybindBox.AutoButtonColor = false
                KeybindBox.ZIndex = 2
                Instance.new("UICorner", KeybindBox).CornerRadius = UDim.new(0, 5)
                
                local BoxStroke = Instance.new("UIStroke", KeybindBox)
                BoxStroke.Color = Color3.fromRGB(255, 255, 255)
                BoxStroke.Transparency = 0.9

                local BoxIcon = Instance.new("ImageLabel", KeybindBox)
                BoxIcon.AnchorPoint = Vector2.new(0.5, 0.5)
                BoxIcon.BackgroundTransparency = 1
                BoxIcon.Position = UDim2.fromScale(0.5, 0.5)
                BoxIcon.Size = UDim2.fromOffset(13, 13)
                BoxIcon.Image = "rbxassetid://101725457581159"
                BoxIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                BoxIcon.ImageTransparency = 0.6
                BoxIcon.ScaleType = Enum.ScaleType.Stretch
                BoxIcon.ZIndex = 2

                local KeybindText = Instance.new("TextLabel", KeybindBox)
                KeybindText.AnchorPoint = Vector2.new(0.5, 0.5)
                KeybindText.BackgroundTransparency = 1
                KeybindText.Position = UDim2.fromScale(0.5, 0.5)
                KeybindText.Size = UDim2.fromOffset(10, 15)
                KeybindText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium)
                KeybindText.Text = KeybindData.Default
                KeybindText.TextColor3 = Color3.fromRGB(255, 255, 255)
                KeybindText.TextSize = 13
                KeybindText.TextTransparency = 0.6
                KeybindText.Visible = false
                KeybindText.ZIndex = 2

                if SpaceUI.Mobile then
                    table.insert(ModuleData.onToggles, function(self, enabled)
                        if enabled then
                            if KeybindData.Data.Keybind and KeybindData.Data.Keybind ~= "unbinded" then
                                SpaceUI.Background.Functions.CreateMobileButton({
                                    Name = KeybindData.Mobile.Text,
                                    Flag = KeybindData.Flag.."MobileKeybind",
                                    Callbacks = {
                                        Began = function(self)
                                            return KeybindData.Callbacks.Began(KeybindData)
                                        end,
                                        End = function(self, drag : boolean)
                                            return KeybindData.Callbacks.End(KeybindData)
                                        end
                                    }
                                })

                            end
                        else
                            if SpaceUI.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"] then
                                SpaceUI.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"].Functions.Destroy()
                            end
                        end
                    end)
                end

                if tostring(KeybindData.Default):gsub(" ", "") ~= "" then
                    KeybindData.Data.Keybind = KeybindData.Default
                    local Size = GetTextBounds(KeybindData.Default, Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium), 13)
                    KeybindBox.Size = UDim2.fromOffset(Size.X + 18, 25)

                    BoxIcon.Visible = false
                    KeybindText.Visible = true 
                    BoxIcon.Image = "rbxassetid://135395971960120"

                    if SpaceUI.Mobile and tostring(KeybindData.Default) == "button" then
                        KeybindData.Construction.Functions.EditToolTip({ToolTip = "Tap The Box To Unbind"})
                            KeybindData.Callbacks.Changed(KeybindData, KeybindData.Default)
                    elseif SpaceUI.Mobile and tostring(KeybindData.Default) == "unbinded" then
                        KeybindData.Callbacks.Changed(KeybindData, nil)

                        KeybindData.Data.Keybind = nil
                        BoxIcon.Image = "rbxassetid://101725457581159"
                        BoxIcon.Visible = true
                        KeybindText.Visible = false
                        KeybindText.Text = "binded"
                    elseif not SpaceUI.Mobile then
                        KeybindData.Callbacks.Changed(KeybindData, KeybindData.Default)
                        KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Unbind"})
                    end

                end

                local ClickCon = KeybindBox.MouseButton1Down:Connect(function()
                    if not KeybindData.Data.Keybind then
                        if SpaceUI.Mobile then
                            KeybindData.Data.Keybind = "button"

                            local Size = GetTextBounds("button", Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium), 13)
                            KeybindBox.Size = UDim2.fromOffset(Size.X + 18, 25)
                            KeybindText.Text = "binded"

                            BoxIcon.Visible = false
                            KeybindText.Visible = true 
                            BoxIcon.Image = "rbxassetid://135395971960120"
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Tap The Box To Unbind"})

                            if not SpaceUI.Config.Game.ModuleKeybinds then
                                SpaceUI.Config.Game.ModuleKeybinds = {}
                            end

                            if not SpaceUI.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"] and ModuleData.Data.Enabled then
                                SpaceUI.Background.Functions.CreateMobileButton({
                                    Name = KeybindData.Mobile.Text,
                                    Flag = KeybindData.Flag.."MobileKeybind",
                                    Callbacks = {
                                        Began = function(self)
                                            return KeybindData.Callbacks.Began(KeybindData)
                                        end,
                                        End = function(self, drag : boolean)
                                            return KeybindData.Callbacks.End(KeybindData)
                                        end
                                    }
                                })
                            end
                            
                            KeybindData.Callbacks.Changed(KeybindData, "button")

                            SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag] = "button"
                            SpaceUI.Assets.Config.Save(tostring(SpaceUI.GameSave), SpaceUI.Config.Game)
                        else
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Please Click A Button"})
                            KeybindData.Data.Binding = true
                        end
                    else
                        KeybindData.Callbacks.Changed(KeybindData, nil)

                        KeybindData.Data.Keybind = nil
                        BoxIcon.Image = "rbxassetid://101725457581159"
                        BoxIcon.Visible = true
                        KeybindText.Visible = false 

                        KeybindBox.Size = UDim2.fromOffset(25, 25)
                        if SpaceUI.Mobile then
                            if SpaceUI.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"] then
                                SpaceUI.Background.MobileButtons.Buttons[KeybindData.Flag.."MobileKeybind"].Functions.Destroy()
                            end
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Tap The Box To Bind"})
                        else
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Bind"})
                        end

                        SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag] = nil
                        if SpaceUI.Mobile then
                            SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag] = "unbinded"
                        end
                        SpaceUI.Assets.Config.Save(tostring(SpaceUI.GameSave), SpaceUI.Config.Game)
                    end
                end)

                local CallbackCon = UserInputService.InputBegan:Connect(function(input)
                    if UserInputService:GetFocusedTextBox() and not KeybindData.Data.Binding then return end
                    if KeybindData.Data.Binding then
                        if input.KeyCode and input.KeyCode.Name ~= "Unknown" then
                            KeybindData.Data.Keybind = input.KeyCode.Name

                            local Size = GetTextBounds(input.KeyCode.Name, Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium), 13)
                            KeybindBox.Size = UDim2.fromOffset(Size.X + 18, 25)
                            KeybindText.Text = input.KeyCode.Name

                            BoxIcon.Visible = false
                            KeybindText.Visible = true 
                            BoxIcon.Image = "rbxassetid://135395971960120"
                            KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Unbind"})

                            if not SpaceUI.Config.Game.ModuleKeybinds then
                                SpaceUI.Config.Game.ModuleKeybinds = {}
                            end

                            KeybindData.Callbacks.Changed(KeybindData, input.KeyCode.Name)
                            SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag] = input.KeyCode.Name
                            SpaceUI.Assets.Config.Save(tostring(SpaceUI.GameSave), SpaceUI.Config.Game)
                        end
                    else
                        if KeybindData.Data.Keybind and KeybindData.Data.Keybind == input.KeyCode.Name then
                            KeybindData.Callbacks.Began(KeybindData)
                        end
                    end
                end)

                local EndCon = UserInputService.InputEnded:Connect(function(input)
                    if UserInputService:GetFocusedTextBox() then return end
                    if KeybindData.Data.Keybind and KeybindData.Data.Keybind == input.KeyCode.Name then
                        if KeybindData.Data.Binding then
                            KeybindData.Data.Binding = false
                            return
                        end
                        KeybindData.Callbacks.End(KeybindData)
                    end
                end)

                local HoverCon = KeybindBox.MouseEnter:Connect(function()
                    if KeybindData.Data.Keybind then
                        KeybindText.Visible = false
                        BoxIcon.Visible = true
                    end
                end)

                local UnHoverCon = KeybindBox.MouseLeave:Connect(function()
                    if KeybindData.Data.Keybind then
                        KeybindText.Visible = true
                        BoxIcon.Visible = false
                    end
                end)
                
                table.insert(KeybindData.Connections, ClickCon)
                table.insert(SpaceUI.Connections, ClickCon)

                table.insert(KeybindData.Connections, CallbackCon)
                table.insert(SpaceUI.Connections, CallbackCon)

                table.insert(KeybindData.Connections, EndCon)
                table.insert(SpaceUI.Connections, EndCon)

                table.insert(KeybindData.Connections, HoverCon)
                table.insert(SpaceUI.Connections, HoverCon)
                
                table.insert(KeybindData.Connections, UnHoverCon)
                table.insert(SpaceUI.Connections, UnHoverCon)


                KeybindData.Functions.SetValue = function(NewValue: string, save: boolean)
                    if not NewValue or NewValue == "" or NewValue == "unbinded" then
                        KeybindData.Data.Keybind = nil
                        BoxIcon.Image = "rbxassetid://101725457581159"
                        BoxIcon.Visible = true
                        KeybindText.Visible = false 

                        KeybindBox.Size = UDim2.fromOffset(25, 25)
                        KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Bind"})

                        if save then
                            SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag] = nil
                            SpaceUI.Assets.Config.Save(tostring(SpaceUI.GameSave), SpaceUI.Config.Game)
                        end
                    else
                        KeybindData.Data.Keybind = NewValue

                        local Size = GetTextBounds(NewValue, Font.new("rbxassetid://12187365364", Enum.FontWeight.Medium), 13)
                        KeybindBox.Size = UDim2.fromOffset(Size.X + 18, 25)

                        KeybindText.Text = NewValue

                        BoxIcon.Visible = false
                        KeybindText.Visible = true 
                        BoxIcon.Image = "rbxassetid://135395971960120"
                        KeybindData.Construction.Functions.EditToolTip({ToolTip = "Click The Box To Unbind"})

                        if not SpaceUI.Config.Game.ModuleKeybinds then
                            SpaceUI.Config.Game.ModuleKeybinds = {}
                        end
                        if save then
                            SpaceUI.Config.Game.ModuleKeybinds[KeybindData.Flag] = NewValue
                            SpaceUI.Assets.Config.Save(tostring(SpaceUI.GameSave), SpaceUI.Config.Game)
                        end
                    end
                end

                KeybindData.Functions.SetVisiblity = function(enabled)
                    if enabled then
                        if table.find(ModuleData.Data.ExcludeSettingsVisiblity, KeybindData) then
                            table.remove(ModuleData.Data.ExcludeSettingsVisiblity, table.find(ModuleData.Data.ExcludeSettingsVisiblity, KeybindData))
                        end
                        if ModuleData.Data.SettingsOpen then
                            KeybindData.Objects.MainInstance.Visible = true
                        end
                    else
                        if not table.find(ModuleData.Data.ExcludeSettingsVisiblity, KeybindData) then
                            table.insert(ModuleData.Data.ExcludeSettingsVisiblity, KeybindData)
                        end
                        KeybindData.Objects.MainInstance.Visible = false
                    end
                end
                
                if KeybindData.Hide then
                    KeybindData.Functions.SetVisiblity(false)
                end

                ModuleData.Settings[KeybindData.Flag] = KeybindData
                return KeybindData
            end

            ModuleData.Functions.Destroy = function()
                for i,v in ModuleData.Connections do
                    v:Disconnect()
                end
                ModuleData.Callback(ModuleData, false)
                table.clear(ModuleData.Connections)
                tab.Modules[ModuleData.Flag] = nil

                ModuleData.Objects.Module:Destroy()
                table.clear(ModuleData)
            end

            tab.Modules[ModuleData.Flag] = ModuleData
            return ModuleData
        end

        tab.Functions.Destroy = function()
            for i,v in tab.Modules do
                if v and v.Functions and v.Functions.Destroy then
                    v.Functions.Destroy()
                end
            end
            for i,v in tab.Connections do
                v:Disconnect()
            end
            tab.Objects.ActualTab:Destroy()
            tab.Objects.DashBoardButton:Destroy()
            table.clear(tab)
        end

        SpaceUI.Tabs.Tabs[tab.Name] = tab
        return tab
    end

end

do
    Assets.SettingsPage.Init = function(Settings)
        if not Settings then return end
        local SettingsPageInfo = {
            Functions = {},
        }

        local pageselectorbuttonicon = Settings.Objects.PageselectorButton:FindFirstChildWhichIsA("ImageLabel")
        if pageselectorbuttonicon then
            pageselectorbuttonicon.ImageTransparency = 0.1
        end
        
        local SettingsScroll = Instance.new("ScrollingFrame", Settings.Objects.ActualPage)
        SettingsScroll.AnchorPoint = Vector2.new(0.5, 1)
        SettingsScroll.BackgroundTransparency = 1
        SettingsScroll.Position = UDim2.new(0.5, 0, 1, 20)
        SettingsScroll.Size = UDim2.new(1, 0, 1, -100)
        SettingsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        SettingsScroll.CanvasSize = UDim2.fromScale(1, 0)
        SettingsScroll.ScrollBarImageTransparency = 0.8
        SettingsScroll.ScrollBarThickness = 2
        SettingsScroll.ScrollingDirection = Enum.ScrollingDirection.Y

        local SettingsScrollList = Instance.new("UIListLayout", SettingsScroll)
        SettingsScrollList.SortOrder = Enum.SortOrder.LayoutOrder
        SettingsScrollList.Padding = UDim.new(0, 10)
        SettingsScrollList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local scrollPadding = Instance.new("UIPadding", SettingsScroll)
        scrollPadding.PaddingBottom = UDim.new(0, 20)
        scrollPadding.PaddingLeft = UDim.new(0, 20)
        scrollPadding.PaddingRight = UDim.new(0, 20)
        scrollPadding.PaddingTop = UDim.new(0, 5)

        SettingsPageInfo.Functions.NewSection = function(data)
            local SectionData = {
                Functions = {},
            }

            local Section = Instance.new("Frame", SettingsScroll)
            Section.AnchorPoint = Vector2.new(0.5, 0)
            Section.AutomaticSize = Enum.AutomaticSize.Y
            Section.BackgroundTransparency = 1
            Section.Size = UDim2.fromScale(1, 0)

            local SectionList = Instance.new("UIListLayout", Section)
            SectionList.SortOrder = Enum.SortOrder.LayoutOrder
            SectionList.HorizontalAlignment = Enum.HorizontalAlignment.Center

            local SectionText = Instance.new("TextLabel", Section)
            SectionText.BackgroundTransparency = 1
            SectionText.Size = UDim2.new(1, -40, 0, 20)
            SectionText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
            SectionText.Text = data.Name:upper()
            SectionText.TextColor3 = Color3.fromRGB(255, 255, 255)
            SectionText.TextTransparency = 0.5
            SectionText.TextSize = 14
            SectionText.TextXAlignment = Enum.TextXAlignment.Left
            SectionText.TextYAlignment = Enum.TextYAlignment.Top

            local madebutton = false
            SectionData.Functions.NewButton = function(data)
                local ButtonData = {
                    Name = data.Name or "Button",
                    Input = data.Input,
                    Last = data.Last or false,
                    Toggle = data.Toggle or false,
                    Default = data.Default or false,
                    Textbox = data.Textbox or false,
                    Flag = data.Flag or nil,
                    Data = {Enabled = false},
                    Objects = {},
                    Callback = data.Callback or function() end,
                }

                ButtonData.Objects.MainButton = Instance.new("ImageButton", Section)
                ButtonData.Objects.MainButton.BackgroundTransparency = 1
                ButtonData.Objects.MainButton.Size = UDim2.new(1, 0, 0, 45)
                ButtonData.Objects.MainButton.AutoButtonColor = false
                ButtonData.Objects.MainButton.Image = "rbxassetid://16286719854"
                ButtonData.Objects.MainButton.ImageColor3 = Color3.fromRGB(0, 0, 0)
                ButtonData.Objects.MainButton.ImageTransparency = 0.6
                ButtonData.Objects.MainButton.ScaleType = Enum.ScaleType.Crop

                if not madebutton then
                    ButtonData.Objects.MainButton.ScaleType = Enum.ScaleType.Slice
                    ButtonData.Objects.MainButton.SliceCenter = Rect.new(512, 214, 512, 214)
                    ButtonData.Objects.MainButton.SliceScale = 0.12
                    ButtonData.Objects.MainButton.Image = "rbxassetid://16287196357"
                    madebutton = true
                end
                if ButtonData.Last then
                    ButtonData.Objects.MainButton.ScaleType = Enum.ScaleType.Slice
                    ButtonData.Objects.MainButton.SliceCenter = Rect.new(512, 0, 512, 0)
                    ButtonData.Objects.MainButton.SliceScale = 0.12
                    ButtonData.Objects.MainButton.Image = "rbxassetid://16287194510"
                end

                local ButtonPadding = Instance.new("UIPadding", ButtonData.Objects.MainButton)
                ButtonPadding.PaddingLeft = UDim.new(0, 20)
                ButtonPadding.PaddingRight = UDim.new(0, 20)

                ButtonData.Objects.MainButtonText = Instance.new("TextLabel", ButtonData.Objects.MainButton)
                ButtonData.Objects.MainButtonText.AnchorPoint = Vector2.new(0, 0.5)
                ButtonData.Objects.MainButtonText.BackgroundTransparency = 1
                ButtonData.Objects.MainButtonText.Position = UDim2.fromScale(0, 0.5)
                ButtonData.Objects.MainButtonText.Size = UDim2.new(1, -50, 1, 0)
                ButtonData.Objects.MainButtonText.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                ButtonData.Objects.MainButtonText.Text = ButtonData.Name
                ButtonData.Objects.MainButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
                ButtonData.Objects.MainButtonText.TextTransparency = 0.3
                ButtonData.Objects.MainButtonText.TextSize = 16
                ButtonData.Objects.MainButtonText.TextXAlignment = Enum.TextXAlignment.Left
                ButtonData.Objects.MainButtonText.TextYAlignment = Enum.TextYAlignment.Center

                local EnabledCheckMark
                if ButtonData.Toggle then
                    EnabledCheckMark = Instance.new("ImageLabel", ButtonData.Objects.MainButton)
                    EnabledCheckMark.AnchorPoint = Vector2.new(1, 0.5)
                    EnabledCheckMark.BackgroundTransparency = 1
                    EnabledCheckMark.Position = UDim2.fromScale(1, 0.5)
                    EnabledCheckMark.Size = UDim2.fromOffset(18, 18)
                    EnabledCheckMark.Image = "rbxassetid://10709790644"
                    EnabledCheckMark.ImageColor3 = Color3.fromRGB(255,255,255)
                    EnabledCheckMark.ImageTransparency = 0.5
                    EnabledCheckMark.ScaleType = Enum.ScaleType.Stretch
                    EnabledCheckMark.Visible = false
                    if ButtonData.Flag then
                        if SpaceUI.Config.UI[ButtonData.Flag] == nil and ButtonData.Default or SpaceUI.Config.UI[ButtonData.Flag] then
                            ButtonData.Data.Enabled = true
                            EnabledCheckMark.Visible = true
                            ButtonData.Callback(ButtonData, true)
                        end
                    end
                end

                if ButtonData.Textbox then
                    local Textbox = Instance.new("TextBox", ButtonData.Objects.MainButton)
                    Textbox.AnchorPoint = Vector2.new(1, 0.5)
                    Textbox.BackgroundTransparency = 1
                    Textbox.Position = UDim2.fromScale(1, 0.5)
                    Textbox.Size = UDim2.new(1, -60, 0, 18)
                    Textbox.FontFace = Font.new("rbxassetid://12187365364", Enum.FontWeight.Regular)
                    Textbox.Text = ""
                    Textbox.TextSize = 16
                    Textbox.TextColor3 = Color3.fromRGB(255, 255, 255)
                    Textbox.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)   
                    Textbox.TextTransparency = 0.3
                    Textbox.TextXAlignment = Enum.TextXAlignment.Right
                    Textbox.ZIndex = 1000
                    Textbox.TextWrapped = true
                    if ButtonData.Default and typeof(ButtonData.Default) == "string" and SpaceUI.Config.UI[ButtonData.Flag] == nil then
                        Textbox.Text = ButtonData.Default
                    end
                    if SpaceUI.Config.UI[ButtonData.Flag] then
                        if typeof(SpaceUI.Config.UI[ButtonData.Flag]) == "table" then
                            for i,v in SpaceUI.Config.UI[ButtonData.Flag] do
                                Textbox.Text = Textbox.Text .. tostring(v) .. ", "
                            end
                            Textbox.Text = string.sub(Textbox.Text, 0, #Textbox.Text-2)
                        else
                            Textbox.Text = tostring(SpaceUI.Config.UI[ButtonData.Flag])
                        end
                    end

                    table.insert(SpaceUI.Connections, Textbox.FocusLost:Connect(function()
                        ButtonData.Callback(ButtonData, Textbox.Text)
                    end))

                    return ButtonData.Callback(ButtonData, Textbox.Text)
                end

                table.insert(SpaceUI.Connections, ButtonData.Objects.MainButton.MouseButton1Click:Connect(function() 
                    if ButtonData.Toggle then
                        ButtonData.Data.Enabled = not ButtonData.Data.Enabled
                        EnabledCheckMark.Visible = ButtonData.Data.Enabled
                        return ButtonData.Callback(ButtonData, ButtonData.Data.Enabled)
                    end
                    return ButtonData.Callback(ButtonData) 
                end))

                return ButtonData
            end
            return SectionData
        end
        return SettingsPageInfo
    end

end 

do    
    Assets.Main.OnUninject = Instance.new("BindableEvent")

    -- Lưu lại tab vừa được mở (không phải reopen do toggle UI) để Accessibility Button
    -- có thể hiện 3 icon truy cập nhanh dựa trên lịch sử mở tab gần nhất.
    Assets.Main.TrackRecentTab = function(tabName)
        if not SpaceUI.Config.Game.Other then SpaceUI.Config.Game.Other = {} end
        local recent = SpaceUI.Config.Game.Other.RecentTabs
        if not recent then
            recent = {}
            SpaceUI.Config.Game.Other.RecentTabs = recent
        end
        -- Bỏ bản ghi cũ của cùng tab (nếu có) để đẩy nó lên đầu danh sách
        for i = #recent, 1, -1 do
            if recent[i] == tabName then
                table.remove(recent, i)
            end
        end
        table.insert(recent, 1, tabName)
        while #recent > 3 do
            table.remove(recent, #recent)
        end
        pcall(function()
            Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
        end)
    end

    -- Trả về tối đa 3 đối tượng tab để hiện trên Accessibility Button:
    -- ưu tiên lịch sử mở gần nhất, phần còn thiếu được lấp bằng tab ngẫu nhiên (không trùng).
    Assets.Main.GetQuickAccessTabs = function(count)
        count = count or 3
        local picked, seen = {}, {}

        local recent = SpaceUI.Config.Game.Other and SpaceUI.Config.Game.Other.RecentTabs
        if recent then
            for _, tabName in recent do
                local tab = SpaceUI.Tabs.Tabs[tabName]
                if tab and not seen[tabName] then
                    seen[tabName] = true
                    table.insert(picked, tab)
                    if #picked >= count then break end
                end
            end
        end

        if #picked < count then
            local pool = {}
            for tabName, tab in SpaceUI.Tabs.Tabs do
                if not seen[tabName] then
                    table.insert(pool, tab)
                end
            end
            -- Xáo trộn ngẫu nhiên (Fisher-Yates) rồi lấy cho đủ số lượng cần
            for i = #pool, 2, -1 do
                local j = math.random(1, i)
                pool[i], pool[j] = pool[j], pool[i]
            end
            for _, tab in pool do
                table.insert(picked, tab)
                if #picked >= count then break end
            end
        end

        return picked
    end

    -- Đóng mọi tab đang mở, rồi mở đúng 1 tab mục tiêu (dùng bởi cả TopbarPlus và
    -- Accessibility Button khi bấm vào 1 icon truy cập nhanh).
    Assets.Main.OpenSingleTab = function(targetTab)
        if not targetTab or not targetTab.Functions or not targetTab.Functions.ToggleTab then return end
        if SpaceUI.CurrentOpenTab then
            for i = #SpaceUI.CurrentOpenTab, 1, -1 do
                local openTab = SpaceUI.CurrentOpenTab[i]
                if openTab and openTab ~= targetTab and openTab.Functions and openTab.Functions.ToggleTab then
                    openTab.Functions.ToggleTab(false, true)
                end
            end
        end
        targetTab.Functions.ToggleTab(true, true)
    end

    Assets.Main.CloseAllExceptFocused = function()
        local focused = SpaceUI.Tabs.FocusedTab
        if not focused then return false end
        if SpaceUI.CurrentOpenTab then
            for i = #SpaceUI.CurrentOpenTab, 1, -1 do
                local openTab = SpaceUI.CurrentOpenTab[i]
                if openTab and openTab ~= focused and openTab.Functions and openTab.Functions.ToggleTab then
                    openTab.Functions.ToggleTab(false, true)
                end
            end
        end
        return true
    end

    if SpaceUI.Config.UI.UseAccessibilityButton == false then
        -- ============ TopbarPlus (API cũ) ============
        do
            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer

            local success, Icon = pcall(function()
                return loadstring(game:HttpGet("https://raw.githubusercontent.com/Therealtobu/Topbar-Plus-For-Executor/main/init.lua"))()
            end)

            if success and Icon then
                local success2, err = pcall(function()
                    local SpaceUIIcon = Icon.new()
                        :setLabel("SpaceUI")
                        :setRight()
                        :bindEvent("selected", function()
                            if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame then
                                if not SpaceUI.Background.Objects.MainFrame.Visible then
                                    Assets.Main.ToggleVisibility(true)
                                end
                            end
                        end)
                        :bindEvent("deselected", function()
                            if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame then
                                if SpaceUI.Background.Objects.MainFrame.Visible then
                                    Assets.Main.ToggleVisibility(false)
                                end
                            end
                        end)
                    SpaceUI.TopbarIcon = SpaceUIIcon
                end)
                if not success2 then
                    warn("SpaceUI Topbar Icon Error:", err)
                end
            else
                warn("SpaceUI Failed to load TopbarPlus Library:", Icon)
            end
        end

    else
        -- ============ Accessibility Button (port 1:1 từ Exe5.rbxmx) ============
        -- Node tree, Size/Position/Color giữ nguyên y hệt file gốc.
        -- Chỉ thay đổi: 3 nút "players/dashboard/recent" -> 3 icon tab SpaceUI
        -- (mở gần nhất, random nếu thiếu). Icon "Exe 5" ở trạng thái đóng giữ nguyên
        -- theo yêu cầu (asset rbxassetid://134689689501109), có thể tự đổi sau.
        do
            local UserInputService = game:GetService("UserInputService")
            local TS = TweenService

            local inst = TweenInfo.new(0.01, Enum.EasingStyle.Exponential)
            local quick = TweenInfo.new(0.3, Enum.EasingStyle.Exponential)
            local info = TweenInfo.new(0.5, Enum.EasingStyle.Exponential)

            local AccessibilityGui = Instance.new("ScreenGui", Assets.Functions.gethui())
            AccessibilityGui.Name = "SpaceUIAccessibility"
            AccessibilityGui.ResetOnSpawn = false
            AccessibilityGui.IgnoreGuiInset = true
            AccessibilityGui.DisplayOrder = 10001
            SpaceUI.AccessibilityGui = AccessibilityGui

            -- accessibility_button (Frame)
            local frame = Instance.new("Frame")
            frame.Name = "accessibility_button"
            frame.Active = false
            frame.AnchorPoint = Vector2.new(0.5, 0)
            frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            frame.BackgroundTransparency = 1
            frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            frame.BorderSizePixel = 0
            frame.ClipsDescendants = true
            frame.Position = UDim2.new(0.5, 0, 0, 0)
            frame.Selectable = false
            frame.Size = UDim2.new(0, 300, 0, 70)
            frame.Visible = true
            frame.ZIndex = 1
            frame.Parent = AccessibilityGui

            -- button (ImageButton) - pill nền
            local button = Instance.new("ImageButton")
            button.Name = "button"
            button.HoverImage = ""
            button.Image = "rbxassetid://91331674599520"
            button.ImageColor3 = Color3.fromRGB(255, 255, 255)
            button.ImageTransparency = 0
            button.PressedImage = ""
            button.ScaleType = Enum.ScaleType.Slice
            button.SliceCenter = Rect.new(511, 223, 512, 335)
            button.AutoButtonColor = false
            button.Selected = false
            button.Active = true
            button.AnchorPoint = Vector2.new(0.5, 0)
            button.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            button.BackgroundTransparency = 1
            button.BorderColor3 = Color3.fromRGB(0, 0, 0)
            button.BorderSizePixel = 0
            button.ClipsDescendants = false
            button.Position = UDim2.new(0.5, 0, 0, 0)
            button.Selectable = true
            button.Size = UDim2.new(0, 190, 0, 40)
            button.Visible = true
            button.ZIndex = 1
            button.Parent = frame

            -- button.page (Frame)
            local pageFrame = Instance.new("Frame")
            pageFrame.Name = "page"
            pageFrame.Active = false
            pageFrame.AnchorPoint = Vector2.new(0.5, 0)
            pageFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            pageFrame.BackgroundTransparency = 1
            pageFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
            pageFrame.BorderSizePixel = 0
            pageFrame.ClipsDescendants = true
            pageFrame.Position = UDim2.new(0.5, 0, 0, 0)
            pageFrame.Selectable = false
            pageFrame.Size = UDim2.new(1, -120, 1, -2)
            pageFrame.Visible = true
            pageFrame.ZIndex = 1
            pageFrame.Parent = button

            -- button.page.front (Frame)
            local front = Instance.new("Frame")
            front.Name = "front"
            front.Active = false
            front.AnchorPoint = Vector2.new(0.5, 0)
            front.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            front.BackgroundTransparency = 1
            front.BorderColor3 = Color3.fromRGB(0, 0, 0)
            front.BorderSizePixel = 0
            front.ClipsDescendants = true
            front.LayoutOrder = 2
            front.Position = UDim2.new(0.5, 0, 0, 0)
            front.Selectable = false
            front.Size = UDim2.new(1, 0, 1, 0)
            front.Visible = true
            front.ZIndex = 1
            front.Parent = pageFrame

            -- button.page.front.open (ImageButton)
            -- Căn giữa theo "front" (thay vì neo trái như rbxmx gốc) vì giờ bên trong
            -- là chữ "Space" (TextLabel) chứ không phải ảnh logo có padding riêng.
            local open = Instance.new("ImageButton")
            open.Name = "open"
            open.HoverImage = ""
            open.Image = ""
            open.ImageColor3 = Color3.fromRGB(255, 255, 255)
            open.ImageTransparency = 0
            open.PressedImage = ""
            open.AutoButtonColor = true
            open.Selected = false
            open.Active = true
            open.AnchorPoint = Vector2.new(0.5, 0.5)
            open.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            open.BackgroundTransparency = 1
            open.BorderColor3 = Color3.fromRGB(0, 0, 0)
            open.BorderSizePixel = 0
            open.ClipsDescendants = false
            open.Position = UDim2.new(0.5, 0, 0.5, 0)
            open.Selectable = true
            open.Size = UDim2.new(0, 40, 0, 40)
            open.Visible = true
            open.ZIndex = 1
            open.Parent = front

            -- button.page.front.open.icon -> đổi từ ảnh logo "Exe 5" sang chữ "Space"
            -- (TextLabel, font Gotham - sans hiện đại gần với SF Pro nhất trong Roblox),
            -- căn giữa cả 2 chiều để không bị lệch/tràn ra ngoài khung như bản ảnh cũ.
            local openIcon = Instance.new("TextLabel")
            openIcon.Name = "icon"
            openIcon.BackgroundTransparency = 1
            openIcon.Active = false
            openIcon.AnchorPoint = Vector2.new(0.5, 0.5)
            openIcon.BorderColor3 = Color3.fromRGB(0, 0, 0)
            openIcon.BorderSizePixel = 0
            openIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
            openIcon.Selectable = false
            openIcon.Size = UDim2.new(1, 0, 1, 0)
            openIcon.Visible = true
            openIcon.ZIndex = 1
            openIcon.Font = Enum.Font.GothamMedium
            openIcon.Text = "Space"
            openIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
            openIcon.TextScaled = false
            openIcon.TextSize = 18
            openIcon.TextXAlignment = Enum.TextXAlignment.Center
            openIcon.TextYAlignment = Enum.TextYAlignment.Center
            openIcon.Parent = open

            local openIconScale = Instance.new("UIScale")
            openIconScale.Name = "scale"
            openIconScale.Scale = 1
            openIconScale.Parent = openIcon


            -- button.page.list (UIListLayout)
            -- HorizontalAlignment = Center để "open" (chứa chữ "Space") được căn giữa
            -- theo chiều ngang của "front", thay vì bị đẩy về mép trái.
            local pageList = Instance.new("UIListLayout")
            pageList.Name = "list"
            pageList.Padding = UDim.new(0, 0)
            pageList.FillDirection = Enum.FillDirection.Vertical
            pageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
            pageList.SortOrder = Enum.SortOrder.LayoutOrder
            pageList.VerticalAlignment = Enum.VerticalAlignment.Center
            pageList.Parent = front

            -- button.page.page (UIPageLayout)
            local pageLayout = Instance.new("UIPageLayout")
            pageLayout.Name = "page"
            pageLayout.Animated = true
            pageLayout.Circular = false
            pageLayout.EasingDirection = Enum.EasingDirection.Out
            pageLayout.EasingStyle = Enum.EasingStyle.Exponential
            pageLayout.GamepadInputEnabled = false
            pageLayout.Padding = UDim.new(0, 2)
            pageLayout.ScrollWheelInputEnabled = false
            pageLayout.TouchInputEnabled = false
            pageLayout.TweenTime = 0.5
            pageLayout.FillDirection = Enum.FillDirection.Vertical
            pageLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
            pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
            pageLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            pageLayout.Parent = pageFrame

            -- button.page.options (Frame)
            local options = Instance.new("Frame")
            options.Name = "options"
            options.Active = false
            options.AnchorPoint = Vector2.new(0.5, 0)
            options.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            options.BackgroundTransparency = 1
            options.BorderColor3 = Color3.fromRGB(0, 0, 0)
            options.BorderSizePixel = 0
            options.ClipsDescendants = true
            options.LayoutOrder = 1
            options.Position = UDim2.new(0.5, 0, 0, 0)
            options.Selectable = false
            options.Size = UDim2.new(1, 0, 1, 0)
            options.Visible = true
            options.ZIndex = 1
            options.Parent = pageFrame

            -- 3 nút truy cập nhanh (thay players/dashboard/recent) - dùng chung 1 template
            -- vì cả 3 node gốc có property giống hệt nhau (chỉ khác icon/asset).
            local quickTabs = {}
            local function buildQuickTabButton(name, layoutOrder)
                local btn = Instance.new("ImageButton")
                btn.Name = name
                btn.HoverImage = ""
                btn.Image = ""
                btn.ImageColor3 = Color3.fromRGB(255, 255, 255)
                btn.ImageTransparency = 0
                btn.PressedImage = ""
                btn.AutoButtonColor = true
                btn.Selected = false
                btn.Active = true
                btn.AnchorPoint = Vector2.new(0, 0)
                btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                btn.BackgroundTransparency = 1
                btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
                btn.BorderSizePixel = 0
                btn.ClipsDescendants = false
                btn.LayoutOrder = layoutOrder
                btn.Position = UDim2.new(0, 0, 0, 0)
                btn.Selectable = true
                btn.Size = UDim2.new(0, 40, 0, 40)
                btn.Visible = true
                btn.ZIndex = 1
                btn.Parent = options

                local icon = Instance.new("ImageLabel")
                icon.Name = "icon"
                icon.Image = ""
                icon.ImageColor3 = Color3.fromRGB(255, 255, 255)
                icon.ImageTransparency = 0
                icon.Active = false
                icon.AnchorPoint = Vector2.new(0.5, 0.5)
                icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                icon.BackgroundTransparency = 1
                icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
                icon.BorderSizePixel = 0
                icon.Position = UDim2.new(0.5, 0, 0.5, 0)
                icon.Selectable = false
                icon.Size = UDim2.new(0, 18, 0, 18)
                icon.Visible = true
                icon.ZIndex = 1
                icon.Parent = btn

                local iconScale = Instance.new("UIScale")
                iconScale.Name = "scale"
                iconScale.Scale = 1
                iconScale.Parent = icon

                table.insert(quickTabs, {Button = btn, Icon = icon, Scale = iconScale, Tab = nil, IsDashboard = false, IsPeek = false, IsCloseOthers = false, IsBackToSpace = false})
                return btn, icon
            end

            buildQuickTabButton("quick_tab_1", 0)
            buildQuickTabButton("quick_tab_2", 0)
            buildQuickTabButton("quick_tab_3", 0)

            -- button.page.options.list (UIListLayout)
            local optionsList = Instance.new("UIListLayout")
            optionsList.Name = "list"
            optionsList.Padding = UDim.new(0, 10)
            optionsList.FillDirection = Enum.FillDirection.Horizontal
            optionsList.HorizontalAlignment = Enum.HorizontalAlignment.Left
            optionsList.SortOrder = Enum.SortOrder.LayoutOrder
            optionsList.VerticalAlignment = Enum.VerticalAlignment.Top
            optionsList.Parent = options

            -- button.scale (UIScale)
            local buttonScale = Instance.new("UIScale")
            buttonScale.Name = "scale"
            buttonScale.Scale = 1
            buttonScale.Parent = button

            -- cover (ImageLabel) - overlay flash khi bấm ra ngoài
            local cover = Instance.new("ImageLabel")
            cover.Name = "cover"
            cover.Image = "rbxassetid://91331674599520"
            cover.ImageColor3 = Color3.fromRGB(255, 255, 255)
            cover.ImageTransparency = 1
            cover.ScaleType = Enum.ScaleType.Slice
            cover.SliceCenter = Rect.new(512, 223, 512, 335)
            cover.Active = false
            cover.AnchorPoint = Vector2.new(0.5, 0)
            cover.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            cover.BackgroundTransparency = 1
            cover.BorderColor3 = Color3.fromRGB(0, 0, 0)
            cover.BorderSizePixel = 0
            cover.Position = UDim2.new(0.5, 0, 0, 0)
            cover.Selectable = true
            cover.Size = UDim2.new(1, 0, 1, 0)
            cover.Visible = true
            cover.ZIndex = 100
            cover.Parent = frame

            -- ================= Logic (port từ accessibility_handler LocalScript gốc) =================
            -- Toàn bộ logic hover/click/tween dưới đây giữ nguyên hành vi gốc, chỉ thay
            -- main_module:Go_To(...) bằng Assets.Main.OpenSingleTab (mở 1 trong 3 tab gần nhất).

            local on_frame = false

            -- Đếm số tab con đang mở (KHÔNG tính Dashboard) để quyết định
            -- Space (đóng, <2 tab) hay Options (đóng, >=2 tab). Chữ ở state
            -- đóng (icon "open") đổi theo, không chỉ nội dung lúc hover.
            local function countOpenChildTabs()
                if not SpaceUI.CurrentOpenTab then return 0 end
                local n = 0
                for _ in SpaceUI.CurrentOpenTab do
                    n += 1
                end
                return n
            end

            local function updateAccessibilityLabel()
                if countOpenChildTabs() >= 2 then
                    openIcon.Text = "Options"
                else
                    openIcon.Text = "Space"
                end
            end

            -- Đổ vào quickTabs đúng bộ 3 nút GỐC (trước khi có Peek/CloseOthers/
            -- BackToSpace): 2 quick-tab (tab mở gần nhất) + icon Dashboard ở giữa.
            -- Dùng chung cho case <2 tab THẬT và cho "Back to Space" (xem tạm bộ
            -- nút gốc trong khi vẫn đang >=2 tab, không đổi state thật).
            local function fillQuickTabsLegacy()
                local tabs = Assets.Main.GetQuickAccessTabs(2)
                for i, entry in quickTabs do
                    entry.IsPeek = false
                    entry.IsCloseOthers = false
                    entry.IsBackToSpace = false
                    if i == 2 then
                        entry.Tab = nil
                        entry.IsDashboard = true
                        entry.Icon.Image = "rbxassetid://11295288868"
                        entry.Button.Visible = true
                    else
                        local slot = (i == 1) and 1 or 2
                        local tab = tabs[slot]
                        entry.Tab = tab
                        entry.IsDashboard = false
                        entry.Icon.Image = tab and tab.Icon or ""
                        entry.Button.Visible = tab ~= nil
                    end
                end
            end

            -- Đổ vào quickTabs bộ 3 nút multiview MỚI (CloseOthers/Peek/BackToSpace),
            -- dùng khi >=2 tab mở.
            local function fillQuickTabsMultiview()
                for i, entry in quickTabs do
                    entry.Tab = nil
                    entry.IsDashboard = false
                    entry.IsPeek = false
                    entry.IsCloseOthers = false
                    entry.IsBackToSpace = false
                    if i == 1 then
                        entry.IsCloseOthers = true
                        entry.Icon.Image = "rbxassetid://124976839256685"
                    elseif i == 2 then
                        entry.IsPeek = true
                        entry.Icon.Image = "rbxassetid://81932043269843"
                    else
                        entry.IsBackToSpace = true
                        entry.Icon.Image = "rbxassetid://89183883274841"
                    end
                    entry.Button.Visible = true
                end
            end

            local function refreshQuickTabIcons()
                updateAccessibilityLabel()
                if countOpenChildTabs() >= 2 then
                    fillQuickTabsMultiview()
                else
                    fillQuickTabsLegacy()
                end
            end

            local function accessibility(state)
                if state then
                    refreshQuickTabIcons()
                    pageLayout:JumpTo(options)

                    TS:Create(button, info, {Size = UDim2.fromOffset(270, 40)}):Play()
                    TS:Create(button, info, {ImageTransparency = 0}):Play()
                    TS:Create(buttonScale, info, {Scale = 1.2}):Play()

                    task.spawn(function()
                        for _, entry in quickTabs do
                            TS:Create(entry.Icon, inst, {ImageTransparency = 1}):Play()
                            TS:Create(entry.Scale, inst, {Scale = 0}):Play()
                        end

                        task.wait()

                        for i, entry in quickTabs do
                            TS:Create(entry.Icon, quick, {ImageTransparency = 0}):Play()
                            TS:Create(entry.Scale, quick, {Scale = 1}):Play()
                            task.wait(0.1)
                        end
                    end)
                else
                    pageLayout:JumpTo(front)
                    TS:Create(button, info, {Size = UDim2.fromOffset(190, 40)}):Play()
                end
            end

            -- Back-to-Space (nút phải trong Options khi >=2 tab): "3 nút expand
            -- gốc của Space" nghĩa là bộ 3 quick-tab CŨ (2 tab gần nhất + icon
            -- Dashboard giữa) - tức layout Options trước khi có Peek/CloseOthers/
            -- BackToSpace, KHÔNG phải page "front" (chữ Space tĩnh, chỉ 1 nút).
            -- Vẫn ở lại page "options" (không JumpTo front, không đổi Size) - chỉ
            -- đổi NỘI DUNG bên trong quickTabs, kèm animation cascade fade-out/
            -- fade-in giống hệt lúc accessibility(true) chạy lần đầu.
            local function showFrontWhileExpanded()
                fillQuickTabsLegacy()
                task.spawn(function()
                    for _, entry in quickTabs do
                        TS:Create(entry.Icon, inst, {ImageTransparency = 1}):Play()
                        TS:Create(entry.Scale, inst, {Scale = 0}):Play()
                    end

                    task.wait()

                    for i, entry in quickTabs do
                        TS:Create(entry.Icon, quick, {ImageTransparency = 0}):Play()
                        TS:Create(entry.Scale, quick, {Scale = 1}):Play()
                        task.wait(0.1)
                    end
                end)
            end

            updateAccessibilityLabel()
            pageLayout:JumpTo(front)

            table.insert(SpaceUI.Connections, open.MouseButton1Click:Connect(function()
                accessibility(true)
            end))

            for _, entry in quickTabs do
                table.insert(SpaceUI.Connections, entry.Button.MouseButton1Click:Connect(function()
                    if entry.IsPeek then
                        -- Peek không đóng accessibility panel ngay và không tự mở UI:
                        -- nó chỉ show layout lưới các tab đang mở. Panel tự đóng lại
                        -- (accessibility(false)) sau khi peek Exit (chọn card hoặc bấm ra ngoài).
                        accessibility(false)
                        SpaceUI.Peek.Toggle()
                        return
                    end
                    if entry.IsCloseOthers then
                        -- Đóng mọi tab trừ tab đang focus + Dashboard. KHÔNG đóng panel -
                        -- người dùng vẫn đang ở expand, panel tự cập nhật lại theo số tab
                        -- mới (có thể rơi về <2 tab, refreshQuickTabIcons lo việc đó).
                        local ok = Assets.Main.CloseAllExceptFocused()
                        if not ok and Assets.Notifications and Assets.Notifications.Send then
                            Assets.Notifications.Send({
                                Description = "Không có tab nào đang được focus để giữ lại.",
                                Duration = 3,
                            })
                        end
                        refreshQuickTabIcons()
                        return
                    end
                    if entry.IsBackToSpace then
                        -- Chỉ đổi layout hiển thị TẠM về front (Space gốc) trong khi vẫn
                        -- đang expand - không gọi accessibility(false) vì cái đó thu nhỏ
                        -- cả pill lại (thoát hẳn panel), không đúng ý "quay lại 3 nút
                        -- expand của Space". Việc quay lại Options khi thu gọn xảy ra tự
                        -- nhiên ở lần accessibility(true)/refreshQuickTabIcons() kế tiếp.
                        showFrontWhileExpanded()
                        return
                    end
                    accessibility(false)
                    if entry.IsDashboard then
                        if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame then
                            if not SpaceUI.Background.Objects.MainFrame.Visible then
                                Assets.Main.ToggleVisibility(true)
                            end
                        end
                        return
                    end
                    if not entry.Tab then return end
                    if SpaceUI.Background and SpaceUI.Background.Objects and SpaceUI.Background.Objects.MainFrame then
                        if not SpaceUI.Background.Objects.MainFrame.Visible then
                            Assets.Main.ToggleVisibility(true)
                        end
                    end
                    Assets.Main.OpenSingleTab(entry.Tab)
                end))
            end

            table.insert(SpaceUI.Connections, frame.MouseEnter:Connect(function()
                on_frame = true
                if not UserInputService.TouchEnabled then
                    accessibility(true)
                end
            end))

            table.insert(SpaceUI.Connections, frame.MouseLeave:Connect(function()
                on_frame = false
                if not UserInputService.TouchEnabled then
                    accessibility(false)
                end
            end))

            table.insert(SpaceUI.Connections, UserInputService.InputBegan:Connect(function()
                if not on_frame then
                    accessibility(false)
                    TS:Create(button, info, {ImageTransparency = 0.8}):Play()
                    TS:Create(buttonScale, info, {Scale = 0.7}):Play()
                end
            end))

            for _, entry in quickTabs do
                table.insert(SpaceUI.Connections, entry.Button.MouseEnter:Connect(function()
                    TS:Create(entry.Icon, quick, {ImageColor3 = Color3.fromRGB(255, 214, 10)}):Play()
                    TS:Create(entry.Scale, quick, {Scale = 1.4}):Play()
                end))
                table.insert(SpaceUI.Connections, entry.Button.MouseButton1Down:Connect(function()
                    TS:Create(entry.Scale, quick, {Scale = 0.7}):Play()
                end))
                table.insert(SpaceUI.Connections, entry.Button.InputEnded:Connect(function()
                    TS:Create(entry.Icon, quick, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    TS:Create(entry.Scale, quick, {Scale = 1}):Play()
                end))
            end

            SpaceUI.AccessibilityButton = {
                Frame = frame,
                Button = button,
                Options = options,
                QuickTabs = quickTabs,
                Refresh = refreshQuickTabIcons,
                UpdateLabel = updateAccessibilityLabel,
            }
        end
    end

    Assets.Main.Uninject = function()
        Assets.Main.OnUninject:Fire(true)

        SpaceUI.Background.Objects.MainScreenGui:Destroy()
        SpaceUI.Notifications.Objects.NotificationGui:Destroy()
        SpaceUI.ArrayList.Objects.ArrayGui:Destroy()
        if SpaceUI.TopbarIcon then SpaceUI.TopbarIcon:Destroy() end
        if SpaceUI.AccessibilityGui then SpaceUI.AccessibilityGui:Destroy() end

        if SpaceUI.Mobile then
            for i,v in SpaceUI.Background.MobileButtons.Buttons do
                if v and v.Functions and v.Functions.Destroy then
                    v.Functions.Destroy()
                end
            end
        end

        for i,v in SpaceUI.Tabs.Tabs do
            if v.Modules then
                for i2,v2 in v.Modules do
                    if v2 and v2.Callback then
                        v2.Callback(v2, false)
                        if v2.Data and v2.Data.Enabled then
                            v2.Data.Enabled = false
                        end
                    end
                end
            end
        end
        for i,v in SpaceUI.Connections do
            v:Disconnect()
        end
        
        Assets.Main.OnUninject:Destroy()
        table.clear(getgenv().SpaceUI)
        getgenv().SpaceUI = nil
    end

    local cantogglewithkeybind = true
    Assets.Main.Load = function(file)
        if not SpaceUI.Background then
            SpaceUI.Background = Assets.MainBackground.Init()
        end

        if not SpaceUI.Dashboard then
            SpaceUI.Dashboard = Assets.Pages.NewPage({
                Name = "Dashboard",
                Icon = "rbxassetid://11295288868",
                Default = true
            })
            Assets.Dashboard.NewTab({
                Name = "Premium",
                Icon = "rbxassetid://102351199755031",
                TabInfo = "Powerful modules kept premium",
                Dashboard = SpaceUI.Dashboard
            })

            local Settings = Assets.Pages.NewPage({
                Name = "Settings",
                Icon = "rbxassetid://11293977610",
                Default = false
            })

            local SettingsPage = Assets.SettingsPage.Init(Settings)
            local MainSettings = SettingsPage.Functions.NewSection({Name = "main"})
            MainSettings.Functions.NewButton({Name = "Uninject", Callback = function()
                Assets.Main.Uninject()
            end})
            MainSettings.Functions.NewButton({Name = "Notifications", Default = true, Toggle = true, Flag = "Notifications", Callback = function(self, enabled)
                SpaceUI.Config.UI.Notifications = enabled
                Assets.Config.Save("UI", SpaceUI.Config.UI)
            end})
            MainSettings.Functions.NewButton({Name = "Animations", Default = true, Toggle = true, Flag = "Anim", Callback = function(self, enabled)
                SpaceUI.Config.UI.Anim = enabled
                Assets.Config.Save("UI", SpaceUI.Config.UI)
            end})
            MainSettings.Functions.NewButton({Name = "ArrayList", Default = false, Toggle = true, Flag = "ArrayList", Callback = function(self, enabled)
                SpaceUI.Config.UI.ArrayList = enabled
                local Array
                if not SpaceUI.ArrayList.Loaded then
                    Array = Assets.ArrayList.Init()
                else
                    Array = SpaceUI.ArrayList
                end
                Array.Functions.Toggle(enabled)

                Assets.Config.Save("UI", SpaceUI.Config.UI)
            end})
            MainSettings.Functions.NewButton({Name = "Shortcut", Default = true, Toggle = true, Flag = "ShortcutEnabled", Callback = function(self, enabled)
                SpaceUI.Config.UI.ShortcutEnabled = enabled
                Assets.Config.Save("UI", SpaceUI.Config.UI)
                if enabled then
                    if Assets.Shortcut and Assets.Shortcut.Init then
                        local ok, err = pcall(Assets.Shortcut.Init)
                        if not ok then
                            warn("[SpaceUI] Shortcut.Init() failed:", err)
                        end
                    end
                    if Assets.Shortcut and Assets.Shortcut.UI then
                        Assets.Shortcut.UI.Enabled = true
                    end
                    if Assets.Shortcut and Assets.Shortcut.TopbarIcon then
                        Assets.Shortcut.TopbarIcon:setEnabled(true)
                    end
                else
                    if Assets.Shortcut and Assets.Shortcut.UI then
                        Assets.Shortcut.UI.Enabled = false
                    end
                    if Assets.Shortcut and Assets.Shortcut.TopbarIcon then
                        Assets.Shortcut.TopbarIcon:setEnabled(false)
                    end
                end
            end})
            MainSettings.Functions.NewButton({Name = "Change Keybind", Callback = function(self)
                self.Objects.MainButtonText.Text = "Press the key you want to bind"
                local changecon = nil
                changecon = UserInputService.InputBegan:Connect(function(input)
                    if input and input.KeyCode.Name ~= "Unknown" then
                        cantogglewithkeybind = false
                        self.Objects.MainButtonText.Text = "Changed Keybind to " .. input.KeyCode.Name
                        SpaceUI.Config.UI.ToggleKeyCode = input.KeyCode.Name
                        Assets.Config.Save("UI", SpaceUI.Config.UI)
                        task.wait(1)
                        cantogglewithkeybind = true
                        self.Objects.MainButtonText.Text = "Change Keybind"
                    else
                        self.Objects.MainButtonText.Text = "Error Setting Bind"
                        task.wait(1)
                        self.Objects.MainButtonText.Text = "Change Keybind"
                    end
                    changecon:Disconnect()
                end)
                table.insert(SpaceUI.Connections, changecon)
            end})
            MainSettings.Functions.NewButton({Name = "Reset Game Config", Callback = function()
                SpaceUI.Config.Game = {
                    Modules = {},
                    Keybinds = {},
                    Sliders = {},
                    TextBoxes = {},
                    MiniToggles = {},
                    Dropdowns = {},
                    ToggleLists = {},
                    ModuleKeybinds = {},
                    Other = {}
                }
                Assets.Config.Save(SpaceUI.GameSave, SpaceUI.Config.Game)
            end})
            MainSettings.Functions.NewButton({Name = "Reset UI Config", Last = true, Callback = function()
                local keepAccessibilityChoice = SpaceUI.Config.UI.UseAccessibilityButton
                if keepAccessibilityChoice == nil then keepAccessibilityChoice = true end
                SpaceUI.Config.UI = {
                    Position = {X = 0.5, Y = 0.5},
                    Size = {X = 0.37294304370880129, Y = 0.683131217956543},
                    FullScreen = false,
                    ToggleKeyCode = "LeftAlt",
                    Scale = 1,
                    Notifications = true,
                    Anim = true,
                    ArrayList = false,
                    TabColor = {value1 = 40, value2 = 40, value3 = 40},
                    TabTransparency = 0.07,
                    KeybindTransparency = 0.7,
                    KeybindColor = {value1 = 0, value2 = 0, value3 = 0},
                    UseAccessibilityButton = keepAccessibilityChoice,
                    ShortcutEnabled = true,
                }
                Assets.Config.Save("UI", SpaceUI.Config.UI)
            end})

            local ThemeSettings = SettingsPage.Functions.NewSection({Name = "Theme"})
            ThemeSettings.Functions.NewButton({Name = "TabColor", Textbox = true, Flag = "TabColor", Default = "70, 70, 70", Callback = function(self, value)
                local split = string.split(value, ",")
                if #split == 3 then
                    local v1, v2, v3 = split[1]:gsub(" ", ""), split[2]:gsub(" ", ""), split[3]:gsub(" ", "")
                    if tonumber(v1) and tonumber(v2) and tonumber(v3) then
                        SpaceUI.Config.UI.TabColor = {value1 = tonumber(v1), value2 = tonumber(v2), value3 = tonumber(v3)}
                        Assets.Config.Save("UI", SpaceUI.Config.UI)
                        for i,v in SpaceUI.Tabs.Tabs do
                            v.Objects.ActualTab.ImageColor3 = Color3.fromRGB(tonumber(v1), tonumber(v2), tonumber(v3))
                            v.Objects.CloseButton.BackgroundColor3 = Color3.fromRGB(tonumber(v1 + 20), tonumber(v2 + 20), tonumber(v3 + 20))
                            for i2, b in v.Modules do
                                if b.Objects and b.Objects.BackButton then 
                                    b.Objects.BackButton.BackgroundColor3 = Color3.fromRGB(tonumber(v1 + 20), tonumber(v2 + 20), tonumber(v3 + 20))
                                end
                            end
                        end
                    end
                end
            end})
            ThemeSettings.Functions.NewButton({Name = "TabTransparency", Textbox = true, Flag = "TabTransparency", Default = "0.1", Callback = function(self, value)
                if tonumber(value) then
                    SpaceUI.Config.UI.TabTransparency = tonumber(value)
                    for i,v in SpaceUI.Tabs.Tabs do
                        v.Objects.ActualTab.ImageTransparency = SpaceUI.Config.UI.TabTransparency
                    end
                    Assets.Config.Save("UI", SpaceUI.Config.UI)
                end
            end})
            ThemeSettings.Functions.NewButton({Name = "KeybindColor", Textbox = true, Flag = "KeybindColor", Default = "85, 89, 91", Callback = function(self, value)
                local split = string.split(value, ",")
                if #split == 3 then
                    local v1, v2, v3 = split[1]:gsub(" ", ""), split[2]:gsub(" ", ""), split[3]:gsub(" ", "")
                    if tonumber(v1) and tonumber(v2) and tonumber(v3) then
                        SpaceUI.Config.UI.KeybindColor = {value1 = tonumber(v1), value2 = tonumber(v2), value3 = tonumber(v3)}
                        Assets.Config.Save("UI", SpaceUI.Config.UI)
                        for i,v in SpaceUI.Tabs.Tabs do
                            if v.Objects.ActualTab:FindFirstChildWhichIsA("TextButton") then
                                v.Objects.ActualTab:FindFirstChildWhichIsA("TextButton").BackgroundColor3 = Color3.fromRGB(tonumber(v1), tonumber(v2), tonumber(v3))
                            end
                        end
                    end
                end
            end})
            ThemeSettings.Functions.NewButton({Name = "KeybindTransparency", Textbox = true, Flag = "KeybindTransparency", Last = true, Default = "0.015", Callback = function(self, value)
                if tonumber(value) then
                    SpaceUI.Config.UI.KeybindTransparency = tonumber(value)
                    Assets.Config.Save("UI", SpaceUI.Config.UI)
                    for i,v in SpaceUI.Tabs.Tabs do
                        if v.Objects.ActualTab:FindFirstChildWhichIsA("TextButton") then
                            v.Objects.ActualTab:FindFirstChildWhichIsA("TextButton").BackgroundTransparency = tonumber(value)
                        end
                    end
                end
            end})


            Assets.Functions.LoadFile("SpaceUI/Games/"..file..".lua", "https://raw.githubusercontent.com/warprbx/HubRewrite/refs/heads/main/Hub/Games/"..file..".lua")
            Assets.Config.Load(file, "Game")
            return {Background = SpaceUI.Background, Dashboard = SpaceUI.Dashboard, Settings = Settings}
        else
            Assets.Functions.LoadFile("SpaceUI/Games/"..file..".lua", "https://raw.githubusercontent.com/warprbx/HubRewrite/refs/heads/main/Hub/Games/"..file..".lua")
            Assets.Config.Load(SpaceUI.GameSave, "Game")
            return {Background = SpaceUI.Background, Dashboard = SpaceUI.Dashboard}
        end
    end




    local ToggleTweens = {}
    local Restore = {}
    local IsToggleAnimating = false
    Assets.Main.ToggleVisibility = function(visible)
        if SpaceUI.TopbarIcon then
            if visible then
                SpaceUI.TopbarIcon:select()
            else
                SpaceUI.TopbarIcon:deselect()
            end
        end
        do
            if not SpaceUI.Config.UI.Anim then
                SpaceUI.Background.Objects.MainFrame.Visible = visible
                if visible then
                    SpaceUI.Background.Objects.MainFrame.BackgroundTransparency = 0.1
                    SpaceUI.Background.Objects.MainFrame.ImageTransparency = 0.8
                    SpaceUI.Background.Objects.MainFrameScale.Scale = 1
                    SpaceUI.Background.Objects.WindowControls.GroupTransparency = 0.4
                end
                return
            end

            if IsToggleAnimating then repeat task.wait() until not IsToggleAnimating end
            IsToggleAnimating = true

            -- Cancel any leftover tweens from previous toggle and clear the table
            -- so the completedTweens counter can correctly match #ToggleTweens.
            for _, tw in ToggleTweens do
                tw:Cancel()
            end
            table.clear(ToggleTweens)

            local tweenInfo = TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
            if visible then
                if not SpaceUI.Background.Objects.MainFrame.Visible then  
                    if SpaceUI.Mobile then
                        -- TopbarPlus manages visibility automatically
                    end
                    SpaceUI.Background.Objects.MainFrame.Visible = true
                    SpaceUI.Background.Objects.DropShadow.Visible = true
                    
                    SpaceUI.Background.Objects.MainFrame.BackgroundTransparency = 1
                    SpaceUI.Background.Objects.MainFrame.ImageTransparency = 1
                    SpaceUI.Background.Objects.MainFrameScale.Scale = 1.2
                    SpaceUI.Background.Objects.WindowControls.GroupTransparency = 1


                    table.insert(ToggleTweens, TweenService:Create(SpaceUI.Background.Objects.MainFrame, tweenInfo, {BackgroundTransparency = 0.1, ImageTransparency = 0.8}))
                    table.insert(ToggleTweens, TweenService:Create(SpaceUI.Background.Objects.WindowControls, tweenInfo, {GroupTransparency = 0.4}))
                    table.insert(ToggleTweens, TweenService:Create(SpaceUI.Background.Objects.MainFrameScale, tweenInfo, {Scale = 1}))

                    for i,v in Restore do
                        v.Visible = true
                    end
                    for i,v in SpaceUI.Pages do
                        if v.Objects and v.Objects.ActualPage and v.Selected then
                            v.Objects.ActualPage.Visible = true
                        end
                    end
                    table.clear(Restore)

                    local completedTweens = 0
                    for i,v in ToggleTweens do
                        v:Play()
                        v.Completed:Connect(function()
                            completedTweens += 1
                            if completedTweens == #ToggleTweens then
                                IsToggleAnimating = false
                            end
                        end)
                    end
                    if SpaceUI.CurrentOpenTab then
                        for i,v in SpaceUI.CurrentOpenTab do
                            if v.Functions then
                                task.wait(0.015)
                                v.Functions.ToggleTab(true, true, true)
                            end
                        end
                    end

                else
                    IsToggleAnimating = false
                end

            else
                if SpaceUI.Notifications.Active.discordnoti then
                    SpaceUI.Notifications.Active.discordnoti.Functions.Remove(true)
                end
                if SpaceUI.Mobile then
                    -- TopbarPlus manages visibility automatically
                end

                if SpaceUI.CurrentOpenTab then
                    for i,v in SpaceUI.CurrentOpenTab do
                        if v.Functions then
                            v.Functions.ToggleTab(false, true, true)
                        end
                    end
                end

                table.insert(ToggleTweens, TweenService:Create(SpaceUI.Background.Objects.MainFrame, tweenInfo, {BackgroundTransparency = 1, ImageTransparency = 1}))
                table.insert(ToggleTweens, TweenService:Create(SpaceUI.Background.Objects.WindowControls, tweenInfo, {GroupTransparency = 1}))
                table.insert(ToggleTweens, TweenService:Create(SpaceUI.Background.Objects.MainFrameScale, tweenInfo, {Scale = 1.2}))

                if SpaceUI.Pageselector.Objects.Pageselector.Visible then
                    SpaceUI.Pageselector.Objects.Pageselector.Visible = false
                    table.insert(Restore, SpaceUI.Pageselector.Objects.Pageselector)
                end
                SpaceUI.Background.Objects.NavigationButtons.Visible = false
                table.insert(Restore, SpaceUI.Background.Objects.NavigationButtons)
                SpaceUI.Background.Objects.WindowControls.Visible = false
                table.insert(Restore, SpaceUI.Background.Objects.WindowControls)

                for i,v in SpaceUI.Pages do
                    if v.Objects and v.Objects.ActualPage then
                        v.Objects.ActualPage.Visible = false
                    end
                end
                SpaceUI.Background.Objects.DropShadow.Visible = false

                local completedTweens = 0
                for i,v in ToggleTweens do
                    v:Play()
                    v.Completed:Connect(function()
                        completedTweens += 1
                        if completedTweens == #ToggleTweens then
                            IsToggleAnimating = false
                        end
                    end)
                end

                task.wait(0.8)
                SpaceUI.Background.Objects.MainFrame.Visible = false
                IsToggleAnimating = false
            end
        end
    end
    table.insert(SpaceUI.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed and UserInputService:GetFocusedTextBox() or not cantogglewithkeybind then return end
        if input.KeyCode.Name == SpaceUI.Config.UI.ToggleKeyCode then
            Assets.Main.ToggleVisibility(not SpaceUI.Background.Objects.MainFrame.Visible)
        end
    end))
    -- [Shortcut Integration] Initialize Shortcut Radial Menu & Handlers
    local shortcutInitOk, shortcutInitErr = pcall(function()
        if Assets.Shortcut and Assets.Shortcut.Init then
            Assets.Shortcut.Init()
        end
    end)
    if not shortcutInitOk then
        warn("[SpaceUI] Shortcut.Init() failed:", shortcutInitErr)
    end


end

SpaceUI.Assets = Assets
return Assets
