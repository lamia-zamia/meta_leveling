---@class ml_sound
---@field bank sound_banks
---@field event string

---@class sound_list
---@field [string] ml_sound

---@enum sound_banks
local sound_banks = {
	event_cues = "data/audio/Desktop/event_cues.bank",
	ui = "data/audio/Desktop/ui.bank",
}

---@class ml_const
---@field sounds sound_list
local const = {
	sound_banks = sound_banks,
	sounds = {
		heart = {
			bank = sound_banks.event_cues,
			event = "event_cues/heart/create"
		},
		chest = {
			bank = sound_banks.event_cues,
			event = "event_cues/chest/create"
		},
		click = {
			bank = sound_banks.ui,
			event = "ui/button_click"
		},
		refresh = {
			bank = sound_banks.event_cues,
			event = "event_cues/spell_refresh/create"
		},
		shop_item = {
			bank = sound_banks.event_cues,
			event = "event_cues/shop_item/create"
		},
		perk = {
			bank = sound_banks.event_cues,
			event = "event_cues/perk/create"
		}
	},
	files = {
		shot_damage = "mods/meta_leveling/files/scripts/attach_scripts/shot_damage.lua",
		mana_regen = "mods/meta_leveling/files/scripts/attach_scripts/increased_mana_regen.lua"
	},
	flags = {
		leveling_up = "META_LEVELING_LEVELING_UP",
		fx_played = "META_LEVELING_FX_PLAYED"
	}
}


return const