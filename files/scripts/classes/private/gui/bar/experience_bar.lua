--- @class experience_bar
local EB = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui/bar/experience_bar_class.lua")

local bg_alpha = 0.7098039215686275
local bg_red = 0.47513812154696133
local bg_green = 0.2762430939226519
local bg_blue = 0.22099447513812157

local border_alpha = 0.8509803921568627
local border_red = 0.47465437788018433
local border_green = 0.2764976958525346
local border_blue = 0.22119815668202766

--- Helper function to format percentage
--- @private
--- @param value number
--- @return string
function EB:FloorPerc(value) return tostring(math.floor(value * 100)) end

--- Helper function to handle text color animation
--- @private
--- @param fn function
--- @param ... any
function EB:TextColorAnim(fn, ...)
	self:Color(self.bar.red, self.bar.green, self.bar.blue, math.min(self.const.anim.max_alpha, self.data.anim_text.alpha))
	self:SetZ(-1)
	fn(self, ...)
	fn(self, ...)
end

--- Draw percentage text
--- @private
--- @param x number
--- @param y number
function EB:DrawPercentage(x, y)
	local percentage = self.data.exp_percentage
	if self.data.exp_inverted then
		self:BarColor()
		self:Text(x + 1, y - 2, "<")
		self:BarColor()
		self:Text(x + 10, y, self:FloorPerc(percentage), "data/fonts/font_small_numbers.xml")
	elseif percentage < 1 then
		self:Text(x + 1, y - 2, "%")
		self:Color(1, 1, 1, 0.80)
		self:Text(x + 10, y, self:FloorPerc(percentage), "data/fonts/font_small_numbers.xml")
	else
		self:TextColorAnim(self.Text, x + 1, y - 2, "!!")
		self:TextColorAnim(self.Text, x + 10, y, tostring(ML.pending_levels), "data/fonts/font_small_numbers.xml")
	end
	local prev = self:GetPrevious()
	self:AddToolTip(x, y, prev.w + 10, prev.h)
end

--- Sets background color
--- @private
function EB:BarColorBackground()
	if self.data.exp_inverted then
		self:Color(self.bar.red_inverted_background, self.bar.green_inverted_background, self.bar.blue_inverted_background)
	else
		self:Color(self.bar.red_background, self.bar.green_background, self.bar.blue_background)
	end
end

--- Adjust bar color based on multiplier
--- @private
function EB:BarColor()
	if self.data.exp_inverted then
		self:Color(self.bar.red_inverted, self.bar.green_inverted, self.bar.blue_inverted)
	else
		self:Color(self.bar.red, self.bar.green, self.bar.blue)
	end
end

--- Draw the background of the bar
--- @private
--- @param x number
--- @param y number
--- @param scale_x number
--- @param scale_y number
function EB:DrawBackGround(x, y, scale_x, scale_y)
	self:SetZ(3)
	self:BarColorBackground()
	self:Image(x, y, self.c.px, bg_alpha, scale_x, scale_y)
end

--- Clamp filler value
--- @private
--- @return number
function EB:ClampFiller()
	local percent = math.max(0.00001, self.data.exp_percentage)
	if percent < self.const.filler_clamp or percent == 1 or self.data.exp_inverted then
		return percent
	else
		return self.const.filler_clamp
	end
end

function EB:AnimateBarHSVFadeDetermineBoundaries()
	local _, _, v = ML.colors:rgb2hsv(self.bar.red, self.bar.green, self.bar.blue)
	local min = v - 1
	local max = min + self.data.anim_bar.range * 2
	return min, max, (min + max) / 2
end

--- Animate the bar's HSV fade
--- @private
--- @param alpha number
--- @return number, number, number
function EB:AnimateBarHSVFade(alpha)
	local h, s, v = ML.colors:rgb2hsv(self.bar.red, self.bar.green, self.bar.blue)
	return ML.colors:hsv2rgb(h, s, v - alpha)
end

--- @private
function EB:AnimateBarLogic(data)
	self:Color(self:AnimateBarHSVFade(data.alpha))
	self:SetZ(1)
	if data.alpha >= self.data.anim_bar.max or data.alpha <= self.data.anim_bar.min then data.direction = data.direction * -1 end
	data.alpha = data.alpha + (self.data.anim_bar.step * data.direction)
end

--- @private
function EB:AnimateBar(x, y, width, height)
	local data = {
		alpha = self.data.anim_bar.alpha,
		direction = self.data.anim_bar.direction,
	}
	if width > height then
		for i = 0, width, self.data.anim_bar.size do
			self:AnimateBarLogic(data)
			self:Image(x + i, y, self.c.px, 1, self.data.anim_bar.size, height)
		end
	else
		for i = 0, height, self.data.anim_bar.size do
			self:AnimateBarLogic(data)
			self:Image(x, y + i, self.c.px, 1, width, self.data.anim_bar.size)
		end
	end
	if self.data.anim_bar.alpha >= self.data.anim_bar.max or self.data.anim_bar.alpha <= self.data.anim_bar.min then
		self.data.anim_bar.direction = self.data.anim_bar.direction * -1
	end
	self.data.anim_bar.alpha = self.data.anim_bar.alpha + self.data.anim_bar.step * self.data.anim_bar.direction
end

--- Draw the experience filler
--- @private
--- @param x number
--- @param y number
--- @param scale_x number
--- @param scale_y number
function EB:DrawExpFiller(x, y, scale_x, scale_y)
	local vertical = scale_y > scale_x
	if self.data.animate_bar and ML.pending_levels > 0 then
		self:AnimateBar(x, y, scale_x, scale_y)
		return
	end
	local multiplier = self:ClampFiller()
	self:SetZ(1)
	self:BarColor()

	if vertical then
		print(tostring(-(scale_y * multiplier)))
		self:Image(x, y + scale_y, self.c.px, 1, scale_x, -(scale_y * multiplier))
	else
		self:Image(x, y, self.c.px, 1, scale_x * multiplier, scale_y)
	end
end

--- Display inventory reminder if needed
--- @private
function EB:InventoryReminder()
	if ML.pending_levels > 0 then
		local text = self:Locale("$ml_level_up_tp, ") .. self:Locale("$ml_pending: ") .. ML.pending_levels
		local width = self:GetTextDimension(text)
		self:TextColorAnim(self.Text, self.dim.x - width - 130, 7, text)
	end
end

--- Show tooltip UI
--- @private
function EB:ToolTipUI()
	local level = self:Locale("$ml_level: ") .. ML:get_level()
	if ML.pending_levels > 0 then level = level .. self:Locale(", $ml_pending: ") .. ML.pending_levels end
	if self.data.exp_inverted then level = level .. self:Locale(", $ml_level_skipped") end
	local experience = self:Locale("$ml_experience: ") .. MLP.exp:format(MLP.exp:current()) .. " / " .. MLP.exp:format(ML.next_exp)
	local tooltip = self:Locale("$ml_exp_bar_tooltip")
	local tooltip_force = EB.data.tooltip_force and self:Locale("$ml_exp_bar_tooltip_force") or nil
	local longest = self:GetLongestText({ level, experience, tooltip, tooltip_force }, "exp_bar_tooltip." .. experience)
	self:TextCentered(0, 0, level, longest, "")
	self:TextCentered(0, 0, experience, longest, "")
	self:Color(0.6, 0.6, 0.6)
	self:TextCentered(0, 0, tooltip, longest, "")
	if tooltip_force then
		self:Color(0.6, 0.6, 0.6)
		self:TextCentered(0, 0, tooltip_force, longest, "")
	end
end

--- Animate text fading effect
--- @private
function EB:AnimateTextFading()
	if self.data.anim_text.alpha > 0.75 or self.data.anim_text.alpha < 0 then self.data.anim_text.direction = -self.data.anim_text.direction end
	self.data.anim_text.alpha = self.data.anim_text.alpha + self.const.anim.step * self.data.anim_text.direction
end

--- Add tooltip UI
--- @private
--- @param x number
--- @param y number
--- @param width number
--- @param height number
function EB:AddToolTip(x, y, width, height)
	if self:IsHoverBoxHovered(x, y, width, height) then
		local tp_key = MLP.exp:current() .. tostring(self.data.exp_inverted)
		local cache = self:GetTooltipData(0, 0, self.ToolTipUI, tp_key)
		self:ShowTooltip(x - cache.width, y, self.ToolTipUI, tp_key)
		if self:IsLeftClicked() then ML:toggle_ui() end
		if self:IsRightClicked() then
			GamePlaySound(MLP.const.sounds.click.bank, MLP.const.sounds.click.event, 0, 0)
			ML:toggle_ui()
			ML.gui_em_exit = false
		end
	end
end

--- Set player health bar length
--- @private
function EB:SetPlayerHealthLength()
	local bar_length = math.max(math.min(40 * math.log((2.5 * self.data.max_health), 10), 80), 16)
	self.data.health_length = bar_length + 2
end

--- Draw border around the bar
--- @private
--- @param x number
--- @param y number
--- @param scale_x number
--- @param scale_y number
function EB:DrawBorder(x, y, scale_x, scale_y)
	self:SetZ(2)
	self:Color(border_red, border_green, border_blue)
	self:Image(x, y, self.c.px, border_alpha, scale_x, scale_y)
end

--- Draw experience bar on top of the screen
--- @private
function EB:DrawExpBarOnTop()
	self:DrawBorder(self.bar.x, self.bar.y - 1, self.bar.scale_x + 0.25, self.bar.scale_y) -- top
	self:DrawBorder(self.bar.x, self.bar.y, self.bar.scale_y, 1 + self.bar.thickness) -- left
	self:DrawBorder(self.bar.x, self.bar.y + self.bar.thickness, self.bar.scale_x + 0.25, self.bar.scale_y) -- bottom
	self:DrawBorder(self.bar.x + self.bar.scale_x - 0.75, self.bar.y - 1, self.bar.scale_y, 2 + self.bar.thickness) -- right

	self:DrawBackGround(self.bar.x + 1, self.bar.y, self.bar.scale_x - 1.75, self.bar.thickness)
	self:DrawExpFiller(self.bar.x + 1, self.bar.y, self.bar.scale_x - 1.75, self.bar.thickness)
	self:AddToolTip(self.bar.x, self.bar.y - 1, self.bar.scale_x + 0.25, 2 + self.bar.thickness)
end

--- Draw experience bar under the HP bar
--- @private
function EB:DrawExpBarUnderHP()
	self.bar.x = self.dim.x - 40 - self.data.health_length
	self.bar.scale_x = self.data.health_length
	local y = self.bar.y
	if ML.player.drowning then y = y + 8 end
	self:DrawBorder(self.bar.x, y, self.bar.scale_y, 1 + self.bar.thickness) -- left
	self:DrawBorder(self.bar.x, y + self.bar.thickness, self.bar.scale_x + 0.25, self.bar.scale_y) -- bottom
	self:DrawBorder(self.bar.x + self.bar.scale_x - 0.75, y, self.bar.scale_y, 1 + self.bar.thickness) -- right

	self:DrawBackGround(self.bar.x + 1, y, self.bar.scale_x - 1.75, self.bar.thickness)
	self:DrawExpFiller(self.bar.x + 1, y, self.bar.scale_x - 1.70, self.bar.thickness)
	self:AddToolTip(self.bar.x, y, self.bar.scale_x + 0.25, 1 + self.bar.thickness)
end

--- Draw vertical borders for the bar
--- @private
--- @param y number
function EB:DrawVerticalBorders(y)
	self:DrawBorder(self.bar.x, y, (2 + self.bar.thickness) * self.bar.scale_x, 1) -- top
	self:DrawBorder(self.bar.x, y + 1, 1 * self.bar.scale_x, self.bar.scale_y) -- left
	self:DrawBorder(self.bar.x, y + self.bar.scale_y, (2 + self.bar.thickness) * self.bar.scale_x, 1) -- bottom
	self:DrawBorder(self.bar.x + (1 + self.bar.thickness) * self.bar.scale_x, y, 1 * self.bar.scale_x, self.bar.scale_y + 1) -- right
end

--- Draw experience bar on the left of the screen
--- @private
function EB:DrawExpBarOnLeft()
	local y = self.bar.y
	if self.data.health_length > 46 then y = y + (ML.player.drowning and 18 or 10) end
	self:DrawVerticalBorders(y)
	self:DrawBackGround(self.bar.x + self.bar.scale_x, y + 1, self.bar.thickness * self.bar.scale_x, self.bar.scale_y - 1)
	self:DrawExpFiller(self.bar.x + self.bar.scale_x, y + 1, self.bar.thickness * self.bar.scale_x, self.bar.scale_y - 1)
	self:AddToolTip(self.bar.x - (2 + self.bar.thickness), y, (2 + self.bar.thickness), self.bar.scale_y + 1)
end

--- Draw experience bar on the right of the screen
--- @private
function EB:DrawExpBarOnRight()
	self:DrawVerticalBorders(self.bar.y)
	self:DrawBackGround(self.bar.x + self.bar.scale_x, self.bar.y + 1, self.bar.thickness * self.bar.scale_x, self.bar.scale_y - 1)
	self:DrawExpFiller(self.bar.x + self.bar.scale_x, self.bar.y + 1, self.bar.thickness * self.bar.scale_x, self.bar.scale_y - 1)
	self:AddToolTip(self.bar.x, self.bar.y, (2 + self.bar.thickness), self.bar.scale_y + 1)
end

--- Update player status and check for level-up
--- @private
function EB:UpdatePlayerStatus()
	if self.data.max_health == ML.player.max_hp then return end
	self.data.max_health = ML.player.max_hp
	self:SetPlayerHealthLength()
end

--- Sets colors for bar background
--- @private
--- @param r number
--- @param g number
--- @param b number
--- @param r_i number
--- @param g_i number
--- @param b_i number
--- @param multiplier number
function EB:SetBackgroundColors(r, g, b, r_i, g_i, b_i, multiplier)
	self.bar.red_background = r * multiplier
	self.bar.green_background = g * multiplier
	self.bar.blue_background = b * multiplier
	self.bar.red_inverted_background = r_i * multiplier
	self.bar.green_inverted_background = g_i * multiplier
	self.bar.blue_inverted_background = b_i * multiplier
end

--- Sets colors for bar
--- @private
function EB:SetColors()
	self.bar.red, self.bar.green, self.bar.blue = MLP.get:exp_color()

	local h, s, v = ML.colors:rgb2hsv(1 - self.bar.red, 1 - self.bar.green, 1 - self.bar.blue)
	self.bar.red_inverted, self.bar.green_inverted, self.bar.blue_inverted = ML.colors:hsv2rgb(h, math.min(s, 0.55), math.min(v, 0.6))
	if MLP.get:mod_setting_boolean("exp_bar_default_bg") then
		self:SetBackgroundColors(bg_red, bg_green, bg_blue, bg_red, bg_green, bg_blue, 1)
	else
		self:SetBackgroundColors(
			self.bar.red,
			self.bar.green,
			self.bar.blue,
			self.bar.red_inverted,
			self.bar.green_inverted,
			self.bar.blue_inverted,
			0.6
		)
	end
end

--- Load and apply settings
function EB:GetSettings()
	self:UpdateDimensions()
	self.data.animate_bar = MLP.get:mod_setting_boolean("session_exp_animate_bar", true)
	self.bar.thickness = MLP.get:mod_setting_number("exp_bar_thickness")
	self:SetColors()
	self.data.max_health = ML.player.max_hp
	self.data.perc.x = self.dim.x - 38
	self.data.perc.y = 12
	self.data.perc.show = MLP.get:mod_setting_boolean("exp_bar_show_perc")
	self.data.tooltip_force = MLP.get:mod_setting_boolean("session_exp_close_ui_on_damage")
		or MLP.get:mod_setting_boolean("session_exp_close_ui_on_shot")
		or MLP.get:mod_setting_boolean("session_exp_close_ui_on_pause")
	self.data.reminder_in_inventory = MLP.get:mod_setting_boolean("hud_reminder_in_inventory")
	self.data.anim_bar.min, self.data.anim_bar.max, self.data.anim_bar.alpha = self:AnimateBarHSVFadeDetermineBoundaries()
	local position = ModSettingGet("meta_leveling.exp_bar_position")
	if position == "on_top" then
		self.DrawBarFunction = self.DrawExpBarOnTop
		self.bar.x = self.dim.x - 82
		self.bar.y = 17 - self.bar.thickness
		self.bar.scale_x = 42
		self.bar.scale_y = 1
	elseif position == "on_left" then
		self.DrawBarFunction = self.DrawExpBarOnLeft
		self.bar.x = self.dim.x - 88
		self.bar.y = 20
		self.bar.scale_x = -1
		self.bar.scale_y = 29.25
	elseif position == "on_right" then
		self.DrawBarFunction = self.DrawExpBarOnRight
		self.bar.x = self.dim.x - 8
		self.bar.y = 20
		self.bar.scale_x = 1
		self.bar.scale_y = 29.25
	else
		self.DrawBarFunction = self.DrawExpBarUnderHP
		self.bar.x = self.dim.x - 40 - self.data.health_length
		self.bar.y = 26.20
		self.bar.scale_x = self.data.health_length
		self.bar.scale_y = 1
	end
	self:SetPlayerHealthLength()
end

--- Draw the experience bar
--- @private
function EB:DrawExpBar()
	self.data.exp_percentage, self.data.exp_inverted = ML:get_percentage()
	self:UpdatePlayerStatus()
	self:AddOption(self.c.options.NonInteractive)
	self:DrawBarFunction()
	if self.data.perc.show then self:DrawPercentage(self.data.perc.x, self.data.perc.y) end
	if self.data.reminder_in_inventory and GameIsInventoryOpen() then self:InventoryReminder() end
	self:AnimateTextFading()
end

--- Main loop function
function EB:loop()
	self:StartFrame()
	if ML.player.id then self:DrawExpBar() end
end

return EB
