dofile_once("mods/meta_leveling/files/scripts/appends.lua")
dofile_once("mods/meta_leveling/files/scripts/load_file_into_vfs.lua")
dofile_once("mods/meta_leveling/files/scripts/mod_settings_virtual.lua")

---@type meta_leveling
ML = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling.lua")
---@type ML_gui
local gui = dofile_once("mods/meta_leveling/files/scripts/utilities/gui.lua")

function OnWorldInitialized()
	ML.rewards:GatherData()
end

function OnPlayerSpawned()
	gui:UpdateSettings()
end

function OnWorldPostUpdate()
	gui:Draw()
end

function OnPausedChanged()
	gui:UpdateSettings()
end
