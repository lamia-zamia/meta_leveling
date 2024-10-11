local meta = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local set_component_old = EntitySetComponentIsEnabled

--- @param entity_id entity_id
--- @param component_id component_id
--- @param is_enabled boolean
function EntitySetComponentIsEnabled(entity_id, component_id, is_enabled)
	meta:QuestCompleted(30)
	set_component_old(entity_id, component_id, is_enabled)
end
