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

        local minWindowSize = SpaceUI.Mobile and {X = 0.88, Y = 0.78} or {X = 0.62, Y = 0.78}
        if SpaceUI.Config.UI.Size.X < minWindowSize.X or SpaceUI.Config.UI.Size.Y < minWindowSize.Y then
            SpaceUI.Config.UI.Size = {
                X = math.max(SpaceUI.Config.UI.Size.X, minWindowSize.X),
                Y = math.max(SpaceUI.Config.UI.Size.Y, minWindowSize.Y),
            }
        end
    
        InitInfo.Objects.MainScreenGui = Instance.new("ScreenGui", Assets.Functions.gethui())
        InitInfo.Objects.MainScreenGui.ResetOnSpawn = false
        InitInfo.Objects.MainScreenGui.IgnoreGuiInset = true
        InitInfo.Objects.MainScreenGui.DisplayOrder = 10000
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
end
