---@class level_ui
local LU_meta = {
	meta = {
		y = 0,
		distance = 10,
		bar = {
			width = 90,
			height = 5,
			offset = 100,
		}
	}
}

---Tooltip for text and description
---@private
---@param point ml_progress_point_run
function LU_meta:ProgressPointTooltipText(point)
	local changed = point.current_value ~= point.next_value
	self:TextCentered(0, 0, ML.rewards_deck.FormatString(self:Locale(point.ui_name)), 0)
	local description = ML.rewards_deck:UnpackDescription(point.description, point.description_var)
	if description then
		self:ColorGray()
		self:TextCentered(0, 0, description, 0)
	end
	self:TextCentered(0, 0,
		ML.rewards_deck.FormatString(self:Locale("$ml_meta_current: " .. point.applied_bonus(point.current_value))),
		0)
	if changed then
		self:Color(1, 1, 0.4)
		self:TextCentered(0, 0,
			ML.rewards_deck.FormatString(self:Locale("$ml_meta_next: " .. point.applied_bonus(point.next_value))),
			0)
	end
end

---Tooltip for bar
---@private
---@param point ml_progress_point_run
function LU_meta:ProgressPointTooltipBar(point)
	self:ColorGray()
	self:TextCentered(0, 0, point.next_value .. " / " .. point.stack, 0)
	self:ProgressPointTooltipText(point)
end

---Tooltip for progress manipulator buttons
---@private
---@param point ml_progress_point_run
---@param value number
---@param decrease boolean
function LU_meta:ProgressPointManipulatorTooltip(point, value, decrease)
	local text = decrease and self:Locale("$ml_cost_return: ") or self:Locale("$ml_cost: ")
	self:TextCentered(0, 0, text .. value .. self:Locale(" $ml_meta_points"), 0)
	self:ProgressPointTooltipBar(point)
end

---Tooltip for available points
---@private
---@param text string
function LU_meta:ProgressDisplayAvailablePointsTooltip(text)
	self:TextCentered(0, 0, text, 0)
	self:ColorGray()
	self:TextCentered(0, 0, self:Locale("$ml_meta_available_tp"), 0)
end

---Display available points
---@private
function LU_meta:ProgressDisplayAvailablePoints()
	local text = self:Locale("$ml_meta_available: ") .. MLP.points:get_current_currency()
	local text_dim = self:GetTextDimension(text)
	self:Text(self.const.width - text_dim, 0, text)
	self:AddTooltip(text_dim / 2, self.meta.distance * 2, self.ProgressDisplayAvailablePointsTooltip, text)
end

---Add hoverbox and tooltip if element is visible
---@private
---@param x number
---@param y number
---@param w number
---@param h number
---@param x_off number
---@param y_off number
---@param fn function
---@param ... any
function LU_meta:ProgressPointAddTooltip(x, y, w, h, x_off, y_off, fn, ...)
	if self:ElementIsVisible(self.meta.y, self.meta.distance) then
		self:Draw9Piece(x, y, 50, w, h, self.c.empty)
		self:AddTooltip(x_off, y_off, fn, ...)
	end
end

---Color for bar border
---@private
---@param x number
---@param y number
---@param width number
---@param height number
function LU_meta:PointProgressBarBorderColor(x, y, width, height)
	self:Color(0.66, 0.73, 0.73)
	self:Image(x, y, self.c.px, 1, width, height)
end

---Color for bar background
---@private
---@param x number
---@param y number
---@param width number
---@param height number
function LU_meta:PointProgressBarBackgroundColor(x, y, width, height)
	self:ColorGray()
	self:Image(x, y, self.c.px, 0.5, width, height)
end

---Draws a border around the bar
---@private
function LU_meta:DrawPointProgressBarBorder()
	local x = self.meta.bar.offset
	local width = self.meta.bar.width
	local height = self.meta.bar.height
	-- Draw the top border
	self:PointProgressBarBorderColor(x, self.meta.y + 3 - self.scroll.y, width - 1, 1)
	-- Draw the bottom border
	self:PointProgressBarBorderColor(x, self.meta.y + height + 2 - self.scroll.y, width - 1, 1)
	-- Draw the left border
	self:PointProgressBarBorderColor(x - 1, self.meta.y + 3 - self.scroll.y, 1, height - 1)
	-- Draw the right border
	self:PointProgressBarBorderColor(x + width - 1, self.meta.y + 4 - self.scroll.y, 1, height - 1)
end

---Draws progress bar segment
---@private
---@param index number number of segment
---@param current number number of currently owned
---@param next number
---@param x number x position
---@param width number width of segment
function LU_meta:DrawPointProgressBarSegment(index, current, next, x, width)
	if index <= math.min(current, next) then
		-- This part will remain acquired in the next run
		self:Color(0, 0.8, 0.5)
	elseif next > current and index <= next then
		-- This part will be acquired in the next run
		self:Color(1, 0.7, 0.3)
	elseif next < current and index <= current then
		-- This part will be lost in the next run
		self:Color(0.1, 0.4, 1)
	else
		-- This part is unacquired
		self:Color(0.6, 0.6, 0.6)
	end
	self:Image(x, self.meta.y + 4 - self.scroll.y, self.c.px, 0.8, width, self.meta.bar.height - 2)
end

---Draws semitransparent black lines to add gradient to bar
---@private
function LU_meta:DrawPointProgressBarSegmentGradient()
	local x = self.meta.bar.offset
	local y = self.meta.y + 3 - self.scroll.y
	local gradient_step = 0.25
	for i = 1, self.meta.bar.height - 1, gradient_step do
		self:Color(0, 0, 0)
		self:Image(x, y + i, self.c.px, i / 15, self.meta.bar.width, gradient_step)
	end
end

---Draws progress bar
---@private
---@param point ml_progress_point_run
function LU_meta:DrawPointProgressBar(point)
	local stack = point.stack
	local segment_width = self.meta.bar.width / stack
	for i = 1, stack do
		local x_offset = self.meta.bar.offset + (i - 1) * segment_width
		self:DrawPointProgressBarSegment(i, point.current_value, point.next_value, x_offset, segment_width)

		if i < stack then
			self:SetZ(self.const.z - 5)
			self:PointProgressBarBorderColor(x_offset + segment_width - 1, self.meta.y + 4 - self.scroll.y, 1,
				self.meta.bar.height - 2)
		end
	end
	GuiZSet(self.gui, self.const.z - 4)
	self:DrawPointProgressBarSegmentGradient()
end

---Draws bar background
---@private
function LU_meta:DrawPointProgressBarBackground()
	self:PointProgressBarBackgroundColor(self.meta.bar.offset - 1.25, self.meta.y - self.scroll.y + 2.5,
		self.meta.bar.width + 0.75, 1)
	self:PointProgressBarBackgroundColor(self.meta.bar.offset - 1.25, self.meta.y - self.scroll.y + 3.5,
		self.meta.bar.width + 1.75, self.meta.bar.height - 1.25)
	self:PointProgressBarBackgroundColor(self.meta.bar.offset - 0.25,
		self.meta.y - self.scroll.y + self.meta.bar.height + 2.25, self.meta.bar.width + 0.75, 1)
end

---Draws progress element
---@private
---@param point ml_progress_point_run
function LU_meta:DrawPointProgress(point)
	self:AddOption(2)
	self:DrawPointProgressBarBackground()
	local prev = self:GetPrevious()
	self:ProgressPointAddTooltip(prev.x, prev.y - 4, prev.w, self.meta.bar.height, self.meta.bar.width / 2,
		self.meta.distance * 2, self.ProgressPointTooltipBar, point)
	GuiZSet(self.gui, self.const.z - 3)
	self:DrawPointProgressBar(point)

	GuiZSet(self.gui, self.const.z - 5)
	self:DrawPointProgressBarBorder()

	GuiOptionsRemove(self.gui, 2)
	GuiZSet(self.gui, self.const.z)
end

---Draws plus sign
---@private
---@param index number
---@param point ml_progress_point_run
function LU_meta:DrawPointIncreaser(index, point)
	local x = self.meta.bar.offset + self.meta.bar.width + 3.5
	local y = self.meta.y - self.scroll.y
	local next_val = point.next_value
	if next_val >= point.stack then return end
	local price = point.price[next_val + 1]
	local available = MLP.points:get_current_currency() >= price
	local color = available and { 0.5, 0.8, 0.5 } or { 0.5, 0.5, 0.5 }
	self:Draw9Piece(x + self.data.x, y + self.data.y + 3, self.const.z + 2, 5, 5, self.c.empty)
	if self:ElementIsVisible(self.meta.y, self.meta.distance) then
		local prev = self:GetPrevious()
		if prev.hovered then
			self.tooltip_reset = false
			self:ShowTooltip(prev.x + 2.5, prev.y + self.meta.distance * 2, self.ProgressPointManipulatorTooltip, point,
				price, false)
			self:Draw9Piece(x + self.data.x, y + self.data.y + 3, self.const.z + 2, 5, 5,
				available and self.const.ui_9p_button_hl or self.const.ui_9p_button)
			if available then
				-- self:Draw9Piece(x + self.data.x, y + self.data.y + 3, self.const.z + 2, 5, 5, self.const.ui_9p_button_hl)
				if InputIsMouseButtonJustDown(1) then
					ML.meta:set_next_progress(index, 1)
					-- GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/perk/create", ML.player.x, ML.player.y)
					GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_click", ML.player.x,
						ML.player.y)
				end
			end
		end
	end
	self:Color(unpack(color))
	self:Text(x, y, "+")
end

---Draws minus sign
---@private
---@param index number
---@param point ml_progress_point_run
function LU_meta:DrawPointDecreaser(index, point)
	local x = self.meta.bar.offset - 9
	local y = self.meta.y - self.scroll.y
	local next_val = point.next_value
	if next_val <= 0 then return end
	local return_value = point.price[next_val]
	self:Draw9Piece(x + self.data.x, y + self.data.y + 3, self.const.z + 2, 5, 5, self.c.empty)
	if self:ElementIsVisible(self.meta.y, self.meta.distance) then
		local prev = self:GetPrevious()
		if prev.hovered then
			self.tooltip_reset = false
			self:ShowTooltip(prev.x + 2.5, prev.y + self.meta.distance * 2, self.ProgressPointManipulatorTooltip, point,
				return_value, true)
			self:Draw9Piece(x + self.data.x, y + self.data.y + 3, self.const.z + 2, 5, 5, self.const.ui_9p_button_hl)
			if InputIsMouseButtonJustDown(1) then
				ML.meta:set_next_progress(index, -1)
				GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_click", ML.player.x,
					ML.player.y)
			end
		end
	end
	self:Color(0.5, 0.5, 0.8)
	self:Text(x, y, "-")
end

---Draws progress line
---@private
---@param index number
---@param point ml_progress_point_run
function LU_meta:DrawPointProgressElement(index, point)
	local progress_name = ML.rewards_deck.FormatString(self:Locale(point.ui_name))
	self:Text(0, self.meta.y - self.scroll.y, progress_name .. ":")
	local prev = self:GetPrevious()
	self:ProgressPointAddTooltip(prev.x, prev.y + 1, prev.w, prev.h - 2, self:GetTextDimension(progress_name) / 2,
		self.meta.distance * 2, self.ProgressPointTooltipText, point)
	self:DrawPointProgress(point)
	self:DrawPointDecreaser(index, point)
	self:DrawPointIncreaser(index, point)
end

---Window inside scrollbox
---@private
function LU_meta:DrawMetaWindow()
	self:ProgressDisplayAvailablePoints()
	self.meta.y = 1
	for i, progress in ipairs(ML.meta.progress) do
		self:DrawPointProgressElement(i, progress)
		self.meta.y = self.meta.y + self.meta.distance
	end
	self:Text(0, self.meta.y, "") -- set height for scrollbar, 9piece works weird
end

---Calculates bar offset depending on the longest ui name
---@private
function LU_meta:CalculateProgressOffset()
	local texts = {}
	for _, point in ipairs(ML.meta.progress) do
		texts[#texts + 1] = self:Locale(point.ui_name)
	end
	self.meta.bar.offset = self:GetLongestText(texts, "meta_progress_offset") + 20
end

---Scrollbox window
---@private
function LU_meta:DrawMetaMenu()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.z + 10, self.const.ui_9piece_gray, self.DrawMetaWindow)
end

return LU_meta
