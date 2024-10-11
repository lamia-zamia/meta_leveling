--- @class (exact) ML_set
--- @field private get ML_get
--- @field private const ml_const
local ML_set = {
	get = dofile_once("mods/meta_leveling/files/scripts/classes/public/get.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua"),
}

--- set global valuess of META_LEVELING_
--- @param key string
--- @param value number
function ML_set:global_number(key, value)
	GlobalsSetValue(self.const.globals_prefix .. key:upper(), tostring(value))
end

--- add value to global
--- @param key string
--- @param value number
--- @param default? number
function ML_set:add_to_global_number(key, value, default)
	default = default or 0
	local old = self.get:global_number(key, default)
	self:global_number(key, old + value)
end

return ML_set
