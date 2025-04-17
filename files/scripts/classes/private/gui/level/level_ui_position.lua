---@class (exact) position_data
---@field prefix string
---@field x number
---@field y number
---@field moving boolean
---@field moving_start_x number
---@field moving_start_y number
---@field default_x number
---@field default_y number
---@field max_x number
---@field max_y number

---@class level_ui
local LU = {}

---Clamps position so it won't go over the window
---@private
---@param position position_data
---@param x number
---@param y number
---@return number x, number y
function LU:ClampPosition(position, x, y)
	x = math.max(0, math.min(x, position.max_x))
	y = math.max(-10, math.min(y, position.max_y))
	return x, y
end

---Sets default position for UI
---@private
---@param position position_data
function LU:SetPositionDefault(position)
	self:WritePosition(position.prefix, position.default_x, position.default_y)
end

---Sets position for UI
---@private
---@param prefix string
---@param x number
---@param y number
function LU:WritePosition(prefix, x, y)
	ModSettingSet(prefix .. ".x", x)
	ModSettingSet(prefix .. ".y", y)
end

---Gets position from settings or sets default
---@private
---@param position position_data
function LU:GetPosition(position)
	local x = ModSettingGet(position.prefix .. ".x") ---@cast x integer
	local y = ModSettingGet(position.prefix .. ".y") ---@cast y integer
	if not x or not y then
		self:SetPositionDefault(position)
		position.x, position.y = position.default_x, position.default_y
	else
		position.x, position.y = self:ClampPosition(position, x, y)
	end
end

---Moves window
---@private
---@param position position_data
---@return boolean
function LU:IsHandlingPositionMovement(position)
	if not position.moving then return false end
	if not InputIsMouseButtonDown(self.c.codes.mouse.lc) then
		position.moving = false
		self:WritePosition(position.prefix, position.x, position.y)
		self:GetPosition(position)
		return false
	end
	local mouse_x, mouse_y = self:get_mouse_pos()
	local x = position.x + mouse_x - position.moving_start_x
	local y = position.y + mouse_y - position.moving_start_y
	position.x, position.y = self:ClampPosition(position, x, y)
	position.moving_start_x, position.moving_start_y = mouse_x, mouse_y
	return true
end

---Starts moving
---@private
---@param position position_data
function LU:TriggerPositionMovement(position)
	if InputIsMouseButtonDown(self.c.codes.mouse.lc) then
		position.moving = true
		position.moving_start_x, position.moving_start_y = self:get_mouse_pos()
	end
	if InputIsMouseButtonDown(self.c.codes.mouse.rc) then
		self:SetPositionDefault(position)
		self:GetPosition(position)
	end
end

return LU
