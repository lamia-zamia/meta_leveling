---@class level_ui
local LU_debug = {}

local cheat = {
	draw_rewards = false,
	draw_deck = false,
}

function LU_debug:debug_all_rewards_tooltip(reward)
	self:ColorGray()
	self:Text(0, 0, "id: " .. reward.id)
	self:Text(0, 0, "name: " .. self:Locale(reward.ui_name))
	if reward.description then
		self:Text(0, 0, "desk: " .. self:UnpackDescription(reward.description, reward.description_var))
	end
	if reward.description2 then
		self:ColorGray()
		self:Text(0, 0, "desk2: " .. self:UnpackDescription(reward.description2, reward.description2_var))
	end
	self:Text(0, 0, "prob: " .. ML.rewards_deck:get_probability(reward.probability)) ---@diagnostic disable-line: invisible
	if reward.max < 1280 then
		self:Text(0, 0, "max: " .. reward.max)
	end
	if reward.limit_before then
		self:Text(0, 0, "not before: " .. reward.limit_before)
	end
	if reward.custom_check then
		self:Text(0, 0, "custom check: " .. tostring(reward.custom_check()))
	end
	if reward.min_level > 1 then
		self:Text(0, 0, "min level: " .. reward.min_level)
	end
end

function LU_debug:debug_reward_deck_tooltip(text)
	self:Text(0, 0, text)
end

---draws debug window
function LU_debug:DrawDebugWindow()
	local y = 3
	local x = 4
	local distance_between = 25

	local function reset_bools()
		for name, _ in pairs(cheat) do
			cheat[name] = false
		end
	end

	local buttons = {
		{
			ui_name = "Add levels",
			description = "Gain 10 levels",
			fn = function()
				ML.utils:set_global_number(ML.const.globals.current_exp, ML.level_curve[ML:get_level() + 9 + ML.pending_levels])
			end,
		},
		{
			ui_name = "Reset levels",
			description = "Set level to 1",
			fn = function()
				ML.utils:set_global_number(ML.const.globals.current_exp, 0)
				ML.utils:set_global_number(ML.const.globals.current_level, 1)
			end,
		},
		{
			ui_name = "Rewards",
			description = "You gain choosen rewards",
			fn = function()
				self:ResetScrollBoxHeight()
				reset_bools()
				cheat.draw_rewards = true
			end,
		},
		{
			ui_name = "Deck",
			description = "Show current deck",
			fn = function()
				self:ResetScrollBoxHeight()
				reset_bools()
				cheat.draw_deck = true
			end,
		}
	}

	for _, button in ipairs(buttons) do
		self:Text(x, y - self.scroll.y, button.ui_name)
		local prev = self:GetPrevious()
		x = x + prev.w + 10
		if self:ElementIsVisible(y, distance_between) then
			self:MakeButtonFromPrev(button.description, button.fn, self.const.z, self.const.ui_9p_button,
				self.const.ui_9p_button_hl)
		end
	end

	if cheat.draw_rewards then
		self:Text(0, y + 10 - self.scroll.y, string.rep("_", 60))
		self:TextCentered(0, y + 19 - self.scroll.y, "Choose reward", self.const.width)
		self:Text(0, y + 23 - self.scroll.y, string.rep("_", 60))
		y = y + 13 + distance_between
		x = 3
		for _, reward in self:orderedPairs(ML.rewards_deck.reward_data) do
			if x + distance_between / 2 > self.const.width then
				x = 3
				y = y + distance_between
			end
			if self.data.scrollbox_height < y and self.data.scrollbox_height < self.const.height_max then
				self.data.scrollbox_height = self.data.scrollbox_height + distance_between
			end
			self:Text(x, y - self.scroll.y, "")
			local prev = self:GetPrevious()
			self:ForceFocusable()
			self:Draw9Piece(prev.x, prev.y, self.const.z, 16, 16, self.const.ui_9p_reward, self.const.ui_9p_reward_hl)
			prev = self:GetPrevious()
			if not prev.hovered then
				self:ColorGray()
			end
			self:Image(x, y - self.scroll.y, reward.ui_icon)
			if self:ElementIsVisible(y, distance_between) then
				prev = self:GetPrevious()
				if prev.hovered then
					local cache = self:GetTooltipData(0, distance_between, self.debug_all_rewards_tooltip, reward)
					self:AddTooltip((cache.width - 16) / -2, distance_between, self.debug_all_rewards_tooltip, reward)
					if InputIsMouseButtonJustDown(1) or InputIsMouseButtonJustDown(2) then -- mouse clicks
						ML.rewards_deck:pick_reward(reward.id)
					end
				end
			end
			x = x + distance_between
		end
	end

	if cheat.draw_deck then
		if #ML.rewards_deck.list == 0 then ML.rewards_deck:refresh_reward_order() end ---@diagnostic disable-line: invisible
		local list = ML.rewards_deck.list ---@diagnostic disable-line: invisible
		local current_index = ML.utils:get_global_number(ML.const.globals.draw_index, 1)
		self:Text(0, y + 10 - self.scroll.y, string.rep("_", 60))
		self:TextCentered(0, y + 19 - self.scroll.y,
			"Deck, current index: " .. current_index .. ", total number: " .. #list, self.const.width)
		self:Text(0, y + 23 - self.scroll.y, string.rep("_", 60))
		y = y + 13 + distance_between
		x = 3
		distance_between = 14
		for i, reward_id in ipairs(list) do
			local reward = ML.rewards_deck.reward_data[reward_id]
			if x + distance_between / 2 > self.const.width then
				x = 3
				y = y + distance_between
			end
			if self.data.scrollbox_height < y and self.data.scrollbox_height < self.const.height_max then
				self.data.scrollbox_height = self.data.scrollbox_height + distance_between
			end
			self:Text(x, y - self.scroll.y, "")
			local prev = self:GetPrevious()
			if i >= current_index and i < current_index + ML.rewards_deck:get_draw_amount() then
				self:Draw9Piece(prev.x, prev.y, self.const.z, 8, 8, self.const.ui_9p_reward_hl)
			else
				self:Draw9Piece(prev.x, prev.y, self.const.z, 8, 8, self.const.ui_9p_reward)
				self:ColorGray()
			end
			self:Image(x, y - self.scroll.y, reward.ui_icon, 1, 0.5, 0.5)
			if self:ElementIsVisible(y, distance_between) then
				self:Draw9Piece(prev.x, prev.y, self.const.z, 8, 8, self.c.empty)
				local cache = self:GetTooltipData(0, distance_between, self.debug_reward_deck_tooltip, "index: " .. i .. ", id: " .. reward_id)
				self:AddTooltip((cache.width - 8) / -2, distance_between + 8, self.debug_reward_deck_tooltip, "index: " .. i .. ", id: " .. reward_id)
			end
			x = x + distance_between
		end
	end

	self:Text(0, y, "") -- set height for scrollbar, 9piece works weird
end

function LU_debug:DrawDebugMenu()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x - 1, self.data.y, self.const.width + 2, self.data.scrollbox_height, self.const.z + 1,
		self.const.ui_9piece_gray,
		self.DrawDebugWindow)
end

return LU_debug
