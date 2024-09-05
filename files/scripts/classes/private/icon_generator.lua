---@type nxml
local nxml = dofile_once("mods/meta_leveling/files/scripts/lib/nxml.lua")

---@class ml_icon_generator
local IG = {
	spell_background = {
		draw_many = "mods/meta_leveling/vfs/gfx/draw_many.png",
		material = "mods/meta_leveling/vfs/gfx/material.png",
		modifier = "mods/meta_leveling/vfs/gfx/modifier.png",
		other = "mods/meta_leveling/vfs/gfx/other.png",
		passive = "mods/meta_leveling/vfs/gfx/passive.png",
		projectile = "mods/meta_leveling/vfs/gfx/projectile.png",
		static_projectile = "mods/meta_leveling/vfs/gfx/static_projectile.png",
		utility = "mods/meta_leveling/vfs/gfx/utility.png",
	},
	spell_background_generated = false,
}

---@class ml_icon_generator_layers
---@field [number] string[]

---@class ml_icon_generator_table
---@field path string path to file
---@field layers ml_icon_generator_layers --layers of png
---@field speed? number

---Generates 16x16 icon
---@param config ml_icon_generator_table
function IG:generate(config)
	local path = config.path
	local layers = config.layers
	local columns = self:determine_column_count(layers)

	if path:find("%.xml$") then
		self:generate_xml(path, columns, config.speed)
		path = path:gsub("%.xml$", ".png")
	end

	self:generate_png(columns, layers, path)
end

---Generates png based on the given layouts
---@private
---@param columns number
---@param layers table<number, string[]>
---@param path string
function IG:generate_png(columns, layers, path)
	local destination_id = ModImageMakeEditable(path, columns * 16, #layers * 16)
	for _, layer in ipairs(layers) do
		for j = 1, columns do
			local source = layer[j] or layer[1]
			self:copy_from_icon(destination_id, (j - 1) * 16, source)
		end
	end
end

---Generates xml based on the given layouts
---@private
---@param path string
---@param columns number
---@param speed? number
function IG:generate_xml(path, columns, speed)
	speed = speed or math.max((1.8 / columns), 0.225)
	local png = path:gsub("%.xml$", ".png")
	xml = nxml.new_element("Sprite", { filename = png }, {
		nxml.new_element("RectAnimation", {
			name = "default",
			frame_count = tostring(columns),
			pos_x = "0",
			pos_y = "0",
			frame_width = "16",
			frame_height = "16",
			frame_wait = tostring(speed)
		})
	})
	ModTextFileSetContent(path, tostring(xml))
end

---Applying colors from source to destination, should be 16x16
---@private
---@param image_id number
---@param x number
---@param source string
function IG:copy_from_icon(image_id, x, source)
	local source_id = ModImageMakeEditable(source, 0, 0)
	for i = 0, 15 do
		for j = 0, 15 do
			local color_source = ModImageGetPixel(source_id, i, j)
			if self:color_has_alhpa(color_source) then
				local color = self:blend_colors(color_source, ModImageGetPixel(image_id, x + i, j))
				ModImageSetPixel(image_id, x + i, j, color)
			end
		end
	end
end

---generate common icons if there are none
---@private
function IG:generate_common_if_not()
	if not self.spell_background_generated then self:steal_spell_background() end
end

---Copy background png from game and make them 16x16 instead of 20x20
---@private
function IG:steal_spell_background()
	for key, path in pairs(self.spell_background) do
		if ModDoesFileExist(path) then
			self.spell_background_generated = true
			return
		end
		local dest_id = ModImageMakeEditable(path, 16, 16)
		local source = "data/ui_gfx/inventory/item_bg_" .. key .. ".png"
		local source_id = ModImageMakeEditable(source, 0, 0)
		for x = 0, 15 do
			for y = 0, 15 do
				local color = ModImageGetPixel(source_id, x + 2, y + 2)
				ModImageSetPixel(dest_id, x, y, color)
			end
		end
	end
	self.spell_background_generated = true
end

---Determines amount of columns from layers
---@private
---@param layers ml_icon_generator_layers
---@return number width
---@nodiscard
function IG:determine_column_count(layers)
	local width = 1
	for _, layer in ipairs(layers) do
		width = math.max(width, #layer)
	end
	return width
end

---Split abgr
---@private
---@param abgr_int integer
---@return number red, number green, number blue, number alpha
function IG:color_abgr_split(abgr_int)
	local r = bit.band(abgr_int, 0xFF)
	local g = bit.band(bit.rshift(abgr_int, 8), 0xFF)
	local b = bit.band(bit.rshift(abgr_int, 16), 0xFF)
	local a = bit.band(bit.rshift(abgr_int, 24), 0xFF)

	return r, g, b, a
end

---Merge rgb
---@private
---@param r number
---@param g number
---@param b number
---@param a number
---@return integer color
function IG:color_abgr_merge(r, g, b, a)
	return bit.bor(
		bit.band(r, 0xFF),
		bit.lshift(bit.band(g, 0xFF), 8),
		bit.lshift(bit.band(b, 0xFF), 16),
		bit.lshift(bit.band(a, 0xFF), 24)
	)
end

---Blend colors
---@private
---@param color1 integer
---@param color2 integer
---@return integer
function IG:blend_colors(color1, color2)
	-- Extract RGBA components
	local s_r, s_g, s_b, s_a = self:color_abgr_split(color1)
	local d_r, d_g, d_b, d_a = self:color_abgr_split(color2)

	-- Normalize source alpha and compute inverse alpha once
	local alpha = s_a / 255
	local inv_alpha = 1 - alpha

	-- Blend each component using direct calculations
	local r = alpha * s_r + inv_alpha * d_r
	local g = alpha * s_g + inv_alpha * d_g
	local b = alpha * s_b + inv_alpha * d_b

	-- Merge the final color with full opacity
	return self:color_abgr_merge(r, g, b, 255)
end

---Returns true if color's alpha > 0
---@private
---@param abgr_int integer
---@return boolean
function IG:color_has_alhpa(abgr_int)
	local _, _, _, alpha = self:color_abgr_split(abgr_int)
	return alpha > 0
end

IG:generate_common_if_not()

return IG
