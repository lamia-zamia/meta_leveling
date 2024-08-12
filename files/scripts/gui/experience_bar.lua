---@class experience_bar
local EB = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/experience_bar_class.lua")

---@param value number
---@return string
function EB:FloorPerc(value)
	return tostring(math.floor(value * 100))
end

function EB:TextColorAnim(fn, ...)
	self:Color(self.bar.red, self.bar.green, self.bar.blue, self.data.anim.alpha)
	self:SetZ(-1)
	fn(self, ...)
	fn(self, ...)
end

function EB:DrawPercentage(x, y)
	if ML.exp.percentage < 1 then
		self:Text(x + 1, y - 2, "%")
		self:Color(1, 1, 1, 0.80)
		self:Text(x + 10, y, self:FloorPerc(ML.exp.percentage), "data/fonts/font_small_numbers.xml")
	else
		self:TextColorAnim(self.Text, x + 1, y - 2, "!!")
		self:TextColorAnim(self.Text, x + 10, y, tostring(ML.pending_levels), "data/fonts/font_small_numbers.xml")
	end
	local prev = self:GetPrevious()
	self:AddToolTip(x, y, prev.w + 10, prev.h)
end

function EB:BarColor(m)
	self:Color(self.bar.red * m, self.bar.green * m, self.bar.blue * m)
end

function EB:DrawBackGround(x, y, scale_x, scale_y)
	self:SetZ(3)
	self:BarColor(0.6)
	self:Image(x, y, self.c.px, 0.85, scale_x, scale_y)
end

function EB:ClampFiller()
	local percent = ML.exp.percentage
	if percent < self.const.filler_clamp or percent == 1 then
		return ML.exp.percentage
	else
		return self.const.filler_clamp
	end
end

function EB:DrawExpFiller(x, y, scale_x, scale_y, vertical)
	local multiplier = self:ClampFiller()
	self:SetZ(1)
	self:BarColor(1)
	if vertical then
		self:Image(x, y + scale_y, self.c.px, 1, scale_x, -(scale_y * multiplier))
	else
		self:Image(x, y, self.c.px, 1, scale_x * multiplier, scale_y)
	end
end

function EB:ToolTipUI()
	local level = self:Locale("$ml_level") .. ": " .. ML.level
	if ML.pending_levels > 0 then
		level = level .. ", " .. self:Locale("$ml_pending") .. ": " .. ML.pending_levels
	end
	local experience = self:Locale("$ml_experience") .. ": " .. ML.exp.current .. " / " .. ML.exp.next
	local tooltip = self:Locale("$ml_exp_bar_tooltip")
	local longest = self:GetLongestText({ level, experience, tooltip }, "exp_bar_tooltip. " .. experience, true)
	self.tp:TextCentered(0, 0, level, longest, "", true)
	self.tp:TextCentered(0, 0, experience, longest, "", true)
	self.tp:TextCentered(0, 0, tooltip, longest, "", true)
end

function EB:AnimateBarAlpha()
	local alpha = self.data.anim.alpha
	if alpha > self.const.anim.max_alpha then alpha = self.const.anim.max_alpha end
	if self.data.anim.alpha > 0.75 or self.data.anim.alpha < 0 then self.data.anim.direction = self.data.anim.direction *
		-1 end
	self.data.anim.alpha = self.data.anim.alpha + self.const.anim.step * self.data.anim.direction
	return alpha
end

function EB:AnimateBar(x, y, width, height)
	if ML.exp.percentage >= 1 and self.data.animate_bar then
		self:BarColor(0.9)
		self:Image(x, y, self.c.px, EB:AnimateBarAlpha(), width, height)
	end
end

function EB:AddToolTip(x, y, width, height)
	self:ForceFocusable()
	self:Draw9Piece(x, y, -1000, width, height, self.c.empty, self.c.empty)
	self:AddTooltipClickable(0, 0, self.ToolTipUI, ML.toggle_ui, ML.exp.current)
end

function EB:GetPlayerDamageComponent()
	local player_id = EntityGetWithTag("player_unit")[1]
	return EntityGetFirstComponent(player_id, "DamageModelComponent")
end

function EB:SetPlayerHealthLength() --thanks Killua and Nathan
	local bar_length = 40 * math.log((2.5 * self.data.max_health), 10)
	-- clamping
	bar_length = math.max(bar_length, 16)
	bar_length = math.min(bar_length, 80)

	self.data.health_length = bar_length + 2
end

function EB:DrawBorder(x, y, scale_x, scale_y)
	self:SetZ(2)
	self:Color(0.4752, 0.2768, 0.2215)
	self:Image(x, y, self.c.px, 0.85, scale_x, scale_y)
end

function EB:DrawExpBarOnTop()
	self:DrawBorder(self.bar.x, self.bar.y - 1, self.bar.scale_x + 0.25, self.bar.scale_y)                       --top
	self:DrawBorder(self.bar.x, self.bar.y, self.bar.scale_y, 1 + self.bar.thickness)                            --left
	self:DrawBorder(self.bar.x, self.bar.y + self.bar.thickness, self.bar.scale_x + 0.25, self.bar.scale_y)      --buttom
	self:DrawBorder(self.bar.x + self.bar.scale_x - 0.75, self.bar.y - 1, self.bar.scale_y, 2 + self.bar.thickness) --right

	self:DrawBackGround(self.bar.x + 1, self.bar.y, self.bar.scale_x - 1.75, self.bar.thickness)
	self:DrawExpFiller(self.bar.x + 1, self.bar.y, self.bar.scale_x - 1.75, self.bar.thickness, false)
	self:AnimateBar(self.bar.x, self.bar.y - 1, self.bar.scale_x + 0.25, 2 + self.bar.thickness)
	self:AddToolTip(self.bar.x, self.bar.y - 1, self.bar.scale_x + 0.25, 2 + self.bar.thickness)
end

function EB:DrawExpBarUnderHP()
	self.bar.x = self.dim.x - 40 - self.data.health_length
	self.bar.scale_x = self.data.health_length
	local y = self.bar.y
	if ML.player.drowning then y = y + 8 end
	self:DrawBorder(self.bar.x, y, self.bar.scale_y, 1 + self.bar.thickness)                        --left
	self:DrawBorder(self.bar.x, y + self.bar.thickness, self.bar.scale_x + 0.25, self.bar.scale_y)  --buttom
	self:DrawBorder(self.bar.x + self.bar.scale_x - 0.75, y, self.bar.scale_y, 1 + self.bar.thickness) --right

	self:DrawBackGround(self.bar.x + 1, y, self.bar.scale_x - 1.75, self.bar.thickness)
	self:DrawExpFiller(self.bar.x + 1, y, self.bar.scale_x - 1.70, self.bar.thickness, false)
	self:AnimateBar(self.bar.x, y, self.bar.scale_x + 0.25, 1 + self.bar.thickness)
	self:AddToolTip(self.bar.x, y, self.bar.scale_x + 0.25, 1 + self.bar.thickness)
end

function EB:DrawVerticalBorders(y)
	self:DrawBorder(self.bar.x, y, (2 + self.bar.thickness) * self.bar.scale_x, 1)                                        --top
	self:DrawBorder(self.bar.x, y + 1, 1 * self.bar.scale_x, self.bar.scale_y)                                            --left
	self:DrawBorder(self.bar.x, y + self.bar.scale_y, (2 + self.bar.thickness) * self.bar.scale_x, 1)                     --buttom
	self:DrawBorder(self.bar.x + (1 + self.bar.thickness) * self.bar.scale_x, y, 1 * self.bar.scale_x,
		self.bar.scale_y + 1)                                                                                             --right
end

function EB:DrawExpBarOnLeft()
	local y = self.bar.y
	if self.data.health_length > 46 then
		if ML.player.drowning then
			y = y + 18
		else
			y = y + 10
		end
	end
	self:DrawVerticalBorders(y)
	self:DrawBackGround(self.bar.x + self.bar.scale_x, y + 1, self.bar.thickness * self.bar.scale_x, self.bar.scale_y - 1)
	self:DrawExpFiller(self.bar.x + self.bar.scale_x, y + 1, self.bar.thickness * self.bar.scale_x, self.bar.scale_y - 1,
		true)
	self:AnimateBar(self.bar.x, y, (2 + self.bar.thickness) * self.bar.scale_x, self.bar.scale_y + 1)
	self:AddToolTip(self.bar.x - (2 + self.bar.thickness), y, (2 + self.bar.thickness), self.bar.scale_y + 1)
end

function EB:DrawExpBarOnRight()
	self:DrawVerticalBorders(self.bar.y)
	self:DrawBackGround(self.bar.x + self.bar.scale_x, self.bar.y + 1, self.bar.thickness * self.bar.scale_x,
		self.bar.scale_y - 1)
	self:DrawExpFiller(self.bar.x + self.bar.scale_x, self.bar.y + 1, self.bar.thickness * self.bar.scale_x,
		self.bar.scale_y - 1, true)
	self:AnimateBar(self.bar.x, self.bar.y, (2 + self.bar.thickness) * self.bar.scale_x, self.bar.scale_y + 1)
	self:AddToolTip(self.bar.x, self.bar.y, (2 + self.bar.thickness), self.bar.scale_y + 1)
end

function EB:LevelUpFX()
	self.data.sound_played_level[ML.level] = true
	if GameHasFlagRun(ML.const.flags.fx_played) then return end
	GameAddFlagRun(ML.const.flags.fx_played)
	if self.data.play_sound then GamePlaySound(ML.const.sound_banks.event_cues, "event_cues/wand/create", ML.player.x,
			ML.player.y) end
	if self.data.play_fx then EntityLoad("data/entities/particles/image_emitters/wand_effect.xml", ML.player.x,
			ML.player.y) end
end

function EB:UpdatePlayerStatus()
	if self.data.max_health ~= ML.player.max_hp then
		self.data.max_health = ML.player.max_hp
		self:SetPlayerHealthLength()
	end
	if ML.exp.percentage >= 1 and not self.data.sound_played_level[ML.level] then
		self:LevelUpFX()
	end
end

function EB:GetSettings()
	self.data.play_sound = ML.utils:get_mod_setting_boolean("session_exp_play_sound", true)
	self.data.play_fx = ML.utils:get_mod_setting_boolean("session_exp_play_fx", true)
	self.data.animate_bar = ML.utils:get_mod_setting_boolean("session_exp_animate_bar", true)
	self.bar.thickness = ML.utils:get_mod_setting_number("exp_bar_thickness")
	self.bar.red = ML.utils:get_mod_setting_number("exp_bar_red")
	self.bar.green = ML.utils:get_mod_setting_number("exp_bar_green")
	self.bar.blue = ML.utils:get_mod_setting_number("exp_bar_blue")
	self.data.max_health = ML.player.max_hp
	self.data.perc.x = self.dim.x - 38
	self.data.perc.y = 12
	if ModSettingGet("meta_leveling.exp_bar_position") == "on_top" then
		self.DrawBarFunction = self.DrawExpBarOnTop
		self.bar.x = self.dim.x - 82
		self.bar.y = 17 - self.bar.thickness
		self.bar.scale_x = 42
		self.bar.scale_y = 1
	elseif
		ModSettingGet("meta_leveling.exp_bar_position") == "on_left" then
		self.DrawBarFunction = self.DrawExpBarOnLeft
		self.bar.x = self.dim.x - 88
		self.bar.y = 20
		self.bar.scale_x = -1
		self.bar.scale_y = 29.25
	elseif
		ModSettingGet("meta_leveling.exp_bar_position") == "on_right" then
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
end

function EB:DrawExpBar()
	self:UpdatePlayerStatus()
	self:AddOption(2)
	self:DrawBarFunction()
	self:DrawPercentage(self.data.perc.x, self.data.perc.y)
end

function EB:loop()
	self:StartFrame(self.DrawExpBar, not GameIsInventoryOpen())
end

return EB
