---@class ml_experience
---@field current number
---@field next number
---@field percentage number
local exp = {
	current = 0,
	next = 0,
	percentage = 0,
}

function exp:floor(value)
	if value >= 1000 then
		return string.format("%.0f", value)
	elseif value >= 100 then
		return string.format("%.1f", value)
	end
	return (string.format("%.2f", value):gsub("%.?0+$", ""))
end

---@param value number
---@return string
function exp:format(value)
	if value >= 1000000000000 then
		return string.format("%.1fT", value / 1000000000000)
	elseif value >= 1000000000 then
		return string.format("%.1fB", value / 1000000000)
	elseif value >= 10000000 then
		return string.format("%.1fM", value / 1000000)
	elseif value >= 10000 then
		return string.format("%.1fK", value / 1000)
	elseif value >= 1000 then
		return string.format("%.0f", value)
	elseif value >= 100 then
		return (string.format("%.1f", value):gsub("%.?0+$", ""))
	end
	return (string.format("%.2f", value):gsub("%.?0+$", ""))
end

---get current exp
---@return number
function exp:get()
	local experience = ML.utils:get_global_number(ML.const.globals.current_exp, 0)
	return math.floor(experience * 100) / 100
end

function exp:apply_multiplier(value)
	local multiplier = ML.utils:get_mod_setting_number("session_exp_multiplier", 1) +
		ML.utils:get_global_number(ML.const.globals.exp_multiplier, 0)
	value = (value * multiplier) + ML.utils:get_global_number(ML.const.globals.exp_const, 0)
	return value
end

---add exp
---@param value number
function exp:add(value)
	ML.utils:add_to_global_number(ML.const.globals.current_exp, value)
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
