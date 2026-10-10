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