--- @class (exact) ML_experience
--- @field private get ML_get
--- @field private set ML_set
--- @field private const ml_const
local exp = {
	get = dofile_once("mods/meta_leveling/files/scripts/classes/public/get.lua"),
	set = dofile_once("mods/meta_leveling/files/scripts/classes/public/set.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua"),
}

--- Rounds down a number and formats it to a string based on its magnitude.
--- For values >= 1000, it returns an integer string.
--- For values >= 100 and < 1000, it returns one decimal.
--- For values < 100, it returns two decimals.
--- @param value number The value to be floored and formatted.
--- @return string The formatted string.
function exp:floor(value)
	if value >= 1000 then
		return string.format("%.0f", value)
	elseif value >= 100 then
		return string.format("%.1f", value)
	end
	return (string.format("%.2f", value):gsub("%.?0+$", ""))
end

--- Formats a number into a shortened string with a magnitude suffix (K, M, B, etc.).
--- Automatically determines precision based on the size of the number.
--- @param value number The value to be formatted.
--- @return string The formatted string with appropriate magnitude suffix.
function exp:format(value)
	if value < 1 then return (string.format("%.2f", value):gsub("%.?0+$", "")) end

	local units = { "K", "M", "B", "T", "Q", "P" } -- Extendable list of units
	local magnitude = math.floor(math.log10(value)) -- Determine the order of magnitude of the number
	local unit_index = math.floor(magnitude / 3) -- Determine the index for the units array
	local divisor = 10 ^ (unit_index * 3) -- Calculate the divisor based on the unit index

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

--- Gets the current experience points.
--- @return number experience The current experience points, floored to two decimal places.
function exp:current()
	local experience = self.get:global_number(self.const.globals.current_exp, 0)
	return math.floor(experience * 100) / 100
end

--- Returns true if player has effect_id
---@private
---@param effect_id string
---@param entity? entity_id
---@return boolean
function exp:has_effect(effect_id, entity)
	entity = entity or EntityGetWithTag("player_unit")[1]
	if not entity then return false end
	local effects = EntityGetComponent(entity, "GameEffectComponent") or {}
	for _, effect in ipairs(effects) do
		if ComponentGetValue2(effect, "custom_effect_id") == effect_id then return true end
	end
	local children = EntityGetAllChildren(entity) or {}
	for _, child in ipairs(children) do
		if self:has_effect(effect_id, child) then return true end
	end
	return false
end

--- Applies experience multiplier to a given value.
--- @param value number The base experience value.
--- @return number experience The experience value after applying the multiplier and constants.
function exp:apply_multiplier(value)
	local multiplier = self.get:mod_setting_number("session_exp_multiplier", 1) + self.get:global_number(self.const.globals.exp_multiplier, 0)
	if self:has_effect("META_LEVELING_MORE_EXP") then multiplier = multiplier + 1 end
	value = (value * multiplier) + self.get:global_number(self.const.globals.exp_const, 0)
	return value
end

--- Adds experience points to the current total.
--- @param value number The amount of experience to add.
function exp:add(value)
	self.set:add_to_global_number(self.const.globals.current_exp, value)
end

--- Converts an entity's maximum HP into experience points.
--- @param entity_id entity_id The entity whose HP is to be converted.
--- @return number experience The experience points equivalent of the entity's maximum HP.
function exp:convert_max_hp_to_exp(entity_id)
	local component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	if not component then return 0 end
	local health = tonumber(ComponentGetValue2(component, "max_hp")) or 0
	return health
end

return exp
