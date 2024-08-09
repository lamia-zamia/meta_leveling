---@type ml_reward_definition_list
local reward_spell = {
	{
		id = "random_spell1",
		group_id = "random_spell",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_spell.xml",
		var0 = "$ml_spell_low",
		sound = ML.const.sounds.chest,
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_spell(Random(0, 3))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_spell2",
		group_id = "random_spell",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_spell.xml",
		var0 = "$ml_spell_mid",
		sound = ML.const.sounds.chest,
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_spell(Random(2, 6))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_spell3",
		group_id = "random_spell",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		var0 = "$ml_spell_high",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_spell.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_spell(Random(5, 10))
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_projectile1",
		group_id = "random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		var0 = "$ml_spell_low",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_projectile.xml",
		probability = 0.4,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(0, 3), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_projectile2",
		group_id = "random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		var0 = "$ml_spell_mid",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_projectile.xml",
		probability = 0.3,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(2, 6), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_projectile3",
		group_id = "random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		var0 = "$ml_spell_high",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_projectile.xml",
		probability = 0.2,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(5, 10), 0)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_static_projectile1",
		group_id = "random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		var0 = "$ml_spell_low",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_static_projectile.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(0, 3), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_static_projectile2",
		group_id = "random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		var0 = "$ml_spell_mid",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_static_projectile.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(2, 6), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_static_projectile3",
		group_id = "random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		var0 = "$ml_spell_high",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_static_projectile.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(5, 10), 1)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_modifier1",
		group_id = "random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		var0 = "$ml_spell_low",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_modifier.xml",
		probability = 0.4,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(0, 3), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_modifier2",
		group_id = "random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		var0 = "$ml_spell_mid",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_modifier.xml",
		probability = 0.3,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(2, 6), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_modifier3",
		group_id = "random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		var0 = "$ml_spell_high",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_modifier.xml",
		probability = 0.2,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(5, 10), 2)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_passive_spell1",
		ui_name = "$ml_passive_spell",
		description = "$ml_passive_spell_tp",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_passive_spell.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(0, 3), 7)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_material_spell1",
		ui_name = "$ml_material_spell",
		description = "$ml_material_spell_tp",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_material_spell.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(1, 6), 4)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_utility1",
		group_id = "random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		var0 = "$ml_spell_low",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_utility.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(0, 3), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_utility2",
		group_id = "random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		var0 = "$ml_spell_mid",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_utility.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(2, 6), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_utility3",
		group_id = "random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		var0 = "$ml_spell_high",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_utility.xml",
		probability = 0.1,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(5, 10), 6)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_other2",
		group_id = "random_other",
		ui_name = "$ml_random_other",
		description = "$ml_random_other_tp",
		var0 = "$ml_spell_mid",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_other.xml",
		probability = 0.1,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(2, 6), 5)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_other3",
		group_id = "random_other",
		ui_name = "$ml_random_other",
		description = "$ml_random_other_tp",
		var0 = "$ml_spell_high",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_other.xml",
		probability = 0.05,
		min_level = 20,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(5, 10), 5)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_draw_many1",
		group_id = "random_draw_many",
		ui_name = "$ml_random_draw_many",
		description = "$ml_random_draw_many_tp",
		var0 = "$ml_spell_low",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_multicast.xml",
		probability = 0.3,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(0, 3), 3)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "random_draw_many2",
		group_id = "random_draw_many",
		ui_name = "$ml_random_draw_many",
		description = "$ml_random_draw_many_tp",
		var0 = "$ml_spell_mid",
		sound = ML.const.sounds.chest,
		ui_icon = "mods/meta_leveling/files/gfx/rewards/random_multicast.xml",
		probability = 0.2,
		min_level = 10,
		fn = function()
			ML.utils:random_seed()
			local action_id = ML.rewards:get_random_typed_spell(Random(3, 6), 3)
			ML.utils:spawn_spell(action_id)
		end
	},
	{
		id = "teleport_bolt",
		ui_name = "$action_teleport_projectile_short",
		description = "$ml_spell_static",
		var0 = "$ml_a",
		var1 = "$action_teleport_projectile_short",
		ui_icon = "data/ui_gfx/gun_actions/teleport_projectile_short.png",
		probability = 0.1,
		max = 2,
		sound = ML.const.sounds.chest,
		fn = function()
			ML.utils:spawn_spell("TELEPORT_PROJECTILE_SHORT")
		end
	},
	{
		id = "spell_nolla",
		ui_name = "$action_nolla",
		description = "$ml_spell_static",
		var0 = "$ml_a",
		var1 = "$action_nolla",
		ui_icon = "data/ui_gfx/gun_actions/nolla.png",
		probability = 0.1,
		max = 2,
		sound = ML.const.sounds.chest,
		fn = function()
			ML.utils:spawn_spell("NOLLA")
		end
	},
	{
		id = "spell_add_mana",
		ui_name = "$action_mana_reduce",
		description = "$ml_spell_static",
		var0 = "$ml_an",
		var1 = "$action_mana_reduce",
		ui_icon = "data/ui_gfx/gun_actions/mana.png",
		probability = 0.05,
		sound = ML.const.sounds.chest,
		fn = function()
			ML.utils:spawn_spell("MANA_REDUCE")
		end
	},
	{
		id = "spell_BLOOD_MAGIC",
		ui_name = "$action_blood_magic",
		description = "$ml_spell_static",
		var0 = "$ml_a",
		var1 = "$action_blood_magic",
		ui_icon = "data/ui_gfx/gun_actions/blood_magic.png",
		probability = 0.05,
		min_level = 30,
		sound = ML.const.sounds.chest,
		fn = function()
			ML.utils:spawn_spell("BLOOD_MAGIC")
		end
	},
	{
		id = "spell_COV",
		ui_name = "$action_regeneration_field",
		description = "$ml_spell_static",
		var0 = "$ml_a",
		var1 = "$action_regeneration_field",
		ui_icon = "data/ui_gfx/gun_actions/regeneration_field.png",
		probability = 0.01,
		min_level = 60,
		max = 1,
		sound = ML.const.sounds.chest,
		fn = function()
			ML.utils:spawn_spell("REGENERATION_FIELD")
		end
	},
	{
		id = "heal_spells",
		ui_name = "$ml_heal_spells",
		description = "$ml_heal_spells_tp",
		ui_icon = "data/ui_gfx/gun_actions/heal_bullet.png",
		probability = 0.05,
		max = 2,
		min_level = 20,
		sound = ML.const.sounds.chest,
		fn = function()
			local list = dofile_once("mods/meta_leveling/files/scripts/compatibility/heal_spell_list.lua")
			local action = ML.utils:weighted_random(list)
			ML.utils:spawn_spell(action)
		end
	},
}

ML.rewards_deck:add_rewards(reward_spell)
