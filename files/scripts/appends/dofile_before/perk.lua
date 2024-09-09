GlobalsGetValue_ML_Old = GlobalsGetValue

local function calculate_extra()
	local reward_count = tonumber(GlobalsGetValue_ML_Old("META_LEVELING_EXTRA_PERK_IN_HM", "0"))
	if reward_count == 0 then return 0 end
	local hm_index = tonumber(GlobalsGetValue_ML_Old("HOLY_MOUNTAIN_VISITS", "0"))
	return math.floor(reward_count + (hm_index % 2) / 2)
end

---@param key string
---@param default_value string? '""'
---@return any|nil global
---@nodiscard
GlobalsGetValue = function(key, default_value)
	local value = GlobalsGetValue_ML_Old(key, default_value or "")
	if key == "TEMPLE_PERK_COUNT" then
		return value + calculate_extra()
	end
	return value
end
