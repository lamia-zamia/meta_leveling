---@class (exact) reward_description
---@field [number] string|fun():string

---@class (exact) ml_reward_border
---@field [1] number red
---@field [2] number green
---@field [3] number blue
---@field [4] number alpha

---@class ml_reward
---@field id string A unique identifier for the reward.
---@field ui_name string The name of the reward as displayed in the game UI.
---@field fn function A function to run when the reward is picked.
---@field description? string A brief description of the reward.
---@field description_var? reward_description A variable for dynamic descriptions.
---@field description2? string An additional, clarifying description (usually displayed as a second line in gray).
---@field description2_var? reward_description A variable for the second description line.
---@field ui_icon? string The file path to the reward's icon.
---@field border_color? ml_reward_border Optional parameter for rarity outline color (would overwrite defaults)
---@field group_id? string If part of a group, this is the group’s identifier.
---@field probability? number|fun():number The likelihood of the reward appearing (should be between 0 and 1, can also be a function).
---@field max? number The maximum number of times this reward can be picked.
---@field min_level? number The minimum level at which this reward becomes available.
---@field custom_check? fun():boolean A custom check function to determine if the reward should be added to the deck (returns `true` to add, `false` otherwise).
---@field limit_before? string A string indicating a reward that must reach its maximum before this one can appear.
---@field sound? ml_sound A reference to a sound to be played when the reward is picked.
---@field no_sound? boolean Set to `true` to prevent sound from playing.

---@alias ml_rewards ml_reward[]

---@class ml_rewards_util
---@field get ML_get
---@field player ml_player
local rewards = {
	get = dofile_once("mods/meta_leveling/files/scripts/classes/public/get.lua"),
	player = dofile_once("mods/meta_leveling/files/scripts/classes/private/player.lua"),
}

---get reward_id picked count
---@param reward_id string
---@return number
function rewards:get_reward_picked_count(reward_id)
	return self.get:global_number(reward_id .. "_PICKUP_COUNT", 0)
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
	self.player:update()
	-- perk_pickup(0, self.player.id, perk_id, true, false, true) ---@diagnostic disable-line: undefined-global

	local perk_entity = perk_spawn(self.player.x, self.player.y - 8, perk_id) ---@diagnostic disable-line: undefined-global
	perk_pickup(perk_entity, self.player.id, nil, true, false) ---@diagnostic disable-line: undefined-global
end

function rewards:force_fungal_shift()
	dofile_once("data/scripts/magic/fungal_shift.lua")
	self.player:update()
	fungal_shift(self.player.id, self.player.x, self.player.y, true) ---@diagnostic disable-line: undefined-global
end

return rewards
