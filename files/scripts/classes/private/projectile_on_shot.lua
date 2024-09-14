---@type ML_components_helper
local component = dofile_once("mods/meta_leveling/files/scripts/classes/private/components.lua")

local elemental = {
	"electricity", "fire", "ice", "radioactive", "poison", "curse", "holy"
}

---@class ml_projectile_on_shot
---@field private __index ml_projectile_on_shot
---@field proj_comp component_id
local POS = {}
POS.__index = POS

---A new projectile
---@param projectile_component component_id
---@return ml_projectile_on_shot projectile A new instance of the StringManip class.
---@nodiscard
function POS:new(projectile_component)
	local o = setmetatable({}, self)
	o.proj_comp = projectile_component
	return o
end

---Increase critical chance of projectile
---@param value number
function POS:increase_critical_chance(value)
	component:add_value_to_component_object(self.proj_comp, "damage_critical", "chance", value)
end

---Multiplies projectile damage by value
---@param value number
function POS:projectile_damage_multiply(value)
	component:multiply_value_in_component(self.proj_comp, "damage", value)
end

---Increases elemental damages
---@param value number
function POS:projectile_elemental_increase(value)
	for i = 1, #elemental do
		local current = ComponentObjectGetValue2(self.proj_comp, "damage_by_type", elemental[i])
		if current > 0 then
			local new_damage = (current + value / 25) * value
			ComponentObjectSetValue2(self.proj_comp, "damage_by_type", elemental[i], new_damage)
		end
	end
end

---Returns true if projectile is true
---@return boolean
function POS:projectile_is_drill()
	local drill_damage = ComponentObjectGetValue2(self.proj_comp, "damage_by_type", "drill")
	return drill_damage > 0
end

---Increase damage of drills
---@param value number
function POS:drill_increase_damage(value)
	local drill_damage = ComponentObjectGetValue2(self.proj_comp, "damage_by_type", "drill")
	ComponentSetValue2(self.proj_comp, "collide_with_tag", "hittable")
	ComponentObjectSetValue2(self.proj_comp, "damage_by_type", "drill", drill_damage + value)
end

---Increase destructability of drills
---@param value number
function POS:drill_increase_destruction(value)
	component:add_value_to_component_object(self.proj_comp, "config_explosion",
		"max_durability_to_destroy", value)
	component:add_value_to_component_object(self.proj_comp, "config_explosion", "ray_energy",
		100000 * value)
	component:add_value_to_component_object(self.proj_comp, "config_explosion", "explosion_radius",
		value)
end

---Destroys the current instance by clearing its fields.
function POS:destroy()
	self.proj_comp = nil
	setmetatable(self, nil)
end

return POS
