--- @class ml_perk_picker_gui:UI_class
local gui = dofile("mods/meta_leveling/files/scripts/lib/ui_lib.lua")
gui.buttons.img = "mods/meta_leveling/files/gfx/ui/ui_9piece_button.png"
gui.buttons.img_hl = "mods/meta_leveling/files/gfx/ui/ui_9piece_button_highlight.png"
gui.tooltip_img = "mods/meta_leveling/files/gfx/ui/ui_9piece_tp.png"
gui.picked = {}
gui.picked_count = 0
local perk_picker = dofile_once("mods/meta_leveling/files/entities/perk_picker/perk_picker.lua") --- @type ml_random_perk_picker
local picker_opened = false
local scale_step = 1
local scale_direction = 1

--- invisible 9piece to block inputs on gui
--- @private
function gui:BlockInputOnPrevious()
	local prev = self:GetPrevious()
	if self:IsHoverBoxHovered(prev.x - 10, prev.y - 10, prev.w + 20, prev.h + 20, true) then self:BlockInput() end
end

--- Tooltip for perk
--- @private
--- @param perk {id:string, ui_name:string, ui_description:string, icon:string}
function gui:DrawPerkTooltip(perk)
	self:TextCentered(0, 0, self:Locale(perk.ui_name), 0)
	self:ColorGray()
	self:TextCentered(0, 0, self:Locale(perk.ui_description), 0)
end

--- Draws perk
--- @private
--- @param x number
--- @param y number
--- @param i number
function gui:DrawPerk(x, y, i)
	local perk = perk_picker.perks[i]
	local picked = self.picked[i]
	self:AddOptionForNext(self.c.options.ForceFocusable)
	if picked then
		self:Draw9Piece(x, y, 190, 18, 18, "mods/meta_leveling/files/gfx/ui/ui_9piece_button_important.png")
	else
		self:Draw9Piece(x, y, 190, 18, 18, self.buttons.img, self.buttons.img_hl)
	end

	if self:IsHovered() then
		local cache = self:GetTooltipData(self.x_center, self.y_center, self.DrawPerkTooltip, perk)
		self:ShowTooltip(self.dim.x / 2, self.y_center - cache.height - 21, self.DrawPerkTooltip, perk)
		if self:IsLeftClicked() then
			if picked then
				self.picked[i] = nil
				self.picked_count = self.picked_count - 1
			else
				if self.picked_count < perk_picker.perk_count then
					self.picked[i] = true
					self.picked_count = self.picked_count + 1
				end
			end
		end
	end
	self:Image(x + 1, y + 1, perk.icon)
end

--- Draws row
--- @private
--- @param from number
--- @param to number
function gui:DrawRow(from, to)
	local x = self.x
	local y = self.y
	for i = from, to do
		self:DrawPerk(x, y, i)
		x = x + 30
	end
end

--- Draws main picker gui
--- @private
--- @return boolean
function gui:DrawPicker()
	local amount = #perk_picker.perks
	local split_rows = amount > 6
	local rows = split_rows and 2 or 1
	local amount_per_row = math.ceil(amount / rows)
	local total_width = (amount_per_row * 30) - 12
	local total_height = (30 * rows) - 12
	self.x_center, self.y_center = self:CalculateCenterInScreen(total_width, total_height)
	self.x, self.y = self.x_center, self.y_center

	self:Draw9Piece(self.x, self.y - 11, 200, total_width, total_height + 11, "mods/meta_leveling/files/gfx/ui/ui_9piece_gray.png")
	self:BlockInputOnPrevious()

	self:TextCentered(
		0,
		self.y - 15,
		string.format("%s: %d/%d", self:Locale("$ml_picked_perks"), self.picked_count, perk_picker.perk_count),
		self.dim.x
	)

	if split_rows then
		self:DrawRow(1, amount_per_row)
		self.x = self.x_center + (amount % 2 == 0 and 0 or 15)
		self.y = self.y + 30
		self:DrawRow(amount_per_row + 1, amount)
	else
		self:DrawRow(1, amount)
	end

	local button_text = self:Locale("$ml_picked_perks_apply")
	local button_x = self:CalculateCenterInScreen(self:GetTextDimension(button_text))
	if self:IsButtonClicked(button_x, self.y + 36, 150, button_text, "$ml_picked_perks_apply_tp") then
		GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_click", 0, 0)
		dofile("data/scripts/perks/perk.lua")
		local player = EntityGetWithTag("player_unit")[1]
		if not player then return false end
		local x, y = EntityGetTransform(player)
		for k, _ in pairs(self.picked) do
			local perk = perk_picker.perks[k]
			perk_pickup(0, player, perk.id, false, false, true) ---@diagnostic disable-line: undefined-global
		end
		GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/perk/create", x, y)
		return true
	end
	return false
end

--- Draws perk picker notification
--- @private
function gui:DrawNotification()
	local x = self.dim.x - 14.5
	local y = 92

	-- GuiText(self.gui, x, y, "+1", 0.75)
	if scale_step > 1.3 or scale_step < 1 then scale_direction = -scale_direction end
	scale_step = scale_step + 0.005 * scale_direction

	local img_w, img_h = GuiGetImageDimensions(self.gui, "data/ui_gfx/perk_icons/extra_perk.png", scale_step)

	self:AddOptionForNext(self.c.options.NonInteractive)
	self:SetZ(-1001)
	self:Image(x - img_w / 2, y - img_h / 2, "data/ui_gfx/perk_icons/extra_perk.png", 1, scale_step)

	if self:IsHoverBoxHovered(x - 10, y - 10, 20, 20) then
		self:ShowTooltipTextCenteredX(0, 5, self:Locale("$ml_picked_perks_open_tp"))
		if self:IsMouseClicked() then
			GamePlaySound("data/audio/Desktop/ui.bank", "ui/button_click", 0, 0)
			picker_opened = true
		end
	end
end

--- Draws gui
--- @return boolean
function gui:Draw()
	self:StartFrame()
	self.dim.x, self.dim.y = GuiGetScreenDimensions(self.gui)
	if picker_opened then
		return self:DrawPicker()
	else
		self:DrawNotification()
		return false
	end
end

return gui
