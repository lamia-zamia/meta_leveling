---@class (exact) ml_entity_scanner
---@field private tags table
local entity_scanner = {
	tags = {"enemy", "nest", "helpless_animal"}
}

---@param entity entity_id
---@private
function entity_scanner:add_lua_component_if_none(entity)
	local components = EntityGetComponentIncludingDisabled(entity, "LuaComponent") or {}
	for _, component in ipairs(components) do
		if ComponentGetValue2(component, "script_death") == "mods/meta_leveling/files/scripts/attach_scripts/enemy_on_death.lua" then return end
	end
	EntityAddComponent2(entity, "LuaComponent", {
		execute_every_n_frame= -1,
		script_death = "mods/meta_leveling/files/scripts/attach_scripts/enemy_on_death.lua",
		remove_after_executed=true
	})
end

---scan entities and add death script if none
function entity_scanner:check_entities()
	for _, tag in ipairs(self.tags) do
		local entities = EntityGetWithTag(tag)
		for _, entity in ipairs(entities) do
			self:add_lua_component_if_none(entity)
		end
	end
end

return entity_scanner