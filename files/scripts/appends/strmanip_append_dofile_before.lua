---@type StringManip
local SM = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/stringmanip.lua")

local append_list = {
	["data/scripts/buildings/sun/spot_1_finish.lua"] =
	"mods/meta_leveling/files/scripts/appends/sunquest/spot_1_finish.lua",
	["data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua"] =
	"mods/meta_leveling/files/scripts/appends/ending_sequence_append.lua",
}


for original_file, append_file in pairs(append_list) do
	local sm = SM:new(original_file)
	sm:AppendDofileBefore(append_file)
	sm:WriteAndClose()
end

append_list = nil
