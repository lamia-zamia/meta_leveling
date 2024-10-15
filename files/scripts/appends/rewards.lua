local files = {
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards.lua",
	"mods/meta_leveling/files/scripts/rewards/add_reward_example.lua",
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards_wand.lua",
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards_spell.lua",
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards_perk.lua",
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards_transformations.lua",
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards_pickups.lua",
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards_health.lua",
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards_playerstats.lua",
	"mods/meta_leveling/files/scripts/rewards/level_up_rewards_buff.lua"
}

for _, file in ipairs(files) do
	ModLuaFileAppend("mods/meta_leveling/files/for_modders/rewards_append.lua", file)
end

local integration = {
	bags_of_many = "mods/meta_leveling/files/scripts/rewards/integration_bags_of_many.lua"
}

for mod, file in pairs(integration) do
	if ModIsEnabled(mod) then
		ModLuaFileAppend("mods/meta_leveling/files/for_modders/rewards_append.lua", file)
	end
end
