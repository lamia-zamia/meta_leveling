---@type ml_error_printer
local err = dofile_once("mods/meta_leveling/files/scripts/classes/private/error_printer.lua")

---@class (exact) ml_meta
---@field private progress_list ml_progress_point[]
---@field private flag string
---@field progress ml_progress_point_run[]
local meta = {
	progress_list = {},
	progress = {},
	flag = "META_LEVELING_PROGRESS_APPLIED",
}

---@alias progress_fn fun(count: number)
---@alias applied_bonus_fn fun(count: number):string

---@class (exact) ml_progress_point
---@field id string id of progress
---@field ui_name string name to display in game
---@field fn progress_fn function to execute on start
---@field applied_bonus? applied_bonus_fn function that returns a string value that describes current bonus
---@field description? string description
---@field description_var? reward_description variable for description
---@field stack? number max number of time you can upgrade it
---@field price? number price of point
---@field price_multiplier? number multiplier of price to apply for next points
---@field custom_check? function custom check to perform before showing this point, should return boolean.<br>True - show, false - hide

---@class progress_id

---@class (exact) ml_progress_point_run:ml_progress_point
---@field id progress_id id of progress
---@field next_value number
---@field current_value number
---@field price number[]
---@field private price_multiplier? number

---Apply effect
---@private
---@param point_id progress_id
---@param fn progress_fn
---@param count number
function meta:apply_effect(point_id, fn, count)
	local success, error = pcall(fn, count)
	if not success then
		err:print("error during applying an effect for " .. point_id)
		print(error)
	end
end

---Apply setting
---@private
function meta:apply_settings_if_new_run()
	if SessionNumbersGetValue("is_biome_map_initialized") ~= "0" then return end
	for _, point in ipairs(self.progress_list) do
		local id = "meta_leveling.progress_" .. point.id
		local next_value = tonumber(ModSettingGetNextValue(id)) or 0
		ModSettingSet(id, next_value)
	end
end

---Apply settings and bonuses if new run
function meta:apply_if_new_run()
	if GameHasFlagRun(self.flag) then return end
	for _, point in ipairs(self.progress) do
		-- local count = self:apply_setting(point.id --[[@as progress_id]])
		local count = tonumber(ModSettingGet("meta_leveling.progress_" .. point.id)) or 0
		if count > 0 then self:apply_effect(point.id, point.fn, count) end
	end
	GameAddFlagRun(self.flag)
end

---Calculate costs for progress
---@param price number
---@param multiplier number
---@param max number
---@return number[]
function meta:calculate_cost(price, multiplier, max)
	local prices = {}
	local real_price = price
	for i = 1, max do
		prices[i] = math.floor(real_price)
		real_price = real_price * multiplier
	end
	return prices
end

---Initialize progress list
function meta:initialize()
	dofile_once("mods/meta_leveling/files/for_modders/progress_appends.lua")
	self:apply_settings_if_new_run()
	for _, point in ipairs(self.progress_list) do
		self:initialize_point(point --[[@as ml_progress_point_run]])
	end
end

---Get current progress value
---@private
---@param point_id progress_id
---@return number current, number next
function meta:get_current_progress(point_id)
	local id = "meta_leveling.progress_" .. point_id
	local current = tonumber(ModSettingGet(id)) or 0
	local next = tonumber(ModSettingGetNextValue(id)) or 0
	return current, next
end

---Set next value
---@param index number
---@param amount number
function meta:set_next_progress(index, amount)
	local direction = 1
	local progress = meta.progress[index]
	local current_value = progress.next_value
	local next_value = current_value + amount
	if amount < 0 then
		direction = -1
		current_value = current_value + 1
	end
	local currency = 0
	for i = 1, math.abs(amount) do
		local target_value = current_value + i * direction
		if target_value > 0 and target_value <= #progress.price then
			local price = progress.price[target_value]
			currency = currency + price * -direction
		end
	end
	MLP.points:modify_current_currency(currency)
	progress.next_value = next_value
	ModSettingSetNextValue("meta_leveling.progress_" .. progress.id, next_value, false)
end

---Verify applied_bonus_fn
---@param progress_id progress_id
---@param applied_bonus applied_bonus_fn
---@return applied_bonus_fn
function meta:verify_applied_bonus_description(progress_id, applied_bonus)
	local success, result = pcall(applied_bonus, 1)
	if success and type(result) == "string" then
		return applied_bonus
	end
	print("[Meta Leveling Error]: error during resolving description for " .. progress_id)
	print(result)
	return function() return "hamis" end
end

---Check and add point to progress
---@private
---@param point ml_progress_point
function meta:initialize_point(point)
	if point.custom_check and not point.custom_check() then
		return
	end
	local id = point.id --[[@as progress_id]]
	local current, next = self:get_current_progress(id)
	self.progress[#self.progress + 1] = {
		id = id,
		ui_name = point.ui_name,
		fn = point.fn,
		description = point.description,
		description_var = point.description_var,
		applied_bonus = self:verify_applied_bonus_description(id, point.applied_bonus),
		stack = point.stack or 1,
		price = self:calculate_cost(point.price or 1, point.price_multiplier or 2, point.stack or 1),
		current_value = current,
		next_value = next
	}
end

---Append to progress list
---@param point ml_progress_point
function meta:append_point(point)
	self.progress_list[#self.progress_list + 1] = point
end

---Append an array to progress list
---@param points ml_progress_point[]
function meta:append_points(points)
	for _, point in ipairs(points) do
		self:append_point(point)
	end
end

return meta
