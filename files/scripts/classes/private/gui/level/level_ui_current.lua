---@class (exact) level_ui
---@field private current any
local LU_current = {
	current = {
		group_rewards = true,
		distance = 29.585
	}
}

-- ############################################
-- ########		CURRENT REWARDS		###########
-- ############################################

---Draws tooltip for single reward
---@private
---@param reward ml_single_reward_data
function LU_current:Current_DrawRewardTooltip(reward)
	local text = reward.pick_count .. "x [" .. ML.rewards_deck.FormatString(self:Locale(reward.ui_name)) .. "]"
	local description = ML.rewards_deck:UnpackDescription(reward.description, reward.description_var)
	if description then text = text .. " " .. description end
	text = text .. "\n"
	self:Text(0, 0, text)
end

---Draws tooltip for groups
---@private
---@param rewards ml_reward_id[]
function LU_current:Current_DrawGroupRewardsTooltip(rewards)
	for i = 1, #rewards do
		local reward = ML.rewards_deck.reward_data[rewards[i]]
		if reward.pick_count > 0 then self:Current_DrawRewardTooltip(reward) end
	end
end

---Draws individual reward group
---@private
---@param rewards ml_reward_id[]
function LU_current:Current_DrawGroupedReward(rewards)
	if self.current.x + self.current.distance / 2 > self.const.width then
		self.current.x = 4
		self.current.y = self.current.y + self.current.distance
	end
	self:DrawRewardRarity(self.current.x - 4, self.current.y - 4 - self.scroll.y, self.const.z,
		ML.rewards_deck.borders.common)
	self:Image(self.current.x, self.current.y - self.scroll.y, ML.rewards_deck.reward_data[rewards[1]].ui_icon)
	self:Draw9Piece(self.current.x + self.data.x - 1, self.current.y + self.data.y - 1 - self.scroll.y, self.const.z, 18,
		18,
		self.const.ui_9p_reward)
	if self:ElementIsVisible(self.current.y, self.current.distance) then
		local cache = self:GetTooltipData(0, self.current.distance, self.Current_DrawGroupRewardsTooltip, rewards)
		self:AddTooltip((cache.width - 16) / -2, self.current.distance, self.Current_DrawGroupRewardsTooltip, rewards)
	end
	self.current.x = self.current.x + self.current.distance
end

---Draws current rewards in groups
---@private
---:)
function LU_current:Current_DrawGroupedRewards()
	for _, group in ipairs(ML.rewards_deck.ordered_groups_data) do
		if group.picked then
			self:Current_DrawGroupedReward(group.rewards)
		end
	end
end

---Draws current reward in singular form
---@private
---@param reward ml_single_reward_data
function LU_current:Current_DrawSeparatedReward(reward)
	if self.current.x + self.current.distance / 2 > self.const.width then
		self.current.x = 4
		self.current.y = self.current.y + self.current.distance
	end
	self:DrawRewardRarity(self.current.x - 4, self.current.y - 4 - self.scroll.y, self.const.z, reward.border_color)
	self:Image(self.current.x, self.current.y - self.scroll.y, reward.ui_icon)
	self:Draw9Piece(self.current.x + self.data.x - 1, self.current.y + self.data.y - 1 - self.scroll.y, self.const.z, 18,
		18,
		self.const.ui_9p_reward, self.const.ui_9p_button_hl)
	if self:ElementIsVisible(self.current.y, self.current.distance) then
		local cache = self:GetTooltipData(0, self.current.distance, self.Current_DrawRewardTooltip, reward)
		self:AddTooltip((cache.width - 16) / -2, self.current.distance, self.Current_DrawRewardTooltip, reward)
	end
	self.current.x = self.current.x + self.current.distance
end

---Draws current rewards in singular form
---@private
---:)
function LU_current:Current_DrawSeparatedRewards()
	for _, reward in ipairs(ML.rewards_deck.ordered_rewards_data) do
		if reward.pick_count > 0 then self:Current_DrawSeparatedReward(reward) end
	end
end

---Toggles display mode
---@private
---:)
function LU_current:Current_DrawChangeButton()
	local button = self:Locale("$ml_grouped")
	local button_width = self:GetTextDimension(button)
	local hovered = false
	local button_box = self.const.ui_9p_button
	if self:ElementIsVisible(self.current.y, self.current.distance) then
		self:Draw9Piece(self.data.x + self.scroll.width - button_width - 16,
			self.data.y + self.current.y + 27 - self.scroll.y, self.const.z, button_width + 17, 10, self.c.empty)
		hovered = self:IsHovered()
	end
	if hovered then
		button_box = self.const.ui_9p_button_hl
		local tooltip = self:Locale("$ml_current_change_display")
		local tooltip_width = self:GetTextDimension(tooltip)
		self:Color(1, 1, 0.7)
		self:ShowTooltip(self.data.x + self.scroll.width - button_width - tooltip_width / 2,
			self.data.y + self.current.y + 49, tooltip)
		if self:IsMouseClicked() then
			self.current.group_rewards = not self.current.group_rewards
			GamePlaySound(MLP.const.sounds.click.bank, MLP.const.sounds.click.event, 0, 0)
		end
	end
	self:Text(self.scroll.width - button_width - 15, self.current.y + 27 - self.scroll.y, button)
	if self.current.group_rewards then
		self:Color(0, 0.8, 0)
		self:Text(self.scroll.width - 10, self.current.y + 27 - self.scroll.y, "V")
	else
		self:Color(0.8, 0, 0)
		self:Text(self.scroll.width - 10, self.current.y + 27 - self.scroll.y, "X")
	end
	self:Draw9Piece(self.data.x + self.scroll.width - 11, self.data.y + self.current.y + 29 - self.scroll.y,
		self.const.z - 1, 6, 6, button_box)
	-- self.current.group_rewards = not self.current.group_rewards
end

---Draws current reward window
---@private
function LU_current:Current_DrawRewardsWindow()
	self.current.y = 4
	self.current.x = 4
	local picked_count = ML.rewards_deck.picked_count
	if picked_count < 1 then
		self:ColorGray()
		self:TextCentered(0, 0, self:Locale("$ml_current_none"), self.scroll.width)
		return
	end
	if self.current.group_rewards then
		self:Current_DrawGroupedRewards()
	else
		self:Current_DrawSeparatedRewards()
	end

	self:Current_DrawChangeButton()
	self:TextCentered(0, self.current.y + 27 - self.scroll.y, self:Locale("$ml_current_rewards: ") .. picked_count,
		self.scroll.width)
end

---function to draw current rewards
---@private
function LU_current:Current_DrawRewards()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.z + 1, self.const.ui_9piece_gray,
		self.Current_DrawRewardsWindow)
end

return LU_current
