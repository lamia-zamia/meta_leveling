local UI_class = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/ui_lib.lua")
---@class experience_bar:UI_class
local EB = UI_class:new()
EB.anim_a = 0
EB.anim_step = 0.01
EB.anim_dir = 1
EB.anim_max_a = 0.75
EB.current_health = 100
EB.health_length = 42
EB.sound_played = {}
EB.drawning = false
EB.play_sound = true


function EB:BarColor(m)
	self:Color(self.red * m, self.green * m, self.blue * m)
end

function EB:DrawBackGround(x, y, scale_x, scale_y)
	self:SetZ(3)
	self:BarColor(0.6)
	self:Image(x, y, self.c.px, 0.85, scale_x, scale_y)
end

function EB:DrawExpFiller(x, y, scale_x, scale_y, vertical)
	self:SetZ(1)
	self:BarColor(1)
	if vertical then
		self:Image(x, y + scale_y, self.c.px, 1, scale_x, -(scale_y * ML.exp.percentage))
	else
		self:Image(x, y, self.c.px, 1, scale_x * ML.exp.percentage, scale_y)
	end
end

function EB:ToolTipUI()
	local level = self:Locale("$ml_level") .. ": " .. ML:get_level()
	local experience = self:Locale("$ml_experience") .. ": " .. ML.exp.current .. " / " .. ML.exp.next
	local tooltip = self:Locale("$ml_exp_bar_tooltip")
	local longest = self:GetLongestText({ level, experience, tooltip }, "exp_bar_tooltip. " .. experience, true)
	self.tp:TextCentered(0, 0, level, longest, "", true)
	self.tp:TextCentered(0, 0, experience, longest, "", true)
	self.tp:TextCentered(0, 0, tooltip, longest, "", true)
end

function EB:AnimateBarAlpha()
	local alpha = self.anim_a
	if alpha > self.anim_max_a then alpha = self.anim_max_a end
	if self.anim_a > 0.75 or self.anim_a < 0 then self.anim_dir = self.anim_dir * -1 end
	self.anim_a = self.anim_a + self.anim_step * self.anim_dir
	return alpha
end

function EB:AnimateBar(x, y, width, height)
	if ML.exp.percentage >= 1 and self.animate_bar then
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

function EB:GetPlayerHealth()
	local component_id = self:GetPlayerDamageComponent()
	if not component_id then return 16 end

	return math.max(ComponentGetValue2(component_id, "max_hp"), 1)
end

function EB:SetPlayerHealthLength() --thanks Killua and Nathan
	local bar_length = 40 * math.log((2.5 * self.current_health), 10)
	-- clamping
	bar_length = math.max(bar_length, 16)
	bar_length = math.min(bar_length, 80)

	self.health_length = bar_length + 2
end

function EB:CheckForAir()
	local component_id = self:GetPlayerDamageComponent()
	if not component_id then return false end
	local air_in_lungs_max = ComponentGetValue2(component_id, "air_in_lungs_max")
	local air_in_lungs = ComponentGetValue2(component_id, "air_in_lungs")
	if air_in_lungs ~= air_in_lungs_max then return true end
	return false
end

function EB:DrawBorder(x, y, scale_x, scale_y)
	self:SetZ(2)
	self:Color(0.4752, 0.2768, 0.2215)
	self:Image(x, y, self.c.px, 0.85, scale_x, scale_y)
end

function EB:DrawExpBarOnTop()
	self:DrawBorder(self.x, self.y - 1, self.scale_x + 0.25, self.scale_y)                   --top
	self:DrawBorder(self.x, self.y, self.scale_y, 1 + self.thickness)                        --left
	self:DrawBorder(self.x, self.y + self.thickness, self.scale_x + 0.25, self.scale_y)      --buttom
	self:DrawBorder(self.x + self.scale_x - 0.75, self.y - 1, self.scale_y, 2 + self.thickness) --right

	self:DrawBackGround(self.x + 1, self.y, self.scale_x - 1.75, self.thickness)
	self:DrawExpFiller(self.x + 1, self.y, self.scale_x - 1.75, self.thickness, false)
	self:AnimateBar(self.x, self.y - 1, self.scale_x + 0.25, 2 + self.thickness)
	self:AddToolTip(self.x, self.y - 1, self.scale_x + 0.25, 2 + self.thickness)
end

function EB:DrawExpBarUnderHP()
	self.x = self.dim.x - 40 - self.health_length
	self.scale_x = self.health_length
	local y = self.y
	if self.drawning then y = y + 8 end
	self:DrawBorder(self.x, y, self.scale_y, 1 + self.thickness)                    --left
	self:DrawBorder(self.x, y + self.thickness, self.scale_x + 0.25, self.scale_y)  --buttom
	self:DrawBorder(self.x + self.scale_x - 0.75, y, self.scale_y, 1 + self.thickness) --right

	self:DrawBackGround(self.x + 1, y, self.scale_x - 1.75, self.thickness)
	self:DrawExpFiller(self.x + 1, y, self.scale_x - 1.70, self.thickness, false)
	self:AnimateBar(self.x, y, self.scale_x + 0.25, 1 + self.thickness)
	self:AddToolTip(self.x, y, self.scale_x + 0.25, 1 + self.thickness)
end

function EB:DrawVerticalBorders(y)
	self:DrawBorder(self.x, y, (2 + self.thickness) * self.scale_x, 1)                                --top
	self:DrawBorder(self.x, y + 1, 1 * self.scale_x, self.scale_y)                                    --left
	self:DrawBorder(self.x, y + self.scale_y, (2 + self.thickness) * self.scale_x, 1)                 --buttom
	self:DrawBorder(self.x + (1 + self.thickness) * self.scale_x, y, 1 * self.scale_x, self.scale_y + 1) --right
end

function EB:DrawExpBarOnLeft()
	local y = self.y
	if self.health_length > 46 then
		if self.drawning then
			y = y + 18
		else
			y = y + 10
		end
	end
	self:DrawVerticalBorders(y)
	self:DrawBackGround(self.x + self.scale_x, y + 1, self.thickness * self.scale_x, self.scale_y - 1)
	self:DrawExpFiller(self.x + self.scale_x, y + 1, self.thickness * self.scale_x, self.scale_y - 1, true)
	self:AnimateBar(self.x, y, (2 + self.thickness) * self.scale_x, self.scale_y + 1)
	self:AddToolTip(self.x - (2 + self.thickness), y, (2 + self.thickness), self.scale_y + 1)
end

function EB:DrawExpBarOnRight()
	self:DrawVerticalBorders(self.y)
	self:DrawBackGround(self.x + self.scale_x, self.y + 1, self.thickness * self.scale_x, self.scale_y - 1)
	self:DrawExpFiller(self.x + self.scale_x, self.y + 1, self.thickness * self.scale_x, self.scale_y - 1, true)
	self:AnimateBar(self.x, self.y, (2 + self.thickness) * self.scale_x, self.scale_y + 1)
	self:AddToolTip(self.x, self.y, (2 + self.thickness), self.scale_y + 1)
end

function EB:LevelUpFX()
	self.sound_played[ML:get_level()] = true
	if GameHasFlagRun(ML.const.flags.fx_played) then return end
	GameAddFlagRun(ML.const.flags.fx_played)
	if self.play_sound then GamePlaySound(ML.const.sound_banks.event_cues, "event_cues/wand/create", ML.player.x, ML.player.y) end
	if self.play_fx then EntityLoad("data/entities/particles/image_emitters/wand_effect.xml", ML.player.x, ML.player.y) end
end

function EB:UpdatePlayerStatus()
	local player_health = self:GetPlayerHealth()
	if self.current_health ~= player_health then
		self.current_health = player_health
		self:SetPlayerHealthLength()
	end
	self.drawning = self:CheckForAir()
	if ML.exp.percentage >= 1 and not self.sound_played[ML:get_level()] then
		self:LevelUpFX()
	end
end

function EB:GetSettings()
	self.play_sound = ML.utils:get_mod_setting_boolean("session_exp_play_sound", true)
	self.play_fx = ML.utils:get_mod_setting_boolean("session_exp_play_fx", true)
	self.animate_bar = ML.utils:get_mod_setting_boolean("session_exp_animate_bar", true)
	self.thickness = ML.utils:get_mod_setting_number("exp_bar_thickness")
	self.red = ML.utils:get_mod_setting_number("exp_bar_red")
	self.green = ML.utils:get_mod_setting_number("exp_bar_green")
	self.blue = ML.utils:get_mod_setting_number("exp_bar_blue")
	if ModSettingGet("meta_leveling.exp_bar_position") == "on_top" then
		self.DrawBarFunction = self.DrawExpBarOnTop
		self.x = self.dim.x - 82
		self.y = 17 - self.thickness
		self.scale_x = 42
		self.scale_y = 1
	elseif
		ModSettingGet("meta_leveling.exp_bar_position") == "on_left" then
		self.DrawBarFunction = self.DrawExpBarOnLeft
		self.x = self.dim.x - 88
		self.y = 20
		self.scale_x = -1
		self.scale_y = 29.25
	elseif
		ModSettingGet("meta_leveling.exp_bar_position") == "on_right" then
		self.DrawBarFunction = self.DrawExpBarOnRight
		self.x = self.dim.x - 8
		self.y = 20
		self.scale_x = 1
		self.scale_y = 29.25
	else
		self.DrawBarFunction = self.DrawExpBarUnderHP
		self.x = self.dim.x - 40 - self.health_length
		self.y = 26.20
		self.scale_x = self.health_length
		self.scale_y = 1
	end
end

function EB:DrawExpBar()
	self:UpdatePlayerStatus()
	self:AddOption(2)
	self:DrawBarFunction()
end

function EB:loop()
	self:StartFrame(self.DrawExpBar, true)
end

return EB
