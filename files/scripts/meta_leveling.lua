---@class meta_leveling
---@field player ml_player
---@field level_curve ml_level_curve
---@field gui boolean show gui or not
---@field gui_em_exit boolean
---@field rewards_deck rewards_deck
---@field utils ML_utils
---@field colors colors
---@field entity_scanner ml_entity_scanner
---@field guns ml_gun_parser
---@field meta ml_meta
---@field pending_levels number
---@field next_exp number
---@field stats ml_stats
---@field level_up_effects ml_level_up_effects
---@field private levels_to_get_meta {[number]: boolean}
local ML = {
	meta = dofile_once("mods/meta_leveling/files/scripts/classes/private/meta.lua"),
	gui = false,
	gui_em_exit = true,
	player = dofile_once("mods/meta_leveling/files/scripts/classes/private/player.lua"),
	rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua"),
	utils = dofile_once("mods/meta_leveling/files/scripts/classes/private/meta_leveling_utils.lua"),
	colors = dofile_once("mods/meta_leveling/files/scripts/classes/private/colors.lua"),
	entity_scanner = dofile_once("mods/meta_leveling/files/scripts/classes/private/entity_scanner.lua"),
	guns = dofile_once("mods/meta_leveling/files/scripts/classes/private/gun_parser.lua"),
	pending_levels = 0,
	next_exp = 0,
	levels_to_get_meta = {},
	stats = dofile_once("mods/meta_leveling/files/scripts/classes/private/stats.lua"),
	level_up_effects = dofile_once("mods/meta_leveling/files/scripts/classes/private/level_up_effects.lua"),
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
	MLP.set:global_number(MLP.const.globals.exp_on_levelup, MLP.exp:current())
	MLP.set:global_number(MLP.const.globals.current_level, self:get_level() + 1)
	local level = self:get_level()
	if level % 5 == 0 then self.rewards_deck:add_reroll(1) end
	-- if level % MLP.get:mod_setting_number("meta_point_per_level") == 0 then MLP.points:add_meta_points(1) end
	if self.levels_to_get_meta[level] then MLP.points:add_meta_points(1) end
	self.next_exp = self:get_next()
	self:UpdateCommonParameters()
end

function ML:OnMagicNumbersAndWorldSeedInitialized()
	self.meta:initialize()
	self.level_curve = dofile_once("mods/meta_leveling/files/scripts/classes/private/level_curve.lua")
	ML.guns:parse_actions()
	dofile_once("mods/meta_leveling/files/scripts/on_init/generate_icons.lua")
end

function ML:UpdateCommonParameters()
	self.entity_scanner:check_entities()
	self.player:update()
	self.pending_levels = self:get_pending_levels()
	self.level_up_effects:update()
end

function ML:StartUp()
	self.next_exp = self:get_next()
	self.rewards_deck:GatherData()
	self.rewards_deck:get_reroll_count()
	self.stats:gather_list()
end

function ML:OnSpawn()
	self.player:update()
	self.meta:apply_if_new_run()
	self:UpdateSettings()
	GameRemoveFlagRun(MLP.const.flags.dead) --- for people who likes to save scam
end

--- Update settings for ML
function ML:UpdateSettings()
	self.level_up_effects:update_settings()
	local exp_per_meta = ML.level_curve[MLP.get:mod_setting_number("meta_point_per_level")]
	for level = 1, 1000 do
		if exp_per_meta <= ML.level_curve[level] then
			self.levels_to_get_meta[level] = true
			exp_per_meta = exp_per_meta * 2
		end
	end
end

---Gets the experience points required for the next level.
---@return number experience The experience points required for the next level.
function ML:get_next()
	return ML.level_curve[ML:get_level()] or ML.level_curve[1]
end

---Calculates the current experience percentage towards the next level.
---@return number percentage, boolean inverted The current experience percentage towards the next level.
function ML:get_percentage()
	local current_exp = MLP.exp:current()
	local current_level_required_exp = ML.level_curve[ML:get_level() - 1]

	-- If the player's experience is below the current level's required exp
	-- Calculate how much experience is missing to reach the current level's required exp
	if current_exp < current_level_required_exp then
		-- Reverse percentage: How much EXP is needed to reach the required exp
		local exp_on_skip = MLP.get:global_number(MLP.const.globals.exp_on_levelup, 0)
		return (current_level_required_exp - current_exp) / (current_level_required_exp - exp_on_skip), true
	end

	-- Normal progress percentage toward the next level
	local next_level_required_exp = self:get_next()
	local next_dif = next_level_required_exp - current_level_required_exp
	local current_dif = current_exp - current_level_required_exp

	local perc = current_dif / next_dif
	return perc, false
end

return ML
