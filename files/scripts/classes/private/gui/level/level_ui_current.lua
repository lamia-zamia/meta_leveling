--- @class (exact) level_ui
--- @field private current any
local LU_current = {
	current = {
		group_rewards = true,
		distance = 29.585
	}
}

-- ############################################
-- ########		CURRENT REWARDS		###########
-- ############################################

--- Draws tooltip for single reward
--- @private
--- @param reward ml_single_reward_data
function LU_current:CurrentDrawRewardTooltip(reward)
	local text = reward.pick_count .. "x [" .. ML.rewards_deck.FormatString(self:Locale(reward.ui_name)) .. "]"
	local description = ML.rewards_deck:UnpackDescription(reward.description, reward.description_var)
	if description then text = text .. " " .. description end
	text = text .. "\n"
	self:Text(0, 0, text)
end

--- Draws tooltip for groups
--- @private
--- @param rewards ml_reward_id[]
function LU_current:CurrentDrawGroupRewardsTooltip(rewards)
	for i = 1, #rewards do
		local reward = ML.rewards_deck.reward_data[rewards[i]]
		if reward.pick_count > 0 then self:CurrentDrawRewardTooltip(reward) end
	end
end

--- Draws individual reward group
--- @private
--- @param rewards ml_reward_id[]
function LU_current:CurrentDrawGroupedReward(rewards)
	if self.current.x + self.current.distance / 2 > self.const.width then
		self.current.x = 4
		self.current.y = self.current.y + self.current.distance
	end
	self:DrawRewardRarity(self.current.x - 4, self.current.y - 4, self.const.z,
		ML.rewards_deck.borders.common)
	self:DrawRewardIcon(self.current.x, self.current.y, ML.rewards_deck.reward_data[rewards[1]].ui_icon)
	self:Draw9PieceInScrollBox(self.current.x - 1, self.current.y - 1, self.const.z, 18, 18, self.const.ui_9p_reward)

	if self:IsElementHovered(self.current.x - 1, self.current.y - 1, 18, 18, true) then
		self:ShowTooltipCenteredX(0, self.current.distance, self.CurrentDrawGroupRewardsTooltip, rewards)
	end
	self.current.x = self.current.x + self.current.distance
end

--- Draws current rewards in groups
--- @private
--- :)
function LU_current:CurrentDrawGroupedRewards()
	for _, group in ipairs(ML.rewards_deck.ordered_groups_data) do
		if group.picked then
			self:CurrentDrawGroupedReward(group.rewards)
		end
	end
end

--- Draws current reward in singular form
--- @private
--- @param reward ml_single_reward_data
function LU_current:CurrentDrawSeparatedReward(reward)
	if self.current.x + self.current.distance / 2 > self.const.width then
		self.current.x = 4
		self.current.y = self.current.y + self.current.distance
	end
	self:DrawRewardRarity(self.current.x - 4, self.current.y - 4, self.const.z, reward.border_color)
	self:DrawRewardIcon(self.current.x, self.current.y, reward.ui_icon)
	self:Draw9PieceInScrollBox(self.current.x - 1, self.current.y - 1, self.const.z, 18, 18, self.const.ui_9p_reward)

	if self:IsElementHovered(self.current.x - 1, self.current.y - 1, 18, 18, true) then
		self:ShowTooltipCenteredX(0, self.current.distance, self.CurrentDrawRewardTooltip, reward)
	end
	self.current.x = self.current.x + self.current.distance
end

--- Draws current rewards in singular form
--- @private
--- :)
function LU_current:CurrentDrawSeparatedRewards()
	for _, reward in ipairs(ML.rewards_deck.ordered_rewards_data) do
		if reward.pick_count > 0 then self:CurrentDrawSeparatedReward(reward) end
	end
end

--- Toggles display mode
--- @private
--- :)
function LU_current:CurrentDrawChangeButton()
	local button = self:Locale("$ml_grouped")
	local button_width = self:GetTextDimension(button)
	local text_x = self.scroll.width - button_width - 15
	local text_y = self.current.y + 27

	if self:IsCheckboxInScrollBoxHovered(text_x, text_y, button, self.current.group_rewards) then
		self:ShowTooltipTextCenteredX(-button_width / 2, 20, self:Locale("$ml_current_change_display"))
		if self:IsLeftClicked() then
			self.current.group_rewards = not self.current.group_rewards
		end
	end
end

--- Draws current reward window
--- @private
function LU_current:CurrentDrawRewardsWindow()
	self.current.y = 4 - self.scroll.y
	self.current.x = 4
	local picked_count = ML.rewards_deck.picked_count
	if picked_count < 1 then
		self:ColorGray()
		self:TextCentered(0, 0, self:Locale("$ml_current_none"), self.scroll.width)
		return
	end
	if self.current.group_rewards then
		self:CurrentDrawGroupedRewards()
	else
		self:CurrentDrawSeparatedRewards()
	end

	self:CurrentDrawChangeButton()
	self:TextCentered(0, self.current.y + 27, self:Locale("$ml_current_rewards: ") .. picked_count,
		self.scroll.width)
	self:Text(0, self.current.y + self.scroll.y + 38, "")
end

--- function to draw current rewards
--- @private
function LU_current:CurrentDrawRewards()
	self.data.y = self.data.y + self.const.sprite_offset
	self:ScrollBox(self.data.x, self.data.y, self.const.z + 1, self.const.ui_9piece_gray, 0, 0, self.CurrentDrawRewardsWindow)
end

return LU_current
