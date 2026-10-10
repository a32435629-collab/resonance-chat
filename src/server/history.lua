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