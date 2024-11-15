--- @class ml_debug
local debug = {}

--- Draws deck
--- @private
function debug:draw_deck()
	if #ML.rewards_deck.list == 0 then ML.rewards_deck:refresh_reward_order() end --- @diagnostic disable-line: invisible
	local list = ML.rewards_deck.list --- @diagnostic disable-line: invisible
	local current_index = MLP.get:global_number(MLP.const.globals.draw_index, 1)
	self.imgui.Text("Deck, current index: " .. current_index .. ", total number: " .. #list)

	local interval = 30 * self.scale
	local width = self.imgui.GetWindowWidth()

	for i, reward_id in ipairs(list) do
		local reward = ML.rewards_deck.reward_data[reward_id]
		local pos_x, pos_y = self.imgui.GetCursorPos()
		if pos_x + interval * 2 >= width then
			pos_y = pos_y + interval
			pos_x = 8
		else
			pos_x = pos_x + interval
		end
		if self:draw_reward_full_icon(reward, i) then
			-- self:draw_icon_in_game(reward)
			if self.imgui.BeginTooltip() then
				self:reward_description(reward)
				self.imgui.EndTooltip()
			end
		end
		self.imgui.SetCursorPos(pos_x, pos_y)
	end
	self.xml_viewer:advance_frame()
end

return debug
