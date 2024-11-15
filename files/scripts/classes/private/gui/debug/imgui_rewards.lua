--- @class ml_debug
local debug = {}

--- Draws reward menu
--- @private
--- :)
function debug:draw_rewards()
	local interval = 30 * self.scale
	local width = self.imgui.GetWindowWidth()
	local _, rewards_search = self.imgui.InputText("search", self.rewards_search)
	self.rewards_search = rewards_search
	self.imgui.SameLine()
	if self.imgui.Button("clear") then self.rewards_search = "" end
	for i, reward in ipairs(ML.rewards_deck.ordered_rewards_data) do
		if self.rewards_search ~= "" and not string.find(reward.id, self.rewards_search) then --- @diagnostic disable-line: param-type-mismatch
			goto continue
		end
		local pos_x, pos_y = self.imgui.GetCursorPos()
		if pos_x + interval * 2 >= width then
			pos_y = pos_y + interval
			pos_x = 8
		else
			pos_x = pos_x + interval
		end
		if self:draw_reward_full_icon(reward, i) then
			self:draw_icon_in_game(reward)
			if self.imgui.BeginTooltip() then
				self:reward_description(reward)
				self.imgui.EndTooltip()
			end
			if self.imgui.IsMouseClicked(self.imgui.MouseButton.Left) then ML.rewards_deck:pick_reward(reward.id) end
		end
		self.imgui.SetCursorPos(pos_x, pos_y)
		::continue::
	end
	self.xml_viewer:advance_frame()
end

return debug
