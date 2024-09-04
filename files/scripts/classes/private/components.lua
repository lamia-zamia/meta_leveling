---@class ML_components_helper
local components = {}

---add value to value_name of component
---@param component component_id
---@param value_name string
---@param value number
function components:add_value_to_component(component, value_name, value)
	local current = tonumber(ComponentGetValue2(component, value_name))
	ComponentSetValue2(component, value_name, current + value)
end

---multiply value of value_name in component
---@param component component_id
---@param value_name string
---@param multiplier number
function components:multiply_value_in_component(component, value_name, multiplier)
	local current = tonumber(ComponentGetValue2(component, value_name))
	ComponentSetValue2(component, value_name, current * multiplier)
end

---add value to value_name of component object
---@param component component_id
---@param object string
---@param value_name string
---@param value number
function components:add_value_to_component_object(component, object, value_name, value)
	local current = ComponentObjectGetValue2(component, object, value_name)
	ComponentObjectSetValue2(component, object, value_name, current + value)
end

---multiply value of value_name in component object
---@param component component_id
---@param object string
---@param value_name string
---@param multiplier number
function components:multiply_value_in_component_object(component, object, value_name, multiplier)
	local current = ComponentObjectGetValue2(component, object, value_name)
	ComponentObjectSetValue2(component, object, value_name, current * multiplier)
end

---return world state component id
---@return component_id?
function components:get_world_state_component()
	local world_entity_id = GameGetWorldStateEntity()
	return EntityGetFirstComponent(world_entity_id, "WorldStateComponent")
end

return components