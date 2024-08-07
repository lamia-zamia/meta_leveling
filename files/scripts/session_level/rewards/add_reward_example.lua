---@type ml_single_reward
local reward = {
	id = "spell_refresh",
	ui_name = "$item_spell_refresh",
	description = "$streamingeventdesc_spell_refresh",
	ui_icon = "mods/meta_leveling/files/gfx/rewards/spell_refresh.xml",
	sound = ML.const.sounds.refresh,
	probability = 0.6,
	fn = function()
		GameRegenItemActionsInPlayer(ML.player.id)
	end
}

ML.rewards_deck:add_reward(reward)

---@type ml_reward_definition_list
local rewards = {
	{
		id = "spawn_chest1",
		group_id = "spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		var0 = 1,
		probability = 0.6,
		max = 5,
		fn = function()
			ML.utils:random_seed()
			local rnd = Random(1, 2000)
			if (rnd >= 1999) then
				ML.utils:load_entity_to_player("data/entities/items/pickup/chest_random_super.xml")
			else
				ML.utils:load_entity_to_player("data/entities/items/pickup/chest_random.xml")
			end
		end
	},
	{
		id = "spawn_chest2",
		group_id = "spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		var0 = 2,
		probability = 0.6,
		max = 5,
		limit_before = "spawn_chest1",
		fn = function()
			ML.utils:random_seed()
			local rnd = Random(1, 2000)
			if (rnd >= 1800) then
				ML.utils:load_entity_to_player("data/entities/items/pickup/chest_random_super.xml")
			else
				ML.utils:load_entity_to_player("data/entities/items/pickup/chest_random.xml")
			end
		end
	},
	{
		id = "spawn_chest3",
		group_id = "spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		var0 = 3,
		probability = 0.6,
		limit_before = "spawn_chest2",
		fn = function()
			ML.utils:random_seed()
			local rnd = Random(1, 2000)
			if (rnd >= 1500) then
				ML.utils:load_entity_to_player("data/entities/items/pickup/chest_random_super.xml")
			else
				ML.utils:load_entity_to_player("data/entities/items/pickup/chest_random.xml")
			end
		end
	},
	{
		id = "spawn_chest_mimic",
		group_id = "spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		var0 = "?",
		max = 1,
		probability = 0.2,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/chest_leggy.xml")
		end
	}

	-- data/entities/items/pickup/utility_box.xml
}

ML.rewards_deck:add_rewards(rewards)