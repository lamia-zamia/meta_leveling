local gui = dofile_once("mods/meta_leveling/files/entities/gui/tinkering/gui.lua") ---@class ml_temp_tinkering_gui

local function remove()
	local entity = GetUpdatedEntityID()
	GuiDestroy(gui.gui)
	EntityKill(entity)
end

local picked = gui:Draw()
if picked then remove() end
