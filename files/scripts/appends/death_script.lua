local nxml = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/nxml.lua")
local bases = dofile_once("mods/meta_leveling/files/scripts/compatibility/killable_entities.lua")
local on_death = nxml.new_element("LuaComponent", {
	execute_every_n_frame= "-1",
	script_death = "mods/meta_leveling/files/scripts/attach_scripts/enemy_on_death.lua",
	remove_after_executed="1"
})

for _, file in ipairs(bases) do
	local xml = nxml.parse(ModTextFileGetContent(file))
	xml:add_child(on_death)
	ModTextFileSetContent(file, tostring(xml))
end