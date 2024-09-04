---@type MetaLevelingPublic
MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
local elemental = {
	"electricity", "fire", "ice", "radioactive", "poison", "curse", "holy"
}

---@type script_shot
function shot(projectile_entity_id)
	local projectile_component = EntityGetFirstComponentIncludingDisabled(projectile_entity_id, "ProjectileComponent")
	if not projectile_component then return end

	-- Crit
	local crit_chance_add = MLP.get:global_number(MLP.const.globals.crit_chance_increase, 0)
	if crit_chance_add > 0 then
		ML.utils:add_value_to_component_object(projectile_component, "damage_critical", "chance", crit_chance_add)
	end

	-- Projectile
	local projectile_multiplier = MLP.get:global_number(MLP.const.globals.projectile_damage_increase, 1)
	if projectile_multiplier > 1 then
		ML.utils:multiply_value_in_component(projectile_component, "damage", projectile_multiplier)
	end

	-- Elemental
	local elemental_multiplier = MLP.get:global_number(MLP.const.globals.elemental_damage_increase, 1)
	if elemental_multiplier > 1 then
		for _, type in ipairs(elemental) do
			local current = ComponentObjectGetValue2(projectile_component, "damage_by_type", type)
			if current > 0 then
				local new_damage = (current + elemental_multiplier / 25) * elemental_multiplier
				ComponentObjectSetValue2(projectile_component, "damage_by_type", type, new_damage)
			end
		end
	end

	-- drills
	local drill_damage = ComponentObjectGetValue2(projectile_component, "damage_by_type", "drill")
	if drill_damage > 0 then
		-- damage
		local damage_value = MLP.get:global_number(MLP.const.globals.drill_damage_increase, 0)
		if damage_value > 0 then
			ComponentSetValue2(projectile_component, "collide_with_tag", "hittable")
			ComponentObjectSetValue2(projectile_component, "damage_by_type", "drill", drill_damage + damage_value)
		end

		-- destructability
		local increment = MLP.get:global_number(MLP.const.globals.drill_destructibility, 0)
		if increment > 0 then
				ML.utils:add_value_to_component_object(projectile_component, "config_explosion",
					"max_durability_to_destroy", increment)
				ML.utils:add_value_to_component_object(projectile_component, "config_explosion", "ray_energy",
					100000 * increment)
				ML.utils:add_value_to_component_object(projectile_component, "config_explosion", "explosion_radius",
					increment)
		end
	end
end
