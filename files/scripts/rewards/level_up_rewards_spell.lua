local const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua")
---@type ml_rewards
local reward_spells = {
	{
		id = "spell_random1",
		group_id = "spell_random",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_low.xml",
		description_var = { "$ml_spell_low" },
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(0, 2))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random2",
		group_id = "spell_random",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_mid.xml",
		description_var = { "$ml_spell_mid" },
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(3, 5))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random3",
		group_id = "spell_random",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_high.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(6, 8))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_projectile1",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile_low.xml",
		probability = 0.4,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_projectile2",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile_mid.xml",
		probability = 0.3,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_projectile3",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile_high.xml",
		probability = 0.2,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(6, 8), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_static_projectile1",
		group_id = "spell_random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		description_var = { "$ml_spell_low" },
		sound = const.sounds.chest,
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile_low.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_static_projectile2",
		group_id = "spell_random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile_mid.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_static_projectile3",
		group_id = "spell_random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile_high.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(6, 8), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_modifier1",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier_low.xml",
		probability = 0.4,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_modifier2",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier_mid.xml",
		probability = 0.3,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_modifier3",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier_high.xml",
		probability = 0.2,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(6, 8), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_passive_spell1",
		ui_name = "$ml_passive_spell",
		description = "$ml_passive_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_passive_spell_low.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 7)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_material_spell1",
		group_id = "spell_random_material_spell",
		ui_name = "$ml_material_spell",
		description = "$ml_material_spell_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_material_spell_low.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(1, 3), 4)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_material_spell2",
		group_id = "spell_random_material_spell",
		ui_name = "$ml_material_spell",
		description = "$ml_material_spell_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_material_spell_mid.xml",
		probability = 0.2,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(4, 6), 4)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_utility1",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility_low.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_utility2",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility_mid.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_utility3",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility_high.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(6, 8), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_other2",
		group_id = "spell_random_other",
		ui_name = "$ml_random_other",
		description = "$ml_random_other_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_other_mid.xml",
		probability = 0.1,
		min_level = 30,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(2, 4), 5)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_other3",
		group_id = "spell_random_other",
		ui_name = "$ml_random_other",
		description = "$ml_random_other_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_other_high.xml",
		probability = 0.05,
		min_level = 40,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(5, 8), 5)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_draw_many1",
		group_id = "spell_random_draw_many",
		ui_name = "$ml_random_draw_many",
		description = "$ml_random_draw_many_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_multicast_low.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 3)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_draw_many2",
		group_id = "spell_random_draw_many",
		ui_name = "$ml_random_draw_many",
		description = "$ml_random_draw_many_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_multicast_mid.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 3)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_teleport_bolt",
		ui_name = "$action_teleport_projectile_short",
		description = "$ml_spell_static",
		description_var = { "$ml_a", "$action_teleport_projectile_short" },
		description2 = "$actiondesc_teleport_projectile_short",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_teleport_bolt.png",
		probability = 0.1,
		max = 1,
		fn = function()
			ML.utils:spawn_spell("TELEPORT_PROJECTILE_SHORT")
		end
	},
	{
		id = "spell_nolla",
		ui_name = "$action_nolla",
		description = "$ml_spell_static",
		description_var = { "$ml_a", "$action_nolla" },
		description2 = "$actiondesc_nolla",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_nolla.png",
		probability = 0.1,
		max = 1,
		fn = function()
			ML.utils:spawn_spell("NOLLA")
		end
	},
	{
		id = "spell_add_mana",
		ui_name = "$action_mana_reduce",
		description = "$ml_spell_static",
		description_var = { "$ml_an", "$action_mana_reduce" },
		description2 = "$actiondesc_mana_reduce",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_add_mana.png",
		probability = 0.05,
		fn = function()
			ML.utils:spawn_spell("MANA_REDUCE")
		end
	},
	{
		id = "spell_blood_magic",
		ui_name = "$action_blood_magic",
		description = "$ml_spell_static",
		description_var = { "$ml_a", "$action_blood_magic" },
		description2 = "$actiondesc_blood_magic",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_blood_magic.png",
		probability = 0.05,
		min_level = 30,
		fn = function()
			ML.utils:spawn_spell("BLOOD_MAGIC")
		end
	},
	{
		id = "spell_cov",
		ui_name = "$action_regeneration_field",
		description = "$ml_spell_static",
		description_var = { "$ml_a", "$action_regeneration_field" },
		description2 = "$actiondesc_regeneration_field",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_cov.png",
		probability = 0.01,
		min_level = 60,
		max = 1,
		fn = function()
			ML.utils:spawn_spell("REGENERATION_FIELD")
		end
	},
	{
		id = "spell_heal_spells",
		ui_name = "$ml_heal_spells",
		description = "$ml_heal_spells_tp",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_heal_spells.xml",
		probability = 0.05,
		max = 2,
		min_level = 20,
		fn = function()
			local action = ML.utils:weighted_random(ML.guns.heal_spells)
			ML.utils:spawn_spell(action)
		end
	},
	{
		id = "spell_trigger_hit_world",
		ui_name = "$ml_random_spell_trigger_hit_world",
		description = "$ml_random_spell_trigger_hit_world_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_hit_world.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_from_list(ML.guns.trigger_hit_world)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_trigger_death",
		ui_name = "$ml_random_spell_trigger_death",
		description = "$ml_random_spell_trigger_death_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_death.xml",
		probability = 0.2,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_from_list(ML.guns.trigger_death)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_trigger_timer",
		ui_name = "$ml_random_spell_trigger_timer",
		description = "$ml_random_spell_trigger_timer_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_timer.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_from_list(ML.guns.trigger_timer)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_drills",
		ui_name = "$ml_spell_drills",
		ui_description = "$ml_spell_drills_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/spell_drills.xml",
		probability = 0.3,
		max = 1,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_from_list(ML.guns.drill_spells)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_glimmer",
		ui_name = "$ml_spell_glimmers",
		ui_description = "$ml_spell_glimmers_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/spell_random_glimmer.xml",
		probability = 0.1,
		custom_check = function()
			return HasFlagPersistent("card_unlocked_paint")
		end,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_from_list(ML.guns.glimmers)
			ML.utils:spawn_spell(action_id)
		end
	},
}

for i = 1, #reward_spells do
	reward_spells[i].sound = const.sounds.chest
end
local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_rewards(reward_spells)
