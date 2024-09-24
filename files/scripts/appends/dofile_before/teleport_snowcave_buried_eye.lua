local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

---Checks for first time use
function MetaLevelingBuriedEye()
	if GlobalsGetValue("TELEPORT_SNOWCAVE_BURIED_EYE_POS_X", "0") == "0" then
		MLP:QuestCompleted(40)
	end
end