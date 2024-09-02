---@class ml_experience
---@field current number Current experience points.
---@field next number Experience points required for the next level.
---@field percentage number Percentage of experience gained towards the next level.
local exp = {
	current = 0,
	next = 0,
	percentage = 0,
}

---Rounds down a number and formats it to a string based on its magnitude.
---For values >= 1000, it returns an integer string.
---For values >= 100 and < 1000, it returns one decimal.
---For values < 100, it returns two decimals.
---@param value number The value to be floored and formatted.
---@return string The formatted string.
function exp:floor(value)
	if value >= 1000 then
		return string.format("%.0f", value)
	elseif value >= 100 then
		return string.format("%.1f", value)
	end
	return (string.format("%.2f", value):gsub("%.?0+$", ""))
end

---Formats a number into a shortened string with a magnitude suffix (K, M, B, etc.).
---Automatically determines precision based on the size of the number.
---@param value number The value to be formatted.
---@return string The formatted string with appropriate magnitude suffix.
function exp:format(value)
	if value < 1 then
		return (string.format("%.2f", value):gsub("%.?0+$", ""))
	end

	local units = { "K", "M", "B", "T", "Q", "P" } -- Extendable list of units
	local magnitude = math.floor(math.log10(value)) -- Determine the order of magnitude of the number
	local unit_index = math.floor(magnitude / 3) -- Determine the index for the units array
	local divisor = 10 ^ (unit_index * 3)        -- Calculate the divisor based on the unit index

	-- Handle values that don't need shortening
	if unit_index == 0 then
		return (string.format("%.2f", value):gsub("%.?0+$", ""))
	elseif unit_index > #units then
		return string.format("%.1e", value) -- Fall back to scientific notation if out of units
	end

	-- Automatically determine precision based on the size of the number
	local precision = (value / divisor) >= 1000 and "%.0f" or (value / divisor) >= 100 and "%.1f" or "%.2f"
	return string.format(precision .. units[unit_index], value / divisor)
end

---Gets the current experience points.
---@return number experience The current experience points, floored to two decimal places.
function exp:get()
	local experience = ML.utils:get_global_number(ML.const.globals.current_exp, 0)
	return math.floor(experience * 100) / 100
end

---Applies experience multiplier to a given value.
---@param value number The base experience value.
---@return number experience The experience value after applying the multiplier and constants.
function exp:apply_multiplier(value)
	local multiplier = ML.utils:get_mod_setting_number("session_exp_multiplier", 1) +
		ML.utils:get_global_number(ML.const.globals.exp_multiplier, 0)
	value = (value * multiplier) + ML.utils:get_global_number(ML.const.globals.exp_const, 0)
	return value
end

---Adds experience points to the current total.
---@param value number The amount of experience to add.
function exp:add(value)
	ML.utils:add_to_global_number(ML.const.globals.current_exp, value)
end

---Gets the experience points required for the next level.
---@return number experience The experience points required for the next level.
function exp:get_next()
	return ML.level_curve[ML:get_level()] or ML.level_curve[1]
end

---Calculates the current experience percentage towards the next level.
---Ensures the percentage is between 0.00001 and 1.
---@return number percentage The current experience percentage towards the next level.
function exp:get_percentage()
	local current_level_exp = ML.level_curve[ML:get_level() - 1]
	local next_level_exp = self:get_next()
	local perc = (self:get() - current_level_exp) / (next_level_exp - current_level_exp)
	perc = math.min(perc, 1)
	perc = math.max(perc, 0.00001)
	return perc
end

---Converts an entity's maximum HP into experience points.
---@param entity_id entity_id The entity whose HP is to be converted.
---@return number experience The experience points equivalent of the entity's maximum HP.
function exp:convert_max_hp_to_exp(entity_id)
	local component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	if not component then return 0 end
	local health = tonumber(ComponentGetValue2(component, "max_hp")) or 0
	return health
end

function exp:update()
	self.current = self:get()
	self.next = self:get_next()
	self.percentage = self:get_percentage()
end

return exp
