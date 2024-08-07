---@type ml_reward_definition_list
local potion_reward = {
	{
		id = "random_potion_complete",
		group_id = "potion",
		ui_name = "$ml_random_potion",
		description = "$ml_random_potion_complete_tp",
		ui_icon = "data/ui_gfx/items/potion.png",
		probability = 0.1,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/potion_random_material.xml")
		end
	},
	{
		id = "random_potion",
		group_id = "potion",
		ui_name = "$ml_random_potion",
		description = "$ml_random_potion_tp",
		ui_icon = "data/ui_gfx/items/potion.png",
		probability = 0.3,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/potion.xml")
		end
	},
	{
		id = "random_potion_secret",
		group_id = "potion",
		ui_name = "$ml_random_potion",
		description = "$ml_random_potion_secret_tp",
		ui_icon = "data/ui_gfx/items/potion.png",
		probability = 0.1,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/potion_secret.xml")
		end
	},
	{
		id = "potion_milk",
		group_id = "potion",
		ui_name = "$mat_milk",
		ui_icon = "data/ui_gfx/items/potion.png",
		probability = 0.01,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/potion_milk.xml")
		end
	},
	{
		id = "potion_urine",
		group_id = "potion",
		ui_name = "$mat_urine",
		ui_icon = "data/ui_gfx/items/potion.png",
		probability = 0.01,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/jar_of_urine.xml")
		end
	},
	{
		id = "potion_healthium",
		group_id = "potion",
		ui_name = "$mat_magic_liquid_hp_regeneration",
		ui_icon = "data/ui_gfx/items/potion.png",
		probability = 0.01,
		max = 2,
		min_level = 10,
		fn = function()
			ML.utils:load_entity_to_player("mods/meta_leveling/files/entities/potion_healthium.xml")
		end
	},
	{
		id = "potion_LC",
		group_id = "potion",
		ui_name = "$mat_magic_liquid_hp_regeneration_unstable",
		ui_icon = "data/ui_gfx/items/potion.png",
		probability = 0.01,
		max = 2,
		min_level = 30,
		fn = function()
			ML.utils:load_entity_to_player("mods/meta_leveling/files/entities/potion_LC.xml")
		end
	},
	{
		id = "potion_mimic",
		group_id = "potion",
		ui_name = "$mat_magic_liquid_hp_regeneration",
		ui_icon = "data/ui_gfx/items/potion.png",
		probability = 0.05,
		max = 1,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/potion_mimic.xml")
		end
	},
	{
		id = "item_stonestone",
		ui_name = "$item_stonestone",
		description = "$itemdesc_stonestone",
		ui_icon = "data/ui_gfx/items/stonestone.png",
		probability = 0.1,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/stonestone.xml")
		end
	},
	{
		id = "item_thunderstone",
		ui_name = "$item_thunderstone",
		description = "$item_description_thunderstone",
		ui_icon = "data/ui_gfx/items/ingredient_1.png",
		probability = 0.2,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/thunderstone.xml")
		end
	},
	{
		id = "item_safe_haven",
		ui_name = "$item_safe_haven",
		description = "$item_description_safe_haven",
		ui_icon = "data/ui_gfx/items/safe_haven.png",
		probability = 0.05,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/safe_haven.xml")
		end
	},
	{
		id = "item_powder_stash_3",
		ui_name = "$item_powder_stash_3",
		description = "$itemdesc_powder_stash_3",
		ui_icon = "data/ui_gfx/items/material_pouch.png",
		probability = 0.1,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/powder_stash.xml")
		end
	},
	{
		id = "item_waterstone",
		ui_name = "$item_waterstone",
		description = "$item_description_waterstone",
		ui_icon = "data/ui_gfx/items/waterstone.png",
		probability = 0.05,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/waterstone.xml")
		end
	},
	{
		id = "item_evil_eye",
		ui_name = "$item_evil_eye",
		description = "$item_description_evil_eye",
		ui_icon = "data/ui_gfx/items/evil_eye.png",
		probability = 0.1,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/evil_eye.xml")
		end
	},
	{
		id = "item_broken_wand",
		ui_name = "$item_broken_wand",
		description = "$item_description_broken_wand",
		ui_icon = "data/ui_gfx/items/broken_wand.png",
		probability = 0.1,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/broken_wand.xml")
		end
	},
	{
		id = "item_brimstone",
		ui_name = "$item_brimstone",
		description = "$item_description_brimstone",
		ui_icon = "data/ui_gfx/items/brimstone.png",
		probability = 0.1,
		fn = function()
			ML.utils:load_entity_to_player("data/entities/items/pickup/brimstone.xml")
		end
	},
}
-- data/entities/items/pickup/broken_wand.xml
ML.rewards_deck:add_rewards(potion_reward)
