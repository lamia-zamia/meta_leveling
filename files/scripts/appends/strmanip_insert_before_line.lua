---@type StringManip
local SM = dofile_once("mods/meta_leveling/files/scripts/lib/stringmanip.lua")

local inserts = {
	{
		file = "data/scripts/magic/altar_tablet_magic.lua",
		search_line = "if (tablets_eaten > 2) then",
		insert_line = "meta_leveling_do_tablet_exp()"
	}
}

for i = 1, #inserts do
	local sm = SM:new(inserts[i].file)
	sm:InsertBeforeLine(inserts[i].search_line, inserts[i].insert_line)
	sm:WriteAndClose()
end
