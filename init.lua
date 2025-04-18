---@type MetaLevelingPublic
MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

---@type meta_leveling
ML = dofile_once("mods/meta_leveling/files/scripts/meta_leveling.lua")

---@type ML_gui
local gui = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui/gui.lua")

dofile_once("mods/meta_leveling/files/scripts/on_init/load_file_into_vfs.lua")

---On mod init
function OnModInit()
	dofile_once("mods/meta_leveling/files/scripts/hardmode/init.lua")
	dofile_once("mods/meta_leveling/files/scripts/on_init/appends.lua")
end

---After OnModPostInit
function OnMagicNumbersAndWorldSeedInitialized()
	ML:OnMagicNumbersAndWorldSeedInitialized()
end

---Idk why it's called before initialized
function OnWorldPostUpdate()
	ML:UpdateCommonParameters()
	gui:Draw()
end

---World actually loaded
function OnWorldInitialized()
	ML:StartUp()
	gui:UpdateSettings()
	gui:Init()
end

---?
function OnPlayerSpawned()
	ML:OnSpawn()
end

---Update settings when paused
---@param is_paused boolean
function OnPausedChanged(is_paused)
	if not is_paused then return end
	ML:UpdateSettings()
	gui:UpdateSettings()
	if MLP.get:mod_setting_boolean("session_exp_close_ui_on_pause") then ML.gui = false end
end
