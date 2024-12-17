--[[ 
Append you meta progress file to this file on init, see example at:
mods/meta_leveling/files/scripts/progress/progress_default.lua

Use meta:append_points(progress) for multiple meta items or meta:append_point(point) for single item

you can pass a string as a second parameter to add credits to yourself, e.g. meta:append_points(progress, "great me")

Don't forget to do dofile:
local meta = dofile_once("mods/meta_leveling/files/scripts/classes/private/meta.lua") --- @type ml_meta

Add into your init.lua:
if ModIsEnabled("meta_leveling") then
  ModLuaFileAppend("mods/meta_leveling/files/for_modders/progress_appends.lua", "PATH_TO_YOUR_FILE.lua")
end

More about meta progress fields in mods/meta_leveling/files/scripts/classes/private/meta.lua

]]
