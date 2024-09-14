dofile_once("mods/meta_leveling/files/scripts/appends/append_translations.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/rewards.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/strmanip_append_dofile_before.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/strmanip_insert_before_line.lua")

--- Progress
ModLuaFileAppend("mods/meta_leveling/files/for_modders/progress_appends.lua",
	"mods/meta_leveling/files/scripts/progress/progress_default.lua")
