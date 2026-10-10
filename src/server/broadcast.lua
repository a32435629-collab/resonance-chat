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