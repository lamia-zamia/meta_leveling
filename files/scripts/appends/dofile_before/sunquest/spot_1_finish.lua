local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
local GamePrintImportant_ML_Old = GamePrintImportant

---@param title string
---@param description string
---@param ui_custom_decoration_file string
GamePrintImportant = function(title, description, ui_custom_decoration_file)
	MLP:QuestCompleted(1000)
	GamePrintImportant_ML_Old(title, description, ui_custom_decoration_file or "")
end