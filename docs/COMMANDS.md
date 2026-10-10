
Команды
Все команды пишутся в поле ввода чата и начинаются с /.

Список
/help
Показать список доступных команд.

Пример:

text
/help
Результат:

text
[SYSTEM] Команды: /help /clear /color <hex> /w <ник> <текст> /me <действие>
/clear
Очистить историю сообщений на сервере.

Пример:

text
/clear
Результат: История обнуляется. При следующем подключении игрока он увидит только новые сообщения.

⚠️ Внимание: команда глобальная — очищает чат для всех. Если хочешь ограничить доступ — добавь проверку на админа.

/color <hex>
Установить цвет своего ника (в разработке).

Пример:

text
/color #ff00ff
Результат: Подтверждение установки цвета.

⚠️ Сейчас: команда только показывает подтверждение. Чтобы реально менять цвет, надо добавить player:SetAttribute("ChatColor", hex) в серверный хендлер и читать это в broadcast.lua.

/w <ник> <текст>
Отправить личное сообщение игроку.

Пример:

text
/w Steve привет как дела
Результат:

Steve увидит: [PM] ТвойНик привет как дела

Ты увидишь: [PM] ТвойНик -> Steve: привет как дела

⚠️ Только для онлайн-игроков — если Steve offline, ты получишь ошибку «Игрок не найден».

/me <действие>
Отправить действие от третьего лица.

Пример:

text
/me идёт пить чай
Результат:

text
ТвойНик * ТвойНик идёт пить чай
⚠️ Сейчас: дублирует имя. Чтобы было красиво (* ТвойНик идёт пить чай), надо убрать .Name в commands/me.lua — тогда ник будет только в имени сообщения.

Как добавить свою команду
Создай файл src/server/commands/mycommand.lua:

lua
local Broadcast = require(script.Parent.Parent.broadcast)

return function(player, args)
    -- player — Player кто написал
    -- args   — текст после команды (без /mycommand)
    Broadcast.system(player.Name .. " использовал /mycommand: " .. args)
end
Зарегистрируй в src/server/commands/init.lua:

lua
local handlers = {
    help      = require(script.help),
    clear     = require(script.clear),
    color     = require(script.color),
    w         = require(script.whisper),
    me        = require(script.me),
    mycommand = require(script.mycommand),  -- <-- добавил
}
Добавь файл в scripts/build.lua:

lua
"src/server/commands/mycommand.lua",
Пересобери: lua scripts/build.lua

Готово — команда работает.

Ограничение доступа
Если хочешь чтобы команду могли использовать только админы:

lua
return function(player, args)
    if player.UserId ~= 123456789 then  -- твой UserId
        Broadcast.toPlayer(player, player, "Нет доступа", false)
        return
    end
    -- логика команды
end
Или через группу:

lua
local rank = player:GetRankInGroup(12345678)
if rank < 100 then return end