local entity_load = EntityLoad

---@param filename string
---@param pos_x integer? 0
---@param pos_y integer? 0
---@return entity_id entity_id
function EntityLoad(filename, pos_x, pos_y)
	local entity = entity_load(filename, pos_x, pos_y)
	EntityAddComponent2(entity, "LuaComponent", {
		script_item_picked_up = "mods/meta_leveling/files/scripts/attach_scripts/pacifist_chest.lua",
		script_physics_body_modified = "mods/meta_leveling/files/scripts/attach_scripts/pacifist_chest.lua",
	})
	return entity
end
