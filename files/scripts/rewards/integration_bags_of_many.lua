local const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua")
--- @type ml_rewards
local bags = {}

local sizes = { "small", "medium", "big" }
local types = {
	spells = 0.7,
	potions = 0.9,
	universal = 0.62,
}

for bag_type, probability in pairs(types) do
	for i, size in ipairs(sizes) do
		local bag = "bag_" .. bag_type .. "_" .. size
		bags[#bags + 1] = {
			id = "pickup_bags_of_many_" .. bag,
			group_id = "pickup_bags_of_many",
			ui_name = string.format("$%s", bag),
			description = string.format("$item_description_%s", bag),
			ui_icon = string.format("mods/bags_of_many/files/ui_gfx/bags/%s.png", bag),
			probability = probability - i / 5,
			fn = function()
				ML.utils:load_entity_to_player(string.format("mods/bags_of_many/files/entities/bags/%s.xml", bag))
			end,
			sound = const.sounds.chest,
		}
	end
end

local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua")
rewards_deck:add_rewards(bags, "Bags of many Integration")
