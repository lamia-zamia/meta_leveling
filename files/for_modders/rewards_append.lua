--[[ 
Append you rewards file to this file on init, see example at:
mods/meta_leveling/files/scripts/rewards/add_reward_example.lua

Use ML.rewards_deck:add_rewards(rewards) for multiple rewards or ML.rewards_deck:add_reward(reward) for single rewards

You can pass an additional string variable and it will be shown in progress menu:
It also can be a translate string ("$greatestme")
ML.rewards_deck:add_rewards(rewards, "greatest me")

Add into your init.lua:
if ModIsEnabled("meta_leveling") then
  ModLuaFileAppend("mods/meta_leveling/files/for_modders/rewards_append.lua", "PATH_TO_YOUR_FILE.lua")
end

More about reward fields in mods/meta_leveling/files/scripts/classes/private/rewards.lua

]]
