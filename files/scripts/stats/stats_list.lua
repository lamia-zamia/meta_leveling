---@type ML_components_helper
local components = dofile_once("mods/meta_leveling/files/scripts/classes/private/components.lua")

---@type ml_stats_entry[]
local list = {
	{
		ui_name = "$ml_experience",
		value = function()
			local exp = MLP.exp:current()
			local str = exp .. ", $ml_stats_per_minute: "
			local component = components:get_world_state_component()
			if not component then return "" end
			local total_time_in_minutes = ComponentGetValue2(component, "time_total") * 1000 / 60
			local per_minute = math.floor(exp / total_time_in_minutes)
			return str .. per_minute
		end,
	},
	{
		ui_name = "$ml_stats_exp_multiplier",
		value = function()
			local base = 100 * MLP.get:mod_setting_number("session_exp_multiplier", 1)
			return base + MLP.get:global_number(MLP.const.globals.exp_multiplier, 0) * 100 .. "%"
		end,
	},
	{
		ui_name = "$ml_more_experience_trick",
		value = function()
			return 25 + MLP.get:global_number(MLP.const.globals.exp_trick, 0) * 100 .. "%"
		end,
	},
	{
		ui_name = "$ml_more_experience_betray",
		value = function()
			return 0 + MLP.get:global_number(MLP.const.globals.exp_betray, 0) * 100 .. "%"
		end,
	},
	{
		ui_name = "$ml_stats_streak",
		value = function()
			return tostring(ModSettingGet("meta_leveling.streak_count"))
		end,
		check_before_show = function()
			return ModSettingGet("meta_leveling.streak_count") > 0
		end
	},
	{
		ui_name = "$ml_stats_meta_points_on_win",
		value = function()
			return tostring(MLP:CalculateMetaPointsOnSampo())
		end,
	},
	{
		ui_name = "$ml_stats_bonus_point_speed",
		value = function()
			return tostring(math.floor(MLP.points:CalculateMetaPointsSpeedBonus()))
		end,
		check_before_show = function()
			return MLP.points:CalculateMetaPointsSpeedBonus() > 0
		end
	},
	{
		ui_name = "$ml_stats_bonus_point_pacifist",
		value = function()
			return tostring(math.floor(MLP.points:CalculateMetaPointsPacifistBonus()))
		end,
		check_before_show = function()
			return MLP.points:CalculateMetaPointsPacifistBonus() > 0
		end
	},
	{
		ui_name = "$ml_stats_bonus_point_no_hit",
		value = function()
			return tostring(math.floor(MLP.points:CalculateMetaPointsDamageTaken()))
		end,
		check_before_show = function()
			return MLP.points:CalculateMetaPointsDamageTaken() > 0
		end
	},
	{
		ui_name = "$ml_stats_bonus_point_fungal_shift",
		value = function()
			return tostring(MLP.points:CalculateMetaPointsFungalShift())
		end,
		check_before_show = function()
			return MLP.points:CalculateMetaPointsFungalShift() > 0
		end
	},
	{
		ui_name = "$ml_stats_bonus_point_win_streak",
		value = function()
			return tostring(MLP.points:CalculateMetaPointsWinStreakBonus())
		end,
		check_before_show = function()
			return MLP.points:CalculateMetaPointsWinStreakBonus() > 0
		end
	}

}

return list