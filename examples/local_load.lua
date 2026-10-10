-- ============================================================
-- Resonance Chat — локальная загрузка (для теста в Studio)
-- ============================================================
-- Используй этот файл, если хочешь проверить клиент локально
-- без GitHub — просто скопируй содержимое dist/resonance-chat.client.lua
-- в LocalScript в StarterPlayerScripts.
--
-- Этот пример показывает как правильно требовать модули внутри Studio,
-- если ты НЕ используешь собранный dist.
-- ============================================================

-- ВАЖНО: этот код работает только внутри Roblox Studio
-- когда все модули лежат в правильной иерархии ModuleScript.

local StarterPlayer       = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

-- Структура должна быть:
-- StarterPlayerScripts
--   └── ChatClient (LocalScript)
--       ├── config (ModuleScript)
--       ├── theme (ModuleScript)
--       ├── animations (ModuleScript)
--       ├── rainbow (ModuleScript)
--       ├── keybind (ModuleScript)
--       └── ui (Folder)
--           └── panel (ModuleScript)

local Config   = require(script.config)
local Theme    = require(script.theme)
local Keybind  = require(script.keybind)
local Panel    = require(script.ui.panel)

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sendRemote = ReplicatedStorage:WaitForChild("ResonanceChat_Send")
local msgRemote  = ReplicatedStorage:WaitForChild("ResonanceChat_Message")

local ui = Panel.new(sendRemote)

msgRemote.OnClientEvent:Connect(function(data)
    if type(data) ~= "table" then return end
    ui:addMessage(data)
end)

Keybind.bind(function()
    ui:toggle()
end)

ui:setOpen(true)

print("[Resonance Chat] Client loaded (local)")