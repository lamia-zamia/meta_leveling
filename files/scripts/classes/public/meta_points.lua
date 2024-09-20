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

return ML_points