local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local GameAddFlagRun_old_MP = GameAddFlagRun

---@param flag string
GameAddFlagRun = function(flag)
	local exp = flag == "statue_hands_destroyed_3" and 20 or 3
	MLP:QuestCompleted(exp)
	GameAddFlagRun_old_MP(flag)
end
