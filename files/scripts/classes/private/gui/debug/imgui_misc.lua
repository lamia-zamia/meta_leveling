--- @class ml_debug
local debug = {}

function debug:add_orb()
	local orb_e = EntityCreateNew()
	EntityAddComponent2(orb_e, "OrbComponent", {
		orb_id = GameGetOrbCountThisRun() + 50,
	})
	EntityAddComponent2(orb_e, "ItemComponent", {
		enable_orb_hacks = true,
	})
	GamePickUpInventoryItem(ML.player.id, orb_e, false)
end

function debug:be_strong()
	for _ = 1, 100 do
		ML.rewards_deck:pick_reward("wand_faster_delay_and_recharge") ---@diagnostic disable-line: param-type-mismatch
		ML.rewards_deck:pick_reward("wand_more_recharge_and_mana") ---@diagnostic disable-line: param-type-mismatch
		ML.rewards_deck:pick_reward("buff_damage_crit_chance_increase") ---@diagnostic disable-line: param-type-mismatch
	end
end

--- Draws some trash
--- @private
--- :)
function debug:draw_misc()
	if self.imgui.Button("Add orbs") then self:add_orb() end
	if self.imgui.Button("Pick Sampo") then
		local sampo_e = EntityLoad("data/entities/animals/boss_centipede/sampo.xml", 10000, 10000)
		GamePickUpInventoryItem(ML.player.id, sampo_e, false)
	end
	if self.imgui.Button("KYS") then
		local gsc_id = ML.player:get_component_by_name("GameStatsComponent")
		if gsc_id then ComponentSetValue2(gsc_id, "extra_death_msg", "Killed by debug") end
		EntityKill(ML.player.id)
	end
	if self.imgui.Button("Be strong") then self:be_strong() end
	self.imgui.Text("Meta points")
	self.imgui.Text(
		"Speed bonus: "
			.. string.format("%.2f", MLP.points:CalculateMetaPointsSpeedBonus())
			.. ", minutes: "
			.. string.format("%.2f", GameGetFrameNum() / 60 / 60)
	)
	self.imgui.Text("Pacifist bonus: " .. MLP.points:CalculateMetaPointsPacifistBonus())
	self.imgui.Text("Orb bonus: " .. MLP.points:CalculateMetaPointsOrbs())
	self.imgui.Text("Damage bonus: " .. MLP.points:CalculateMetaPointsDamageTaken())
	self.imgui.Text("Fungal shift bonus: " .. MLP.points:CalculateMetaPointsFungalShift())
	self.imgui.Text("Streak bonus: " .. MLP.points:CalculateMetaPointsWinStreakBonus() .. ", streak: " .. ModSettingGet("meta_leveling.streak_count"))
	self.imgui.Text("You will be rewarded for " .. MLP:CalculateMetaPointsOnSampo() .. " points")
end

return debug
