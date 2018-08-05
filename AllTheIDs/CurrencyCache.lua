
local addon_name, addon = ...

local CreateFrame, GetCurrentListInfo, GetCurrencyListInfo,
        GetCurrencyListSize, GetCurrencyListSize, rawset, setmetatable
    = CreateFrame, GetCurrentListInfo, GetCurrencyListInfo,
        GetCurrencyListSize, GetCurrencyListSize, rawset, setmetatable

local function defaulttable(callable)
    callable = callable or function() return nil end
    return setmetatable({}, {
        __index = function(t, key)
            local val = callable()
            rawset(t, key, val)
            return val
        end
    })
end

addon.currencyCache = defaulttable(defaulttable)

local event_frame = CreateFrame("FRAME")
event_frame:SetScript("OnEvent", function(frame, event, ...)
    local func = frame[event]
    if func then
        return func(frame, ...)
    end
end)

function event_frame:PLAYER_ENTERING_WORLD()
    for idx = 1,GetCurrencyListSize() do
        local link = GetCurrencyListLink(idx)
        local name, _, _, _, _, _, icon = GetCurrencyListInfo(idx)
        if name and icon then
            addon.currencyCache[name][icon] = link
        end
    end
end
event_frame:RegisterEvent("PLAYER_ENTERING_WORLD")
event_frame:PLAYER_ENTERING_WORLD()
