MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
GamePrintImportant_ML_Old = GamePrintImportant

GamePrintImportant = function(title, description, ui_custom_decoration_file)
	local message = GameTextGetTranslatedOrNot("$ml_quest_done")
	local player_id = EntityGetWithTag("player_unit")[1]
	MLP:AddExpGlobal(1000, player_id, message .. ": ")
	GamePrintImportant_ML_Old(title, description, ui_custom_decoration_file or "")
end