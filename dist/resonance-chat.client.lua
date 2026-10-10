-- === src/shared/constants.lua ===
-- ============================================================
-- Общие константы
-- ============================================================
return {
    VERSION = "1.0.0",
    NAME    = "Resonance Chat",
}

-- === src/shared/types.lua ===
-- ============================================================
-- Описание типов данных
-- ============================================================
-- Message = {
--     name    : string
--     text    : string
--     color   : Color3
--     time    : string
--     userId  : number?
--     system  : boolean?
-- }
return {}

-- === src/client/config.lua ===
-- ============================================================
-- Настройки клиента
-- ============================================================
return {
    PANEL_WIDTH        = 420,
    PANEL_HEIGHT       = 320,
    MARGIN             = 20,
    MAX_MESSAGES       = 30,
    RAINBOW_SPEED      = 0.5,
    PANEL_TRANSPARENCY = 0.35,
}

-- === src/client/theme.lua ===
-- ============================================================
-- Тема UI
-- ============================================================
return {
    Background         = Color3.fromRGB(20, 20, 30),
    Header             = Color3.fromRGB(0, 0, 0),
    InputBg            = Color3.fromRGB(30, 30, 45),
    Text               = Color3.fromRGB(240, 240, 250),
    TextDim            = Color3.fromRGB(140, 140, 160),
    CloseHover         = Color3.fromRGB(255, 80, 80),
    SendBg             = Color3.fromRGB(100, 100, 180),
    SendHover          = Color3.fromRGB(120, 120, 220),

    PanelTransparency  = 0.35,
    HeaderTransparency = 0.6,
    InputTransparency  = 0.4,

    CornerRadius       = 14,
    CornerSmall        = 8,
    HeaderHeight       = 36,
    InputHeight        = 36,

    Font               = Enum.Font.Gotham,
    FontBold           = Enum.Font.GothamBold,
    TitleSize          = 15,
    MessageSize        = 13,
    NameSize           = 12,

    OpenTime           = 0.25,
    CloseTime          = 0.2,
    HoverTime          = 0.15,
    EasingStyle        = Enum.EasingStyle.Quart,
    EasingDirection    = Enum.EasingDirection.Out,
}

-- === src/client/animations.lua ===
-- ============================================================
-- Tween-обёртки
-- ============================================================
local TweenService = game:GetService("TweenService")

local Anim = {}

function Anim.tween(obj, props, time, style, dir)
    local info = TweenInfo.new(
        time or 0.2,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

return Anim

-- === src/client/rainbow.lua ===
-- ============================================================
-- Глобальная радуга
-- ============================================================
local RunService = game:GetService("RunService")

local Rainbow = {}
Rainbow.hue = 0
Rainbow.speed = 0.5
Rainbow.targets = {}

local function step(dt)
    Rainbow.hue = (Rainbow.hue + dt * Rainbow.speed) % 1
    for _, t in pairs(Rainbow.targets) do
        if t.update then t:update(Rainbow.hue) end
    end
end

RunService.RenderStepped:Connect(step)

function Rainbow.register(target)
    table.insert(Rainbow.targets, target)
end

function Rainbow.getColor()
    return Color3.fromHSV(Rainbow.hue, 1, 1)
end

return Rainbow

-- === src/client/keybind.lua ===
-- ============================================================
-- Хоткей Y — открыть/закрыть чат
-- ============================================================
local UserInputService = game:GetService("UserInputService")

local Keybind = {}
local TOGGLE_KEY = Enum.KeyCode.Y

function Keybind.bind(callback)
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == TOGGLE_KEY then
            callback()
        end
    end)
end

function Keybind.setKey(key)
    TOGGLE_KEY = key
end

return Keybind

-- === src/client/ui/panel.lua ===
-- ============================================================
-- Resonance Chat — главная панель UI
-- ============================================================
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local CONFIG = require(script.Parent.Parent.config)
local Theme  = require(script.Parent.Parent.theme)

local LocalPlayer = Players.LocalPlayer

local Panel = {}
Panel.__index = Panel

-- ============================================================
-- СОЗДАНИЕ
-- ============================================================
function Panel.new(sendRemote)
    local self = setmetatable({}, Panel)
    self.sendRemote   = sendRemote
    self.isOpen       = false
    self.messageCount = 0
    self:_buildUI()
    self:_startRainbow()
    return self
end

-- ============================================================
-- ПОСТРОЕНИЕ UI
-- ============================================================
function Panel:_buildUI()
    -- ScreenGui
    local gui = Instance.new("ScreenGui")
    gui.Name = "ResonanceChat"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    self.gui = gui

    -- Главный фрейм
    local frame = Instance.new("Frame")
    frame.Name = "ChatPanel"
    frame.Size = UDim2.new(0, CONFIG.PANEL_WIDTH, 0, 0)
    frame.Position = UDim2.new(
        1, -CONFIG.PANEL_WIDTH - CONFIG.MARGIN,
        1, -CONFIG.PANEL_HEIGHT - CONFIG.MARGIN)
    frame.BackgroundColor3 = Theme.Background
    frame.BackgroundTransparency = Theme.PanelTransparency
    frame.BorderSizePixel = 0
    frame.Visible = false
    frame.Active = true
    frame.Draggable = true
    frame.Parent = gui
    self.frame = frame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, Theme.CornerRadius)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Transparency = 0.1
    stroke.Color = Color3.fromHSV(0, 1, 1)
    stroke.Parent = frame
    self.stroke = stroke

    local gradient = Instance.new("UIGradient")
    gradient.Rotation = 45
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0.0, 0.85),
        NumberSequenceKeypoint.new(0.5, 0.75),
        NumberSequenceKeypoint.new(1.0, 0.85),
    })
    gradient.Parent = frame
    self.gradient = gradient

    -- ЗАГОЛОВОК
    self:_buildHeader(frame)

    -- СПИСОК СООБЩЕНИЙ
    self:_buildMessageList(frame)

    -- ПОЛЕ ВВОДА
    self:_buildInput(frame)
end

function Panel:_buildHeader(parent)
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, Theme.HeaderHeight)
    header.BackgroundColor3 = Theme.Header
    header.BackgroundTransparency = Theme.HeaderTransparency
    header.BorderSizePixel = 0
    header.Parent = parent

    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, Theme.CornerRadius)
    hc.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.new(0, 38, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Resonance Chat"
    title.TextColor3 = Theme.Text
    title.TextSize = Theme.TitleSize
    title.Font = Theme.FontBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -36, 0.5, -15)
    closeBtn.BackgroundColor3 = Theme.InputBg
    closeBtn.BackgroundTransparency = 0.3
    closeBtn.Text = "x"
    closeBtn.TextColor3 = Theme.Text
    closeBtn.TextSize = 18
    closeBtn.Font = Theme.FontBold
    closeBtn.AutoButtonColor = false
    closeBtn.Parent = header

    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, Theme.CornerSmall)
    cc.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15),
            { BackgroundColor3 = Theme.CloseHover, BackgroundTransparency = 0 }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15),
            { BackgroundColor3 = Theme.InputBg, BackgroundTransparency = 0.3 }):Play()
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:setOpen(false)
    end)
end

function Panel:_buildMessageList(parent)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Messages"
    scroll.Size = UDim2.new(1, -12, 1, -Theme.HeaderHeight - Theme.InputHeight - 12)
    scroll.Position = UDim2.new(0, 6, 0, Theme.HeaderHeight + 6)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Theme.SendBg
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = parent
    self.scroll = scroll

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = scroll

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6)
    pad.PaddingLeft = UDim.new(0, 4)
    pad.PaddingRight = UDim.new(0, 4)
    pad.Parent = scroll
end

function Panel:_buildInput(parent)
    local inputFrame = Instance.new("Frame")
    inputFrame.Size = UDim2.new(1, -12, 0, Theme.InputHeight)
    inputFrame.Position = UDim2.new(0, 6, 1, -Theme.InputHeight - 6)
    inputFrame.BackgroundColor3 = Theme.InputBg
    inputFrame.BackgroundTransparency = Theme.InputTransparency
    inputFrame.BorderSizePixel = 0
    inputFrame.Parent = parent

    local ic = Instance.new("UICorner")
    ic.CornerRadius = UDim.new(0, Theme.CornerSmall)
    ic.Parent = inputFrame

    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -44, 1, 0)
    input.Position = UDim2.new(0, 10, 0, 0)
    input.BackgroundTransparency = 1
    input.Text = ""
    input.PlaceholderText = "Напиши сообщение..."
    input.PlaceholderColor3 = Theme.TextDim
    input.TextColor3 = Theme.Text
    input.TextSize = 14
    input.Font = Theme.Font
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.ClearTextOnFocus = false
    input.Parent = inputFrame
    self.input = input

    local sendBtn = Instance.new("TextButton")
    sendBtn.Size = UDim2.new(0, 30, 0, 30)
    sendBtn.Position = UDim2.new(1, -34, 0.5, -15)
    sendBtn.BackgroundColor3 = Theme.SendBg
    sendBtn.Text = ">"
    sendBtn.TextColor3 = Theme.Text
    sendBtn.TextSize = 16
    sendBtn.Font = Theme.FontBold
    sendBtn.AutoButtonColor = false
    sendBtn.Parent = inputFrame

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, Theme.CornerSmall)
    sc.Parent = sendBtn

    sendBtn.MouseEnter:Connect(function()
        TweenService:Create(sendBtn, TweenInfo.new(0.15),
            { BackgroundColor3 = Theme.SendHover }):Play()
    end)
    sendBtn.MouseLeave:Connect(function()
        TweenService:Create(sendBtn, TweenInfo.new(0.15),
            { BackgroundColor3 = Theme.SendBg }):Play()
    end)
    sendBtn.MouseButton1Click:Connect(function() self:_send() end)
    input.FocusLost:Connect(function(enter)
        if enter then self:_send() end
    end)
end

-- ============================================================
-- ОТПРАВКА
-- ============================================================
function Panel:_send()
    local text = self.input.Text
    if #text == 0 then return end
    self.sendRemote:FireServer(text)
    self.input.Text = ""
end

-- ============================================================
-- ДОБАВЛЕНИЕ СООБЩЕНИЯ
-- ============================================================
function Panel:addMessage(data)
    self.messageCount = self.messageCount + 1

    local row = Instance.new("Frame")
    row.Name = "Msg_" .. self.messageCount
    row.LayoutOrder = self.messageCount
    row.Size = UDim2.new(1, 0, 0, 0)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.BackgroundTransparency = 1
    row.Parent = self.scroll

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = row

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 16)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = (data.name or "?") .. "  [" .. (data.time or "") .. "]"
    nameLabel.TextColor3 = data.color or Theme.Text
    nameLabel.TextSize = Theme.NameSize
    nameLabel.Font = Theme.FontBold
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = row

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 0, 0)
    textLabel.AutomaticSize = Enum.AutomaticSize.Y
    textLabel.BackgroundTransparency = 1
    textLabel.Text = data.text or ""
    textLabel.TextColor3 = Theme.Text
    textLabel.TextSize = Theme.MessageSize
    textLabel.Font = Theme.Font
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.TextWrapped = true
    textLabel.TextYAlignment = Enum.TextYAlignment.Top
    textLabel.Parent = row

    -- Скролл вниз
    task.defer(function()
        self.scroll.CanvasPosition = Vector2.new(0, self.scroll.AbsoluteCanvasSize.Y)
    end)

    -- Убираем старые
    local msgs = {}
    for _, c in ipairs(self.scroll:GetChildren()) do
        if c:IsA("Frame") and c.Name:match("^Msg_") then
            table.insert(msgs, c)
        end
    end
    while #msgs > CONFIG.MAX_MESSAGES do
        local old = table.remove(msgs, 1)
        if old then old:Destroy() end
    end
end

-- ============================================================
-- ОТКРЫТИЕ / ЗАКРЫТИЕ
-- ============================================================
function Panel:setOpen(open)
    self.isOpen = open
    self.frame.Visible = true

    if open then
        TweenService:Create(self.frame,
            TweenInfo.new(Theme.OpenTime, Theme.EasingStyle, Theme.EasingDirection),
            { Size = UDim2.new(0, CONFIG.PANEL_WIDTH, 0, CONFIG.PANEL_HEIGHT) }):Play()
    else
        local t = TweenService:Create(self.frame,
            TweenInfo.new(Theme.CloseTime, Theme.EasingStyle, Theme.EasingDirection),
            { Size = UDim2.new(0, CONFIG.PANEL_WIDTH, 0, 0) })
        t:Play()
        t.Completed:Connect(function()
            if not self.isOpen then
                self.frame.Visible = false
            end
        end)
    end
end

function Panel:toggle()
    self:setOpen(not self.isOpen)
end

-- ============================================================
-- РАДУЖНАЯ АНИМАЦИЯ
-- ============================================================
function Panel:_startRainbow()
    local hue = 0
    local panel = self

    RunService.RenderStepped:Connect(function(dt)
        hue = (hue + dt * CONFIG.RAINBOW_SPEED) % 1

        -- Радужная обводка
        panel.stroke.Color = Color3.fromHSV(hue, 0.8, 1)

        -- Радужный градиент фона
        local c1 = Color3.fromHSV(hue, 0.6, 1)
        local c2 = Color3.fromHSV((hue + 0.25) % 1, 0.6, 1)
        local c3 = Color3.fromHSV((hue + 0.5) % 1, 0.6, 1)
        local c4 = Color3.fromHSV((hue + 0.75) % 1, 0.6, 1)

        panel.gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, c1),
            ColorSequenceKeypoint.new(0.33, c2),
            ColorSequenceKeypoint.new(0.66, c3),
            ColorSequenceKeypoint.new(1.00, c4),
        })
    end)
end

return Panel

-- === src/client/init.client.lua ===
-- ============================================================
-- Resonance Chat — Client Entry Point
-- ============================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Keybind = require(script.Parent.keybind)
local Panel   = require(script.Parent.ui.panel)

local sendRemote = ReplicatedStorage:WaitForChild("ResonanceChat_Send")
local msgRemote  = ReplicatedStorage:WaitForChild("ResonanceChat_Message")

-- Создаём UI
local ui = Panel.new(sendRemote)

-- Приём сообщений с сервера
msgRemote.OnClientEvent:Connect(function(data)
    if type(data) ~= "table" then return end
    ui:addMessage(data)
end)

-- Хоткей Y — открыть/закрыть
Keybind.bind(function()
    ui:toggle()
end)

-- Открываем при загрузке
ui:setOpen(true)

print("[Resonance Chat] Client loaded. Y — toggle")
