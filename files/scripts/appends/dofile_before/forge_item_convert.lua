local meta = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
local entity_kill_old = EntityKill
local rewards = {
	["data/entities/items/wand_leukaluu.xml"] = 100,
	["data/entities/items/pickup/summon_portal_broken.xml"] = 40,
	["data/entities/items/pickup/broken_wand.xml"] = 30,
}

--- @param entity_id entity_id
function EntityKill(entity_id)
	local file = EntityGetFilename(entity_id)
	local exp = rewards[file] or 20
	meta:QuestCompleted(exp)
	entity_kill_old(entity_id)
end
