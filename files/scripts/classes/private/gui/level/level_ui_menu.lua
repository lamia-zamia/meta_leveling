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
		self:DrawButton(x, y, self.const.z, text, false, self.const.ui_9p_button_hl, self.const.ui_9p_button_hl)
		if self:IsHovered() and self:IsMouseClicked() then
			self:ToggleMenuWindow(fn)
		end
	else
		if self:IsButtonClicked(x, y, self.const.z, text, tooltip) then
			self:ToggleMenuWindow(fn)
		end
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
	local level_up_text = self:Locale("$ml_level_up")
	if ML.pending_levels >= 1 and not GameHasFlagRun(MLP.const.flags.dead) then
		self:DrawButton(x, y, self.const.z, level_up_text, true, self.const.ui_9p_button_important, self.const.ui_9p_button_hl)
		if self:IsHovered() then
			self:ShowTooltipTextCenteredX(0, 22, self:Locale("$ml_level_up_tp"))
			if self:IsMouseClicked() then
				self:LevelUpOpenLevelUpMenu()
			end
		end
	else
		self:DrawButton(x, y, self.const.z, level_up_text, false)
	end

	self:AddMenuSelector(x_off(), y, self:Locale("$ml_current_rewards"), self:Locale("$ml_current_rewards_tp"),
		self.CurrentDrawRewards)

	self:AddMenuSelector(x_off(), y, self:Locale("$ml_stats"), self:Locale("$ml_stats_tp"), self.StatsDrawMenu)

	self:AddMenuSelector(x_off(), y, self:Locale("$ml_meta"), self:Locale("$ml_meta_tp"), self.MetaDrawMetaMenu)

	self:AddMenuSelector(x_off(), y, self:Locale("$ml_rewards_progression"), self:Locale("$ml_rewards_progression_tp"),
		self.ListDrawRewardsList)

	local close_text = self:Locale("$ml_close")
	if self:IsButtonClicked(self.const.width + self.data.x - self:GetTextDimension(close_text), y, self.const.z, close_text, self:Locale("$ml_close_tp")) then
		self:CloseMenu()
	end
end

return LU_menu
