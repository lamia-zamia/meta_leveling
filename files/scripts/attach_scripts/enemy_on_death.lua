local ML = dofile_once("mods/meta_leveling/files/scripts/utilities/meta_leveling.lua")
local distance_x = 428
local distance_y = 243

local function get_distance(died_entity)
	local d_x, d_y = EntityGetTransform(died_entity)
	local p_x, p_y = EntityGetTransform(ML.utils:get_player_id())
	local x = math.abs(d_x - p_x)
	local y = math.abs(d_y - p_y)
	return {x = x, y = y}
end

function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
	local died_entity = GetUpdatedEntityID()
	local exp = ML:convert_max_hp_to_exp(died_entity)
	local message = nil
	local died_name = GameTextGetTranslatedOrNot(EntityGetName(died_entity))

	if EntityHasTag(entity_thats_responsible, "player_unit") then
		message = "Killed " .. died_name .. ", gain xp: " .. exp
		ML:add_exp(exp)
	else
		local distance = get_distance(died_entity)
		if distance.x > distance_x or distance.y > distance_y then return end
		local responsible_name = EntityGetName(entity_thats_responsible)
		if responsible_name then
			message = GamePrint("Died from enemy: " .. died_name .. ", resposible: " .. GameTextGetTranslatedOrNot(responsible_name))
		else
			local cause = GameTextGetTranslatedOrNot(damage_message)
			message = "Died: " .. died_name .. ", cause: " .. cause .. ", resposible: unknown"
		end
	end
	if message and ML.utils:get_mod_setting_boolean("session_exp_log") then GamePrint(message) end
end
