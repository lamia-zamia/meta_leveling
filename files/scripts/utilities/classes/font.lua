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
	r = "0",
	g = "0",
	b = "0"
}

function font:get_color()
	self.r = string.format("%.2f", ML.utils:get_mod_setting_number("exp_bar_red"))
	self.g = string.format("%.2f", ML.utils:get_mod_setting_number("exp_bar_green"))
	self.b = string.format("%.2f", ML.utils:get_mod_setting_number("exp_bar_blue"))
end

function font:get_path()
	self:get_color()
	local path = self.path .. self.r .. self.g .. self.b .. ".xml"
	if ModDoesFileExist(path) then
		return path
	else
		font:generate(path)
		return path
	end
end

function font:generate(path)
	path = path or self:get_path()
	local xml = ML.nxml.parse(ModTextFileGetContent(self.source))
	xml.attr.color_r = self.r
	xml.attr.color_g = self.g
	xml.attr.color_b = self.b
	xml.attr.color_a = "1"
	ModTextFileSetContent(path, tostring(xml))
end

function font:popup(source_entity, text, scale)
	if scale < 1 then
		scale = 0.5
	else
		scale = scale ^ 0.25 * 0.5
	end
	local x, y = EntityGetFirstHitboxCenter(source_entity)
	local offset = #text * self.font_size * scale
	if not x then return end
	entity = EntityCreateNew("ml_exp_popup")
	EntityAddComponent2(entity, "SpriteComponent", {
		image_file = self:get_path(),
		is_text_sprite = true,
		text = text,
		z_index = -2,
		emissive = true,
	})
	EntityAddComponent2(entity, "LifetimeComponent", self.LifetimeComponent)
	EntityAddComponent2(entity, "LuaComponent", self.LuaComponent)
	EntitySetTransform(entity, x - offset, y - 7, 0, scale, scale)
end

return font
