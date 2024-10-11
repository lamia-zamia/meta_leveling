local game_on_completed = GameOnCompleted

function GameOnCompleted() --- @diagnostic disable-line: missing-global-doc
	ModSettingSet("meta_leveling.streak_win", true)
	game_on_completed()
end
