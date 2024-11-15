--- @class ml_debug
local debug = {}

--- Draws icon with borders
--- @private
--- @param reward ml_single_reward_data
--- @param id number window id
--- @return boolean
function debug:draw_reward_full_icon(reward, id)
	local size = 16
	local margin = 8
	local cursor_offset = margin / 2 * self.scale
	local box_size = size + margin
	local pos_x, pos_y = self.imgui.GetCursorPos()

	local border_img = self.imgui.LoadImage("mods/meta_leveling/files/gfx/ui/reward_glow.png")
	local border_img_size = box_size * self.scale
	local r, g, b, a = unpack(reward.border_color)
	if border_img then self.imgui.Image(border_img, border_img_size, border_img_size, 0, 0, 1, 1, r, g, b, a) end
	self.imgui.SetCursorPos(pos_x + cursor_offset, pos_y + cursor_offset)
	if self.imgui.BeginChild(reward.id .. id, size * self.scale, size * self.scale, 0, self.child_flags) then --- @diagnostic disable-line: param-type-mismatch
		self:draw_reward_icon(size, reward.ui_icon)
		self.imgui.EndChild()
	end
	self.imgui.SetCursorPos(pos_x, pos_y)
	local hovered = self.imgui.IsItemHovered()
	local border = hovered and "mods/meta_leveling/files/gfx/ui/ui_9piece_reward_highlight.png"
		or "mods/meta_leveling/files/gfx/ui/ui_9piece_reward.png"
	self:ImGui9Piece(border, box_size, box_size)
	return hovered
end

--- Draw a 9-slice sprite in ImGui with scaling support
--- @private
--- @param image any -- ImGui texture identifier (e.g., from self.imgui.LoadImage)
--- @param width number -- Total width of the final drawn piece
--- @param height number -- Total height of the final drawn piece
function debug:ImGui9Piece(image, width, height)
	local img = self.imgui.LoadImage(image)
	if not img then return end
	local image_size = img.height
	local patch = image_size / 3

	width = width * self.scale
	height = height * self.scale
	local scaled_patch = patch * self.scale
	local pos_x, pos_y = self.imgui.GetCursorPos()
	-- Calculate UV coordinates for the 9 segments of the image
	local uv = {
		top_left = { 0, 0, patch / image_size, patch / image_size },
		top_right = { (image_size - patch) / image_size, 0, 1, patch / image_size },
		bottom_left = { 0, (image_size - patch) / image_size, patch / image_size, 1 },
		bottom_right = { (image_size - patch) / image_size, (image_size - patch) / image_size, 1, 1 },
		top = { patch / image_size, 0, (image_size - patch) / image_size, patch / image_size },
		bottom = { patch / image_size, (image_size - patch) / image_size, (image_size - patch) / image_size, 1 },
		left = { 0, patch / image_size, patch / image_size, (image_size - patch) / image_size },
		right = { (image_size - patch) / image_size, patch / image_size, 1, (image_size - patch) / image_size },
		center = { patch / image_size, patch / image_size, (image_size - patch) / image_size, (image_size - patch) / image_size },
	}

	-- Render corners with scaling
	self.imgui.SetCursorPos(pos_x, pos_y)
	self.imgui.Image(img, scaled_patch, scaled_patch, uv.top_left[1], uv.top_left[2], uv.top_left[3], uv.top_left[4]) -- Top-left

	self.imgui.SetCursorPos(pos_x + width - scaled_patch, pos_y)
	self.imgui.Image(img, scaled_patch, scaled_patch, uv.top_right[1], uv.top_right[2], uv.top_right[3], uv.top_right[4]) -- Top-right

	self.imgui.SetCursorPos(pos_x, pos_y + height - scaled_patch)
	self.imgui.Image(img, scaled_patch, scaled_patch, uv.bottom_left[1], uv.bottom_left[2], uv.bottom_left[3], uv.bottom_left[4]) -- Bottom-left

	self.imgui.SetCursorPos(pos_x + width - scaled_patch, pos_y + height - scaled_patch)
	self.imgui.Image(img, scaled_patch, scaled_patch, uv.bottom_right[1], uv.bottom_right[2], uv.bottom_right[3], uv.bottom_right[4]) -- Bottom-right

	-- Render borders with scaling
	self.imgui.SetCursorPos(pos_x + scaled_patch, pos_y)
	self.imgui.Image(img, width - 2 * scaled_patch, scaled_patch, uv.top[1], uv.top[2], uv.top[3], uv.top[4]) -- Top border

	self.imgui.SetCursorPos(pos_x + scaled_patch, pos_y + height - scaled_patch)
	self.imgui.Image(img, width - 2 * scaled_patch, scaled_patch, uv.bottom[1], uv.bottom[2], uv.bottom[3], uv.bottom[4]) -- Bottom border

	self.imgui.SetCursorPos(pos_x, pos_y + scaled_patch)
	self.imgui.Image(img, scaled_patch, height - 2 * scaled_patch, uv.left[1], uv.left[2], uv.left[3], uv.left[4]) -- Left border

	self.imgui.SetCursorPos(pos_x + width - scaled_patch, pos_y + scaled_patch)
	self.imgui.Image(img, scaled_patch, height - 2 * scaled_patch, uv.right[1], uv.right[2], uv.right[3], uv.right[4]) -- Right border

	-- Render center with scaling
	self.imgui.SetCursorPos(pos_x + scaled_patch, pos_y + scaled_patch)
	self.imgui.Image(img, width - 2 * scaled_patch, height - 2 * scaled_patch, uv.center[1], uv.center[2], uv.center[3], uv.center[4])
end

--- Draws image or xml
--- @private
--- @param size number
--- @param icon string
function debug:draw_reward_icon(size, icon)
	if icon:find("%.xml$") then
		if self.xml_viewer:can_display_xml(icon) then
			local offset = self.xml_viewer:get_offset()
			if offset then
				local pos_x, pos_y = self.imgui:GetCursorPos()
				self.imgui.SetCursorPos(pos_x - offset.x * self.scale, pos_y - offset.y * self.scale)
			end
			self.xml_viewer:show("default", size * self.scale, size * self.scale)
		else
			self.imgui.Text(self.xml_viewer:error_message())
		end
	else
		local img = self.imgui.LoadImage(icon)
		if img then self.imgui.Image(img, size * self.scale, size * self.scale) end
	end
end

return debug
