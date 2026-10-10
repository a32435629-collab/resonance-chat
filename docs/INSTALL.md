# Установка

## Требования

- Roblox Studio (последняя версия)
- Игра, где ты можешь редактировать скрипты (не FE-restricted)

## Способ 1 — вручную (рекомендую)

### Сервер

1. Открой игру в **Roblox Studio**
2. В **Explorer** найди `ServerScriptService`
3. Правый клик → **Insert Object** → **Script**
4. Переименуй в `ChatServer`
5. Открой `dist/resonance-chat.server.lua` и скопируй содержимое
6. Вставь в `ChatServer`

### Клиент

1. В **Explorer** найди `StarterPlayer → StarterPlayerScripts`
2. Правый клик → **Insert Object** → **LocalScript**
3. Переименуй в `ChatClient`
4. Открой `dist/resonance-chat.client.lua` и скопируй содержимое
5. Вставь в `ChatClient`

### Проверка

1. Нажми **Play** в Studio
2. В чате появятся сообщения `[SYSTEM] Resonance Chat v1.0`
3. Нажми `Y` — откроется панель чата
4. Напиши что-нибудь и нажми `Enter`

## Способ 2 — через loadstring (только клиент)

Если сервер уже работает в игре, а тебе нужно только клиентское UI:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/a32435629-collab/resonance-chat/main/dist/resonance-chat.client.lua"))()
Понадобится executor с поддержкой HttpGet.

Способ 3 — локальная разработка
Если хочешь тестировать через модули, а не через собранный dist:

В StarterPlayerScripts создай LocalScript ChatClient

Внутри него создай:

ModuleScript config → содержимое src/client/config.lua

ModuleScript theme → содержимое src/client/theme.lua

ModuleScript animations → содержимое src/client/animations.lua

ModuleScript rainbow → содержимое src/client/rainbow.lua

ModuleScript keybind → содержимое src/client/keybind.lua

Folder ui → ModuleScript panel внутри → содержимое src/client/ui/panel.lua

Скопируй код из examples/local_load.lua в LocalScript

Частые проблемы
«Remote event not found»
Серверный скрипт не запущен. Проверь, что ChatServer лежит в ServerScriptService.

Чат не открывается по Y
Проверь src/client/keybind.lua — возможно, клавиша занята. Измени TOGGLE_KEY на другую.

Сообщения не отправляются
Проверь, что ResonanceChat_Send создан сервером. Зайди в ReplicatedStorage и убедись что там есть 2 RemoteEvent.