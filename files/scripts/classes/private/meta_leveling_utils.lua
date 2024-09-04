---@class ML_utils
local utils = {
	set_content = ModTextFileSetContent
}

function utils:weighted_random(pool)
	local poolsize = 0
	for _, item in ipairs(pool) do
		poolsize = poolsize + item.weight
	end
	self:random_seed()
	local selection = Random(1, poolsize)
	for _, item in ipairs(pool) do
		selection = selection - item.weight
		if (selection <= 0) then
			return item.id
		end
	end
end

function utils:spawn_spell(action_id)
	CreateItemActionEntity(action_id, ML.player.x, ML.player.y)
end

function utils:random_seed()
	SetRandomSeed(ML.player.x, ML.player.y + GameGetFrameNum())
end

function utils:load_entity_to_player(file)
	EntityLoad(file, ML.player.x, ML.player.y)
end

function utils:merge_tables(table1, table2)
	for _, element in ipairs(table2) do
		table1[#table1 + 1] = element
	end
end



return utils
