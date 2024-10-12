--- @class (exact) level_ui
--- @field private stats any
local LU_stats = {
	stats = {
		longest = 0,
		distance = 10
	},
}

function LU_stats:StatsText(x, y, text, hovered, r, g, b)
	if hovered then self:Color(r, g, b) end
	self:Text(x, y, text, "data/fonts/font_pixel_noshadow.xml")
end

function LU_stats:StatsHideEntry(stat)
	return stat.check_before_show and not stat.check_before_show()
end

--- Draws category
--- @param category string
--- @param category_name string
--- @param folded boolean
--- @return boolean
function LU_stats:StatsDrawCategory(category, category_name, folded)
	local img = folded and "data/ui_gfx/button_fold_close.png" or "data/ui_gfx/button_fold_open.png"
	local category_text = self:Locale(category_name)
	local dim = self:GetTextDimension(category_text, "data/fonts/font_pixel_noshadow.xml")
	local hovered = self:IsHoverBoxHovered(self.data.x, self.data.y + self.stats.y - self.scroll.y, self.scroll.width, 10)
	self:StatsText(self.stats.x, self.stats.y - self.scroll.y, category_text, hovered, 1, 1, 0.7)
	if hovered then self:Color(1, 1, 0.7) end
	self:Image(self.stats.x + dim, self.stats.y - self.scroll.y, img)
	if hovered and self:IsLeftClicked() then
		ML.stats.unfolded[category] = not ML.stats.unfolded[category]
	end
	return true
end

function LU_stats:StatsDrawEntry(stat)
	if self:StatsHideEntry(stat) then return end
	local hovered = self:IsHoverBoxHovered(self.data.x, self.data.y + self.stats.y - self.scroll.y, self.scroll.width, 10)
	self:ColorGray()
	self:StatsText(self.stats.x + 5, self.stats.y - self.scroll.y, self:Locale(stat.ui_name) .. ":", hovered, 0.6,
		0.9,
		0.7)
	self:StatsText(self.stats.x + self.stats.longest + 15, self.stats.y - self.scroll.y, self:Locale(stat.value()),
		hovered, 0.6, 0.9, 0.7)
	self.stats.y = self.stats.y + self.stats.distance
end

function LU_stats:StatsDrawEntries(category)
	local category_list = ML.stats.list[category]
	for i = 1, #category_list do
		self:StatsDrawEntry(category_list[i])
	end
end

function LU_stats:StatsDrawWindow()
	self.stats.x = 3
	self.stats.y = 0
	for category, category_name in pairs(ML.stats.categories) do
		local show = ML.stats.unfolded[category]
		if self:StatsDrawCategory(category, category_name, show) then
			self.stats.y = self.stats.y + self.stats.distance
			if show then self:StatsDrawEntries(category) end
		end
	end
	self:Text(0, self.stats.y, "") -- set height for scrollbar, 9piece works weird
end

function LU_stats:StatsDrawMenu()
	self.data.y = self.data.y + self.const.sprite_offset
	self:ScrollBox(self.data.x, self.data.y, self.const.z + 1, self.const.ui_9piece_gray, 0, 0, self.StatsDrawWindow)
end

function LU_stats:StatsFindLongest()
	local longest = 0
	for category, _ in pairs(ML.stats.categories) do
		local category_list = ML.stats.list[category]
		for i = 1, #category_list do
			local stat = category_list[i]
			longest = math.max(longest, self:GetTextDimension(self:Locale(stat.ui_name)))
		end
	end
	self.stats.longest = longest
end

return LU_stats
