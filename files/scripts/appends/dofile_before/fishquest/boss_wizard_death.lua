local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local CreateItemActionEntity_ML_Old = CreateItemActionEntity

---@param action_id string
---@param ... any
CreateItemActionEntity = function(action_id, ...)
	if action_id == "HOMING_WAND" then
		MLP:QuestCompleted(2000)
	end
	CreateItemActionEntity_ML_Old(action_id, ...)
end
