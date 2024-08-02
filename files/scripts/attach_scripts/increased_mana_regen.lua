---@type meta_leveling
local ML = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling.lua")

local wand_id = ML.utils:get_hold_wand()
if not wand_id then return end

local wand = ML.utils.EZWand(wand_id)
wand.mana = wand.mana + wand.manaChargeSpeed / 60 * ML.utils:get_global_number("permanent_concentrated_mana", 0)