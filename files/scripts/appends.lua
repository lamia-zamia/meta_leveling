dofile_once("mods/meta_leveling/files/scripts/appends/append_translations.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/rewards.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/mountain_altar.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/strmanip_append_dofile_before.lua")

--- Progress
ModLuaFileAppend("mods/meta_leveling/files/scripts/progress/progress_appends.lua",
	"mods/meta_leveling/files/scripts/progress/progress_default.lua")
