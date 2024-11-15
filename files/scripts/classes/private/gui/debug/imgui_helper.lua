--- @class ml_debug
local debug = {}

--- Draws text in gray
--- @private
--- @param text any
function debug:gray_text(text)
	self.imgui.PushStyleColor(0, 0.6, 0.6, 0.6)
	self.imgui.Text(tostring(text))
	self.imgui.PopStyleColor()
end

--- Draws text in gray and white
--- @private
--- @param gray any
--- @param normal any
--- @param addition? any
function debug:gray_normal_text(gray, normal, addition)
	self:gray_text(gray)
	self.imgui.SameLine()
	self.imgui.Text(tostring(normal))
	if addition then
		self.imgui.SameLine()
		self:gray_text(tostring(addition))
	end
end

return debug
