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
    Assets.ArrayList.Init = function()
        local Data = {
            Entries = {},
            Connections = {},
            Functions = {},
            RainbowSpeed = 5000,
            Loaded = true,
            Objects = SpaceUI.ArrayList.Objects
        }


        local Create = function(Class: string, Properties: { [string]: any }): Instance
            local Inst = Instance.new(Class)
            
            for Index, Value in next, Properties do
                if Index ~= 'Children' then
                    Inst[Index] = Value
                end
            end
            
            if Properties.Children then
                for Index, Child in Properties.Children do
                    Child.Name = Index
                    Child.Parent = Inst
                end
            end
            
            return Inst
        end

        local TEXT_SIZE = if SpaceUI.Mobile then 16 else 24
        
        local download = Assets.Font.Download("Product-Sans-Regular", "https://raw.githubusercontent.com/warprbx/HubRewrite/refs/heads/main/SpaceUI/Assets/Fonts/Product-Sans-Regular.ttf")
        if not download then
            return 
        end

        local product_sans_id = Assets.Font.create_family("ProductSans", {
            {
                name = "Regular",
                weight = 400,
                file = "SpaceUI/Assets/Fonts/Product-Sans-Regular.ttf",
            },
        })
        local font = Font.new(product_sans_id)

        type EntryInstance = Frame & {
            Line: Frame,
            MainText: TextLabel
        }
        
        type ModuleEntry = {
            Name: string,
            Instance: EntryInstance?,
        }
        
        local Template = Create("Frame", {
            BackgroundColor3 = Color3.new(),
            BackgroundTransparency = 0.35,
            BorderSizePixel = 0,
            Size = UDim2.fromOffset(0, 30),
            
            Children = {
                Line = Create("Frame", {
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundColor3 = Color3.new(1, 1, 1),
                    Position = UDim2.fromScale(1, 0),
                    Size = UDim2.new(0, 2, 1, 0),
                    BorderSizePixel = 0,
                }),
                MainText = Create("TextLabel", {
                    BackgroundTransparency = 1,
                    FontFace = font,
                    Text = '',
                    TextColor3 = Color3.fromRGB(239, 239, 239),
                    TextSize = TEXT_SIZE,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Size = UDim2.fromScale(1, 1),
                }),
                UIPadding = Create("UIPadding", {
                    PaddingLeft = UDim.new(0, 6)
                })
            }
        })
        
        local Holder = Create("Frame", {
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -10, 0, 10),
            Size = UDim2.new(0.5, 0, 1, -10),
            Children = {
                UIListLayout = Create("UIListLayout", {
                    HorizontalAlignment = Enum.HorizontalAlignment.Right,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
            },
        })


        function Data.Functions.PushModule(Entry: ModuleEntry)
            local EntryInstance = Template:Clone()
            local MainText = EntryInstance.MainText
            local MainSize = GetTextBounds(Entry.Name, font, TEXT_SIZE)
            
            MainText.Text = Entry.Name
            
            local XSize = MainSize.X + 14
            local YSize = TEXT_SIZE + 6
            
            MainText.Size = UDim2.new(0, MainSize.X, 1, 0)
            
            EntryInstance.Size = UDim2.fromOffset(XSize, YSize)
            EntryInstance.LayoutOrder = #Data.Entries
            EntryInstance.Parent = Holder
                        
            local Index = #Data.Entries + 1
            local _Entry
            _Entry = {
                Name = Entry.Name,
                Instance = EntryInstance,
                Index = Index,
                Deconstruct = function()
                    _Entry.Instance:Destroy()
                    Entry.Instance = nil
                    local Index = table.find(Data.Entries, _Entry)
                    if Index then
                        table.remove(Data.Entries, Index)
                    end
                    Data.Functions.Resort()
                end
                
            }
            
            Data.Entries[Index] = _Entry
            
            Data.Functions.Resort()
            
            return _Entry
        end


        function Data.Functions.Resort()
            table.sort(Data.Entries, function(a: ModuleEntry, b: ModuleEntry)
                local TotalTextA = a.Name
                local TotalTextB = b.Name
                
                local SizeA = GetTextBounds(TotalTextA, font, TEXT_SIZE)
                local SizeB = GetTextBounds(TotalTextB, font, TEXT_SIZE)
        
                return SizeA.X > SizeB.X
            end)
            
            for Index, Entry in next, Data.Entries do
                Entry.Instance.LayoutOrder = Index
            end
        end

        local function Rainbow(Delay: number)
            local time = (os.clock() * 1000 + Delay) / 1000
            local hue = (math.sin(time * 0.5) * 40 + 240) 
            local saturation = math.sin(time * 0.3) * 0.1 + 0.35
            local value = 0.95
            
            return Color3.fromHSV(hue / 360, saturation, value)
        end
        
        local function ArrayListRainbow()
            local Speed = Data.RainbowSpeed
            
            for i, Module in Data.Entries do
                local Color = Rainbow(Speed - i * 250) 
                Module.Instance.MainText.TextColor3 = Color
                Module.Instance.Line.BackgroundColor3 = Color
            end
        end

        function Data.Functions.Toggle(visible: boolean)
            SpaceUI.ArrayList.Objects.ArrayGui.Enabled = visible
            if not visible then
                for i,v in Data.Connections do
                    if table.find(SpaceUI.Connections, v) then
                        table.remove(SpaceUI.Connections, table.find(SpaceUI.Connections, v))
                    end
                    v:Disconnect()
                    Data.Connections[i] = nil
                end
            else
                if not Data.Connections.Rainbow then
                    local r = game:GetService("RunService").RenderStepped:Connect(ArrayListRainbow)
                    table.insert(Data.Connections, r)
                    table.insert(SpaceUI.Connections, r)
                end
            end
        end

        Holder.Parent = SpaceUI.ArrayList.Objects.ArrayGui

        SpaceUI.ArrayList = Data
        return Data
    end
end

do
    
end
