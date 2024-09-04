---@type MetaLevelingPublic
MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

---@type meta_leveling
ML = dofile_once("mods/meta_leveling/files/scripts/meta_leveling.lua")

---@type ML_gui
local gui = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui.lua")

dofile_once("mods/meta_leveling/files/scripts/load_file_into_vfs.lua")
dofile_once("mods/meta_leveling/files/scripts/appends.lua")

function OnMagicNumbersAndWorldSeedInitialized()
	dofile_once("mods/meta_leveling/files/scripts/generate_icons.lua")
end

function OnWorldPostUpdate()
	ML:UpdateCommonParameters()
	gui:Draw()
end

function OnWorldInitialized()
	ML:StartUp()
end

function OnPlayerSpawned()
	ML:OnSpawn()
	gui:UpdateSettings()
end

function OnPausedChanged()
	gui:UpdateSettings()
	if MLP.get:mod_setting_boolean("session_exp_close_ui_on_pause") then ML.gui = false end
end
