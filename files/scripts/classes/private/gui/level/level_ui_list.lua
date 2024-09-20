---@class level_ui
local LU_list = {}

---Draws tooltip
---@private
---@param reward ml_single_reward_data
---@param count number
function LU_list:DrawRewardsListTooltip(reward, count)
	if count > 0 then
		self:TextCentered(0, 0, self:Locale(reward.ui_name), 0)
		self:TextCentered(0, 0, self:Locale("$ml_rewards_progression_picked: ") .. count, 0)
	else
		self:TextCentered(0, 0, self:Locale("$progress_unknown"), 0)
	end
	local reward_appended_by = ML.rewards_deck.reward_appended_by[reward.id]
	if reward_appended_by then
		self:TextCentered(0, 0, self:Locale("$ml_rewards_added_by: " .. reward_appended_by), 0)
	end
end

---Draws an individual reward
---@private
---@param x number
---@param y number
---@param reward ml_single_reward_data
---@param hovered boolean
function LU_list:DrawRewardListEntry(x, y, reward, hovered)
	local bg = "mods/meta_leveling/files/gfx/ui/reward_list_bg_unknown.png"
	local scale_border = hovered and 1.1 or 1
	local scale_img = hovered and 1.2 or 1
	local offset_border = hovered and 3 or 2
	local offset_img = hovered and 1.6 or 0
	local count = ML.rewards_deck:reward_picked_up_count_all_time(reward.id)
	if count > 0 then
		bg = "mods/meta_leveling/files/gfx/ui/reward_list_bg.png"
		self:SetZ(self.const.z - 3)
		self:Image(x - offset_img, y - self.scroll.y - offset_img, reward.ui_icon, 1, scale_img, scale_img)
		-- local r, g, b, a = unpack(reward.border_color)
		-- self:Color(r , g, b, 0.01)
	end
	self:SetZ(self.const.z - 1)
	self:Image(x - offset_border, y - self.scroll.y - offset_border, bg, 1, scale_border, scale_border)
	if hovered then
		local prev = self:GetPrevious()
		self:ShowTooltip(prev.x + 11, prev.y + 30, self.DrawRewardsListTooltip, reward, count) end
end

---function to draw rewards itself
---@private
function LU_list:DrawRewardsListInside()
	local y = 3
	local x = 3
	local distance_between = 21.3 -- don't question my sanity pls

	for _, reward in ipairs(ML.rewards_deck.ordered_rewards_data) do
		if x + distance_between / 2 > self.const.width then
			x = 3
			y = y + distance_between
		end
		local prev = { hovered = false }
		if self:ElementIsVisible(y, distance_between) then
			self:Draw9Piece(self.data.x + x, self.data.y + y - self.scroll.y, 0, 16, 16, self.c.empty, self.c.empty)
			prev = self:GetPrevious()
		end
		self:DrawRewardListEntry(x, y, reward, prev.hovered)



		x = x + distance_between
	end

	self:Text(0, y + 27, "")
end

---function to draw current rewards
---@private
function LU_list:DrawRewardsList()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.z + 1, self.const.ui_9piece_gray,
		self.DrawRewardsListInside)
end

return LU_list
