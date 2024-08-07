local UI_class = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/ui_lib.lua")
---@class level_ui:UI_class
---@field private v table
local LU = UI_class:new()

local constants = {
	ui_9piece = "mods/meta_leveling/files/gfx/ui/ui_9piece.png",
	ui_9piece_gray = "mods/meta_leveling/files/gfx/ui/ui_9piece_gray.png",
	ui_9p_reward = "mods/meta_leveling/files/gfx/ui/ui_9piece_reward.png",
	ui_9p_reward_hl = "mods/meta_leveling/files/gfx/ui/ui_9piece_reward_highlight.png",
	ui_9p_button = "mods/meta_leveling/files/gfx/ui/ui_9piece_button.png",
	ui_9p_button_hl = "mods/meta_leveling/files/gfx/ui/ui_9piece_button_highlight.png",
	ui_9p_button_important = "mods/meta_leveling/files/gfx/ui/ui_9piece_button_important.png",
	height = 180,
	width = 320,
	sprite_offset = 20,
	reward_box_size = 24,
	reward_list = nil
}
LU.v = constants
LU.anim_reset = {
	rewards = {
		reset = false,
	},
	header = {
		reset = false,
	},
	window = {
		reset = false,
	}
}

function LU:AnimReset(key)
	self.anim_reset[key].reset = true
	self.anim_reset[key].frame = GameGetFrameNum()
end

function LU:CheckForAnim()
	for key, _ in pairs(self.anim_reset) do
		if self.anim_reset[key].reset then
			if GameGetFrameNum() - self.anim_reset[key].frame > 1 then
				self.anim_reset[key].reset = false
			end
		end
	end
end

function LU:MenuAnimS(key)
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim_reset[key].reset)
	self:AnimateScale(0.08, self.anim_reset[key].reset)
end

---toggle level up menu, adds flag to run so you can't close it
---@private
---@method
function LU:OpenLevelUpMenu()
	GamePlaySound("ui", "ui/button_click", 0, 0)
	GameAddFlagRun(ML.const.flags.leveling_up)
	self:AnimReset("rewards")
end

function LU:CloseRewardUI()
	ML:level_up()
	GameRemoveFlagRun(ML.const.flags.fx_played)
	GamePlaySound("ui", "ui/button_click", 0, 0)
	if ML.exp.percentage < 1 then
		GameRemoveFlagRun(ML.const.flags.leveling_up)
		ML:toggle_ui()
	end
	self.v.reward_list = nil
	self:AnimReset("rewards")
end

---Skip button function
---@private
---@method
function LU:SkipReward()
	ML.rewards_deck:skip_reward()
	self:CloseRewardUI()
end

function LU:PickReward(reward)
	ML.rewards_deck:pick_reward(reward.id)
	self:CloseRewardUI()
end

---tooltip render for rewards
---@private
---@method
---@param reward ml_single_reward
function LU:RewardsTooltip(reward)
	local texts = {
		name = self:Locale(reward.ui_name),
		description = self:GameTextGet(reward.description, reward.var0, reward.var1, reward.var2)
	}
	local longest = self.tp:GetLongestText(texts, reward.ui_name)
	self.tp:TextCentered(0, 0, texts.name, longest)
	self.tp:TextCentered(0, 0, texts.description, longest)
end

---Draw rewards
---@private
---@method
---@param x number
---@param y number
---@param data table
function LU:DrawPointSpenderRewards(x, y, data)
	for i = 1, data.amount do
		local x_offset = x + (data.width + data.width9_offset) * (i - 1)
		local reward_icon = ML.rewards_deck.reward_data[self.v.reward_list[i]].ui_icon
		self:ForceFocusable()
		self:Draw9Piece(x_offset, y, 999, data.width - data.width9_offset, data.height, self.v.ui_9p_reward,
			self.v.ui_9p_reward_hl)
		local tp_offset = (data.width - data.width9_offset) / 2
		self:AddTooltipClickable(tp_offset, data.height * 2, self.RewardsTooltip, self.PickReward,
			ML.rewards_deck.reward_data[self.v.reward_list[i]])
		if not self.v.reward_list then return end
		self:Image(x_offset + (data.width - data.width9_offset - data.icon_size) / 2,
			y + (data.height - data.icon_size) / 2, reward_icon)
	end
end

---draw level up menu
---@private
---@method
function LU:DrawPointSpender()
	self:MenuAnimS("rewards")
	-- self:AddOptionForNext(2)
	-- self:AddOptionForNext(1)
	-- self:SetZ(200000)
	-- self:Draw9Piece(-20, -20, 1999, 1000, 1000, self.v.ui_9piece)
	-- -- self:Image(0, 0, self.c.empty, 1, self.dim.x, self.dim.y)
	-- local prev = self:GetPrevious()
	-- if prev.hovered then
	-- 	-- ML:toggle_ui()
	-- 	print("hovered")
	-- end
	-- self:TextCentered(0, 100, self:Locale("$ml_close_click_anywhere"), self.dim.x)

	if not self.v.reward_list then self.v.reward_list = ML.rewards_deck:draw_reward() end
	local data = {
		amount = #self.v.reward_list,
		width9_offset = 6,
		width = self.v.reward_box_size,
		icon_size = 16,
	}
	data.height = self.v.reward_box_size - data.width9_offset
	data.total_width = data.amount * (data.width + data.width9_offset) - data.width9_offset * 2
	local x, y = self:CalculateCenterInScreen(data.total_width, data.height)
	self:Draw9Piece(x, y, 1000, data.total_width, data.height, self.v.ui_9piece)

	self:DrawPointSpenderRewards(x, y, data)

	self:TextCentered(x + 0.5, y + data.height + data.width9_offset * 3, self:Locale("$ml_skip"), data.total_width)
	self:MakeButtonFromPrev(self:Locale("$ml_skip_tp"), self.SkipReward, self.v.ui_9p_button, self.v.ui_9p_button_hl)
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
			if self.curent_rewards_height < y then 
				self.curent_rewards_height = self.curent_rewards_height + distance_between
			end
			local tooltip = ""
			self:Image(x, y + self.scroll.y, ML.rewards_deck.reward_data[group.rewards[1]].ui_icon)
			self:Draw9Piece(self.x + x, self.y + y, 999, 16, 16, self.v.ui_9p_reward)
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

LU.curent_rewards_height = LU.v.sprite_offset
function LU:DrawCurrentRewards()
	local section = self.curent_rewards_height
	self.y = self.y + self.v.sprite_offset
	self:FakeScrollBox(self.x, self.y, self.v.width, section, self.v.ui_9piece_gray, self.DrawCurrentRewardsItems)
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
		self:Add9PieceBackGroundText(self.v.ui_9p_button_hl, self.v.ui_9p_button_hl)
		self:MakePreviousClickable(self.ToggleMenuWindow, fn)
	else
		self:Text(x, y, text)
		self:MakeButtonFromPrev(tooltip, self.ToggleMenuWindow, self.v.ui_9p_button, self.v.ui_9p_button_hl, fn)
	end
end

function LU:DrawMenuButtons()
	self:MenuAnimS("header")
	local y = self.y - 5.5
	local x = self.x
	local function x_off()
		local prev = self:GetPrevious()
		x = x + prev.w + 10
		return x
	end
	if ML.exp.percentage >= 1 then
		self:Text(x, y, self:Locale("$ml_level_up"))
		self:MakeButtonFromPrev(self:Locale("$ml_level_up_tp"), self.OpenLevelUpMenu, self.v.ui_9p_button_important,
			self.v.ui_9p_button_hl)
	else
		self:TextGray(x, y, self:Locale("$ml_level_up"))
		self:Add9PieceBackGroundText(self.v.ui_9p_button)
	end
	self:AddMenuSelector(x_off(), y, self:Locale("$ml_current_rewards"), "whatever", self.DrawCurrentRewards)

	self:TextGray(x_off(), y, self:Locale("Stats (WIP)"))
	self:Add9PieceBackGroundText(self.v.ui_9p_button)

	self:TextGray(x_off(), y, self:Locale("Meta (WIP)"))
	self:Add9PieceBackGroundText(self.v.ui_9p_button)

	self:Text(self.v.width + self.x - self:GetTextDimension(self:Locale("$ml_close")), y, self:Locale("$ml_close"))
	self:MakeButtonFromPrev(self:Locale("$ml_close_tp"), self.CloseMenu, self.v.ui_9p_button, self.v.ui_9p_button_hl)
	self:AnimateE()
end

function LU:CloseMenu()
	GamePlaySound(ML.const.sound_banks.ui, "ui/button_click", 0, 0)
	ML:toggle_ui()
end

---draw main window
---@private
---@method
function LU:DrawMainHeader()
	self:MenuAnimS("header")
	local section = 10
	local experience = self:Locale("$ml_experience") .. ": " .. ML.exp.current .. " / " .. ML.exp.next
	local level = self:Locale("$ml_level") .. ": " .. ML:get_level()
	self.y = self.y + self.v.sprite_offset
	self:Draw9Piece(self.x, self.y, 1000, self.v.width, section, self.v.ui_9piece)
	self:TextCentered(self.x, self.y, experience, self.v.width * 0.33)
	self:TextCentered(self.x, self.y, "META LEVELING", self.v.width)
	self:TextCentered(self.x + self.v.width * 0.33, self.y, level, self.v.width)
	self:AnimateE()

	self.y = self.y + section + self.v.sprite_offset
end

function LU:DrawMenuConnector()
	self:SetZ(1001)
	self:Draw9Piece(self.x, self.y, 1000, self.v.width, 0, "mods/meta_leveling/files/gfx/ui/ui_9piece_connector.png")
end

LU.DrawWindow = nil

function LU:DrawMainMenu()
	self.x, self.y = self:CalculateCenterInScreen(self.v.width, self.v.height)
	self:DrawMainHeader()
	self:DrawMenuButtons()
	if self.DrawWindow then
		self:AnimateB()
		self:AnimateAlpha(0.08, 0.1, false)
		self:DrawMenuConnector()
		self:AnimateE()
		self:MenuAnimS("window")
		self:DrawWindow()
		self:AnimateE()
	end
end

---main logic
---@private
---@method
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
	self:StartFrame(self.DrawLevelUI, ML.gui)
end

return LU
