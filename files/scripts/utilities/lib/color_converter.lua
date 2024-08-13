---@class color_converter
local color_converter = {}

function color_converter:rgb2hsv(r, g, b)
    local M, m = math.max(r, g, b), math.min(r, g, b)
    local C = M - m
    local K = 1 / (6 * C)
    local h = 0
    if (C ~= 0) then
        if (M == r) then
            h = (K * (g - b)) % 1
        elseif (M == g) then
            h = K * (b - r) + 1 / 3
        else
            h = K * (r - g) + 2 / 3
        end
    end
    return h, M == 0 and 0 or C / M, M / 255
end

function color_converter:hsv2rgb(h, s, v)
    local C = 255 * v * s
    local m = 255 * v - C
    local r, g, b = m, m, m
    if (h == h) then
        local h_ = (h % 1) * 6
        local X = C * (1 - math.abs(h_ % 2 - 1))
        C, X = C + m, X + m
        if (h_ < 1) then
            r, g, b = C, X, m
        elseif (h_ < 2) then
            r, g, b = X, C, m
        elseif (h_ < 3) then
            r, g, b = m, C, X
        elseif (h_ < 4) then
            r, g, b = m, X, C
        elseif (h_ < 5) then
            r, g, b = X, m, C
        else
            r, g, b = C, m, X
        end
    end
    return r, g, b
end

return color_converter