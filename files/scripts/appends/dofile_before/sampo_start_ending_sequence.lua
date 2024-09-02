local function ml_add_points_on_win()
	local ML = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling.lua")
	local newgame_n = tonumber(SessionNumbersGetValue("NEW_GAME_PLUS_COUNT"))
	local orb_count = GameGetOrbCountThisRun()
	local exponent = orb_count + newgame_n ^ 0.5
	local points = math.floor(1.15 ^ exponent)
	ML.meta:modify_current_currency(points)
end

ml_add_points_on_win()