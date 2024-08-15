---@class ml_font
local font = {}

---@private
function font:add_vsc(entity, name, value)
	EntityAddComponent2(entity, "VariableStorageComponent", { name = name, value_string = value })
end

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

---create font generator entity
---@private
---@param r string
---@param g string
---@param b string
function font:create_generator(x, y, text, scale, r, g, b)
	entity = EntityCreateNew("ml_font_generate")
	EntityAddComponent2(entity, "LuaComponent", {
		script_source_file = "mods/meta_leveling/files/scripts/attach_scripts/generate_font_hax.lua",
		execute_times = 1
	})
	self:add_vsc(entity, "x", x)
	self:add_vsc(entity, "y", y)
	self:add_vsc(entity, "text", text)
	self:add_vsc(entity, "scale", scale)
	self:add_vsc(entity, "red", r)
	self:add_vsc(entity, "green", g)
	self:add_vsc(entity, "blue", b)
end

---create font generator entity
---@private
---@param r string
---@param g string
---@param b string
function font:generate(r, g, b)
	local path = "mods/meta_leveling/vfs/font/" .. r .. g .. b .. ".xml"
	local xml = ML.nxml.parse(ModTextFileGetContent("data/fonts/font_pixel.xml"))
	xml.attr.color_r = r
	xml.attr.color_g = g
	xml.attr.color_b = b
	xml.attr.color_a = "1"
	ModTextFileSetContent(path, tostring(xml))
end

---returns path to virtual colored font and generate if it doesn't exist
---@private
---@param r string
---@param g string
---@param b string
---@return string? path
function font:get_path(r, g, b)
	local path = "mods/meta_leveling/vfs/font/" .. r .. g .. b .. ".xml"
	if ModDoesFileExist(path) then
		return path
	elseif ModTextFileSetContent then
		self:generate(r, g, b)
		return path
	end
	return nil
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
	if not x then return end
	x = x - (#text * 3 * scale)
	y = y - 7
	local path = self:get_path(r, g, b)
	if path then
		entity = EntityCreateNew("ml_popup")
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
	else
		self:create_generator(x, y, text, scale, r, g, b) --because ModTextFileSetContent available only from lua component
	end
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
