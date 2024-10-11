local meta = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
local print_important = GamePrintImportant

--- @param title string
--- @param description string
--- @param ui_custom_decoration_file string
function GamePrintImportant(title, description, ui_custom_decoration_file)
	meta:QuestCompleted(10000)
	print_important(title, description, ui_custom_decoration_file or "")
	meta.points:add_meta_points(100)
end
