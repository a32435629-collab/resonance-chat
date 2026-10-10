local Broadcast = require(script.Parent.Parent.broadcast)

return function(player, _)
    Broadcast.system(
        "Команды: /help /clear /color <hex> /w <ник> <текст> /me <действие>"
    )
end