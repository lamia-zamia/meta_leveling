local rewards_deck = dofile_once("mods/meta_leveling/files/scripts/classes/private/rewards_deck.lua") --- @class rewards_deck
local rewards = rewards_deck.reward_definition_list
for i = 1, #rewards do
	local reward = rewards[i]
	local reward_id = reward.id
	if reward_id:find("^health_extra_health") then reward.probability = reward.probability / 5 end
	if reward_id:find("^wand_") then reward.probability = reward.probability / 3 end
	if reward.min_level then reward.min_level = math.ceil(reward.min_level * 1.25) end
end
