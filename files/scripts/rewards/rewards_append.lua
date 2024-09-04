--[[ 
Append you rewards file to this file on init, see example at:
mods/meta_leveling/files/scripts/rewards/add_reward_example.lua

Add into your init.lua:
if ModIsEnabled("meta_leveling") then
  ModLuaFileAppend("mods/meta_leveling/files/scripts/rewards/rewards_append.lua", "mods/meta_leveling/files/scripts/rewards/add_reward_example.lua")
end

]]
