--- @class level_ui
local LU = {
	position = {
		x = 0,
		y = 0,
		moving = false,
		moving_start_x = 0,
		moving_start_y = 0,
		hovered_frames = 0,
	},
}

--- Clamps position so it won't go over the window
--- @private
--- @param x number
--- @param y number
--- @return number x, number y
function LU:ClampPosition(x, y)
	x = math.max(0, math.min(x, self.dim.x - self.const.width))
	y = math.max(-10, math.min(y, self.dim.y - 110))
	return x, y
end

--- Sets default position for UI
--- @private
function LU:SetPositionDefault()
	self.position.x, self.position.y = self:CalculateCenterInScreen(self.const.width, self.const.height)
	self:WritePosition(self.position.x, self.position.y)
end

--- Sets position for UI
--- @private
--- @param x number
--- @param y number
function LU:WritePosition(x, y)
	ModSettingSet("meta_leveling.ui_position.x", x)
	ModSettingSet("meta_leveling.ui_position.y", y)
end

--- Gets position from settings or sets default
--- @private
function LU:GetPosition()
	local x = ModSettingGet("meta_leveling.ui_position.x") ---@cast x integer
	local y = ModSettingGet("meta_leveling.ui_position.y") ---@cast y integer
	if not x or not y then
		self:SetPositionDefault()
	else
		self.position.x, self.position.y = self:ClampPosition(x, y)
	end
	self.scroll.height_max = self.dim.y - self.position.y - 90
end

--- Moves window
--- @private
function LU:HandlePositionMovement()
	if not InputIsMouseButtonDown(self.c.codes.mouse.lc) then
		self.position.moving = false
		self:WritePosition(self.position.x, self.position.y)
		self:GetPosition()
		return
	end
	local mouse_x, mouse_y = self:get_mouse_pos()
	local x = self.position.x + mouse_x - self.position.moving_start_x
	local y = self.position.y + mouse_y - self.position.moving_start_y
	self.position.x, self.position.y = self:ClampPosition(x, y)
	self.scroll.height_max = self.dim.y - self.position.y - 90
	self.position.moving_start_x, self.position.moving_start_y = mouse_x, mouse_y
end

--- Starts moving
--- @private
function LU:TriggerPositionMovement()
	if self:IsLeftClicked() then
		self.position.moving = true
		self.position.moving_start_x, self.position.moving_start_y = self:get_mouse_pos()
	end
	if self:IsRightClicked() then
		self:SetPositionDefault()
		self:GetPosition()
	end
end

function LU:MainHeaderTooltip()
	self:TextCentered(0, 0, "Meta Leveling", 0)
	self:TextCentered(0, 0, self:Locale("$ml_level: ") .. ML:get_level(), 0)
	self:TextCentered(0, 0, self:Locale("$ml_experience: ") .. MLP.exp:current(), 0)
	self:ColorGray()
	self:TextCentered(0, 0, self:Locale("$ml_position_move"), 0)
	self:ColorGray()
	self:TextCentered(0, 0, self:Locale("$ml_position_reset"), 0)
end

--- Do stuff if header is hovered
--- @private
function LU:HeaderHovered()
	if self.position.moving then
		self:HandlePositionMovement()
		return
	end
	if
		self:IsHoverBoxHovered(
			self.data.x - self.const.sprite_offset / 2,
			self.data.y - self.const.sprite_offset / 2,
			self.const.width + self.const.sprite_offset,
			10 + self.const.sprite_offset,
			true
		)
	then
		self.position.hovered_frames = self.position.hovered_frames + 1
		if self.position.hovered_frames > 45 then self:ShowTooltip(self.data.x + self.const.width / 2, self.data.y + 30, self.MainHeaderTooltip) end
		self:BlockInput()
		if InputIsKeyDown(self.c.codes.keyboard.lshift) then self:TriggerPositionMovement() end
	else
		self.position.hovered_frames = 0
	end
end

--- draw header
--- @private
function LU:DrawMainHeader()
	self:MenuAnimS("header")
	local third_width = self.const.width * 0.33
	local section = 10
	local experience = self:Locale("$ml_experience: ") .. MLP.exp:format(MLP.exp:current())
	if MLP.exp:current() < 10 ^ 21 then experience = experience .. "/" .. MLP.exp:format(ML.next_exp) end
	local level = self:Locale("$ml_level: ") .. ML:get_level()
	self.data.y = self.data.y + self.const.sprite_offset
	self:Draw9Piece(self.data.x, self.data.y, self.const.z + 1, self.const.width, section, self.const.ui_9piece)

	self:HeaderHovered()

	self:TextCentered(self.data.x, self.data.y, experience, third_width)
	self:TextCentered(self.data.x + third_width, self.data.y, "META LEVELING", third_width)
	self:TextCentered(self.data.x + third_width * 2, self.data.y, level, third_width)
	self:AnimateE()

	self.data.y = self.data.y + section + self.const.sprite_offset
end

return LU
