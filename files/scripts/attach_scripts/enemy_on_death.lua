dofile_once("mods/meta_leveling/files/scripts/compatibility/experience_custom.lua") --- importing CustomExpEntities
dofile_once("mods/meta_leveling/files/scripts/compatibility/water_list.lua") --- importing WaterMaterials
local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua") --- @type MetaLevelingPublic
local T = GameTextGetTranslatedOrNot

--- Check if the entity is visible
--- @param entity entity_id
--- @return boolean
local function is_entity_visible(entity)
	local cam_x, cam_y, cam_w, cam_h = GameGetCameraBounds()
	local ent_x, ent_y = EntityGetTransform(entity)

	-- Offset to account for some boundary around the camera
	local offset = 20
	if ent_x + offset < cam_x or ent_x - offset > cam_x + cam_w then return false end
	if ent_y + offset < cam_y or ent_y - offset > cam_y + cam_h then return false end

	-- Check if the entity is covered by fog
	return GameGetFogOfWarBilinear(ent_x, ent_y) <= 230
end

--- Check if the damage was done by water
--- @param damage_message string
--- @return boolean
local function damage_done_by_water(damage_message)
	for _, water in ipairs(WaterMaterials) do
		local text = GameTextGet("$damage_frommaterial", T(water))
		if text == damage_message then
			return true
		end
	end
	return false
end

--- @type script_damage_received
local script_damage_received = function(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	local parent = EntityGetRootEntity(entity_thats_responsible)
	if MLP.get:entity_is_player_related(parent) then
		SetValueInteger("ML_damaged_by_player", GameGetFrameNum())
	end
end
damage_received = script_damage_received

--- @type script_death
local script_death = function(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local died_entity = GetUpdatedEntityID()

	-- Return if entity belongs to the player's herd
	if MLP.get:is_player_herd(died_entity) then return end

	-- Calculate base experience from entity's max HP or using custom exp mapping
	local exp = CustomExpEntities[EntityGetFilename(died_entity)] or MLP.exp:convert_max_hp_to_exp(died_entity)
	local died_name = T(EntityGetName(died_entity))

	-- Check for boss tag to double the experience
	if MLP.get:entity_has_tag(died_entity, "boss") then exp = exp * 2 end

	-- Blessed beast integration
	if MLP.get:entity_has_tag(died_entity, "blessed_beast") then exp = exp * 1.5 end
	if MLP.get:entity_has_tag(died_entity, "blessed_miniboss") then exp = exp * 2 end

	local current_frame = GameGetFrameNum()
	local last_damage_by_player = GetValueInteger("ML_damaged_by_player", -900)
	local message = nil

	-- ######################### player kills ##########################
	if current_frame - last_damage_by_player < 180 then
		if damage_type_bit_field == 1 then exp = exp * 2 end -- Kicks
		message = T("$ml_killed") .. " : " .. died_name .. ", " .. T("$ml_gained_xp") .. ": "
	else
		-- Return if entity is off-screen
		if not is_entity_visible(died_entity) then return end

		local responsible_name = EntityGetName(entity_thats_responsible)

		-- ######################### killed by someone ##########################
		if responsible_name then
			local betrayal_multiplier = MLP.get:global_number(MLP.const.globals.exp_betray, 0)
			if betrayal_multiplier == 0 then return end

			exp = exp * betrayal_multiplier
			message = T("$ml_died") .. ": " .. died_name .. ", " .. T("$ml_cause") ..
				": " .. responsible_name .. ", " .. T("$ml_gained_xp") .. ": "
		else
			-- ######################### trick kills ##########################
			local cause = T(damage_message)
			local multiplier = 0.25 + MLP.get:global_number(MLP.const.globals.exp_trick, 0)

			-- Increase multiplier if water is involved in the kill
			if damage_message == "$damage_water" or (damage_type_bit_field == 32 and damage_done_by_water(damage_message)) then
				multiplier = multiplier + 0.5
			end

			exp = exp * multiplier
			message = T("$ml_died") .. ": " .. died_name .. ", " .. T("$ml_cause") .. ": "
				.. cause .. ", " .. T("$ml_gained_xp") .. ": "
		end
	end
	MLP:AddExpGlobal(exp, died_entity, message)
end
death = script_death
