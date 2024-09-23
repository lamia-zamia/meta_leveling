
local GameOnCompleted_old = GameOnCompleted

GameOnCompleted = function() ---@diagnostic disable-line: missing-global-doc
	ModSettingSet("meta_leveling.streak_win", true)
	GameOnCompleted_old()
end