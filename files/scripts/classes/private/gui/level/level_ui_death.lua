---@class level_ui
local LU_d = {
	credits = {
		frame = 0,
	},
}

--- Calculates credits length
--- @private
function LU_d:DeathCalculateCreditsLength()
	self.credits.scroll_speed = tonumber(MagicNumbersGetValue("CREDITS_SCROLL_SPEED")) or 25
	self.credits.scroll_speed_multiplier = tonumber(MagicNumbersGetValue("CREDITS_SCROLL_SKIP_SPEED_MULTIPLIER")) or 15
	local offset = tonumber(MagicNumbersGetValue("CREDITS_SCROLL_END_OFFSET_EXTRA")) or 85
	local credits = ModTextFileGetContent("data/credits.txt")
	local credits_lines = 0
	for _ in credits:gmatch("[^\n]+") do
		credits_lines = credits_lines + 1
	end
	local _, height = self:GetTextDimension("A")
	local extra_lines = 37 -- two empty screens + 4 extra lines on start - logo at the end
	local total_distance = (credits_lines + extra_lines) * height
	self.credits.speed_up_until_frame = total_distance * 60
	self.credits.total_distance = self.credits.speed_up_until_frame + offset * 60 - 60
end

---Returns true is credits is playing
---@return boolean
---@nodiscard
function LU_d:DeathIsCreditsPlaying()
	if not self.credits.total_distance then self:DeathCalculateCreditsLength() end
	if GameHasFlagRun("ending_game_completed") and self.credits.frame < self.credits.total_distance then
		local scroll_speed = self.credits.scroll_speed
		-- don't speedup for last part (logo fade out)
		if InputIsKeyDown(self.c.codes.keyboard.space) and self.credits.frame < self.credits.speed_up_until_frame then
			scroll_speed = scroll_speed * self.credits.scroll_speed_multiplier
		end
		self.credits.frame = self.credits.frame + scroll_speed
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
	local acquired = MLP.get:global_number(MLP.const.globals.meta_point_acquired, 0)
	if acquired > 0 then
		local text = string.format("%s: %d, %s: %d", self:Locale("$ml_meta_available"), points, self:Locale("$ml_meta_acquired_in_run"), acquired)
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
	if ML.gui or self:IsControlCharsPressed() then self:DeathMenuInit() end
	local cause_of_death = StatsGetValue("killed_by") .. " " .. StatsGetValue("killed_by_extra")
	local cause_of_death_len = self:GetTextDimension(self:Locale("$stat_cause_of_death " .. cause_of_death))
	local x_cod = self:CalculateCenterInScreen(cause_of_death_len, self.dim.y)
	local you_are_dead_len = self:GetTextDimension(self:Locale(" $menugameover_nextbutton "))
	local x_yad = self:CalculateCenterInScreen(you_are_dead_len, self.dim.y)
	local hovered_cod = self:IsHoverBoxHovered(x_cod, 132, cause_of_death_len, 20, true)
	local hovered_yad = self:IsHoverBoxHovered(x_yad, 142, you_are_dead_len, 20, true)
	if hovered_cod or hovered_yad then
		if self:IsMouseClicked() then self:DeathMenuInit() end
	end
end

function LU_d:DeathDrawMenu()
	if not GameHasFlagRun(MLP.const.flags.dead) then self:DeathDrawTriggerEndMenu() end
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
