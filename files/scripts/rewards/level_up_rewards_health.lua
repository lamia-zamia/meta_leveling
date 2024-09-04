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
		sound = MLP.const.sounds.heart,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "max_hp", 1)
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
		sound = MLP.const.sounds.heart,
		limit_before = "health_extra_health1",
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "max_hp", 2)
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
		sound = MLP.const.sounds.heart,
		limit_before = "health_extra_health2",
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "max_hp", 4)
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
		sound = MLP.const.sounds.heart,
		limit_before = "health_extra_health2",
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:multiply_value_in_component(component_id, "max_hp", 1.1)
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
		sound = MLP.const.sounds.heart,
		limit_before = "health_extra_health_perc1",
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:multiply_value_in_component(component_id, "max_hp", 1.25)
		end
	},
	{
		id = "health_heal_con1",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			return ML.player.absent_hp_percent + 0.1
		end,
		max = 3,
		description_var = { "75" },
		sound = MLP.const.sounds.heart,
		custom_check = function()
			return ML.player.absent_hp_percent > 0.1
		end,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "hp", 3)
		end
	},
	{
		id = "health_heal_con2",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			return ML.player.absent_hp_percent + 0.1
		end,
		max = 3,
		description_var = { "150" },
		limit_before = "health_heal_con1",
		sound = MLP.const.sounds.heart,
		custom_check = function()
			return ML.player.absent_hp_percent > 0.1
		end,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "hp", 6)
		end
	},
	{
		id = "health_heal_con3",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			return ML.player.absent_hp_percent + 0.1
		end,
		description_var = { "300" },
		limit_before = "health_heal_con2",
		sound = MLP.const.sounds.heart,
		custom_check = function()
			return ML.player.absent_hp_percent > 0.1
		end,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "hp", 12)
		end
	},
	{
		id = "health_heal_perc1",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			return ML.player.absent_hp_percent + 0.1
		end,
		description_var = { "50 + 10%" },
		max = 3,
		min_level = 10,
		sound = MLP.const.sounds.heart,
		custom_check = function()
			return ML.player.absent_hp_percent > 0.1
		end,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			local value = ComponentGetValue2(component_id, "max_hp")
			ML.utils:add_value_to_component(component_id, "hp", 2 + (value * 0.1))
		end
	},
	{
		id = "health_heal_perc2",
		group_id = "health_heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = function()
			return ML.player.absent_hp_percent + 0.1
		end,
		description_var = { "100 + 25%" },
		limit_before = "health_heal_perc1",
		sound = MLP.const.sounds.heart,
		custom_check = function()
			return ML.player.absent_hp_percent > 0.1
		end,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			local value = ComponentGetValue2(component_id, "max_hp")
			ML.utils:add_value_to_component(component_id, "hp", 4 + (value * 0.25))
		end
	},
}

ML.rewards_deck:add_rewards(health_rewards)
