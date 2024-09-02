ML = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling.lua")
GamePrintImportant_ML_Old = GamePrintImportant

GamePrintImportant = function(title, description, ui_custom_decoration_file)
	local message = GameTextGetTranslatedOrNot("$ml_quest_done")
	ML:AddExpGlobal(10000, ML.player:get_id(), message .. ": ")
	GamePrintImportant_ML_Old(title, description, ui_custom_decoration_file or "")
	ML.meta:modify_current_currency(10)
end