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