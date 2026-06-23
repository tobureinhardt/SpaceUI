return function(Assets, SpaceUI, Services)
    Assets.Functions.cloneref = cloneref or function(ref: Instance) return ref end

    Services.Players = Assets.Functions.cloneref(game:GetService("Players"))
    Services.HttpService = Assets.Functions.cloneref(game:GetService("HttpService"))
    Services.TweenService = Assets.Functions.cloneref(game:GetService("TweenService"))
    Services.UserInputService = Assets.Functions.cloneref(game:GetService("UserInputService"))
    Services.Workspace = Assets.Functions.cloneref(game:GetService("Workspace"))
    Services.TextService = Assets.Functions.cloneref(game:GetService("TextService"))
    Services.UserCamera = Services.Workspace.CurrentCamera
    Services.LocalPlayer = Services.Players.LocalPlayer
end
