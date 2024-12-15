local author = "Meta Leveling"
local game_effects = dofile_once("mods/meta_leveling/files/scripts/classes/private/gameEffect_parser.lua") --- @type ML_gameEffect_parser

local new_events = {
	{
		id = "META_LEVELING_MORE_EXPERIENCE",
		ui_name = "$ml_more_experience",
		ui_description = "$ml_more_experience_2x_tp",
		ui_icon = "data/ui_gfx/streaming_event_icons/health_plus.png",
		ui_author = author,
		weight = 1.0,
		kind = STREAMING_EVENT_GOOD,
		action = function(event)
			game_effects:apply_status_to_player("META_LEVELING_MORE_EXP", 300 * 60)
		end,
	},
}

local streaming_events_count = #streaming_events
for i = 1, #new_events do
	streaming_events[streaming_events_count + i] = new_events[i]
end
