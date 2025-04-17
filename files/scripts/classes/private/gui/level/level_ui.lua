--- @class level_ui
local LU = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_class.lua")

local modules = {
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_position.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_death.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_level_up.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_current.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_stats.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_meta.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_list.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_menu.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_header.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_itembox.lua",
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
	if self.data.SkipMenuOnPending and ML.pending_levels > 0 then GameAddFlagRun(MLP.const.flags.leveling_up) end
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
	if
		self:IsHoverBoxHovered(
			prev.x - self.const.sprite_offset / 2,
			prev.y - self.const.sprite_offset / 2,
			prev.w + self.const.sprite_offset,
			prev.h + self.const.sprite_offset,
			true
		)
	then
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
			if GameGetFrameNum() - self.anim[key].frame > 1 then self.anim[key].reset = false end
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

--- Draws 9piece with offset in scrollbox
--- @private
--- @param x number
--- @param y number
--- @param z number
--- @param width number
--- @param height number
--- @param sprite? string
--- @param highlight? string
function LU:Draw9PieceInScrollBox(x, y, z, width, height, sprite, highlight)
	self:Draw9Piece(x + self.data.x, y + self.data.y, z, width, height, sprite, highlight)
end

--- Draws checbox
--- @param x number
--- @param y number
--- @param text string
--- @param value boolean
--- @return boolean hovered
function LU:IsCheckboxInScrollBoxHovered(x, y, text, value)
	local text_dim = self:GetTextDimension(text)
	local hovered = self:IsHoverBoxHovered(x + self.data.x, y + 1 + self.data.y, text_dim + 13, 9)
	if hovered then self:Color(1, 1, 0.7) end
	self:Text(x, y, text)
	self:Draw9PieceInScrollBox(x + text_dim + 4, y + 2, self.const.z, 6, 6, hovered and self.buttons.img_hl or self.buttons.img)
	if value then
		self:Color(0, 0.8, 0)
		self:Text(x + text_dim + 5, y, "V")
	else
		self:Color(0.8, 0, 0)
		self:Text(x + text_dim + 5, y, "X")
	end
	return hovered
end

--- Checks if element in scrollbox is hovered
--- @private
--- @param x number
--- @param y number
--- @param width number
--- @param height number
--- @param dont_focus? boolean
--- @return boolean
--- @nodiscard
function LU:IsElementHovered(x, y, width, height, dont_focus)
	local offset = height / 2
	if y + offset > 0 and y + offset < self.scroll.height_max then
		return self:IsHoverBoxHovered(self.data.x + x, self.data.y + y, width, height, dont_focus)
	end
	return false
end

--- function to reset scrollbox height
--- @private
function LU:ResetScrollBoxHeight()
	self:ScrollBoxReset()
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

--- draw connector between header and window
--- @private
function LU:DrawMenuConnector()
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim["window"].reset)
	self:SetZ(5)
	self:Draw9Piece(self.data.x, self.data.y, self.const.z + 1, self.const.width, 0, "mods/meta_leveling/files/gfx/ui/ui_9piece_connector.png")
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
	self.level_up.show_new = MLP.get:mod_setting_boolean("show_new_text")
	self:MetaGetSettings()
	self:StatsFindLongest()
end

---Initializes data
function LU:Init()
	self:header_update_data()
	self:itembox_update_data()
	self:stash_get()
end

--- main logic
--- @private
function LU:DrawLevelUI()
	if not self:PointSpenderCheck() then self:DrawMainMenu() end
end

--- main loop
function LU:loop()
	if ML.gui_em_exit then self:EmergencyExit() end
	self:StartFrame()

	GuiZSet(self.gui, self.const.z - 2)
	-- print("self.header_position.x (" .. tostring(self.header_position.x) .. ":" .. type(self.header_position.x) .. ")")
	-- print("self.header_position.y (" .. tostring(self.header_position.y) .. ":" .. type(self.header_position.y) .. ")")
	self.data.x, self.data.y = self.header_position.x, self.header_position.y

	if self:IsDead() then
		if self:DeathIsCreditsPlaying() then return end
		self:DeathDrawMenu()
	else
		self:draw_itembox()
		if ML.gui then self:DrawLevelUI() end
	end

	if InputIsKeyJustDown(self.data.hotkey) then
		self:OpenMenu()
		if InputIsKeyDown(self.c.codes.keyboard.lshift) then ML.gui_em_exit = false end
	end
	self:CheckForAnim()
end

return LU
