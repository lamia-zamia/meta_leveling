if SessionNumbersGetValue("is_biome_map_initialized") == "0" then
	local is_hardmode_enabled = ModSettingGetNextValue("meta_leveling.hardmode_enabled") or false
	ModSettingSet("meta_leveling.hardmode_enabled", is_hardmode_enabled)
end

local is_hardmode_enabled = ModSettingGet("meta_leveling.hardmode_enabled") or false

if not is_hardmode_enabled then return end

if ModSettingGet("meta_leveling.hardmode_nerf_perks") then
	ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/meta_leveling/files/scripts/hardmode/nerf_perks.lua")
end

if ModSettingGet("meta_leveling.hardmode_nerf_rewards") then
	ModLuaFileAppend("mods/meta_leveling/files/for_modders/rewards_modify.lua", "mods/meta_leveling/files/scripts/hardmode/nerf_rewards.lua")
end
