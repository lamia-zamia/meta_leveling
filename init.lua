dofile_once("mods/meta_leveling/files/scripts/appends.lua")
dofile_once("mods/meta_leveling/files/scripts/load_file_into_vfs.lua")
dofile_once("mods/meta_leveling/files/scripts/mod_settings_virtual.lua")

---@type meta_leveling
ML = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling.lua")
---@type ML_gui
local gui = dofile_once("mods/meta_leveling/files/scripts/gui/gui.lua")

function OnWorldInitialized()
	ML.rewards_deck:GatherData()
	ML.rewards:gather_action_info()
end

function OnPlayerSpawned()
	gui:UpdateSettings()
end

function OnWorldPostUpdate()
	ML:UpdateCommonParameters()
	gui:Draw()
end

function OnPausedChanged()
	gui:UpdateSettings()
	if ML.utils:get_mod_setting_boolean("session_exp_close_ui_on_pause") then ML.gui = false end
end
