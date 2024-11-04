---@type ml_error_printer
local err = dofile_once("mods/meta_leveling/files/scripts/classes/private/error_printer.lua")

---@class ml_stats
---@field list {string:ml_stats_entry[]}
---@field categories {string:string}
local ml_stats = {
	list = {},
	categories = {
		default = "$ml_stats_misc",
		experience = "$ml_experience",
		meta = "$ml_meta",
		resistance = "$ml_stats_resistance",
	},
	unfolded = {
		default = true,
		experience = true,
	},
}

---@class ml_stats_entry
---@field ui_name string name of stat
---@field category? string category name
---@field value fun():string actual value to show
---@field check_before_show? fun():boolean hide if this function returns false

---Gathers list
function ml_stats:gather_list()
	self.list = {}
	dofile_once("mods/meta_leveling/files/scripts/stats/stats_list.lua")
	dofile_once("mods/meta_leveling/files/for_modders/stats_append.lua")
	self:check_categories()
end

---Checks categories for validity
---@private
---:)
function ml_stats:check_categories()
	for category, category_name in pairs(self.categories) do
		if not category_name then
			err:print("no category name found for stat category: " .. category)
			self.categories[category] = category
		end
		if not self.list[category] then
			err:print("couldn't find any stats for category: " .. category)
			self.categories[category] = nil
		end
	end
end

---Adds entry to stat list
---@param entry ml_stats_entry
function ml_stats:add_entry(entry)
	local check = entry.check_before_show
	if check then
		if type(check()) ~= "boolean" then
			err:print("custom check for stat is wrong, stat: " .. entry.ui_name)
			entry.check_before_show = nil
		end
	end
	local cat = entry.category or "default"
	if not self.list[cat] then self.list[cat] = {} end
	local arr = self.list[cat]
	arr[#arr + 1] = entry
end

---Adds entries to stat list
---@param entries ml_stats_entry[]
function ml_stats:add_entries(entries)
	for i = 1, #entries do
		self:add_entry(entries[i])
	end
end

---Adds category name
---@param category string
---@param name string
---@param unfolded_by_default boolean
function ml_stats:add_category(category, name, unfolded_by_default)
	self.categories[category] = name
	self.unfolded[category] = unfolded_by_default
end

return ml_stats
