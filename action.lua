local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local PlayersService = game:GetService("Players")
local LocalPlayer = PlayersService.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)

local function getDeviceType()
    local UserInputService = game:GetService("UserInputService")
    if UserInputService.TouchEnabled then
        if UserInputService.KeyboardEnabled then
            return "平板"
        else
            return "手机"
        end
    else
        return "电脑"
    end
end

local deviceType = getDeviceType()
local uiSize, uiPosition

if deviceType == "手机" then
    uiSize = UDim2.fromOffset(400, 240)
elseif deviceType == "平板" then
    uiSize = UDim2.fromOffset(450, 350)
else
    uiSize = UDim2.fromOffset(600, 400)
end
uiPosition = UDim2.new(0.5, 0, 0.5, 0)

WindUI.TransparencyValue = 0.15

WindUI:AddTheme({
    Name = "CyberBlue",
    Accent = "#18181b",
    Dialog = "#18181b",
    Outline = "#FFFFFF",
    Text = "#FFFFFF",
    Placeholder = "#000000",
    Background = "#0e0e10",
    Button = "#52525b",
    Icon = "#00f7ff"
})

WindUI:SetTheme("CyberBlue")

local Window = WindUI:CreateWindow({
    Title = "殺脚本被遗弃┃动画播放器",
    Icon = "sparkle",
    Author = "风御 X",
    Folder = "ExampleScript",
    Size = uiSize,
    Position = uiPosition,
    Theme = "CyberBlue",
    Background = WindUI:Gradient({
        ["0"] = { Color = Color3.fromHex("#1a1a1a"), Transparency = 0 },
        ["50"] = { Color = Color3.fromHex("#2c3e50"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 }
    }, { Rotation = 150 }),
    Transparent = true,
    HideSearchBar = true,
    SideBarWidth = 150,
    ScrollBarEnabled = false,
    CornerRadius = UDim.new(0, 14),
    DropShadow = true
})

Window:SetToggleKey(Enum.KeyCode.K)
WindUI:SetFont("rbxasset://fonts/families/AccanthisADFStd.json")

Window:EditOpenButton({
    Title = "动画播放器",
    Icon = "sparkle",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 0,
    Color = ColorSequence.new(
        Color3.fromHex("000000"),
        Color3.fromHex("000000")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets
local emotes = Assets.Emotes
local Camera = workspace.CurrentCamera
local lplr = game.Players.LocalPlayer
local lchr = nil

local Exclusive_Emotes = {}
local Gettable_Emotes = {}
local Emotes = {}

local ExtraEmotes = {
    MinionBreakdown = {
        ["DisplayName"] = "Minion Breakdown",
        ["Description"] = "3 Million Orb",
        ["AssetID"] = "rbxassetid://89449841864319",
        ["SFX"] = "rbxassetid://1838457617",
        ["CUSTOMASSET"] = "https://raw.githubusercontent.com/1MP3LT3/ScriptHub/refs/heads/main/Sounds/ILLIT%20(%EC%95%84%EC%9D%B4%EB%A6%BF)%20'NOT%20CUTE%20ANYMORE%E2%80%99%20Official%20MV.mp3",
        ["SFXProperties"] = {
            ["Looped"] = false,
        },
        ["CreatedServer"] = function(p4)
            local v5 = p4.Character
            if v5 then
                local v_u_6 =
                    game:GetService("ReplicatedStorage").Assets.Skins.Killers["1x1x1x1"].Abyss1x1x1x1.Config.ZombieEmote
                        :Clone()
                v_u_6.Name = "EmoteZombie"
                v_u_6.PrimaryPart.Anchored = true
                for _, v7 in v_u_6:GetDescendants() do
                    if v7:IsA("BasePart") then
                        v7.CanCollide = false
                        v7.CanQuery = false
                        v7.CanTouch = false
                    end
                end
                v_u_6:SetPrimaryPartCFrame(v5.PrimaryPart.CFrame)
                v_u_6.Parent = workspace.Misc
                v_u_6.Dummy:FindFirstChildOfClass("Animator"):LoadAnimation(v_u_6.Animation):Play()
                task.delay(20.4, function()
                    if v_u_6 ~= nil then
                        v_u_6:Destroy()
                    end
                end)
            end
        end,
        ["DestroyedServer"] = function(p4)
            local v5 = workspace.Misc
            if v5 then
                if v5:FindFirstChild("EmoteZombie") then
                    v5:FindFirstChild("EmoteZombie"):Destroy()
                end
            end
        end,
    },
    AnnhilationGuitar = {
        ["DisplayName"] = "Guitar",
        ["Description"] = "Guitar",
        ["AssetID"] = "rbxassetid://77434400165211",
        ["SFX"] = "rbxassetid://101986282901846",
        ["SFXProperties"] = {
            ["Looped"] = false,
        },
        ["Created"] = function(p4)
            local chr = p4.Character
            local Guitar =
                game:GetService("ReplicatedStorage").Assets.Skins.Killers.JohnDoe.AnnihilationJohnDoe.Rig.Guitar:Clone()
            Guitar.Name = "Guitar"
            Guitar.Parent = chr
            Guitar.Transparency = 0
        end,
        ["Destroyed"] = function(p7)
            local v8 = p7.Character
            local v9 = v8 and v8:FindFirstChild("Guitar")
            if v9 then
                v9.Transparency = 1
            end
        end,
    },
    bluudanc = {
        ["DisplayName"] = "bluudanc",
        ["Description"] = "yayyy wahooo weeeeee",
        ["AssetID"] = "rbxassetid://70756604276888",
        ["SFX"] = "rbxassetid://128124155529803",
        ["SFXProperties"] = {
            ["Looped"] = true,
        },
    },
    prettydanc = {
        ["DisplayName"] = "pretty dance",
        ["Description"] = "yayyy wahooo weeeeee",
        ["AssetID"] = "rbxassetid://85315044663872",
        ["SFX"] = "rbxassetid://119720647959535",
        ["SFXProperties"] = {
            ["Looped"] = true,
            ["Volume"] = 0.7,
        },
    },
    Snap = {
        ["DisplayName"] = "Snap",
        ["Description"] = " ",
        ["Speed"] = 6,
        ["AssetID"] = "rbxassetid://132946177664650",
        ["SFX"] = "rbxassetid://128566549159266",
        ["SFXProperties"] = {
            ["Looped"] = true,
        },
    },
}

local function safecall(func)
    task.spawn(function()
        pcall(func)
    end)
end

local function GetMAX(Table)
    local MAX = 0
    for _, _ in pairs(Table) do
        MAX = MAX + 1
    end
    if MAX == 0 then
        MAX = 1
    end
    return MAX
end

local function SetupUpdateCharacter()
    if lplr.Character then
        lchr = lplr.Character
    end

    lplr.CharacterAdded:Connect(function(chrA)
        lchr = chrA
    end)
    lplr.CharacterRemoving:Connect(function()
        lchr = nil
    end)
end
SetupUpdateCharacter()

local function LoadEmote(Emote, RequiredEmoteS)
    local RequiredEmote = RequiredEmoteS or table.clone(require(Emote))
    local AudioProps = RequiredEmote.SFXProperties

    local AnimId = RequiredEmote.AssetID
    local AudioId = RequiredEmote.SFX

    local Audios = {}
    local AnimTracks = {}

    local function AnimTP(AnimationId)
        local Anim = Instance.new("Animation")
        Anim.AnimationId = AnimationId
        local AnimT = lchr:WaitForChild("Humanoid", 5):WaitForChild("Animator", 5):LoadAnimation(Anim)
        return AnimT
    end

    local function CreateAudio(SoundId, IsLooped)
        local Audio = Instance.new("Sound", lchr.PrimaryPart)
        Audio.Looped = IsLooped or false
        Audio.Name = Emote.Name

        if RequiredEmote.CUSTOMASSET then
            local success, err = pcall(function()
                local response = request({
                    Url = RequiredEmote.CUSTOMASSET,
                    Method = "GET",
                })
                writefile("CustomMusic.mp3", response.Body)
                Audio.SoundId = getcustomasset("CustomMusic.mp3", false)
            end)
            if not success then
                warn("[" .. Emote.Name .. "] 自定义音频加载失败: " .. tostring(err))
                Audio.SoundId = SoundId
            end
        else
            Audio.SoundId = SoundId
        end
        return Audio
    end

    if typeof(AnimId) == "string" then
        local Number = 1
        local AnimT = AnimTP(AnimId)
        AnimTracks[tostring(Number)] = AnimT
    elseif typeof(AnimId) == "table" then
        for Number, Anim in ipairs(AnimId) do
            local AnimT = AnimTP(Anim)
            AnimTracks[tostring(Number)] = AnimT
        end
    end

    if typeof(AudioId) == "string" then
        local Number = 1
        Audios[tostring(Number)] = CreateAudio(AudioId)
    elseif typeof(AudioId) == "table" then
        for Number, Audio in pairs(AudioId) do
            Audios[tostring(Number)] = CreateAudio(Audio)
        end
    end

    if AudioProps then
        for _, Audio in pairs(Audios) do
            for AudioPropName, AudioPropVal in AudioProps do
                if typeof(AudioPropVal) == "number" and AudioPropVal == 0 then
                    continue
                end
                Audio[AudioPropName] = AudioPropVal
            end
        end
    end

    Emotes[Emote.Name] = {
        StartFunction = RequiredEmote.Created or RequiredEmote.CreatedServer or nil,
        EndFunction = RequiredEmote.Destroyed or RequiredEmote.DestroyedServer or nil,
        LoopedFunction = RequiredEmote.Looped or RequiredEmote.LoopedServer or nil,

        StartAnimation = RequiredEmote.AssetID.Start and AnimTP(RequiredEmote.AssetID.Start),
        StartAudio = RequiredEmote.SFX.Start and CreateAudio(RequiredEmote.SFX.Start),

        LoopAnimation = RequiredEmote.AssetID.Loop and AnimTP(RequiredEmote.AssetID.Loop),
        LoopAudio = RequiredEmote.SFX.Loop and CreateAudio(RequiredEmote.SFX.Loop, true),

        Audios = Audios,
        AnimTracks = AnimTracks,
        RequiredEmote = RequiredEmote,
    }
end

local function UpdateEmotes()
    repeat
        task.wait()
    until lchr and lchr.PrimaryPart

    for EmoteName, ExtraEmote in ExtraEmotes do
        LoadEmote({ Name = tostring(EmoteName) }, ExtraEmote)
    end

    for _, Emote in emotes:GetChildren() do
        safecall(function()
            LoadEmote(Emote)
        end)
    end
end

local function EmoteUseNormal(mobile)
    local Hum = lchr:FindFirstChild("Humanoid")
    local EmoteName = nil

    if not Hum then return end

    for _, Emote in emotes:GetChildren() do
        local requireEmote = require(Emote)
        if requireEmote.DisplayName == _G.Emotes then
            EmoteName = Emote.Name
        end
    end
    for ExtraEmoteName, ExtraEmote in ExtraEmotes do
        if ExtraEmote.DisplayName == _G.Emotes then
            EmoteName = ExtraEmoteName
        end
    end
    if not EmoteName then return end

    local SpeedMultipliers = lchr:FindFirstChild("SpeedMultipliers")
    if not SpeedMultipliers then return end
    local EmoteHACK = SpeedMultipliers:FindFirstChild("EmoteHACK")

    if EmoteHACK then
        if getgenv().StopEmoting then
            getgenv().StopEmoting()
        end
        EmoteHACK:Destroy()
    end

    local TableForFunctions = nil
    local ADEmote = Emotes[EmoteName]

    EmoteHACK = Instance.new("NumberValue")
    EmoteHACK.Value = 0
    EmoteHACK.Name = "EmoteHACK"
    EmoteHACK.Parent = SpeedMultipliers

    local Audios = ADEmote.Audios
    local AnimTracks = ADEmote.AnimTracks
    local Audio = nil
    local AnimTrack = nil

    Camera.CameraSubject = lchr:FindFirstChild("Head")

    local Connections = {}
    local RequiredEmote = ADEmote.RequiredEmote

    if RequiredEmote.Speed then
        EmoteHACK.Value = RequiredEmote.Speed / (Hum.WalkSpeed or 12)
        if RequiredEmote.Speed > Hum.WalkSpeed then
            EmoteHACK.Value = 1
        end
    end

    local LoopedAnimT = ADEmote.LoopAnimation
    local LoopSound = ADEmote.LoopAudio
    local StartAnimT = ADEmote.StartAnimation
    local StartSound = ADEmote.StartAudio

    if StartAnimT and LoopSound and StartSound and LoopedAnimT then
        StartAnimT:Play()
        StartSound:Play()
    end

    local RandomNumber = math.random(1, GetMAX(AnimTracks))
    for Number, AnimTrackP in pairs(AnimTracks) do
        if RandomNumber == tonumber(Number) then
            AnimTrack = AnimTrackP
            AnimTrack:Play()
        end
    end

    RandomNumber = ((GetMAX(AnimTracks) == GetMAX(Audios)) and RandomNumber) or math.random(1, GetMAX(Audios))
    for Number, AudioP in pairs(Audios) do
        if RandomNumber == tonumber(Number) then
            Audio = AudioP
            Audio.Name = "PlayerEmoteSFX"
            Audio:Play()
        end
    end

    TableForFunctions = {
        Character = lchr,
        Emote = {
            Animation = AnimTrack and AnimTrack.Animation,
            KeyframeReached = (ADEmote.LoopAnimation and ADEmote.LoopAnimation.KeyframeReached) or AnimTrack.KeyframeReached,
            SFX = Audio,
        },
    }

    safecall(function()
        if ADEmote.StartFunction then
            ADEmote.StartFunction(TableForFunctions)
        end
    end)

    getgenv().StopEmoting = function()
        Camera.CameraSubject = lchr:FindFirstChild("Humanoid")

        safecall(function() AnimTrack:Stop() end)
        safecall(function() StartAnimT:Stop() end)
        safecall(function() StartSound:Stop() end)
        safecall(function() LoopedAnimT:Stop() end)
        safecall(function() LoopSound:Stop() end)
        safecall(function() Audio:Stop(); Audio.Name = EmoteName end)
        safecall(function() EmoteHACK:Destroy() end)

        for _, Connection in Connections do
            Connection:Disconnect()
        end

        safecall(function()
            if ADEmote.EndFunction then
                ADEmote.EndFunction(TableForFunctions)
            end
        end)

        getgenv().StopEmoting = nil
    end

    local StartAnimTConnection = StartAnimT and StartAnimT.Stopped:Connect(function()
        task.wait()
        if getgenv().StopEmoting then
            LoopedAnimT:Play()
            AnimTrack:Play()
            if ADEmote.LoopedFunction then
                ADEmote.LoopedFunction(TableForFunctions)
            end
        end
    end)

    local LoopedAnimTConnection = LoopedAnimT and LoopedAnimT.Stopped:Connect(function()
        task.wait()
        if getgenv().StopEmoting then
            getgenv().StopEmoting()
        end
    end)

    local JumpConnection = Hum.Jumping:Connect(function()
        task.wait()
        if getgenv().StopEmoting then
            getgenv().StopEmoting()
        end
    end)

    local DiedConnection = Hum.Died:Connect(function()
        task.wait()
        if getgenv().StopEmoting then
            getgenv().StopEmoting()
        end
    end)

    local HealthChangedConnection = Hum.HealthChanged:Connect(function()
        task.wait()
        if getgenv().StopEmoting then
            getgenv().StopEmoting()
        end
    end)

    table.insert(Connections, HealthChangedConnection)
    table.insert(Connections, DiedConnection)
    table.insert(Connections, LoopedAnimTConnection)
    table.insert(Connections, StartAnimTConnection)
    table.insert(Connections, JumpConnection)
end

local function EmoteUseCopy(mobile)
    local EmoteName = nil

    for _, Emote in emotes:GetChildren() do
        local requireEmote = require(Emote)
        if requireEmote.DisplayName == _G.Emotes then
            EmoteName = Emote.Name
        end
    end

    if _G.SepecialDropdownForE == "Force" then
        local args = {
            [1] = "PlayEmote",
            [2] = "Animations",
            [3] = EmoteName,
        }
        game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))

        if mobile then
            task.spawn(function()
                while true do
                    task.wait(0.1)
                    if _G.OFF then
                        safecall(function()
                            local args = { [1] = "PlayEmote", [2] = "Animations", [3] = EmoteName }
                            game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
                        end)
                        safecall(function()
                            local args = { "PlayEmote", { buffer.fromstring('"Animations"'), buffer.fromstring('"' .. EmoteName .. '"') } }
                            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                        end)
                        break
                    end
                end
            end)
        else
            local Endput = game:GetService("UserInputService").InputBegan:Connect(function(input)
                if input.KeyCode == _G.KeybindStop then
                    safecall(function()
                        local args = { [1] = "StopEmote", [2] = "Animations", [3] = EmoteName }
                        game:GetService("ReplicatedStorage"):FindFirstChild("Modules"):FindFirstChild("Network"):FindFirstChild("RemoteEvent"):FireServer(unpack(args))
                    end)
                    safecall(function()
                        local args = { "StopEmote", { buffer.fromstring('"Animations"'), buffer.fromstring('"' .. EmoteName .. '"') } }
                        game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
                    end)
                    Endput:Disconnect()
                end
            end)
        end
    end
end

function PlayEmote(mobile)
    if _G.SepecialDropdownForE == "Original" then
        EmoteUseNormal(mobile)
    else
        EmoteUseCopy(mobile)
    end
end

safecall(UpdateEmotes)
lplr.CharacterAdded:Connect(UpdateEmotes)

for _, Emote in emotes:GetChildren() do
    local requireEmote = require(Emote)
    if requireEmote.Exclusive then
        table.insert(Exclusive_Emotes, requireEmote.DisplayName)
    else
        table.insert(Gettable_Emotes, requireEmote.DisplayName)
    end
end

for _, ExtraEmote in ExtraEmotes do
    table.insert(Exclusive_Emotes, ExtraEmote.DisplayName)
end

local AnimTab = Window:Tab({
    Title = "动画播放器", 
    Icon = "play" 
})

local animSection = AnimTab:Section({
    Title = "播放器", 
    Opened = true 
})

animSection:Dropdown({
    Title = "普通动画",
    Values = Gettable_Emotes,
    Default = nil,
    Callback = function(selected)
        _G.Emotes = selected
    end,
    Icon = "list",
    SearchBarEnabled = true,
})

animSection:Dropdown({
    Title = "专属动画",
    Values = Exclusive_Emotes,
    Default = nil,
    Callback = function(selected)
        _G.Emotes = selected
    end,
    Icon = "list",
    SearchBarEnabled = true,
})

animSection:Dropdown({
    Title = "播放模式",
    Values = { "Original", "Force" },
    Default = "Original",
    Callback = function(selected)
        _G.SepecialDropdownForE = selected
    end,
    Icon = "shuffle",
})

animSection:Button({
    Title = "播放动画",
    Icon = "play",
    Callback = function()
        _G.OFF = false
        PlayEmote(true)
    end
})

animSection:Button({
    Title = "停止动画",
    Icon = "square",
    Callback = function()
        _G.OFF = true
        if getgenv().StopEmoting then
            getgenv().StopEmoting()
        end
    end
})

local actionTab = Window:Tab({
    Title = "FE动作", 
    Icon = "person-standing" 
})

local feSection = actionTab:Section({
    Title = "非官方动作动作", 
    Opened = true 
})
local vu710 = nil

feSection:Toggle({
    Title = "撸管",
    Default = false,
    Icon = "hand",
    Callback = function(p711)
        local v712 = game.Players.LocalPlayer
        local v713 = (v712.Character or v712.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
        if v713 then
            if p711 then
                if not (vu710 and vu710.IsPlaying) then
                    local v714 = Instance.new("Animation")
                    v714.AnimationId = "rbxassetid://72042024"
                    vu710 = v713:LoadAnimation(v714)
                    vu710.Looped = true
                    vu710:Play()
                end
            elseif vu710 and vu710.IsPlaying then
                vu710:Stop()
            end
        end
    end
})

feSection:Toggle({
    Title = "张开手臂旋转",
    Default = false,
    Icon = "rotate-cw",
    Callback = function(p715)
        local v716 = game.Players.LocalPlayer
        local v717 = (v716.Character or v716.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
        if v717 then
            if p715 then
                if not (vu710 and vu710.IsPlaying) then
                    local v718 = Instance.new("Animation")
                    v718.AnimationId = "rbxassetid://235542946"
                    vu710 = v717:LoadAnimation(v718)
                    vu710:Play()
                end
            elseif vu710 and vu710.IsPlaying then
                vu710:Stop()
            end
        end
    end
})

feSection:Toggle({
    Title = "旋转手",
    Default = false,
    Icon = "rotate-3d",
    Callback = function(p719)
        local v720 = game.Players.LocalPlayer
        local v721 = (v720.Character or v720.CharacterAdded:Wait()):FindFirstChildOfClass("Humanoid")
        if v721 then
            if p719 then
                if not (vu710 and vu710.IsPlaying) then
                    local v722 = Instance.new("Animation")
                    v722.AnimationId = "rbxassetid://259438880"
                    vu710 = v721:LoadAnimation(v722)
                    vu710.Looped = true
                    vu710:Play()
                end
            elseif vu710 and vu710.IsPlaying then
                vu710:Stop()
            end
        end
    end
})

feSection:Button({
    Title = "直升机",
    Callback = function()
        if game.Players.LocalPlayer.Character.Humanoid.RigType == Enum.HumanoidRigType.R6 then
            spawn(function()
                local speaker = game.Players.LocalPlayer
                local Anim = Instance.new("Animation")
                Anim.AnimationId = "rbxassetid://27432686"
                local bruh = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
                bruh:Play()
                bruh:AdjustSpeed(0)
                speaker.Character.Animate.Disabled = true
                local hi = Instance.new("Sound")
                hi.Name = "Sound"
                hi.SoundId = ""
                hi.Volume = 2
                hi.Looped = true
                hi.archivable = false
                hi.Parent = game.Workspace
                hi:Play()

                local spinSpeed = 40
                local Spin = Instance.new("BodyAngularVelocity")
                Spin.Name = "Spinning"
                Spin.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
                Spin.MaxTorque = Vector3.new(0, math.huge, 0)
                Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
            end)
        else
            spawn(function()
                local speaker = game.Players.LocalPlayer
                local Anim = Instance.new("Animation")
                Anim.AnimationId = "rbxassetid://507776043"
                local bruh = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
                bruh:Play()
                bruh:AdjustSpeed(0)
                speaker.Character.Animate.Disabled = true
                local hi = Instance.new("Sound")
                hi.Name = "Sound"
                hi.SoundId = "空"
                hi.Volume = 2
                hi.Looped = true
                hi.archivable = false
                hi.Parent = game.Workspace
                hi:Play()

                local spinSpeed = 40
                local Spin = Instance.new("BodyAngularVelocity")
                Spin.Name = "Spinning"
                Spin.Parent = game.Players.LocalPlayer.Character.HumanoidRootPart
                Spin.MaxTorque = Vector3.new(0, math.huge, 0)
                Spin.AngularVelocity = Vector3.new(0,spinSpeed,0)
            end)
        end
        local Mouse = game:GetService("Players").LocalPlayer:GetMouse()
        local u = game.Players.LocalPlayer
        local urchar = u.Character

        task.spawn(function()
            qUp = Mouse.KeyUp:Connect(function(KEY)
                if KEY == 'q' then
                    urchar.Humanoid.HipHeight = urchar.Humanoid.HipHeight - 3
                end
            end)
            eUp = Mouse.KeyUp:Connect(function(KEY)
               if KEY == 'e' then
                    urchar.Humanoid.HipHeight = urchar.Humanoid.HipHeight + 3
                end
            end)
        end)
    end
})

feSection:Toggle({
    Title = "坐下",
    Default = false,
    Callback = function(state)
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character:FindFirstChildOfClass("Humanoid").Sit = state
        end
    end
})

do
    local refreshEnabled = false
    local deathPosition = nil

    local function onDied()
        local player = game:GetService("Players").LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            deathPosition = player.Character.HumanoidRootPart.CFrame
        end
    end

    local function onCharacterAdded(newChar)
        if refreshEnabled and deathPosition then
            newChar:WaitForChild("HumanoidRootPart").CFrame = deathPosition
        end
    end

    local player = game:GetService("Players").LocalPlayer
    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.Died:Connect(onDied)
    end
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("Humanoid").Died:Connect(onDied)
    end)

feSection:Toggle({
    Title = "刷新 (死亡后原地复活)",
    Default = false,
    Callback = function(state)
        refreshEnabled = state
    end
})
end

do
    local swimEnabled = false
    local oldGravity = game:GetService("Workspace").Gravity
    local swimHeartbeat = nil
    local gravResetConn = nil
    local player = game:GetService("Players").LocalPlayer

    local function stopSwim()
        if swimHeartbeat then
            swimHeartbeat:Disconnect()
            swimHeartbeat = nil
        end
        if gravResetConn then
            gravResetConn:Disconnect()
            gravResetConn = nil
        end
        game:GetService("Workspace").Gravity = oldGravity
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, state in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                if state ~= Enum.HumanoidStateType.None then
                    hum:SetStateEnabled(state, true)
                end
            end
        end
    end

feSection:Toggle({
    Title = "漂浮",
    Default = false,
    Callback = function(state)
        if state then
            if not player.Character then return end
            local hum = player.Character:FindFirstChildOfClass("Humanoid")
            if not hum then return end

            swimEnabled = true
            oldGravity = game:GetService("Workspace").Gravity
            game:GetService("Workspace").Gravity = 0

            gravResetConn = hum.Died:Connect(function()
                game:GetService("Workspace").Gravity = oldGravity
            end)

            for _, s in ipairs(Enum.HumanoidStateType:GetEnumItems()) do
                if s ~= Enum.HumanoidStateType.None and s ~= Enum.HumanoidStateType.Swimming then
                    hum:SetStateEnabled(s, false)
                end
            end
            hum:ChangeState(Enum.HumanoidStateType.Swimming)

            swimHeartbeat = game:GetService("RunService").Heartbeat:Connect(function()
                pcall(function()
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and hum then
                        if hum.MoveDirection == Vector3.new() and not game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                            hrp.Velocity = Vector3.new()
                        end
                    end
                end)
            end)
        else
            stopSwim()
        end
    end
})

    player.CharacterAdded:Connect(function()
        if swimEnabled then
            swimEnabled = false
            stopSwim()
        end
    end)
end

feSection:Button({
    Title = "变成药丸宝宝",
    Callback = function()
        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        if character then
            repeat task.wait() until character:FindFirstChild("HumanoidRootPart") and character:FindFirstChild("Humanoid")

            local limbs = {"Left Arm", "Right Arm", "Left Leg", "Right Leg"}
            for _, limb in ipairs(limbs) do
                local part = character:FindFirstChild(limb)
                if part then
                    part:Destroy()
                end
            end

            local torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
            if torso then
                local mesh = torso:FindFirstChildOfClass("SpecialMesh")
                if not mesh then
                    mesh = Instance.new("SpecialMesh", torso)
                end
                mesh.MeshId = "rbxasset://fonts/head.mesh"
                mesh.Scale = Vector3.new(1.4, 1.8, 1.4)
            end
        end
    end
})

feSection:Button({
    Title = "滑铲按钮",
    Callback = function()
        local vu727 = game.Players.LocalPlayer
        local v728 = vu727:WaitForChild("PlayerGui")
        local v729 = v728:FindFirstChild("ScreenGui")
        if not v729 then
            v729 = Instance.new("ScreenGui")
            v729.Name = "ScreenGui"
            v729.Parent = v728
        end
        local v730 = Instance.new("TextButton")
        v730.Size = UDim2.new(0, 100, 0, 40)
        v730.Position = UDim2.new(0.5, -50, 0.5, -20)
        v730.Text = "滑铲"
        v730.BackgroundColor3 = Color3.fromRGB(0, 119, 255)
        v730.TextColor3 = Color3.fromRGB(255, 255, 255)
        v730.Font = Enum.Font.GothamBold
        v730.TextSize = 16
        v730.BorderSizePixel = 0
        v730.Parent = v729
        v730.Draggable = true

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 8)
        corner.Parent = v730

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 2
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Parent = v730

        v730.MouseEnter:Connect(function()
            v730.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        end)

        v730.MouseLeave:Connect(function()
            v730.BackgroundColor3 = Color3.fromRGB(0, 119, 255)
        end)

        v730.MouseButton1Click:Connect(function()
            local v731 = vu727.Character or vu727.CharacterAdded:Wait()
            local v732 = v731:WaitForChild("HumanoidRootPart")
            local v733 = v731:WaitForChild("Humanoid")
            local v734 = Instance.new("Animation")
            v734.AnimationId = "rbxassetid://182749109"
            local vu735 = v733:LoadAnimation(v734)
            local v736 = vu735
            vu735:Play()
            local v737 = game:GetService("TweenService")
            local v738 = v732.CFrame * CFrame.new(0, 0, -20)
            local v739 = v737:Create(v732, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                CFrame = v738
            })
            v739:Play()
            v739.Completed:Connect(function()
                vu735:Stop()
            end)
        end)
    end
})

local fakeautoTab = Window:Tab({
    Title = "假格挡", 
    Icon = "shield" 
})

local fakeautoTabSection = fakeautoTab:Section({
    Title = "杀手会信吗？", 
    Opened = true 
})

local _RS      = game:GetService("ReplicatedStorage")
local _UIS     = game:GetService("UserInputService")
local _Players = game:GetService("Players")
local _LP      = _Players.LocalPlayer

local _Assets         = _RS:WaitForChild("Assets")
local _Guest1337Root  = _Assets.Survivors:WaitForChild("Guest1337")
local _Guest1337Skins = _Assets.Skins.Survivors:WaitForChild("Guest1337")

local playerGui = _LP:WaitForChild("PlayerGui")

local function GetScreenGui()
    local screenGui = playerGui:FindFirstChild("ScreenGui")
    if not screenGui then
        screenGui = Instance.new("ScreenGui")
        screenGui.Name = "ScreenGui"
        screenGui.ResetOnSpawn = false
        screenGui.Parent = playerGui
    end
    return screenGui
end

local bf

local function FakeBlockCallback()
    local bg = _LP.Character and _LP.Character:FindFirstChild('Humanoid')
    if not bg then return end
    local anim = Instance.new("Animation")
    anim.AnimationId = bf
    local track = bg:LoadAnimation(anim)
    track:Play()
end

local fakeBlockUIToggle = false

local function GetButton()
    local screenGui = GetScreenGui()
    local button = screenGui:FindFirstChild("FakeBlockButton")
    if not button then
        button = Instance.new("ImageButton")
        button.Name = "FakeBlockButton"
        button.Size = UDim2.new(0, 66, 0, 66)
        button.Position = UDim2.fromScale(0.66, 0.35)
        button.AnchorPoint = Vector2.new(0.5, 0.5)
        button.Image = "rbxassetid://137576632569674"
        button.BackgroundTransparency = 1
        button.Visible = fakeBlockUIToggle
        button.Parent = screenGui

        button.MouseButton1Click:Connect(function()
            if _UIS:GetFocusedTextBox() then return end
            FakeBlockCallback()
        end)
    end
    return button
end

local function SyncButtonVisible()
    local btn = GetButton()
    btn.Visible = fakeBlockUIToggle
end

SyncButtonVisible()

local be = {
    Normal = require(_Guest1337Root.Config).Animations.Block,
}
bf = be.Normal

local bh = {'Normal'}
for _, bj in _Guest1337Skins:GetChildren() do
    if bj:FindFirstChild("Config") and (require(bj.Config).Animations or {}).Block ~= nil then
        local bk = require(bj.Config)
        local bl = bk.DisplayName
        table.insert(bh, bl)
        be[bl] = bk.Animations.Block
        task.spawn(function()
            game:GetService("ContentProvider"):PreloadAsync({bk.Animations.Block})
        end)
    end
end

fakeautoTabSection:Toggle({
    Title = "假格挡（按钮）",
    Default = false,
    Icon = "shield",
    Callback = function(state)
        fakeBlockUIToggle = state
        SyncButtonVisible()
    end
})

_LP.CharacterAdded:Connect(function()
    task.wait(0.2)
    SyncButtonVisible()
end)

playerGui.ChildRemoved:Connect(function(child)
    if child.Name == "ScreenGui" and fakeBlockUIToggle then
        task.wait(0.1)
        SyncButtonVisible()
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        if fakeBlockUIToggle then
            local sg = GetScreenGui()
            if not sg:FindFirstChild("FakeBlockButton") then
                SyncButtonVisible()
            end
        end
    end
end)

local fakeBlockKeybind = true

fakeautoTabSection:Toggle({
    Title = "启用快捷键 (B)",
    Default = true,
    Icon = "keyboard",
    Callback = function(state)
        fakeBlockKeybind = state
    end
})

_UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if not fakeBlockKeybind then return end
    if input.KeyCode == Enum.KeyCode.B then
        FakeBlockCallback()
    end
end)

fakeautoTabSection:Dropdown({
    Title = "格挡动画",
    Values = bh,
    Default = "Normal",
    Icon = "list",
    SearchBarEnabled = true,
    Callback = function(selected)
        if selected and be[selected] then
            bf = be[selected]
        end
    end
})

local blockAnimChangerEnabled = false
local bgConn = nil

local function TableFindThatWorks(t, v)
    for _, x in pairs(t) do
        if x == v then return true end
    end
    return false
end

local function Track(bh)
    local bi = bh and bh:WaitForChild('HumanoidRootPart', 7)
    if not bi then return end
    local bj = bi and bh:WaitForChild("Humanoid", 7)
    if not bj then return end
    local bk = bj:WaitForChild('Animator', 5)
    if not bk then return end

    local function MakeConnection()
        return bk.AnimationPlayed:Connect(function(bl)
            if not TableFindThatWorks(be, bl.Animation.AnimationId) then return end
            if not blockAnimChangerEnabled then return end
            bl:Stop()
            local bm = Instance.new("Animation")
            bm.AnimationId = bf
            local bn = bj:LoadAnimation(bm)
            if bgConn then bgConn:Disconnect() end
            bn:Play()
            bgConn = MakeConnection()
        end)
    end

    bgConn = MakeConnection()
end

fakeautoTabSection:Toggle({
    Title = "更改格挡动画",
    Default = false,
    Icon = "repeat",
    Callback = function(state)
        blockAnimChangerEnabled = state
        if state and _LP.Character then
            Track(_LP.Character)
        end
    end
})

local _Survivors = workspace:FindFirstChild("Players") and workspace.Players:FindFirstChild("Survivors")
if _Survivors then
    _Survivors.ChildAdded:Connect(function(bh)
        repeat task.wait() until (not bh) or bh:GetAttribute("Username") or (not bh.Parent)
        if bh:GetAttribute("Username") == _LP.Name then
            Track(bh)
        end
    end)
end

if _LP.Character then
    Track(_LP.Character)
end

local animationTab = Window:Tab({
    Title = "动作包整合", 
    Icon = "box" 
})

local animationTabSection = animationTab:Section({
    Title = "整合包", 
    Opened = true 
})

local animationControllers = {}
local animationStates = {}

local function createAnimationController(p740, p741, p742, toggleName)
    local controller = {
        active = false,
        connection = nil,
        characterConnection = nil,
        animations = {},
        animIds = { idle = p740, walk = p741, run = p742 },
        toggleName = toggleName
    }

    local function setupAnimations(character)
        if not character or not controller.active then return end

        local humanoid = character:WaitForChild("Humanoid", 5)
        local rootPart = character:WaitForChild("HumanoidRootPart", 5)
        local animator = humanoid and humanoid:WaitForChild("Animator", 5)

        if not humanoid or not rootPart or not animator then return end

        for _, anim in pairs(controller.animations) do
            if anim then
                anim:Stop(0.2)
            end
        end
        controller.animations = {}

        local function loadAnimation(animId)
            local anim = Instance.new("Animation")
            anim.AnimationId = animId
            return animator:LoadAnimation(anim)
        end

        controller.animations.idle = loadAnimation(p740)
        controller.animations.walk = loadAnimation(p741)
        controller.animations.run = loadAnimation(p742)

        if controller.connection then
            controller.connection:Disconnect()
        end

        controller.connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not controller.active then return end
            if not controller.animations.idle or not controller.animations.walk or not controller.animations.run then return end

            local velocity = rootPart.Velocity.Magnitude
            if velocity < 1 then
                if not controller.animations.idle.IsPlaying then
                    controller.animations.idle:Play()
                    controller.animations.walk:Stop(0.2)
                    controller.animations.run:Stop(0.2)
                end
            elseif velocity >= 20 then
                if not controller.animations.run.IsPlaying then
                    controller.animations.run:Play()
                    controller.animations.idle:Stop(0.2)
                    controller.animations.walk:Stop(0.2)
                end
            elseif not controller.animations.walk.IsPlaying then
                controller.animations.walk:Play()
                controller.animations.idle:Stop(0.2)
                controller.animations.run:Stop(0.2)
            end
        end)
    end

    local function startAnimation()
        if controller.active then return end

        controller.active = true
        animationStates[controller.toggleName] = true

        local player = game.Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()

        if controller.characterConnection then
            controller.characterConnection:Disconnect()
        end

        controller.characterConnection = player.CharacterAdded:Connect(function(newCharacter)
            if controller.active then
                wait(1)
                setupAnimations(newCharacter)
            end
        end)

        setupAnimations(character)
    end

    local function stopAnimation()
        if not controller.active then return end

        controller.active = false
        animationStates[controller.toggleName] = false

        if controller.connection then
            controller.connection:Disconnect()
            controller.connection = nil
        end

        if controller.characterConnection then
            controller.characterConnection:Disconnect()
            controller.characterConnection = nil
        end

        for _, anim in pairs(controller.animations) do
            if anim then
                anim:Stop(0.2)
            end
        end
        controller.animations = {}
    end

    return {
        start = startAnimation,
        stop = stopAnimation,
        isActive = function() return controller.active end,
        getToggleName = function() return controller.toggleName end
    }
end

local animationPacks = {
    ["2017动画包"] = {
        idle = "rbxassetid://124622205682529",
        walk = "rbxassetid://99127941563341",
        run = "rbxassetid://99159420513149"
    },
    ["狗王🐶动画包"] = {
        idle = "rbxassetid://135419935358802",
        walk = "rbxassetid://95469909855529",
        run = "rbxassetid://109671225388655"
    },
    ["放松动画包"] = {
        idle = "rbxassetid://132811450080149",
        walk = "rbxassetid://90163253241107",
        run = "rbxassetid://96194626828153"
    },
    ["约翰.多动画包"] = {
        idle = "rbxassetid://105880087711722",
        walk = "rbxassetid://81193817424328",
        run = "rbxassetid://132653655520682"
    },
    ["约翰.多3月18日动作包"] = {
        idle = "rbxassetid://105880087711722",
        walk = "rbxassetid://88665566861294",
        run = "rbxassetid://88665566861294"
    },
    ["酷小孩动画包"] = {
        idle = "rbxassetid://18885903667",
        walk = "rbxassetid://18885906143",
        run = "rbxassetid://96571077893813"
    },
    ["里程四酷小孩动画包"] = {
        idle = "rbxassetid://136752484165169",
        walk = "rbxassetid://124582615971845",
        run = "rbxassetid://113259297401193"
    },
    ["诺利动画包"] = {
        idle = "rbxassetid://83465205704188",
        walk = "rbxassetid://116353529220765",
        run = "rbxassetid://117451341682452"
    },
    ["酷动画包"] = {
        idle = "rbxassetid://115268929362938",
        walk = "rbxassetid://123678890237669",
        run = "rbxassetid://132086389849889"
    },
    ["蓝小孩动画包"] = {
        idle = "rbxassetid://115268929362938",
        walk = "rbxassetid://18885906143",
        run = "rbxassetid://96571077893813"
    },
    ["蓝小孩（新）动画包"] = {
        idle = "rbxassetid://96013907659083",
        walk = "rbxassetid://111019416323211",
        run = "rbxassetid://101711406381367"
    },
    ["斩首者动画包"] = {
        idle = "rbxassetid://116050994905421",
        walk = "rbxassetid://93622022596108",
        run = "rbxassetid://93054787145505"
    },
    ["里程四斩首者动画包"] = {
        idle = "rbxassetid://111915677103210",
        walk = "rbxassetid://92337314320765",
        run = "rbxassetid://86125526846131"
    },
    ["追踪者动画包"] = {
        idle = "rbxassetid://94895464960972",
        walk = "rbxassetid://100206079439305",
        run = "rbxassetid://138660433982140"
    },
    ["黑手党动作包"] = {
        idle = "rbxassetid://96029349600709",
        walk = "rbxassetid://122086286372651",
        run = "rbxassetid://73833636394121"
    },
    ["旁白动画包"] = {
        idle = "rbxassetid://129891807903845",
        walk = "rbxassetid://114152086302685",
        run = "rbxassetid://97759042686395"
    },
    ["吸血鬼动画包"] = {
        idle = "rbxassetid://70639889347646",
        walk = "rbxassetid://125580704385106",
        run = "rbxassetid://82983377044738"
    },
    ["鬼畜动画包"] = {
        idle = "rbxassetid://138798332857092",
        walk = "rbxassetid://125121915550057",
        run = "rbxassetid://119868176210393"
    },
    ["电视时间动画包"] = {
        idle = "rbxassetid://85728609580979",
        walk = "rbxassetid://95769893872782",
        run = "rbxassetid://95769893872782"
    },
    ["1x1x1x1动画包"] = {
        idle = "rbxassetid://138754221537146",
        walk = "rbxassetid://109130982296927",
        run = "rbxassetid://106485518413331"
    },
    ["深渊之眼动画包"] = {
        idle = "rbxassetid://86304511408042",
        walk = "rbxassetid://92610215258030",
        run = "rbxassetid://129455514345450"
    },
    ["管理员动画包"] = {
        idle = "rbxassetid://119473916907837",
        walk = "rbxassetid://89706191899405",
        run = "rbxassetid://124250212996049"
    },
    ["烈焰石动画包"] = {
        idle = "rbxassetid://106883884364210",
        walk = "rbxassetid://131203472525014",
        run = "rbxassetid://93106765808091"
    },
    ["诺利动画包"] = {
        idle = "rbxassetid://83465205704188",
        walk = "rbxassetid://109700476007435",
        run = "rbxassetid://117451341682452"
    },
    ["杜塞卡尔动画包"] = {
        idle = "rbxassetid://107756518054855",
        walk = "rbxassetid://102812745115149",
        run = "rbxassetid://125869734469543"
    },
    ["桑乔动画包"] = {
        idle = "rbxassetid://134912704311964",
        walk = "rbxassetid://95213748170889",
        run = "rbxassetid://75409814098993"
    },
    ["苏库娜动画包"] = {
        idle = "rbxassetid://115268929362938",
        walk = "rbxassetid://123678890237669",
        run = "rbxassetid://132086389849889"
    },
    ["厄尔金动画包"] = {
        idle = "rbxassetid://93727662665079",
        walk = "rbxassetid://97625643261790",
        run = "rbxassetid://119357938208454"
    },
    ["魔术师动画包"] = {
        idle = "rbxassetid://88012681536088",
        walk = "rbxassetid://92645737884601",
        run = "rbxassetid://72285218671060"
    },
    ["白南瓜动画包"] = {
        idle = "rbxassetid://129258407299450",
        walk = "rbxassetid://120452519884275",
        run = "rbxassetid://73353742411211"
    },
    ["暴食动画包"] = {
        idle = "rbxassetid://137256991715697",
        walk = "rbxassetid://131591857576708",
        run = "rbxassetid://90961401774639"
    }
}

for packName, animData in pairs(animationPacks) do
    animationControllers[packName] = createAnimationController(
        animData.idle,
        animData.walk,
        animData.run,
        packName
    )

    animationTabSection:Toggle({
        Title = packName,
        Default = false,
        Icon = "person-standing",
        Callback = function(state)
            if state then
                animationControllers[packName]:start()
            else
                animationControllers[packName]:stop()
            end
        end
    })
end

local jeffController = {
    active = false,
    runningAnim = nil,
    idleAnim = nil,
    runningConnection = nil,
    characterConnection = nil
}

local function setupJeffAnimations(character)
    if not jeffController.active then return end

    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end

    if jeffController.runningAnim then
        jeffController.runningAnim:Stop()
    end
    if jeffController.idleAnim then
        jeffController.idleAnim:Stop()
    end

    local runningAnim = Instance.new("Animation")
    runningAnim.AnimationId = "rbxassetid://252557606"
    local idleAnim = Instance.new("Animation")
    idleAnim.AnimationId = "rbxassetid://124622205682529"

    jeffController.runningAnim = humanoid:LoadAnimation(runningAnim)
    jeffController.idleAnim = humanoid:LoadAnimation(idleAnim)

    if jeffController.runningConnection then
        jeffController.runningConnection:Disconnect()
    end

    jeffController.runningConnection = humanoid.Running:Connect(function(speed)
        if not jeffController.active then return end
        if speed > 0 then
            if jeffController.idleAnim and jeffController.idleAnim.IsPlaying then
                jeffController.idleAnim:Stop()
            end
            if jeffController.runningAnim and not jeffController.runningAnim.IsPlaying then
                jeffController.runningAnim.Looped = true
                jeffController.runningAnim:Play()
            end
        else
            if jeffController.runningAnim and jeffController.runningAnim.IsPlaying then
                jeffController.runningAnim:Stop()
            end
            if jeffController.idleAnim and not jeffController.idleAnim.IsPlaying then
                jeffController.idleAnim.Looped = true
                jeffController.idleAnim:Play()
            end
        end
    end)
end

animationTabSection:Toggle({
    Title = "Jeff the killer动画包",
    Default = false,
    Icon = "ghost",
    Callback = function(state)
        if state then
            jeffController.active = true

            local player = game.Players.LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()

            if jeffController.characterConnection then
                jeffController.characterConnection:Disconnect()
            end

            jeffController.characterConnection = player.CharacterAdded:Connect(function(newCharacter)
                if jeffController.active then
                    wait(1)
                    setupJeffAnimations(newCharacter)
                end
            end)

            setupJeffAnimations(character)
        else
            jeffController.active = false

            if jeffController.characterConnection then
                jeffController.characterConnection:Disconnect()
                jeffController.characterConnection = nil
            end

            if jeffController.runningConnection then
                jeffController.runningConnection:Disconnect()
                jeffController.runningConnection = nil
            end

            if jeffController.runningAnim then
                jeffController.runningAnim:Stop()
                jeffController.runningAnim = nil
            end

            if jeffController.idleAnim then
                jeffController.idleAnim:Stop()
                jeffController.idleAnim = nil
            end
        end
    end
})

local OtherTab = Window:Tab({
    Title = "其他动作", 
    Icon = "star" 
})

local otherSection = OtherTab:Section({
    Title = "非官方动作项目", 
    Opened = true 
})

otherSection:Toggle({
    Title = "Silly Billy",
    Default = false,
    Icon = "laugh",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local soundName = "Sound_SillyBilly"

        if state then
            local oldSound = rootPart:FindFirstChild(soundName)
            if oldSound then oldSound:Destroy() end

            humanoid.PlatformStand = true
            humanoid.JumpPower = 0

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://107464355830477"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()

            local sound = Instance.new("Sound")
            sound.Name = soundName
            sound.SoundId = "rbxassetid://77601084987544"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = false
            sound:Play()

            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end

                local s = rootPart:FindFirstChild(soundName)
                if s then
                    s:Stop()
                    s:Destroy()
                end

                for _, assetName in ipairs({ "EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand" }) do
                    local asset = char:FindFirstChild(assetName)
                    if asset then asset:Destroy() end
                end
            end)
        else
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0

            for _, assetName in ipairs({ "EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand" }) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end

            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end

            local sound = rootPart:FindFirstChild(soundName)
            if sound then
                sound:Stop()
                sound:Destroy()
            end

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://107464355830477" then
                    track:Stop()
                end
            end
        end
    end
})

otherSection:Toggle({
    Title = "Silly of it",
    Default = false,
    Icon = "laugh",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local soundName = "Sound_SillyOfIt"

        if state then
            local oldSound = rootPart:FindFirstChild(soundName)
            if oldSound then oldSound:Destroy() end

            humanoid.PlatformStand = true
            humanoid.JumpPower = 0

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://107464355830477"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()

            local sound = Instance.new("Sound")
            sound.Name = soundName
            sound.SoundId = "rbxassetid://120176009143091"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = false
            sound:Play()

            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end

                local s = rootPart:FindFirstChild(soundName)
                if s then
                    s:Stop()
                    s:Destroy()
                end

                for _, assetName in ipairs({ "EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand" }) do
                    local asset = char:FindFirstChild(assetName)
                    if asset then asset:Destroy() end
                end
            end)
        else
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0

            for _, assetName in ipairs({ "EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand" }) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end

            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end

            local sound = rootPart:FindFirstChild(soundName)
            if sound then
                sound:Stop()
                sound:Destroy()
            end

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://107464355830477" then
                    track:Stop()
                end
            end
        end
    end
})

otherSection:Toggle({
    Title = "Subterfuge",
    Default = false,
    Icon = "eye-off",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local soundName = "Sound_Subterfuge"

        if state then
            local oldSound = rootPart:FindFirstChild(soundName)
            if oldSound then oldSound:Destroy() end

            humanoid.PlatformStand = true
            humanoid.JumpPower = 0

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://87482480949358"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()

            local sound = Instance.new("Sound")
            sound.Name = soundName
            sound.SoundId = "rbxassetid://132297506693854"
            sound.Parent = rootPart
            sound.Volume = 2
            sound.Looped = false
            sound:Play()

            local args = {
                [1] = "PlayEmote",
                [2] = "Animations",
                [3] = "_Subterfuge"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end

                local s = rootPart:FindFirstChild(soundName)
                if s then
                    s:Stop()
                    s:Destroy()
                end
            end)
        else
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0

            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end

            local sound = rootPart:FindFirstChild(soundName)
            if sound then
                sound:Stop()
                sound:Destroy()
            end

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://87482480949358" then
                    track:Stop()
                end
            end
        end
    end
})

otherSection:Toggle({
    Title = "Aw Shucks",
    Default = false,
    Icon = "frown",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local soundName = "Sound_AwShucks"

        if state then
            local oldSound = rootPart:FindFirstChild(soundName)
            if oldSound then oldSound:Destroy() end

            humanoid.PlatformStand = true
            humanoid.JumpPower = 0

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://74238051754912"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()

            local sound = Instance.new("Sound")
            sound.Name = soundName
            sound.SoundId = "rbxassetid://123236721947419"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = false
            sound:Play()

            local args = {
                [1] = "PlayEmote",
                [2] = "Animations",
                [3] = "Shucks"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end

                local s = rootPart:FindFirstChild(soundName)
                if s then
                    s:Stop()
                    s:Destroy()
                end
            end)
        else
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0

            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end

            local sound = rootPart:FindFirstChild(soundName)
            if sound then
                sound:Stop()
                sound:Destroy()
            end

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://74238051754912" then
                    track:Stop()
                end
            end
        end
    end
})

otherSection:Toggle({
    Title = "Miss The Quiet",
    Default = false,
    Icon = "moon",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local soundName = "Sound_MissTheQuiet"

        if state then
            local oldSound = rootPart:FindFirstChild(soundName)
            if oldSound then oldSound:Destroy() end

            humanoid.PlatformStand = true
            humanoid.JumpPower = 0

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://100986631322204"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()

            local sound = Instance.new("Sound")
            sound.Name = soundName
            sound.SoundId = "rbxassetid://131936418953291"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = false
            sound:Play()

            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end

                local s = rootPart:FindFirstChild(soundName)
                if s then
                    s:Stop()
                    s:Destroy()
                end

                for _, assetName in ipairs({ "EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand" }) do
                    local asset = char:FindFirstChild(assetName)
                    if asset then asset:Destroy() end
                end
            end)
        else
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0

            for _, assetName in ipairs({ "EmoteHatAsset", "EmoteLighting", "PlayerEmoteHand" }) do
                local asset = char:FindFirstChild(assetName)
                if asset then asset:Destroy() end
            end

            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end

            local sound = rootPart:FindFirstChild(soundName)
            if sound then
                sound:Stop()
                sound:Destroy()
            end

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://100986631322204" then
                    track:Stop()
                end
            end
        end
    end
})

otherSection:Toggle({
    Title = "VIP (新音频)",
    Default = false,
    Icon = "crown",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local soundName = "Sound_VIPNew"

        if state then
            local oldSound = rootPart:FindFirstChild(soundName)
            if oldSound then oldSound:Destroy() end

            humanoid.PlatformStand = true
            humanoid.JumpPower = 0

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://138019937280193"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()

            local sound = Instance.new("Sound")
            sound.Name = soundName
            sound.SoundId = "rbxassetid://109474987384441"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = true
            sound:Play()

            local effect = game:GetService("ReplicatedStorage").Assets.Emotes.HakariDance.HakariBeamEffect:Clone()
            effect.Name = "PlayerEmoteVFX"
            effect.CFrame = char.PrimaryPart.CFrame * CFrame.new(0, -1, -0.3)
            effect.WeldConstraint.Part0 = char.PrimaryPart
            effect.WeldConstraint.Part1 = effect
            effect.Parent = char
            effect.CanCollide = false

            local args = {
                [1] = "PlayEmote",
                [2] = "Animations",
                [3] = "HakariDance"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end

                local s = rootPart:FindFirstChild(soundName)
                if s then
                    s:Stop()
                    s:Destroy()
                end
            end)
        else
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0

            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end

            local sound = rootPart:FindFirstChild(soundName)
            if sound then
                sound:Stop()
                sound:Destroy()
            end

            local effect = char:FindFirstChild("PlayerEmoteVFX")
            if effect then effect:Destroy() end

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://138019937280193" then
                    track:Stop()
                end
            end
        end
    end
})

otherSection:Toggle({
    Title = "VIP (旧音频)",
    Default = false,
    Icon = "crown",
    Callback = function(state)
        local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
        local humanoid = char:WaitForChild("Humanoid")
        local rootPart = char:WaitForChild("HumanoidRootPart")
        local soundName = "Sound_VIPOld"

        if state then
            local oldSound = rootPart:FindFirstChild(soundName)
            if oldSound then oldSound:Destroy() end

            humanoid.PlatformStand = true
            humanoid.JumpPower = 0

            local bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
            bodyVelocity.Velocity = Vector3.zero
            bodyVelocity.Parent = rootPart

            local animation = Instance.new("Animation")
            animation.AnimationId = "rbxassetid://138019937280193"
            local animationTrack = humanoid:LoadAnimation(animation)
            animationTrack:Play()

            local sound = Instance.new("Sound")
            sound.Name = soundName
            sound.SoundId = "rbxassetid://87166578676888"
            sound.Parent = rootPart
            sound.Volume = 0.5
            sound.Looped = true
            sound:Play()

            local effect = game:GetService("ReplicatedStorage").Assets.Emotes.HakariDance.HakariBeamEffect:Clone()
            effect.Name = "PlayerEmoteVFX"
            effect.CFrame = char.PrimaryPart.CFrame * CFrame.new(0, -1, -0.3)
            effect.WeldConstraint.Part0 = char.PrimaryPart
            effect.WeldConstraint.Part1 = effect
            effect.Parent = char
            effect.CanCollide = false

            local args = {
                [1] = "PlayEmote",
                [2] = "Animations",
                [3] = "HakariDance"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer(unpack(args))

            animationTrack.Stopped:Connect(function()
                humanoid.PlatformStand = false
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end

                local s = rootPart:FindFirstChild(soundName)
                if s then
                    s:Stop()
                    s:Destroy()
                end
            end)
        else
            humanoid.PlatformStand = false
            humanoid.JumpPower = 0

            local bodyVelocity = rootPart:FindFirstChildOfClass("BodyVelocity")
            if bodyVelocity then bodyVelocity:Destroy() end

            local sound = rootPart:FindFirstChild(soundName)
            if sound then
                sound:Stop()
                sound:Destroy()
            end

            local effect = char:FindFirstChild("PlayerEmoteVFX")
            if effect then effect:Destroy() end

            for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
                if track.Animation.AnimationId == "rbxassetid://138019937280193" then
                    track:Stop()
                end
            end
        end
    end
})

local wthTab = Window:Tab({
    Title = "滚球", 
    Icon = "circle" 
})

local wthSection = wthTab:Section({
    Title = "滚球控制", 
    Opened = true 
})

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = PlayersService.LocalPlayer
local speed = 30
local jumpHeight = 25
local distanceCheck = 0.3
local ballSize = 5

local tc = nil
local jumprqst = nil

local function disableHamsterBall()
    if tc then
        tc:Disconnect()
        tc = nil
    end
    if jumprqst then
        jumprqst:Disconnect()
        jumprqst = nil
    end

    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local rootPart = character.HumanoidRootPart
        rootPart.Anchored = false
        rootPart.CanCollide = true
        rootPart.Shape = Enum.PartType.Block
        if rootPart:FindFirstChild("OriginalSize") then
            rootPart.Size = rootPart.OriginalSize.Value
        end
        if character:FindFirstChild("Humanoid") then
            character.Humanoid.PlatformStand = false
            Camera.CameraSubject = character.Humanoid
        end
    end
    Workspace.Gravity = 100
end

local function enableHamsterBall()
    if tc ~= nil then
        return
    end

    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return
    end

    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    local rootPart = character.HumanoidRootPart
    rootPart.Shape = Enum.PartType.Ball
    rootPart.Size = Vector3.new(ballSize, ballSize, ballSize)
    if not rootPart:FindFirstChild("OriginalSize") then
        local origSize = Instance.new("Vector3Value")
        origSize.Name = "OriginalSize"
        origSize.Value = rootPart.Size
        origSize.Parent = rootPart
    end

    local humanoid = character:WaitForChild("Humanoid")
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = { character }

    tc = RunService.RenderStepped:Connect(function(deltaTime)
        rootPart.CanCollide = true
        humanoid.PlatformStand = true
        if not UserInputService:GetFocusedTextBox() then
            if UserInputService:IsKeyDown("W") then
                rootPart.RotVelocity = rootPart.RotVelocity - Camera.CFrame.RightVector * deltaTime * speed
            end
            if UserInputService:IsKeyDown("A") then
                rootPart.RotVelocity = rootPart.RotVelocity - Camera.CFrame.LookVector * deltaTime * speed
            end
            if UserInputService:IsKeyDown("S") then
                rootPart.RotVelocity = rootPart.RotVelocity + Camera.CFrame.RightVector * deltaTime * speed
            end
            if UserInputService:IsKeyDown("D") then
                rootPart.RotVelocity = rootPart.RotVelocity + Camera.CFrame.LookVector * deltaTime * speed
            end
        end
    end)

    jumprqst = UserInputService.JumpRequest:Connect(function()
        if Workspace:Raycast(rootPart.Position, Vector3.new(0, -(rootPart.Size.Y / 2 + distanceCheck), 0), raycastParams) then
            rootPart.Velocity = rootPart.Velocity + Vector3.new(0, jumpHeight, 0)
        end
    end)

    Camera.CameraSubject = rootPart

    humanoid.Died:Connect(function()
        disableHamsterBall()
    end)
end

local function brake()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Shape == Enum.PartType.Ball then
        character.HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
end

local function toggleFreeze()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Shape == Enum.PartType.Ball then
        local root = character.HumanoidRootPart
        root.Anchored = not root.Anchored
    end
end

wthSection:Button({
    Title = "启用",
    Icon = "play",
    Callback = function()
        enableHamsterBall()
    end
})

wthSection:Button({
    Title = "禁用",
    Icon = "square",
    Callback = function()
        disableHamsterBall()
    end
})

wthSection:Slider({
    Title = '球体大小',
    Value = {
        Min = 5,
        Max = 15,
        Default = 5,
    },
    Callback = function(value)
        ballSize = value
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") and character.HumanoidRootPart.Shape == Enum.PartType.Ball then
            character.HumanoidRootPart.Size = Vector3.new(ballSize, ballSize, ballSize)
        end
    end
})

wthSection:Button({
    Title = "刹车",
    Icon = "octagon",
    Callback = function()
        brake()
    end
})

wthSection:Button({
    Title = "冻结/解冻",
    Icon = "snowflake",
    Callback = function()
        toggleFreeze()
    end
})

wthSection:Slider({
    Title = '速度倍率',
    Value = {
        Min = 0,
        Max = 100,
        Default = 25,
    },
    Callback = function(value)
        speed = value
    end
})

wthSection:Slider({
    Title = '跳跃高度',
    Value = {
        Min = 0,
        Max = 100,
        Default = 25,
    },
    Callback = function(value)
        jumpHeight = value
    end
})

wthSection:Slider({
    Title = '环境重力',
    Value = {
        Min = 0,
        Max = 196,
        Default = 100,
    },
    Callback = function(value)
        Workspace.Gravity = value
    end
})

local kickTab = Window:Tab({
    Title = "另外", 
    Icon = "settings" 
})

local closeSection = kickTab:Section({
    Title = "UI 设置", 
    Opened = true 
})

closeSection:Button({
    Title = "滚出去（关闭 UI）",
    Icon = "x",
    Callback = function()
        pcall(function()
            Window:Destroy()
        end)
        pcall(function()
            if WindUI and WindUI.Close then WindUI:Close() end
        end)
    end
})