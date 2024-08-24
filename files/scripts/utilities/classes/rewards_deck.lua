---@class ml_reward_definition_list
---@field [number] ml_reward

---@class (exact) ml_single_reward_data:ml_reward
---@field fn function function to run on pick
---@field group_id string id of group if part of group
---@field ui_icon string path to icon
---@field probability number|fun():number should be between 0 and 1
---@field max number max number of reward that you can pick
---@field sound ml_sound see sounds
---@field pick_count number

---@class (exact) group_data
---@field rewards table<[number], [string]> list of rewards in group
---@field picked boolean if something from group was picked

---@class (exact) groups_data
---@field [string] group_data

---@class (exact) reward_data
---@field [string] ml_single_reward_data

---@class (exact) rewards_deck
---@field private reward_definition_list ml_rewards list of rewards
---@field groups_data groups_data
---@field reward_data reward_data data of rewards
---@field default_icon string
---@field private max_probability number max probability for single reward
---@field private min_probability number min probability for single reward
---@field private list table table of rewards id
---@field private distance number mimimum distance between rewards
---@field reroll_count number
local rewards_deck = {
	reward_data = {},
	groups_data = {},
	default_icon = "mods/meta_leveling/files/gfx/rewards/no_png.png",
	max_probability = 1,
	min_probability = 0.01,
	list = {},
	distance = 4,
	reroll_count = 1,
}

---default function if function was not found
---@private
function rewards_deck:function_not_found()
	print("error!")
end

---add single reward to list
---@param table ml_reward
function rewards_deck:add_reward(table)
	self.reward_definition_list[#self.reward_definition_list + 1] = table
end

---add array of rewards to list
---@param table ml_rewards
function rewards_deck:add_rewards(table)
	for _, reward in ipairs(table) do
		self:add_reward(reward)
	end
end

---function to gather data from list
function rewards_deck:GatherData()
	self.reward_definition_list = dofile_once("mods/meta_leveling/files/scripts/session_level/rewards/level_up_rewards.lua")
	dofile_once("mods/meta_leveling/files/scripts/session_level/rewards/rewards_append.lua")
	for _, reward in ipairs(self.reward_definition_list) do
		self.reward_data[reward.id] = {
			id = reward.id,
			group_id = reward.group_id or reward.id,
			ui_name = reward.ui_name,
			description = reward.description or nil,
			description_var = reward.description_var or nil,
			description2 = reward.description2 or nil,
			description2_var = reward.description2_var or nil,
			ui_icon = reward.ui_icon or self.default_icon,
			probability = self:set_probability(reward.probability),
			max = reward.max or 1280,
			fn = reward.fn or self.function_not_found,
			pick_count = self:get_specific_reward_pickup_amount(reward.id),
			limit_before = reward.limit_before or nil,
			custom_check = reward.custom_check or nil,
			sound = reward.sound or ML.const.sounds.perk,
			no_sound = reward.no_sound,
			min_level = reward.min_level or 1
		}
		local group_id = self.reward_data[reward.id].group_id
		if self.groups_data[group_id] then
			self.groups_data[group_id].rewards[#self.groups_data[group_id].rewards + 1] = reward.id
		else
			self.groups_data[group_id] = {
				rewards = { reward.id },
				picked = false
			}
		end
		if self.reward_data[reward.id].pick_count > 0 then self.groups_data[group_id].picked = true end
	end
	local i = 0
	for _, _ in pairs(self.groups_data) do
		i = i + 1
	end
	print("[Meta Leveling]: loaded " .. i .. " unique rewards group")
end

---get normalized probability
---@private
---@param probability number|fun():number
---@return number|fun():number
function rewards_deck:set_probability(probability)
	probability = probability or 1
	if type(probability) == "number" then return self:probability_normalize(probability) end
	return probability
end

---normalize probability
---@param probability number
---@return number
function rewards_deck:probability_normalize(probability)
	probability = math.min(self.max_probability, probability)
	probability = math.max(probability, self.min_probability + 0.01)
	return probability
end

---get normalized probability
---@private
---@param probability number
---@return number
function rewards_deck:get_probability(probability)
	if type(probability) == "number" then return probability end
	return self:probability_normalize(probability())
end

---shuffle table
---@private
function rewards_deck:shuffle()
	local iterations = #self.list
	local j
	for i = iterations, 2, -1 do
		j = Random(1, i)
		self.list[i], self.list[j] = self.list[j], self.list[i]
	end
end

function rewards_deck:add_to_list(reward_id, amount)
	for _ = 1, amount do
		self.list[#self.list + 1] = reward_id
	end
end

function rewards_deck:checks_before_add(reward)
	local pass = true
	pass = pass and reward.pick_count < reward.max
	pass = pass and ML:get_level() >= reward.min_level
	if reward.limit_before then
		pass = pass and self.reward_data[reward.limit_before].pick_count >= self.reward_data[reward.limit_before].max
	end
	if reward.custom_check then
		pass = pass and reward.custom_check()
	end
	return pass
end

---gather list
---@private
function rewards_deck:get_from_list()
	self.distance = self:get_draw_amount() * 4
	self.list = {}
	for _, reward in pairs(self.reward_data) do
		local probability = Randomf(self.min_probability, self:get_probability(reward.probability))
		if self:checks_before_add(reward) then self:add_to_list(reward.id, probability * 100) end
	end
end

---ensure rewards are not spawned too close to each other
---@private
function rewards_deck:ensure_distance()
	local temp_new = {}
	local count = #self.list

	for i = 1, count do
		if not self.list[i] then goto continue end
		if i + self.distance > count then break end
		for j = i + 1, i + self.distance do
			if self.reward_data[self.list[i]].group_id == self.reward_data[self.list[j]].group_id then
				goto continue
			end
		end
		temp_new[#temp_new+1] = self.list[i]
		::continue::
	end

	self.list = temp_new
end

---Generate reward list
---@private
function rewards_deck:refresh_reward_order()
	SetRandomSeed(1, 2)
	self:get_from_list()
	self:shuffle()
	self:ensure_distance()
end

---returns how many to draw
---@return number
function rewards_deck:get_draw_amount()
	return ML.utils:get_global_number(ML.const.globals.draw_amount, 0) + 3
end

---return current draw index
---@private
---@return number
function rewards_deck:get_draw_index()
	return ML.utils:get_global_number(ML.const.globals.draw_index, 1)
end

---return next valid draw index
---@private
---@param current_index number
---@return number
function rewards_deck:get_next_draw_index(current_index)
	if self.list[current_index] == nil then
		self:refresh_reward_order()
		current_index = 1
	end
	while self.list[current_index] == nil or self.list[current_index] == "" do
		current_index = current_index + 1
		if current_index > 10000 then break end
	end
	return current_index
end

---set next draw index
---@private
function rewards_deck:set_draw_index()
	local index = self:get_draw_index()
	for _ = 1, self:get_draw_amount() + 1 do
		index = self:get_next_draw_index(index + 1)
	end
	ML.utils:set_global_number(ML.const.globals.draw_index, index)
end

---Return next reward
---@return table reward_ids
function rewards_deck:draw_reward()
	self:refresh_reward_order()
	local draw_index = self:get_draw_index()
	local draw_list = {}
	for _ = 1, self:get_draw_amount() do
		draw_index = self:get_next_draw_index(draw_index)
		draw_list[#draw_list + 1] = self.list[draw_index]
		draw_index = draw_index + 1
	end
	return draw_list
end

---get reward picked up count
---@param reward_id string
---@return number pickup_count
function rewards_deck:get_specific_reward_pickup_amount(reward_id)
	return ML.utils:get_global_number(ML.const.globals_prefix .. reward_id .. "_PICKUP_COUNT", 0)
end

---add reward pick up count
---@private
---@param reward_id string
function rewards_deck:add_specific_reward_pickup_amount(reward_id)
	self.reward_data[reward_id].pick_count = self.reward_data[reward_id].pick_count + 1
	self.groups_data[self.reward_data[reward_id].group_id].picked = true
	ML.utils:set_global_number(ML.const.globals_prefix .. reward_id .. "_PICKUP_COUNT", self.reward_data[reward_id].pick_count)
end

function rewards_deck:skip_reward()
	self:set_draw_index()
end

function rewards_deck:play_sound(draw_id)
	if self.reward_data[draw_id].no_sound then return end
	GamePlaySound(self.reward_data[draw_id].sound.bank, self.reward_data[draw_id].sound.event, ML.player.x, ML.player.y)
end

---do stuff after pickup
---@param draw_id string
function rewards_deck:pick_reward(draw_id)
	rewards_deck:set_draw_index()

	rewards_deck:play_sound(draw_id)
	rewards_deck.reward_data[draw_id].fn()

	rewards_deck:add_specific_reward_pickup_amount(draw_id)
end

function rewards_deck:get_reroll_count()
	self.reroll_count = ML.utils:get_global_number(ML.const.globals.reroll_count, 1)
end

function rewards_deck:add_reroll(count)
	self.reroll_count = self.reroll_count + count
	ML.utils:set_global_number(ML.const.globals.reroll_count, self.reroll_count)
end

function rewards_deck:reroll()
	self.reroll_count = self.reroll_count - 1
	ML.utils:set_global_number(ML.const.globals.reroll_count, self.reroll_count)
	self:set_draw_index()
end

return rewards_deck
