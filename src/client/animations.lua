-- ============================================================
-- Tween-обёртки
-- ============================================================
local TweenService = game:GetService("TweenService")

local Anim = {}

function Anim.tween(obj, props, time, style, dir)
    local info = TweenInfo.new(
        time or 0.2,
        style or Enum.EasingStyle.Quart,
        dir or Enum.EasingDirection.Out)
    local t = TweenService:Create(obj, info, props)
    t:Play()
    return t
end

return Anim