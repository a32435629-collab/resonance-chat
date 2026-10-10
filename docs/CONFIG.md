
Настройки
Сервер (src/server/config.lua)
lua
return {
    MAX_MESSAGE_LENGTH = 200,      -- Максимум символов в сообщении
    COOLDOWN_SECONDS   = 0.5,      -- Антиспам (сек между сообщениями)
    MAX_HISTORY        = 50,       -- Сколько сообщений хранить

    FILTER_BADWORDS    = true,     -- Фильтр мата вкл/выкл
    FILTER_LINKS       = false,    -- Фильтр ссылок вкл/выкл

    SYSTEM_COLOR       = Color3.fromRGB(120, 220, 255),  -- цвет [SYSTEM]
    JOIN_COLOR         = Color3.fromRGB(80, 255, 120),   -- цвет входа
    LEAVE_COLOR        = Color3.fromRGB(255, 120, 120),  -- цвет выхода
    ERROR_COLOR        = Color3.fromRGB(255, 200, 80),   -- цвет ошибок
}
Что меняется
ПараметрЭффект
MAX_MESSAGE_LENGTH = 500Разрешить длинные сообщения
COOLDOWN_SECONDS = 0Отключить антиспам
COOLDOWN_SECONDS = 2Строгий антиспам (2 сек между)
MAX_HISTORY = 100Больше истории
FILTER_BADWORDS = falseОтключить фильтр мата
FILTER_LINKS = trueЗапретить ссылки
Клиент (src/client/config.lua)
lua
return {
    PANEL_WIDTH        = 420,     -- ширина панели в пикселях
    PANEL_HEIGHT       = 320,     -- высота панели
    MARGIN             = 20,      -- отступ от края экрана
    MAX_MESSAGES       = 30,      -- сколько сообщений видно
    RAINBOW_SPEED      = 0.5,     -- скорость радуги (0 = стоп)
    PANEL_TRANSPARENCY = 0.35,    -- прозрачность (0 = непрозрачный, 1 = невидимый)
}
Что меняется
ПараметрЭффект
PANEL_WIDTH = 600Более широкая панель
PANEL_HEIGHT = 500Более высокая панель
MARGIN = 0Прижать к краю
MAX_MESSAGES = 100Больше сообщений на экране (может лагать)
RAINBOW_SPEED = 2Быстрая радуга
RAINBOW_SPEED = 0Отключить радугу
PANEL_TRANSPARENCY = 0Полностью непрозрачная панель
PANEL_TRANSPARENCY = 0.7Почти прозрачная
Тема (src/client/theme.lua)
lua
Background  = Color3.fromRGB(20, 20, 30),    -- фон панели
Header      = Color3.fromRGB(0, 0, 0),       -- фон заголовка
InputBg     = Color3.fromRGB(30, 30, 45),    -- фон поля ввода
Text        = Color3.fromRGB(240, 240, 250), -- основной текст
TextDim     = Color3.fromRGB(140, 140, 160), -- тусклый текст
CloseHover  = Color3.fromRGB(255, 80, 80),   -- красный при наведении на X
SendBg      = Color3.fromRGB(100, 100, 180), -- фон кнопки отправки
Смена темы
Хочешь тёмно-красную тему:

lua
Background  = Color3.fromRGB(40, 10, 10),
Header      = Color3.fromRGB(60, 15, 15),
InputBg     = Color3.fromRGB(50, 15, 15),
Text        = Color3.fromRGB(255, 220, 220),
SendBg      = Color3.fromRGB(180, 50, 50),
Хочешь зелёную (матрица):

lua
Background  = Color3.fromRGB(5, 20, 10),
Header      = Color3.fromRGB(0, 40, 20),
InputBg     = Color3.fromRGB(5, 30, 15),
Text        = Color3.fromRGB(80, 255, 120),
SendBg      = Color3.fromRGB(20, 120, 60),
Шрифты
В theme.lua:

lua
Font     = Enum.Font.Gotham,        -- основной
FontBold = Enum.Font.GothamBold,    -- заголовок
Доступные: Gotham, SourceSans, Roboto, Ubuntu, Code, SciFi — полный список в документации Roblox.

Хоткей
В src/client/keybind.lua:

lua
local TOGGLE_KEY = Enum.KeyCode.Y
Замени на любую:

Enum.KeyCode.U

Enum.KeyCode.F

Enum.KeyCode.Slash

Enum.KeyCode.RightShift

Enum.KeyCode.F2

Применение изменений
Если менял src/ → нужно пересобрать dist/:

bash
lua scripts/build.lua
Если менял dist/ напрямую → изменения сразу в игре при следующем запуске.

Если используешь loadstring → нужно запушить на GitHub и потом loadstring подтянет свежую версию.