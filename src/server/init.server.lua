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