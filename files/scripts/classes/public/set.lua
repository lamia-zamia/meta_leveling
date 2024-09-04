---@class (exact) ML_set
---@field MLP MetaLevelingPublic
local ML_set = {}

---set global valuess of META_LEVELING_
---@param key string
---@param value number
function ML_set:global_number(key, value)
	GlobalsSetValue(self.MLP.const.globals_prefix .. key:upper(), tostring(value))
end

---add value to global
---@param key string
---@param value number
---@param default? number
function ML_set:add_to_global_number(key, value, default)
	default = default or 0
	local old = self.MLP.get:global_number(key, default)
	self:global_number(key, old + value)
end

return ML_set