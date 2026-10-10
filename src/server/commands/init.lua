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