--- @class ml_debug
local debug = {}

--- Gets current data
--- @private
--- :)
function debug:fetch_current()
	self.numbers.level = ML:get_level()
	self.numbers.experience = MLP.exp:current()
	self.numbers.meta = MLP.points:get_current_currency()
end

--- Draws number menu
--- @private
--- :)
function debug:draw_numbers()
	if self.imgui.Button("Reset to current") then self:fetch_current() end
	local _, level = self.imgui.InputInt("level", self.numbers.level, 1, 10)
	self.numbers.level = level
	if self.imgui.IsItemDeactivatedAfterEdit() then
		MLP.set:global_number(MLP.const.globals.current_exp, ML.level_curve[self.numbers.level - 1])
		MLP.set:global_number(MLP.const.globals.current_level, self.numbers.level - 1)
		ML:level_up()
		self:fetch_current()
	end
	_, self.numbers.experience = self.imgui.InputFloat("experience", self.numbers.experience, 10, 1000)
	if self.imgui.IsItemDeactivatedAfterEdit() then
		MLP.set:global_number(MLP.const.globals.current_exp, self.numbers.experience)
		self:fetch_current()
	end
	_, self.numbers.meta = self.imgui.InputFloat("meta points", self.numbers.meta, 1, 10)
	if self.imgui.IsItemDeactivatedAfterEdit() then
		MLP.points:set_meta_points(self.numbers.meta)
		self:fetch_current()
	end
end

return debug
