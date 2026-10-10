-- ============================================================
-- Создание RemoteEvent
-- ============================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensure(name)
    local r = ReplicatedStorage:FindFirstChild(name)
    if not r then
        r = Instance.new("RemoteEvent")
        r.Name = name
        r.Parent = ReplicatedStorage
    end
    return r
end

return {
    send    = ensure("ResonanceChat_Send"),
    message = ensure("ResonanceChat_Message"),
}