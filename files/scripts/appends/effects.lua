local new_effects = {
	{
		id = "META_LEVELING_MORE_EXP",
		ui_name = "$ml_more_experience",
		ui_description = "$ml_more_experience_2x_tp",
		ui_icon = "mods/meta_leveling/files/gfx/more_exp_status.png",
		effect_entity = "mods/meta_leveling/files/entities/effects/more_exp/more_exp.xml",
	},
	{
		id = "META_LEVELING_POLYMORPH_PROTECTION_COOLDOWN",
		ui_name = "$ml_polymorph_immunity_cooldown",
		ui_description = "$ml_polymorph_immunity_cooldown_tp",
		ui_icon = "mods/meta_leveling/files/gfx/poly_protection_cooldown.png",
		effect_entity = "mods/meta_leveling/files/entities/effects/poly_protection/poly_protection_cooldown.xml",
	},
}

local game_effects_count = #status_effects
for i = 1, #new_effects do
	status_effects[game_effects_count + i] = new_effects[i]
end
