local transformations_data = dofile_once("mods/meta_leveling/files/scripts/classes/private/player_transformations.lua")

---@type ml_rewards
local transformations = {
	{
		id = "transformation_rat",
		group_id = "transformations",
		ui_name = "$ml_transformation_rat",
		description = "$ml_transformation_rat_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_ratty.xml",
		probability = 0.02,
		min_level = 30,
		custom_check = function()
			return HasFlagPersistent(transformations_data.rat.flag) and tonumber(GlobalsGetValue(transformations_data.rat.value, "0")) < 2
		end,
		fn = function()
			transformations_data.rat:transform()
		end,
	},
	{
		id = "transformation_fungi",
		group_id = "transformations",
		ui_name = "$ml_transformation_fungi",
		description = "$ml_transformation_fungi_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_fungi.xml",
		probability = 0.02,
		min_level = 30,
		custom_check = function()
			return HasFlagPersistent(transformations_data.fungi.flag) and tonumber(GlobalsGetValue(transformations_data.fungi.value, "0")) < 2
		end,
		fn = function()
			transformations_data.fungi:transform()
		end,
	},
	{
		id = "transformation_ghost",
		group_id = "transformations",
		ui_name = "$ml_transformation_ghost",
		description = "$ml_transformation_ghost_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_ghost.xml",
		probability = 0.02,
		min_level = 30,
		custom_check = function()
			return HasFlagPersistent(transformations_data.ghost.flag) and tonumber(GlobalsGetValue(transformations_data.ghost.value, "0")) < 2
		end,
		fn = function()
			transformations_data.ghost:transform()
		end,
	},
	{
		id = "transformation_lukki",
		group_id = "transformations",
		ui_name = "$ml_transformation_lukki",
		description = "$ml_transformation_lukki_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_lukki.xml",
		probability = 0.02,
		min_level = 30,
		custom_check = function()
			return HasFlagPersistent(transformations_data.lukki.flag) and tonumber(GlobalsGetValue(transformations_data.lukki.value, "0")) < 2
		end,
		fn = function()
			transformations_data.lukki:transform()
		end,
	},
	{
		id = "transformation_angel",
		group_id = "transformations",
		ui_name = "$ml_transformation_angel",
		description = "$ml_transformation_angel_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_angel.xml",
		probability = 0.02,
		min_level = 30,
		custom_check = function()
			return HasFlagPersistent(transformations_data.angel.flag) and tonumber(GlobalsGetValue(transformations_data.angel.value, "0")) < 2
		end,
		fn = function()
			transformations_data.angel:transform()
		end,
	},
	{
		id = "transformation_demon",
		group_id = "transformations",
		ui_name = "$ml_transformation_demon",
		description = "$ml_transformation_demon_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_demon.xml",
		probability = 0.02,
		min_level = 30,
		custom_check = function()
			return HasFlagPersistent(transformations_data.demon.flag) and tonumber(GlobalsGetValue(transformations_data.demon.value, "0")) > -2
		end,
		fn = function()
			transformations_data.demon:transform()
		end,
	},
}
local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_rewards(transformations)
