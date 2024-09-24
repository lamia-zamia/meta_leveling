---@class level_ui
local LU_d = {}

---Returns true is credits is playing
---@return boolean
---@nodiscard
function LU_d:IsCreditsPlaying()
	if GameHasFlagRun("ending_game_completed") and self.data.credits_frame < 5150 then
		self.data.credits_frame = self.data.credits_frame + 1
		if InputIsKeyDown(self.c.codes.keyboard.space) and self.data.credits_frame < 5000 then ---last few seconds doesn't accelerate with space
			self.data.credits_frame = self.data.credits_frame + 15
		end
		return true
	end
	return false
end

---Draws button on death screen
function LU_d:DrawEndMenu()
	local points = MLP.points:get_current_currency()
	GuiZSet(self.gui, self.const.z - 2)
	self:AnimateB()
	self:AnimateAlpha(0.05, 0.1, false)
	self:AnimateScale(0.05, false)
	self:Color(0.8, 0.8, 0.8)
	self:TextCentered(0, 10, "Meta Leveling", self.dim.x)
	self:MakeButtonFromPrev(self:Locale("$ml_exp_bar_tooltip"), self.OpenMenu, self.const.z + 10,
		self.const.ui_9p_button, self.const.ui_9p_button_hl)
	if points > 0 then
		local acquired = MLP.get:global_number(MLP.const.globals.meta_point_acquired, 0)
		local text = self:Locale("$ml_meta_available: ") .. points
		if acquired > 0 then
			text = text .. self:Locale(", $ml_meta_acquired_in_run: ") .. acquired
		end
		self:Color(0.8, 0.8, 0.8)
		self:TextCentered(0, 30, text, self.dim.x)
	end
	self:AnimateE()
end

---Adds triggers for opening menu
function LU_d:DrawTriggerEndMenu()
	if ML.gui then GameAddFlagRun(MLP.const.flags.dead) end
	if self:IsControlCharsPressed() then
		GameAddFlagRun(MLP.const.flags.dead)
	end
	local cause_of_death = StatsGetValue("killed_by") .. " " .. StatsGetValue("killed_by_extra")
	local cause_of_death_len = self:GetTextDimension(self:Locale("$stat_cause_of_death " .. cause_of_death))
	local x_cod = self:CalculateCenterInScreen(cause_of_death_len, self.dim.y)
	local you_are_dead_len = self:GetTextDimension(self:Locale(" $menugameover_nextbutton "))
	local x_yad = self:CalculateCenterInScreen(you_are_dead_len, self.dim.y)
	self:Draw9Piece(x_cod, 132, 10, cause_of_death_len, 15, self.c.empty)
	local hovered_cod = self:IsHovered()
	self:Draw9Piece(x_yad, 142, 10, you_are_dead_len, 15, self.c.empty)
	local hovered_yad = self:IsHovered()
	if hovered_cod or hovered_yad then
		if self:IsMouseClicked() then
			GameAddFlagRun(MLP.const.flags.dead)
		end
	end
end

return LU_d