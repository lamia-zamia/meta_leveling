local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local GamePrintImportant_old_MP = GamePrintImportant

---@param ... any
GamePrintImportant = function(...)
	MLP:QuestCompleted(500)
	GamePrintImportant_old_MP(...)
end
