---@type ml_reward
local reward = {
	id = "pickup_spell_refresh",
	ui_name = "$item_spell_refresh",
	description = "$streamingeventdesc_spell_refresh",
	ui_icon = "mods/meta_leveling/files/gfx/rewards/spell_refresh.xml",
	sound = MLP.const.sounds.refresh,
	probability = 0.6,
	fn = function()
		GameRegenItemActionsInPlayer(ML.player.id)
	end
}

ML.rewards_deck:add_reward(reward)

---@type ml_rewards
local rewards = {
	{
		id = "pickup_spawn_chest1",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
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
		id = "pickup_spawn_chest2",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		description_var = { "$ml_but_better" },
		probability = 0.6,
		max = 5,
		limit_before = "pickup_spawn_chest1",
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
		id = "pickup_spawn_chest3",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		description_var = { "$ml_but_better", "!" },
		probability = 0.6,
		limit_before = "pickup_spawn_chest2",
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
		id = "pickup_spawn_chest_mimic",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		description_var = { "$ml_but_better", "?" },
		max = 1,
		probability = 0.2,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/chest_leggy.xml")
		end
	}
}

ML.rewards_deck:add_rewards(rewards)
