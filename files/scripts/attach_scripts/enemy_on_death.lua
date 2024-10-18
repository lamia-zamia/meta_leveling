dofile_once("mods/meta_leveling/files/scripts/compatibility/experience_custom.lua")  --- importing CustomExpEntities
dofile_once("mods/meta_leveling/files/scripts/compatibility/water_list.lua")         --- importing WaterMaterials
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

-- local function get_base_experience

--- Determines if was hurt by player
--- @return boolean
--- @nodiscard
local function is_player_kill()
	local current_frame = GameGetFrameNum()
	local last_damage_by_player = GetValueInteger("ML_damaged_by_player", -900)
	return (current_frame - last_damage_by_player) < 180
end

--- Process friendly fire
--- @param multiplier number
--- @param died_name string
--- @param responsible_name string
--- @return number, string
local function betray_exp(multiplier, died_name, responsible_name)
	local betrayal_multiplier = MLP.get:global_number(MLP.const.globals.exp_betray, 0)
	if betrayal_multiplier == 0 then return 0, "" end

	multiplier = multiplier * betrayal_multiplier
	local message = T("$ml_died") .. ": " .. died_name .. ", " .. T("$ml_cause") ..
		": " .. responsible_name .. ", " .. T("$ml_gained_xp") .. ": "

	return multiplier, message
end

--- Process environmental kills
--- @param multiplier number
--- @param died_name string
--- @param damage_message string
--- @param damage_type_bit_field number
--- @return number, string
local function trick_exp(multiplier, died_name, damage_message, damage_type_bit_field)
	local cause = T(damage_message)
	local trick_multiplier = 0.25 + MLP.get:global_number(MLP.const.globals.exp_trick, 0)

	-- Increase multiplier if water is involved in the kill
	if damage_message == "$damage_water" or (damage_type_bit_field == 32 and damage_done_by_water(damage_message)) then
		trick_multiplier = trick_multiplier + 0.5
	end

	multiplier = multiplier * trick_multiplier
	local message = T("$ml_died") .. ": " .. died_name .. ", " .. T("$ml_cause") .. ": "
		.. cause .. ", " .. T("$ml_gained_xp") .. ": "

	return multiplier, message
end

--- Process experience value
--- @param multiplier number
--- @param died_entity entity_id
--- @return number
local function process_boss(multiplier, died_entity)
	-- Check for boss tag to double the experience
	if MLP.get:entity_has_tag(died_entity, "boss") then 
		multiplier = multiplier * 2 
		MLP.points:add_meta_points(1)
	end

	-- Blessed beast integration
	if MLP.get:entity_has_tag(died_entity, "blessed_beast") then multiplier = multiplier * 1.5 end
	if MLP.get:entity_has_tag(died_entity, "blessed_miniboss") then multiplier = multiplier * 2 end

	return multiplier
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

	local multiplier = 1
	local message = nil
	local died_name = T(EntityGetName(died_entity))

	if is_player_kill() then
		-- Player kill
		if damage_type_bit_field == 1 then multiplier = multiplier * 2 end -- Kicks
		message = T("$ml_killed") .. " : " .. died_name .. ", " .. T("$ml_gained_xp") .. ": "
	else
		-- Return if entity is off-screen
		if not is_entity_visible(died_entity) then return end

		local responsible_name = EntityGetName(EntityGetRootEntity(entity_thats_responsible))

		if responsible_name then
			-- Killed by another entity
			multiplier, message = betray_exp(multiplier, died_name, responsible_name)
			if multiplier <= 0 then return end
		else
			-- Environmental kills
			multiplier, message = trick_exp(multiplier, died_name, damage_message, damage_type_bit_field)
		end
	end

	multiplier = process_boss(multiplier, died_entity)

	-- Calculate base experience from entity's max HP or using custom exp mapping
	local exp = CustomExpEntities[EntityGetFilename(died_entity)] or MLP.exp:convert_max_hp_to_exp(died_entity)

	MLP:AddExpGlobal(exp * multiplier, died_entity, message)
end
death = script_death
