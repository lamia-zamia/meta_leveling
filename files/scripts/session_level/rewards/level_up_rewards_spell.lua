---@type ml_rewards
local reward_spells = {
	{
		id = "spell_random1",
		group_id = "spell_random",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell.xml",
		description_var = { "$ml_spell_low" },
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(0, 3))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random2",
		group_id = "spell_random",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell.xml",
		description_var = { "$ml_spell_mid" },
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(2, 6))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random3",
		group_id = "spell_random",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(5, 10))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_projectile1",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile.xml",
		probability = 0.4,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 3), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_projectile2",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile.xml",
		probability = 0.3,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(2, 6), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_projectile3",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile.xml",
		probability = 0.2,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(5, 10), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_static_projectile1",
		group_id = "spell_random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		description_var = { "$ml_spell_low" },
		sound = MLP.const.sounds.chest,
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 3), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_static_projectile2",
		group_id = "spell_random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(2, 6), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_static_projectile3",
		group_id = "spell_random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(5, 10), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_modifier1",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier.xml",
		probability = 0.4,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 3), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_modifier2",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier.xml",
		probability = 0.3,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(2, 6), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_modifier3",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier.xml",
		probability = 0.2,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(5, 10), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_passive_spell1",
		ui_name = "$ml_passive_spell",
		description = "$ml_passive_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_passive_spell.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 3), 7)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_material_spell1",
		ui_name = "$ml_material_spell",
		description = "$ml_material_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_material_spell.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(1, 6), 4)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_utility1",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 3), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_utility2",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(2, 6), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_utility3",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(5, 10), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_other2",
		group_id = "spell_random_other",
		ui_name = "$ml_random_other",
		description = "$ml_random_other_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_other.xml",
		probability = 0.1,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(2, 6), 5)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_other3",
		group_id = "spell_random_other",
		ui_name = "$ml_random_other",
		description = "$ml_random_other_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_other.xml",
		probability = 0.05,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(5, 10), 5)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_draw_many1",
		group_id = "spell_random_draw_many",
		ui_name = "$ml_random_draw_many",
		description = "$ml_random_draw_many_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_multicast.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 3), 3)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "spell_random_draw_many2",
		group_id = "spell_random_draw_many",
		ui_name = "$ml_random_draw_many",
		description = "$ml_random_draw_many_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_multicast.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 6), 3)
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

for _, reward in ipairs(reward_spells) do
	reward.sound = MLP.const.sounds.chest
end

ML.rewards_deck:add_rewards(reward_spells)
