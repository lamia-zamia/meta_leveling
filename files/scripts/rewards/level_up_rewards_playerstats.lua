local components = dofile_once("mods/meta_leveling/files/scripts/classes/private/components.lua")
local player = dofile_once("mods/meta_leveling/files/scripts/classes/private/player.lua") --- @type ml_player
--- @type ml_rewards
local player_stats = {
	{
		id = "stats_movement_speed",
		ui_name = "$ml_slightly $perk_movement_faster",
		description = "$perkdesc_movement_faster",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/movement_speed.png",
		probability = 0.5,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("CharacterPlatformingComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "velocity_max_x", 20)
			components:add_value_to_component(component_id, "fly_velocity_x", 20)
			components:add_value_to_component(component_id, "run_velocity", 20)
		end,
	},
	{
		id = "stats_hover_speed",
		group_id = "stats_hover",
		ui_name = "$ml_hover_speed",
		description = "$ml_hover_speed_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/hover_speed.png",
		probability = 0.4,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("CharacterPlatformingComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "fly_speed_max_up", 20)
			components:add_value_to_component(component_id, "pixel_gravity", 8)
		end,
	},
	{
		id = "stats_hover_energy",
		group_id = "stats_hover",
		ui_name = "$ml_slightly $perk_hover_boost",
		description = "$ml_hover_energy_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/hover_energy.png",
		probability = 0.3,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("CharacterDataComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "fly_time_max", 1)
		end,
	},
	{
		id = "stats_hover_recharge",
		group_id = "stats_hover",
		ui_name = "$ml_hover_recharge",
		description = "$ml_hover_recharge_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/hover_recharge.png",
		probability = 0.2,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("CharacterDataComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "fly_recharge_spd", 0.1)
			components:add_value_to_component(component_id, "fly_recharge_spd_ground", 1.5)
		end,
	},
	{
		id = "stats_bigger_lungs",
		ui_name = "$ml_bigger_lungs",
		description = "$ml_bigger_lungs_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/bigger_lungs.png",
		probability = 0.3,
		custom_check = function()
			player:update()
			return not player:has_effect("BREATH_UNDERWATER")
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "air_in_lungs_max", 3)
		end,
	},
	{
		id = "stats_projectile_resistance",
		ui_name = "$ml_projectile_resistance",
		description = "$ml_projectile_resistance_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/projectile_resistance.png",
		probability = 0.2,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component_object(component_id, "damage_multipliers", "projectile", -0.1)
		end,
	},
	{
		id = "stats_explosion_resistance",
		ui_name = "$ml_explosion_resistance",
		description = "$ml_explosion_resistance_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/explosion_resistance.png",
		probability = 0.2,
		custom_check = function()
			player:update()
			return not player:has_effect("PROTECTION_EXPLOSION")
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component_object(component_id, "damage_multipliers", "explosion", -0.05)
		end,
	},
	{
		id = "stats_melee_resistance",
		ui_name = "$ml_melee_resistance",
		description = "$ml_melee_resistance_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/melee_resistance.png",
		probability = 0.2,
		custom_check = function()
			player:update()
			return not player:has_effect("PROTECTION_MELEE")
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component_object(component_id, "damage_multipliers", "melee", -0.1)
		end,
	},
	{
		id = "stats_electricity_resistance",
		ui_name = "$ml_electricity_resistance",
		description = "$ml_electricity_resistance_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/electricity_resistance.png",
		probability = 0.2,
		custom_check = function()
			player:update()
			return not player:has_effect("PROTECTION_ELECTRICITY")
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component_object(component_id, "damage_multipliers", "electricity", -0.1)
		end,
	},
	{
		id = "stats_fire_resistance",
		ui_name = "$ml_fire_resistance",
		description = "$ml_fire_resistance_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/fire_resistance.png",
		probability = 0.2,
		custom_check = function()
			player:update()
			return not player:has_effect("PROTECTION_FIRE")
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component_object(component_id, "damage_multipliers", "fire", -0.1)
		end,
	},
	{
		id = "stats_radioactive_resistance",
		ui_name = "$ml_radioactive_resistance",
		description = "$ml_radioactive_resistance_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/radioactive_resistance.png",
		probability = 0.2,
		custom_check = function()
			player:update()
			return not player:has_effect("PROTECTION_RADIOACTIVITY")
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component_object(component_id, "damage_multipliers", "radioactive", -0.1)
		end,
	},
}

local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_rewards(player_stats)
