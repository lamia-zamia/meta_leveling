--- @class ml_entity_scanner
--- @field private tags table
--- @field private processed_entities table
local entity_scanner = {
	tags = { "enemy", "nest", "homing_target" },
	processed_entities = setmetatable({}, { __mode = "k" }),
}

--- @param entity entity_id
--- @private
function entity_scanner:add_lua_component_if_none(entity)
	self.processed_entities[entity] = true
	local components = EntityGetComponent(entity, "LuaComponent") or {}
	local component_id = nil
	for i = 1, #components do
		local component = components[i]
		if ComponentGetValue2(component, "script_death") == "mods/meta_leveling/files/scripts/attach_scripts/enemy_on_death.lua" then
			component_id = component
			break
		end
	end
	component_id = component_id or EntityAddComponent2(entity, "LuaComponent")
	ComponentSetValue2(component_id, "execute_every_n_frame", -1)
	ComponentSetValue2(component_id, "script_death", "mods/meta_leveling/files/scripts/attach_scripts/enemy_on_death.lua")
	ComponentSetValue2(component_id, "script_damage_received", "mods/meta_leveling/files/scripts/attach_scripts/enemy_on_death.lua")
end

--- scan entities and add death script if none
function entity_scanner:check_entities()
	local unprocessed_entities = {}
	for _, tag in ipairs(self.tags) do
		local entities = EntityGetWithTag(tag)
		for _, entity in ipairs(entities) do
			if not self.processed_entities[entity] then unprocessed_entities[entity] = true end
		end
	end
	for entity, _ in pairs(unprocessed_entities) do
		self:add_lua_component_if_none(entity)
	end
end

return entity_scanner
