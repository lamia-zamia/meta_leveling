---@class level_ui
local LU_level_up = {}

---tooltip render for rewards
---@private
---@param reward ml_single_reward_data
function LU_level_up:RewardsTooltip(reward)
	local texts = {
		name = self:FormatString(self:Locale(reward.ui_name)),
		description = self:UnpackDescription(reward.description, reward.description_var),
		description2 = self:UnpackDescription(reward.description2, reward.description2_var)
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
function LU_level_up:SkipReward()
	ML.rewards_deck:skip_reward()
	self:CloseRewardUI()
end

---Reroll button
---@private
function LU_level_up:Reroll()
	self:AnimReset("rewards")
	ML.rewards_deck:reroll()
	self.data.reward_list = ML.rewards_deck:draw_reward()
end

---Choose reward
---@private
---@param reward ml_single_reward_data
function LU_level_up:PickReward(reward)
	ML.rewards_deck:pick_reward(reward.id)
	self:CloseRewardUI()
end

---draw level up buttons
---@private
---@param button_y number
function LU_level_up:DrawButtonsCentered(button_y)
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
function LU_level_up:DrawPointSpenderRewards(x, y, data)
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
function LU_level_up:DrawPointSpender()
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
function LU_level_up:CloseRewardUI()
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
function LU_level_up:OpenLevelUpMenu()
	GamePlaySound(ML.const.sounds.click.bank, ML.const.sounds.click.event, 0, 0)
	GameAddFlagRun(ML.const.flags.leveling_up)
	self:AnimReset("rewards")
end

return LU_level_up
