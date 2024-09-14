--[[ 
Append you meta progress file to this file on init, see example at:
mods/meta_leveling/files/scripts/progress/progress_default.lua

Use ML.meta:append_points(progress) for multiple meta items or ML.meta:append_point(point) for single item

Add into your init.lua:
if ModIsEnabled("meta_leveling") then
  ModLuaFileAppend("mods/meta_leveling/files/for_modders/progress_appends.lua", "PATH_TO_YOUR_FILE.lua")
end

More about meta progress fields in mods/meta_leveling/files/scripts/classes/private/meta.lua

]]
