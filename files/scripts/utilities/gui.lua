---@type UI_class
local UI = dofile_once("mods/meta_leveling/files/scripts/utilities/ui_lib.lua")
---@type experience_bar
local EB = dofile_once("mods/meta_leveling/files/scripts/session_level/experience_bar.lua")
---@type level_ui
local LU = dofile_once("mods/meta_leveling/files/scripts/session_level/level_ui.lua")

---@class ML_gui
---@field private UI UI_class
---@field private EB experience_bar
---@field private LU level_ui
local gui = {
	UI = UI,
	EB = EB,
	LU = LU
}

function gui:UpdateSettings()
	self.UI:UpdateDimensions()
	self.EB:GetSettings()
end

function gui:Draw()
	if ML then
		self.EB:loop()
		self.LU:loop()
		self.UI.tp:StartFrame()
		-- self.UI:DebugDrawGrid()
	end
end

return gui