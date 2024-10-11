--- @class level_ui
local LU = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_class.lua")

local modules = {
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_death.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_level_up.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_current.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_stats.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_meta.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_list.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_menu.lua"
}

for _, module_name in ipairs(modules) do
	local module = dofile_once(module_name)
	if not module then error("couldn't load " .. module_name) end
	for k, v in pairs(module) do
		LU[k] = v
	end
end

-- ############################################
-- #############		MISC		###########
-- ############################################

--- Checks and runs point spender if needed
--- @private
--- @return boolean
function LU:PointSpenderCheck()
	if not ML.player.id then return false end
	if self.data.SkipMenuOnPending and ML.pending_levels > 0 then
		GameAddFlagRun(MLP.const.flags.leveling_up)
	end
	if GameHasFlagRun(MLP.const.flags.leveling_up) then
		self:LevelUpDrawPointSpender()
		return true
	end
	return false
end

--- Returns true if player is dead
--- @private
--- @return boolean
function LU:IsDead()
	return StatsGetValue("dead") == "1"
end

--- Open menu
--- @private
function LU:OpenMenu()
	ML:toggle_ui()
	GamePlaySound(MLP.const.sounds.click.bank, MLP.const.sounds.click.event, 0, 0)
end

--- close ui on triggers
--- @private
function LU:EmergencyExit()
	if self.data.CloseOnDamage and ML.player.mLastDamageFrame ~= self.data.mLastDamageFrame then
		self.data.mLastDamageFrame = ML.player.mLastDamageFrame
		ML.gui = false
	end
	if self.data.CloseOnShot and ML.player.mButtonLastFrameFire ~= self.data.mButtonLastFrameFire then
		self.data.mButtonLastFrameFire = ML.player.mButtonLastFrameFire
		ML.gui = false
	end
end

--- invisible 9piece to block inputs on gui
--- @private
function LU:BlockInputOnPrevious()
	local prev = self:GetPrevious()
	if self:IsHoverBoxHovered(prev.x - self.const.sprite_offset / 2, prev.y - self.const.sprite_offset / 2, prev.w + self.const.sprite_offset, prev.h + self.const.sprite_offset, true) then
		self:BlockInput()
	end
end

--- reset animation by key
--- @private
function LU:AnimReset(key)
	self.anim[key].reset = true
	self.anim[key].frame = GameGetFrameNum()
end

--- check if animation should be resetted, it's done so it could wait 1 frame, otherwise animations don't reset
--- @private
function LU:CheckForAnim()
	for key, _ in pairs(self.anim) do
		if self.anim[key].reset then
			if GameGetFrameNum() - self.anim[key].frame > 1 then
				self.anim[key].reset = false
			end
		end
	end
end

--- set common parameters for menu animation
--- @private
function LU:MenuAnimS(key)
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim[key].reset)
	self:AnimateScale(0.08, self.anim[key].reset)
end

--- function to close menu
--- @private
function LU:CloseMenu()
	GamePlaySound(MLP.const.sounds.click.bank, MLP.const.sounds.click.event, 0, 0)
	ML.gui = false
end

--- check if element is visible within scrollbox
--- @private
--- @param y number
--- @param distance_between number
--- @return boolean
function LU:ElementIsVisible(y, distance_between)
	if
		y - self.scroll.y + distance_between / 2 > 0 and
		y - self.scroll.y - distance_between / 2 < self.scroll.height_max
	then
		return true
	end
	return false
end

--- function to reset scrollbox height
--- @private
function LU:ResetScrollBoxHeight()
	self:FakeScrollBox_Reset()
end

--- function to reset scrollbox params to default
--- @private
function LU:ResetScrollBox()
	self:AnimReset("window")
	self:ResetScrollBoxHeight()
end

--- Draws reward rarity glow
--- @private
--- @param x number
--- @param y number
--- @param z number
--- @param color ml_reward_border
function LU:DrawRewardRarity(x, y, z, color)
	self:AddOptionForNext(self.c.options.NonInteractive)
	self:SetZ(z)
	local r, g, b, a = unpack(color)
	self:Color(r, g, b)
	self:Image(x, y, "mods/meta_leveling/files/gfx/ui/reward_glow.png", a)
end

--- Draws reward icon
--- @private
--- @param x number
--- @param y number
--- @param icon string
--- @param scale? number
function LU:DrawRewardIcon(x, y, icon, scale)
	scale = scale or 1
	if icon:find("%.xml") then
		self:Image(x, y, icon, 1, scale, scale)
		return
	end
	local width, height = GuiGetImageDimensions(self.gui, icon, 1)
	local x_offset = (16 - width) / 2 * scale
	local y_offset = (16 - height) / 2 * scale
	self:Image(x + x_offset, y + y_offset, icon, 1, scale, scale)
end

-- ############################################
-- ############		MAIN MENU		###########
-- ############################################

--- draw header
--- @private
function LU:DrawMainHeader()
	self:MenuAnimS("header")
	local third_width = self.const.width * 0.33
	local section = 10
	local experience = self:Locale("$ml_experience: ") .. MLP.exp:format(MLP.exp:current())
	if MLP.exp:current() < 10^21 then
		experience = experience .. "/" .. MLP.exp:format(ML.next_exp)
	end
	local level = self:Locale("$ml_level: ") .. ML:get_level()
	self.data.y = self.data.y + self.const.sprite_offset
	self:Draw9Piece(self.data.x, self.data.y, self.const.z + 1, self.const.width, section, self.const.ui_9piece)
	self:BlockInputOnPrevious()
	self:TextCentered(self.data.x, self.data.y, experience, third_width)
	self:TextCentered(self.data.x + third_width, self.data.y, "META LEVELING", third_width)
	self:TextCentered(self.data.x + third_width * 2, self.data.y, level, third_width)
	self:AnimateE()

	self.data.y = self.data.y + section + self.const.sprite_offset
end

--- draw connector between header and window
--- @private
function LU:DrawMenuConnector()
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim["window"].reset)
	self:SetZ(5)
	self:Draw9Piece(self.data.x, self.data.y, self.const.z + 1, self.const.width, 0,
		"mods/meta_leveling/files/gfx/ui/ui_9piece_connector.png")
	self:BlockInputOnPrevious()
	self:AnimateE()
end

--- Draws menu buttons
--- @private
function LU:DrawButtonsAndWindow()
	self:DrawMenuButtons()
	if self.DrawWindow then
		self:DrawMenuConnector()
		self:MenuAnimS("window")
		self:DrawWindow()
		self:AnimateE()
	end
end

--- main window
--- @private
function LU:DrawMainMenu()
	if not ML.player.id then return end
	self:DrawMainHeader()
	self:DrawButtonsAndWindow()
end

-- ############################################
-- #############		LOGIC		###########
-- ############################################

--- gathers settings on pause update
function LU:GetSetting()
	self:UpdateDimensions()
	self.data.CloseOnShot = MLP.get:mod_setting_boolean("session_exp_close_ui_on_shot")
	self.data.CloseOnDamage = MLP.get:mod_setting_boolean("session_exp_close_ui_on_damage")
	self.data.SkipMenuOnPending = MLP.get:mod_setting_boolean("session_exp_ui_open_auto")
	self.data.hotkey = MLP.get:mod_setting_number("open_ui_hotkey")
	self.data.on_death = MLP.get:mod_setting_boolean("show_ui_on_death")
	self:MetaCalculateProgressOffset()
	self:StatsFindLongest()
end

--- main logic
--- @private
function LU:DrawLevelUI()
	if not self:PointSpenderCheck() then
		self:DrawMainMenu()
	end
end

--- main loop
function LU:loop()
	if ML.gui_em_exit then self:EmergencyExit() end
	self:StartFrame()

	GuiZSet(self.gui, self.const.z - 2)
	self.data.x, self.data.y = self:CalculateCenterInScreen(self.const.width, self.const.height)

	if self:IsDead() then
		if self:DeathIsCreditsPlaying() then return end
		self:DeathDrawMenu()
	elseif ML.gui then
		self:DrawLevelUI()
	end

	if InputIsKeyJustDown(self.data.hotkey) then
		self:OpenMenu()
		if InputIsKeyDown(self.c.codes.keyboard.lshift) then
			ML.gui_em_exit = false
		end
	end
	self:CheckForAnim()
end

return LU
