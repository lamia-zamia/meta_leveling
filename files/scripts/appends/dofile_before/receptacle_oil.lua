local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local EntityKill_ML_Old = EntityKill

---@param entity_id entity_id
EntityKill = function(entity_id)
	MLP:QuestCompleted(5)
	EntityKill_ML_Old(entity_id)
end