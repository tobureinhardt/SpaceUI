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
    Assets.Main.OnUninject = Instance.new("BindableEvent")
    -- Custom Topbar Button
    do
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer

        local TopbarGui = Instance.new("ScreenGui")
        TopbarGui.Name = "SpaceUITopbar"
        TopbarGui.ResetOnSpawn = false
        TopbarGui.IgnoreGuiInset = true
        TopbarGui.DisplayOrder = 9999
        TopbarGui.Parent = Assets.Functions.gethui and Assets.Functions.gethui() or LocalPlayer.PlayerGui

        -- Nút nằm sát góc phải, căn giữa theo chiều cao topbar (36px trên PC, ~56px mobile)
        local Btn = Instance.new("ImageButton")
        Btn.Name = "SpaceUIBtn"
        Btn.AnchorPoint = Vector2.new(1, 0)
        Btn.Position = UDim2.new(1, -8, 0, 8)
        Btn.Size = UDim2.fromOffset(44, 44)
        Btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
        Btn.BackgroundTransparency = 0.3
        Btn.BorderSizePixel = 0
        Btn.AutoButtonColor = false
        Btn.Parent = TopbarGui
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)

        local BtnIcon = Instance.new("ImageLabel", Btn)
        BtnIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        BtnIcon.Position = UDim2.fromScale(0.5, 0.5)
        BtnIcon.Size = UDim2.fromOffset(26, 26)
        BtnIcon.BackgroundTransparency = 1
        BtnIcon.Image = "rbxassetid://117924444252444"
        BtnIcon.ScaleType = Enum.ScaleType.Fit
        BtnIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)

        Btn.MouseEnter:Connect(function()
            Btn.BackgroundTransparency = 0.1
        end)
        Btn.MouseLeave:Connect(function()
            Btn.BackgroundTransparency = 0.3
        end)

        Btn.MouseButton1Click:Connect(function()
            local newVisible = not SpaceUI.Background.Objects.MainFrame.Visible
            Assets.Main.ToggleVisibility(newVisible)
        end)

        -- Sync khi đóng từ nút X bên trong UI
        local origToggle = Assets.Main.ToggleVisibility
        Assets.Main.ToggleVisibility = function(visible)
            origToggle(visible)
            Btn.BackgroundTransparency = visible and 0.1 or 0.3
        end

        SpaceUI.TopbarGui = TopbarGui
        SpaceUI.TopbarBtn = Btn
    end

    Assets.Main.Uninject = function()
        Assets.Main.OnUninject:Fire(true)

        SpaceUI.Background.Objects.MainScreenGui:Destroy()
        SpaceUI.Notifications.Objects.NotificationGui:Destroy()
        SpaceUI.ArrayList.Objects.ArrayGui:Destroy()
        if SpaceUI.TopbarGui then SpaceUI.TopbarGui:Destroy() end

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


            Assets.Functions.LoadFile("SpaceUI/Games/"..file..".lua", "https://raw.githubusercontent.com/warprbx/HubRewrite/refs/heads/main/SpaceUI/Games/"..file..".lua")
            Assets.Config.Load(file, "Game")
            return {Background = SpaceUI.Background, Dashboard = SpaceUI.Dashboard, Settings = Settings}
        else
            Assets.Functions.LoadFile("SpaceUI/Games/"..file..".lua", "https://raw.githubusercontent.com/warprbx/HubRewrite/refs/heads/main/SpaceUI/Games/"..file..".lua")
            Assets.Config.Load(SpaceUI.GameSave, "Game")
            return {Background = SpaceUI.Background, Dashboard = SpaceUI.Dashboard}
        end
    end




    local ToggleTweens = {}
    local Restore = {}
    local IsToggleAnimating = false
    Assets.Main.ToggleVisibility = function(visible)
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

                task.wait(0.5)
                SpaceUI.Background.Objects.MainFrame.Visible = false
            end
        end
    end
    table.insert(SpaceUI.Connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed and UserInputService:GetFocusedTextBox() or not cantogglewithkeybind then return end
        if input.KeyCode.Name == SpaceUI.Config.UI.ToggleKeyCode then
            Assets.Main.ToggleVisibility(not SpaceUI.Background.Objects.MainFrame.Visible)
        end
    end))

end

SpaceUI.Assets = Assets
end
