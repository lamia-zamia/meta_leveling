---@class (exact) meta_leveling
---@field player ml_player
---@field level_curve ml_level_curve
---@field gui boolean show gui or not
---@field gui_em_exit boolean
---@field rewards_deck rewards_deck
---@field rewards ml_rewards_util
---@field utils ML_utils
---@field const ml_const
---@field exp ml_experience
---@field font ml_font
---@field EZWand any
---@field colors colors
---@field entity_scanner ml_entity_scanner
---@field nxml nxml
---@field guns ml_gun_parser
---@field meta ml_meta
---@field pending_levels number
local ML = {
	gui = false,
	gui_em_exit = true,
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
	colors = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/colors.lua"),
	entity_scanner = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/entity_scanner.lua"),
	guns = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/gun_parser.lua"),
	meta = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/meta.lua"),
	pending_levels = 0,
}

function ML:toggle_ui()
	ML.gui = not ML.gui
	self.gui_em_exit = true
end

---returns current level
---@return number
function ML:get_level()
	return self.utils:get_global_number(ML.const.globals.current_level, 1)
end

function ML:get_pending_levels()
	local pending = 0
	while self.exp.current >= self.level_curve[self:get_level() + pending] do
		pending = pending + 1
	end
	return pending
end

function ML:level_up()
	self.utils:set_global_number(ML.const.globals.current_level, self:get_level() + 1)
	if self:get_level() % 5 == 0 then
		self.rewards_deck:add_reroll(1)
	end
	self:UpdateCommonParameters()
end

function ML:UpdateCommonParameters()
	self.entity_scanner:check_entities()
	self.player:update()
	self.exp:update()
	self.pending_levels = self:get_pending_levels()
	self.meta:update()
end

function ML:StartUp()
	self.guns:parse_actions()
	self.rewards_deck:GatherData()
	self.rewards_deck:get_reroll_count()
end

function ML:OnSpawn()
	self.meta:initialize()
end

---@param exp number number of exp to add BEFORE applying multiplier
---@param entity? entity_id entity id from which to popup exp
---@param message? string message to log, exp value will be added to the end
function ML:AddExpGlobal(exp, entity, message)
	exp = self.exp:apply_multiplier(exp)
	if message and self.utils:get_mod_setting_boolean("session_exp_log") then
		message = message .. exp
		GamePrint(message)
	end
	if entity and EntityGetIsAlive(entity) and self.utils:get_mod_setting_boolean("session_exp_popup") then
		self.font:popup_exp(entity,	self.exp:format(exp), exp)
	end

	self.exp:add(exp)
end

return ML
