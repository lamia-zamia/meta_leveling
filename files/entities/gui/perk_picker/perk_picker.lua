dofile("data/scripts/perks/perk_list.lua")

--- Generates a table of N unique random numbers within a specified range.
--- @param n number The number of unique random numbers to generate.
--- @param min number The minimum value of the range.
--- @param max number The maximum value of the range.
--- @return table A table containing N unique random numbers.
local function generate_unique_random_numbers(n, min, max)
	local numbers, result = {}, {}
	while #result < n do
		local rand = Random(min, max)
		if not numbers[rand] and not perk_list[rand].not_in_default_perk_pool then
			numbers[rand] = true
			result[#result + 1] = rand
		end
	end
	return result
end

local function get_random_perks(count)
	local x, y = 0, 0
	if ModIsEnabled("quant.ew") then
		x, y = CrossCall("ew_per_peer_seed")
	end
	SetRandomSeed(x + 1, y + 1)
	local perk_indexes = generate_unique_random_numbers(count, 1, #perk_list)
	local perks = {}
	for i = 1, count do
		local index = perk_indexes[i]
		local perk = perk_list[index]
		perks[i] = {
			id = perk.id,
			ui_name = perk.ui_name,
			ui_description = perk.ui_description,
			icon = perk.perk_icon,
		}
	end
	return perks
end

--- @class ml_random_perk_picker
--- @field perks {id:string, ui_name:string, ui_description:string, icon:string}[]
local picker = {
	perk_count = ModSettingGet("meta_leveling.progress_random_perk") or 1,
}
picker.perks = get_random_perks(picker.perk_count * 3)

return picker
