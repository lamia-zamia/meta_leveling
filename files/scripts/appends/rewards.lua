local files = {
	"mods/meta_leveling/files/scripts/session_level/rewards/add_reward_example.lua",
	"mods/meta_leveling/files/scripts/session_level/rewards/level_up_rewards_wand.lua",
	"mods/meta_leveling/files/scripts/session_level/rewards/level_up_rewards_spell.lua",
	"mods/meta_leveling/files/scripts/session_level/rewards/level_up_rewards_perk.lua",
	"mods/meta_leveling/files/scripts/session_level/rewards/level_up_rewards_transformations.lua",
	"mods/meta_leveling/files/scripts/session_level/rewards/level_up_rewards_pickups.lua",
	"mods/meta_leveling/files/scripts/session_level/rewards/level_up_rewards_health.lua"
}

for _, file in ipairs(files) do
	ModLuaFileAppend("mods/meta_leveling/files/scripts/session_level/rewards/rewards_append.lua", file)
end