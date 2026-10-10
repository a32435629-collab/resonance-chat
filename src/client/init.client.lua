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