---@type ml_error_printer
local err = dofile_once("mods/meta_leveling/files/scripts/classes/private/error_printer.lua")

---@class ml_stats
---@field list ml_stats_entry[]
local ml_stats = {
	list = {}
}

---@class ml_stats_entry
---@field ui_name string name of stat
---@field value fun():string actual value to show
---@field check_before_show? fun():boolean hide if this function returns false

function ml_stats:gather_list()
	self.list = dofile_once("mods/meta_leveling/files/scripts/stats/stats_list.lua")
	dofile_once("mods/meta_leveling/files/for_modders/stats_append.lua")
end

---Add entry to stat list
---@param entry ml_stats_entry
function ml_stats:add_entry(entry)
	local check = entry.check_before_show
	if check then
		if type(check()) ~= "boolean" then
			err:print("custom check for stat is wrong, stat: " .. entry.ui_name)
			entry.check_before_show = nil
		end
	end
	self.list[#self.list + 1] = entry
end

---Add entries to stat list
---@param entries ml_stats_entry[]
function ml_stats:add_entries(entries)
	for i = 1, #entries do
		self:add_entry(entries[i])
	end
end

return ml_stats