local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local GameTriggerMusicFadeOutAndDequeueAll_ML_old = GameTriggerMusicFadeOutAndDequeueAll

---@param relative_fade_speed number
GameTriggerMusicFadeOutAndDequeueAll = function(relative_fade_speed)
	MLP:QuestCompleted(50)
	GameTriggerMusicFadeOutAndDequeueAll_ML_old(relative_fade_speed)
end