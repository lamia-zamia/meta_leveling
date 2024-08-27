---@type experience_bar
local EB = dofile_once("mods/meta_leveling/files/scripts/gui/experience_bar.lua")
---@type level_ui
local LU = dofile_once("mods/meta_leveling/files/scripts/gui/level_ui.lua")

---@class ML_gui
---@field private EB experience_bar
---@field private LU level_ui
local gui = {
	EB = EB,
	LU = LU
}

---update settings
function gui:UpdateSettings()
	self.EB:GetSettings()
	self.LU:GetSetting()
end

---draw gui
function gui:Draw()
	if ML then
		self.EB:loop()
		self.LU:loop()
	end
end

return gui