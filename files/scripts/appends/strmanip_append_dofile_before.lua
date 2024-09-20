---@type StringManip
local SM = dofile_once("mods/meta_leveling/files/scripts/lib/stringmanip.lua")

local append_list = {
	["data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/sampo_start_ending_sequence.lua",
}

local append_list_once = {
	["data/scripts/buildings/sun/spot_1_finish.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/sunquest/spot_1_finish.lua",
	["data/scripts/buildings/sun/spot_2.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/sunquest/spot_1_finish.lua",
	["data/scripts/buildings/sun/spot_3.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/sunquest/spot_1_finish.lua",
	["data/scripts/buildings/sun/spot_4.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/sunquest/spot_4.lua",
	["data/scripts/magic/altar_tablet_magic.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/altar_tablet_magic.lua",
	["data/scripts/buildings/meditation_cube.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/meditation_cube.lua",
	["data/scripts/buildings/receptacle_oil.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/receptacle_oil.lua",
	["data/scripts/perks/perk.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/perk.lua",
	["data/scripts/buildings/oiltank_puzzle_check.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/oiltank_puzzle_check.lua",
	["data/scripts/buildings/receptacle_steam.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/receptacle_steam.lua",
	["data/scripts/buildings/receptacle_water.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/receptacle_water.lua",
	["data/scripts/buildings/swing_puzzle_target.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/swing_puzzle_target.lua",
	["data/scripts/buildings/vault_lab_puzzle_check.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/vault_lab_puzzle_check.lua",
	["data/scripts/buildings/statue_hand_modified.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/handstatuequest/statue_hand_modified.lua",
	["data/scripts/buildings/teleport_snowcave_buried_eye.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/teleport_snowcave_buried_eye.lua",
	["data/scripts/buildings/forge_item_convert.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/forge_item_convert.lua",
	["data/scripts/projectiles/summon_portal_position_check.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/handstatuequest/summon_portal_position_check.lua",
	["data/scripts/buildings/chest_steel.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/handstatuequest/chest_steel.lua",
	["data/entities/animals/boss_wizard/death.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/fishquest/boss_wizard_death.lua",
	["data/scripts/magic/towercheck.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/towercheck.lua",
	["data/entities/animals/boss_alchemist/key_music.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/key_music/key_music.lua",
	["data/scripts/magic/kantele.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/music_notes.lua",
	["data/scripts/magic/ocarina.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/music_notes.lua",
	["data/scripts/buildings/chest_dark.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/key_music/darklightchests.lua",
	["data/scripts/buildings/chest_light.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/key_music/darklightchests.lua",
	["data/biome_impl/static_tile/puzzle_logic_potion_mimics.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/templequest/puzzle_logic_potion_mimics.lua",
	["data/biome_impl/static_tile/chest_darkness.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/templequest/chest_darkness.lua",
	["data/biome_impl/static_tile/puzzle_logic_barren.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/templequest/puzzle_logic_potion_mimics.lua",
	["data/scripts/buildings/hourglass_material_check.lua"] =
	"mods/meta_leveling/files/scripts/appends/dofile_before/hourglass_material_check.lua"
}

for original_file, append_file in pairs(append_list_once) do
	local sm = SM:new(original_file)
	sm:AppendDofileOnceBefore(append_file)
	sm:WriteAndClose()
end

for original_file, append_file in pairs(append_list) do
	local sm = SM:new(original_file)
	sm:AppendDofileBefore(append_file)
	sm:WriteAndClose()
end

append_list = nil
