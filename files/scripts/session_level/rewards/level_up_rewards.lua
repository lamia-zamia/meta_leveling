---@type ml_reward_definition_list
local reward_list = {
	{
		id = "simple_extra_health1",
		group_id = "simple_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.8,
		max = 3,
		var0 = 25,
		sound = ML.const.sounds.heart,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "max_hp", 1)
		end
	},
	{
		id = "simple_extra_health2",
		group_id = "simple_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.5,
		var0 = 50,
		max = 5,
		sound = ML.const.sounds.heart,
		limit_before = "simple_extra_health1",
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "max_hp", 2)
		end
	},
	{
		id = "simple_extra_health3",
		group_id = "simple_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.3,
		var0 = 100,
		sound = ML.const.sounds.heart,
		limit_before = "simple_extra_health2",
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "max_hp", 4)
		end
	},
	{
		id = "extra_health_perc1",
		group_id = "simple_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.3,
		var0 = "10%",
		max = 5,
		sound = ML.const.sounds.heart,
		limit_before = "simple_extra_health2",
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:multiply_value_in_component(component_id, "max_hp", 1.1)
		end
	},
	{
		id = "extra_health_perc2",
		group_id = "simple_extra_health",
		ui_name = "$ml_simple_extra_health",
		description = "$ml_simple_extra_health_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/simple_extra_health.xml",
		probability = 0.3,
		var0 = "25%",
		sound = ML.const.sounds.heart,
		limit_before = "extra_health_perc1",
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:multiply_value_in_component(component_id, "max_hp", 1.25)
		end
	},
	{
		id = "heal_con1",
		group_id = "heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = 0.8,
		max = 3,
		var0 = 75,
		sound = ML.const.sounds.heart,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "hp", 3)
		end
	},
	{
		id = "heal_con2",
		group_id = "heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = 0.8,
		max = 3,
		var0 = 150,
		limit_before = "heal_con1",
		sound = ML.const.sounds.heart,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "hp", 6)
		end
	},
	{
		id = "heal_con3",
		group_id = "heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = 0.8,
		var0 = 300,
		limit_before = "heal_con2",
		sound = ML.const.sounds.heart,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "hp", 12)
		end
	},
	{
		id = "heal_perc1",
		group_id = "heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = 0.8,
		var0 = "50 + 10%",
		max = 3,
		min_level = 10,
		sound = ML.const.sounds.heart,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			local value = ComponentGetValue2(component_id, "max_hp")
			ML.utils:add_value_to_component(component_id, "hp", 2 + (value * 0.1))
		end
	},
	{
		id = "heal_perc2",
		group_id = "heal",
		ui_name = "$ml_heal_con",
		description = "$ml_heal_con_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/heal.xml",
		probability = 0.8,
		var0 = "100 + 25%",
		limit_before = "heal_perc1",
		sound = ML.const.sounds.heart,
		fn = function()
			local component_id = ML.player:get_component_by_name("DamageModelComponent")
			if not component_id then return end
			local value = ComponentGetValue2(component_id, "max_hp")
			ML.utils:add_value_to_component(component_id, "hp", 4 + (value * 0.25))
		end
	},
	{
		id = "extra_reward_choice1",
		group_id = "extra_reward_choice",
		ui_name = "$ml_extra_reward_choice",
		description = "$ml_extra_reward_choice_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/extra_reward_choice.png",
		probability = 0.5,
		var0 = 1,
		max = 4,
		min_level = 5,
		fn = function()
			ML.utils:add_to_global_number("DRAW_AMOUNT", 1)
			for _=1, ML.utils:get_global_number("DRAW_AMOUNT", 0) do
				ML:level_up()
			end
		end
	},
	{
		id = "extra_reward_choice2",
		group_id = "extra_reward_choice",
		ui_name = "$ml_extra_reward_choice",
		description = "$ml_extra_reward_choice_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/extra_reward_choice.png",
		probability = 0.2,
		var0 = 2,
		max = 2,
		limit_before = "extra_reward_choice1",
		fn = function()
			ML.utils:add_to_global_number("DRAW_AMOUNT", 2)
			for _=1, ML.utils:get_global_number("DRAW_AMOUNT", 0) do
				ML:level_up()
			end
		end
	},
	{
		id = "add_gold1",
		group_id = "add_gold",
		ui_name = "$ml_add_gold",
		description = "$ml_add_gold_tp",
		probability = 0.8,
		ui_icon = "data/ui_gfx/items/goldnugget.png",
		max = 3,
		var0 = 400,
		sound = ML.const.sounds.shop_item,
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "money", 200)
		end
	},
	{
		id = "add_gold2",
		group_id = "add_gold",
		ui_name = "$ml_add_gold",
		description = "$ml_add_gold_tp",
		probability = 0.5,
		ui_icon = "data/ui_gfx/items/goldnugget.png",
		max = 3,
		var0 = 1600,
		sound = ML.const.sounds.shop_item,
		limit_before = "add_gold1",
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "money", 1000)
		end
	},
	{
		id = "add_gold3",
		group_id = "add_gold",
		ui_name = "$ml_add_gold",
		description = "$ml_add_gold_tp",
		probability = 0.5,
		ui_icon = "data/ui_gfx/items/goldnugget.png",
		var0 = 5000,
		sound = ML.const.sounds.shop_item,
		limit_before = "add_gold2",
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			ML.utils:add_value_to_component(component_id, "money", 5000)
		end
	},
	{
		id = "bloody_money",
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
		var0 = "$ml_radius",
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
		var0 = "$ml_brightness",
		limit_before = "permanent_light1",
		fn = function()
			local entity_id = EntityGetWithName("ml_permanent_light")
			local comp_id = EntityGetFirstComponent(entity_id, "SpriteComponent")
			if not comp_id then return end
			ML.utils:add_value_to_component(comp_id, "alpha", 0.1)
		end
	},
	{
		id = "peace_with_gods",
		group_id = "gods",
		ui_name = "$ml_peace_with_gods",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/peace_with_gods.xml",
		description = "$ml_peace_with_gods_tp",
		probability = 0.3,
		custom_check = function()
			return GlobalsGetValue("TEMPLE_SPAWN_GUARDIAN", "0") ~= "0"
		end,
		fn = function()
			GlobalsSetValue("TEMPLE_SPAWN_GUARDIAN", "0")
			GamePrintImportant("$ml_piece_with_gods_message1", "$ml_piece_with_gods_message2")
		end
	},
	{
		id = "forgetful_gods",
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
		var0 = "10%",
		probability = 0.5,
		max = 5,
		fn = function()
			ML.utils:add_to_global_number("EXP_MULTIPLIER", 0.1)
		end
	},
	{
		id = "more_experience2",
		group_id = "more_experience",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp.xml",
		var0 = "25%",
		probability = 0.3,
		max = 4,
		limit_before = "more_experience1",
		fn = function()
			ML.utils:add_to_global_number("EXP_MULTIPLIER", 0.25)
		end
	},
	{
		id = "more_experience3",
		group_id = "more_experience",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp.xml",
		var0 = "50%",
		probability = 0.1,
		limit_before = "more_experience2",
		fn = function()
			ML.utils:add_to_global_number("EXP_MULTIPLIER", 0.5)
		end
	},
	{
		id = "more_experience_con",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_const.xml",
		var0 = "1",
		probability = 0.1,
		max = 5,
		min_level = 5,
		fn = function()
			ML.utils:add_to_global_number("EXP_CONST", 1)
		end
	},
	{
		id = "more_experience_trick1",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		var0 = "25%",
		probability = 0.3,
		max = 2,
		fn = function()
			ML.utils:add_to_global_number("EXP_MULTIPLIER_TRICK", 0.25)
		end
	},
	{
		id = "more_experience_trick2",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		var0 = "50%",
		probability = 0.2,
		max = 3,
		limit_before = "more_experience_trick1",
		fn = function()
			ML.utils:add_to_global_number("EXP_MULTIPLIER_TRICK", 0.5)
		end
	},
	{
		id = "more_experience_trick3",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		var0 = "100%",
		probability = 0.1,
		limit_before = "more_experience_trick1",
		fn = function()
			ML.utils:add_to_global_number("EXP_MULTIPLIER_TRICK", 1.0)
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
			ML.utils:add_to_global_number("EXP_MULTIPLIER_BETRAY", 0.25)
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
			ML.utils:add_to_global_number("EXP_MULTIPLIER_BETRAY", 0.25)
		end
	},
	{
		id = "more_love",
		ui_name = "$perk_genome_more_love",
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
		ui_name = "$perk_genome_more_hatred",
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
		id = "permanent_concentrated_mana",
		ui_name = "$ml_permanent_concentrated_mana",
		description = "$ml_permanent_concentrated_mana_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/permanent_concentrated_mana.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_source_file", ML.const.files.mana_regen)
			ML.utils:add_to_global_number("permanent_concentrated_mana", 0.25)
		end
	},
	{
		id = "projectile_damage_increase",
		ui_name = "$ml_projectile_damage_increase",
		description = "$ml_projectile_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/projectile_damage.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number("projectile_damage_increase", 0.1, 1)
		end
	},
	{
		id = "elemental_damage_increase",
		ui_name = "$ml_elemental_damage_increase",
		description = "$ml_elemental_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/elemental_damage.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number("elemental_damage_increase", 0.3, 1)
		end
	},
	{
		id = "drill_damage_increase",
		ui_name = "$ml_drill_damage_increase",
		description = "$ml_drill_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/drill_damage.xml",
		probability = 0.1,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number("drill_damage_increase", 0.4)
		end
	},
	{
		id = "crit_chance_increase",
		ui_name = "$action_critical_hit",
		description = "$actiondesc_critical_hit",
		ui_icon = "data/ui_gfx/gun_actions/critical_hit.png",
		probability = 0.1,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number("crit_chance_increase", 15)
		end
	},
	{
		id = "drill_destructibility_increase",
		ui_name = "$ml_drill_destructibility_increase",
		description = "$ml_drill_destructibility_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/drill_destructibility.xml",
		probability = 0.1,
		max = 3,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", ML.const.files.shot_damage)
			ML.utils:add_to_global_number("drill_destructibility_increase", 1)
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
