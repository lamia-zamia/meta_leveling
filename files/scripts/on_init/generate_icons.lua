---@type ml_icon_generator
local IG = dofile_once("mods/meta_leveling/files/scripts/classes/private/icon_generator.lua")

local borders = {
	[0] = IG.spell_background.projectile,
	[1] = IG.spell_background.static_projectile,
	[2] = IG.spell_background.modifier,
	[3] = IG.spell_background.draw_many,
	[4] = IG.spell_background.material,
	[5] = IG.spell_background.other,
	[6] = IG.spell_background.utility,
	[7] = IG.spell_background.passive,
}

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

---Generates a table of N unique random numbers within a specified range.
---@param n number The number of unique random numbers to generate.
---@param min number The minimum value of the range.
---@param max number The maximum value of the range.
---@return table A table containing N unique random numbers.
local function generateUniqueRandomNumbers(n, min, max)
	local numbers, result = {}, {}
	while #result < n do
		local rand = Random(min, max)
		if not numbers[rand] then
			numbers[rand] = true
			result[#result + 1] = rand
		end
	end
	return result
end

local spell_suffixes = {
	["low"] = "_low.xml",
	["mid"] = "_mid.xml",
	["high"] = "_high.xml"
}

local random_categorized_spells = {
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_projectile",
		type = 0
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile",
		type = 1
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_modifier",
		type = 2
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_multicast",
		type = 3
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_material_spell",
		type = 4
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_other",
		type = 5
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_utility",
		type = 6
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/random_passive_spell",
		type = 7
	},
}

SetRandomSeed(1, 1)
for _, category in ipairs(random_categorized_spells) do
	for level, suffix in pairs(spell_suffixes) do
		local data = ML.guns.actions_data.types[category.type][level]
		local size = #data
		local n = math.min(size - (size % 2), 8)
		if n > 0 then
			local indexes = generateUniqueRandomNumbers(n, 1, size)
			---@type ml_icon_generator_layers
			local icons = {}
			for _, index in ipairs(indexes) do
				icons[#icons + 1] = ML.guns.actions_data.icons[data[index]]
			end
			icons_to_generate[#icons_to_generate + 1] = {
				path = category.path .. suffix,
				layers = {
					{
						borders[category.type]
					},
					icons
				},
				speed = math.max((1.8 / n), 0.45)
			}
		end
	end
end

for level, suffix in pairs(spell_suffixes) do
	---@type ml_icon_generator_layers
	local random_spell_layers = {
		[1] = {},
		[2] = {}
	}
	for _ = 1, 2 do
		for type = 0, #borders do
			local data = ML.guns.actions_data.types[type][level]
			random_spell_layers[1][#random_spell_layers[1] + 1] = borders[type]
			random_spell_layers[2][#random_spell_layers[2] + 1] = ML.guns.actions_data.icons[data[Random(1, #data)]]
		end
	end
	icons_to_generate[#icons_to_generate + 1] = {
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell" .. suffix,
		layers = random_spell_layers
	}
end

for _, icon in ipairs(icons_to_generate) do
	IG:generate(icon)
end
