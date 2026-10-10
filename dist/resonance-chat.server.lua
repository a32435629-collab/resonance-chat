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

-- === src/server/config.lua ===
-- ============================================================
-- Настройки сервера
-- ============================================================
return {
    MAX_MESSAGE_LENGTH = 200,
    COOLDOWN_SECONDS   = 0.5,
    MAX_HISTORY        = 50,

    FILTER_BADWORDS    = true,
    FILTER_LINKS       = false,

    SYSTEM_COLOR       = Color3.fromRGB(120, 220, 255),
    JOIN_COLOR         = Color3.fromRGB(80, 255, 120),
    LEAVE_COLOR        = Color3.fromRGB(255, 120, 120),
    ERROR_COLOR        = Color3.fromRGB(255, 200, 80),
}

-- === src/server/remotes.lua ===
-- ============================================================
-- Создание RemoteEvent
-- ============================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensure(name)
    local r = ReplicatedStorage:FindFirstChild(name)
    if not r then
        r = Instance.new("RemoteEvent")
        r.Name = name
        r.Parent = ReplicatedStorage
    end
    return r
end

return {
    send    = ensure("ResonanceChat_Send"),
    message = ensure("ResonanceChat_Message"),
}

-- === src/server/sanitizer.lua ===
-- ============================================================
-- Очистка текста + антиспам
-- ============================================================
local CONFIG = require(script.Parent.config)

local lastTime = {}
local Sanitizer = {}

function Sanitizer.checkCooldown(player)
    local now = tick()
    local last = lastTime[player] or 0
    if now - last < CONFIG.COOLDOWN_SECONDS then return false end
    lastTime[player] = now
    return true
end

function Sanitizer.clean(text)
    text = text:gsub("[%c]", "")
    if #text > CONFIG.MAX_MESSAGE_LENGTH then
        text = text:sub(1, CONFIG.MAX_MESSAGE_LENGTH) .. "..."
    end
    return text
end

function Sanitizer.clearPlayer(player)
    lastTime[player] = nil
end

return Sanitizer

-- === src/server/history.lua ===
-- ============================================================
-- История сообщений
-- ============================================================
local CONFIG  = require(script.Parent.config)
local Remotes = require(script.Parent.remotes)

local History = {}
local messages = {}

function History.push(msg)
    table.insert(messages, msg)
    if #messages > CONFIG.MAX_HISTORY then
        table.remove(messages, 1)
    end
end

function History.sendTo(player)
    for _, msg in ipairs(messages) do
        Remotes.message:FireClient(player, msg)
    end
end

function History.clear()
    messages = {}
end

function History.count()
    return #messages
end

return History

-- === src/server/broadcast.lua ===
-- ============================================================
-- Рассылка сообщений
-- ============================================================
local CONFIG  = require(script.Parent.config)
local Remotes = require(script.Parent.remotes)
local History = require(script.Parent.history)

local Broadcast = {}

-- Уникальный цвет ника по хешу имени
local function playerColor(player)
    local hash = 0
    for i = 1, #player.Name do
        hash = (hash + string.byte(player.Name, i) * i) % 360
    end
    return Color3.fromHSV(hash / 360, 0.7, 1)
end

local function timestamp()
    return os.date("%H:%M:%S")
end

-- Всем игрокам
function Broadcast.toAll(player, text)
    local msg = {
        name   = player.Name,
        text   = text,
        color  = playerColor(player),
        time   = timestamp(),
        userId = player.UserId,
    }
    History.push(msg)
    Remotes.message:FireAllClients(msg)
end

-- Одному игроку (личка)
function Broadcast.toPlayer(target, from, text, isWhisper)
    local msg = {
        name  = isWhisper and ("[PM] " .. from.Name) or from.Name,
        text  = text,
        color = playerColor(from),
        time  = timestamp(),
    }
    Remotes.message:FireClient(target, msg)
end

-- Системное сообщение
function Broadcast.system(text, color)
    local msg = {
        name   = "[SYSTEM]",
        text   = text,
        color  = color or CONFIG.SYSTEM_COLOR,
        time   = timestamp(),
        system = true,
    }
    History.push(msg)
    Remotes.message:FireAllClients(msg)
end

return Broadcast

-- === src/server/commands/init.lua ===
-- ============================================================
-- Парсер команд
-- ============================================================
local Commands = {}

local handlers = {
    help  = require(script.help),
    clear = require(script.clear),
    color = require(script.color),
    w     = require(script.whisper),
    me    = require(script.me),
}

function Commands.tryExecute(player, text)
    local cmd, args = text:match("^/(%w+)%s*(.*)$")
    if not cmd then return false end

    local handler = handlers[cmd:lower()]
    if handler then
        handler(player, args)
        return true
    end
    return false
end

return Commands

-- === src/server/commands/help.lua ===
local Broadcast = require(script.Parent.Parent.broadcast)

return function(player, _)
    Broadcast.system(
        "Команды: /help /clear /color <hex> /w <ник> <текст> /me <действие>"
    )
end

-- === src/server/commands/clear.lua ===
local History = require(script.Parent.Parent.history)

return function(player, _)
    History.clear()
end

-- === src/server/commands/color.lua ===
local Broadcast = require(script.Parent.Parent.broadcast)

return function(player, args)
    if #args == 0 then
        Broadcast.toPlayer(player, player, "Использование: /color <hex>", false)
        return
    end
    Broadcast.toPlayer(player, player, "Цвет установлен: " .. args, false)
end

-- === src/server/commands/whisper.lua ===
local Players   = game:GetService("Players")
local Broadcast = require(script.Parent.Parent.broadcast)

return function(player, args)
    local name, text = args:match("^(%S+)%s+(.+)$")
    if not name or not text then
        Broadcast.toPlayer(player, player, "Использование: /w <ник> <текст>", false)
        return
    end

    local target = Players:FindFirstChild(name)
    if target then
        Broadcast.toPlayer(target, player, text, true)
        Broadcast.toPlayer(player, player, "-> " .. target.Name .. ": " .. text, true)
    else
        Broadcast.toPlayer(player, player, "Игрок не найден: " .. name, false)
    end
end

-- === src/server/commands/me.lua ===
local Broadcast = require(script.Parent.Parent.broadcast)

return function(player, args)
    if #args == 0 then
        Broadcast.toPlayer(player, player, "Использование: /me <действие>", false)
        return
    end
    Broadcast.toAll(player, "* " .. player.Name .. " " .. args)
end

-- === src/server/filters/init.lua ===
-- ============================================================
-- Цепочка фильтров
-- ============================================================
local CONFIG = require(script.Parent.Parent.config)

local badwords = require(script.badwords)
local links    = require(script.links)

local Filters = {}

function Filters.apply(player, text)
    if CONFIG.FILTER_BADWORDS then
        text = badwords(text)
        if not text then return nil end
    end
    if CONFIG.FILTER_LINKS then
        text = links(text)
        if not text then return nil end
    end
    return text
end

return Filters

-- === src/server/filters/badwords.lua ===
-- ============================================================
-- Фильтр мата
-- ============================================================
local WORDS = {
    -- "мат1", "мат2"  -- замени на реальные
}

return function(text)
    for _, word in ipairs(WORDS) do
        text = text:gsub(word, string.rep("*", #word))
    end
    return text
end

-- === src/server/filters/links.lua ===
-- ============================================================
-- Фильтр ссылок
-- ============================================================
return function(text)
    if text:match("https?://") then
        return nil
    end
    return text
end

-- === src/server/init.server.lua ===
-- ============================================================
-- Resonance Chat — Server Entry Point
-- ============================================================
local Players = game:GetService("Players")

local Remotes   = require(script.Parent.remotes)
local Sanitizer = require(script.Parent.sanitizer)
local History   = require(script.Parent.history)
local Broadcast = require(script.Parent.broadcast)
local Commands  = require(script.Parent.commands)
local Filters   = require(script.Parent.filters)

-- Приём сообщений от клиентов
Remotes.send.OnServerEvent:Connect(function(player, text)
    if type(text) ~= "string" then return end
    if not Sanitizer.checkCooldown(player) then return end

    text = Sanitizer.clean(text)
    if #text == 0 then return end

    text = Filters.apply(player, text)
    if not text then return end

    if Commands.tryExecute(player, text) then return end

    Broadcast.toAll(player, text)
end)

-- Подключение игрока
Players.PlayerAdded:Connect(function(player)
    task.wait(3)
    History.sendTo(player)
    Broadcast.system(player.Name .. " подключился", Color3.fromRGB(80, 255, 120))
end)

-- Отключение игрока
Players.PlayerRemoving:Connect(function(player)
    Broadcast.system(player.Name .. " отключился", Color3.fromRGB(255, 120, 120))
    Sanitizer.clearPlayer(player)
end)

Broadcast.system("Resonance Chat v1.0", Color3.fromRGB(120, 220, 255))
print("[Resonance Chat] Server started")
