dofile_once("mods/meta_leveling/files/scripts/appends/append_translations.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/rewards.lua")

local manip = dofile_once("mods/meta_leveling/files/scripts/utilities/stringmanip.lua")

manip.replace_by_file("data/scripts/items/drop_money.lua",
	"function death%( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items %)",
	"mods/meta_leveling/files/scripts/appends/append_to_death_script.txt")