---dummy entity for generating fonts outside of init.lua or lua component

local nxml = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/nxml.lua")

local entity = GetUpdatedEntityID()

local function get_from_vsc(comps, name)
	for _, comp in ipairs(comps) do
		if ComponentGetValue2(comp, "name") == name then
			return ComponentGetValue2(comp, "value_string")
		end
	end
end

local comps = EntityGetComponent(entity, "VariableStorageComponent")

local source = "data/fonts/font_pixel.xml"
local red = get_from_vsc(comps, "red")
local green = get_from_vsc(comps, "green")
local blue = get_from_vsc(comps, "blue")
local x = tonumber(get_from_vsc(comps, "x")) or 0
local y = tonumber(get_from_vsc(comps, "y")) or 0
local text = get_from_vsc(comps, "text")
local scale = tonumber(get_from_vsc(comps, "scale")) or 1

local path = "mods/meta_leveling/vfs/font/" .. red .. green .. blue .. ".xml"

local xml = nxml.parse(ModTextFileGetContent(source))
xml.attr.color_r = red
xml.attr.color_g = green
xml.attr.color_b = blue
xml.attr.color_a = "1"
ModTextFileSetContent(path, tostring(xml))

entity_pop = EntityCreateNew("ml_popup")
EntityAddComponent2(entity_pop, "SpriteComponent", {
	image_file = path,
	is_text_sprite = true,
	text = text,
	z_index = -2,
	emissive = true,
})
EntityAddComponent2(entity_pop, "LifetimeComponent", {
	lifetime = 60,
	fade_sprites = true
})
EntityAddComponent2(entity_pop, "LuaComponent", {
	script_source_file = "mods/meta_leveling/files/scripts/attach_scripts/popup_exp.lua",
})
EntitySetTransform(entity_pop, x, y, 0, scale, scale)

EntityKill(entity)