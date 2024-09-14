local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local EntitySetComponentIsEnabled_ML_Old = EntitySetComponentIsEnabled

---@param entity_id entity_id
---@param component_id component_id
---@param is_enabled boolean
EntitySetComponentIsEnabled = function(entity_id, component_id, is_enabled)
	MLP:QuestCompleted(30)
	EntitySetComponentIsEnabled_ML_Old(entity_id, component_id, is_enabled)
end