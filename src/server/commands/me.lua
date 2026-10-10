local Broadcast = require(script.Parent.Parent.broadcast)

return function(player, args)
    if #args == 0 then
        Broadcast.toPlayer(player, player, "Использование: /me <действие>", false)
        return
    end
    Broadcast.toAll(player, "* " .. player.Name .. " " .. args)
end