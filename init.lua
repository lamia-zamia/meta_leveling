---@type MetaLevelingPublic
MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

---@type meta_leveling
ML = dofile_once("mods/meta_leveling/files/scripts/meta_leveling.lua")

---@type ML_gui
local gui = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui.lua")

dofile_once("mods/meta_leveling/files/scripts/on_init/load_file_into_vfs.lua")
dofile_once("mods/meta_leveling/files/scripts/on_init/appends.lua")

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
end

---?
function OnPlayerSpawned()
	ML:OnSpawn()
	gui:UpdateSettings()
end

---Update settings when paused
function OnPausedChanged()
	ML.level_up_effects:update_settings()
	gui:UpdateSettings()
	if MLP.get:mod_setting_boolean("session_exp_close_ui_on_pause") then ML.gui = false end
end
