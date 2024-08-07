---@class (exact) meta_leveling
---@field player ml_player
---@field level_curve ml_level_curve
---@field gui boolean show gui or not
---@field rewards_deck rewards_deck
---@field rewards ml_rewards_util
---@field utils ML_utils
---@field const ml_const
---@field exp ml_experience
---@field EZWand any
local ML = {
	gui = false,
	player = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/player.lua"),
	level_curve = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/level_curve.lua"),
	rewards_deck = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/rewards_deck.lua"),
	rewards = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/rewards.lua"),
	utils = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/meta_leveling_utils.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/const.lua"),
	exp = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/experience.lua"),
	EZWand = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/EZWand.lua")
}

function ML:toggle_ui()
	ML.gui = not ML.gui
end

---returns current level
---@return number
function ML:get_level()
	return self.utils:get_global_number("CURRENT_LEVEL", 1)
end

function ML:level_up()
	self.utils:set_global_number("CURRENT_LEVEL", self:get_level() + 1)
	self.exp:update()
end

function ML:UpdateCommonParameters()
	self.player:validate()
	self.player.x, self.player.y = self.player:get_pos()
	self.exp:update()
end

return ML
