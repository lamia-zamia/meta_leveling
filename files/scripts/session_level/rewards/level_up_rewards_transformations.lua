local transformations = {
	{
		id = "transformation_rat",
		ui_name = "$ml_transformation_rat",
		description = "ml_transformation_rat_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_ratty.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.utils.transformations.rat.flag) and
				tonumber(GlobalsGetValue(ML.utils.transformations.rat.value, "0")) < 2
		end,
		fn = function()
			ML.utils.transformations.rat:transform()
		end
	},
	{
		id = "transformation_fungi",
		ui_name = "$ml_transformation_fungi",
		description = "ml_transformation_fungi_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_fungi.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.utils.transformations.fungi.flag) and
				tonumber(GlobalsGetValue(ML.utils.transformations.fungi.value, "0")) < 2
		end,
		fn = function()
			ML.utils.transformations.fungi:transform()
		end
	},
	{
		id = "transformation_ghost",
		ui_name = "ml_transformation_ghost",
		description = "ml_transformation_ghost_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_ghost.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.utils.transformations.ghost.flag) and
				tonumber(GlobalsGetValue(ML.utils.transformations.ghost.value, "0")) < 2
		end,
		fn = function()
			ML.utils.transformations.ghost:transform()
		end
	},
	{
		id = "transformation_lukki",
		ui_name = "$ml_transformation_lukki",
		description = "ml_transformation_lukki_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_lukki.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.utils.transformations.lukki.flag) and
				tonumber(GlobalsGetValue(ML.utils.transformations.lukki.value, "0")) < 2
		end,
		fn = function()
			ML.utils.transformations.lukki:transform()
		end
	},
	{
		id = "transformation_angel",
		ui_name = "$ml_transformation_angel",
		description = "$ml_transformation_angel_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_angel.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.utils.transformations.angel.flag) and
				tonumber(GlobalsGetValue(ML.utils.transformations.angel.value, "0")) < 2
		end,
		fn = function()
			ML.utils.transformations.angel:transform()
		end
	},
	{
		id = "transformation_demon",
		ui_name = "$ml_transformation_demon",
		description = "$ml_transformation_demon_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/transformation_demon.xml",
		probability = 0.02,
		custom_check = function()
			return HasFlagPersistent(ML.utils.transformations.demon.flag) and
				tonumber(GlobalsGetValue(ML.utils.transformations.demon.value, "0")) > -2
		end,
		fn = function()
			ML.utils.transformations.demon:transform()
		end
	},
}

ML.rewards:add_rewards(transformations)
