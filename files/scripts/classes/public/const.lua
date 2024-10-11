--- @class ml_sound
--- @field bank sound_banks
--- @field event string

--- @class sound_list
--- @field [string] ml_sound

--- @enum sound_banks
local sound_banks = {
	event_cues = "data/audio/Desktop/event_cues.bank",
	ui = "data/audio/Desktop/ui.bank",
}

--- constant values
--- @class ml_const
--- @field sounds sound_list
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
		dead = "META_LEVELING_GAME_END"
	},
	player_tags = {
		"player_unit", "player_projectile", "projectile_player"
	},
	globals_prefix = "META_LEVELING_",
	globals = {                                                -- globals name used by this mod
		current_level = "CURRENT_LEVEL",                       -- current level, default 1
		exp_on_levelup = "EXP_ON_LEVELUP",                     -- exp on levelup, required to calculate negative exp
		fx_played = "EXP_FX_PLAYER",                           -- level for which exp fx was played
		meta_point_acquired = "META_POINT_ACQUIRED",           -- how many meta points were acquired in this run
		draw_amount = "DRAW_AMOUNT",                           -- how many extra options, default 0
		draw_index = "DRAW_INDEX",                             -- current index in reward deck
		reroll_count = "REROLL_COUNT",                         -- current available reroll count
		current_exp = "CURRENT_EXP",                           -- current experience
		exp_multiplier = "EXP_MULTIPLIER",                     -- current exp multiplier from rewards in percentage
		exp_const = "EXP_CONST",                               -- current amount of exp to constantly add, integer
		exp_betray = "EXP_MULTIPLIER_BETRAY",                  -- current exp multiplier from betray in percentage, default 0
		exp_trick = "EXP_MULTIPLIER_TRICK",                    -- current exp multiplier for trick kills, default 0.5
		permanent_concentrated_mana = "PERMANENT_CONCENTRATED_MANA", -- amount of permanent_concentrated_mana in percentage
		drill_destructibility = "DRILL_DESTRUCTIBILITY_INCREASE", -- stronger drills
		drill_damage_increase = "DRILL_DAMAGE_INCREASE",       -- more drill damage
		crit_chance_increase = "CRIT_CHANCE_INCREASE",         -- crit chance, percentage
		elemental_damage_increase = "ELEMENTAL_DAMAGE_INCREASE", -- elemental damage increase, const + percentage
		projectile_damage_increase = "PROJECTILE_DAMAGE_INCREASE", -- more projectile damage, percentage
		projectile_explosion_radius = "PROJECTILE_EXPLOSION_RADIUS", -- more explosion radius
		projectile_explosion_damage = "PROJECTILE_EXPLOSION_DAMAGE", -- more explosion damage
	}
}

return const
