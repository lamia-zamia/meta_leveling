---@diagnostic disable: undefined-global

---@class (exact) ml_rewards_util
---@field locked_spells table list of locked spells
---@field spells_no_spawn table list of spells with 0 spawn rate
---@field transformation ml_transformations
local rewards = {
	locked_spells = {},
	spells_no_spawn = {},
	transformation = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/player_transformations.lua")
}

---function to gather spells info in order to validate them later
function rewards:gather_action_info()
	dofile_once("data/scripts/gun/gun_actions.lua")
	for _, action in ipairs(actions) do
		if action.spawn_probability == "0" then
			self.spells_no_spawn[action.id] = action.spawn_probability
		end
		if action.spawn_requires_flag then
			self.locked_spells[action.id] = action.spawn_requires_flag
		end
	end
end

---get reward_id picked count
---@param reward_id string
---@return number
function rewards:get_reward_picked_count(reward_id)
	return ML.utils:get_global_number(reward_id .. "_PICKUP_COUNT", 0)
end

---returns true if reward_id was picked more then number
---@param reward_id string
---@param number string
---@return boolean
function rewards:check_for_picked_count(reward_id, number)
	if self:get_reward_picked_count(reward_id) < number then
		return false
	else
		return true
	end
end

---returns number of perk picked up
---@param perk_id string
---@return number
function rewards:get_perk_pickup_count(perk_id)
	local flag = "PERK_PICKED_" .. perk_id .. "_PICKUP_COUNT"
	return tonumber(GlobalsGetValue(flag, "0")) or 0
end

---give player perk using vanilla's mechanic
---@param perk_id string
function rewards:grant_perk(perk_id)
	dofile_once("data/scripts/perks/perk.lua")
	perk_pickup(0, ML.player.id, perk_id, true, false, true)
end

---check if player can have this spell
---@param action_id string
---@return boolean
function rewards:check_if_spell_is_invalid(action_id)
	if self.spells_no_spawn[action_id] then return true end
	if self.locked_spells[action_id] and not HasFlagPersistent(self.locked_spells[action_id]) then
		return true
	end
	return false
end

---return random spells of level
---@param level number
---@return string action_id
function rewards:get_random_spell(level)
	if level > 6 then level = 10 end
	local action_id = "OCARINA_A" --placeholder
	while (self:check_if_spell_is_invalid(action_id)) do
		action_id = GetRandomAction(ML.player.x, ML.player.y, level, GameGetFrameNum())
	end
	return action_id
end

---return random typed spells of level
---@param level number
---@param type number
---@return string action_id
function rewards:get_random_typed_spell(level, type)
	if level > 6 then level = 10 end
	local action_id = "OCARINA_A" --placeholder
	while (self:check_if_spell_is_invalid(action_id)) do
		action_id = GetRandomActionWithType(ML.player.x, ML.player.y, level, type, GameGetFrameNum())
	end
	return action_id
end

function rewards:force_fungal_shift()
	dofile_once("data/scripts/magic/fungal_shift.lua")
	fungal_shift(ML.player.id, ML.player.x, ML.player.y, true)
end

return rewards