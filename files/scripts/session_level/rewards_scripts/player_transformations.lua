local rat = {
	value = "PLAYER_RATTINESS_LEVEL",
	threshold = 3,
	flag = "player_status_ratty"
}

function rat:transform()
	local player = ML.utils:get_player_id()
	if not player then return end
	local x, y = ML.utils:get_player_pos()
	GlobalsSetValue(self.value, tostring(self.threshold + 1))

	local child_id = EntityLoad("data/entities/verlet_chains/tail/verlet_tail.xml", x, y)
	EntityAddTag(child_id, "perk_entity")
	EntityAddChild(player, child_id)

	local component = EntityGetFirstComponentIncludingDisabled(player, "CharacterPlatformingComponent")
	if (component ~= nil) then
		local run_speed = ComponentGetValue2(component, "run_velocity") * 1.15
		local vel_x = math.abs(ComponentGetValue2(component, "velocity_max_x")) * 1.15

		local vel_x_min = 0 - vel_x
		local vel_x_max = vel_x

		ComponentSetValue2(component, "run_velocity", run_speed)
		ComponentSetValue2(component, "velocity_min_x", vel_x_min)
		ComponentSetValue2(component, "velocity_max_x", vel_x_max)
	end
end

local fungi = {
	value = "PLAYER_FUNGAL_LEVEL",
	threshold = 3,
	flag = "player_status_funky"
}

function fungi:transform()
	local player = ML.utils:get_player_id()
	if not player then return end
	GlobalsSetValue(self.value, tostring(self.threshold + 1))

	EntitySetComponentsWithTagEnabled(player, "player_hat", true)
	EntitySetComponentsWithTagEnabled(player, "player_hat2_shadow", false)

	local damagemodel = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
	if (damagemodel ~= nil) then
		local explosion_resistance = ComponentObjectGetValue2(damagemodel, "damage_multipliers", "explosion")
		explosion_resistance = explosion_resistance * 0.9
		ComponentObjectSetValue2(damagemodel, "damage_multipliers", "explosion", explosion_resistance)
	end
end

local ghost = {
	value = "PLAYER_GHOSTNESS_LEVEL",
	threshold = 3,
	flag = "player_status_ghostly"
}

function ghost:transform()
	local player = ML.utils:get_player_id()
	if not player then return end
	local x, y = ML.utils:get_player_pos()
	GlobalsSetValue(self.value, tostring(self.threshold + 1))

	local child_id = EntityLoad("data/entities/misc/perks/ghostly_ghost.xml", x, y)
	local child_id2 = EntityLoad("data/entities/misc/perks/tiny_ghost_extra.xml", x, y)
	EntityAddTag(child_id, "perk_entity")
	EntityAddTag(child_id2, "perk_entity")
	EntityAddChild(player, child_id)
	EntityAddChild(player, child_id2)


	local component = EntityGetFirstComponentIncludingDisabled(player, "CharacterDataComponent")
	if (component ~= nil) then
		local fly_time = ComponentGetValue2(component, "fly_recharge_spd") * 1.15
		ComponentSetValue2(component, "fly_recharge_spd", fly_time)
	end
end

local lukki = {
	value = "PLAYER_LUKKINESS_LEVEL",
	threshold = 3,
	flag = "player_status_lukky"
}

function lukki:transform()
	local player = ML.utils:get_player_id()
	if not player then return end
	GlobalsSetValue(self.value, tostring(self.threshold + 1))

	EntitySetComponentsWithTagEnabled(player, "lukki_enable", true)

	local comp = EntityGetFirstComponent(player, "SpriteComponent", "lukki_disable")
	if (comp ~= nil) then
		ComponentSetValue2(comp, "alpha", 0.0)
	end

	local component = EntityGetFirstComponentIncludingDisabled(player, "CharacterPlatformingComponent")
	if (component ~= nil) then
		local run_speed = ComponentGetValue2(component, "run_velocity") * 1.1
		local vel_x = math.abs(ComponentGetValue2(component, "velocity_max_x")) * 1.1

		local vel_x_min = 0 - vel_x
		local vel_x_max = vel_x

		ComponentSetValue2(component, "run_velocity", run_speed)
		ComponentSetValue2(component, "velocity_min_x", vel_x_min)
		ComponentSetValue2(component, "velocity_max_x", vel_x_max)
	end
end

local angel = {
	value = "PLAYER_HALO_LEVEL",
	threshold = 3,
	flag = "player_status_halo"
}

function angel:remove()
	local entity = EntityGetWithName("halo")
	if entity then
		EntityRemoveFromParent(entity)
		EntityKill(entity)
	end
end

function angel:transform()
	local halo_level = tonumber(GlobalsGetValue(self.value, "0"))
	local player = ML.utils:get_player_id()
	if not player then return end
	local x, y = ML.utils:get_player_pos()
	GlobalsSetValue(self.value, tostring(self.threshold + 10))

	child_id = EntityLoad("data/entities/misc/perks/player_halo_light.xml", x, y)
	if child_id ~= nil then
		EntityAddChild(player, child_id)
	end

	if halo_level < -2 then
		self:remove()
	else
		local damagemodel = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
		if (damagemodel ~= nil) then
			local fire_resistance = ComponentObjectGetValue2(damagemodel, "damage_multipliers", "fire") * 0.9
			ComponentObjectSetValue2(damagemodel, "damage_multipliers", "fire", fire_resistance)

			local holy_resistance = ComponentObjectGetValue2(damagemodel, "damage_multipliers", "holy") * 0.9
			ComponentObjectSetValue2(damagemodel, "damage_multipliers", "holy", holy_resistance)
		end
	end
end

local demon = {
	value = "PLAYER_HALO_LEVEL",
	threshold = -3,
	flag = "player_status_halo"
}

function demon:remove()
	local entity = EntityGetWithName("halo")
	if entity then
		EntityRemoveFromParent(entity)
		EntityKill(entity)
	end
end

function demon:transform()
	local halo_level = tonumber(GlobalsGetValue(self.value, "0"))
	local player = ML.utils:get_player_id()
	if not player then return end
	local x, y = ML.utils:get_player_pos()
	GlobalsSetValue(self.value, tostring(self.threshold - 10))

	child_id = EntityLoad("data/entities/misc/perks/player_halo_dark.xml", x, y)
	if child_id ~= nil then
		EntityAddChild(player, child_id)
	end

	if halo_level > 2 then
		self:remove()
	else
		local damagemodel = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
		if (damagemodel ~= nil) then
			local fire_resistance = ComponentObjectGetValue2(damagemodel, "damage_multipliers", "fire") * 0.9
			ComponentObjectSetValue2(damagemodel, "damage_multipliers", "fire", fire_resistance)

			local holy_resistance = ComponentObjectGetValue2(damagemodel, "damage_multipliers", "holy") * 0.9
			ComponentObjectSetValue2(damagemodel, "damage_multipliers", "holy", holy_resistance)
		end
	end
end

local transformations = {
	rat = rat,
	fungi = fungi,
	ghost = ghost,
	lukki = lukki,
	angel = angel,
	demon = demon
}

return transformations