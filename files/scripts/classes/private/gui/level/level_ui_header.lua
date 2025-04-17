---@class level_ui
---@field header_position position_data
---@field header_hovered_frames number
local LU = {
	header_position = {
		prefix = "meta_leveling.ui_position",
		x = 0,
		y = 0,
		moving = false,
		moving_start_x = 0,
		moving_start_y = 0,
		default_x = 0,
		default_y = 0,
	},
	header_hovered_frames = 0,
}

function LU:MainHeaderTooltip()
	self:TextCentered(0, 0, "Meta Leveling", 0)
	self:TextCentered(0, 0, self:Locale("$ml_level: ") .. ML:get_level(), 0)
	self:TextCentered(0, 0, self:Locale("$ml_experience: ") .. MLP.exp:current(), 0)
	self:ColorGray()
	self:TextCentered(0, 0, self:Locale("$ml_position_move"), 0)
	self:ColorGray()
	self:TextCentered(0, 0, self:Locale("$ml_position_reset"), 0)
end

---Do stuff if header is hovered
---@private
function LU:HeaderHovered()
	if self:IsHandlingPositionMovement(self.header_position) then
		self.scroll.height_max = self.dim.y - self.header_position.y - 90
		return
	end

	local sprite_off = self.const.sprite_offset
	local half_sprite = sprite_off / 2
	local hovered = self:IsHoverBoxHovered(self.data.x - half_sprite, self.data.y - half_sprite, self.const.width + sprite_off, 10 + sprite_off, true)

	if hovered then
		self.header_hovered_frames = self.header_hovered_frames + 1
		if self.header_hovered_frames > 45 then self:ShowTooltip(self.data.x + self.const.width / 2, self.data.y + 30, self.MainHeaderTooltip) end
		self:BlockInput()
		if InputIsKeyDown(self.c.codes.keyboard.lshift) then self:TriggerPositionMovement(self.header_position) end
	else
		self.header_hovered_frames = 0
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

---Updates header data
function LU:header_update_data()
	self.header_position.default_x, self.header_position.default_y = self:CalculateCenterInScreen(self.const.width, self.const.height)
	self:GetPosition(self.header_position)
	self.scroll.height_max = self.dim.y - self.header_position.y - 90
end

return LU
