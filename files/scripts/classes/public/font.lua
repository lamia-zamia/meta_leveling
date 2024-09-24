---class to handle font generation, color management, and popup text displays.
---@class ML_font
---@field private get ML_get
local font = {
	set_content = ModTextFileSetContent,
	get = dofile_once("mods/meta_leveling/files/scripts/classes/public/get.lua"),
}

---Returns a string of RGB values or retrieves them from mod settings if not provided.
---@param r? number|string Optional red component (0-1). Defaults to mod setting.
---@param g? number|string Optional green component (0-1). Defaults to mod setting.
---@param b? number|string Optional blue component (0-1). Defaults to mod setting.
---@return string r Red component as a string.
---@return string g Green component as a string.
---@return string b Blue component as a string.
function font:get_color(r, g, b)
	r = r or string.format("%.2f", self.get:mod_setting_number("exp_bar_red"))
	g = g or string.format("%.2f", self.get:mod_setting_number("exp_bar_green"))
	b = b or string.format("%.2f", self.get:mod_setting_number("exp_bar_blue"))
	return tostring(r), tostring(g), tostring(b)
end

---Generates a font XML file with the specified RGB values.
---@private
---@param r string Red component as a string.
---@param g string Green component as a string.
---@param b string Blue component as a string.
---@param set_content function Function to save the generated XML content.
function font:generate(r, g, b, set_content)
	local path = string.format("mods/meta_leveling/vfs/font/%s%s%s.xml", r, g, b)
	local nxml = dofile_once("mods/meta_leveling/files/scripts/lib/nxml.lua")
	local xml = nxml.parse(ModTextFileGetContent("data/fonts/font_pixel.xml"))
	xml.attr.color_r = r
	xml.attr.color_g = g
	xml.attr.color_b = b
	xml.attr.color_a = "1"
	set_content(path, tostring(xml))
end

---Returns the path to the virtual colored font file, generating it if it doesn't exist.
---@private
---@param r string Red component as a string.
---@param g string Green component as a string.
---@param b string Blue component as a string.
---@return string path Path to the generated or existing font file.
function font:get_path(r, g, b)
	local path = string.format("mods/meta_leveling/vfs/font/%s%s%s.xml", r, g, b)
	if ModDoesFileExist(path) then
		return path
	end

	local set_content = ModTextFileSetContent or self.set_content
	if set_content then
		self:generate(r, g, b, set_content)
		return path
	end

	return "data/fonts/font_pixel.xml" -- Fallback to the default font if generation is not possible
end

---Displays a popup text on the specified entity with customizable scale and color.
---@param source_entity entity_id Entity ID where the popup should appear.
---@param text string Text to display in the popup.
---@param scale number Scale factor for the text size. Defaults to 1.
---@param r string Optional red component as a string.
---@param g string Optional green component as a string.
---@param b string Optional blue component as a string.
function font:popup(source_entity, text, scale, r, g, b)
	scale = scale or 1
	local x, y = EntityGetFirstHitboxCenter(source_entity)
	if not x then return end

	-- Adjust positions
	x = x - (#text * 3 * scale)
	y = y - 7

	local path = self:get_path(r, g, b)

	local entity = EntityCreateNew("ml_popup")
	EntityAddComponent2(entity, "SpriteComponent", {
		image_file = path,
		is_text_sprite = true,
		text = text,
		z_index = -2,
		emissive = true,
	})
	EntityAddComponent2(entity, "LifetimeComponent", {
		lifetime = 60,
		fade_sprites = true
	})
	EntityAddComponent2(entity, "LuaComponent", {
		script_source_file = "mods/meta_leveling/files/scripts/attach_scripts/popup_exp.lua",
	})
	EntitySetTransform(entity, x, y, 0, scale, scale)
end

---Displays a popup for experience points on the specified entity, adjusting scale based on input.
---@param source_entity entity_id Entity ID where the popup should appear.
---@param text string Text to display in the popup.
---@param scale number Scale factor for the text size.
function font:popup_exp(source_entity, text, scale)
	if scale < 1 then
		scale = 0.5
	else
		scale = scale ^ 0.25 * 0.5
	end
	self:popup(source_entity, text, scale, self:get_color())
end

return font
