---@class level_ui
local LU = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_class.lua")

local modules = {
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_debug.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_level_up.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_current.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_stats.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/level/level_ui_meta.lua"
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

---function to unpack variable descriptions
---@param description string
---@param variables reward_description
---@return string?
function LU:UnpackDescription(description, variables)
	if not description then return nil end
	description = self:Locale(description)
	if variables then
		for i, variable in ipairs(variables) do
			if type(variable) == "string" then
				description = description:gsub("%$" .. i - 1, self:Locale(variable:gsub("%%", "%%%%")))
			elseif type(variable) == "function" then
				description = description:gsub("%$" .. i - 1, variable())
			end
		end
	end
	description = description:gsub("%$%d", "")
	return self:FormatString(description)
end

---close ui on triggers
---@private
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

---beautiful rewards name
---@private
function LU:FormatString(text)
	return text:lower():gsub("^%l", string.upper)
end

---invisible 9piece to block inputs on gui
---@private
function LU:BlockInputOnPrevious()
	local prev = self:GetPrevious()
	self:AddOptionForNext(6)
	self:Draw9Piece(prev.x - self.const.sprite_offset / 2, prev.y - self.const.sprite_offset / 2, 100,
		prev.w + self.const.sprite_offset, prev.h + self.const.sprite_offset, self.c.empty)
	prev = self:GetPrevious()
	if prev.hovered then
		self:BlockInput()
	end
end

---reset animation by key
---@private
function LU:AnimReset(key)
	self.anim[key].reset = true
	self.anim[key].frame = GameGetFrameNum()
end

---check if animation should be resetted, it's done so it could wait 1 frame, otherwise animations don't reset
---@private
function LU:CheckForAnim()
	for key, _ in pairs(self.anim) do
		if self.anim[key].reset then
			if GameGetFrameNum() - self.anim[key].frame > 1 then
				self.anim[key].reset = false
			end
		end
	end
end

---set common parameters for menu animation
---@private
function LU:MenuAnimS(key)
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim[key].reset)
	self:AnimateScale(0.08, self.anim[key].reset)
end

---function to close menu
---@private
function LU:CloseMenu()
	GamePlaySound(MLP.const.sounds.click.bank, MLP.const.sounds.click.event, 0, 0)
	ML.gui = false
end

---check if element is visible within scrollbox
---@private
---@param y number
---@param distance_between number
---@return boolean
function LU:ElementIsVisible(y, distance_between)
	if y - self.scroll.y + distance_between / 2 > 0 and y - self.scroll.y - distance_between / 2 < self.const.height_max then
		return true
	end
	return false
end

---function to reset scrollbox height
---@private
function LU:ResetScrollBoxHeight()
	self:FakeScrollBox_Reset()
	self.data.scrollbox_height = self.const.sprite_offset
end

---function to reset scrollbox params to default
---@private
function LU:ResetScrollBox()
	self:AnimReset("window")
	self:ResetScrollBoxHeight()
end

---Pairs sorted
---@generic T: table, K, V
---@param tbl T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
function LU:orderedPairs(tbl)
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	table.sort(keys)

	local i = 0
	local function iter()
		i = i + 1
		if keys[i] then
			return keys[i], tbl[keys[i]]
		end
	end

	return iter, tbl
end

-- ############################################
-- ############		MAIN MENU		###########
-- ############################################

---toggle between different windows when buttons pressed
---@private
function LU:ToggleMenuWindow(window)
	self:ResetScrollBox()
	if self.DrawWindow == window then
		self.DrawWindow = nil
	else
		self.DrawWindow = window
	end
end

---buttons functions
---@private
function LU:AddMenuSelector(x, y, text, tooltip, fn)
	if self.DrawWindow == fn then
		self:ColorGray()
		self:Text(x, y, text)
		self:ForceFocusable()
		self:Add9PieceBackGroundText(self.const.z, self.const.ui_9p_button_hl, self.const.ui_9p_button_hl)
		self:MakePreviousClickable(self.ToggleMenuWindow, fn)
	else
		self:Text(x, y, text)
		self:MakeButtonFromPrev(tooltip, self.ToggleMenuWindow, self.const.z, self.const.ui_9p_button,
			self.const.ui_9p_button_hl, fn)
	end
end

---draw buttons under the header
---@private
function LU:DrawMenuButtons()
	self:MenuAnimS("header")
	local y = self.data.y - 5.5
	local x = self.data.x
	local function x_off()
		local prev = self:GetPrevious()
		x = x + prev.w + 10
		return x
	end
	if ML.pending_levels >= 1 then
		self:Text(x, y, self:Locale("$ml_level_up"))
		self:MakeButtonFromPrev(self:Locale("$ml_level_up_tp"), self.OpenLevelUpMenu, self.const.z,
			self.const.ui_9p_button_important,
			self.const.ui_9p_button_hl)
	else
		self:ColorGray()
		self:Text(x, y, self:Locale("$ml_level_up"))
		self:Add9PieceBackGroundText(self.const.z, self.const.ui_9p_button)
	end
	self:AddMenuSelector(x_off(), y, self:Locale("$ml_current_rewards"), self:Locale("$ml_current_rewards_tp"),
		self.DrawCurrentRewards)

	self:AddMenuSelector(x_off(), y, "Stats", "heh", self.DrawStatsMenu)

	self:AddMenuSelector(x_off(), y, "Meta", "mheh", self.DrawMetaMenu)

	self:Text(self.const.width + self.data.x - self:GetTextDimension(self:Locale("$ml_close")), y,
		self:Locale("$ml_close"))
	self:MakeButtonFromPrev(self:Locale("$ml_close_tp"), self.CloseMenu, self.const.z, self.const.ui_9p_button,
		self.const.ui_9p_button_hl)
	self:AnimateE()

	if self.data.debug then
		self:Text(self.const.width + self.data.x - self:GetTextDimension(self:Locale("DEBUG")),
			y - self.const.sprite_offset * 2 - 10.5,
			self:Locale("DEBUG"))
		self:MakeButtonFromPrev("cheat menu", self.ToggleMenuWindow, self.const.z, self.const.ui_9p_button,
			self.const.ui_9p_button_hl, self.DrawDebugMenu)
	end
end

---draw header
---@private
function LU:DrawMainHeader()
	self:MenuAnimS("header")
	local third_width = self.const.width * 0.33
	local section = 10
	local experience = self:Locale("$ml_experience: ") .. MLP.exp:format(MLP.exp:get())
	if MLP.exp:get() < 10 ^ 21 then
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

---draw connector between header and window
---@private
function LU:DrawMenuConnector()
	self:AnimateB()
	self:AnimateAlpha(0.08, 0.1, self.anim["window"].reset)
	self:SetZ(5)
	self:Draw9Piece(self.data.x, self.data.y, self.const.z + 1, self.const.width, 0,
		"mods/meta_leveling/files/gfx/ui/ui_9piece_connector.png")
	self:BlockInputOnPrevious()
	self:AnimateE()
end

---main window
---@private
function LU:DrawMainMenu()
	self.data.x, self.data.y = self:CalculateCenterInScreen(self.const.width, self.const.height)
	self:DrawMainHeader()
	self:DrawMenuButtons()
	if self.DrawWindow then
		self:DrawMenuConnector()
		self:MenuAnimS("window")
		self:DrawWindow()
		self:AnimateE()
	end
end

-- ############################################
-- #############		LOGIC		###########
-- ############################################

---gathers settings on pause update
function LU:GetSetting()
	self:UpdateDimensions()
	self.data.CloseOnShot = MLP.get:mod_setting_boolean("session_exp_close_ui_on_shot")
	self.data.CloseOnDamage = MLP.get:mod_setting_boolean("session_exp_close_ui_on_damage")
	self.data.SkipMenuOnPending = MLP.get:mod_setting_boolean("session_exp_ui_open_auto")
	self.data.debug = ModIsEnabled("component-explorer")
	self:CalculateProgressOffset()
end

---main logic
---@private
function LU:DrawLevelUI()
	GuiZSet(self.gui, self.const.z - 2)
	if GameHasFlagRun(MLP.const.flags.leveling_up) then
		self:DrawPointSpender()
	else
		if self.data.SkipMenuOnPending and ML.pending_levels > 0 then
			GameAddFlagRun(MLP.const.flags.leveling_up)
		end
		self:DrawMainMenu()
	end

	self:CheckForAnim()
end

---main loop
function LU:loop()
	if ML.gui_em_exit then self:EmergencyExit() end
	self:StartFrame(self.DrawLevelUI, ML.gui)
end

return LU
