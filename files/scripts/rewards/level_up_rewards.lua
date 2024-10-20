local components = dofile_once("mods/meta_leveling/files/scripts/classes/private/components.lua") ---@type ML_components_helper
local const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua")
local rewards = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards.lua")
local get = dofile_once("mods/meta_leveling/files/scripts/classes/public/get.lua")
local player = dofile_once("mods/meta_leveling/files/scripts/classes/private/player.lua") --- @type ml_player
---@type ml_rewards
local reward_list = {
	{
		id = "extra_reward_choice1",
		group_id = "extra_reward_choice",
		ui_name = "$ml_extra_reward_choice",
		description = "$ml_extra_reward_choice_tp",
		description_var = { "1" },
		description2 = "$ml_extra_reward_choice_clarify",
		description2_var = {
			function()
				return MLP.get:global_number(MLP.const.globals.draw_amount, 0) + 1
			end,
		},
		ui_icon = "mods/meta_leveling/files/gfx/rewards/extra_reward_choice.png",
		probability = 0.5,
		max = 4,
		min_level = 5,
		fn = function()
			MLP.set:add_to_global_number(MLP.const.globals.draw_amount, 1)
			for _ = 1, MLP.get:global_number(MLP.const.globals.draw_amount, 0) do
				ML:level_up()
			end
		end,
	},
	{
		id = "extra_reward_choice2",
		group_id = "extra_reward_choice",
		ui_name = "$ml_extra_reward_choice",
		description = "$ml_extra_reward_choice_tp",
		description_var = { "2" },
		description2 = "$ml_extra_reward_choice_clarify",
		description2_var = {
			function()
				return MLP.get:global_number(MLP.const.globals.draw_amount, 0) + 2
			end,
		},
		ui_icon = "mods/meta_leveling/files/gfx/rewards/extra_reward_choice.png",
		probability = 0.2,
		max = 2,
		limit_before = "extra_reward_choice1",
		fn = function()
			MLP.set:add_to_global_number(MLP.const.globals.draw_amount, 2)
			for _ = 1, MLP.get:global_number(MLP.const.globals.draw_amount, 0) do
				ML:level_up()
			end
		end,
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
		sound = const.sounds.shop_item,
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "money", 400)
			local entity = EntityCreateNew()
			EntitySetTransform(entity, ML.player.x, ML.player.y)
			EntityAddComponent2(entity, "MagicConvertMaterialComponent", {
				from_any_material = true,
				to_material = CellFactory_GetType("gold"),
				is_circle = true,
				steps_per_frame = 1,
				radius = 10,
			})
		end,
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
		sound = const.sounds.shop_item,
		limit_before = "gold_add1",
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "money", 1600)
			local entity = EntityCreateNew()
			EntitySetTransform(entity, ML.player.x, ML.player.y)
			EntityAddComponent2(entity, "MagicConvertMaterialComponent", {
				from_any_material = true,
				to_material = CellFactory_GetType("gold"),
				is_circle = true,
				steps_per_frame = 1,
				radius = 15,
			})
		end,
	},
	{
		id = "gold_add3",
		group_id = "gold_add",
		ui_name = "$ml_add_gold",
		description = "$ml_add_gold_tp",
		description_var = { "5000" },
		probability = 0.5,
		ui_icon = "data/ui_gfx/items/goldnugget.png",
		sound = const.sounds.shop_item,
		limit_before = "gold_add2",
		fn = function()
			local component_id = ML.player:get_component_by_name("WalletComponent")
			if not component_id then return end
			components:add_value_to_component(component_id, "money", 5000)
			local entity = EntityCreateNew()
			EntitySetTransform(entity, ML.player.x, ML.player.y)
			EntityAddComponent2(entity, "MagicConvertMaterialComponent", {
				from_any_material = true,
				to_material = CellFactory_GetType("gold"),
				is_circle = true,
				steps_per_frame = 1,
				radius = 20,
			})
		end,
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
			local comp_worldstate = components:get_world_state_component()
			if not comp_worldstate then return end
			components:add_value_to_component(comp_worldstate, "perk_hp_drop_chance", 20)
		end,
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
		end,
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
			components:add_value_to_component(comp_id, "special_scale_x", 2)
			components:add_value_to_component(comp_id, "special_scale_y", 2)
		end,
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
			components:add_value_to_component(comp_id, "alpha", 0.1)
		end,
	},
	{
		id = "gods_peace_with_gods",
		group_id = "gods",
		ui_name = "$ml_peace_with_gods",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/peace_with_gods.xml",
		description = "$ml_peace_with_gods_tp",
		probability = 0.3,
		custom_check = function()
			return GlobalsGetValue("TEMPLE_SPAWN_GUARDIAN", "0") ~= "0" and GlobalsGetValue("TEMPLE_PEACE_WITH_GODS", "0") == "0"
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
		end,
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
		end,
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
			MLP.set:add_to_global_number(MLP.const.globals.exp_multiplier, 0.1)
		end,
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
			MLP.set:add_to_global_number(MLP.const.globals.exp_multiplier, 0.25)
		end,
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
			MLP.set:add_to_global_number(MLP.const.globals.exp_multiplier, 0.5)
		end,
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
			MLP.set:add_to_global_number(MLP.const.globals.exp_const, 1)
		end,
	},
	{
		id = "more_experience_trick1",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience_trick",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		description_var = { "25%" },
		probability = 0.3,
		max = 3,
		fn = function()
			MLP.set:add_to_global_number(MLP.const.globals.exp_trick, 0.25)
		end,
	},
	{
		id = "more_experience_trick2",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience_trick",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		description_var = { "50%" },
		probability = 0.2,
		max = 2,
		limit_before = "more_experience_trick1",
		fn = function()
			MLP.set:add_to_global_number(MLP.const.globals.exp_trick, 0.5)
		end,
	},
	{
		id = "more_experience_trick3",
		group_id = "more_experience_trick",
		ui_name = "$ml_more_experience_trick",
		description = "$ml_more_experience_trick_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_exp_trick.xml",
		description_var = { "100%" },
		probability = 0.1,
		limit_before = "more_experience_trick1",
		fn = function()
			MLP.set:add_to_global_number(MLP.const.globals.exp_trick, 1.0)
		end,
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
			MLP.set:add_to_global_number(MLP.const.globals.exp_betray, 0.25)
		end,
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
			MLP.set:add_to_global_number(MLP.const.globals.exp_betray, 0.25)
		end,
	},
	{
		id = "more_love",
		ui_name = "$ml_slightly $perk_genome_more_love",
		description = "$perkdesc_genome_more_love",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_love.png",
		probability = 0.3,
		custom_check = function()
			local comp_id = components:get_world_state_component()
			if not comp_id then return false end
			return ComponentGetValue2(comp_id, "global_genome_relations_modifier") < 100
		end,
		fn = function()
			local comp_id = components:get_world_state_component()
			if not comp_id then return end
			components:add_value_to_component(comp_id, "global_genome_relations_modifier", 10)
		end,
	},
	{
		id = "more_hatred",
		ui_name = "$ml_slightly $perk_genome_more_hatred",
		description = "$perkdesc_genome_more_hatred",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_hatred.png",
		probability = 0.3,
		custom_check = function()
			local comp_id = components:get_world_state_component()
			if not comp_id then return false end
			return ComponentGetValue2(comp_id, "global_genome_relations_modifier") > -100
		end,
		fn = function()
			local comp_id = components:get_world_state_component()
			if not comp_id then return end
			components:add_value_to_component(comp_id, "global_genome_relations_modifier", -10)
		end,
	},
	{
		id = "buff_permanent_concentrated_mana",
		ui_name = "$ml_permanent_concentrated_mana",
		description = "$ml_permanent_concentrated_mana_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/permanent_concentrated_mana.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_source_file", MLP.const.files.mana_regen)
			MLP.set:add_to_global_number(MLP.const.globals.permanent_concentrated_mana, 0.25)
		end,
	},
	{
		id = "buff_damage_projectile_damage_increase",
		ui_name = "$ml_projectile_damage_increase",
		description = "$ml_projectile_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/projectile_damage.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", MLP.const.files.shot_damage)
			MLP.set:add_to_global_number(MLP.const.globals.projectile_damage_increase, 0.1, 1)
		end,
	},
	{
		id = "buff_damage_elemental_damage_increase",
		ui_name = "$ml_elemental_damage_increase",
		description = "$ml_elemental_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/elemental_damage.xml",
		probability = 0.2,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", MLP.const.files.shot_damage)
			MLP.set:add_to_global_number(MLP.const.globals.elemental_damage_increase, 0.3, 1)
		end,
	},
	{
		id = "buff_damage_drill_damage_increase",
		ui_name = "$ml_drill_damage_increase",
		description = "$ml_drill_damage_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/drill_damage.xml",
		probability = 0.1,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", MLP.const.files.shot_damage)
			MLP.set:add_to_global_number(MLP.const.globals.drill_damage_increase, 0.4)
		end,
	},
	{
		id = "buff_damage_crit_chance_increase",
		ui_name = "$action_critical_hit",
		description = "$actiondesc_critical_hit",
		ui_icon = "data/ui_gfx/gun_actions/critical_hit.png",
		probability = 0.1,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", MLP.const.files.shot_damage)
			MLP.set:add_to_global_number(MLP.const.globals.crit_chance_increase, 15)
		end,
	},
	{
		id = "buff_damage_drill_destructibility_increase",
		ui_name = "$ml_drill_destructibility_increase",
		description = "$ml_drill_destructibility_increase_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/drill_destructibility.xml",
		probability = 0.1,
		max = 3,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", MLP.const.files.shot_damage)
			MLP.set:add_to_global_number(MLP.const.globals.drill_destructibility, 1)
		end,
	},
	{
		id = "force_fungal_shift",
		ui_name = "$ml_force_fungal_shift",
		description = "$ml_force_fungal_shift_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/fungal_shift.xml",
		probability = 0.1,
		fn = function()
			rewards:force_fungal_shift()
		end,
	},
	{
		id = "polymorph_immunity",
		ui_name = "$ml_polymorph_immunity",
		description = "$ml_polymorph_immunity_tp",
		description2 = "$ml_polymorph_immunity_tp2",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/poly_protection.xml",
		probability = 0.05,
		min_level = 100,
		custom_check = function()
			local player_id = EntityGetWithTag("player_unit")
			if not player_id then return false end
			return not EntityHasTag(player_id, "polymorphable_NOT")
		end,
		max = 1,
		fn = function()
			EntityAddTag(ML.player.id, "polymorphable_NOT")
		end,
	},
	{
		id = "extra_perk",
		ui_name = "$ml_slightly_more_perks",
		description = "$ml_slightly_more_perks_tp",
		ui_icon = "data/items_gfx/perks/extra_perk.png",
		probability = 0.05,
		min_level = 5,
		max = 4,
		fn = function()
			MLP.set:add_to_global_number("EXTRA_PERK_IN_HM", 1, 0)
		end,
	},
	{
		id = "buff_explosion_radius",
		ui_name = "$ml_buff_explosion_radius",
		description = "$ml_buff_explosion_radius_tp",
		description_var = { "10%" },
		description2 = "$ml_lag_warning",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/explosion.xml",
		probability = 0.2,
		max = 20,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", MLP.const.files.shot_damage)
			MLP.set:add_to_global_number(MLP.const.globals.projectile_explosion_radius, 0.10, 1)
		end,
	},
	{
		id = "buff_explosion_damage",
		ui_name = "$ml_buff_explosion_damage",
		description = "$ml_buff_explosion_damage_tp",
		description_var = { "15%" },
		ui_icon = "mods/meta_leveling/files/gfx/rewards/explosion_red.xml",
		probability = 0.2,
		max = 20,
		fn = function()
			ML.player:add_lua_component_if_none("script_shot", MLP.const.files.shot_damage)
			MLP.set:add_to_global_number(MLP.const.globals.projectile_explosion_damage, 0.15, 1)
		end,
	},
	{
		id = "remove_hp_cap",
		ui_name = "$ml_remove_hp_cap",
		description = "$ml_remove_hp_cap_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/remove_hp_cap.png",
		probability = 0.01,
		custom_check = function()
			player:update()
			return player:get_damagemodel_value_number("max_hp_cap", 0) > 0
		end,
		fn = function()
			player:update()
			local dmg_comp = player:get_damagemodel()
			if not dmg_comp then return end
			ComponentSetValue2(dmg_comp, "max_hp_cap", 0)
		end,
	},
}

local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_rewards(reward_list)
-- return reward_list
