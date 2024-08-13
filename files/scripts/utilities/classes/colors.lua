---@class colors
---@field colors color_converter
local colors = {
	converter = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/color_converter.lua")
}

function colors:mult255(r, g, b)
    return r * 255, g * 255, b * 255
end

function colors:div255(r, g, b)
    return r / 255, g / 255, b / 255
end

function colors:rgb2hsv(r, g, b)
    return self.converter:rgb2hsv(self:mult255(r, g, b))
end

function colors:hsv2rgb(h, s, v)
    return self:div255(self.converter:hsv2rgb(h, s, v))
end

return colors