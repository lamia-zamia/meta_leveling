---@class level_ui
local LU_stats = {}

function LU_stats:DrawStatsWindow()
	self:Text(0, 0, "Nope, still WIP")
	self:ColorGray()
	self:Text(0, 8, "(i have no idea what to put here tbh)")
end

function LU_stats:DrawStatsMenu()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.width, self.data.scrollbox_height, self.const.z + 1,
		self.const.ui_9piece_gray,
		self.DrawStatsWindow)
end

return LU_stats