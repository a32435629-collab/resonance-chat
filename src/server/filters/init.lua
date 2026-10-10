-- ============================================================
-- Цепочка фильтров
-- ============================================================
local CONFIG = require(script.Parent.Parent.config)

local badwords = require(script.badwords)
local links    = require(script.links)

local Filters = {}

function Filters.apply(player, text)
    if CONFIG.FILTER_BADWORDS then
        text = badwords(text)
        if not text then return nil end
    end
    if CONFIG.FILTER_LINKS then
        text = links(text)
        if not text then return nil end
    end
    return text
end

return Filters