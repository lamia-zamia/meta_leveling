---@class (exact) ML_points
---@field MLP MetaLevelingPublic
local ML_points = {}

---Adds or subtracts from currency
---@param value number
function ML_points:modify_current_currency(value)
	local current = self:get_current_currency()
	ModSettingSet("meta_leveling.currency_progress", current + value)
end

---Returns current available points
---@return number
function ML_points:get_current_currency()
	return tonumber(ModSettingGet("meta_leveling.currency_progress")) or 0
end

return ML_points