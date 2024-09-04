---@type MetaLevelingPublic
local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")
local waters = dofile_once("mods/meta_leveling/files/scripts/compatibility/water_list.lua")
local T = GameTextGetTranslatedOrNot

local function not_visible(entity)
	local offset = 20
	local cam_x, cam_y, cam_w, cam_h = GameGetCameraBounds()
	local ent_x, ent_y = EntityGetTransform(entity)
	if ent_x + offset < cam_x or ent_x - offset > cam_x + cam_w then return true end
	if ent_y + offset < cam_y or ent_y - offset > cam_y + cam_h then return true end
	local fog = GameGetFogOfWarBilinear(ent_x, ent_y)
	if fog > 230 then return true end
	return false
end

local function damage_done_by_water(damage_message)
	for _, water in ipairs(waters) do
		local text = GameTextGet("$damage_frommaterial", T(water))
		if text == damage_message then
			return true
		end
	end
	return false
end

---@type script_damage_received
function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
	if MLP.get:entity_is_player_related(entity_thats_responsible) then
		SetValueInteger("ML_damaged_by_player", GameGetFrameNum())
	end
end

---@type script_death
function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local died_entity = GetUpdatedEntityID()
	if MLP.get:is_player_herd(died_entity) then return end
	local exp = MLP.exp:convert_max_hp_to_exp(died_entity)
	if MLP.get:entity_has_tag(died_entity, "boss") then exp = exp * 2 end
	local message = nil
	local died_name = T(EntityGetName(died_entity))
	-- ######################### player kills ##########################
	if GameGetFrameNum() - GetValueInteger("ML_damaged_by_player", -900) < 180 then
		message = T("$ml_killed") .. " : " .. died_name .. ", " .. T("$ml_gained_xp") .. ": "
	else
		if not_visible(died_entity) then return end
		local responsible_name = EntityGetName(entity_thats_responsible)
		-- ######################### killed by someone ##########################
		if responsible_name then
			local multiplier = MLP.get:global_number(MLP.const.globals.exp_betray, 0)
			if multiplier == 0 then return end
			exp = exp * multiplier
			message = T("$ml_died") .. ": " .. died_name .. ", " .. T("$ml_cause") .. ": "
				.. T(responsible_name) .. ", " .. T("$ml_gained_xp") .. ": "
		else -- ######################### trick kills ##########################
			local cause = T(damage_message)
			local multiplier = 0.25 + MLP.get:global_number(MLP.const.globals.exp_trick, 0)
			if damage_message == "$damage_water" then multiplier = multiplier + 0.5 end
			if damage_type_bit_field == 32 and damage_done_by_water(damage_message) then multiplier = multiplier + 0.5 end

			exp = exp * multiplier
			message = T("$ml_died") .. ": " .. died_name .. ", " .. T("$ml_cause") .. ": "
				.. cause .. ", " .. T("$ml_gained_xp") .. ": "
		end
	end
	MLP:AddExpGlobal(exp, died_entity, message)
end
