---@class level_ui
local LU = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/gui/level_ui_class.lua")

-- ############################################
-- #########		MISC		###########
-- ############################################

---function to unpack variable descriptions
---@param description string
---@param variables reward_description
---@return string?
function LU:UnpackDescription(description, variables)
	if not description then return nil end
	description = self:Locale(description)
	if variables then
		for i, variable in ipairs(variables) do
			if type(variable) == "string" then
				description = description:gsub("%$" .. i - 1, self:Locale(variable:gsub("%%", "%%%%")))
			elseif type(variable) == "function" then
				description = description:gsub("%$" .. i - 1, variable())
			end
		end
	end
	description = description:gsub("%$%d", "")
	return self:FormatString(description)
end

---tooltip render for rewards
---@private
---@param reward ml_single_reward_data
function LU:RewardsTooltip(reward)
	local texts = {
		name = LU:FormatString(self:Locale(reward.ui_name)),
		description = LU:UnpackDescription(reward.description, reward.description_var),
		description2 = LU:UnpackDescription(reward.description2, reward.description2_var)
	}
	local longest = self.tp:GetLongestText(texts, reward.ui_name)
	self.tp:TextCentered(0, 0, texts.name, longest)
	if texts.description then self.tp:TextCentered(0, 0, texts.description, longest) end
	if texts.description2 then
		self:ColorGray()
		self.tp:TextCentered(0, 0, texts.description2, longest)
	end
end

---close ui on triggers
---@private
function LU:EmergencyExit()
	if self.data.CloseOnDamage and ML.player.mLastDamageFrame ~= self.data.mLastDamageFrame then
		self.data.mLastDamageFrame = ML.player.mLastDamageFrame
		ML.gui = false
	end
	if self.data.CloseOnShot and ML.player.mButtonLastFrameFire ~= self.data.mButtonLastFrameFire then
		self.data.mButtonLastFrameFire = ML.player.mButtonLastFrameFire
		ML.gui = false
	end
end

---beautiful rewards name
---@private
function LU:FormatString(text)
	return text:lower():gsub("^%l", string.upper)
end

---invisible 9piece to block inputs on gui
---@private
function LU:BlockInputOnPrevious()
	local prev = self:GetPrevious()
	self:AddOptionForNext(6)
	self:Draw9Piece(prev.x - self.const.sprite_offset / 2, prev.y - self.const.sprite_offset / 2, 100,
		prev.w + self.const.sprite_offset, prev.h + self.const.sprite_offset, self.c.empty)
	prev = self:GetPrevious()
	if prev.hovered then
		self:BlockInput()
	end
end

---reset animation by key
---@private
function LU:AnimReset(key)
	self.anim[key].reset = true
	self.anim[key].frame = GameGetFrameNum()
end

---check if animation should be resetted, it's done so it could wait 1 frame, otherwise animations don't reset
---@private
function LU:CheckForAnim()
	for key, _ in pairs(self.anim) do
		if self.anim[key].reset then
			if GameGetFrameNum() - self.anim[key].frame > 1 then
				self.anim[key].reset = false
			end
		end
	end
end

---set common parameters for menu animation
---@private
function LU:MenuAnimS(key)
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim[key].reset)
	self:AnimateScale(0.08, self.anim[key].reset)
end

---function to close menu
---@private
function LU:CloseMenu()
	GamePlaySound(ML.const.sounds.click.bank, ML.const.sounds.click.event, 0, 0)
	ML.gui = false
end

---check if element is visible within scrollbox
---@private
---@param y number
---@param distance_between number
---@return boolean
function LU:ElementIsVisible(y, distance_between)
	if y - self.scroll.y + distance_between / 2 > 0 and y - self.scroll.y - distance_between / 2 < self.const.height_max then
		return true
	end
	return false
end

---function to reset scrollbox height
---@private
function LU:ResetScrollBoxHeight()
	self:FakeScrollBox_Reset()
	self.data.scrollbox_height = self.const.sprite_offset
end

---function to reset scrollbox params to default
---@private
function LU:ResetScrollBox()
	self:AnimReset("window")
	self:ResetScrollBoxHeight()
end

---Pairs sorted
---@generic T: table, K, V
---@param tbl T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
function LU:orderedPairs(tbl)
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	table.sort(keys)

	local i = 0
	local function iter()
		i = i + 1
		if keys[i] then
			return keys[i], tbl[keys[i]]
		end
	end

	return iter, tbl
end

-- ############################################
-- #########		LEVELING UP		###########
-- ############################################

---Skip button function
---@private
function LU:SkipReward()
	ML.rewards_deck:skip_reward()
	self:CloseRewardUI()
end

---Reroll button
---@private
function LU:Reroll()
	self:AnimReset("rewards")
	ML.rewards_deck:reroll()
	self.data.reward_list = ML.rewards_deck:draw_reward()
end

---Choose reward
---@private
---@param reward ml_single_reward_data
function LU:PickReward(reward)
	ML.rewards_deck:pick_reward(reward.id)
	self:CloseRewardUI()
end

---draw level up buttons
---@private
---@param button_y number
function LU:DrawButtonsCentered(button_y)
	local texts = {
		self:Locale("$ml_skip"),
		self:Locale("$ml_close"),
		self:Locale("$ml_reroll")
	}
	local longest = self:GetLongestText(texts, "LevelUpButtons")
	local total_width = #texts * (longest + 10) - 10
	local button_x = self:CalculateCenterInScreen(total_width, self.const.reward_box_size)

	local function add_button(name, tp, fn, check)
		self:ForceFocusable()
		if check then
			self:Draw9Piece(button_x, button_y, self.const.z + 1, longest, 10, self.const.ui_9p_button,
				self.const.ui_9p_button_hl)
		else
			fn = nil
			self:Draw9Piece(button_x, button_y, self.const.z + 1, longest, 10, self.const.ui_9p_button)
			self:ColorGray()
		end
		local prev = self:GetPrevious()
		self:TextCentered(button_x, button_y, self:Locale(name), longest)
		local tp_offset = math.abs(self:GetTextDimension(tp) - longest - 1.5) / -2
		if prev.hovered then
			self:ShowTooltip(prev.x + tp_offset, prev.y + prev.h * 2.2, tp)
			if InputIsMouseButtonJustDown(1) or InputIsMouseButtonJustDown(2) then -- mouse clicks
				if fn then fn(self) end
			end
		end
		button_x = button_x + longest + 10
	end

	add_button("$ml_skip", self:Locale("$ml_skip_tp"), self.SkipReward, true)
	add_button("$ml_reroll", self:GameTextGet("$ml_reroll_tp", tostring(ML.rewards_deck.reroll_count)), self.Reroll,
		ML.rewards_deck.reroll_count > 0)
	add_button("$ml_close", self:Locale("$ml_close_tp"), self.CloseMenu, true)
end

---Draw rewards in level up menu
---@private
---@param x number
---@param y number
---@param data table
function LU:DrawPointSpenderRewards(x, y, data)
	for i = 1, data.amount do
		local x_offset = x + (data.width + data.width9_offset) * (i - 1)
		local reward_icon = ML.rewards_deck.reward_data[self.data.reward_list[i]].ui_icon
		self:ForceFocusable()
		self:Draw9Piece(x_offset, y, self.const.z, data.width - data.width9_offset, data.height, self.const.ui_9p_reward,
			self.const.ui_9p_reward_hl)
		local tp_offset = (data.width - data.width9_offset) / 2
		self:AddTooltipClickable(tp_offset, data.height * 2, self.RewardsTooltip, self.PickReward,
			ML.rewards_deck.reward_data[self.data.reward_list[i]])
		if not self.data.reward_list then return end
		self:Image(x_offset + (data.width - data.width9_offset - data.icon_size) / 2,
			y + (data.height - data.icon_size) / 2, reward_icon)
	end
end

---draw level up menu window
---@private
function LU:DrawPointSpender()
	self:MenuAnimS("rewards")
	if not self.data.reward_list then self.data.reward_list = ML.rewards_deck:draw_reward() end
	local data = {
		amount = #self.data.reward_list,
		width9_offset = 6,
		width = self.const.reward_box_size,
		icon_size = 16,
	}
	data.height = self.const.reward_box_size - data.width9_offset
	data.total_width = data.amount * (data.width + data.width9_offset) - data.width9_offset * 2
	local x, y = self:CalculateCenterInScreen(data.total_width, data.height)

	self:Draw9Piece(x, y, self.const.z + 1, data.total_width, data.height, self.const.ui_9piece)
	self:BlockInputOnPrevious()
	self:DrawPointSpenderRewards(x, y, data)

	local button_y = y + data.height + data.width9_offset * 3
	self:DrawButtonsCentered(button_y)
	self:AnimateE()
end

---checks for pending level and close level up UI
---@private
function LU:CloseRewardUI()
	ML:level_up()
	GameRemoveFlagRun(ML.const.flags.fx_played)
	GamePlaySound(ML.const.sounds.click.bank, ML.const.sounds.click.event, 0, 0)
	if ML.pending_levels <= 0 then
		GameRemoveFlagRun(ML.const.flags.leveling_up)
		ML:toggle_ui()
	end
	self.data.reward_list = nil
	self:AnimReset("rewards")
end

---toggle level up menu, adds flag to run so you can't close it
---@private
function LU:OpenLevelUpMenu()
	GamePlaySound(ML.const.sounds.click.bank, ML.const.sounds.click.event, 0, 0)
	GameAddFlagRun(ML.const.flags.leveling_up)
	self:AnimReset("rewards")
end

-- ############################################
-- ############		DEBUG		###############
-- ############################################

LU.Debug = dofile_once("mods/meta_leveling/files/scripts/gui/level_ui_debug.lua")

function LU:DrawDebugMenu()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x - 1, self.data.y, self.const.width + 2, self.data.scrollbox_height, self.const.z + 1,
		self.const.ui_9piece_gray,
		self.Debug.DrawDebugWindow)
end

-- ############################################
-- ########		CURRENT REWARDS		###########
-- ############################################

---function to draw tooltip on current rewards
---@private
---@param rewards ml_reward_id[]
function LU:DrawCurrentRewardsTooltip(rewards)
	for _, reward_id in ipairs(rewards) do
		local reward = ML.rewards_deck.reward_data[reward_id]
		if reward.pick_count > 0 then
			local text = reward.pick_count .. "x [" .. LU:FormatString(self:Locale(reward.ui_name)) .. "]"
			local description = LU:UnpackDescription(reward.description, reward.description_var)
			if description then text = text .. " " .. description end
			text = text .. "\n"
			self:Text(0, 0, text)
		end
	end
end

---function to draw rewards itself
---@private
function LU:DrawCurrentRewardsItems()
	local y = 2
	local x = 2
	local distance_between = 30

	for _, group in LU:orderedPairs(ML.rewards_deck.groups_data) do
		if group.picked then
			if x + distance_between / 2 > self.const.width then
				x = 2
				y = y + distance_between
			end
			if self.data.scrollbox_height < y and self.data.scrollbox_height < self.const.height_max then
				self.data.scrollbox_height = self.data.scrollbox_height + distance_between
			end
			self:Image(x, y - self.scroll.y, ML.rewards_deck.reward_data[group.rewards[1]].ui_icon)
			local prev = self:GetPrevious()
			self:Draw9Piece(prev.x, prev.y, self.const.z, 16, 16, self.const.ui_9p_reward)
			if self:ElementIsVisible(y, distance_between) then
				local cache = self.tp:GetTooltipData(0, distance_between, self.DrawCurrentRewardsTooltip, group.rewards)
				self:AddTooltip((cache.width - 16) / - 2, distance_between, self.DrawCurrentRewardsTooltip, group.rewards)
			end
			x = x + distance_between
		end
	end
	self:Text(0, y, "") -- set height for scrollbar, 9piece works weird
end

---function to draw current rewards
---@private
function LU:DrawCurrentRewards()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.width, self.data.scrollbox_height, self.const.z + 1,
		self.const.ui_9piece_gray,
		self.DrawCurrentRewardsItems)
end

-- ############################################
-- ############		MAIN MENU		###########
-- ############################################

---toggle between different windows when buttons pressed
---@private
function LU:ToggleMenuWindow(window)
	self:ResetScrollBox()
	if self.DrawWindow == window then
		self.DrawWindow = nil
	else
		self.DrawWindow = window
	end
end

---buttons functions
---@private
function LU:AddMenuSelector(x, y, text, tooltip, fn)
	if self.DrawWindow == fn then
		self:ColorGray()
		self:Text(x, y, text)
		self:ForceFocusable()
		self:Add9PieceBackGroundText(self.const.z, self.const.ui_9p_button_hl, self.const.ui_9p_button_hl)
		self:MakePreviousClickable(self.ToggleMenuWindow, fn)
	else
		self:Text(x, y, text)
		self:MakeButtonFromPrev(tooltip, self.ToggleMenuWindow, self.const.z, self.const.ui_9p_button,
			self.const.ui_9p_button_hl, fn)
	end
end

---draw buttons under the header
---@private
function LU:DrawMenuButtons()
	self:MenuAnimS("header")
	local y = self.data.y - 5.5
	local x = self.data.x
	local function x_off()
		local prev = self:GetPrevious()
		x = x + prev.w + 10
		return x
	end
	if ML.exp.percentage >= 1 then
		self:Text(x, y, self:Locale("$ml_level_up"))
		self:MakeButtonFromPrev(self:Locale("$ml_level_up_tp"), self.OpenLevelUpMenu, self.const.z,
			self.const.ui_9p_button_important,
			self.const.ui_9p_button_hl)
	else
		self:ColorGray()
		self:Text(x, y, self:Locale("$ml_level_up"))
		self:Add9PieceBackGroundText(self.const.z, self.const.ui_9p_button)
	end
	self:AddMenuSelector(x_off(), y, self:Locale("$ml_current_rewards"), self:Locale("$ml_current_rewards_tp"),
		self.DrawCurrentRewards)

	self:ColorGray()
	self:Text(x_off(), y, self:Locale("Stats (WIP)"))
	self:Add9PieceBackGroundText(self.const.z, self.const.ui_9p_button)

	self:ColorGray()
	self:Text(x_off(), y, self:Locale("Meta (WIP)"))
	self:Add9PieceBackGroundText(self.const.z, self.const.ui_9p_button)

	self:Text(self.const.width + self.data.x - self:GetTextDimension(self:Locale("$ml_close")), y,
		self:Locale("$ml_close"))
	self:MakeButtonFromPrev(self:Locale("$ml_close_tp"), self.CloseMenu, self.const.z, self.const.ui_9p_button,
		self.const.ui_9p_button_hl)
	self:AnimateE()

	if self.data.debug then
		self:Text(self.const.width + self.data.x - self:GetTextDimension(self:Locale("DEBUG")),
			y - self.const.sprite_offset * 2 - 10.5,
			self:Locale("DEBUG"))
		self:MakeButtonFromPrev("cheat menu", self.ToggleMenuWindow, self.const.z, self.const.ui_9p_button,
			self.const.ui_9p_button_hl, self.DrawDebugMenu)
	end
end

---draw header
---@private
function LU:DrawMainHeader()
	self:MenuAnimS("header")
	local third_width = self.const.width * 0.33
	local section = 10
	local experience = self:Locale("$ml_experience: ") .. ML.exp:format(ML.exp.current)
	if ML.exp.current < 10^21 then
		experience = experience .. "/" .. ML.exp:format(ML.exp.next)
	end
	local level = self:Locale("$ml_level: ") .. ML:get_level()
	self.data.y = self.data.y + self.const.sprite_offset
	self:Draw9Piece(self.data.x, self.data.y, self.const.z + 1, self.const.width, section, self.const.ui_9piece)
	self:BlockInputOnPrevious()
	self:TextCentered(self.data.x, self.data.y, experience, third_width)
	self:TextCentered(self.data.x + third_width, self.data.y, "META LEVELING", third_width)
	self:TextCentered(self.data.x + third_width * 2, self.data.y, level, third_width)
	self:AnimateE()

	self.data.y = self.data.y + section + self.const.sprite_offset
end

---draw connector between header and window
---@private
function LU:DrawMenuConnector()
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim["window"].reset)
	self:SetZ(5)
	self:Draw9Piece(self.data.x, self.data.y, self.const.z + 1, self.const.width, 0,
		"mods/meta_leveling/files/gfx/ui/ui_9piece_connector.png")
	self:BlockInputOnPrevious()
	self:AnimateE()
end

---main window
---@private
function LU:DrawMainMenu()
	self.data.x, self.data.y = self:CalculateCenterInScreen(self.const.width, self.const.height)
	self:DrawMainHeader()
	self:DrawMenuButtons()
	if self.DrawWindow then
		self:DrawMenuConnector()
		self:MenuAnimS("window")
		self:DrawWindow()
		self:AnimateE()
	end
end

-- ############################################
-- #############		LOGIC		###########
-- ############################################

---gathers settings on pause update
function LU:GetSetting()
	self.data.CloseOnShot = ML.utils:get_mod_setting_boolean("session_exp_close_ui_on_shot")
	self.data.CloseOnDamage = ML.utils:get_mod_setting_boolean("session_exp_close_ui_on_damage")
	self.data.SkipMenuOnPending = ML.utils:get_mod_setting_boolean("session_exp_ui_open_auto")
	self.data.debug = ML.utils:get_mod_setting_boolean("show_debug")
end

---main logic
---@private
function LU:DrawLevelUI()
	GuiZSet(self.gui, self.const.z - 2)
	if GameHasFlagRun(ML.const.flags.leveling_up) then
		self:DrawPointSpender()
	else
		if self.data.SkipMenuOnPending and ML.pending_levels > 0 then
			GameAddFlagRun(ML.const.flags.leveling_up)
		end
		self:DrawMainMenu()
	end

	self:CheckForAnim()
end

---main loop
function LU:loop()
	if ML.gui_em_exit then self:EmergencyExit() end
	self:StartFrame(self.DrawLevelUI, ML.gui)
end

return LU
