---@class level_ui
---@field itembox_position position_data
---@field stashed ml_reward_id[]|nil
---@field itembox_index number
---@field itembox_hotkey number
local itembox = {
	itembox = {
		x = 50,
		y = 60,
	},
	itembox_position = {
		prefix = "meta_leveling.itembox_position",
		x = 0,
		y = 0,
		moving = false,
		moving_start_x = 0,
		moving_start_y = 0,
		default_x = 620,
		default_y = 340,
		max_x = 640,
		max_y = 360,
	},
	itembox_index = 1,
	itembox_hotkey = 0,
}

function itembox:can_stash()
	local meta = ModSettingGet("meta_leveling.progress_extra_stash") or 0
	local amount = self.stashed and #self.stashed or 0
	return amount < meta + 1
end

function itembox:stash_set()
	local stash_string = self.stashed and table.concat(self.stashed, ",") or ""
	GlobalsSetValue("META_LEVELING_STASHED_REWARDS", stash_string)
end

function itembox:stash_get()
	local stash_arr = {}
	local stash_string = GlobalsGetValue("META_LEVELING_STASHED_REWARDS", "")
	for reward in stash_string:gmatch("([^,]+)") do
		stash_arr[#stash_arr + 1] = reward
	end
	if #stash_arr > 0 then self.stashed = stash_arr end
end

function itembox:stash_use(reward_id)
	table.remove(self.stashed, self.itembox_index)
	ML.rewards_deck:apply_reward(reward_id)
	if #self.stashed < 1 then self.stashed = nil end
	self:stash_set()
	self.itembox_index = 1
end

---Adds a reward to stash
---@private
---@param reward_id ml_reward_id
function itembox:stash_add(reward_id)
	if not self.stashed then self.stashed = {} end
	self.stashed[#self.stashed + 1] = reward_id
	self:stash_set()
end

---Draws a tooltip for stash
---@private
---@param reward ml_single_reward_data
function itembox:itembox_tooltip(reward)
	local text_1 = self:Locale("$ml_stash_apply")
	text_1 = text_1 .. string.format(" (%d/%d)", self.itembox_index, #self.stashed)
	self:ColorGray()
	self:TextCentered(0, 0, text_1, 0)
	self:Text(0, 0, " ")
	local texts = {
		name = ML.rewards_deck.FormatString(self:Locale(reward.ui_name)),
		description = ML.rewards_deck:UnpackDescription(reward.description, reward.description_var),
		description2 = ML.rewards_deck:UnpackDescription(reward.description2, reward.description2_var),
	}
	self:TextCentered(0, 0, texts.name, 0)
	if texts.description then self:TextCentered(0, 0, texts.description, 0) end
	if texts.description2 then
		self:ColorGray()
		self:TextCentered(0, 0, texts.description2, 0)
	end
	-- self:TextCentered(0, 0, "Meta Leveling", 0)
	-- self:TextCentered(0, 0, self:Locale("$ml_level: ") .. ML:get_level(), 0)
	-- self:TextCentered(0, 0, self:Locale("$ml_experience: ") .. MLP.exp:current(), 0)
	self:Text(0, 0, " ")
	self:ColorGray()
	self:TextCentered(0, 0, self:Locale("$ml_position_move"), 0)
	self:ColorGray()
	self:TextCentered(0, 0, self:Locale("$ml_position_reset"), 0)
end

function itembox:draw_itembox()
	if not self.stashed then return end
	local x, y = self.itembox_position.x, self.itembox_position.y

	local reward_hovered = self:IsHoverBoxHovered(x + 3, y + 3, 13, 13, true)
	local scale_img = reward_hovered and 1 or 0.8
	local offset_img = reward_hovered and 1.6 or 3.2

	local reward_id = self.stashed[self.itembox_index]
	local reward = ML.rewards_deck.reward_data[reward_id]

	self:SetZ(self.const.z - 10)
	self:AddOption(self.c.options.NonInteractive)
	self:DrawRewardIcon(x + offset_img, y + offset_img, reward.ui_icon, scale_img)
	self:Draw9Piece(x + 1, y + 2, self.const.z - 8, 18, 16, self.const.ui_9p_button)
	local hovered = self:IsHovered()

	local stashed_amount = #self.stashed

	if stashed_amount > 1 then
		self:SetZ(self.const.z - 9)
		self:Image(x + 6, y + 15, "data/ui_gfx/button_fold_open.png", 0.6, 1, 1, math.pi)
		self:SetZ(self.const.z - 9)
		self:Image(x + 14, y + 5, "data/ui_gfx/button_fold_open.png", 0.6)
		if hovered then
			if InputIsMouseButtonJustDown(self.c.codes.mouse.wheel_down) then self.itembox_index = (self.itembox_index % stashed_amount) + 1 end
			if InputIsMouseButtonJustDown(self.c.codes.mouse.wheel_up) then
				self.itembox_index = (self.itembox_index - 2 + stashed_amount) % stashed_amount + 1
			end
		end
	end

	self:RemoveOption(self.c.options.NonInteractive)

	if self:IsHandlingPositionMovement(self.itembox_position) then return end
	if hovered then
		self:BlockInput()
		if InputIsKeyDown(self.c.codes.keyboard.lshift) then
			self:TriggerPositionMovement(self.itembox_position)
			return
		end

		self:ShowTooltip(x + 9, y + 30, self.itembox_tooltip, reward)
		if self:IsMouseClicked() then self:stash_use(reward_id) end
	end

	if InputIsKeyJustDown(self.itembox_hotkey) then self:stash_use(reward_id) end
end

---Updates itembox data
function itembox:itembox_update_data()
	self.itembox_position.default_x, self.itembox_position.default_y = self.dim.x - 22, self.dim.y - 21
	self.itembox_position.max_x = self.dim.x - 20
	self.itembox_position.max_y = self.dim.y - 20

	self:GetPosition(self.itembox_position)
end

return itembox
