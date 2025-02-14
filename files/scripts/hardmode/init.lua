--- Exit from this file if hardmode is not enabled
if not ModSettingGet("meta_leveling.hardmode_enabled") then return end

local sandbox = dofile_once("mods/meta_leveling/files/scripts/classes/private/sandbox.lua") --- @type ML_sandbox

if ModSettingGet("meta_leveling.hardmode_nerf_perks") then
	ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/meta_leveling/files/scripts/hardmode/nerf_perks.lua")

	sandbox:start_sandbox()
	dofile("data/scripts/perks/perk_list.lua")
	dofile("mods/meta_leveling/files/scripts/hardmode/nerf_perks_update_translation.lua")
	sandbox:end_sandbox()
end

if ModSettingGet("meta_leveling.hardmode_nerf_rewards") then
	ModLuaFileAppend("mods/meta_leveling/files/for_modders/rewards_modify.lua", "mods/meta_leveling/files/scripts/hardmode/nerf_rewards.lua")
end

if true then
	ModLuaFileAppend(
		"mods/meta_leveling/files/scripts/compatibility/experience_custom.lua",
		"mods/meta_leveling/files/scripts/hardmode/exp_amount_nerf.lua"
	)
end
