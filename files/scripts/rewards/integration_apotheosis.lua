---@type ml_reward
local apo = {
	id = "pickup_apotheosis_redsand",
	ui_name = "$material_apotheosis_sand_red",
	description = "$book_apotheosis_orbbook_stone_12_description",
	ui_icon = "mods/meta_leveling/files/gfx/rewards/redsand.png",
	probability = 0.05,
	max = 1,
	fn = function()
		ML.utils:load_entity_to_player("mods/Apotheosis/files/entities/special/powder_stash_redsand.xml")
	end,
}

local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_reward(apo, "Apotheosis Integration")
