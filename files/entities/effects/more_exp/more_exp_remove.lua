local player = EntityGetWithTag("player_unit")[1] --- check if it the effect run out or it was removed due to polymorphine
if not player then return end

local const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua") --- @type ml_const
local key = const.globals_prefix .. const.globals.exp_multiplier
local multiplier = tonumber(GlobalsGetValue(key, "1"))
GlobalsSetValue(key, tostring(multiplier - 1))
