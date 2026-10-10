-- ============================================================
-- Resonance Chat — тест серверной части
-- ============================================================
-- Запусти это в Command Bar в Studio (не в скрипте).
-- Отправит тестовые сообщения от имени сервера.
-- ============================================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local remote = ReplicatedStorage:FindFirstChild("ResonanceChat_Message")
if not remote then
    warn("Remote не найден. Запусти серверный скрипт сначала.")
    return
end

local testMessages = {
    { name = "System",  text = "Тестовое сообщение #1",  time = "12:00:00", color = Color3.fromRGB(120, 220, 255) },
    { name = "Player",  text = "Привет, это тест!",       time = "12:00:01", color = Color3.fromRGB(80, 255, 120) },
    { name = "Server",  text = "Проверка связи...",       time = "12:00:02", color = Color3.fromRGB(255, 200, 80) },
}

for _, msg in ipairs(testMessages) do
    remote:FireAllClients(msg)
    task.wait(0.5)
end

print("[Test] Отправлено " .. #testMessages .. " сообщений")