local const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua") --- @type ml_const
local key = const.globals_prefix .. const.globals.exp_multiplier
local multiplier = tonumber(GlobalsGetValue(key, "0"))
GlobalsSetValue(key, tostring(multiplier + 1))
