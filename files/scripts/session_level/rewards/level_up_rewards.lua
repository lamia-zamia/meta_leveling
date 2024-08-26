---@type ml_rewards
local reward_list = {
	{
		id = "extra_reward_choice1",
		group_id = "extra_reward_choice",
		ui_name = "$ml_extra_reward_choice",
		description = "$ml_extra_reward_choice_tp",
		description_var = { "1" },
		description2 = "$ml_extra_reward_choice_clarify",
		description2_var = { function()
			return ML.utils:get_global_number(ML.const.globals.draw_amount, 0) + 1
		end },
		ui_icon = "mods/meta_leveling/files/gfx/rewards/extra_reward_choice.png",
		probability = 0.5,
		max = 4,
		min_level = 5,
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.draw_amount, 1)
			for _ = 1, ML.utils:get_global_number(ML.const.globals.draw_amount, 0) do
				ML:level_up()
			end
		end
	},
	{
		id = "extra_reward_choice2",
		group_id = "extra_reward_choice",
		ui_name = "$ml_extra_reward_choice",
		description = "$ml_extra_reward_choice_tp",
		description_var = { "2" },
		description2 = "$ml_extra_reward_choice_clarify",
		description2_var = { function()
			return ML.utils:get_global_number(ML.const.globals.draw_amount, 0) + 2
		end },
		ui_icon = "mods/meta_leveling/files/gfx/rewards/extra_reward_choice.png",
		probability = 0.2,
		max = 2,
		limit_before = "extra_reward_choice1",
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.draw_amount, 2)
			for _ = 1, ML.utils:get_global_number(ML.const.globals.draw_amount, 0) do
				ML:level_up()
			end
		end
	},
	{
		id = "gold_add1",
		group_id = "gold_add",
		ui_name = "$ml_add_gold",
		description = "$ml_add_gold_tp",
		description_var = { "400" },
		probability = 0.8,
		ui_icon = "data/ui_gfx/items/goldnugget.png",
		max = 3,
		sound = ML.const.sounds.shop_item,
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "money", 200)
		end
	},
	{
		id = "gold_add2",
		group_id = "gold_add",
		ui_name = "$ml_add_gold",
		description = "$ml_add_gold_tp",
		description_var = { "1600" },
		probability = 0.5,
		ui_icon = "data/ui_gfx/items/goldnugget.png",
		max = 3,
		sound = ML.const.sounds.shop_item,
		limit_before = "gold_add1",
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "money", 1000)
		end
	},
	{
		id = "gold_add3",
		group_id = "gold_add",
		ui_name = "$ml_add_gold",
		description = "$ml_add_gold_tp",
		description_var = { "5000" },
		probability = 0.5,
		ui_icon = "data/ui_gfx/items/goldnugget.png",
		sound = ML.const.sounds.shop_item,
		limit_before = "gold_add2",
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "money", 5000)
		end
	},
	{
		id = "gold_bloody_money",
		ui_name = "$ml_bloody_money",
		description = "$ml_bloody_money_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/bloody_money.xml",
		probability = 0.01,
		min_level = 20,
		max = 3,
		fn = function()
			local comp_worldstate = ML.utils:get_world_state_component()
			if not comp_worldstate then return end
			ML.utils:add_value_to_component(comp_worldstate, "perk_hp_drop_chance", 20)
		end
	},
	{
		id = "permanent_light1",
		group_id = "permanent_light",
		ui_name = "$ml_permanent_light",
		description = "$ml_permanent_light_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/permanent_light.xml",
		probability = 0.5,
		max = 1,
		fn = function()
			local entity_id = EntityLoad("mods/meta_leveling/files/entities/permanent_light.xml")
			EntityAddChild(ML.player.id, entity_id)
		end
	},
	{
		id = "permanent_light2",
		group_id = "permanent_light",
		ui_name = "$ml_permanent_light",
		description = "$ml_permanent_light_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/permanent_light.xml",
		probability = 0.5,
		max = 3,
		description_var = { "$ml_radius" },
		limit_before = "permanent_light1",
		fn = function()
			local entity_id = EntityGetWithName("ml_permanent_light")
			local comp_id = EntityGetFirstComponent(entity_id, "SpriteComponent")
			if not comp_id then return end
			ML.utils:add_value_to_component(comp_id, "special_scale_x", 2)
			ML.utils:add_value_to_component(comp_id, "special_scale_y", 2)
		end
	},
	{
		id = "permanent_light3",
		group_id = "permanent_light",
		ui_name = "$ml_permanent_light",
		description = "$ml_permanent_light_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/permanent_light.xml",
		probability = 0.5,
		max = 2,
		description_var = { "$ml_brightness" },
		limit_before = "permanent_light1",
		fn = function()
			local entity_id = EntityGetWithName("ml_permanent_light")
			local comp_id = EntityGetFirstComponent(entity_id, "SpriteComponent")
			if not comp_id then return end
			ML.utils:add_value_to_component(comp_id, "alpha", 0.1)
		end
	},
	{
		id = "gods_peace_with_gods",
		group_id = "gods",
		ui_name = "$ml_peace_with_gods",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/peace_with_gods.xml",
		description = "$ml_peace_with_gods_tp",
		probability = 0.3,
		custom_check = function()
			return GlobalsGetValue("TEMPLE_SPAWN_GUARDIAN", "0") ~= "0" and
				GlobalsGetValue("TEMPLE_PEACE_WITH_GODS", "0") == "0"
		end,
		fn = function()
			GlobalsSetValue("TEMPLE_SPAWN_GUARDIAN", "0")
			GamePrintImportant("$ml_piece_with_gods_message1", "$ml_piece_with_gods_message2")
			local steves = EntityGetWithTag("necromancer_shop")
			if steves then
				for _, entity_steve in ipairs(steves) do
					GetGameEffectLoadTo(entity_steve, "CHARM", true)
				end
			end
		end
	},
	{
		id = "gods_forgetful_gods",
		group_id = "gods",
		ui_name = "$ml_forgetful_gods",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/peace_with_gods.xml",
		description = "$ml_forgetful_gods_tp",
		probability = 0.3,
		custom_check = function()
			return GlobalsGetValue("STEVARI_DEATHS", "0") ~= "0"
		end,
		fn = function()
			GlobalsSetValue("STEVARI_DEATHS", "0")
			GamePrintImportant("$ml_piece_with_gods_message1", "$ml_piece_with_gods_message2")
		end
	},
	{
		id = "more_experience1",
		group_id = "more_experience",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp.xml",
		description_var = { "10%" },
		probability = 0.5,
		max = 5,
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_multiplier, 0.1)
		end
	},
	{
		id = "more_experience2",
		group_id = "more_experience",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp.xml",
		description_var = { "25%" },
		probability = 0.3,
		max = 4,
		limit_before = "more_experience1",
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_multiplier, 0.25)
		end
	},
	{
		id = "more_experience3",
		group_id = "more_experience",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp.xml",
		description_var = { "50%" },
		probability = 0.1,
		limit_before = "more_experience2",
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_multiplier, 0.5)
		end
	},
	{
		id = "more_experience_con",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_const.xml",
		description_var = { "+1" },
		probability = 0.1,
		max = 5,
		min_level = 5,
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_const, 1)
		end
	},
	{
		id = "more_experience_trick1",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		description_var = { "25%" },
		probability = 0.3,
		max = 3,
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_trick, 0.25)
		end
	},
	{
		id = "more_experience_trick2",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		description_var = { "50%" },
		probability = 0.2,
		max = 2,
		limit_before = "more_experience_trick1",
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_trick, 0.5)
		end
	},
	{
		id = "more_experience_trick3",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		description_var = { "100%" },
		probability = 0.1,
		limit_before = "more_experience_trick1",
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_trick, 1.0)
		end
	},
	{
		id = "more_experience_betray1",
		group_id = "more_experience_betray",
		ui_name = "$ml_more_experience_betray",
		description = "$ml_more_experience_betray_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_betray.xml",
		probability = 0.3,
		max = 1,
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_betray, 0.25)
		end
	},
	{
		id = "more_experience_betray2",
		group_id = "more_experience_betray",
		ui_name = "$ml_more_more_experience_betray",
		description = "$ml_more_more_experience_betray_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_betray.xml",
		probability = 0.1,
		limit_before = "more_experience_betray1",
		fn = function()
			ML.utils:add_to_global_number(ML.const.globals.exp_betray, 0.25)
		end
	},
	{
		id = "more_love",
		ui_name = "$ml_slightly $perk_genome_more_love",
		description = "$perkdesc_genome_more_love",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_love.png",
		probability = 0.3,
		custom_check = function()
			local comp_id = ML.utils:get_world_state_component()
			if not comp_id then return end
			return ComponentGetValue2(comp_id, "global_genome_relations_modifier") < 100
		end,
		fn = function()
			local comp_id = ML.utils:get_world_state_component()
			if not comp_id then return end
			ML.utils:add_value_to_component(comp_id, "global_genome_relations_modifier", 10)
		end
	},
	{
		id = "more_hatred",
		ui_name = "$ml_slightly $perk_genome_more_hatred",
		description = "$perkdesc_genome_more_hatred",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_hatred.png",
		probability = 0.3,
		custom_check = function()
			local comp_id = ML.utils:get_world_state_component()
			if not comp_id then return end
			return ComponentGetValue2(comp_id, "global_genome_relations_modifier") > -100
		end,
		fn = function()
			local comp_id = ML.utils:get_world_state_component()
			if not comp_id then return end
			ML.utils:add_value_to_component(comp_id, "global_genome_relations_modifier", -10)
		end
	},
	{
		id = "buff_permanent_concentrated_mana",
		ui_name = "$ml_permanent_concentrated_mana",
		description = "$ml_permanent_concentrated_mana_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/permanent_concentrated_mana.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_source_file", ML.const.files.mana_regen)
			ML.utils:add_to_global_number(ML.const.globals.permanent_concentrated_mana, 0.25)
		end
	},
	{
		id = "buff_damage_projectile_damage_increase",
		ui_name = "$ml_projectile_damage_increase",
		description = "$ml_projectile_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/projectile_damage.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number(ML.const.globals.projectile_damage_increase, 0.1, 1)
		end
	},
	{
		id = "buff_damage_elemental_damage_increase",
		ui_name = "$ml_elemental_damage_increase",
		description = "$ml_elemental_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/elemental_damage.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number(ML.const.globals.elemental_damage_increase, 0.3, 1)
		end
	},
	{
		id = "buff_damage_drill_damage_increase",
		ui_name = "$ml_drill_damage_increase",
		description = "$ml_drill_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/drill_damage.xml",
		probability = 0.1,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number(ML.const.globals.drill_damage_increase, 0.4)
		end
	},
	{
		id = "buff_damage_crit_chance_increase",
		ui_name = "$action_critical_hit",
		description = "$actiondesc_critical_hit",
		ui_icon = "data/ui_gfx/gun_actions/critical_hit.png",
		probability = 0.1,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number(ML.const.globals.crit_chance_increase, 15)
		end
	},
	{
		id = "buff_damage_drill_destructibility_increase",
		ui_name = "$ml_drill_destructibility_increase",
		description = "$ml_drill_destructibility_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/drill_destructibility.xml",
		probability = 0.1,
		max = 3,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number(ML.const.globals.drill_destructibility, 1)
		end
	},
	{
		id = "force_fungal_shift",
		ui_name = "$ml_force_fungal_shift",
		description = "$ml_force_fungal_shift_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/fungal_shift.xml",
		probability = 0.1,
		fn = function()
			ML.rewards:force_fungal_shift()
		end
	},
}

return reward_list
