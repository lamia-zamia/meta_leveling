---@class level_ui
local LU_current = {}

-- ############################################
-- ########		CURRENT REWARDS		###########
-- ############################################

---function to draw tooltip on current rewards
---@private
---@param rewards ml_reward_id[]
function LU_current:DrawCurrentRewardsTooltip(rewards)
	for _, reward_id in ipairs(rewards) do
		local reward = ML.rewards_deck.reward_data[reward_id]
		if reward.pick_count > 0 then
			local text = reward.pick_count .. "x [" .. ML.rewards_deck.FormatString(self:Locale(reward.ui_name)) .. "]"
			local description = ML.rewards_deck:UnpackDescription(reward.description, reward.description_var)
			if description then text = text .. " " .. description end
			text = text .. "\n"
			self:Text(0, 0, text)
		end
	end
end

---function to draw rewards itself
---@private
function LU_current:DrawCurrentRewardsItems()
	local y = 4
	local x = 4
	local distance_between = 29.585 -- don't question my sanity pls
	local picked_count = ML.rewards_deck.picked_count
	if picked_count < 1 then
		self:ColorGray()
		self:TextCentered(0, 0, self:Locale("$ml_current_none"), self.scroll.width)
		return
	end
	for _, group in ipairs(ML.rewards_deck.ordered_groups_data) do
		if group.picked then
			if x + distance_between / 2 > self.const.width then
				x = 4
				y = y + distance_between
			end
			self:DrawRewardRarity(x - 4, y - 4 - self.scroll.y, self.const.z, ML.rewards_deck.borders.common)
			self:Image(x, y - self.scroll.y, ML.rewards_deck.reward_data[group.rewards[1]].ui_icon)
			local prev = self:GetPrevious()
			self:Draw9Piece(prev.x - 1, prev.y - 1, self.const.z, 18, 18, self.const.ui_9p_reward)
			if self:ElementIsVisible(y, distance_between) then
				local cache = self:GetTooltipData(0, distance_between, self.DrawCurrentRewardsTooltip, group.rewards)
				self:AddTooltip((cache.width - 16) / -2, distance_between, self.DrawCurrentRewardsTooltip, group.rewards)
			end
			x = x + distance_between
		end
	end
	self:TextCentered(0, y + 27 - self.scroll.y, self:Locale("$ml_current_rewards: ") .. picked_count, self.scroll.width)
end

---function to draw current rewards
---@private
function LU_current:DrawCurrentRewards()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.z + 1, self.const.ui_9piece_gray,
		self.DrawCurrentRewardsItems)
end

return LU_current
