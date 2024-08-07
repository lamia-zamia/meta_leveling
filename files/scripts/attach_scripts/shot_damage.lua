---@type meta_leveling
ML = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling.lua")
local elemental = {
	"electricity", "fire", "ice", "radioactive", "poison", "curse", "holy"
}

function shot(projectile_entity_id)
	local projectile_component = EntityGetFirstComponentIncludingDisabled(projectile_entity_id, "ProjectileComponent")
	if not projectile_component then return end

	-- crit
	local crit_chance_add = ML.utils:get_global_number("crit_chance_increase", 0)
	ML.utils:add_value_to_component_object(projectile_component, "damage_critical", "chance", crit_chance_add)

	-- projectile
	local projectile_multiplier = ML.utils:get_global_number("projectile_damage_increase", 1)
	ML.utils:multiply_value_in_component(projectile_component, "damage", projectile_multiplier)

	--	elemental
	local elemental_multiplier = ML.utils:get_global_number("elemental_damage_increase", 1)
	for _, type in pairs(elemental) do
		ML.utils:multiply_value_in_component_object(projectile_component, "damage_by_type", type, elemental_multiplier)
	end

	-- drills
	local drill_damage = ComponentObjectGetValue2(projectile_component, "damage_by_type", "drill")
	if drill_damage > 0 then
		local damage_value = ML.utils:get_global_number("drill_damage_increase", 0)
		if damage_value > 0 then --damage
			ComponentSetValue2(projectile_component, "collide_with_tag", "hittable")
			ComponentObjectSetValue2(projectile_component, "damage_by_type", "drill", drill_damage + damage_value)
		end
		local increment = ML.utils:get_global_number("drill_destructibility_increase", 0)
		if increment > 0 then --DESTRUCT
			local max_durability_to_destroy = ComponentObjectGetValue2(projectile_component, "config_explosion", "max_durability_to_destroy")
			if max_durability_to_destroy then
				ML.utils:add_value_to_component_object(projectile_component, "config_explosion", "max_durability_to_destroy", increment)
				ML.utils:add_value_to_component_object(projectile_component, "config_explosion", "ray_energy", 100000 * increment)
				ML.utils:add_value_to_component_object(projectile_component, "config_explosion", "explosion_radius", increment)
			end
		end
	end
end
