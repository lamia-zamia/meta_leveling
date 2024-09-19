---@class level_ui
local LU_stats = {
	stats_longest = 0
}

function LU_stats:DrawLine(x, y, width, height)
	self:ColorGray()
	self:Image(x, y, self.c.px, 0.5, width, height)
end

function LU_stats:DrawBorders()
	self:DrawLine(0, 0 - self.scroll.y, self.const.width)
	self:DrawLine(0, 0, 1, self.scroll.height_max)
	self:DrawLine(self.const.width - 1, 0, 1, self.scroll.height_max)
end

function LU_stats:Stats_DrawWindow()
	local x = 3
	local y = 0
	local distance_between = 10
	local x_offset = x + self.stats_longest + 10
	self:AddOption(2)
	self:DrawLine(x_offset - 3, 0, 1, self.const.height_max)
	self:DrawBorders()
	for i = 1, #ML.stats.list do
		local stat = ML.stats.list[i]
		if stat.check_before_show and not stat.check_before_show() then goto continue end
		self:Text(x, y - self.scroll.y, self:Locale(stat.ui_name) .. ":", "data/fonts/font_pixel_noshadow.xml")
		self:Text(x_offset, y - self.scroll.y, self:Locale(stat.value()), "data/fonts/font_pixel_noshadow.xml")
		y = y + distance_between
		self:DrawLine(0, y - self.scroll.y, self.const.width, 1)
		::continue::
	end
	self:RemoveOption(2)
	self:Text(0, y + 1, "") -- set height for scrollbar, 9piece works weird
end

function LU_stats:Stats_DrawMenu()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.z + 1, self.const.ui_9piece_gray, self.Stats_DrawWindow)
end

function LU_stats:Stats_FindLongest()
	local longest = 0
	for i = 1, #ML.stats.list do
		longest = math.max(longest, self:GetTextDimension(self:Locale(ML.stats.list[i].ui_name)))
	end
	self.stats_longest = longest
end

return LU_stats
