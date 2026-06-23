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
end
