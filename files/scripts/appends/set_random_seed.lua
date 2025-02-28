local world_state = GameGetWorldStateEntity()
if world_state == 0 then return end

local set_random_seed = SetRandomSeed

--- Sets random seed and adds offset for ascension
--- @param x number
--- @param y number
--- @param ... any
function SetRandomSeed(x, y, ...)
	local ascend_count = GlobalsGetValue("META_LEVELING_ASCEND", "0") or 0
	set_random_seed(x + tonumber(ascend_count) * 13, y, ...)
end

local get_random_action = GetRandomAction

--- Gets random action
--- @param x number
--- @param y number
--- @param ... any
--- @return string
function GetRandomAction(x, y, ...)
	local ascend_count = GlobalsGetValue("META_LEVELING_ASCEND", "0") or 0
	return get_random_action(x + tonumber(ascend_count) * 13, y, ...)
end
