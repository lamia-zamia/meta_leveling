local anvil = {
	id = "pickup_anvil_of_destiny_portable",
	ui_name = "Portable Anvil of Destiny",
	description = "Throw it on the ground to spawn a room with an Anvil of Destiny",
	ui_icon = "mods/anvil_of_destiny/files/entities/portable_anvil/ui_icon.png",
	probability = 0.05,
	fn = function() ML.utils:load_entity_to_player("mods/anvil_of_destiny/files/entities/portable_anvil/item.xml") end,
}

local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_reward(anvil, "Anvil of Destiny Integration")
