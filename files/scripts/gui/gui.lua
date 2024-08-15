---@class UI_class
local UI = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/ui_lib.lua")
---@type experience_bar
local EB = dofile_once("mods/meta_leveling/files/scripts/gui/experience_bar.lua")
---@type level_ui
local LU = dofile_once("mods/meta_leveling/files/scripts/gui/level_ui.lua")

---@class ML_gui
---@field private UI UI_class
---@field private EB experience_bar
---@field private LU level_ui
local gui = {
	UI = UI,
	EB = EB,
	LU = LU
}

---update settings
function gui:UpdateSettings()
	UI:UpdateDimensions()
	self.EB:GetSettings()
	self.LU:GetSetting()
end

---draw gui
function gui:Draw()
	if ML then
		self.EB:loop()
		self.LU:loop()
		UI.tp:StartFrame()
	end
end

return gui