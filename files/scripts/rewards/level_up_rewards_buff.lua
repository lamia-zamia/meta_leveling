---@type ml_rewards
local buffs = {
	{
		id = "buff_temporary_berserk",
		ui_name = "$status_berserk",
		description = "$ml_buff_temporary_tp",
		description_var = { "$status_berserk", "120" },
		description2 = "$statusdesc_berserk",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_berserk.png",
		probability = 0.7,
		fn = function()
			ML.gameEffect:apply_status_to_player("BERSERK", 120 * 60)
		end
	},
	{
		id = "buff_temporary_speed",
		ui_name = "$perk_movement_faster",
		description = "$ml_buff_temporary_tp",
		description_var = { "$perk_movement_faster", "180" },
		description2 = "$statusdesc_movement_faster",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_movement.png",
		probability = 0.8,
		fn = function()
			local faster = { ---@type ML_gameEffect
				id = "MOVEMENT_FASTER",
				ui_name = "$perk_movement_faster",
				ui_description = "$perkdesc_movement_faster",
				ui_icon = "data/ui_gfx/status_indicators/movement_faster.png",
				effect_entity = "data/entities/misc/effect_movement_faster.xml"
			}
			ML.gameEffect:apply_status_to_player(faster, 180 * 60)
		end
	},
	{
		id = "buff_temporary_mana",
		ui_name = "$status_mana_regeneration",
		description = "$ml_buff_temporary_tp",
		description_var = { "$status_mana_regeneration", "120" },
		description2 = "$statusdesc_mana_regeneration",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_mana.png",
		probability = 0.4,
		fn = function()
			ML.gameEffect:apply_status_to_player("MANA_REGENERATION", 120 * 60)
		end
	},
	{
		id = "buff_temporary_OILED",
		ui_name = "$status_oiled",
		description = "$ml_buff_temporary_tp",
		description_var = { "$status_oiled", "600" },
		description2 = "$ml_buff_oily",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_oiled.png",
		probability = 0.01,
		fn = function()
			local oil = {
				id = "OILED",
				ui_name = "$status_oiled",
				ui_description = "$ml_buff_oily",
				ui_icon = "data/ui_gfx/status_indicators/oiled.png",
				effect_entity = "data/entities/misc/effect_oiled.xml",
			}
			ML.gameEffect:apply_status_to_player(oil, 600 * 60)
		end
	},
	{
		id = "buff_temporary_invis",
		ui_name = "$status_invisibility",
		description = "$ml_buff_temporary_tp",
		description_var = { "$status_invisibility", "300" },
		description2 = "$statusdesc_invisibility",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_invis.png",
		probability = 0.2,
		custom_check = function()
			local pickup_count = ML.rewards:get_perk_pickup_count("INVISIBILITY")
			if pickup_count < 1 then return true end
			return false
		end,
		fn = function()
			ML.gameEffect:apply_status_to_player("INVISIBILITY", 300 * 60)
		end
	},
	{
		id = "buff_temporary_protect",
		ui_name = "$status_protection_all",
		description = "$ml_buff_temporary_tp",
		description_var = { "$status_protection_all", "30" },
		description2 = "$statusdesc_protection_all",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_protec.png",
		probability = 0.015,
		fn = function()
			ML.gameEffect:apply_status_to_player("PROTECTION_ALL", 30 * 60)
		end
	},
	{
		id = "buff_temporary_remove_fog",
		ui_name = "$perk_remove_fog_of_war",
		description = "$ml_buff_temporary_tp",
		description_var = { "$perk_remove_fog_of_war", "60" },
		description2 = "$perkdesc_remove_fog_of_war",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_remove_fog.png",
		probability = 0.02,
		custom_check = function()
			local pickup_count = ML.rewards:get_perk_pickup_count("REMOVE_FOG_OF_WAR")
			if pickup_count < 1 then return true end
			return false
		end,
		fn = function()
			local fog = { ---@type ML_gameEffect
				id = "REMOVE_FOG_OF_WAR",
				ui_name = "$perk_remove_fog_of_war",
				ui_description = "$perkdesc_remove_fog_of_war",
				ui_icon = "data/ui_gfx/status_indicators/nightvision.png",
				effect_entity = "data/entities/misc/effect_remove_fog_of_war.xml"
			}
			ML.gameEffect:apply_status_to_player(fog, 60 * 60)
		end
	},
	{
		id = "buff_temporary_regen",
		ui_name = "$status_hp_regeneration",
		description = "$ml_buff_temporary_tp",
		description_var = { "$status_hp_regeneration", "5" },
		description2 = "$statusdesc_hp_regeneration",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_regen.png",
		probability = 0.01,
		fn = function()
			local regen = { ---@type ML_gameEffect
				id = "REGENERATION",
				ui_name = "$status_hp_regeneration",
				ui_description = "$statusdesc_hp_regeneration",
				ui_icon = "data/ui_gfx/status_indicators/hp_regeneration.png",
				effect_entity = "data/entities/misc/effect_regeneration.xml"
			}
			ML.gameEffect:apply_status_to_player(regen, 5 * 60)
		end
	},
	{
		id = "buff_temporary_twwe",
		ui_name = "$perk_edit_wands_everywhere",
		description = "$ml_buff_temporary_tp",
		description_var = { "$perk_edit_wands_everywhere", "60" },
		description2 = "$perkdesc_edit_wands_everywhere",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_tinker.png",
		probability = 0.15,
		custom_check = function()
			local pickup_count = ML.rewards:get_perk_pickup_count("EDIT_WANDS_EVERYWHERE")
			if pickup_count < 1 then return true end
			return false
		end,
		fn = function()
			local twwe = { ---@type ML_gameEffect
				id = "EDIT_WANDS_EVERYWHERE",
				ui_name = "$perk_edit_wands_everywhere",
				ui_description = "$perkdesc_edit_wands_everywhere",
				ui_icon = "mods/meta_leveling/files/gfx/ui/icons/tinker.png",
				effect_entity = "data/entities/misc/effect_edit_wands_everywhere.xml"
			}
			ML.gameEffect:apply_status_to_player(twwe, 60 * 60)
		end
	},
	{
		id = "buff_temporary_homing",
		ui_name = "$perk_projectile_homing",
		description = "$ml_buff_temporary_tp",
		description_var = { "$perk_projectile_homing", "180" },
		description2 = "$perkdesc_projectile_homing",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_homing.png",
		probability = 0.2,
		custom_check = function()
			local pickup_count = ML.rewards:get_perk_pickup_count("PROJECTILE_HOMING")
			if pickup_count < 1 then return true end
			return false
		end,
		fn = function()
			local homing = { ---@type ML_gameEffect
				id = "PROJECTILE_HOMING",
				ui_name = "$perk_projectile_homing",
				ui_description = "$perkdesc_projectile_homing",
				ui_icon = "data/ui_gfx/status_indicators/homing.png",
				effect_entity = "data/entities/misc/effect_projectile_homing.xml"
			}
			ML.gameEffect:apply_status_to_player(homing, 180 * 60)
		end
	},
	{
		id = "buff_temporary_extra_money",
		ui_name = "$perk_extra_money",
		description = "$ml_buff_temporary_tp",
		description_var = { "$perk_extra_money", "300" },
		description2 = "$perkdesc_extra_money",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/buff_extra_money.png",
		probability = 0.4,
		fn = function()
			local money = { ---@type ML_gameEffect
				id = "EXTRA_MONEY",
				ui_name = "$perk_extra_money",
				ui_description = "$perkdesc_extra_money",
				ui_icon = "mods/meta_leveling/files/gfx/ui/icons/money.png",
				effect_entity = "data/entities/misc/effect_extra_money.xml"
			}
			ML.gameEffect:apply_status_to_player(money, 300 * 60)
		end
	}
}
-- PROTECTION_POLYMORPH
-- FRIEND_FIREMAGE
ML.rewards_deck:add_rewards(buffs)
