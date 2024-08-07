---@class ml_experience
local exp = {
	current = 0,
	next = 0,
	percentage = 0,
}

---@private
function exp:floor(value)
	return tonumber(string.format("%.2f", value))
end

---get current exp
---@return number
function exp:get()
	local experience = ML.utils:get_global_number("CURRENT_EXP", 0)
	return self:floor(experience)
end

---add exp
---@param value number
function exp:add(value)
	local multiplier = ML.utils:get_mod_setting_number("session_exp_multiplier", 1) +
		ML.utils:get_global_number("EXP_MULTIPLIER", 0)
	value = (value * multiplier) + ML.utils:get_global_number("EXP_CONST", 0)
	ML.utils:add_to_global_number("CURRENT_EXP", value)
end

---returns how many exp needs for next level
---@return number
function exp:get_next()
	return ML.level_curve[ML:get_level()] or ML.level_curve[1]
end

---returns current percentage of exp
---@return number
function exp:get_percentage()
	local perc = (self:get() - ML.level_curve[ML:get_level() - 1]) /
		(self:get_next() - ML.level_curve[ML:get_level() - 1])
	perc = math.min(perc, 1)
	perc = math.max(perc, 0.00001)
	return perc
end

---get enemy hp
---@param entity_id entity_id
---@return number
function exp:convert_max_hp_to_exp(entity_id)
	local component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	if component == nil then return 0 end
	local health = tonumber(ComponentGetValue2(component, "max_hp")) or 0
	return health
end

---convert enemy hp and add to exp
---@private
---@param entity_id entity_id
function exp:kill_reward(entity_id)
	self:add(self:convert_max_hp_to_exp(entity_id))
end

function exp:update()
	self.current = self:get()
	self.next = self:get_next()
	self.percentage = self:get_percentage()
end

return exp