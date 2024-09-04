---@class ML_utils
local utils = {
	set_content = ModTextFileSetContent
}

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
