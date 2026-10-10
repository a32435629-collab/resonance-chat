-- ============================================================
-- Resonance Chat — сборщик
-- Склеивает модули src/ в один файл для сервера и клиента
-- Запуск: lua scripts/build.lua
-- ============================================================

local function readFile(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local c = f:read("*a")
    f:close()
    return c
end

local function writeFile(path, content)
    local f = io.open(path, "w")
    if not f then
        error("Не могу открыть " .. path .. " для записи")
    end
    f:write(content)
    f:close()
end

local function concat(files)
    local out = {}
    for _, path in ipairs(files) do
        local c = readFile(path)
        if c then
            table.insert(out, "-- === " .. path .. " ===")
            table.insert(out, c)
            table.insert(out, "")
        else
            print("  [SKIP] " .. path .. " (не найден)")
        end
    end
    return table.concat(out, "\n")
end

-- ============================================================
-- СПИСОК ФАЙЛОВ — СЕРВЕР
-- ============================================================
local serverFiles = {
    "src/shared/constants.lua",
    "src/shared/types.lua",

    "src/server/config.lua",
    "src/server/remotes.lua",
    "src/server/sanitizer.lua",
    "src/server/history.lua",
    "src/server/broadcast.lua",

    "src/server/commands/init.lua",
    "src/server/commands/help.lua",
    "src/server/commands/clear.lua",
    "src/server/commands/color.lua",
    "src/server/commands/whisper.lua",
    "src/server/commands/me.lua",

    "src/server/filters/init.lua",
    "src/server/filters/badwords.lua",
    "src/server/filters/links.lua",

    "src/server/init.server.lua",
}

-- ============================================================
-- СПИСОК ФАЙЛОВ — КЛИЕНТ
-- ============================================================
local clientFiles = {
    "src/shared/constants.lua",
    "src/shared/types.lua",

    "src/client/config.lua",
    "src/client/theme.lua",
    "src/client/animations.lua",
    "src/client/rainbow.lua",
    "src/client/keybind.lua",

    "src/client/ui/panel.lua",

    "src/client/init.client.lua",
}

-- ============================================================
-- СБОРКА
-- ============================================================
print("============================================")
print("Resonance Chat — Build")
print("============================================")

-- Сервер
local serverOut = concat(serverFiles)
writeFile("dist/resonance-chat.server.lua", serverOut)
print("  OK: dist/resonance-chat.server.lua (" .. #serverOut .. " bytes)")

-- Клиент
local clientOut = concat(clientFiles)
writeFile("dist/resonance-chat.client.lua", clientOut)
print("  OK: dist/resonance-chat.client.lua (" .. #clientOut .. " bytes)")

print("")
print("============================================")
print("Done!")
print("============================================")