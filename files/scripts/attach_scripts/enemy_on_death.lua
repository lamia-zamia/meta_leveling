---@type meta_leveling
ML = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling.lua")
local waters = dofile_once("mods/meta_leveling/files/scripts/compatibility/water_list.lua")
local T = GameTextGetTranslatedOrNot

local function not_visible(entity)
	local offset = 20
	local cam_x, cam_y, cam_w, cam_h = GameGetCameraBounds()
	local ent_x, ent_y = EntityGetTransform(entity)
	if ent_x + offset < cam_x or ent_x - offset > cam_x + cam_w then return true end
	if ent_y + offset < cam_y or ent_y - offset > cam_y + cam_h then return true end
	local fog = GameGetFogOfWarBilinear(ent_x, ent_y)
	if fog > 110 then return true end
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

---@type script_death
function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local died_entity = GetUpdatedEntityID()
	if ML.utils:is_player_herd(died_entity) then return end
	local exp = ML.exp:convert_max_hp_to_exp(died_entity)
	exp = ML.exp:apply_multiplier(exp)
	local message = nil
	local died_name = T(EntityGetName(died_entity))
	-- ######################### player kills ##########################
	if ML.utils:entity_has_player_tag(entity_thats_responsible) or ML.utils:is_player_herd(entity_thats_responsible) then
		message = T("$ml_killed") .. " : " .. died_name .. ", " .. T("$ml_gained_xp") .. ": " .. exp
		ML.exp:add(exp)
	else
		if not_visible(died_entity) then return end
		local responsible_name = EntityGetName(entity_thats_responsible)
		-- ######################### killed by someone ##########################
		if responsible_name then
			local multiplier = ML.utils:get_global_number(ML.const.globals.exp_betray, 0)
			if multiplier == 0 then return end
			exp = exp * multiplier
			message = T("$ml_died") .. ": " .. died_name .. ", " .. T("$ml_cause") .. ": "
				.. T(responsible_name) .. ", " .. T("$ml_gained_xp") .. ": " .. exp
			ML.exp:add(exp)
		else -- ######################### trick kills ##########################
			local cause = T(damage_message)
			local multiplier = 0.25 + ML.utils:get_global_number(ML.const.globals.exp_trick, 0)
			if damage_message == "$damage_water" then multiplier = multiplier + 0.5 end
			if damage_type_bit_field == 32 and damage_done_by_water(damage_message) then multiplier = multiplier + 0.5 end

			exp = exp * multiplier
			message = T("$ml_died") .. ": " .. died_name .. ", " .. T("$ml_cause") .. ": "
				.. cause .. ", " .. T("$ml_gained_xp") .. ": " .. exp
			ML.exp:add(exp)
		end
	end
	if message and ML.utils:get_mod_setting_boolean("session_exp_popup") then ML.font:popup_exp(died_entity,
			ML.exp:format(exp), exp) end
	if message and ML.utils:get_mod_setting_boolean("session_exp_log") then GamePrint(message) end
end
