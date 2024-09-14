local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
local EntityKill_old_MP = EntityKill
local rewards = {
	["data/entities/items/wand_leukaluu.xml"] = 100,
	["data/entities/items/pickup/summon_portal_broken.xml"] = 40,
	["data/entities/items/pickup/broken_wand.xml"] = 30,
}

---@param entity_id entity_id
EntityKill = function(entity_id)
	local file = EntityGetFilename(entity_id)
	local exp = rewards[file] or 20
	MLP:QuestCompleted(exp)
	EntityKill_old_MP(entity_id)
end