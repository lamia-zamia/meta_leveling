---@class (exact) meta_leveling
---@field player ml_player
---@field level_curve ml_level_curve
---@field gui boolean show gui or not
---@field gui_em_exit boolean
---@field rewards_deck rewards_deck
---@field rewards ml_rewards_util
---@field utils ML_utils
---@field colors colors
---@field entity_scanner ml_entity_scanner
---@field guns ml_gun_parser
---@field meta ml_meta
---@field pending_levels number
---@field next_exp number
local ML = {
	gui = false,
	gui_em_exit = true,
	player = dofile_once("mods/meta_leveling/files/scripts/classes/private/player.lua"),
	level_curve = dofile_once("mods/meta_leveling/files/scripts/classes/private/level_curve.lua"),
	rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua"),
	rewards = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards.lua"),
	utils = dofile_once("mods/meta_leveling/files/scripts/classes/private/meta_leveling_utils.lua"),
	colors = dofile_once("mods/meta_leveling/files/scripts/classes/private/colors.lua"),
	entity_scanner = dofile_once("mods/meta_leveling/files/scripts/classes/private/entity_scanner.lua"),
	guns = dofile_once("mods/meta_leveling/files/scripts/classes/private/gun_parser.lua"),
	meta = dofile_once("mods/meta_leveling/files/scripts/classes/private/meta.lua"),
	pending_levels = 0,
	next_exp = 0,
}

function ML:toggle_ui()
	ML.gui = not ML.gui
	self.gui_em_exit = true
end

---returns current level
---@return number
function ML:get_level()
	return MLP.get:global_number(MLP.const.globals.current_level, 1)
end

function ML:get_pending_levels()
	local pending = 0
	while MLP.exp:current() >= self.level_curve[self:get_level() + pending] do
		pending = pending + 1
	end
	return pending
end

function ML:level_up()
	MLP.set:global_number(MLP.const.globals.current_level, self:get_level() + 1)
	local level = self:get_level()
	if level % 5 == 0 then
		self.rewards_deck:add_reroll(1)
	end
	if level % 100 == 0 then
		MLP.points:modify_current_currency(1)
	end
	self.next_exp = self:get_next()
	self:UpdateCommonParameters()
end

function ML:UpdateCommonParameters()
	self.entity_scanner:check_entities()
	self.player:update()
	self.pending_levels = self:get_pending_levels()
end

function ML:StartUp()
	self.next_exp = self:get_next()
	self.guns:parse_actions()
	self.rewards_deck:GatherData()
	self.rewards_deck:get_reroll_count()
end

function ML:OnSpawn()
	self.meta:initialize()
end



---Gets the experience points required for the next level.
---@return number experience The experience points required for the next level.
function ML:get_next()
	return ML.level_curve[ML:get_level()] or ML.level_curve[1]
end

---Calculates the current experience percentage towards the next level.
---Ensures the percentage is between 0.00001 and 1.
---@return number percentage The current experience percentage towards the next level.
function ML:get_percentage()
	local current_level_exp = ML.level_curve[ML:get_level() - 1]
	local next_level_exp = self:get_next()
	local perc = (MLP.exp:current() - current_level_exp) / (next_level_exp - current_level_exp)
	perc = math.min(perc, 1)
	perc = math.max(perc, 0.00001)
	return perc
end

return ML