---@class UI_const
---@field default_9piece string
local const = {
	empty = "data/ui_gfx/empty.png",
	default_9piece = "data/ui_gfx/decorations/9piece0_gray.png",
	px = "mods/meta_leveling/vfs/white.png",
	gui_id = 100,
}

---@class (exact) UI_dimensions
---@field x number
---@field y number
local dimensions = {
	x = 640,
	y = 360
}

---@class (exact) ui_fake_scroll
---@field y number
---@field target_y number
---@field limit_not_hit boolean
---@field max_y number
---@field move_triggered boolean
---@field position_triggered number
---@field max_y_target number

---@class (exact) UI_class
---@field protected gui gui
---@field private gui_id number
---@field private gui_longest_string_cache table
---@field protected tp tooltip
---@field private __index UI_class
---@field protected c UI_const constants
---@field protected dim UI_dimensions
---@field protected scroll ui_fake_scroll
local ui_class = {
	gui = GuiCreate(),
	gui_id = const.gui_id,
	gui_longest_string_cache = setmetatable({}, { __mode = "k" }),
	c = const,
	dim = dimensions,
	scroll = {
		y = 0,
		target_y = 0,
		max_y = 0,
		limit_not_hit = true,
		move_triggered = false,
		position_triggered = 0,
		max_y_target = 0
	},
}

---create new gui
---@return UI_class
---@protected
function ui_class:new()
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.gui = GuiCreate()
	return o
end

---@class tooltip:UI_class
---@field private gui_tooltip_size_cache table
---@field private tooltip_z number
local tooltip_class = ui_class:new()
tooltip_class.gui_tooltip_size_cache = setmetatable({}, { __mode = "k" })
tooltip_class.tooltip_z = -100

ui_class.tp = tooltip_class

---update dimensions
---@protected
function ui_class:UpdateDimensions()
	GuiStartFrame(self.gui)
	self.dim.x, self.dim.y = GuiGetScreenDimensions(self.gui)
end

---reset gui id
---@protected
function ui_class:id_reset()
	self.gui_id = self.c.gui_id
end

---set color for next widget
---@param r integer
---@param g integer
---@param b integer
---@param a? integer
---@protected
function ui_class:Color(r, g, b, a)
	a = a or 1
	GuiColorSetForNextWidget(self.gui, r, g, b, a)
end

---GuiAnimateAlphaFadeIn
---@param speed integer
---@param step integer
---@param reset boolean
---@protected
function ui_class:AnimateAlpha(speed, step, reset)
	GuiAnimateAlphaFadeIn(self.gui, self:id(), speed, step, reset)
end

---@protected
function ui_class:AnimateScale(acceleration, reset)
	GuiAnimateScaleIn(self.gui, self:id(), acceleration, reset)
end

---End animation
---@protected
function ui_class:AnimateE()
	GuiAnimateEnd(self.gui)
end

---Start animation
---@protected
function ui_class:AnimateB()
	GuiAnimateBegin(self.gui)
end

---return id with increment
---@private
---@return number gui_id
function ui_class:id()
	self.gui_id = self.gui_id + 1
	return self.gui_id
end

---@protected
function ui_class:ForceFocusable()
	self:AddOptionForNext(7)
end

---Returns translated text from $string
---@param string string should be in $string format
---@return string
---@protected
function ui_class:Locale(string)
	local pattern = "%$%w[%w_]+"
	string = string:gsub(pattern, GameTextGetTranslatedOrNot, 1)
	if string:find(pattern) then return self:Locale(string)
	else return string end
end

---Returns GameTextGet with args replaced if input is valid
---@param string string
---@param var0 string
---@param var1? string
---@param var2? string
---@return string
---@protected
function ui_class:GameTextGet(string, var0, var1, var2)
	var0 = self:Locale(var0)
	if var1 then var1 = self:Locale(var1) else var1 = "" end
	if var2 then var2 = self:Locale(var2) else var2 = "" end
	if string:find("^%$") then
		return GameTextGet(string, var0, var1, var2)
	else
		return string
	end
end

---zero or minus
---@private
---@param value number
---@return number
function tooltip_class:ReturnZeroOrMinus(value)
	if value <= 10 then
		return value - 19
	else
		return 0
	end
end

---calculate y offset needed to not go over the screen
---@private
---@param y number
---@param h number
function tooltip_class:GetOffsetY(y, h)
	local y_offset = 0
	if y > self.dim.y * 0.75 then
		y_offset = y_offset - h - 10
	else
		y_offset = self:ReturnZeroOrMinus(self.dim.y - y - h)
	end
	return y_offset
end

---calculate x offset needed to not go over the screen
---@private
---@param x number
---@param w number
function tooltip_class:GetOffsetX(x, w)
	local min_offset = 38
	local x_offset = 0
	if x > self.dim.x * 0.9 then
		x_offset = self.dim.x - x - w - min_offset
	elseif x > self.dim.x * 0.75 then
		x_offset = x_offset - w
		-- if (self.dim.x - x - w) < -min_offset then x_offset = self.dim.x - x - w - min_offset end

		-- if x_offset > -min_offset then x_offset = -min_offset end
	else
		-- if x <= 10 then
		-- 	x_offset = 10
		-- elseif screen_w - x - w <= min_offset then
		-- 	x_offset = screen_w - x - w - min_offset
		-- end
		-- x_offset = ReturnZeroOrMinus(screen_w - x - w )
	end
	return x_offset
end

---set tooltip cache
---@private
---@param key string
---@param x number
---@param y number
function tooltip_class:SetTooltipCache(x, y, key)
	self.gui_tooltip_size_cache[key] = {}
	local prev = self:GetPrevious()
	self.gui_tooltip_size_cache[key].width = prev.w
	self.gui_tooltip_size_cache[key].height = prev.h
	self.gui_tooltip_size_cache[key].x_offset = self:GetOffsetX(x, self.gui_tooltip_size_cache[key].width)
	self.gui_tooltip_size_cache[key].y_offset = self:GetOffsetY(y, self.gui_tooltip_size_cache[key].height)
end

---set tooltip cache if empty
---@private
---@param x number
---@param y number
---@param ui_fn function
---@param variable any
---@param key string
function tooltip_class:GuiTooltipValidateTooltipCache(x, y, ui_fn, variable, key)
	if self.gui_tooltip_size_cache[key] then return end
	local offscreen_offset = 1000
	GuiBeginAutoBox(self.gui)
	GuiLayoutBeginVertical(self.gui, x + offscreen_offset, y + offscreen_offset, true)
	ui_fn(self, variable)
	GuiLayoutEnd(self.gui)
	GuiEndAutoBoxNinePiece(self.gui)
	self:SetTooltipCache(x, y, key)
end

---get dimensions
---@param text string
---@param font? string
---@return number, number
---@protected
function ui_class:GetTextDimension(text, font)
	font = font or ""
	return GuiGetTextDimensions(self.gui, text, 1, 2, font)
end

---actual function to draw tooltip
---@private
---@param x number
---@param y number
---@param ui_fn function
---@param variable any
function tooltip_class:DrawToolTip(x, y, ui_fn, variable)
	local key = self:Locale("$current_language") .. tostring(x) .. tostring(y) .. tostring(ui_fn) .. tostring(variable)
	self:id_reset()
	self:GuiTooltipValidateTooltipCache(x, y, ui_fn, variable, key)
	GuiZSet(self.gui, self.tooltip_z)
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, false)
	self:AnimateScale(0.08, false)
	GuiBeginAutoBox(self.gui)
	GuiLayoutBeginVertical(
		self.gui, x + self.gui_tooltip_size_cache[key].x_offset,
		y + self.gui_tooltip_size_cache[key].y_offset, true
	)
	ui_fn(self, variable)
	GuiLayoutEnd(self.gui)
	GuiZSet(self.gui, self.tooltip_z + 1)
	GuiEndAutoBoxNinePiece(self.gui)
	self:AnimateE()
	GuiZSet(self.gui, 0)
end

---Start frame for tooltip rendering
function tooltip_class:StartFrame()
	self:id_reset()
	if self.gui ~= nil then GuiStartFrame(self.gui) end
end

---Custom tooltip.
---@param x number position of x.
---@param y number position of y.
---@param draw function|string function to render in tooltip.
---@param variable? any optional parameter to pass to ui function.
---@protected
function ui_class:ShowTooltip(x, y, draw, variable)
	local fn_type = type(draw)
	if fn_type == "string" then
		tooltip_class:DrawToolTip(x, y, self.TooltipText, draw)
	elseif fn_type == "function" then
		tooltip_class:DrawToolTip(x, y, draw, variable)
	end
end

---Custom tooltip with hovered check.
---@param x number offset x.
---@param y number offset y.
---@param draw function|string function to render in tooltip.
---@param variable? any optional parameter to pass to ui function.
---@protected
function ui_class:AddTooltip(x, y, draw, variable)
	local prev = self:GetPrevious()
	if prev.hovered then self:ShowTooltip(prev.x + x, prev.y + y, draw, variable) end
end

---Custom tooltip with hovered check and make clickable.
---@param x number offset x.
---@param y number offset y.
---@param draw function|string function to render in tooltip.
---@param variable? any optional parameter to pass to ui function.
---@protected
function ui_class:AddTooltipClickable(x, y, draw, click_fn, variable)
	local prev = self:GetPrevious()
	if prev.hovered then
		self:ShowTooltip(prev.x + x, prev.y + y, draw, variable)
		if InputIsMouseButtonJustDown(1) or InputIsMouseButtonJustDown(2) then -- mouse clicks
			if click_fn then click_fn(self, variable) end
		end
	end
end

---@protected
function ui_class:MakePreviousClickable(click_fn, variable)
	local prev = self:GetPrevious()
	if prev.hovered then
		if InputIsMouseButtonJustDown(1) or InputIsMouseButtonJustDown(2) then -- mouse clicks
			click_fn(self, variable)
		end
	end
end

---@protected
function ui_class:Add9PieceBackGroundText(z, sprite, highlight)
	local prev = self:GetPrevious()
	self:Draw9Piece(prev.x - 1, prev.y, z, prev.w + 1.5, prev.h, sprite, highlight)
end

---@protected
function ui_class:MakeButtonFromPrev(text, click_fn, z, sprite, highlight, variable)
	local prev = self:GetPrevious()
	self:ForceFocusable()
	self:Add9PieceBackGroundText(z, sprite, highlight)
	local tp_offset = (self:GetTextDimension(text) - prev.w - 1.5) / -2
	self:AddTooltipClickable(tp_offset, prev.h * 2, text, click_fn, variable)
end

---@protected
function ui_class:ColorGray()
	self:Color(0.6, 0.6, 0.6)
end

---@param text string
---@param font? string
---@param x number
---@param y number
---@protected
function ui_class:Text(x, y, text, font)
	font = font or ""
	GuiText(self.gui, x, y, text, 1, font)
end

---draw text at 0
---@private
---@param text string
function ui_class:TooltipText(text)
	self:Text(0, 0, text)
end

---return x and y of mouse pos
---@protected
---@return number mouse_x, number mouse_y
function ui_class:get_mouse_pos()
	local mouse_screen_x, mouse_screen_y = InputGetMousePosOnScreen()
	local mx_p, my_p = mouse_screen_x / 1280, mouse_screen_y / 720
	return mx_p * self.dim.x, my_p * self.dim.y
end

---creates invisible scrollbox to block clicks and scrolls
---@protected
function ui_class:BlockInput()
	GuiIdPushString(self.gui, "STOP_FLICKERING_SCROLLBAR")
	local m_x, m_y = self:get_mouse_pos()
	GuiAnimateBegin(self.gui)
	GuiAnimateAlphaFadeIn(self.gui, 2, 0, 0, true)
	GuiOptionsAddForNextWidget(self.gui, 3) --AlwaysClickable
	GuiBeginScrollContainer(self.gui, 2, m_x - 25, m_y - 25, 50, 50, false, 0, 0)
	GuiAnimateEnd(self.gui)
	GuiEndScrollContainer(self.gui)
	GuiIdPop(self.gui)
end

function ui_class:FakeScrollBox_MouseDrag(x, y, width, height, z, sprite_dim)
	local content_height = self.scroll.max_y - y
	local visible_height = height - sprite_dim / 1.5
	local scrollbar_height = (visible_height / content_height) * (height)
	local scrollbar_pos = (self.scroll.y / (content_height - visible_height)) * (height - scrollbar_height)
	self:Draw9Piece(x + width + sprite_dim / 3 - 5, y + scrollbar_pos, z - 1, 0, scrollbar_height)
	self:Draw9Piece(x + width + sprite_dim / 3 - 8, y, z - 1, 6, height, self.c.empty, self.c.empty)
	local scroll_prev = self:GetPrevious()
	if scroll_prev.hovered then
		if InputIsMouseButtonJustDown(1) then
			self.scroll.move_triggered = true
			_, self.scroll.position_triggered = self:get_mouse_pos()
		end
	end
	if not InputIsMouseButtonDown(1) then
		self.scroll.move_triggered = false
		self.scroll.position_triggered = 0
	end
	if self.scroll.move_triggered then
		local _, mouse_y = self:get_mouse_pos()
		local target = self.scroll.target_y + mouse_y - self.scroll.position_triggered
		if target > 0 and target < self.scroll.max_y_target then
			self.scroll.position_triggered = mouse_y
		end
		self.scroll.target_y = math.max(math.min(target, self.scroll.max_y_target), 0)
	end
end

---reply on actions
---@private
function ui_class:FakeScrollBox_MakePreviousScrollable()
	if self.scroll.target_y > 0 and InputIsMouseButtonJustDown(4) then --up
		self.scroll.target_y = self.scroll.target_y - 10
	end
	if self.scroll.target_y < self.scroll.max_y_target and InputIsMouseButtonJustDown(5) then --down
		self.scroll.target_y = self.scroll.target_y + 10
	end
end

---function to clump target and move scroll
---@private
function ui_class:FakeScrollBox_ClumpAndMove()
	if self.scroll.target_y < 0 then self.scroll.target_y = 0 end
	if self.scroll.target_y > self.scroll.max_y_target then self.scroll.target_y = self.scroll.max_y_target end
	if math.abs(self.scroll.target_y - self.scroll.y) < 1 then
		self.scroll.y = self.scroll.target_y
	end

	if self.scroll.target_y ~= self.scroll.y then
		self.scroll.y = (self.scroll.y + self.scroll.target_y) / 2
	end
end

---function to reset scrollbox cache
---@protected
function ui_class:FakeScrollBox_Reset()
	self.scroll.y = 0
	self.scroll.target_y = 0
	self.scroll.max_y = 0
	self.scroll.max_y_target = 0
	self.scroll.limit_not_hit = true
	self.scroll.move_triggered = false
	self.scroll.position_triggered = 0
end

---fake scroll box
---@protected
---@param x number position x
---@param y number position y
---@param width number width
---@param height number height
---@param z number z of scrollbox
---@param sprite string 9piece for scrollbox
---@param draw_fn function function to draw inside scrollbox, position is relative
function ui_class:FakeScrollBox(x, y, width, height, z, sprite, draw_fn)
	local id = self:id()
	local sprite_dim = GuiGetImageDimensions(self.gui, sprite, 1)
	self.scroll.max_y_target = self.scroll.max_y - y - height + sprite_dim / 1.5
	self:Draw9Piece(x, y, z, width, height, sprite)

	---phantom 9piece with corrent hitbox
	self:Draw9Piece(x - sprite_dim / 3, y - sprite_dim / 3, z, width + sprite_dim / 1.5, height + sprite_dim / 1.5,
		self.c.empty, self.c.empty)
	local main_window = self:GetPrevious()
	if main_window.hovered then
		self:BlockInput()
	end
	if self.scroll.max_y > y + height then
		self:FakeScrollBox_MakePreviousScrollable()
		self:FakeScrollBox_MouseDrag(x, y, width, height, z, sprite_dim)
	end

	GuiAnimateBegin(self.gui)
	GuiAnimateAlphaFadeIn(self.gui, id, 0, 0, true)
	GuiBeginAutoBox(self.gui)
	GuiBeginScrollContainer(self.gui, id, x, y, width, height, false, 0, 0)
	GuiEndAutoBoxNinePiece(self.gui)
	GuiAnimateEnd(self.gui)
	draw_fn(self)
	local prev = self:GetPrevious()
	self.scroll.max_y = math.max(self.scroll.max_y, prev.y + prev.h)
	self:FakeScrollBox_ClumpAndMove()
	GuiEndScrollContainer(self.gui)
end

---Function to calculate the longest string in array
---@private
---@param array table strings
---@param key string cache key
---@return number
---@protected
function ui_class:CalculateLongestText(array, key)
	local longest = 0
	for _, text in ipairs(array) do
		local length = self:GetTextDimension(text, "")
		longest = math.max(longest, length)
	end
	self.gui_longest_string_cache[key] = longest
	return self.gui_longest_string_cache[key]
end

---Get the longest string length from array
---@param array table table to look through
---@param key string cache key, should be static enough
---@return number
---@protected
function ui_class:GetLongestText(array, key)
	key = self:Locale("$current_language") .. key
	return self.gui_longest_string_cache[key] or self:CalculateLongestText(array, key)
end

---Set Z for next widget
---@param number number
---@protected
function ui_class:SetZ(number)
	GuiZSetForNextWidget(self.gui, number)
end

---get center of screen
---@return number x, number y
---@protected
function ui_class:CalculateCenterInScreen(width, height)
	local x = (self.dim.x - width) / 2
	local y = (self.dim.y - height) / 2
	return x, y
end

---GuiText but centered
---@param x number
---@param y number
---@param text string
---@param longest number longest string length
---@param font? string
---@protected
function ui_class:TextCentered(x, y, text, longest, font)
	font = font or ""
	local x_offset = (longest - self:GetTextDimension(text, font)) / 2
	GuiText(self.gui, x + x_offset, y, text, 1, font)
end

---for debugging
---@debug
---@protected
function ui_class:DebugDrawGrid()
	for i = 0, 640, 10 do
		if i % 16 == 0 then GuiColorSetForNextWidget(self.gui, 1, 0, 0, 1) end
		GuiImage(self.gui, self:id(), i, 0, self.c.px, 0.2, 1, 360)
	end
	for i = 0, 360, 10 do
		if i % 9 == 0 then GuiColorSetForNextWidget(self.gui, 1, 0, 0, 1) end
		GuiImage(self.gui, self:id(), 0, i, self.c.px, 0.2, 640, 1)
	end
end

---set option for all next widgets
---@param option number
---@protected
function ui_class:AddOption(option)
	GuiOptionsAdd(self.gui, option)
end

---set option for next widget
---@param option number
---@protected
function ui_class:AddOptionForNext(option)
	GuiOptionsAddForNextWidget(self.gui, option)
end

---add image
---@param x number
---@param y number
---@param sprite string
---@param alpha? number
---@param scale_x? number
---@param scale_y? number
---@protected
function ui_class:Image(x, y, sprite, alpha, scale_x, scale_y)
	alpha = alpha or 1
	scale_x = scale_x or 1
	scale_y = scale_y or 1
	GuiImage(self.gui, self:id(), x, y, sprite, alpha, scale_x, scale_y, 0, 2)
end

---draw 9piece
---@param x number
---@param y number
---@param z number
---@param width number
---@param height number
---@param sprite? string
---@param highlight? string
---@protected
function ui_class:Draw9Piece(x, y, z, width, height, sprite, highlight)
	sprite = sprite or self.c.default_9piece
	highlight = highlight or sprite
	GuiZSetForNextWidget(self.gui, z)
	GuiImageNinePiece(self.gui, self:id(), x, y, width, height, 1, sprite, highlight)
end

---add 9piece to previous widget
---@param z number
---@param sprite? string
---@param highlight? string
---@protected
function ui_class:Add9PieceBackGround(z, sprite, highlight)
	sprite = sprite or self.c.default_9piece
	highlight = highlight or sprite
	_, _, _, x, y, w, h = GuiGetPreviousWidgetInfo(self.gui)
	self:Draw9Piece(x, y, z, w, h, sprite, highlight)
end

---@class PreviousInfo
---@field lc boolean left click
---@field rc boolean right click
---@field hovered boolean hovered
---@field x number
---@field y number
---@field w number
---@field h number

---returns previous widget info
---@return PreviousInfo return hover, x, y, w, h
---@protected
---@nodiscard
function ui_class:GetPrevious()
	local lc, rc, prev_hovered, x, y, width, height = GuiGetPreviousWidgetInfo(self.gui)
	local table = {
		lc = lc,
		rc = rc,
		hovered = prev_hovered,
		x = x,
		y = y,
		w = width,
		h = height
	}
	return table
end

---start frame
---@param fn function
---@param bool boolean
---@protected
function ui_class:StartFrame(fn, bool)
	self:id_reset()
	local player = EntityGetWithTag("player_unit")[1]
	if player then --if player is even alive
		if self.gui ~= nil then GuiStartFrame(self.gui) end
		if fn ~= nil and bool then
			fn(self)
		end
	end
end

return ui_class
