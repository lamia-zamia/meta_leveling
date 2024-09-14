---@type MetaLevelingPublic
local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
---@type ml_projectile_on_shot
local POS = dofile_once("mods/meta_leveling/files/scripts/classes/private/projectile_on_shot.lua")

---@type script_shot
local script_shot = function(projectile_entity_id)
	local projectile_component = EntityGetFirstComponentIncludingDisabled(projectile_entity_id, "ProjectileComponent")
	if not projectile_component then return end
	local projectile = POS:new(projectile_component)

	-- Crit
	local crit_chance_add = MLP.get:global_number(MLP.const.globals.crit_chance_increase, 0)
	if crit_chance_add > 0 then
		projectile:increase_critical_chance(crit_chance_add)
	end

	-- Projectile
	local projectile_multiplier = MLP.get:global_number(MLP.const.globals.projectile_damage_increase, 1)
	if projectile_multiplier > 1 then
		projectile:projectile_damage_multiply(projectile_multiplier)
	end

	-- Elemental
	local elemental_multiplier = MLP.get:global_number(MLP.const.globals.elemental_damage_increase, 1)
	if elemental_multiplier > 1 then
		projectile:projectile_elemental_increase(elemental_multiplier)
	end

	-- drills
	if projectile:projectile_is_drill() then
		-- damage
		local damage_value = MLP.get:global_number(MLP.const.globals.drill_damage_increase, 0)
		if damage_value > 0 then
			projectile:drill_increase_damage(damage_value)
		end
		-- destructability
		local increment = MLP.get:global_number(MLP.const.globals.drill_destructibility, 0)
		if increment > 0 then
			projectile:drill_increase_destruction(increment)
		end
	end

	-- explosions
	local explosion_radius = MLP.get:global_number(MLP.const.globals.projectile_explosion_radius, 1)
	if explosion_radius > 1 then
		projectile:increase_explosion_radius(explosion_radius)
	end
	local explosion_damage = MLP.get:global_number(MLP.const.globals.projectile_explosion_damage, 1)
	if explosion_damage > 1 then
		projectile:increase_explosion_damage(explosion_damage)
	end

	projectile:destroy()
end

shot = script_shot
