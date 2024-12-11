--- @type ML_components_helper
local components = dofile_once("mods/meta_leveling/files/scripts/classes/private/components.lua")

local function return_resistance(type)
	local dmc = ML.player:get_damagemodel()
	if not dmc then return "0%" end
	local value = math.floor(ComponentObjectGetValue2(dmc, "damage_multipliers", type) * 100)
	return string.format("%d%%", 100 - value)
end

--- @type ml_stats_entry[]
local list = {
	{
		ui_name = "$ml_experience",
		category = "experience",
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
		category = "experience",
		value = function()
			local base = 100 * MLP.get:mod_setting_number("session_exp_multiplier", 1)
			return base + MLP.get:global_number(MLP.const.globals.exp_multiplier, 0) * 100 .. "%"
		end,
	},
	{
		ui_name = "$ml_more_experience_trick",
		category = "experience",
		value = function()
			return 25 + MLP.get:global_number(MLP.const.globals.exp_trick, 0) * 100 .. "%"
		end,
	},
	{
		ui_name = "$ml_more_experience_betray",
		category = "experience",
		value = function()
			return 0 + MLP.get:global_number(MLP.const.globals.exp_betray, 0) * 100 .. "%"
		end,
	},
	{
		ui_name = "$ml_stats_time",
		value = function()
			local frames = GameGetFrameNum()
			local total_seconds = math.floor(frames / 60)
			local hours = math.floor(total_seconds / 3600) -- 3600 seconds = 1 hour
			local minutes = math.floor((total_seconds % 3600) / 60)
			local seconds = total_seconds % 60
			return string.format("%02d:%02d:%02d", hours, minutes, seconds)
		end,
	},
	{
		ui_name = "$ml_stats_streak",
		value = function()
			return tostring(ModSettingGet("meta_leveling.streak_count"))
		end,
	},
	{
		ui_name = "$ml_stats_meta_points_on_win",
		category = "meta",
		value = function()
			return tostring(MLP:CalculateMetaPointsOnSampo())
		end,
	},
	{
		ui_name = "$ml_stats_meta_bonus",
		category = "meta",
		value = function()
			return tostring(MLP.get:global_number(MLP.const.globals.meta_point_acquired, 0))
		end,
	},
	{
		ui_name = "$ml_stats_bonus_point_speed",
		category = "meta",
		value = function()
			return tostring(math.floor(MLP.points:CalculateMetaPointsSpeedBonus()))
		end,
	},
	{
		ui_name = "$ml_stats_bonus_point_pacifist",
		category = "meta",
		value = function()
			return tostring(math.floor(MLP.points:CalculateMetaPointsPacifistBonus()))
		end,
	},
	{
		ui_name = "$ml_stats_bonus_point_no_hit",
		category = "meta",
		value = function()
			return tostring(math.floor(MLP.points:CalculateMetaPointsDamageTaken()))
		end,
	},
	{
		ui_name = "$ml_stats_bonus_point_fungal_shift",
		category = "meta",
		value = function()
			return tostring(MLP.points:CalculateMetaPointsFungalShift())
		end,
	},
	{
		ui_name = "$ml_stats_bonus_point_win_streak",
		category = "meta",
		value = function()
			return tostring(MLP.points:CalculateMetaPointsWinStreakBonus())
		end,
	},
	{
		ui_name = "$ml_projectile_resistance",
		category = "resistance",
		value = function()
			return return_resistance("projectile")
		end,
	},
	{
		ui_name = "$ml_explosion_resistance",
		category = "resistance",
		value = function()
			return return_resistance("explosion")
		end,
	},
	{
		ui_name = "$ml_melee_resistance",
		category = "resistance",
		value = function()
			return return_resistance("melee")
		end,
	},
	{
		ui_name = "$ml_electricity_resistance",
		category = "resistance",
		value = function()
			return return_resistance("electricity")
		end,
	},
	{
		ui_name = "$ml_fire_resistance",
		category = "resistance",
		value = function()
			return return_resistance("fire")
		end,
	},
	{
		ui_name = "$ml_radioactive_resistance",
		category = "resistance",
		value = function()
			return return_resistance("radioactive")
		end,
	},
}

ML.stats:add_entries(list)
