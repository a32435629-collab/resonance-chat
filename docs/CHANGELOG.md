
Changelog
Все значительные изменения в проекте будут документироваться здесь.

Формат: Keep a Changelog
Версии: Semantic Versioning

[1.0.0] - 2026-10-10
Added
Сервер
Модуль config.lua — центральные настройки

Модуль remotes.lua — создание RemoteEvent'ов

Модуль sanitizer.lua — очистка текста + антиспам

Модуль history.lua — хранение истории сообщений (50)

Модуль broadcast.lua — рассылка всем / лично / system

Модуль commands/ — парсер команд + 5 команд:

/help — список команд

/clear — очистка истории

/color <hex> — цвет ника (заготовка)

/w <ник> <текст> — личное сообщение

/me <действие> — действие от третьего лица

Модуль filters/ — цепочка фильтров:

badwords.lua — фильтр мата

links.lua — фильтр ссылок

Модуль init.server.lua — точка входа сервера

Клиент
Модуль config.lua — настройки UI

Модуль theme.lua — цвета, шрифты, размеры

Модуль animations.lua — tween-обёртки

Модуль rainbow.lua — глобальная радуга

Модуль keybind.lua — хоткей Y

Модуль ui/panel.lua — главный UI (~300 строк):

Радужная анимированная панель

Полупрозрачный фон

Перетаскиваемая панель

Анимированное открытие/закрытие

Список сообщений с автоскроллом

Поле ввода + кнопка отправки

Модуль init.client.lua — точка входа клиента

Инфраструктура
scripts/build.lua — сборщик src/ → dist/

.github/workflows/build.yml — автопересборка dist при push

Документация: INSTALL, FEATURES, COMMANDS, CONFIG, CHANGELOG

Примеры: loadstring.lua, local_load.lua, server_test.lua

Known Issues
/color пока не применяет цвет — только подтверждает

/me дублирует ник в тексте

Нет модерации (kick/ban/mute)

Нет Discord webhook логирования

[Unreleased] — планы
Will be added
/kick <ник> — кик игрока

/ban <ник> — бан игрока

/mute <ник> — мут

Реальная работа /color

Discord webhook для логов

Эмодзи-панель

Приватные каналы (#general, #trade, #help)

Сохранение настроек в DataStore

Звук при новом сообщении

Will be improved
Рефакторинг panel.lua — разбить на модули header.lua, input.lua, message_list.lua

Кеширование цветов игроков

Оптимизация рейдуги (меньше обновлений в секунду)