MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

AddFlagPersistent_ML_Old = AddFlagPersistent

AddFlagPersistent = function(key)
	print("hey!")
	local message = GameTextGetTranslatedOrNot("$ml_quest_done")
	local function get_tablet_count()
		local entity_id = GetUpdatedEntityID()
		local variablestorages = EntityGetComponent(entity_id, "VariableStorageComponent")
		if not variablestorages then return 1 end
		for _, variablestorage in ipairs(variablestorages) do
			if ComponentGetValue2(variablestorage, "name") == "tablets_eaten" then
				return tonumber(ComponentGetValue2(variablestorage, "value_int"))
			end
		end
		return 1
	end
	print(key)
	local values = {
		misc_chest_rain = 50,
		misc_util_rain = 100,
		misc_sun_effect = 1000,
		misc_darksun_effect = 1000,
		misc_greed_rain = 100,
		misc_worm_rain = 150,
		misc_monk_bots = 300,
		misc_altar_tablet = 15 * get_tablet_count(),
		misc_fish_rain = 200,
		misc_mimic_potion_rain = 200
	}
	print(key, values[key])
	local entity_id = EntityGetWithTag("player_unit")[1]
	if values[key] then
		MLP:AddExpGlobal(values[key], entity_id, message .. ": ")
	else
		MLP:AddExpGlobal(1, entity_id, message .. ": ")
	end

	AddFlagPersistent_ML_Old(key)
end
