--- @type MetaLevelingPublic
local meta = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

local ezwand = dofile_once("mods/meta_leveling/files/scripts/lib/EZWand.lua")
local wand_id = meta.get:hold_wand()
if not wand_id then return end

local wand = ezwand(wand_id)
wand.mana = wand.mana +
	wand.manaChargeSpeed / 60 * MLP.get:global_number(MLP.const.globals.permanent_concentrated_mana, 0)
