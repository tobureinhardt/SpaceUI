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
    type FontFamily = {
        name: string,
        faces: { FontFace },
    }
    
    type FontFace = {
        name: string,
        file: string,
        weight: number,
        style: string?,
    }

    Assets.Font.Download = function(Name: string, Font: string)
        local data = game:HttpGet(Font)
        if not isfile("SpaceUI/Assets/Fonts/"..Name..".ttf") then
            if data and not tostring(data):find("404") then
                writefile("SpaceUI/Assets/Fonts/"..Name..".ttf", data)
            else
                return false
            end
        end
        return true
    end

    local family_cache = {}
    Assets.Font.create_family = function(name: string, faces: { FontFace })
        local family = { name = name, faces = {} }

        for i, face in next, faces do
            local rbx_face = {
                name = assert(face.name, "Face #"..tostring(i).." is invalid (no name field)"),
                weight = assert(face.weight, "Face #"..tostring(i).." is invalid (no weight field)"),
                style = face.style or "normal",
                assetId = getcustomasset(face.file),
            }

            table.insert(family.faces, rbx_face)
        end

        writefile("SpaceUI/Assets/Fonts/"..name..".json", HttpService:JSONEncode(family))

        local id = getcustomasset("SpaceUI/Assets/Fonts/"..name..".json")
        family_cache[name] = id

        return id
    end

    Assets.Font.get_family = function(name: string)
        local id = assert(family_cache[name], "Family "..tostring(name).." not found!")

        return id
    end
end
end
