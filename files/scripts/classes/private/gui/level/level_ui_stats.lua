---@class (exact) level_ui
---@field private stats any
local LU_stats = {
	stats = {
		longest = 0,
		displaying = {},
		distance = 10
	},
}

function LU_stats:Stats_Text(x, y, text, hovered, r, g, b)
	if hovered then self:Color(r, g, b) end
	self:Text(x, y, text, "data/fonts/font_pixel_noshadow.xml")
end

function LU_stats:Stats_HideEntry(stat)
	return stat.check_before_show and not stat.check_before_show()
end

---Draws category
---@param category string
---@param category_name string
---@param folded boolean
---@return boolean
function LU_stats:Stats_DrawCategory(category, category_name, folded)
	local img = folded and "data/ui_gfx/button_fold_close.png" or "data/ui_gfx/button_fold_open.png"
	local category_text = self:Locale(category_name)
	local dim = self:GetTextDimension(category_text, "data/fonts/font_pixel_noshadow.xml")
	self:Draw9Piece(self.data.x, self.data.y + self.stats.y - self.scroll.y, 0, self.scroll.width, 10, self.c
		.empty)
	local prev = self:GetPrevious()
	self:Stats_Text(self.stats.x, self.stats.y - self.scroll.y, category_text, prev.hovered, 1, 1, 0.7)
	if prev.hovered then self:Color(1, 1, 0.7) end
	self:Image(self.stats.x + dim, self.stats.y - self.scroll.y, img)
	if prev.hovered and self:is_mouse_clicked() then
		self.stats.displaying[category] = not self.stats.displaying[category]
		GamePlaySound(MLP.const.sounds.click.bank, MLP.const.sounds.click.event, 0, 0)
	end
	return true
end

function LU_stats:Stats_DrawEntry(stat)
	if self:Stats_HideEntry(stat) then return end
	self:Draw9Piece(self.data.x, self.data.y + self.stats.y - self.scroll.y, 0, self.scroll.width, 10, self.c.empty,
		self.c.empty)
	local prev = self:GetPrevious()
	self:ColorGray()
	self:Stats_Text(self.stats.x + 5, self.stats.y - self.scroll.y, self:Locale(stat.ui_name) .. ":", prev.hovered, 0.6,
		0.9,
		0.7)
	self:Stats_Text(self.stats.x + self.stats.longest + 15, self.stats.y - self.scroll.y, self:Locale(stat.value()),
		prev.hovered, 0.6, 0.9, 0.7)
	self.stats.y = self.stats.y + self.stats.distance
end

function LU_stats:Stats_DrawEntries(category)
	local category_list = ML.stats.list[category]
	for i = 1, #category_list do
		self:Stats_DrawEntry(category_list[i])
	end
end

function LU_stats:Stats_DrawWindow()
	self.stats.x = 3
	self.stats.y = 0
	for category, category_name in pairs(ML.stats.categories) do
		local show = self.stats.displaying[category]
		if self:Stats_DrawCategory(category, category_name, show) then
			self.stats.y = self.stats.y + self.stats.distance
			if show then self:Stats_DrawEntries(category) end
		end
	end
	self:Text(0, self.stats.y, "") -- set height for scrollbar, 9piece works weird
end

function LU_stats:Stats_DrawMenu()
	self.data.y = self.data.y + self.const.sprite_offset
	self:FakeScrollBox(self.data.x, self.data.y, self.const.z + 1, self.const.ui_9piece_gray, self.Stats_DrawWindow)
end

function LU_stats:Stats_FindLongest()
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
