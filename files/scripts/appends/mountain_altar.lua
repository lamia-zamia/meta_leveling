local file = "data/scripts/magic/altar_tablet_magic.lua"

local content = ModTextFileGetContent(file)
content = "ML = dofile_once(\"mods/meta_leveling/files/scripts/utilities/meta_leveling.lua\")\n" .. content
content = [[
local function get_tablet_count(entity)
	local variablestorages = EntityGetComponent(entity, "VariableStorageComponent")
	if not variablestorages then return 1 end
	for _,variablestorage in ipairs(variablestorages) do
		if ComponentGetValue2(variablestorage, "name") == "tablets_eaten" then
		return tonumber(ComponentGetValue2(variablestorage, "value_int")) + 1
		end
	end
	return 1
end
]] .. content

---@param append ml_quest_append
local function add_after_collected(append)
	local search = "(" .. append.search .. ")(.-)(if collected then)"
	local replace = "%1%2%3\n			local ml_exp = ML.exp:apply_multiplier(" .. append.exp .. ")\n"
	if append.multiplier then replace = replace .. "			ml_exp = ml_exp * " .. append.multiplier .. "\n" end
	replace = replace .. [[
			ML.exp:add(ml_exp)
			ML.font:popup_exp(ML.player:get_id(), ML.exp:format(ml_exp), ml_exp)
	]]
	content = content:gsub(search, replace, 1)
end

---@class ml_quest_append
---@field search string
---@field exp string
---@field multiplier? string

---@class ml_quest_appends
---@field [number] ml_quest_append
local ml_quest_appends = {
	{
		search = "local chests = EntityGetWithTag%( \"chest\" %)",
		exp = "50",
	},
	{
		search = "local chests = EntityGetWithTag%( \"utility_box\" %)",
		exp = "100",
	},
	{
		search = "local suns = EntityGetWithTag%( \"sunrock\" %)",
		exp = "300",
	},
	{
		search = "local suns = EntityGetWithTag%( \"darksunrock\" %)",
		exp = "300",
	},
	{
		search = "if %( #greed_crystals > 0 %) then",
		exp = "100",
	},
	{
		search = "if %( #worm_crystals > 0 %) then",
		exp = "150",
	},
	{
		search = "if %( #hand_statues > 0 %) then",
		exp = "200",
	},
	{
		search = "if %( #tablets > 0 %) then",
		exp = "15",
		multiplier = "get_tablet_count(entity_id)"
	},
	{
		search = "local animals = EntityGetInRadiusWithTag%( x, y, 128, \"helpless_animal\" %)",
		exp = "200",
	},
	{
		search = "local animals = EntityGetInRadiusWithTag%( x, y, 128, \"mimic_potion\" %)",
		exp = "200",
	}
}

for _, line in ipairs(ml_quest_appends) do
	add_after_collected(line)
end

ModTextFileSetContent(file, content)