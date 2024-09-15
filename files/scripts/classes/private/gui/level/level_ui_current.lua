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
			local text = reward.pick_count .. "x [" .. self:FormatString(self:Locale(reward.ui_name)) .. "]"
			local description = self:UnpackDescription(reward.description, reward.description_var)
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

	for _, group in self:orderedPairs(ML.rewards_deck.groups_data) do
		if group.picked then
			if x + distance_between / 2 > self.const.width then
				x = 4
				y = y + distance_between
			end
			if self.data.scrollbox_height < y + distance_between and self.data.scrollbox_height < self.const.height_max then
				self.data.scrollbox_height = math.min(y + distance_between + 1, self.const.height_max)
			end
			self:DrawRewardRarity(x - 4, y - 4 - self.scroll.y, self.const.z, ML.rewards_deck.borders.common)
			self:Image(x, y - self.scroll.y, ML.rewards_deck.reward_data[group.rewards[1]].ui_icon)
			local prev = self:GetPrevious()
			self:Draw9Piece(prev.x - 1, prev.y - 1, self.const.z, 18, 18, self.const.ui_9p_reward)
			if self:ElementIsVisible(y, distance_between) then
				local cache = self:GetTooltipData(0, distance_between, self.DrawCurrentRewardsTooltip, group.rewards)
				self:AddTooltip((cache.width - 16) / - 2, distance_between, self.DrawCurrentRewardsTooltip, group.rewards)
			end
			x = x + distance_between
		end
	end
	self:Text(0, y, "") -- set height for scrollbar, 9piece works weird
end

---function to draw current rewards
---@private
function LU_current:DrawCurrentRewards()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.width, self.data.scrollbox_height, self.const.z + 1,
		self.const.ui_9piece_gray,
		self.DrawCurrentRewardsItems)
end

return LU_current