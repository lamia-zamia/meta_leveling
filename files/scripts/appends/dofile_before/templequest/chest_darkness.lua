local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local AddFlagPersistent_ML_Old = AddFlagPersistent

---@param key string
AddFlagPersistent = function(key)
	MLP:QuestCompleted(100)
	AddFlagPersistent_ML_Old(key)
end
