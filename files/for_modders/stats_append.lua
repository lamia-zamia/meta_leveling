--[[ 
Append you stat file to this file on init

Use ML.stats:add_entries(table) for multiple stats or ML.stat:add_entry(entry) for single stat

Add into your init.lua:
if ModIsEnabled("meta_leveling") then
  ModLuaFileAppend("mods/meta_leveling/files/for_modders/stats_append.lua", "PATH_TO_YOUR_FILE.lua")
end

More about meta progress fields in mods/meta_leveling/files/scripts/classes/private/stats.lua

]]
