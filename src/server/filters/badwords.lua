-- ============================================================
-- Фильтр мата
-- ============================================================
local WORDS = {
    -- "мат1", "мат2"  -- замени на реальные
}

return function(text)
    for _, word in ipairs(WORDS) do
        text = text:gsub(word, string.rep("*", #word))
    end
    return text
end