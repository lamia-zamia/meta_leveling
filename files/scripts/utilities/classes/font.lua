---@class ml_font
local font = {
	source = "data/fonts/font_pixel.xml",
	path = "mods/meta_leveling/vfs/font/",
	font_size = 3,
	LifetimeComponent = {
		lifetime = 60,
		fade_sprites = true
	},
	LuaComponent = {
		script_source_file = "mods/meta_leveling/files/scripts/attach_scripts/popup_exp.lua",
	},
}

---returns string of rgb or exp color if none
---@param r? number|string
---@param g? number|string
---@param b? number|string
---@return string r, string g, string b
function font:get_color(r, g, b)
	if r then r = tostring(r) else r = string.format("%.2f", ML.utils:get_mod_setting_number("exp_bar_red")) end
	if g then g = tostring(g) else g = string.format("%.2f", ML.utils:get_mod_setting_number("exp_bar_green")) end
	if b then b = tostring(b) else b = string.format("%.2f", ML.utils:get_mod_setting_number("exp_bar_blue")) end
	return r, g, b
end

---generate virtual font
---@private
---@param r string
---@param g string
---@param b string
---@param path string
function font:generate(r, g, b, path)
	local xml = ML.nxml.parse(ModTextFileGetContent(self.source))
	xml.attr.color_r = r
	xml.attr.color_g = g
	xml.attr.color_b = b
	xml.attr.color_a = "1"
	ModTextFileSetContent(path, tostring(xml))
end

---returns path to virtual colored font and generate if it doesn't exist
---@param r string
---@param g string
---@param b string
---@return string path
function font:get_path(r, g, b)
	local path = self.path .. r .. g .. b .. ".xml"
	if ModDoesFileExist(path) then
		return path
	else
		font:generate(r, g, b, path)
		return path
	end
end

---popup text on entity
---@param source_entity entity_id
---@param text string
---@param r string
---@param g string
---@param b string
---@param scale number
function font:popup(source_entity, text, scale, r, g, b)
	scale = scale or 1
	local x, y = EntityGetFirstHitboxCenter(source_entity)
	local offset = #text * self.font_size * scale
	if not x then return end
	entity = EntityCreateNew("ml_exp_popup")
	EntityAddComponent2(entity, "SpriteComponent", {
		image_file = self:get_path(r, g, b),
		is_text_sprite = true,
		text = text,
		z_index = -2,
		emissive = true,
	})
	EntityAddComponent2(entity, "LifetimeComponent", self.LifetimeComponent)
	EntityAddComponent2(entity, "LuaComponent", self.LuaComponent)
	EntitySetTransform(entity, x - offset, y - 7, 0, scale, scale)
end

---popup exp on entity
---@param source_entity entity_id
---@param text string
---@param scale number
function font:popup_exp(source_entity, text, scale)
	if scale < 1 then
		scale = 0.5
	else
		scale = scale ^ 0.25 * 0.5
	end
	self:popup(source_entity, text, scale, self:get_color())
end

return font
