dofile_once("mods/meta_leveling/files/scripts/appends/append_translations.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/rewards.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/strmanip_append_dofile_before.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/strmanip_insert_before_line.lua")
dofile_once("mods/meta_leveling/files/scripts/appends/materials/append.lua")

--- Progress
ModLuaFileAppend("mods/meta_leveling/files/for_modders/progress_appends.lua", "mods/meta_leveling/files/scripts/progress/progress_default.lua")

ModLuaFileAppend("mods/component-explorer/menu_extensions.lua", "mods/meta_leveling/files/scripts/appends/component_explorer.lua")

ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/meta_leveling/files/scripts/appends/effects.lua")
ModLuaFileAppend("data/scripts/streaming_integration/event_list.lua", "mods/meta_leveling/files/scripts/appends/twitch/event_list.lua")
