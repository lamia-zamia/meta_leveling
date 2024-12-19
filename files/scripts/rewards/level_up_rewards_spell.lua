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
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(0, 2))
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random2",
		group_id = "spell_random",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_mid.xml",
		description_var = { "$ml_spell_mid" },
		probability = 0.2,
		min_level = 15,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(3, 5))
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random3",
		group_id = "spell_random",
		ui_name = "$ml_random_spell",
		description = "$ml_random_spell_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_high.xml",
		probability = 0.1,
		min_level = 30,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_spell(Random(6, 8))
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_projectile1",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile_low.xml",
		probability = 0.4,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 0)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_projectile2",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile_mid.xml",
		probability = 0.3,
		min_level = 15,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 0)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_projectile3",
		group_id = "spell_random_projectile",
		ui_name = "$ml_random_projectile",
		description = "$ml_random_projectile_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_projectile_high.xml",
		probability = 0.2,
		min_level = 30,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(6, 8), 0)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
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
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 1)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_static_projectile2",
		group_id = "spell_random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile_mid.xml",
		probability = 0.2,
		min_level = 15,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 1)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_static_projectile3",
		group_id = "spell_random_static_projectile",
		ui_name = "$ml_random_static_projectile",
		description = "$ml_random_static_projectile_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile_high.xml",
		probability = 0.1,
		min_level = 30,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(6, 8), 1)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_modifier1",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier_low.xml",
		probability = 0.4,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 2)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_modifier2",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier_mid.xml",
		probability = 0.3,
		min_level = 15,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 2)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_modifier3",
		group_id = "spell_random_modifier",
		ui_name = "$ml_random_modifier",
		description = "$ml_random_modifier_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_modifier_high.xml",
		probability = 0.2,
		min_level = 30,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(6, 8), 2)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_passive_spell1",
		ui_name = "$ml_passive_spell",
		description = "$ml_passive_spell_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_passive_spell_low.xml",
		probability = 0.3,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 7)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_material_spell1",
		group_id = "spell_random_material_spell",
		ui_name = "$ml_material_spell",
		description = "$ml_material_spell_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_material_spell_low.xml",
		probability = 0.2,
		min_level = 15,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(1, 3), 4)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_material_spell2",
		group_id = "spell_random_material_spell",
		ui_name = "$ml_material_spell",
		description = "$ml_material_spell_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_material_spell_mid.xml",
		probability = 0.2,
		min_level = 40,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(4, 6), 4)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_utility1",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility_low.xml",
		probability = 0.3,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 6)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_utility2",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility_mid.xml",
		probability = 0.2,
		min_level = 15,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 6)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_utility3",
		group_id = "spell_random_utility",
		ui_name = "$ml_random_utility",
		description = "$ml_random_utility_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_utility_high.xml",
		probability = 0.1,
		min_level = 30,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(6, 8), 6)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_other2",
		group_id = "spell_random_other",
		ui_name = "$ml_random_other",
		description = "$ml_random_other_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_other_mid.xml",
		probability = 0.1,
		min_level = 40,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(2, 4), 5)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_other3",
		group_id = "spell_random_other",
		ui_name = "$ml_random_other",
		description = "$ml_random_other_tp",
		description_var = { "$ml_spell_high" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_other_high.xml",
		probability = 0.05,
		min_level = 60,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(5, 8), 5)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_draw_many1",
		group_id = "spell_random_draw_many",
		ui_name = "$ml_random_draw_many",
		description = "$ml_random_draw_many_tp",
		description_var = { "$ml_spell_low" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_multicast_low.xml",
		probability = 0.3,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(0, 2), 3)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_draw_many2",
		group_id = "spell_random_draw_many",
		ui_name = "$ml_random_draw_many",
		description = "$ml_random_draw_many_tp",
		description_var = { "$ml_spell_mid" },
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_multicast_mid.xml",
		probability = 0.2,
		min_level = 15,
		fn = function(is_testing)
			ML.utils:random_seed()
			local action_id = ML.guns:get_random_typed_spell(Random(3, 5), 3)
			if is_testing then return action_id end
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_teleport_bolt",
		ui_name = "$action_teleport_projectile_short",
		description = "$ml_spell_static",
		description_var = { "$action_teleport_projectile_short" },
		description2 = "$actiondesc_teleport_projectile_short",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_teleport_bolt.png",
		probability = 0.1,
		min_level = 20,
		max = 1,
		fn = function(is_testing)
			local action_id = "TELEPORT_PROJECTILE_SHORT"
			if is_testing then return ML.guns:spell_is_valid(action_id) end
			ML.utils:spawn_spell(action_id)
		end,
	},
	{
		id = "spell_nolla",
		ui_name = "$action_nolla",
		description = "$ml_spell_static",
		description_var = { "$action_nolla" },
		description2 = "$actiondesc_nolla",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_nolla.png",
		probability = 0.1,
		min_level = 30,
		max = 1,
		fn = function(is_testing)
			local action_id = "NOLLA"
			if is_testing then return ML.guns:spell_is_valid(action_id) end
			ML.utils:spawn_spell(action_id)
		end,
	},
	{
		id = "spell_add_mana",
		ui_name = "$action_mana_reduce",
		description = "$ml_spell_static",
		description_var = { "$action_mana_reduce" },
		description2 = "$actiondesc_mana_reduce",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_add_mana.png",
		probability = 0.05,
		min_level = 30,
		fn = function(is_testing)
			local action_id = "MANA_REDUCE"
			if is_testing then return ML.guns:spell_is_valid(action_id) end
			ML.utils:spawn_spell(action_id)
		end,
	},
	{
		id = "spell_blood_magic",
		ui_name = "$action_blood_magic",
		description = "$ml_spell_static",
		description_var = { "$action_blood_magic" },
		description2 = "$actiondesc_blood_magic",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_blood_magic.png",
		probability = 0.05,
		min_level = 60,
		fn = function(is_testing)
			local action_id = "BLOOD_MAGIC"
			if is_testing then return ML.guns:spell_is_valid(action_id) end
			ML.utils:spawn_spell(action_id)
		end,
	},
	{
		id = "spell_cov",
		ui_name = "$action_regeneration_field",
		description = "$ml_spell_static",
		description_var = { "$action_regeneration_field" },
		description2 = "$actiondesc_regeneration_field",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_cov.png",
		probability = 0.01,
		min_level = 60,
		max = 1,
		fn = function(is_testing)
			local action_id = "REGENERATION_FIELD"
			if is_testing then return ML.guns:spell_is_valid(action_id) end
			ML.utils:spawn_spell(action_id)
		end,
	},
	{
		id = "spell_heal_spells",
		ui_name = "$ml_heal_spells",
		description = "$ml_heal_spells_tp",
		ui_icon = "mods/meta_leveling/vfs/rewards/spell_heal_spells.xml",
		probability = 0.05,
		max = 2,
		min_level = 20,
		fn = function(is_testing)
			ML.utils:random_seed()
			if is_testing then
				for i = 1, #ML.guns.heal_spells do
					if ML.guns:spell_is_valid(ML.guns.heal_spells[i].id) then return true end
				end
			end
			local action = ML.utils:weighted_random(ML.guns.heal_spells)
			ML.utils:spawn_spell(action)
		end,
	},
	{
		id = "spell_trigger_hit_world",
		ui_name = "$ml_random_spell_trigger_hit_world",
		description = "$ml_random_spell_trigger_hit_world_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_hit_world.xml",
		probability = 0.3,
		fn = function(is_testing)
			ML.utils:random_seed()
			if is_testing then
				for i = 1, #ML.guns.trigger_hit_world do
					if ML.guns:spell_is_valid(ML.guns.trigger_hit_world[i]) then return true end
				end
			end
			local action_id = ML.guns:get_random_from_list(ML.guns.trigger_hit_world)
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_trigger_death",
		ui_name = "$ml_random_spell_trigger_death",
		description = "$ml_random_spell_trigger_death_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_death.xml",
		probability = 0.2,
		fn = function(is_testing)
			ML.utils:random_seed()
			if is_testing then
				for i = 1, #ML.guns.trigger_death do
					if ML.guns:spell_is_valid(ML.guns.trigger_death[i]) then return true end
				end
			end
			local action_id = ML.guns:get_random_from_list(ML.guns.trigger_death)
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_trigger_timer",
		ui_name = "$ml_random_spell_trigger_timer",
		description = "$ml_random_spell_trigger_timer_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_timer.xml",
		probability = 0.3,
		fn = function(is_testing)
			ML.utils:random_seed()
			if is_testing then
				for i = 1, #ML.guns.trigger_timer do
					if ML.guns:spell_is_valid(ML.guns.trigger_timer[i]) then return true end
				end
			end
			local action_id = ML.guns:get_random_from_list(ML.guns.trigger_timer)
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_drills",
		ui_name = "$ml_spell_drills",
		ui_description = "$ml_spell_drills_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/spell_drills.xml",
		probability = 0.3,
		max = 1,
		fn = function(is_testing)
			ML.utils:random_seed()
			if is_testing then
				for i = 1, #ML.guns.drill_spells do
					if ML.guns:spell_is_valid(ML.guns.drill_spells[i]) then return true end
				end
			end
			local action_id = ML.guns:get_random_from_list(ML.guns.drill_spells)
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
	{
		id = "spell_random_glimmer",
		ui_name = "$ml_spell_glimmers",
		ui_description = "$ml_spell_glimmers_tp",
		ui_icon = "mods/meta_leveling/vfs/gfx/rewards/spell_random_glimmer.xml",
		probability = 0.1,
		fn = function(is_testing)
			ML.utils:random_seed()
			if is_testing then
				for i = 1, #ML.guns.glimmers do
					if ML.guns:spell_is_valid(ML.guns.glimmers[i]) then return true end
				end
			end
			local action_id = ML.guns:get_random_from_list(ML.guns.glimmers)
			if action_id then ML.utils:spawn_spell(action_id) end
		end,
	},
}

local is_reward_checked = {}

for i = 1, #reward_spells do
	local reward = reward_spells[i]
	reward.sound = const.sounds.chest
	local old_check = reward.custom_check
	reward.custom_check = function()
		local reward_id = reward.id
		if not is_reward_checked[reward_id] then
			is_reward_checked[reward_id] = {}
			local result = not not reward.fn(true)
			is_reward_checked[reward_id].valid = not not reward.fn(true)
		end
		if not is_reward_checked[reward_id].valid then return false end
		return old_check and old_check() or true
	end
end
local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua") --- @type rewards_deck
rewards_deck:add_rewards(reward_spells)
