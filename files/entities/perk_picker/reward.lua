local gui = dofile_once("mods/meta_leveling/files/entities/perk_picker/gui.lua")

local entity = GetUpdatedEntityID()

local picked = gui:Draw()
if picked then
	GuiDestroy(gui.gui)
	EntityKill(entity)
end
