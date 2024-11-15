local ui = dofile("mods/meta_leveling/files/scripts/lib/ui_lib.lua") --- @class UI_class

--- @class ml_debug
local debug = {}

--- Render icon in real gui
--- @private
--- @param reward ml_single_reward_data
function debug:draw_icon_in_game(reward)
	local function draw(x, y)
		ui:Draw9Piece(x - 1, y - 1, -5000, 18, 18, "mods/meta_leveling/files/gfx/ui/ui_9piece_reward.png")
		ui:SetZ(-6000)
		local r, g, b, a = unpack(reward.border_color)
		ui:Color(r, g, b)
		ui:Image(x - 4, y - 4, "mods/meta_leveling/files/gfx/ui/reward_glow.png", a)
		ui:SetZ(-7000)
		if reward.ui_icon:find("%.xml") then
			ui:Image(x, y, reward.ui_icon)
		else
			local width, height = GuiGetImageDimensions(self.gui, reward.ui_icon, 1)
			local x_offset = (16 - width) / 2
			local y_offset = (16 - height) / 2
			ui:Image(x + x_offset, y + y_offset, reward.ui_icon)
		end
	end
	local x = 610
	local y = 330
	ui:StartFrame()
	ui:Draw9Piece(x - 41, y - 6, -3000, 28, 28)
	draw(x, y)
	draw(x - 35, y)
end

--- Draws tooltip for reward
--- @private
--- @param reward ml_single_reward_data
function debug:reward_description(reward)
	self:gray_normal_text("id: ", reward.id --[[@as string]])
	self:gray_normal_text("name: ", ML.rewards_deck.FormatString(ui:Locale(reward.ui_name)), " (" .. reward.ui_name .. ")")
	if reward.description then self:gray_normal_text("desk: ", ML.rewards_deck:UnpackDescription(reward.description, reward.description_var)) end
	if reward.description2 then self:gray_normal_text("desk2: ", ML.rewards_deck:UnpackDescription(reward.description2, reward.description2_var)) end
	self:gray_normal_text("prob: ", ML.rewards_deck:get_probability(reward.probability)) --- @diagnostic disable-line: invisible
	if reward.max < 1280 then self:gray_normal_text("max: ", reward.max) end
	if reward.limit_before then self:gray_normal_text("not before: ", reward.limit_before) end
	if reward.custom_check then self:gray_normal_text("custom check: ", reward.custom_check()) end
	if reward.min_level > 1 then self:gray_normal_text("min level: ", reward.min_level) end
end

return debug
