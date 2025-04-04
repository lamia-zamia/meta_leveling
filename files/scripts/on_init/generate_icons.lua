local max_categorized_spells = 16
local random_random_spells_iterations = 4

--- Generates a table of N unique random numbers within a specified range.
--- @param n number The number of unique random numbers to generate.
--- @param min number The minimum value of the range.
--- @param max number The maximum value of the range.
--- @return table A table containing N unique random numbers.
local function generate_unique_random_numbers(n, min, max)
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

--- Function to generate layers with random spells from table
--- @param list string[]
--- @return ml_icon_generator_layers?, number
--- @nodiscard
local function generate_spell_icon_layer(list)
	local size = #list
	local n = math.min(size - (size % 2), max_categorized_spells)
	if n > 0 then
		local indexes = generate_unique_random_numbers(n, 1, size)
		--- @type ml_icon_generator_layers
		local icons = {}
		for _, index in ipairs(indexes) do
			icons[#icons + 1] = ML.guns.actions_data.icons[list[index]]
		end
		return icons, size
	end
	return nil, 0
end

--- @type ml_icon_generator
local IG = dofile_once("mods/meta_leveling/files/scripts/classes/private/icon_generator.lua")

--- Spell border icons
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

--- Spell levels and suffixes for xml
local spell_suffixes = {
	["low"] = "_low.xml",
	["mid"] = "_mid.xml",
	["high"] = "_high.xml",
}

--- Icons to generate, manually specified
--- @type ml_icon_generator_table[]
local icons_to_generate = {
	{
		path = "mods/meta_leveling/vfs/rewards/spell_teleport_bolt.png",
		layers = {
			{
				IG.spell_background.projectile,
			},
			{
				"data/ui_gfx/gun_actions/teleport_projectile_short.png",
			},
		},
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_nolla.png",
		layers = {
			{
				IG.spell_background.modifier,
			},
			{
				"data/ui_gfx/gun_actions/nolla.png",
			},
		},
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_add_mana.png",
		layers = {
			{
				IG.spell_background.modifier,
			},
			{
				"data/ui_gfx/gun_actions/mana.png",
			},
		},
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_blood_magic.png",
		layers = {
			{
				IG.spell_background.utility,
			},
			{
				"data/ui_gfx/gun_actions/blood_magic.png",
			},
		},
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_cov.png",
		layers = {
			{
				IG.spell_background.static_projectile,
			},
			{
				"data/ui_gfx/gun_actions/regeneration_field.png",
			},
		},
	},
	{
		path = "mods/meta_leveling/vfs/rewards/spell_heal_spells.xml",
		layers = {
			{
				IG.spell_background.projectile,
			},
			{
				"data/ui_gfx/gun_actions/heal_bullet.png",
				"data/ui_gfx/gun_actions/antiheal.png",
			},
		},
	},
	{
		path = "mods/meta_leveling/vfs/gfx/rewards/spell_drills.xml",
		layers = {
			{
				IG.spell_background.projectile,
			},
			{
				"data/ui_gfx/gun_actions/digger.png",
				"data/ui_gfx/gun_actions/powerdigger.png",
			},
		},
	},
}

--- Categorized spells to generate
local random_categorized_spells = {
	[0] = "mods/meta_leveling/vfs/gfx/rewards/random_projectile",
	[1] = "mods/meta_leveling/vfs/gfx/rewards/random_static_projectile",
	[2] = "mods/meta_leveling/vfs/gfx/rewards/random_modifier",
	[3] = "mods/meta_leveling/vfs/gfx/rewards/random_multicast",
	[4] = "mods/meta_leveling/vfs/gfx/rewards/random_material_spell",
	[5] = "mods/meta_leveling/vfs/gfx/rewards/random_other",
	[6] = "mods/meta_leveling/vfs/gfx/rewards/random_utility",
	[7] = "mods/meta_leveling/vfs/gfx/rewards/random_passive_spell",
}

local special_category_spells = {
	{
		list = ML.guns.trigger_hit_world,
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_hit_world.xml",
		type = 0,
	},
	{
		list = ML.guns.trigger_death,
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_death.xml",
		type = 0,
	},
	{
		list = ML.guns.trigger_timer,
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell_trigger_timer.xml",
		type = 0,
	},
	{
		list = ML.guns.glimmers,
		path = "mods/meta_leveling/vfs/gfx/rewards/spell_random_glimmer.xml",
		type = 2,
		speed = 0.225,
	},
}

SetRandomSeed(1, 1)

--- Generate spell icons for categorized spell rewards
for category = 0, #random_categorized_spells do --- for each category
	for level, suffix in pairs(spell_suffixes) do
		local icons, size = generate_spell_icon_layer(ML.guns.actions_data.types[category][level])
		if not icons then goto continue end
		local layers = {
			{ borders[category] },
			icons,
		}
		icons_to_generate[#icons_to_generate + 1] = {
			path = random_categorized_spells[category] .. suffix,
			layers = layers,
			speed = math.max((1.8 / size), 0.45),
		}
		::continue::
	end
end

--- Generate random random spells
for level, suffix in pairs(spell_suffixes) do
	--- @type ml_icon_generator_layers
	local random_spell_layers = { [1] = {}, [2] = {} }
	for _ = 1, random_random_spells_iterations do
		for type = 0, #borders do
			local data = ML.guns.actions_data.types[type][level]
			random_spell_layers[1][#random_spell_layers[1] + 1] = borders[type]
			random_spell_layers[2][#random_spell_layers[2] + 1] = ML.guns.actions_data.icons[data[Random(1, #data)]]
		end
	end
	icons_to_generate[#icons_to_generate + 1] = {
		path = "mods/meta_leveling/vfs/gfx/rewards/random_spell" .. suffix,
		layers = random_spell_layers,
		speed = 0.225,
	}
end

for i = 1, #special_category_spells do
	local icons, size = generate_spell_icon_layer(special_category_spells[i].list)
	if not icons then goto continue end
	local layers = {
		{ borders[special_category_spells[i].type] },
		icons,
	}
	icons_to_generate[#icons_to_generate + 1] = {
		path = special_category_spells[i].path,
		layers = layers,
		speed = special_category_spells[i].speed or math.max((1.8 / size), 0.45),
	}
	::continue::
end

for _, icon in ipairs(icons_to_generate) do
	IG:generate(icon)
end

local potions_to_generate = {
	["mods/meta_leveling/vfs/gfx/rewards/potion_hp_regen.png"] = 0x80a1f18c,
	["mods/meta_leveling/vfs/gfx/rewards/potion_urine.png"] = 0x33FFEE00,
	["mods/meta_leveling/vfs/gfx/rewards/potion_milk.png"] = 0xfffff6e5,
	["mods/meta_leveling/vfs/gfx/rewards/potion_lava.png"] = 0xffff6000,
	["mods/meta_leveling/vfs/gfx/rewards/potion_water.png"] = 0xA0376259,
	["mods/meta_leveling/vfs/gfx/rewards/potion_blood.png"] = 0xaa830000,
	["mods/meta_leveling/vfs/gfx/rewards/potion_magic_liquid_unstable_teleportation.png"] = 0x8000BEE4,
	["mods/meta_leveling/vfs/gfx/rewards/potion_magic_liquid_polymorph.png"] = 0x80f18beb,
	["mods/meta_leveling/vfs/gfx/rewards/potion_magic_liquid_protection_all.png"] = 0x80df9828,
}

local random_potion = { --- @type ml_icon_generator_table
	path = "mods/meta_leveling/vfs/gfx/rewards/random_potion.xml",
	layers = { [1] = {} },
	speed = 0.225,
}

for path, argb in pairs(potions_to_generate) do
	IG:make_potion(path, argb)
	random_potion.layers[1][#random_potion.layers[1] + 1] = path
end

IG:generate(random_potion)
