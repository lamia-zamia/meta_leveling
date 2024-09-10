local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

function meta_leveling_do_tablet_exp()
	local entity_id = GetUpdatedEntityID()
	local variablestorages = EntityGetComponent(entity_id, "VariableStorageComponent")
	if not variablestorages then return end
	local message = GameTextGetTranslatedOrNot("$ml_quest_done")
	for _, variablestorage in ipairs(variablestorages) do
		if ComponentGetValue2(variablestorage, "name") == "tablets_eaten" then
			local count = tonumber(ComponentGetValue2(variablestorage, "value_int")) or 1
			local player_id = EntityGetWithTag("player_unit")[1]
			MLP:AddExpGlobal(15 * count, player_id, message .. ": ")
		end
	end
end

local AddFlagPersistent_ML_Old = AddFlagPersistent

---@param key string
AddFlagPersistent = function(key)
	local message = GameTextGetTranslatedOrNot("$ml_quest_done")
	local values = {
		misc_chest_rain = 50,
		misc_util_rain = 100,
		misc_sun_effect = 1000,
		misc_darksun_effect = 1000,
		misc_greed_rain = 100,
		misc_worm_rain = 150,
		misc_monk_bots = 300,
		misc_fish_rain = 200,
		misc_mimic_potion_rain = 200
	}
	if values[key] then
		local player_id = EntityGetWithTag("player_unit")[1]
		MLP:AddExpGlobal(values[key], player_id, message .. ": ")
	end

	AddFlagPersistent_ML_Old(key)
end
