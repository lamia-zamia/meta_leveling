local components = dofile_once("mods/meta_leveling/files/scripts/classes/private/components.lua")
local const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua")
local player = dofile_once("mods/meta_leveling/files/scripts/classes/private/player.lua") --- @type ml_player
local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua") --- @type rewards_deck
---@type ml_rewards
local health_rewards = {
	{
		id = "health_extra_health1",
		group_id = "health_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.8,
		max = 3,
		description_var = { "25" },
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "max_hp", 1)
		end
	},
	{
		id = "health_extra_health2",
		group_id = "health_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.5,
		description_var = { "50" },
		max = 5,
		limit_before = "health_extra_health1",
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "max_hp", 2)
		end
	},
	{
		id = "health_extra_health3",
		group_id = "health_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.3,
		description_var = { "100" },
		limit_before = "health_extra_health2",
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "max_hp", 4)
		end
	},
	{
		id = "health_extra_health_perc1",
		group_id = "health_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.3,
		description_var = { "10%" },
		max = 5,
		limit_before = "health_extra_health2",
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:multiply_value_in_component(component_id, "max_hp", 1.1)
		end
	},
	{
		id = "health_extra_health_perc2",
		group_id = "health_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.3,
		description_var = { "25%" },
		limit_before = "health_extra_health_perc1",
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:multiply_value_in_component(component_id, "max_hp", 1.25)
		end
	},
	{
		id = "health_heal_con1",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			player:update()
			return player.absent_hp_percent + 0.1
		end,
		border_color = rewards_deck.borders.common,
		max = 3,
		description_var = { "75" },
		custom_check = function()
			player:update()
			return player.absent_hp_percent > 0.1
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "hp", 3)
		end
	},
	{
		id = "health_heal_con2",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			player:update()
			return player.absent_hp_percent + 0.1
		end,
		border_color = rewards_deck.borders.common,
		max = 3,
		description_var = { "150" },
		limit_before = "health_heal_con1",
		custom_check = function()
			player:update()
			return player.absent_hp_percent > 0.1
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "hp", 6)
		end
	},
	{
		id = "health_heal_con3",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			player:update()
			return player.absent_hp_percent + 0.1
		end,
		border_color = rewards_deck.borders.common,
		description_var = { "300" },
		limit_before = "health_heal_con2",
		custom_check = function()
			player:update()
			return player.absent_hp_percent > 0.1
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "hp", 12)
		end
	},
	{
		id = "health_heal_perc1",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			player:update()
			return player.absent_hp_percent + 0.1
		end,
		border_color = rewards_deck.borders.uncommon,
		description_var = { "50 + 10%" },
		max = 3,
		min_level = 10,
		custom_check = function()
			player:update()
			return player.absent_hp_percent > 0.1
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			local value = ComponentGetValue2(component_id, "max_hp")
			components:add_value_to_component(component_id, "hp", 2 + (value * 0.1))
		end
	},
	{
		id = "health_heal_perc2",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			player:update()
			return player.absent_hp_percent + 0.1
		end,
		border_color = rewards_deck.borders.uncommon,
		description_var = { "100 + 25%" },
		limit_before = "health_heal_perc1",
		custom_check = function()
			player:update()
			return player.absent_hp_percent > 0.1
		end,
		fn = function()
			player:update()
			local component_id = player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			local value = ComponentGetValue2(component_id, "max_hp")
			components:add_value_to_component(component_id, "hp", 4 + (value * 0.25))
		end
	},
}

for i = 1, #health_rewards do
	health_rewards[i].sound = const.sounds.heart
end

rewards_deck:add_rewards(health_rewards)
