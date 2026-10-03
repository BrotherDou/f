local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

WindUI.TransparencyValue = 0.15

WindUI:AddTheme({
    Name = "CrimsonRed",
    Accent = "#1a0a0a",
    Dialog = "#1a0a0a",
    Outline = "#FF3B3B",
    Text = "#FFFFFF",
    Placeholder = "#000000",
    Background = "#0e0505",
    Button = "#5b1f1f",
    Icon = "#ff2d2d"
})

WindUI:SetTheme("CrimsonRed")

local Window = WindUI:CreateWindow({
    Title = "殺脚本┃皮肤管理",
    Icon = "crown",
    Author = "风御 X",
    Folder = "wind ui",
    Size = UDim2.fromOffset(550, 400),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Theme = "CrimsonRed",
    Background = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#1a0808"), Transparency = 0 },
        ["50"]  = { Color = Color3.fromHex("#3d0f0f"), Transparency = 0 },
        ["100"] = { Color = Color3.fromHex("#000000"), Transparency = 0 }
    }, { Rotation = 150 }),
    Transparent = true,
    HideSearchBar = true,
    SideBarWidth = 150,
    ScrollBarEnabled = true,
    CornerRadius = UDim.new(0, 14),
    DropShadow = true
})

Window:SetToggleKey(Enum.KeyCode.K)
WindUI:SetFont("rbxasset://fonts/families/AccanthisADFStd.json")

Window:EditOpenButton({
    Title = "皮肤",
    Icon = "crown",
    CornerRadius = UDim.new(0, 16),
    StrokeThickness = 2,
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
    Active = true,
    Color = ColorSequence.new(
        Color3.fromRGB(255, 60, 60),
        Color3.fromRGB(255, 200, 200)
    )
})

local function isValidAnimationId(id)
    local num = tostring(id):match("%d+")
    if not num then return false end
    if tostring(id) ~= num then return false end
    if #num < 6 then return false end
    return true
end

local function setAnimationId(anim, value)
    pcall(function()
        anim.AnimationId = value
    end)
end

local function sanitizeAnimation(anim)
    if not anim or not anim:IsA("Animation") then return end

    local ok, rawId = pcall(function()
        return anim.AnimationId
    end)
    if not ok then return end

    local id = tostring(rawId):match("%d+")
    if not id or not isValidAnimationId(id) then
        setAnimationId(anim, "")
    else
        setAnimationId(anim, "rbxassetid://" .. id)
    end
end

game.DescendantAdded:Connect(function(obj)
    if obj:IsA("Animation") then
        sanitizeAnimation(obj)
    end
end)

for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("Animation") then
        sanitizeAnimation(v)
    end
end

local slaTab = Window:Tab({ Title = "斩首者",     Icon = "skull" })
local johTab = Window:Tab({ Title = "约翰.多",    Icon = "user" })
local cooTab = Window:Tab({ Title = "酷小孩",     Icon = "smile" })
local lXlTab = Window:Tab({ Title = "1X1X1X1",    Icon = "shield" })
local sheTab = Window:Tab({ Title = "谢德莱茨基", Icon = "heart-crack" })
local chaTab = Window:Tab({ Title = "机会",       Icon = "dice-5" })
local twoTab = Window:Tab({ Title = "两次",       Icon = "users" })

local slaSection = slaTab:Section({
    Title = "斩首者皮肤列表",
    Opened = true
})

slaSection:Button({
    Title = "恶魔化",
    Icon = "flame",
    Callback = function()
        _G.SkinEnabled = false
        if _G.SkinConnections then
            for _, c in ipairs(_G.SkinConnections) do
                c:Disconnect()
            end
            _G.SkinConnections = {}
        end
        if _G.SkinHornObjects then
            for _, v in ipairs(_G.SkinHornObjects) do
                if v then v:Destroy() end
            end
            _G.SkinHornObjects = {}
        end
        for _, name in ipairs({"OrbitKatana", "DarkHalo", "DemonHorn"}) do
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj.Name == name then
                    obj:Destroy()
                end
            end
        end
        if _G.SkinAuraConnection then
            _G.SkinAuraConnection:Disconnect()
            _G.SkinAuraConnection = nil
        end
        if _G.SkinAuraHolder then
            _G.SkinAuraHolder:Destroy()
            _G.SkinAuraHolder = nil
        end

        _G.SkinEnabled = true
        _G.SkinConnections = _G.SkinConnections or {}
        _G.SkinHornObjects = _G.SkinHornObjects or {}

        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local plr = Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()
        local hum = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")
        local head = char:WaitForChild("Head")

        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") then
                v:Destroy()
            end
        end

        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(15, 15, 15)
                v.Material = Enum.Material.SmoothPlastic
            end
        end

        hum.Died:Connect(function()
            _G.SkinEnabled = false
            if _G.SkinConnections then
                for _, c in ipairs(_G.SkinConnections) do
                    c:Disconnect()
                end
                _G.SkinConnections = {}
            end
            if _G.SkinHornObjects then
                for _, v in ipairs(_G.SkinHornObjects) do
                    if v then v:Destroy() end
                end
                _G.SkinHornObjects = {}
            end
            for _, name in ipairs({"OrbitKatana", "DarkHalo", "DemonHorn"}) do
                for _, obj in ipairs(workspace:GetChildren()) do
                    if obj.Name == name then
                        obj:Destroy()
                    end
                end
            end
            if _G.SkinAuraConnection then
                _G.SkinAuraConnection:Disconnect()
                _G.SkinAuraConnection = nil
            end
            if _G.SkinAuraHolder then
                _G.SkinAuraHolder:Destroy()
                _G.SkinAuraHolder = nil
            end
        end)

        local halo = Instance.new("Part")
        halo.Name = "DarkHalo"
        halo.Size = Vector3.new(1, 1, 1)
        halo.Material = Enum.Material.Neon
        halo.Color = Color3.fromRGB(255, 0, 0)
        halo.Anchored = true
        halo.CanCollide = false
        halo.CanTouch = false
        halo.CanQuery = false
        halo.Parent = workspace

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://3270017"
        mesh.Scale = Vector3.new(1.5, 1.5, 0.08)
        mesh.Parent = halo

        local haloSmoke = Instance.new("ParticleEmitter")
        haloSmoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
        haloSmoke.Rate = 8
        haloSmoke.Lifetime = NumberRange.new(0.5, 1)
        haloSmoke.Speed = NumberRange.new(0, 0.3)
        haloSmoke.Parent = halo

        task.spawn(function()
            while halo.Parent and root.Parent and _G.SkinEnabled do
                local pulse = (math.sin(tick() * 4) + 1) / 2
                halo.Color = Color3.fromRGB(55 + (200 * pulse), 0, 0)
                halo.CFrame = CFrame.new(root.Position + Vector3.new(0, 3.2, 0)) * CFrame.Angles(math.rad(90), 0, tick() * 3)
                task.wait()
            end
            if halo then halo:Destroy() end
        end)

        local function CreateHorn(side)
            local horn = Instance.new("Part")
            horn.Name = "DemonHorn"
            horn.Size = Vector3.new(0.15, 1.8, 0.15)
            horn.Material = Enum.Material.Neon
            horn.Color = Color3.fromRGB(255, 0, 0)
            horn.Anchored = true
            horn.CanCollide = false
            horn.CanTouch = false
            horn.CanQuery = false
            horn.Parent = workspace

            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            mesh.MeshId = "rbxassetid://1033714"
            mesh.Scale = Vector3.new(0.25, 1.8, 0.25)
            mesh.Parent = horn

            local smoke = Instance.new("ParticleEmitter")
            smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
            smoke.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
            smoke.Rate = 25
            smoke.Speed = NumberRange.new(0.5, 1.5)
            smoke.Lifetime = NumberRange.new(1, 2)
            smoke.Size = NumberSequence.new{
                NumberSequenceKeypoint.new(0, 0.4),
                NumberSequenceKeypoint.new(1, 0)
            }
            smoke.Parent = horn

            local lightning = Instance.new("ParticleEmitter")
            lightning.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
            lightning.LightEmission = 1
            lightning.Rate = 40
            lightning.Speed = NumberRange.new(2, 5)
            lightning.Lifetime = NumberRange.new(0.1, 0.3)
            lightning.Size = NumberSequence.new(0.15)
            lightning.Parent = horn

            table.insert(_G.SkinHornObjects, horn)

            local offset
            if side == "Left" then
                offset = CFrame.new(-0.35, 0.45, -0.05) * CFrame.Angles(math.rad(-15), 0, math.rad(45))
            else
                offset = CFrame.new(0.35, 0.45, -0.05) * CFrame.Angles(math.rad(-15), 0, math.rad(-45))
            end

            local conn = RunService.Heartbeat:Connect(function()
                if not _G.SkinEnabled then return end
                if head.Parent and horn.Parent then
                    local pulse = (math.sin(tick() * 4) + 1) / 2
                    horn.Color = Color3.fromRGB(55 + (200 * pulse), 0, 0)
                    horn.CFrame = head.CFrame * offset
                end
            end)
            table.insert(_G.SkinConnections, conn)
        end

        CreateHorn("Left")
        CreateHorn("Right")

        for i = 1, 6 do
            local model = Instance.new("Model")
            model.Name = "OrbitKatana"
            model.Parent = workspace

            local blade = Instance.new("Part")
            blade.Size = Vector3.new(0.15, 4, 0.35)
            blade.Material = Enum.Material.Neon
            blade.Color = Color3.fromRGB(255, 0, 0)
            blade.Anchored = true
            blade.CanCollide = false
            blade.Parent = model

            local att0 = Instance.new("Attachment")
            att0.Position = Vector3.new(0, -1.95, 0)
            att0.Parent = blade

            local att1 = Instance.new("Attachment")
            att1.Position = Vector3.new(0, 1.95, 0)
            att1.Parent = blade

            local trail = Instance.new("Trail")
            trail.Attachment0 = att0
            trail.Attachment1 = att1
            trail.Lifetime = 0.05
            trail.MinLength = 0.001
            trail.FaceCamera = false
            trail.Parent = blade
            trail.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 0))
            })

            local smoke = Instance.new("ParticleEmitter")
            smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
            smoke.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0))
            smoke.Rate = 10
            smoke.Lifetime = NumberRange.new(0.5, 1)
            smoke.Speed = NumberRange.new(0, 1)
            smoke.Parent = blade

            local handle = Instance.new("Part")
            handle.Size = Vector3.new(0.25, 1, 0.25)
            handle.Material = Enum.Material.SmoothPlastic
            handle.Color = Color3.fromRGB(15, 15, 15)
            handle.Anchored = true
            handle.CanCollide = false
            handle.Parent = model

            local guard = Instance.new("Part")
            guard.Size = Vector3.new(1, 0.15, 0.15)
            guard.Material = Enum.Material.Neon
            guard.Color = Color3.fromRGB(120, 0, 0)
            guard.Anchored = true
            guard.CanCollide = false
            guard.Parent = model

            task.spawn(function()
                while model.Parent and root.Parent and _G.SkinEnabled do
                    local t = tick() * 1.8
                    local angle = math.rad((i - 1) * 60) + t
                    local radius = 5
                    local pos = root.Position + Vector3.new(math.cos(angle) * radius, 2, math.sin(angle) * radius)
                    local pulse = (math.sin(tick() * 5) + 1) / 2
                    blade.Color = Color3.fromRGB(55 + (200 * pulse), 0, 0)
                    guard.Color = blade.Color
                    local cf = CFrame.new(pos) * CFrame.Angles(0, angle, math.rad(180))
                    blade.CFrame = cf
                    handle.CFrame = cf * CFrame.new(0, 2.5, 0)
                    guard.CFrame = cf * CFrame.new(0, 2, 0)
                    task.wait()
                end
                if model then model:Destroy() end
            end)
        end

        local auraTexts = {
            "must kill",
            "kill all",
            "fool",
            "1x1x1x1",
            "haha",
            "idiot",
            "i will kill you",
            "you will die"
        }

        local auraConnection = nil
        local auraHolder = nil
        local auraAlive = false

        local function splitText(text)
            if math.random() < 0.35 then
                local mid = math.floor(#text / 2)
                return text:sub(1, mid) .. " " .. text:sub(mid + 1)
            end
            return text
        end

        local function stopAura()
            auraAlive = false
            if auraConnection then
                auraConnection:Disconnect()
                auraConnection = nil
            end
            if auraHolder then
                auraHolder:Destroy()
                auraHolder = nil
            end
        end

        local function startAura(character)
            if not _G.SkinEnabled then return end
            stopAura()
            auraAlive = true

            local hrp = character:WaitForChild("HumanoidRootPart")
            local humanoid = character:WaitForChild("Humanoid")

            auraHolder = Instance.new("Part")
            auraHolder.Size = Vector3.new(1, 1, 1)
            auraHolder.Anchored = true
            auraHolder.CanCollide = false
            auraHolder.Transparency = 1
            auraHolder.Parent = character

            local labels = {}
            for i = 1, 2 do
                local gui = Instance.new("BillboardGui")
                gui.Size = UDim2.new(0, 100, 0, 35)
                gui.AlwaysOnTop = true
                gui.Parent = auraHolder

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextScaled = true
                label.Font = Enum.Font.Arcade
                label.TextSize = 70
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
                label.TextStrokeTransparency = 0.3
                label.Parent = gui
                table.insert(labels, label)
            end

            local index1, index2 = 1, 2
            local lastSwitch = 0

            humanoid.Died:Connect(function()
                stopAura()
            end)

            auraConnection = RunService.RenderStepped:Connect(function()
                if not auraAlive then return end
                if not hrp or not hrp.Parent then return end

                local t = tick()
                local angle = t * 2
                auraHolder.Position = hrp.Position + Vector3.new(math.cos(angle) * 3, 2 + math.sin(t * 3) * 0.6, math.sin(angle) * 3)

                if t - lastSwitch > math.random(3, 6) / 10 then
                    lastSwitch = t
                    index1 = math.random(1, #auraTexts)
                    index2 = math.random(1, #auraTexts)
                end

                local function getText(i)
                    local txt = auraTexts[i]
                    if math.random() < 0.35 then
                        local mid = math.floor(#txt / 2)
                        return txt:sub(1, mid) .. " " .. txt:sub(mid + 1)
                    end
                    return txt
                end

                local jitter = Vector3.new((math.random() - 0.5) * 0.9, (math.random() - 0.5) * 0.9, (math.random() - 0.5) * 0.9)
                auraHolder.Position = auraHolder.Position + jitter

                labels[1].Text = getText(index1)
                labels[2].Text = getText(index2)

                for _, l in ipairs(labels) do
                    l.Rotation = math.random(-30, 30)
                    l.TextTransparency = (math.random() < 0.2) and 1 or 0
                end

                local c = (math.random() < 0.5) and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 0, 0)
                labels[1].TextColor3 = c
                labels[2].TextColor3 = c
            end)
        end

        if char then
            startAura(char)
        end

        _G.SkinAuraConnection = auraConnection
        _G.SkinAuraHolder = auraHolder
    end
})

slaSection:Button({
    Title = "Titan TV Man皮肤",
    Icon = "tv",
    Callback = function()
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")

        local plr = Players.LocalPlayer
        local char = plr.Character or plr.CharacterAdded:Wait()

        task.wait(1)

        char = plr.Character or plr.CharacterAdded:Wait()

        local hum = char:WaitForChild("Humanoid")
        local root = char:WaitForChild("HumanoidRootPart")
        local head = char:WaitForChild("Head")

        pcall(function()
            hum.PlatformStand = false
            hum.AutoRotate = true
            hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
            hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
        end)
        root.AssemblyAngularVelocity = Vector3.zero

        local TV_SIZE = Vector3.new(1.8, 1.7, 1.7)

        for _, v in pairs(char:GetChildren()) do
            if v:IsA("Accessory") then
                v:Destroy()
            end
        end

        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Color = Color3.fromRGB(10, 10, 10)
                v.Material = Enum.Material.SmoothPlastic
                v.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0, 0, 0, 0)
            end
        end

        local function weldPart(part, parentPart, cf)
            part.Anchored = false
            part.CanCollide = false
            part.Massless = true
            part.CFrame = parentPart.CFrame * cf
            local weld = Instance.new("Motor6D")
            weld.Part0 = parentPart
            weld.Part1 = part
            weld.C0 = cf
            weld.Parent = parentPart
            return weld
        end

        for _, v in pairs(head:GetChildren()) do
            if v:IsA("Decal") then
                v:Destroy()
            end
        end

        local face = Instance.new("Decal")
        face.Name = "face"
        face.Texture = "rbxassetid://7074764"
        face.Face = Enum.NormalId.Front
        face.Parent = head

        head.Transparency = 1

        local tv = Instance.new("Part")
        tv.Name = "TitanTV"
        tv.Size = TV_SIZE
        tv.Color = Color3.fromRGB(20, 20, 20)
        tv.Material = Enum.Material.Metal
        tv.Parent = char
        weldPart(tv, head, CFrame.new(0, 0, 0))

        local screen = Instance.new("Part")
        screen.Name = "Screen"
        screen.Size = Vector3.new(1.45, 1.2, 0.05)
        screen.Material = Enum.Material.Neon
        screen.Color = Color3.fromRGB(255, 0, 0)
        screen.Parent = char
        weldPart(screen, tv, CFrame.new(0, 0, -0.9))

        local gui = Instance.new("SurfaceGui")
        gui.Face = Enum.NormalId.Front
        gui.AlwaysOnTop = true
        gui.Adornee = screen
        gui.Parent = screen

        local img = Instance.new("ImageLabel")
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://7074764"
        img.Parent = gui

        task.spawn(function()
            while task.wait(0.15) do
                if screen and screen.Parent then
                    screen.Color = Color3.fromRGB(
                        math.random(150, 255),
                        0,
                        math.random(0, 120)
                    )
                end
            end
        end)

        local aura = Instance.new("ParticleEmitter")
        aura.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        aura.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 0, 255))
        })
        aura.LightEmission = 1
        aura.Rate = 60
        aura.Speed = NumberRange.new(2, 5)
        aura.Lifetime = NumberRange.new(0.5, 1.5)
        aura.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1.5),
            NumberSequenceKeypoint.new(1, 0)
        })
        aura.Parent = root

        local smoke = Instance.new("ParticleEmitter")
        smoke.Texture = "rbxasset://textures/particles/smoke_main.dds"
        smoke.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 0, 0))
        })
        smoke.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 1)
        })
        smoke.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 2),
            NumberSequenceKeypoint.new(1, 5)
        })
        smoke.Lifetime = NumberRange.new(1.5, 3)
        smoke.Rate = 20
        smoke.Speed = NumberRange.new(1, 2)
        smoke.Rotation = NumberRange.new(0, 360)
        smoke.RotSpeed = NumberRange.new(-20, 20)
        smoke.SpreadAngle = Vector2.new(180, 180)
        smoke.Parent = root

        local tvElectric = Instance.new("ParticleEmitter")
        tvElectric.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        tvElectric.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 120, 120))
        })
        tvElectric.LightEmission = 1
        tvElectric.Rate = 80
        tvElectric.Speed = NumberRange.new(3, 6)
        tvElectric.Lifetime = NumberRange.new(0.2, 0.5)
        tvElectric.Size = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 0)
        })
        tvElectric.SpreadAngle = Vector2.new(360, 360)
        tvElectric.Parent = tv

        local a0 = Instance.new("Attachment")
        a0.Position = Vector3.new(0, 1, 0)
        a0.Parent = root

        local a1 = Instance.new("Attachment")
        a1.Position = Vector3.new(0, -1, 0)
        a1.Parent = root

        local trail = Instance.new("Trail")
        trail.Attachment0 = a0
        trail.Attachment1 = a1
        trail.Lifetime = 0.2
        trail.MinLength = 0.1
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        trail.Parent = root

        hum.WalkSpeed = 16
        hum.JumpPower = 50

        RunService.Heartbeat:Connect(function()
            root.AssemblyAngularVelocity = Vector3.zero
            if hum.MoveDirection.Magnitude > 0 then
                local moveDir = hum.MoveDirection.Unit
                root.AssemblyLinearVelocity = Vector3.new(
                    moveDir.X * hum.WalkSpeed,
                    root.AssemblyLinearVelocity.Y,
                    moveDir.Z * hum.WalkSpeed
                )
            else
                root.AssemblyLinearVelocity = Vector3.new(
                    0,
                    root.AssemblyLinearVelocity.Y,
                    0
                )
            end
            if hum.Health <= hum.MaxHealth * 0.35 then
                if screen then
                    screen.Color = Color3.fromRGB(255, 0, 0)
                end
                aura.Rate = 120
                hum.WalkSpeed = 18
            else
                hum.WalkSpeed = 16
            end
        end)

        print("Titan TV Man BLACK SMOKE Loaded")

        local char2 = plr.Character or plr.CharacterAdded:Wait()
        local root2 = char2:WaitForChild("HumanoidRootPart")
        local swordCount = 6
        local spacing = 1.3
        local offsetBack = 6
        local offsetHeight = 1.8
        local smooth = 0.15
        local pulseSpeed = 2
        local pulseMin = 1.5
        local pulseMax = 2.8
        local swords = {}

        local function createKatana()
            local model = Instance.new("Model")
            local blade = Instance.new("Part")
            blade.Size = Vector3.new(0.2, 0.4, 4)
            blade.Material = Enum.Material.Neon
            blade.Color = Color3.fromRGB(255, 0, 0)
            blade.Anchored = true
            blade.CanCollide = false
            blade.Parent = model

            local tip = Instance.new("Part")
            tip.Size = Vector3.new(0.2, 0.4, 0.8)
            tip.Material = Enum.Material.Neon
            tip.Color = Color3.fromRGB(255, 0, 0)
            tip.Anchored = true
            tip.CanCollide = false
            tip.Parent = model

            local guard = Instance.new("Part")
            guard.Size = Vector3.new(0.8, 0.2, 0.8)
            guard.Material = Enum.Material.Metal
            guard.Color = Color3.fromRGB(80, 0, 0)
            guard.Anchored = true
            guard.CanCollide = false
            guard.Parent = model

            local handle = Instance.new("Part")
            handle.Size = Vector3.new(0.3, 0.3, 1.2)
            handle.Material = Enum.Material.SmoothPlastic
            handle.Color = Color3.fromRGB(30, 0, 0)
            handle.Anchored = true
            handle.CanCollide = false
            handle.Parent = model

            local att0 = Instance.new("Attachment", blade)
            att0.Position = Vector3.new(0, 0, blade.Size.Z / 2)
            local att1 = Instance.new("Attachment", blade)
            att1.Position = Vector3.new(0, 0, -blade.Size.Z / 2)
            local trail = Instance.new("Trail")
            trail.Attachment0 = att0
            trail.Attachment1 = att1
            trail.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
            trail.Lifetime = 0.25
            trail.Parent = blade

            model.Parent = workspace
            return model, blade, tip, guard, handle
        end

        for i = 1, swordCount do
            local m, b, t, g, h = createKatana()
            table.insert(swords, { model = m, blade = b, tip = t, guard = g, handle = h })
        end

        local aura2 = Instance.new("ParticleEmitter")
        aura2.Color = ColorSequence.new(Color3.fromRGB(255, 0, 0))
        aura2.LightEmission = 1
        aura2.Rate = 80
        aura2.Speed = NumberRange.new(0)
        aura2.Transparency = NumberSequence.new{
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1)
        }
        aura2.Parent = root2

        RunService.RenderStepped:Connect(function()
            local time = tick()
            local pulse = (math.sin(time * pulseSpeed) + 1) / 2
            local sizeValue = pulseMin + (pulseMax - pulseMin) * pulse
            aura2.Size = NumberSequence.new{
                NumberSequenceKeypoint.new(0, sizeValue),
                NumberSequenceKeypoint.new(1, 0)
            }

            for i, data in ipairs(swords) do
                local blade = data.blade
                local tip = data.tip
                local guard = data.guard
                local handle = data.handle

                local xOffset = (i - (swordCount + 1) / 2) * spacing
                local pos = root2.Position
                    + root2.CFrame.RightVector * xOffset
                    - root2.CFrame.LookVector * offsetBack
                    + Vector3.new(0, offsetHeight, 0)

                local baseCF = CFrame.lookAt(
                    pos,
                    pos - root2.CFrame.LookVector,
                    root2.CFrame.UpVector
                )

                local velocityY = root2.Velocity.Y
                local tilt = 0
                local currentSmooth = smooth

                if velocityY > 1 then
                    tilt = math.rad(45)
                elseif velocityY < -2 then
                    tilt = math.rad(-60 - math.clamp(-velocityY * 2, 0, 30))
                    currentSmooth = 0.08
                else
                    local sway = math.sin(time * 2 + i * 0.5) * math.rad(15)
                    local shakeX = math.sin(time * 20 + i) * 0.08
                    local shakeY = math.cos(time * 18 + i) * 0.08
                    tilt = sway
                    baseCF = baseCF * CFrame.new(shakeX, shakeY, 0)
                end

                local finalCF = baseCF * CFrame.Angles(tilt, 0, 0)
                local scale = 1 + pulse * 0.15
                blade.Size = Vector3.new(0.2, 0.4, 4 * scale)

                blade.CFrame = blade.CFrame:Lerp(finalCF, currentSmooth)
                tip.CFrame = tip.CFrame:Lerp(
                    finalCF * CFrame.new(0, 0, -(blade.Size.Z / 2 + tip.Size.Z / 2)),
                    currentSmooth
                )
                guard.CFrame = guard.CFrame:Lerp(
                    finalCF * CFrame.new(0, 0, (blade.Size.Z / 2 + guard.Size.Z / 2)),
                    currentSmooth
                )
                handle.CFrame = handle.CFrame:Lerp(
                    finalCF * CFrame.new(0, 0, (blade.Size.Z / 2 + guard.Size.Z + handle.Size.Z / 2)),
                    currentSmooth
                )
            end
        end)
    end
})

slaSection:Button({
    Title = "几何体皮肤",
    Icon = "shapes",
    Callback = function()
        loadstring(game:HttpGet("https://encrypt-x.pages.dev/Scripts?Id=8726057978642"))("8726057978642")
    end
})

slaSection:Button({
    Title = "Mystic 管理员皮肤",
    Icon = "wand-sparkles",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/Myst"))()
    end
})

slaSection:Button({
    Title = "Sancho 管理员皮肤",
    Icon = "shield-check",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/San"))()
    end
})

slaSection:Button({
    Title = "Noli",
    Icon = "user-round",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/Noli"))()
    end
})

slaSection:Button({
    Title = "访客 666",
    Icon = "ghost",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/G666"))()
    end
})

local johSection = johTab:Section({
    Title = "约翰.多皮肤列表",
    Opened = true
})

johSection:Button({
    Title = "歼灭",
    Icon = "sword",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/Annihilation"))()
    end
})

johSection:Button({
    Title = "圆规小姐",
    Icon = "compass",
    Callback = function()
        loadstring(game:HttpGet("https://protected-roblox-scripts.onrender.com/2eb46abf5cea8f923296a7f4b27fa868"))()
    end
})

local cooSection = cooTab:Section({
    Title = "酷小孩皮肤列表",
    Opened = true
})

cooSection:Button({
    Title = "2011 X",
    Icon = "user",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/2011x"))()
    end
})

local lXlSection = lXlTab:Section({
    Title = "1X1X1X1皮肤列表",
    Opened = true
})

lXlSection:Button({
    Title = "Gabriel",
    Icon = "swords",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/Gabriel"))()
    end
})

local sheSection = sheTab:Section({
    Title = "谢德莱茨基皮肤列表",
    Opened = true
})

sheSection:Button({
    Title = "心碎之人",
    Icon = "heart-crack",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/HeartBroken%20Boohoo"))()
    end
})

local chaSection = chaTab:Section({
    Title = "机会皮肤列表",
    Opened = true
})

chaSection:Button({
    Title = "lsaac",
    Icon = "dice-5",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/heC1USQ1"))()
    end
})

local twoSection = twoTab:Section({
    Title = "两次皮肤列表",
    Opened = true
})

twoSection:Button({
    Title = "小宝宝",
    Icon = "baby",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ElderRealNofake/Forsaken-Skin-Vroom/refs/heads/main/BTT"))()
    end
})

game:GetObjects("rbxassetid://115662197522885")[1].Parent = game.ReplicatedStorage