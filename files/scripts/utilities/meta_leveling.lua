---@class (exact) meta_leveling
---@field player ml_player
---@field level_curve ml_level_curve
---@field gui boolean show gui or not
---@field rewards_deck rewards_deck
---@field rewards ml_rewards_util
---@field utils ML_utils
---@field const ml_const
---@field EZWand any
local ML = {
	gui = false,
	player = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/player.lua"),
	level_curve = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/level_curve.lua"),
	rewards_deck = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/rewards_deck.lua"),
	rewards = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/rewards.lua"),
	utils = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling_utils.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/const.lua"),
	EZWand = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/EZWand.lua")
}

function ML:toggle_ui()
	ML.gui = not ML.gui
end

function ML:floor(value)
	return tonumber(string.format("%.2f", value))
end

---get current exp
---@return number
function ML:get_exp()
	local exp = self.utils:get_global_number("CURRENT_EXP", 0)
	return self:floor(exp)
end

---returns current level
---@return number
function ML:get_level()
	return self.utils:get_global_number("CURRENT_LEVEL", 1)
end

---returns how many exp needs for next level
---@return number
function ML:get_next_exp()
	return self.level_curve[self:get_level()] or self.level_curve[1]
end

---returns current percentage of exp
---@return number
function ML:get_exp_percentage()
	local perc = (self:get_exp() - self.level_curve[self:get_level() - 1]) /
		(self:get_next_exp() - self.level_curve[self:get_level() - 1])
	perc = math.min(perc, 1)
	perc = math.max(perc, 0.00001)
	return perc
end

function ML:level_up()
	self.utils:set_global_number("CURRENT_LEVEL", self:get_level() + 1)
end

---add exp
---@param value number
function ML:add_exp(value)
	local multiplier = self.utils:get_mod_setting_number("session_exp_multiplier", 1) +
		self.utils:get_global_number("EXP_MULTIPLIER", 0)
	value = (value * multiplier) + self.utils:get_global_number("EXP_CONST", 0)
	self.utils:set_global_number("CURRENT_EXP", self:get_exp() + value)
end

---get enemy hp
---@param entity_id entity_id
---@return number
function ML:convert_max_hp_to_exp(entity_id)
	local component = EntityGetFirstComponentIncludingDisabled(entity_id, "DamageModelComponent")
	if component == nil then return 0 end
	local health = tonumber(ComponentGetValue2(component, "max_hp")) or 0
	return health
end

---convert enemy hp and add to exp
---@private
---@param entity_id entity_id
function ML:kill_reward(entity_id)
	self:add_exp(self:convert_max_hp_to_exp(entity_id))
end

function ML:UpdateCommonParameters()
	self.player:validate()
	self.player.x, self.player.y = self.player:get_pos()
end

return ML
