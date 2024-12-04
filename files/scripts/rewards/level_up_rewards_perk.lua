local rewards = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards.lua") --- @type ml_rewards_util
--- @type ml_rewards
local rewards_perk = {
	{
		id = "perk_perks_lottery",
		ui_name = "$perk_perks_lottery",
		description = "$perkdesc_perks_lottery",
		ui_icon = "data/items_gfx/perks/perks_lottery.png",
		probability = 0.05,
		no_sound = true,
		min_level = 20,
		custom_check = function()
			local pickup_count = rewards:get_perk_pickup_count("PERKS_LOTTERY")
			if pickup_count < 7 then return true end
			return false
		end,
		fn = function()
			rewards:grant_perk("PERKS_LOTTERY")
		end,
	},
	{
		id = "perk_remove_fog_of_war",
		ui_name = "$perk_remove_fog_of_war",
		description = "$perkdesc_remove_fog_of_war",
		ui_icon = "data/items_gfx/perks/remove_fog_of_war.png",
		probability = 0.02,
		no_sound = true,
		min_level = 50,
		custom_check = function()
			local pickup_count = rewards:get_perk_pickup_count("REMOVE_FOG_OF_WAR")
			if pickup_count < 1 then return true end
			return false
		end,
		fn = function()
			rewards:grant_perk("REMOVE_FOG_OF_WAR")
		end,
	},
	{
		id = "perk_edit_wands_everywhere",
		ui_name = "$perk_edit_wands_everywhere",
		description = "$perkdesc_edit_wands_everywhere",
		ui_icon = "data/items_gfx/perks/edit_wands_everywhere.png",
		probability = 0.01,
		no_sound = true,
		min_level = 80,
		custom_check = function()
			local pickup_count = rewards:get_perk_pickup_count("EDIT_WANDS_EVERYWHERE")
			if pickup_count < 1 then return true end
			return false
		end,
		fn = function()
			rewards:grant_perk("EDIT_WANDS_EVERYWHERE")
		end,
	},
	{
		id = "perk_respawn",
		ui_name = "$perk_respawn",
		description = "$perkdesc_respawn",
		ui_icon = "data/items_gfx/perks/respawn.png",
		probability = 0.05,
		no_sound = true,
		min_level = 40,
		fn = function()
			rewards:grant_perk("RESPAWN")
		end,
	},
}

local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_rewards(rewards_perk)
