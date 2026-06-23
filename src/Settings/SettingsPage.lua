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
end
