---@diagnostic disable: lowercase-global, missing-global-doc

function grant_poly_protection()
	local player_id = EntityGetWithTag("player_unit")[1]
	if not player_id then
		SetTimeOut(0, "mods/meta_leveling/files/scripts/attach_scripts/player_poly_protect.lua", "grant_poly_protection")
		return
	end
	LoadGameEffectEntityTo(player_id, "mods/meta_leveling/files/entities/effects/poly_protection/poly_protection.xml")
	local cooldown_entity = EntityLoad("mods/meta_leveling/files/entities/effects/poly_protection/poly_protection_cooldown.xml")
	EntityAddComponent2(cooldown_entity, "UIIconComponent", {
		name = "$ml_polymorph_immunity_cooldown",
		description = "$ml_polymorph_immunity_cooldown_tp",
		icon_sprite_file = "mods/meta_leveling/files/gfx/poly_protection_cooldown.png",
		is_perk = false,
	})

	EntityAddChild(player_id, cooldown_entity)
end

function set_poly_to_one_frame()
	local poly_id = EntityGetWithTag("polymorphed_player")[1]
	if not poly_id then return end
	local children = EntityGetAllChildren(poly_id) or {}
	for _, child in ipairs(children) do
		local game_effect = EntityGetFirstComponent(child, "GameEffectComponent")
		if game_effect then ComponentSetValue2(game_effect, "frames", 1) end
	end
	SetTimeOut(0, "mods/meta_leveling/files/scripts/attach_scripts/player_poly_protect.lua", "grant_poly_protection")
end

---@param entity_id entity_id
---@return boolean
local function is_on_cooldown(entity_id)
	local children = EntityGetAllChildren(entity_id) or {}
	for _, child in ipairs(children) do
		local ui_icon = EntityGetFirstComponent(child, "UIIconComponent")
		if ui_icon and ComponentGetValue2(ui_icon, "name") == "$ml_polymorph_immunity_cooldown" then return true end
	end
	return false
end

---@param entity_id entity_id
---@param target_path string
function polymorphing_to(entity_id, target_path)
	if target_path == "data/entities/animals/nibbana.xml" then return end
	if is_on_cooldown(entity_id) then return end

	SetTimeOut(0, "mods/meta_leveling/files/scripts/attach_scripts/player_poly_protect.lua", "set_poly_to_one_frame")
end
