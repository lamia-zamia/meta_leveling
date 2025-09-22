--- @class (exact) ML_points
--- @field MLP MetaLevelingPublic
--- @field private set ML_set
--- @field private const ml_const
local ML_points = {
	set = dofile_once("mods/meta_leveling/files/scripts/classes/public/set.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua"),
}

--- Multiplies value by meta progress
--- @param value number
--- @return number
--- @nodiscard
function ML_points:multiply_by_meta(value)
	local meta_multiplier = tonumber(ModSettingGet("meta_leveling.progress_more_meta_points")) or 0
	return value * (1 + meta_multiplier)
end

--- Adds meta point to player and writes it to global for stats
--- @param value number
function ML_points:add_meta_points(value)
	value = self:multiply_by_meta(value)
	self.set:add_to_global_number(self.const.globals.meta_point_acquired, value, 0)
	local current = self:get_current_currency()
	ModSettingSet("meta_leveling.currency_progress", current + value)
	ModSettingSetNextValue("meta_leveling.currency_progress", current + value, false)
end

--- Set meta points
--- @param value number
function ML_points:set_meta_points(value)
	ModSettingSet("meta_leveling.currency_progress", value)
	ModSettingSetNextValue("meta_leveling.currency_progress", value, false)
end

--- Adds or subtracts from currency
--- @param value number
function ML_points:modify_current_currency(value)
	local current = self:get_current_currency()
	self:set_meta_points(current + value)
end

--- Returns current available points
--- @return number
function ML_points:get_current_currency()
	return tonumber(ModSettingGet("meta_leveling.currency_progress")) or 0
end

--- Calculates bonus points for fungal shift
function ML_points:CalculateMetaPointsFungalShift()
	local shift_iteration = tonumber(GlobalsGetValue("fungal_shift_iteration", "0")) or 0
	local minutes = (GameGetFrameNum() / 3600) + 5
	local shift_amount = math.floor(math.min(minutes / 5, shift_iteration))
	local sum = math.min(20, shift_amount) + (math.max(0, shift_amount - 20)) ^ 0.65
	return sum
end

--- Calculates bonus points for no hit
function ML_points:CalculateMetaPointsDamageTaken()
	local damage_taken = tonumber(StatsGetValue("damage_taken")) or 1
	if damage_taken <= 0 then
		return 30
	elseif damage_taken <= 8 then
		return 8 / math.max(damage_taken, 1)
	end
	return 0
end

--- Calculates bonus points for orbs
--- @return number
function ML_points:CalculateMetaPointsOrbs()
	--- Points for basic win, orbs and NG
	local newgame_n = tonumber(SessionNumbersGetValue("NEW_GAME_PLUS_COUNT"))
	local orb_count = GameGetOrbCountThisRun()
	local exponent = orb_count + newgame_n ^ 0.5
	return 1.15 ^ exponent
end

--- Calculates bonus points for speedruns
--- @return number
function ML_points:CalculateMetaPointsSpeedBonus()
	local minutes = math.max(1, GameGetFrameNum() / 60 / 60)
	if minutes <= 5 then
		return 5 / minutes * 20
	else
		return math.max(5 - minutes / 5, 0)
	end
end

function ML_points:CalculateMetaPointsWinStreakBonus()
	local streaks = ModSettingGet("meta_leveling.streak_count")
	if streaks < 1 then return 0 end
	return math.min(1.4 ^ streaks, 200)
end

--- Calculates points for pacifist run
--- @return number
function ML_points:CalculateMetaPointsPacifistBonus()
	local kills = tonumber(StatsGetValue("enemies_killed"))
	if kills == 0 then
		return 50
	else
		return math.max(5 - kills / 15, 0)
	end
end

return ML_points
