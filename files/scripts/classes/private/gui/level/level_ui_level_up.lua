---@class (exact) level_ui
---@field private level_up any
local LU_level_up = {
	level_up = {
		x = 0,
		y = 0,
		x_center = 0,
		y_center = 0
	}
}

---tooltip render for rewards
---@private
---@param reward ml_single_reward_data
function LU_level_up:LevelUpRewardsTooltip(reward)
	local texts = {
		name = ML.rewards_deck.FormatString(self:Locale(reward.ui_name)),
		description = ML.rewards_deck:UnpackDescription(reward.description, reward.description_var),
		description2 = ML.rewards_deck:UnpackDescription(reward.description2, reward.description2_var)
	}
	self:TextCentered(0, 0, texts.name, 0)
	if texts.description then self:TextCentered(0, 0, texts.description, 0) end
	if texts.description2 then
		self:ColorGray()
		self:TextCentered(0, 0, texts.description2, 0)
	end
end

---Skip button function
---@private
function LU_level_up:LevelUpSkipReward()
	ML.rewards_deck:skip_reward()
	self:LevelUpCloseRewardUI()
end

---Reroll button
---@private
function LU_level_up:LevelUpReroll()
	self:AnimReset("rewards")
	ML.rewards_deck:reroll()
	self.data.reward_list = ML.rewards_deck:draw_reward()
end

---Choose reward
---@private
---@param reward_id ml_reward_id
function LU_level_up:LevelUpPickReward(reward_id)
	ML.rewards_deck:pick_reward(reward_id)
	self:LevelUpCloseRewardUI()
end

---Draws a button with shared lenght
---@private
---@param name string
---@param tp string
---@param fn function
---@param check boolean
---@param longest number
function LU_level_up:LevelUpDrawButton(name, tp, fn, check, longest)
	self:AddOptionForNext(self.c.options.ForceFocusable)
	if check then
		self:Draw9Piece(self.level_up.x - 1, self.level_up.y, self.const.z + 1, longest + 1, 10, self.const.ui_9p_button,
			self.const.ui_9p_button_hl)
	else
		self:Draw9Piece(self.level_up.x - 1, self.level_up.y, self.const.z + 1, longest + 1, 10, self.const.ui_9p_button)
		self:ColorGray()
	end
	if self:IsHovered() then
		self:ShowTooltipTextCenteredX(0, 22, tp)
		if check and self:IsMouseClicked() then
			fn(self)
		end
	end
	self:TextCentered(self.level_up.x, self.level_up.y, name, longest)
	self.level_up.x = self.level_up.x + longest + 10
end

---draw level up buttons
---@private
function LU_level_up:LevelUpDrawButtonsCentered()
	local skip = self:Locale("$ml_skip")
	local close = self:Locale("$ml_close")
	local reroll = self:Locale("$ml_reroll")
	local reroll_count = math.floor(ML.rewards_deck:get_reroll_count())
	local is_reroll_available = reroll_count > 0
	if is_reroll_available then
		reroll = reroll .. " [" .. reroll_count .. "]"
	end
	local longest = self:GetLongestText({ skip, close, reroll }, "LevelUpButtons_" .. reroll_count)
	local total_width = 3 * (longest + 10) - 10
	self.level_up.x = self:CalculateCenterInScreen(total_width, self.const.reward_box_size)

	self:LevelUpDrawButton(skip, self:Locale("$ml_skip_tp"), self.LevelUpSkipReward, true, longest)
	self:LevelUpDrawButton(reroll, self:Locale("$ml_reroll_tp: ") .. reroll_count, self.LevelUpReroll,
		is_reroll_available, longest)
	self:LevelUpDrawButton(close, self:Locale("$ml_close_tp"), self.CloseMenu, true, longest)
end

---Draws rewards
---@private
---@param reward_id ml_reward_id
---@return boolean
function LU_level_up:LevelUpDrawPointSpenderReward(reward_id)
	local reward = ML.rewards_deck.reward_data[reward_id]
	self:DrawRewardRarity(self.level_up.x - 3, self.level_up.y - 3, self.const.z + 4, reward.border_color)
	self:Image(self.level_up.x + 1, self.level_up.y + 1, reward.ui_icon)
	self:AddOptionForNext(self.c.options.ForceFocusable)
	self:Draw9Piece(self.level_up.x, self.level_up.y, self.const.z + 1, 18, 18, self.const.ui_9p_reward,
		self.const.ui_9p_reward_hl)
	if self:IsHovered() then
		self.tooltip_img = self.const.tooltip_img_levelup
		local cache = self:GetTooltipData(0, 0, self.LevelUpRewardsTooltip, reward)
		self:ShowTooltip(self.dim.x / 2, self.level_up.y_center - cache.height - 10, self.LevelUpRewardsTooltip, reward)
		-- self:ShowTooltip(self.level_up.x + 9, self.level_up.y + 36, self.LevelUpRewardsTooltip, reward)
		self.tooltip_img = self.const.tooltip_img
		if self:IsLeftClicked() then return true end
	end
	self.level_up.x = self.level_up.x + 30
	return false
end

---Draws rewards row
---@private
---@param from number
---@param to number
function LU_level_up:LevelUpDrawPointSpenderRow(from, to)
	for i = from, to do
		if not self.data.reward_list then return end
		local reward_id = self.data.reward_list[i]
		if self:LevelUpDrawPointSpenderReward(reward_id) then
			self:LevelUpPickReward(reward_id)
			return
		end
	end
end

---draw level up menu window
---@private
function LU_level_up:LevelUpDrawPointSpender()
	self:MenuAnimS("rewards")
	if not self.data.reward_list then self.data.reward_list = ML.rewards_deck:draw_reward() end
	local amount = #self.data.reward_list
	local split_rows = amount > 6
	local rows = split_rows and 2 or 1
	local amount_per_row = math.ceil(amount / rows)
	local total_width = (amount_per_row * 30) - 12
	local total_height = (30 * rows) - 12
	self.level_up.x_center, self.level_up.y_center = self:CalculateCenterInScreen(total_width, total_height)
	self.level_up.x, self.level_up.y = self.level_up.x_center, self.level_up.y_center

	self:Draw9Piece(self.level_up.x, self.level_up.y, self.const.z + 5, total_width, total_height, self.const.ui_9piece)
	self:BlockInputOnPrevious()

	if split_rows then
		self:LevelUpDrawPointSpenderRow(1, amount_per_row)
		self.level_up.x = self.level_up.x_center + (amount % 2 == 0 and 0 or 15)
		self.level_up.y = self.level_up.y + 30
		self:LevelUpDrawPointSpenderRow(amount_per_row + 1, amount)
	else
		self:LevelUpDrawPointSpenderRow(1, amount)
	end

	self.level_up.y = self.level_up.y + 36
	self:LevelUpDrawButtonsCentered()

	self:AnimateE()
end

---checks for pending level and close level up UI
---@private
function LU_level_up:LevelUpCloseRewardUI()
	ML:level_up()
	if ML.pending_levels <= 0 then
		GameRemoveFlagRun(MLP.const.flags.leveling_up)
		ML:toggle_ui()
	else
		self:AnimReset("rewards")
	end
	self.data.reward_list = nil
end

---toggle level up menu, adds flag to run so you can't close it
---@private
function LU_level_up:LevelUpOpenLevelUpMenu()
	GamePlaySound(MLP.const.sounds.click.bank, MLP.const.sounds.click.event, 0, 0)
	GameAddFlagRun(MLP.const.flags.leveling_up)
	self:AnimReset("rewards")
end

return LU_level_up
