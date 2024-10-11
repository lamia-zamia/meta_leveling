--- @class colors_hue:number
--- @class colors_saturation:number
--- @class colors_value:number

--- @class (exact) colors
--- @field private converter color_converter
local colors = {
	converter = dofile_once("mods/meta_leveling/files/scripts/lib/color_converter.lua")
}

--- @private
function colors:mult255(r, g, b)
	return r * 255, g * 255, b * 255
end

--- @private
function colors:div255(r, g, b)
	return r / 255, g / 255, b / 255
end

--- converts noita-rgb to 255hsv
--- @param r number
--- @param g number
--- @param b number
--- @return colors_hue, colors_saturation, colors_value
function colors:rgb2hsv(r, g, b)
	return self.converter:rgb2hsv(self:mult255(r, g, b))
end

--- converts 255hsv to noita-rgb
--- @param h colors_hue
--- @param s colors_saturation
--- @param v colors_value
--- @return number red, number green, number blue
function colors:hsv2rgb(h, s, v)
	return self:div255(self.converter:hsv2rgb(h, s, v))
end

return colors
