# Resonance Chat

Стильный чат для Roblox — **радужная полупрозрачная панель** + **кастомный сервер** для сообщений.

## Возможности

- Радужная анимированная панель с градиентом
- Полупрозрачный фон (35%)
- Уникальные цвета ников для каждого игрока
- Отправка по Enter или кнопке
- Хоткей `Y` — открыть/закрыть
- История 50 сообщений
- Антиспам 0.5 сек
- Лимит длины 200 символов
- Системные уведомления (вход/выход)
- Команды: `/help`, `/clear`, `/color`, `/w`, `/me`
- Перетаскиваемая панель

## Установка

### Roblox Studio

1. Открой игру в Studio
2. **ServerScriptService** -> **Script** -> вставь `dist/resonance-chat.server.lua`
3. **StarterPlayer -> StarterPlayerScripts** -> **LocalScript** -> вставь `dist/resonance-chat.client.lua`
4. Play -> нажми `Y`

### Через loadstring (только клиент)

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/a32435629-collab/resonance-chat/main/dist/resonance-chat.client.lua"))()
Управление
КлавишаДействие
YОткрыть / закрыть чат
EnterОтправить сообщение
EscЗакрыть
Структура проекта
text
resonance-chat/
├── src/
│   ├── server/          -- серверная часть (17 модулей)
│   ├── client/          -- клиентская часть (9 модулей)
│   └── shared/          -- общие константы
├── dist/                -- собранные скрипты для вставки в Studio
├── docs/                -- документация
├── scripts/             -- сборщик
└── examples/            -- примеры использования
Документация
Установка

Возможности

Команды

Настройки

История версий

Разработка
Сборка
bash
lua scripts/build.lua
Склеивает модули из src/ в два файла:

dist/resonance-chat.server.lua

dist/resonance-chat.client.lua

Автосборка
GitHub Actions автоматически пересобирает dist/ при каждом пуше в main.

Лицензия
MIT — см. LICENSE