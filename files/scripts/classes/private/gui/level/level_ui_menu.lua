---@class level_ui
local LU_menu = {}

---toggle between different windows when buttons pressed
---@private
function LU_menu:ToggleMenuWindow(window)
	self:ResetScrollBox()
	if self.DrawWindow == window then
		self.DrawWindow = nil
	else
		self.DrawWindow = window
	end
end

---buttons functions
---@private
function LU_menu:AddMenuSelector(x, y, text, tooltip, fn)
	if self.DrawWindow == fn then
		self:ColorGray()
		self:Text(x, y, text)
		self:AddOptionForNext(self.c.options.ForceFocusable)
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
function LU_menu:DrawMenuButtons()
	self:MenuAnimS("header")
	local y = self.data.y - 5.5
	local x = self.data.x
	local function x_off()
		local prev = self:GetPrevious()
		x = x + prev.w + 10
		return x
	end
	if ML.pending_levels >= 1 and not GameHasFlagRun(MLP.const.flags.dead) then
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
		self.Current_DrawRewards)

	self:AddMenuSelector(x_off(), y, self:Locale("$ml_stats"), self:Locale("$ml_stats_tp"), self.Stats_DrawMenu)

	self:AddMenuSelector(x_off(), y, self:Locale("$ml_meta"), self:Locale("$ml_meta_tp"), self.DrawMetaMenu)

	self:AddMenuSelector(x_off(), y, self:Locale("$ml_rewards_progression"), self:Locale("$ml_rewards_progression_tp"),
		self.DrawRewardsList)

	self:Text(self.const.width + self.data.x - self:GetTextDimension(self:Locale("$ml_close")), y,
		self:Locale("$ml_close"))
	self:MakeButtonFromPrev(self:Locale("$ml_close_tp"), self.CloseMenu, self.const.z, self.const.ui_9p_button,
		self.const.ui_9p_button_hl)
	self:AnimateE()
end

return LU_menu
