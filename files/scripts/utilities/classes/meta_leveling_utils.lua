---@class ML_utils
local utils = {}

---get global valuess of META_LEVELING_
---@return number
---@param key string
---@param default number
function utils:get_global_number(key, default)
	return tonumber(GlobalsGetValue("META_LEVELING_" .. key:upper(), tostring(default))) or default
end

---set global valuess of META_LEVELING_
---@param key string
---@param value number
function utils:set_global_number(key, value)
	GlobalsSetValue("META_LEVELING_" .. key:upper(), tostring(value))
end

---add value to global
---@param key string
---@param value number
---@param default? number
function utils:add_to_global_number(key, value, default)
	default = default or 0
	local old = self:get_global_number(key, default)
	self:set_global_number(key, old + value)
end

function utils:weighted_random(pool)
	local poolsize = 0
	for _, item in ipairs(pool) do
		poolsize = poolsize + item.weight
	end
	self:random_seed()
	local selection = Random(1, poolsize)
	for _, item in ipairs(pool) do
		selection = selection - item.weight
		if (selection <= 0) then
			return item.id
		end
	end
end

---add value to value_name of component
---@param component component_id
---@param value_name string
---@param value number
function utils:add_value_to_component(component, value_name, value)
	local current = tonumber(ComponentGetValue2(component, value_name))
	ComponentSetValue2(component, value_name, current + value)
end

---multiply value of value_name in component
---@param component component_id
---@param value_name string
---@param multiplier number
function utils:multiply_value_in_component(component, value_name, multiplier)
	local current = tonumber(ComponentGetValue2(component, value_name))
	ComponentSetValue2(component, value_name, current * multiplier)
end

---add value to value_name of component object
---@param component component_id
---@param object string
---@param value_name string
---@param value number
function utils:add_value_to_component_object(component, object, value_name, value)
	local current = ComponentObjectGetValue2(component, object, value_name)
	ComponentObjectSetValue2(component, object, value_name, current + value)
end

---multiply value of value_name in component object
---@param component component_id
---@param object string
---@param value_name string
---@param multiplier number
function utils:multiply_value_in_component_object(component, object, value_name, multiplier)
	local current = ComponentObjectGetValue2(component, object, value_name)
	ComponentObjectSetValue2(component, object, value_name, current * multiplier)
end

---return world state component id
---@return component_id?
function utils:get_world_state_component()
	local world_entity_id = GameGetWorldStateEntity()
	return EntityGetFirstComponent(world_entity_id, "WorldStateComponent")
end

---return number from mod settings
---@param id string id of setting
---@param default? number default number or 0
---@return number
function utils:get_mod_setting_number(id, default)
	default = default or 0
	return tonumber(ModSettingGet("meta_leveling." .. id)) or default
end

---return number from mod settings
---@param id string id of setting
---@param default? boolean default value or false
---@return boolean
function utils:get_mod_setting_boolean(id, default)
	default = default or false
	local value = ModSettingGet("meta_leveling." .. id)
	if type(value) == "boolean" then
		return value
	else
		return default
	end
end

function utils:spawn_spell(action_id)
	CreateItemActionEntity(action_id, ML.player.x, ML.player.y)
end

function utils:random_seed()
	SetRandomSeed(ML.player.x, ML.player.y + GameGetFrameNum())
end

function utils:load_entity_to_player(file)
	EntityLoad(file, ML.player.x, ML.player.y)
end

function utils:merge_tables(table1, table2)
	for _, element in ipairs(table2) do
		table1[#table1 + 1] = element
	end
end

return utils
