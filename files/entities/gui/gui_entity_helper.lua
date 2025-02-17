---@diagnostic disable: invisible

---@class ML_gui_entity_helper
---@field private scale number
---@field private scale_direction number
---@field private gui_lib UI_class
---@field private icon string
---@field private tooltip string
---@field private gui_count number
---@field private order number
---@field private __index ML_gui_entity_helper
---@field private wait_frame number
---@field opened boolean
local helper = {
	scale = 1,
	scale_direction = 1,
	opened = false,
	gui_count = 0,
	order = 0,
	wait_frame = 0,
}
helper.__index = helper

---Gets a list of gui entities
---@private
---@return entity_id[]
---@nodiscard
function helper.get_extra_gui_entities()
	local player = EntityGetWithTag("player_unit")[1]
	if not player then return {} end

	local children = EntityGetAllChildren(player) or {}
	local relevant_children = {}
	for _, child in ipairs(children) do
		local vsc = EntityGetFirstComponent(child, "VariableStorageComponent")
		if vsc and ComponentGetValue2(vsc, "name") == "ML_extra_gui" then relevant_children[#relevant_children + 1] = child end
	end
	return relevant_children
end

---Gets a sorted list of gui entities depending on priority
---@private
---@param relevant_children entity_id[]
---@return {entity:entity_id, priority:number}
function helper.get_sorted_gui_entities(relevant_children)
	local child_list = {}
	for _, child in ipairs(relevant_children) do
		local vsc = EntityGetFirstComponent(child, "VariableStorageComponent")
		if vsc then child_list[#child_list + 1] = { entity = child, priority = ComponentGetValue2(vsc, "value_int") or 99 } end
	end
	table.sort(child_list, function(a, b)
		return a.priority < b.priority
	end)
	return child_list
end

---Gets a position to render the icon
---@private
---@return number
function helper:get_plane()
	local relevant_children = self.get_extra_gui_entities()
	local gui_count = #relevant_children
	if gui_count == 0 then return 0 end
	if gui_count == self.gui_count then return self.order end
	self.gui_count = gui_count

	local sorted_gui_entities = self.get_sorted_gui_entities(relevant_children)
	local this_entity = GetUpdatedEntityID()
	for i, gui in ipairs(sorted_gui_entities) do
		if gui.entity == this_entity then
			local plane = i - 1
			self.order = plane
			return plane
		end
	end
	return 50
end

---Advances scale
---@private
function helper:advance_scale()
	if self.scale > 1.3 or self.scale < 1 then self.scale_direction = -self.scale_direction end
	self.scale = self.scale + 0.005 * self.scale_direction
end

---Sets this ui as opened
function helper:set_opened()
	self.opened = true
	GameAddFlagRun("META_LEVELING_EXTRA_GUI_OPENED")
end

---Sets this ui as closed
function helper:set_closed()
	self.opened = false
	GameRemoveFlagRun("META_LEVELING_EXTRA_GUI_OPENED")
end

---Draws notification icon
function helper:draw_notification()
	if GameHasFlagRun("META_LEVELING_EXTRA_GUI_OPENED") then
		self.wait_frame = GameGetFrameNum() + 2
		return
	end
	if GameGetFrameNum() < self.wait_frame then
		self.scale = 1
		self.scale_direction = 1
		return
	end

	local x = self.gui_lib.dim.x - 14.5
	local y = 92 + self:get_plane() * 16

	self:advance_scale()

	local img_w, img_h = GuiGetImageDimensions(self.gui_lib.gui, self.icon, self.scale)

	self.gui_lib:AddOptionForNext(self.gui_lib.c.options.NonInteractive)
	self.gui_lib:SetZ(-1001)
	self.gui_lib:Image(x - img_w / 2, y - img_h / 2, self.icon, 1, self.scale)

	if self.gui_lib:IsHoverBoxHovered(x - 10, y - 10, 20, 20) then
		self.gui_lib:ShowTooltipTextCenteredX(0, 5, self.gui_lib:Locale(self.tooltip))
		if self.gui_lib:IsMouseClicked() then
			GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_click", 0, 0)
			self:set_opened()
		end
	end
end

---Creates new icon
---@param gui_lib UI_class
---@param icon string
---@param tooltip string
---@return ML_gui_entity_helper
function helper:new(gui_lib, icon, tooltip)
	GameRemoveFlagRun("META_LEVELING_EXTRA_GUI_OPENED")
	local o = {
		gui_lib = gui_lib,
		icon = icon,
		tooltip = tooltip,
	}
	setmetatable(o, self)
	return o
end

return helper
