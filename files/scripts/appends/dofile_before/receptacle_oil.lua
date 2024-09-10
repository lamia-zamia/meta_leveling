local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local EntityKill_ML_Old = EntityKill

---@param entity_id entity_id
EntityKill = function(entity_id)
	local message = GameTextGetTranslatedOrNot("$ml_quest_done")
	local player_id = EntityGetWithTag("player_unit")[1]
	MLP:AddExpGlobal(5, player_id, message .. ": ")
	EntityKill_ML_Old(entity_id)
end