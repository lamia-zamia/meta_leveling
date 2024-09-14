local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local GameAddFlagRun_ML_Old = GameAddFlagRun

local values = {
	["ocarina_secret_00"] = 20,
	["ocarina_secret_01"] = 20,
	["ocarina_secret_02"] = 20,
	["alchemy_ocarina"] = 10,
	["kantele_secret_00"] = 20,
	["kantele_secret_01"] = 20,
	["kantele_secret_02"] = 20,
	["alchemy_kantele"] = 10,
}

---@param key string
GameAddFlagRun = function(key)
	local exp = values[key] or 10
	MLP:QuestCompleted(exp)
	GameAddFlagRun_ML_Old(key)
end
