-- ============================================================
-- Resonance Chat — пример загрузки через loadstring
-- ============================================================
-- Требования:
--   1. Серверная часть уже стоит в игре (ServerScriptService)
--   2. У тебя есть executor с HttpGet
--
-- Что делает:
--   Загружает клиентский скрипт чата из GitHub и запускает его.
-- ============================================================

local URL = "https://raw.githubusercontent.com/a32435629-collab/resonance-chat/main/dist/resonance-chat.client.lua"

local ok, code = pcall(function()
    return game:HttpGet(URL)
end)

if not ok or not code then
    warn("[Resonance Chat] Не удалось скачать клиент")
    return
end

local chunk, err = loadstring(code, "@resonance-chat-client")
if not chunk then
    warn("[Resonance Chat] Ошибка компиляции: " .. tostring(err))
    return
end

local ok2, err2 = pcall(chunk)
if not ok2 then
    warn("[Resonance Chat] Ошибка запуска: " .. tostring(err2))
    return
end

print("[Resonance Chat] Клиент загружен")