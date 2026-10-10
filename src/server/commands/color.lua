local Broadcast = require(script.Parent.Parent.broadcast)

return function(player, args)
    if #args == 0 then
        Broadcast.toPlayer(player, player, "Использование: /color <hex>", false)
        return
    end
    Broadcast.toPlayer(player, player, "Цвет установлен: " .. args, false)
end