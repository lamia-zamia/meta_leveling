---@class (exact) meta_leveling
---@field player ml_player
---@field level_curve ml_level_curve
---@field gui boolean show gui or not
---@field rewards_deck rewards_deck
---@field rewards ml_rewards_util
---@field utils ML_utils
---@field const ml_const
---@field exp ml_experience
---@field font ml_font
---@field EZWand any
---@field nxml nxml
---@field level number
---@field pending_levels number
local ML = {
	gui = false,
	player = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/player.lua"),
	level_curve = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/level_curve.lua"),
	rewards_deck = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/rewards_deck.lua"),
	rewards = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/rewards.lua"),
	utils = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/meta_leveling_utils.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/const.lua"),
	exp = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/experience.lua"),
	font = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/font.lua"),
	EZWand = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/EZWand.lua"),
	nxml = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/nxml.lua"),
	level = 1,
	pending_levels = 0,
}

function ML:toggle_ui()
	ML.gui = not ML.gui
end

---returns current level
---@return number
function ML:get_level()
	return self.utils:get_global_number("CURRENT_LEVEL", 1)
end

function ML:get_pending_levels()
	local pending = 0
	while self.exp.current >= self.level_curve[self:get_level() + pending] do
		pending = pending + 1
	end
	return pending
end

function ML:level_up()
	self.level = self.level + 1
	self.utils:set_global_number("CURRENT_LEVEL", self:get_level() + 1)
	self.exp:update()
end

function ML:UpdateCommonParameters()
	self.player:update()
	self.exp:update()
	if self.exp.percentage >= 1 then
		self.pending_levels = self:get_pending_levels()
	end
end

function ML:StartUp()
	self.level = self:get_level()
	self.rewards_deck:GatherData()
	self.rewards:gather_action_info()
end

return ML
