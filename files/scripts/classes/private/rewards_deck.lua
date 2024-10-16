--- @type ml_error_printer
local err = dofile_once("mods/meta_leveling/files/scripts/classes/private/error_printer.lua")

--- @class ml_reward_id

--- @class (exact) ml_single_reward_data:ml_reward
--- @field id ml_reward_id The id of the reward
--- @field group_id ml_reward_id The id of the group if part of a group
--- @field fn function function to run on pick
--- @field ui_icon string path to icon
--- @field probability number|fun():number should be between 0 and 1
--- @field max number max number of reward that you can pick
--- @field sound ml_sound see sounds
--- @field pick_count number
--- @field border_color ml_reward_border color of border

--- @class (exact) ml_group_data
--- @field rewards ml_reward_id[] list of rewards in group
--- @field picked boolean if something from group was picked

--- @class rewards_deck
--- @field private get ML_get
--- @field private const ml_const
--- @field private set ML_set
--- @field private reward_definition_list ml_rewards list of rewards
--- @field reward_appended_by { [ml_reward_id]: string}
--- @field groups_data { [string]: ml_group_data}
--- @field reward_data { [string]: ml_single_reward_data } data of rewards
--- @field ordered_groups_data ml_group_data[]
--- @field ordered_rewards_data ml_single_reward_data[]
--- @field private default_icon string
--- @field private max_probability number max probability for single reward
--- @field private min_probability number min probability for single reward
--- @field private list ml_reward_id[] table of rewards id
--- @field private distance number minimum distance between rewards
--- @field borders { [string]: ml_reward_border}
--- @field picked_count number how many rewards have been picked
local rewards_deck = {
	get = dofile_once("mods/meta_leveling/files/scripts/classes/public/get.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua"),
	set = dofile_once("mods/meta_leveling/files/scripts/classes/public/set.lua"),
	reward_data = {},
	groups_data = {},
	default_icon = "mods/meta_leveling/files/gfx/rewards/no_png.png",
	borders = {
		common = { 0.6, 0.6, 0.6, 0.6 },
		uncommon = { 0.3, 1, 0.3, 0.6 },
		rare = { 0, 1, 1, 0.6 },
		epic = { 1, 0, 1, 0.7 },
		legendary = { 1, 0.5, 0, 1 },
		relic = { 1, 0, 0, 1 }
	},
	max_probability = 1,
	min_probability = 0.01,
	list = {},
	distance = 4,
	picked_count = 0,
	reward_appended_by = {}
}

--- beautiful rewards name
--- @param text string
--- @return string
function rewards_deck.FormatString(text)
	return (text:lower():gsub("^%l", string.upper))
end

--- function to unpack variable descriptions
--- @param description string
--- @param variables reward_description
--- @return string?
function rewards_deck:UnpackDescription(description, variables)
	if not description then return nil end
	description = GameTextGetTranslatedOrNot(description)
	if variables then
		for i, variable in ipairs(variables) do
			if type(variable) == "string" then
				local text = variable:gsub("%%", "%%%%")
				description = description:gsub("%$" .. i - 1, GameTextGetTranslatedOrNot(text))
			elseif type(variable) == "function" then
				description = description:gsub("%$" .. i - 1, variable())
			end
		end
	end
	description = description:gsub("%$%d", "")
	return self.FormatString(description)
end

--- Pairs sorted
--- @private
--- @generic T: table, K, V
--- @param tbl T
--- @return fun(table: table<K, V>, index?: K):K, V
--- @return T
function rewards_deck.ordered_pairs(tbl)
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

--- Adds a single reward to the reward list.
--- @param table ml_reward
--- @param appended_by? string
function rewards_deck:add_reward(table, appended_by)
	self.reward_definition_list[#self.reward_definition_list + 1] = table
	if appended_by then self.reward_appended_by[table.id] = appended_by end
end

--- Adds an array of rewards to the reward list.
--- @param table ml_rewards
--- @param appended_by? string
function rewards_deck:add_rewards(table, appended_by)
	for i = 1, #table do
		self:add_reward(table[i], appended_by)
	end
end

--- Validates the reward data and group data for consistency.
--- @private
function rewards_deck:ValidateData()
	local reward_count = 0
	for id, reward in pairs(self.reward_data) do
		if reward.limit_before and not self.reward_data[reward.limit_before] then
			err:print("invalid limit_before in reward: " .. id)
			self.reward_data[id].limit_before = nil
		end
		if reward.custom_check and type(reward.custom_check()) ~= "boolean" then
			err:print("invalid custom_check in reward: " .. id)
			self.reward_data[id].custom_check = nil
		end
		reward_count = reward_count + 1
	end

	local group_count = 0
	for _, _ in pairs(self.groups_data) do
		group_count = group_count + 1
	end
	print("[Meta Leveling]: loaded " .. reward_count .. " rewards, " .. group_count .. " unique rewards group")
end

--- Sorts pairs table
--- @param tbl {[string]: any}
--- @return any[]
function rewards_deck:sort_data(tbl)
	local sorted = {}
	for _, entry in self.ordered_pairs(tbl) do
		sorted[#sorted + 1] = entry
	end
	return sorted
end

--- Gathers reward data from a predefined list.
function rewards_deck:GatherData()
	self.reward_definition_list = {}
	dofile_once("mods/meta_leveling/files/for_modders/rewards_append.lua")
	dofile_once("mods/meta_leveling/files/for_modders/rewards_modify.lua")

	for _, reward in ipairs(self.reward_definition_list) do
		if self.reward_data[reward.id] then
			err:print("duplicate reward id " .. reward.id)
		else
			self:initialize_reward_data(reward)
		end
	end

	self:ValidateData()
	self.ordered_groups_data = self:sort_data(self.groups_data)
	self.ordered_rewards_data = self:sort_data(self.reward_data)
end

--- Initializes the reward data and group data based on the reward definition.
--- @private
--- @param reward ml_reward
function rewards_deck:initialize_reward_data(reward)
	local reward_id = reward.id --[[@as ml_reward_id]]
	local reward_entry = {
		id = reward_id,
		group_id = reward.group_id or reward_id,
		ui_name = reward.ui_name,
		description = reward.description or nil,
		description_var = reward.description_var or nil,
		description2 = reward.description2 or nil,
		description2_var = reward.description2_var or nil,
		ui_icon = self:set_icon(reward.ui_icon),
		probability = self:set_probability(reward.probability),
		max = reward.max or 1280,
		fn = reward.fn or err.print,
		pick_count = self:get_specific_reward_pickup_amount(reward_id),
		limit_before = reward.limit_before or nil,
		custom_check = reward.custom_check or nil,
		sound = reward.sound or self.const.sounds.perk,
		no_sound = reward.no_sound,
		min_level = reward.min_level or 1
	}
	reward_entry.border_color = self:set_borders(reward_id, reward_entry.probability, reward.border_color)
	self.picked_count = self.picked_count + reward_entry.pick_count
	self.reward_data[reward.id] = reward_entry
	self:initialize_group_data(reward_entry)
end

--- Initializes the group data for a given reward.
--- @private
--- @param reward_entry ml_single_reward_data
function rewards_deck:initialize_group_data(reward_entry)
	local group_id = reward_entry.group_id

	if not self.groups_data[group_id] then
		self.groups_data[group_id] = { rewards = {}, picked = false }
	end

	self.groups_data[group_id].rewards[#self.groups_data[group_id].rewards + 1] = reward_entry.id

	if reward_entry.pick_count > 0 then
		self.groups_data[group_id].picked = true
	end
end

--- Sets the probability of a reward, normalizing it if necessary.
--- @private
--- @param probability number|fun():number
--- @return number|fun():number
function rewards_deck:set_probability(probability)
	if type(probability) == "number" then return self:probability_normalize(probability) end
	return probability or 1
end

--- Normalizes the probability of a reward.
--- @param probability number
--- @return number
function rewards_deck:probability_normalize(probability)
	return math.max(self.min_probability + 0.001, math.min(self.max_probability, probability))
end

--- Sets icon for reward
--- @param ui_icon string?
--- @return string
--- @nodiscard
function rewards_deck:set_icon(ui_icon)
	if not ui_icon then return self.default_icon end
	if ui_icon:find("%.xml") and ModDoesFileExist(ui_icon) then return ui_icon end
	if ui_icon:find("%.png") and ModImageDoesExist(ui_icon) then return ui_icon end
	return self.default_icon
end

--- get normalized probability
--- @private
--- @param probability number|fun():number
--- @return number
function rewards_deck:get_probability(probability)
	if type(probability) == "number" then return probability end
	return self:probability_normalize(probability())
end

--- Determines and sets border icon
--- @param id ml_reward_id
--- @param probability number|fun():number
--- @param border? ml_reward_border
--- @return ml_reward_border
--- @nodiscard
function rewards_deck:set_borders(id, probability, border)
	if border then return border end
	if type(probability) == "function" then
		probability = probability()
	end
	if probability < 0.03 then
		return self.borders.relic
	elseif probability < 0.1 then
		return self.borders.legendary
	elseif probability < 0.2 then
		return self.borders.epic
	elseif probability < 0.3 then
		return self.borders.rare
	elseif probability < 0.5 then
		return self.borders.uncommon
	end
	return self.borders.common
end

--- Shuffles the list of rewards.
--- @private
function rewards_deck:shuffle()
	for i = #self.list, 2, -1 do
		local j = Random(1, i)
		self.list[i], self.list[j] = self.list[j], self.list[i]
	end
end

--- Adds a reward to the list a specified number of times.
--- @private
--- @param reward_id ml_reward_id
--- @param amount number
function rewards_deck:add_to_list(reward_id, amount)
	for _ = 1, amount do
		self.list[#self.list + 1] = reward_id
	end
end

--- Checks if a reward meets the criteria to be added to the list.
--- @private
--- @param reward ml_single_reward_data
--- @return boolean
function rewards_deck:checks_before_add(reward)
	local pass = reward.pick_count < reward.max
	pass = pass and ML:get_level() >= reward.min_level
	if reward.limit_before then
		pass = pass and self.reward_data[reward.limit_before].pick_count >= self.reward_data[reward.limit_before].max
	end
	if reward.custom_check then
		pass = pass and reward.custom_check()
	end
	return pass
end

--- Gathers rewards from the data and populates the list.
--- @private
function rewards_deck:get_from_list()
	self.distance = self:get_draw_amount() * 4
	self.list = {}
	for _, reward in pairs(self.reward_data) do
		local meta_bonus = (ModSettingGet("meta_leveling.progress_reward_less_rare") or 0) / 100
		local probability = Randomf(self.min_probability + meta_bonus, self:get_probability(reward.probability))
		if self:checks_before_add(reward) then self:add_to_list(reward.id, probability * 100) end
	end
end

--- Ensures rewards are not spawned too close to each other.
--- @private
function rewards_deck:ensure_distance()
	local temp_new = {}
	-- local count = #self.list

	for i = 1, #self.list do
		if not self.list[i] then goto continue end
		if i + self.distance > #self.list then break end
		for j = i + 1, i + self.distance do
			if self.reward_data[self.list[i]].group_id == self.reward_data[self.list[j]].group_id then
				goto continue
			end
		end
		temp_new[#temp_new + 1] = self.list[i]
		::continue::
	end

	self.list = temp_new
end

--- Refreshes the order of rewards in the list.
--- @private
function rewards_deck:refresh_reward_order()
	SetRandomSeed(1, 2)
	self:get_from_list()
	self:shuffle()
	self:ensure_distance()
end

--- Returns the number of rewards to draw.
--- @return number
function rewards_deck:get_draw_amount()
	return self.get:global_number(self.const.globals.draw_amount, 0) + 3
end

--- Returns the current draw index.
--- @private
--- @return number
function rewards_deck:get_draw_index()
	return self.get:global_number(self.const.globals.draw_index, 1)
end

--- Returns the next valid draw index.
--- @private
--- @param current_index number
--- @return number
function rewards_deck:get_next_draw_index(current_index)
	if self.list[current_index] == nil then
		self:refresh_reward_order()
		current_index = 1
	end
	while self.list[current_index] == nil do
		current_index = current_index + 1
		if current_index > 10000 then break end
	end
	return current_index
end

--- Sets the next draw index.
--- @private
function rewards_deck:set_draw_index()
	local index = self:get_draw_index()
	for _ = 1, self:get_draw_amount() + 1 do
		index = self:get_next_draw_index(index + 1)
	end
	self.set:global_number(self.const.globals.draw_index, index)
end

--- Draws the next rewards from the list.
--- @return table<[number], ml_reward_id> reward_ids
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

--- Returns the pickup count for a specific reward.
--- @param reward_id ml_reward_id
--- @return number pickup_count
function rewards_deck:get_specific_reward_pickup_amount(reward_id)
	return self.get:global_number(self.const.globals_prefix .. reward_id .. "_PICKUP_COUNT", 0)
end

--- Increments the pickup count for a specific reward.
--- @private
--- @param reward_id ml_reward_id
function rewards_deck:add_specific_reward_pickup_amount(reward_id)
	self.reward_data[reward_id].pick_count = self.reward_data[reward_id].pick_count + 1
	self.groups_data[self.reward_data[reward_id].group_id].picked = true
	self.set:global_number(self.const.globals_prefix .. reward_id .. "_PICKUP_COUNT",
		self.reward_data[reward_id].pick_count)
	self.picked_count = self.picked_count + 1
	self:add_to_progress(reward_id)
end

--- Skips the current reward and advances the draw index.
function rewards_deck:skip_reward()
	self:add_reroll(0.51)
	self:set_draw_index()
end

--- Plays the sound associated with a drawn reward.
--- @param draw_id ml_reward_id
function rewards_deck:play_sound(draw_id)
	local reward = self.reward_data[draw_id]
	if not reward.no_sound then
		local player_id = EntityGetWithTag("player_unit")[1]
		if not player_id then return end
		local x, y = EntityGetTransform(player_id)
		GamePlaySound(reward.sound.bank, reward.sound.event, x, y)
	end
end

--- Executes actions when a reward is picked.
--- @param draw_id ml_reward_id
function rewards_deck:pick_reward(draw_id)
	local success, error = pcall(rewards_deck.reward_data[draw_id].fn)
	if success then
		rewards_deck:set_draw_index()
		rewards_deck:play_sound(draw_id)
		rewards_deck:add_specific_reward_pickup_amount(draw_id)
	else
		err:print("function of " .. draw_id .. " throw an error, error: " .. error)
	end
end

--- Retrieves the current reroll count.
--- @return number
function rewards_deck:get_reroll_count()
	return math.max(0, self.get:global_number(self.const.globals.reroll_count, 1))
end

--- Adds to the reroll count.
--- @param count number
function rewards_deck:add_reroll(count)
	self.set:add_to_global_number(self.const.globals.reroll_count, count, 1)
end

--- Performs a reroll, decrementing the reroll count and setting the next draw index.
function rewards_deck:reroll()
	self.set:add_to_global_number(self.const.globals.reroll_count, -1)
	self:set_draw_index()
end

--- Add reward into progress
--- @param reward_id ml_reward_id
--- @private
function rewards_deck:add_to_progress(reward_id)
	local setting_id = "meta_leveling.reward_picked_" .. reward_id
	local count = tonumber(ModSettingGet(setting_id)) or 0
	ModSettingSet(setting_id, count + 1)
	ModSettingSetNextValue(setting_id, count + 1, false)
end

--- Returns picked up count
--- @param reward_id ml_reward_id
--- @return number
function rewards_deck:reward_picked_up_count_all_time(reward_id)
	local setting_id = "meta_leveling.reward_picked_" .. reward_id
	return tonumber(ModSettingGet(setting_id)) or 0
end

return rewards_deck
