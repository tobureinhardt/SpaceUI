return function(Assets, SpaceUI, Services)
    local PlayersSV = Services.Players
    local HttpService = Services.HttpService
    local TweenService = Services.TweenService
    local UserInputService = Services.UserInputService
    local Workspace = Services.Workspace
    local TextService = Services.TextService
    local UserCamera = Services.UserCamera
    local LocalPlayer = Services.LocalPlayer
    local GetTextBounds = Services.GetTextBounds
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
            Data = {Dragging = false, SettingsOpen = false}
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
            SpaceUI.Tabs.TabBackground = Instance.new("ImageButton", SpaceUI.Background.Objects.MainFrame)
            SpaceUI.Tabs.TabBackground.AnchorPoint = Vector2.new(0.5, 0.5)
            SpaceUI.Tabs.TabBackground.BackgroundTransparency = 1
            SpaceUI.Tabs.TabBackground.Position = UDim2.fromScale(0.5, 0.5)
            SpaceUI.Tabs.TabBackground.Size = UDim2.fromScale(1, 1)
            SpaceUI.Tabs.TabBackground.Image = "rbxassetid://16286761786"
            SpaceUI.Tabs.TabBackground.ImageTransparency = 0.5
            SpaceUI.Tabs.TabBackground.ScaleType = Enum.ScaleType.Stretch
            SpaceUI.Tabs.TabBackground.Visible = false
            SpaceUI.Tabs.TabBackground.AutoButtonColor = false
            Instance.new("UICorner", SpaceUI.Tabs.TabBackground).CornerRadius = UDim.new(0, 20)
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

        tab.Objects.TabDragCanvas = Instance.new("CanvasGroup", tab.Objects.ActualTab)
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
                    local Viewport = UserCamera.ViewportSize
                    local Delta = Vector2.new(0, 0)
                    if mouseStart and input then
                        Delta = (Vector2.new(input.Position.X, input.Position.Y) - Vector2.new(mouseStart.X, mouseStart.Y))
                    end
        
                    local newX = frameStart.X.Scale + (Delta.X / (Viewport.X / (SpaceUI.Background.Objects.MainFrame.Size.X.Scale + 2.13)))
                    local newY = frameStart.Y.Scale + (Delta.Y / (Viewport.Y / 2))
        
                    tab.Objects.ActualTab.Position = UDim2.fromScale(newX, newY)
                    local flagged = false
                    for i,v in SpaceUI.Tabs.Tabs do
                        if v.Objects and v.Objects.ActualTab then
                            local Tab = v.Objects.ActualTab
                            local TabPos = Tab.Position
                            if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                if not flagged then
                                    local t = TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                    t:Play()
                                    task.spawn(function()
                                        t.Completed:Wait()
                                        task.wait(0.1)
                                        if not flagged and SpaceUI.Tabs.TabBackground.ZIndex ~= -100 then
                                            SpaceUI.Tabs.TabBackground.ZIndex = -100
                                        end
                                    end)
                                end
                            else
                                if v.Objects.ActualTab.Visible then
                                    TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                    SpaceUI.Tabs.TabBackground.ZIndex = 1
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


        
        local TabPad = Instance.new("UIPadding", tab.Objects.ActualTab)
        TabPad.PaddingBottom = UDim.new(0, 10)
        TabPad.PaddingLeft = UDim.new(0, 10)
        TabPad.PaddingRight = UDim.new(0, 10)
        TabPad.PaddingTop = UDim.new(0, 10)

        local TabScale = Instance.new("UIScale", tab.Objects.ActualTab)
        TabScale.Scale = 0
        
        local TabConstraint = Instance.new("UISizeConstraint", tab.Objects.ActualTab)
        TabConstraint.MaxSize = Vector2.new(1000, 800)

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

        local CloseButton = Instance.new("ImageButton", tab.Objects.ActualTab)
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

        tab.Objects.ScrollFrame = Instance.new("ScrollingFrame", tab.Objects.ActualTab)
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

        local ScrollFrameList = Instance.new("UIListLayout", tab.Objects.ScrollFrame)
        ScrollFrameList.SortOrder = Enum.SortOrder.LayoutOrder
        ScrollFrameList.Padding = UDim.new(0, 10)
        ScrollFrameList.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local ScrollFramePad = Instance.new("UIPadding", tab.Objects.ScrollFrame)
        ScrollFramePad.PaddingBottom = UDim.new(0, 10)
        ScrollFramePad.PaddingLeft = UDim.new(0, 15)
        ScrollFramePad.PaddingRight = UDim.new(0, 15)

        local SearchBar = Instance.new("Frame", tab.Objects.ScrollFrame)
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

        local SearchBarIcon = Instance.new("ImageLabel", SearchBar)
        SearchBarIcon.AnchorPoint = Vector2.new(0, 0.5)
        SearchBarIcon.BackgroundTransparency = 1
        SearchBarIcon.Position = UDim2.new(0, -25, 0.5, 0)
        SearchBarIcon.Size = UDim2.fromOffset(17, 17)
        SearchBarIcon.Image = "rbxassetid://11293977875"
        SearchBarIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
        SearchBarIcon.ImageTransparency = 0.5
        SearchBarIcon.ScaleType = Enum.ScaleType.Fit

        local SearchBarClear = Instance.new("ImageButton", SearchBar)
        SearchBarClear.AnchorPoint = Vector2.new(1, 0.5)
        SearchBarClear.BackgroundTransparency = 1
        SearchBarClear.Position = UDim2.fromScale(1, 0.5)
        SearchBarClear.Size = UDim2.fromOffset(40, 40)
        SearchBarClear.AutoButtonColor = false

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
        tab.Functions.ToggleTab = function(visible, anim, reopen)
            task.spawn(function()
                tab.Opened = visible
                tab.Objects.ScrollFrame.Visible = visible
                if visible then
                    if not reopen then
                        if not SpaceUI.CurrentOpenTab then
                            SpaceUI.CurrentOpenTab = {tab}
                        else
                            table.insert(SpaceUI.CurrentOpenTab, tab)
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
                        TabScale.Scale = 1.2

                        local flagged = false
                        for i,v in SpaceUI.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        local t = TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                        t:Play()
                                        task.spawn(function()
                                            t.Completed:Wait()
                                            task.wait(0.1)
                                            if not flagged and SpaceUI.Tabs.TabBackground.ZIndex ~= -100 then
                                                SpaceUI.Tabs.TabBackground.ZIndex = -100
                                            end
                                        end)
                                        SpaceUI.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab or v == tab then
                                        SpaceUI.Tabs.TabBackground.ZIndex = 1
                                        TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()
                                        SpaceUI.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end
                        TweenService:Create(tab.Objects.ActualTab, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = SpaceUI.Config.UI.TabTransparency}):Play()
                        TweenService:Create(TabScale, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {Scale = 1}):Play()
                    else
                        local flagged = false
                        for i,v in SpaceUI.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        local t = TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                        t:Play()
                                        task.spawn(function()
                                            t.Completed:Wait()
                                            task.wait(0.1)
                                            if not flagged and SpaceUI.Tabs.TabBackground.ZIndex ~= -100 then
                                                SpaceUI.Tabs.TabBackground.ZIndex = -100
                                            end
                                        end)
                                        SpaceUI.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab or v == tab then
                                        SpaceUI.Tabs.TabBackground.ZIndex = 1
                                        TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 0.5}):Play()
                                        SpaceUI.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end
                        TabScale.Scale = 1
                        tab.Objects.ActualTab.ImageTransparency = SpaceUI.Config.UI.TabTransparency
                    end
                else
                    if not reopen then
                        table.remove(SpaceUI.CurrentOpenTab, table.find(SpaceUI.CurrentOpenTab, tab))
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
                        TweenService:Create(tab.Objects.ActualTab, TweenInfo.new(0.8, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
                        TweenService:Create(TabScale, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {Scale = 1.2}):Play()

                        local flagged = false
                        for i,v in SpaceUI.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        local t = TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                        t:Play()
                                        task.spawn(function()
                                            t.Completed:Wait()
                                            task.wait(0.1)
                                            if not flagged and SpaceUI.Tabs.TabBackground.ZIndex ~= -100 then
                                                SpaceUI.Tabs.TabBackground.ZIndex = -100
                                            end
                                        end)
                                        SpaceUI.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab then
                                        TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                        SpaceUI.Tabs.TabBackground.ZIndex = 1
                                        SpaceUI.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end

                        task.wait(0.15)
                    else
                        TabScale.Scale = 1.2
                        tab.Objects.ActualTab.ImageTransparency = 1
                        local flagged = false
                        for i,v in SpaceUI.Tabs.Tabs do
                            if v.Objects and v.Objects.ActualTab then
                                local Tab = v.Objects.ActualTab
                                local TabPos = Tab.Position
                                if TabPos.X.Scale > 0.9 or 0 > TabPos.X.Scale or TabPos.Y.Scale >= 0.95 or 0 > TabPos.Y.Scale then
                                    if not flagged then
                                        local t = TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 1})
                                        t:Play()
                                        task.spawn(function()
                                            t.Completed:Wait()
                                            task.wait(0.1)
                                            if not flagged and SpaceUI.Tabs.TabBackground.ZIndex ~= -100 then
                                                SpaceUI.Tabs.TabBackground.ZIndex = -100
                                            end
                                        end)
                                        SpaceUI.IsAllowedToHoverTabButton = false
                                    end
                                else
                                    if v.Objects.ActualTab.Visible and v ~= tab then
                                        TweenService:Create(SpaceUI.Tabs.TabBackground, TweenInfo.new(0.8, Enum.EasingStyle.Exponential), {ImageTransparency = 0.5}):Play()
                                        SpaceUI.Tabs.TabBackground.ZIndex = 1
                                        SpaceUI.IsAllowedToHoverTabButton = true
                                        flagged = true
                                    end
                                end
                            end
                        end
                    end
                    local cnt = 0 
                    for i,v in SpaceUI.CurrentOpenTab do
                        cnt += 1
                    end
                    if 0 >= cnt then
                        SpaceUI.Tabs.TabBackground.Visible = false
                    end
                end
                tab.Objects.ActualTab.Visible = visible
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
            tab.Functions.ToggleTab(not tab.Opened, true)
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

            local Backbutton = Instance.new("ImageButton", tab.Objects.ActualTab)
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

            local KeyBindButton = Instance.new("TextButton", tab.Objects.ActualTab)
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
            local moduleclickcon = ModuleData.Objects.Module.MouseButton1Click:Connect(function()
                if db then return end
                db = true
                DropOpen = not DropOpen
                if DropOpen then
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
                else
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
                db = false
            end)
            table.insert(SpaceUI.Connections, moduleclickcon)
            table.insert(ModuleData.Connections, moduleclickcon)

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
                if not SpaceUI.ArrayList.Loaded then
                    Array = Assets.ArrayList.Init()
                else
                    Array = SpaceUI.ArrayList
                end

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

                        if updateArray then
                            ModuleData.Data.ArrayIndex = Array.Functions.PushModule({
                                Name = ModuleData.Name
                            })
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
                            local Index = ModuleData.Data.ArrayIndex
                            if Index.Deconstruct then
                                Index.Deconstruct()
                            end
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
                if not SpaceUI.Mobile then
                    ModuleData.Data.SettingKeybind = true
                    KeyBindButton.Text = "Press Any Key"
                else
                    if ModuleData.Data.Keybind then
                        ModuleData.Functions.UnbindKeybind(true)
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
                ModuleData.Functions.Toggle(not ModuleData.Data.Enabled, false, true, true, true)
            end)
            table.insert(SpaceUI.Connections, togglebuttoncon)
            table.insert(ModuleData.Connections, togglebuttoncon)

            local settingsbuttoncon = SettingsButton.MouseButton1Click:Connect(function()
                tab.Data.SettingsOpen = true
                ModuleData.Data.SettingsOpen = true
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

            local currentbackbuttonfunc = function()
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

                local SettingNameText = Instance.new("TextLabel", SettingDetails)
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
                ToggleBox.AnchorPoint = Vector2.new(1, 0.5)
                ToggleBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                ToggleBox.BackgroundTransparency = 0.4
                ToggleBox.Position = UDim2.fromScale(1, 0.5)
                ToggleBox.Size = UDim2.fromOffset(36, 21)
                Instance.new("UICorner", ToggleBox).CornerRadius = UDim.new(0, 15)
                
                local ToggleCircle = Instance.new("Frame", ToggleBox)
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

                local SliderBox = Instance.new("Frame", SliderData.Objects.MainInstance)
                SliderBox.AnchorPoint = Vector2.new(0, 0.5)
                SliderBox.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
                SliderBox.BackgroundTransparency = 0.6
                SliderBox.Position = UDim2.fromScale(0, 0.63)
                SliderBox.Size = UDim2.fromScale(1, 0.05)
                Instance.new("UICorner", SliderBox).CornerRadius = UDim.new(0, 15)

                local Fill = Instance.new("Frame", SliderBox)
                Fill.AnchorPoint = Vector2.new(0, 0.5)
                Fill.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                Fill.Position = UDim2.fromScale(0, 0.5)
                Fill.Size = UDim2.fromScale(math.clamp((tonumber(SliderValue2.Text)-SliderData.Min)/(SliderData.Max-SliderData.Min), 0, 1), 1)
                Instance.new("UICorner", Fill).CornerRadius = UDim.new(0, 15)

                local Circle2 = Instance.new("ImageButton", Fill)
                Circle2.AutoButtonColor = false
                Circle2.AnchorPoint = Vector2.new(0.5,0.5)
                Circle2.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                Circle2.Position = UDim2.fromScale(1, 0.5)
                Circle2.Size = UDim2.fromOffset(10, 10)
                Circle2.ImageTransparency = 1
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
                    local ValueSplitIcon = Instance.new("ImageLabel", Numbers)
                    ValueSplitIcon.BackgroundTransparency = 1
                    ValueSplitIcon.Size = UDim2.fromOffset(15, 15)
                    ValueSplitIcon.Image = "rbxassetid://136254264936851"
                    ValueSplitIcon.ImageColor3 = Color3.fromRGB(255,255,255)
                    ValueSplitIcon.ImageTransparency = 0.6
                    ValueSplitIcon.ScaleType = Enum.ScaleType.Stretch
                    ValueSplitIcon.LayoutOrder = 1

                    Circle1 = Instance.new("ImageButton", Fill)
                    Circle1.AutoButtonColor = false
                    Circle1.AnchorPoint = Vector2.new(0.5,0.5)
                    Circle1.BackgroundColor3 = Color3.fromRGB(195, 195, 195)
                    Circle1.Position = UDim2.fromScale(0, 0.5)
                    Circle1.Size = UDim2.fromOffset(10, 10)
                    Circle1.ImageTransparency = 1
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
end
