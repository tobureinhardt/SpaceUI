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

-- Initialize SpaceUI Library global state if not already set
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
        Tabs = { Tabs = {}, TabBackground = nil },
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
end
local SpaceUI = getgenv().SpaceUI

local Services = {}
local ModulePaths = {
    "src/Core/Services.lua",
    "src/Core/Util.lua",
    "src/Core/Config.lua",
    "src/Core/Font.lua",
    "src/Components/Notifications.lua",
    "src/Components/Background.lua",
    "src/Components/ArrayList.lua",
    "src/Components/Pages.lua",
    "src/Components/Dashboard.lua",
    "src/Settings/SettingsPage.lua",
    "src/Core/Main.lua",
}

local function loadModule(path)
    local source
    if isfile and isfile(path) then
        source = readfile(path)
    elseif SpaceUI.BaseUrl then
        source = game:HttpGet(SpaceUI.BaseUrl .. "/" .. path)
    else
        error("SpaceUI Library source module not found: " .. path)
    end
    return loadstring(source, "SpaceUI:" .. path)()
end

for _, path in ModulePaths do
    loadModule(path)(Assets, SpaceUI, Services)
end

return Assets
