local meta = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local music_old = GameTriggerMusicFadeOutAndDequeueAll

--- @param relative_fade_speed number
function GameTriggerMusicFadeOutAndDequeueAll(relative_fade_speed)
	meta:QuestCompleted(50)
	music_old(relative_fade_speed)
end
