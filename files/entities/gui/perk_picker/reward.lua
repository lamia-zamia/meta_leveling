local gui = dofile_once("mods/meta_leveling/files/entities/gui/perk_picker/gui.lua") ---@class ml_perk_picker_gui

local picked = gui:Draw()
if picked then
	local entity = GetUpdatedEntityID()
	GuiDestroy(gui.gui)
	EntityKill(entity)
end
