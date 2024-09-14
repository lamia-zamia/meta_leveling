local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local CreateItemActionEntity_ML_Old = CreateItemActionEntity

local values = {
	["AIR_BULLET"] = 100,
	["DIVIDE_10"] = 1000,
	["BOMB_HOLY_GIGA"] = 3000,
	["NUKE_GIGA"] = 3000,
}

---@param action_id string
---@param ... any
CreateItemActionEntity = function(action_id, ...)
	local exp = values[action_id] or 10
	MLP:QuestCompleted(exp)
	CreateItemActionEntity_ML_Old(action_id, ...)
end
