---@class (exact) ML_points
---@field MLP MetaLevelingPublic
---@field private set ML_set
---@field private const ml_const
local ML_points = {
	set = dofile_once("mods/meta_leveling/files/scripts/classes/public/set.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua")
}

---Adds or subtracts from currency
---@param value number
function ML_points:modify_current_currency(value)
	self.set:add_to_global_number(self.const.globals.meta_point_acquired, value, 0)
	local current = self:get_current_currency()
	ModSettingSet("meta_leveling.currency_progress", current + value)
	ModSettingSetNextValue("meta_leveling.currency_progress", current + value, false)
end

---Returns current available points
---@return number
function ML_points:get_current_currency()
	return tonumber(ModSettingGet("meta_leveling.currency_progress")) or 0
end

---Calculates bonus points for no hit
function ML_points:CalculateMetaPointsDamageTaken()
	local damage_taken = tonumber(StatsGetValue("damage_taken"))
	if damage_taken <= 0 then
		return 30
	else
		return math.max(4 - damage_taken / 4)
	end
end

---Calculates bonus points for orbs
---@return number
function ML_points:CalculateMetaPointsOrbs()
	---Points for basic win, orbs and NG
	local newgame_n = tonumber(SessionNumbersGetValue("NEW_GAME_PLUS_COUNT"))
	local orb_count = GameGetOrbCountThisRun()
	local exponent = orb_count + newgame_n ^ 0.5
	return 1.15 ^ exponent
end

---Calculates bonus points for speedruns
---@return number
function ML_points:CalculateMetaPointsSpeedBonus()
	local minutes = GameGetFrameNum() / 60 / 60
	if minutes <= 5 then
		return (5 - minutes / 5) * 20
	else
		return math.max(4 - minutes / 5, 0)
	end
end

---Calculates points for pacifist run
---@return number
function ML_points:CalculateMetaPointsPacifistBonus()
	local kills = tonumber(StatsGetValue("enemies_killed"))
	if kills == 0 then
		return 50
	else
		return math.max(5 - kills / 10, 0)
	end
end

return ML_points