---@diagnostic disable: undefined-global

---@class (exact) reward_description
---@field [number] string|fun():string

---@class (exact) ml_reward
---@field id string id of reward
---@field ui_name string name to display in game
---@field fn? function function to run on pick
---@field group_id? string id of group if part of group
---@field description? string description
---@field description_var? reward_description variable for description
---@field description2? string additional description for clarifying things, second line in gray
---@field description2_var? reward_description variable for description
---@field ui_icon? string path to icon
---@field probability? number|fun():number should be between 0 and 1
---@field max? number max number of reward that you can pick
---@field custom_check? function custom check to perform before adding to reward deck, should return boolean.<br>True - add to deck, false - don't add
---@field limit_before? string don't spawn this reward before this reward was hit it's max
---@field sound? ml_sound see sounds
---@field no_sound? boolean if set to true no sound will be played
---@field min_level? number if set will not appear before this level

---@alias ml_rewards ml_reward[]

---@class (exact) ml_rewards_util
---@field transformation ml_transformations
local rewards = {
	transformation = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/player_transformations.lua")
}

---get reward_id picked count
---@param reward_id string
---@return number
function rewards:get_reward_picked_count(reward_id)
	return MLP.get:global_number(reward_id .. "_PICKUP_COUNT", 0)
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

function rewards:force_fungal_shift()
	dofile_once("data/scripts/magic/fungal_shift.lua")
	fungal_shift(ML.player.id, ML.player.x, ML.player.y, true)
end

return rewards
