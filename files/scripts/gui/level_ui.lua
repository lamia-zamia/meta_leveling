---@class level_ui
local LU = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/level_ui_class.lua")

function LU:AnimReset(key)
	self.anim[key].reset = true
	self.anim[key].frame = GameGetFrameNum()
end

function LU:CheckForAnim()
	for key, _ in pairs(self.anim) do
		if self.anim[key].reset then
			if GameGetFrameNum() - self.anim[key].frame > 1 then
				self.anim[key].reset = false
			end
		end
	end
end

function LU:MenuAnimS(key)
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim[key].reset)
	self:AnimateScale(0.08, self.anim[key].reset)
end

---toggle level up menu, adds flag to run so you can't close it
---@private
function LU:OpenLevelUpMenu()
	GamePlaySound("ui", "ui/button_click", 0, 0)
	GameAddFlagRun(ML.const.flags.leveling_up)
	self:AnimReset("rewards")
end

---Close level up UI
function LU:CloseRewardUI()
	ML:level_up()
	GameRemoveFlagRun(ML.const.flags.fx_played)
	GamePlaySound("ui", "ui/button_click", 0, 0)
	if ML.exp.percentage < 1 then
		GameRemoveFlagRun(ML.const.flags.leveling_up)
		ML:toggle_ui()
	end
	self.data.reward_list = nil
	self:AnimReset("rewards")
end

---Skip button function
---@private
function LU:SkipReward()
	ML.rewards_deck:skip_reward()
	self:CloseRewardUI()
end

---Choose reward
---@private
function LU:PickReward(reward)
	ML.rewards_deck:pick_reward(reward.id)
	self:CloseRewardUI()
end

---tooltip render for rewards
---@private
---@param reward ml_single_reward
function LU:RewardsTooltip(reward)
	local texts = {
		name = self:Locale(reward.ui_name):gsub("^%l", string.upper),
		description = self:GameTextGet(reward.description, reward.var0, reward.var1, reward.var2):gsub("^%l",
			string.upper)
	}
	local longest = self.tp:GetLongestText(texts, reward.ui_name)
	self.tp:TextCentered(0, 0, texts.name, longest)
	self.tp:TextCentered(0, 0, texts.description, longest)
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
		self:Draw9Piece(x_offset, y, 999, data.width - data.width9_offset, data.height, self.const.ui_9p_reward,
			self.const.ui_9p_reward_hl)
		local tp_offset = (data.width - data.width9_offset) / 2
		self:AddTooltipClickable(tp_offset, data.height * 2, self.RewardsTooltip, self.PickReward,
			ML.rewards_deck.reward_data[self.data.reward_list[i]])
		if not self.data.reward_list then return end
		self:Image(x_offset + (data.width - data.width9_offset - data.icon_size) / 2,
			y + (data.height - data.icon_size) / 2, reward_icon)
	end
end

---draw level up buttons
function LU:DrawButtonsCentered(button_y)
	local texts = {
		self:Locale("$ml_skip"),
		self:Locale("$ml_close"),
	}
	local longest = self:GetLongestText(texts, "LevelUpButtons")
	local count = 0
	for _ in pairs(texts) do count = count + 1 end
	local total_width = count * (longest + 10) - 10
	local button_x = self:CalculateCenterInScreen(total_width, self.const.reward_box_size)

	local function add_button(name, tp, fn)
		self:TextCentered(button_x, button_y, name, longest)
		self:ForceFocusable()
		self:Draw9Piece(button_x, button_y, 50, longest, 10, self.const.ui_9p_button, self.const.ui_9p_button_hl)
		local prev = self:GetPrevious()
		local tp_offset = (self:GuiTextDimensionLocale(tp) - prev.w - 1.5) / -2
		self:AddTooltipClickable(tp_offset, prev.h * 2.2, tp, fn)
		button_x = button_x + longest + 10
	end

	add_button(self:Locale("$ml_skip"), self:Locale("$ml_skip_tp"), self.SkipReward)
	add_button(self:Locale("$ml_close"), self:Locale("$ml_close_tp"), self.CloseMenu)
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
	self:Draw9Piece(x, y, 1000, data.total_width, data.height, self.const.ui_9piece)

	self:DrawPointSpenderRewards(x, y, data)

	local button_y = y + data.height + data.width9_offset * 3
	self:DrawButtonsCentered(button_y)
	self:AnimateE()
end

function LU:DrawCurrentRewardsItems()
	local y = 2
	local x = 2
	local distance_between = 30
	local count = 1
	local max_per_row = 11

	for _, group in pairs(ML.rewards_deck.groups_data) do
		if group.picked then
			if count > max_per_row then
				count = 1
				y = y + distance_between
				x = 2
			end
			if self.data.curent_rewards_height < y then
				self.data.curent_rewards_height = self.data.curent_rewards_height + distance_between
			end
			local tooltip = ""
			self:Image(x, y + self.scroll.y, ML.rewards_deck.reward_data[group.rewards[1]].ui_icon)
			self:Draw9Piece(self.data.x + x, self.data.y + y, 999, 16, 16, self.const.ui_9p_reward)
			for _, reward_id in ipairs(group.rewards) do
				local reward = ML.rewards_deck.reward_data[reward_id]
				if reward.pick_count > 0 then
					tooltip = tooltip .. reward.pick_count .. "x [" .. self:Locale(reward.ui_name) .. "] "
						.. self:GameTextGet(reward.description, reward.var0, reward.var1, reward.var2) .. "\n"
				end
			end
			local prev = self:GetPrevious()
			local tp_offset = (self:GuiTextDimensionLocale(tooltip) - prev.w - 1.5) / -2
			self:AddTooltip(tp_offset, distance_between, tooltip)
			x = x + distance_between
			count = count + 1
		end
	end
end

function LU:DrawCurrentRewards()
	local section = self.data.curent_rewards_height
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.width, section, self.const.ui_9piece_gray,
		self.DrawCurrentRewardsItems)
end

function LU:ToggleMenuWindow(window)
	self.scroll.y = 0
	if self.DrawWindow == window then
		self.DrawWindow = nil
	else
		self.DrawWindow = window
	end
end

function LU:AddMenuSelector(x, y, text, tooltip, fn)
	if self.DrawWindow == fn then
		self:TextGray(x, y, text)
		self:ForceFocusable()
		self:Add9PieceBackGroundText(self.const.ui_9p_button_hl, self.const.ui_9p_button_hl)
		self:MakePreviousClickable(self.ToggleMenuWindow, fn)
	else
		self:Text(x, y, text)
		self:MakeButtonFromPrev(tooltip, self.ToggleMenuWindow, self.const.ui_9p_button, self.const.ui_9p_button_hl, fn)
	end
end

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
		self:MakeButtonFromPrev(self:Locale("$ml_level_up_tp"), self.OpenLevelUpMenu, self.const.ui_9p_button_important,
			self.const.ui_9p_button_hl)
	else
		self:TextGray(x, y, self:Locale("$ml_level_up"))
		self:Add9PieceBackGroundText(self.const.ui_9p_button)
	end
	self:AddMenuSelector(x_off(), y, self:Locale("$ml_current_rewards"), "whatever", self.DrawCurrentRewards)

	self:TextGray(x_off(), y, self:Locale("Stats (WIP)"))
	self:Add9PieceBackGroundText(self.const.ui_9p_button)

	self:TextGray(x_off(), y, self:Locale("Meta (WIP)"))
	self:Add9PieceBackGroundText(self.const.ui_9p_button)

	self:Text(self.const.width + self.data.x - self:GetTextDimension(self:Locale("$ml_close")), y,
		self:Locale("$ml_close"))
	self:MakeButtonFromPrev(self:Locale("$ml_close_tp"), self.CloseMenu, self.const.ui_9p_button,
		self.const.ui_9p_button_hl)
	self:AnimateE()
end

function LU:CloseMenu()
	GamePlaySound(ML.const.sound_banks.ui, "ui/button_click", 0, 0)
	ML.gui = false
end

---draw main window
---@private
function LU:DrawMainHeader()
	self:MenuAnimS("header")
	local section = 10
	local experience = self:Locale("$ml_experience") .. ": " .. ML.exp.current .. " / " .. ML.exp.next
	local level = self:Locale("$ml_level") .. ": " .. ML:get_level()
	self.data.y = self.data.y + self.const.sprite_offset
	self:Draw9Piece(self.data.x, self.data.y, 1000, self.const.width, section, self.const.ui_9piece)
	self:TextCentered(self.data.x, self.data.y, experience, self.const.width * 0.33)
	self:TextCentered(self.data.x, self.data.y, "META LEVELING", self.const.width)
	self:TextCentered(self.data.x + self.const.width * 0.33, self.data.y, level, self.const.width)
	self:AnimateE()

	self.data.y = self.data.y + section + self.const.sprite_offset
end

function LU:DrawMenuConnector()
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, false)
	self:SetZ(1001)
	self:Draw9Piece(self.data.x, self.data.y, 1000, self.const.width, 0,
		"mods/meta_leveling/files/gfx/ui/ui_9piece_connector.png")
	self:AnimateE()
end

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

function LU:GetSetting()
	self.data.CloseOnShot = ML.utils:get_mod_setting_boolean("session_exp_close_ui_on_shot")
	self.data.CloseOnDamage = ML.utils:get_mod_setting_boolean("session_exp_close_ui_on_damage")
end

---main logic
---@private
function LU:DrawLevelUI()
	if GameHasFlagRun(ML.const.flags.leveling_up) then
		self:DrawPointSpender()
	else
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
