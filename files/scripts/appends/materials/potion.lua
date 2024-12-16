local new_materials = {
	{
		material = "meta_leveling_magic_liquid_more_exp",
		cost = 500,
	},
}

local materials_magic_count = #materials_magic
for i = 1, #new_materials do
	materials_magic[materials_magic_count + i] = new_materials[i]
end
