---Pairs sorted
---@generic T: table, K, V
---@param tbl T
---@return fun(table: table<K, V>, index?: K):K, V
---@return T
local function orderedPairs(self, tbl)
	local keys = {}
	for k in pairs(tbl) do
		table.insert(keys, k)
	end
	table.sort(keys)

	local i = 0
	local function iter()
		i = i + 1
		if keys[i] then
			return keys[i], tbl[keys[i]]
		end
	end

	return iter, tbl
end

return orderedPairs