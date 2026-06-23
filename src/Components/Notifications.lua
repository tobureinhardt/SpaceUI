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
end
