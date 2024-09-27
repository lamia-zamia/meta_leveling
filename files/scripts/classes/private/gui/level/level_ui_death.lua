---@class level_ui
local LU_d = {}

---Returns true is credits is playing
---@return boolean
---@nodiscard
function LU_d:DeathIsCreditsPlaying()
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
function LU_d:DeathDrawEndMenu()
	local points = MLP.points:get_current_currency()
	GuiZSet(self.gui, self.const.z - 2)
	self:AnimateB()
	self:AnimateAlpha(0.05, 0.1, false)
	self:AnimateScale(0.05, false)
	self:Color(0.8, 0.8, 0.8)
	local center = (self.dim.x - self:GetTextDimension("Meta Leveling")) / 2
	if self:IsButtonClicked(center, self.data.y + 10, self.const.z - 2, "Meta Leveling", self:Locale("$ml_exp_bar_tooltip")) then
		self:AnimReset("buttons")
		self:OpenMenu()
	end
	if points > 0 then
		local acquired = MLP.get:global_number(MLP.const.globals.meta_point_acquired, 0)
		local text = self:Locale("$ml_meta_available: ") .. points
		if acquired > 0 then
			text = text .. self:Locale(", $ml_meta_acquired_in_run: ") .. acquired
		end
		self:Color(0.8, 0.8, 0.8)
		self:TextCentered(0, self.data.y + 25, text, self.dim.x)
	end
	self:AnimateE()
end

---Sets parameters
---@private
function LU_d:DeathMenuInit()
	ML.gui = false
	GameAddFlagRun(MLP.const.flags.dead)
	self.DrawWindow = nil
end

---Adds triggers for opening menu
function LU_d:DeathDrawTriggerEndMenu()
	if ML.gui or self:IsControlCharsPressed() then
		self:DeathMenuInit()
	end
	local cause_of_death = StatsGetValue("killed_by") .. " " .. StatsGetValue("killed_by_extra")
	local cause_of_death_len = self:GetTextDimension(self:Locale("$stat_cause_of_death " .. cause_of_death))
	local x_cod = self:CalculateCenterInScreen(cause_of_death_len, self.dim.y)
	local you_are_dead_len = self:GetTextDimension(self:Locale(" $menugameover_nextbutton "))
	local x_yad = self:CalculateCenterInScreen(you_are_dead_len, self.dim.y)
	local hovered_cod = self:IsHoverBoxHovered(x_cod, 132, cause_of_death_len, 15, true)
	local hovered_yad = self:IsHoverBoxHovered(x_yad, 142, you_are_dead_len, 15, true)
	if hovered_cod or hovered_yad then
		if self:IsMouseClicked() then
			self:DeathMenuInit()
		end
	end
end

function LU_d:DeathDrawMenu()
	if not GameHasFlagRun(MLP.const.flags.dead) then
		self:DeathDrawTriggerEndMenu()
	end
	self.scroll.height_max = 75
	self.data.y = 10
	if ML.gui then
		self:DrawButtonsAndWindow()
	elseif self.data.on_death and GameHasFlagRun(MLP.const.flags.dead) then
		self:DeathDrawEndMenu()
	else

	end
end

return LU_d
