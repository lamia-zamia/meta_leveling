local const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua")
local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
---@type ml_reward
local reward = {
	id = "pickup_spell_refresh",
	ui_name = "$item_spell_refresh",
	description = "$streamingeventdesc_spell_refresh",
	ui_icon = "mods/meta_leveling/files/gfx/rewards/spell_refresh.xml",
	sound = const.sounds.refresh,
	probability = 0.6,
	fn = function() GameRegenItemActionsInPlayer(ML.player.id) end,
}

rewards_deck:add_reward(reward)

local function is_near_mountain_altar()
	local mountain = EntityGetWithTag("ending_sampo_spot_mountain")[1]
	if mountain and ML.player.y < -1000 then
		local x = EntityGetTransform(mountain)
		if ML.player.x > x - 150 and ML.player.x < x + 150 then return true end
	end
	return false
end

local function spawn_chest(chance)
	if is_near_mountain_altar() then
		ML.utils:load_entity_to_player("data/entities/items/pickup/chest_leggy.xml")
		return
	end

	ML.utils:random_seed()
	local rnd = Random(1, 2000)
	if rnd >= chance then
		ML.utils:load_entity_to_player("data/entities/items/pickup/chest_random_super.xml")
	else
		ML.utils:load_entity_to_player("data/entities/items/pickup/chest_random.xml")
	end
end

---@type ml_rewards
local rewards = {
	{
		id = "pickup_spawn_chest1",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		probability = 0.6,
		max = 3,
		fn = function() spawn_chest(1999) end,
	},
	{
		id = "pickup_spawn_chest2",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		description_var = { "$ml_but_better" },
		probability = 0.6,
		border_color = rewards_deck.borders.uncommon,
		max = 3,
		limit_before = "pickup_spawn_chest1",
		fn = function() spawn_chest(1900) end,
	},
	{
		id = "pickup_spawn_chest3",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		description_var = { "$ml_but_better", "!" },
		probability = 0.6,
		border_color = rewards_deck.borders.rare,
		max = 3,
		limit_before = "pickup_spawn_chest2",
		fn = function() spawn_chest(1800) end,
	},
	{
		id = "pickup_spawn_chest4",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		description_var = { "$ml_but_better", "!!" },
		probability = 0.5,
		border_color = rewards_deck.borders.epic,
		max = 3,
		limit_before = "pickup_spawn_chest3",
		fn = function() spawn_chest(1700) end,
	},
	{
		id = "pickup_spawn_chest5",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		description_var = { "$ml_but_better", "!!!" },
		probability = 0.3,
		border_color = rewards_deck.borders.legendary,
		limit_before = "pickup_spawn_chest4",
		fn = function() spawn_chest(1500) end,
	},
	{
		id = "pickup_spawn_chest_mimic",
		group_id = "pickup_spawn_chest",
		ui_name = "$ml_spawn_chest",
		description = "$ml_spawn_chest_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/spawn_chest.png",
		description_var = { "$ml_but_better", "?" },
		max = 1,
		probability = 0.5,
		limit_before = "pickup_spawn_chest1",
		fn = function() ML.utils:load_entity_to_player("data/entities/items/pickup/chest_leggy.xml") end,
	},
}

rewards_deck:add_rewards(rewards)
