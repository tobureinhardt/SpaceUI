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
        if name and SpaceUI and SpaceUI.Tabs and SpaceUI.Tabs.Tabs then
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
local function GetTextBounds(str: string, font: Font, textsize: number)
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = str
    Params.Font = font
    Params.Size = textsize
    Params.Width = 1e9
    Params.RichText = false
    
    return TextService:GetTextBoundsAsync(Params)
end
    Services.GetTextBounds = GetTextBounds
end
