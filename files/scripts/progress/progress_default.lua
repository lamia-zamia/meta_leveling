---@type ml_progress_point[]
local progress = {
	{
		id = "health_up",
		ui_name = "$ml_meta_starting_health",
		description = "$ml_meta_starting_health_tp",
		fn = function(count)
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			local health = 0.2 * count
			ML.utils:add_value_to_component(component_id, "max_hp", health)
			ML.utils:add_value_to_component(component_id, "hp", health)
		end,
		applied_bonus = function(count)
			return "+" .. 5 * count .. " $ml_simple_extra_health"
		end,
		stack = 20,
		price_multiplier = 1.1,
	},
	{
		id = "exp_multiplier",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_tp",
		description_var = { "5%" },
		fn = function(count)
			ML.utils:add_to_global_number(ML.const.globals.exp_multiplier, 0.05 * count)
		end,
		applied_bonus = function(count)
			return "+" .. 5 * count .. "%"
		end,
		stack = 20,
		price_multiplier = 1.25,
	},
	{
		id = "exp_trick_experience",
		ui_name = "$ml_more_experience_trick",
		description = "$ml_more_experience_trick_tp",
		description_var = { "5%" },
		fn = function(count)
			ML.utils:add_to_global_number(ML.const.globals.exp_trick, 0.05 * count)
		end,
		applied_bonus = function(count)
			return "+" .. 5 * count .. "%"
		end,
		stack = 15,
		price = 3,
		price_multiplier = 1.25,
	},
	{
		id = "exp_trick_betray",
		ui_name = "$ml_more_experience_betray",
		description = "$ml_more_more_experience_betray_tp",
		fn = function(count)
			ML.utils:add_to_global_number(ML.const.globals.exp_betray, 0.25 * count)
		end,
		applied_bonus = function(count)
			return "+" .. 25 * count .. "%"
		end,
		stack = 15,
		price = 5,
		price_multiplier = 1.5,
	},
	{
		id = "movement_speed",
		ui_name = "$perk_movement_faster",
		description = "$perkdesc_movement_faster",
		fn = function(count)
			local component_id = ML.player:get_component_by_name("CharacterPlatformingComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "velocity_max_x", 5 * count)
			ML.utils:add_value_to_component(component_id, "fly_velocity_x", 5 * count)
			ML.utils:add_value_to_component(component_id, "run_velocity", 5 * count)
		end,
		applied_bonus = function(count)
			return "+" .. 5 * count
		end,
		stack = 20,
		price = 2,
		price_multiplier = 1.2
	},
	{
		id = "extra_reward_choice",
		ui_name = "$ml_extra_reward_choice",
		description = "$ml_meta_extra_reward_choice_tp",
		fn = function(count)
			ML.utils:add_to_global_number(ML.const.globals.draw_amount, count)
		end,
		applied_bonus = function(count)
			return "+" .. count
		end,
		stack = 3,
		price = 50,
		price_multiplier = 2
	},
	-- {
	-- 	id = "meh",
	-- 	ui_name = "Whatever",
	-- 	fn = function()
	-- 		-- print("kek")
	-- 	end,
	-- 	stack = 30,
	-- }
}


ML.meta:append_points(progress)
