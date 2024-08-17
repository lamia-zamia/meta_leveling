---@type ml_rewards
local transformations = {
	{
		id = "transformation_rat",
		ui_name = "$ml_transformation_rat",
		description = "$ml_transformation_rat_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_ratty.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.rewards.transformation.rat.flag) and
				tonumber(GlobalsGetValue(ML.rewards.transformation.rat.value, "0")) < 2
		end,
		fn = function()
			ML.rewards.transformation.rat:transform()
		end
	},
	{
		id = "transformation_fungi",
		ui_name = "$ml_transformation_fungi",
		description = "$ml_transformation_fungi_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_fungi.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.rewards.transformation.fungi.flag) and
				tonumber(GlobalsGetValue(ML.rewards.transformation.fungi.value, "0")) < 2
		end,
		fn = function()
			ML.rewards.transformation.fungi:transform()
		end
	},
	{
		id = "transformation_ghost",
		ui_name = "$ml_transformation_ghost",
		description = "$ml_transformation_ghost_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_ghost.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.rewards.transformation.ghost.flag) and
				tonumber(GlobalsGetValue(ML.rewards.transformation.ghost.value, "0")) < 2
		end,
		fn = function()
			ML.rewards.transformation.ghost:transform()
		end
	},
	{
		id = "transformation_lukki",
		ui_name = "$ml_transformation_lukki",
		description = "$ml_transformation_lukki_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_lukki.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.rewards.transformation.lukki.flag) and
				tonumber(GlobalsGetValue(ML.rewards.transformation.lukki.value, "0")) < 2
		end,
		fn = function()
			ML.rewards.transformation.lukki:transform()
		end
	},
	{
		id = "transformation_angel",
		ui_name = "$ml_transformation_angel",
		description = "$ml_transformation_angel_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_angel.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.rewards.transformation.angel.flag) and
				tonumber(GlobalsGetValue(ML.rewards.transformation.angel.value, "0")) < 2
		end,
		fn = function()
			ML.rewards.transformation.angel:transform()
		end
	},
	{
		id = "transformation_demon",
		ui_name = "$ml_transformation_demon",
		description = "$ml_transformation_demon_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_demon.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.rewards.transformation.demon.flag) and
				tonumber(GlobalsGetValue(ML.rewards.transformation.demon.value, "0")) > -2
		end,
		fn = function()
			ML.rewards.transformation.demon:transform()
		end
	},
}

ML.rewards_deck:add_rewards(transformations)
