local EZWand = dofile("mods/meta_leveling/files/scripts/lib/EZWand.lua")

local function refresh_wand_if_in_inventory(wand_id)
	-- Refresh the wand if it's being held by something
	local parent = EntityGetRootEntity(wand_id)
	local inventory2_comp = EntityGetFirstComponentIncludingDisabled(parent, "Inventory2Component")
	if inventory2_comp then
		ComponentSetValue2(inventory2_comp, "mDontLogNextItemEquip", true)
		ComponentSetValue2(inventory2_comp, "mForceRefresh", true)
		ComponentSetValue2(inventory2_comp, "mActualActiveItem", 0)
	end
end

--- @type ml_rewards
local wand_rewards = {
	{
		id = "wand_faster_delay_and_recharge",
		ui_name = "$ml_faster_wand",
		description = "$ml_faster_wand_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/faster_wand.png",
		probability = 0.2,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			wand.castDelay = Randomf(wand.castDelay * 0.9 - 5, wand.castDelay - 2)
			wand.rechargeTime = Randomf(wand.rechargeTime * 0.9 - 5, wand.rechargeTime - 2)
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_faster_delay",
		ui_name = "$ml_faster_wand",
		description = "$ml_faster_wand_delay",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/faster_delay.png",
		probability = 0.3,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			wand.castDelay = Randomf(wand.castDelay * 0.80 - 5, wand.castDelay - 2)
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_faster_recharge",
		ui_name = "$ml_faster_wand",
		description = "$ml_faster_wand_recharge",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/faster_recharge.png",
		probability = 0.3,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			wand.rechargeTime = Randomf(wand.rechargeTime * 0.80 - 5, wand.rechargeTime - 2)
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_more_mana",
		ui_name = "$ml_wand_more_mana",
		description = "$ml_wand_more_mana_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_mana.png",
		probability = 0.3,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			wand.manaMax = wand.manaMax + Random(5, 10) * Random(5, 20)
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_more_recharge",
		ui_name = "$ml_wand_more_recharge",
		description = "$ml_wand_more_recharge_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_recharge.png",
		probability = 0.3,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			wand.manaChargeSpeed = wand.manaChargeSpeed + Random(1, ML:get_level() * 5) + 10
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_more_recharge_and_mana",
		ui_name = "$ml_wand_more_recharge_and_mana",
		description = "$ml_wand_more_recharge_and_mana_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_mana_and_recharge.png",
		probability = 0.2,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			wand.manaMax = wand.manaMax + Random(2, 5) * Random(2, 10)
			wand.manaChargeSpeed = wand.manaChargeSpeed + Random(1, ML:get_level() * 3) + 5
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_more_capacity1",
		group_id = "wand_more_capacity",
		ui_name = "$ml_wand_more_capacity",
		description = "$ml_wand_more_capacity_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_capacity.png",
		probability = 0.3,
		custom_check = function()
			return ML:get_level() < 40
		end,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			local old_capacity = wand.capacity
			local new_capacity = math.min(26, wand.capacity + Random(1, 3))
			wand.capacity = math.max(old_capacity, new_capacity)
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_more_capacity2",
		group_id = "ml_wand_more_capacity",
		ui_name = "$ml_wand_more_capacity",
		description = "$ml_wand_more_capacity_tp_no_limit",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/more_capacity.png",
		probability = 0.3,
		min_level = 41,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			wand.capacity = wand.capacity + Random(1, 3)
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_no_shuffle",
		ui_name = "$ml_wand_no_shuffle",
		description = "$ml_wand_no_shuffle_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/no_shuffle.png",
		probability = 0.3,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			wand.shuffle = false
			refresh_wand_if_in_inventory(wand_id)
		end
	},
	{
		id = "wand_lower_spread",
		ui_name = "$ml_wand_lower_spread",
		description = "$ml_wand_lower_spread_tp",
		ui_icon = "mods/meta_leveling/files/gfx/rewards/lower_spread.png",
		probability = 0.3,
		fn = function()
			local wand_id = MLP.get:hold_wand(true)
			if not wand_id then return end
			local wand = EZWand(wand_id)
			ML.utils:random_seed()
			wand.spread = wand.spread - Random(2, 10)
			refresh_wand_if_in_inventory(wand_id)
		end
	},
}

ML.rewards_deck:add_rewards(wand_rewards)
