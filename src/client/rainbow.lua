-- ============================================================
-- Глобальная радуга
-- ============================================================
local RunService = game:GetService("RunService")

local Rainbow = {}
Rainbow.hue = 0
Rainbow.speed = 0.5
Rainbow.targets = {}

local function step(dt)
    Rainbow.hue = (Rainbow.hue + dt * Rainbow.speed) % 1
    for _, t in pairs(Rainbow.targets) do
        if t.update then t:update(Rainbow.hue) end
    end
end

RunService.RenderStepped:Connect(step)

function Rainbow.register(target)
    table.insert(Rainbow.targets, target)
end

function Rainbow.getColor()
    return Color3.fromHSV(Rainbow.hue, 1, 1)
end

return Rainbow