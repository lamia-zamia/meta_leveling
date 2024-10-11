local meta = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local entity_kill = EntityKill

--- @param entity_id entity_id
function EntityKill(entity_id)
	meta:QuestCompleted(10)
	entity_kill(entity_id)
end
