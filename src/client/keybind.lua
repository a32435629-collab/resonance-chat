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