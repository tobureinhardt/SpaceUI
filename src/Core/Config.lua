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
end
