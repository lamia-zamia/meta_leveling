---@diagnostic disable: invisible

---@class ML_gui_entity_helper
---@field private scale number
---@field private scale_direction number
---@field private is_frame_advanced boolean[]
---@field private gui_lib UI_class
---@field private icon string
---@field private tooltip string
---@field private __index ML_gui_entity_helper
---@field opened boolean
local helper = {
	scale = 1,
	scale_direction = 1,
	is_frame_advanced = setmetatable({}, { __mode = "k" }),
	opened = false,
}
helper.__index = helper

---Advances scale
---@private
function helper:advance_scale()
	local frame = GameGetFrameNum()
	if helper.is_frame_advanced[frame] then return end
	if helper.scale > 1.3 or helper.scale < 1 then helper.scale_direction = -helper.scale_direction end
	helper.scale = helper.scale + 0.005 * helper.scale_direction
	helper.is_frame_advanced[frame] = true
end

---Draws notification icon
function helper:draw_notification()
	local x = self.gui_lib.dim.x - 14.5
	local y = 92

	self:advance_scale()

	local img_w, img_h = GuiGetImageDimensions(self.gui_lib.gui, self.icon, helper.scale)

	self.gui_lib:AddOptionForNext(self.gui_lib.c.options.NonInteractive)
	self.gui_lib:SetZ(-1001)
	self.gui_lib:Image(x - img_w / 2, y - img_h / 2, self.icon, 1, helper.scale)

	if self.gui_lib:IsHoverBoxHovered(x - 10, y - 10, 20, 20) then
		self.gui_lib:ShowTooltipTextCenteredX(0, 5, self.gui_lib:Locale(self.tooltip))
		if self.gui_lib:IsMouseClicked() then
			GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_click", 0, 0)
			self.opened = true
		end
	end
end

---Creates new icon
---@param gui_lib UI_class
---@param icon string
---@param tooltip string
---@return ML_gui_entity_helper
function helper:new(gui_lib, icon, tooltip)
	local o = {
		gui_lib = gui_lib,
		icon = icon,
		tooltip = tooltip,
	}
	setmetatable(o, self)
	return o
end

return helper
