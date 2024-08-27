---@type ml_icon_generator
local IG = dofile_once("mods/meta_leveling/files/scripts/utilities/classes/icon_generator.lua")

---@type ml_icon_generator_table[]
local icons_to_generate = {
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_hit_world.xml",
		layers = {
			{
				IG.spell_background.projectile
			},
			{
				"data/ui_gfx/gun_actions/light_bullet_trigger.png",
				"data/ui_gfx/gun_actions/grenade_trigger.png",
				"data/ui_gfx/gun_actions/bubbleshot_trigger.png",
				"data/ui_gfx/gun_actions/slow_bullet_trigger.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_death.xml",
		layers = {
			{
				IG.spell_background.projectile
			},
			{
				"data/ui_gfx/gun_actions/summon_hollow_egg.png",
				"data/ui_gfx/gun_actions/pipe_bomb_death_trigger.png",
				"data/ui_gfx/gun_actions/mine_death_trigger.png",
				"data/ui_gfx/gun_actions/black_hole_timer.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_timer.xml",
		layers = {
			{
				IG.spell_background.projectile
			},
			{
				"data/ui_gfx/gun_actions/light_bullet_timer.png",
				"data/ui_gfx/gun_actions/luminous_drill_timer.png",
				"data/ui_gfx/gun_actions/spitter_timer.png",
				"data/ui_gfx/gun_actions/bouncy_orb_timer.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell.xml",
		layers = {
			{
				IG.spell_background.projectile,
				IG.spell_background.static_projectile,
				IG.spell_background.other,
				IG.spell_background.passive,
				IG.spell_background.material,
				IG.spell_background.draw_many,
				IG.spell_background.modifier,
				IG.spell_background.utility
			},
			{
				"data/ui_gfx/gun_actions/light_bullet.png",
				"data/ui_gfx/gun_actions/purple_explosion_field.png",
				"data/ui_gfx/gun_actions/zeta.png",
				"data/ui_gfx/gun_actions/torch.png",
				"data/ui_gfx/gun_actions/material_oil.png",
				"data/ui_gfx/gun_actions/burst_2.png",
				"data/ui_gfx/gun_actions/light.png",
				"data/ui_gfx/gun_actions/long_distance_cast.png"
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_projectile.xml",
		layers = {
			{
				IG.spell_background.projectile
			},
			{
				"data/ui_gfx/gun_actions/light_bullet.png",
				"data/ui_gfx/gun_actions/bubbleshot.png",
				"data/ui_gfx/gun_actions/buckshot.png",
				"data/ui_gfx/gun_actions/disc_bullet.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile.xml",
		layers = {
			{
				IG.spell_background.static_projectile
			},
			{
				"data/ui_gfx/gun_actions/purple_explosion_field.png",
				"data/ui_gfx/gun_actions/delayed_spell.png",
				"data/ui_gfx/gun_actions/cloud_water.png",
				"data/ui_gfx/gun_actions/teleportation_field.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_other.xml",
		layers = {
			{
				IG.spell_background.other
			},
			{
				"data/ui_gfx/gun_actions/zeta.png",
				"data/ui_gfx/gun_actions/trigger.png",
				"data/ui_gfx/gun_actions/divide_2.png",
				"data/ui_gfx/gun_actions/duplicate.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_passive_spell.xml",
		layers = {
			{
				IG.spell_background.passive
			},
			{
				"data/ui_gfx/gun_actions/torch.png",
				"data/ui_gfx/gun_actions/torch_electric.png",
				"data/ui_gfx/gun_actions/energy_shield.png",
				"data/ui_gfx/gun_actions/tiny_ghost.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_material_spell.xml",
		layers = {
			{
				IG.spell_background.material
			},
			{
				"data/ui_gfx/gun_actions/material_oil.png",
				"data/ui_gfx/gun_actions/material_blood.png",
				"data/ui_gfx/gun_actions/material_water.png",
				"data/ui_gfx/gun_actions/material_cement.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_multicast.xml",
		layers = {
			{
				IG.spell_background.draw_many
			},
			{
				"data/ui_gfx/gun_actions/burst_2.png",
				"data/ui_gfx/gun_actions/circle_shape.png",
				"data/ui_gfx/gun_actions/scatter_3.png",
				"data/ui_gfx/gun_actions/scatter_4.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_modifier.xml",
		layers = {
			{
				IG.spell_background.modifier
			},
			{
				"data/ui_gfx/gun_actions/light.png",
				"data/ui_gfx/gun_actions/mana.png",
				"data/ui_gfx/gun_actions/freeze.png",
				"data/ui_gfx/gun_actions/horizontal_arc.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_utility.xml",
		layers = {
			{
				IG.spell_background.utility
			},
			{
				"data/ui_gfx/gun_actions/long_distance_cast.png",
				"data/ui_gfx/gun_actions/i_shot.png",
				"data/ui_gfx/gun_actions/reset.png",
				"data/ui_gfx/gun_actions/caster_cast.png",
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_teleport_bolt.png",
		layers = {
			{
				IG.spell_background.projectile
			},
			{
				"data/ui_gfx/gun_actions/teleport_projectile_short.png"
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_nolla.png",
		layers = {
			{
				IG.spell_background.modifier
			},
			{
				"data/ui_gfx/gun_actions/nolla.png"
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_add_mana.png",
		layers = {
			{
				IG.spell_background.modifier
			},
			{
				"data/ui_gfx/gun_actions/mana.png"
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_blood_magic.png",
		layers = {
			{
				IG.spell_background.utility
			},
			{
				"data/ui_gfx/gun_actions/blood_magic.png"
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_cov.png",
		layers = {
			{
				IG.spell_background.static_projectile
			},
			{
				"data/ui_gfx/gun_actions/regeneration_field.png"
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_heal_spells.xml",
		layers = {
			{
				IG.spell_background.projectile
			},
			{
				"data/ui_gfx/gun_actions/heal_bullet.png",
				"data/ui_gfx/gun_actions/antiheal.png"
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/spell_drills.xml",
		layers = {
			{
				IG.spell_background.projectile
			},
			{
				"data/ui_gfx/gun_actions/digger.png",
				"data/ui_gfx/gun_actions/powerdigger.png"
			}
		}
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/spell_random_glimmer.xml",
		layers = {
			{
				IG.spell_background.modifier
			},
			{
				"data/ui_gfx/gun_actions/colour_red.png",
				"data/ui_gfx/gun_actions/colour_orange.png",
				"data/ui_gfx/gun_actions/colour_green.png",
				"data/ui_gfx/gun_actions/colour_yellow.png",
				"data/ui_gfx/gun_actions/colour_purple.png",
				"data/ui_gfx/gun_actions/colour_blue.png",
				"data/ui_gfx/gun_actions/colour_rainbow.png",
				"data/ui_gfx/gun_actions/colour_invis.png"
			}
		}
	},
}

for _, icon in ipairs(icons_to_generate) do
	IG:generate(icon)
end