---@diagnostic disable: missing-global-doc
local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

function MetaLevelingDoTabletExp()
	local entity_id = GetUpdatedEntityID()
	local variablestorages = EntityGetComponent(entity_id, "VariableStorageComponent")
	if not variablestorages then return end
	for _, variablestorage in ipairs(variablestorages) do
		if ComponentGetValue2(variablestorage, "name") == "tablets_eaten" then
			local count = tonumber(ComponentGetValue2(variablestorage, "value_int")) or 1
			MLP:QuestCompleted(15 * count)
		end
	end
end

function MetaLevelingCheckForChestCheese()
	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform(entity_id)
	local chests = EntityGetInRadiusWithTag(x, y, 50, "chest")
	for i = 1, #chests do
		local chest = chests[i]
		local variable_storage_comps = EntityGetComponent(chest, "VariableStorageComponent") or {}
		for j = 1, #variable_storage_comps do
			local vsc = variable_storage_comps[j]
			if ComponentGetValue2(vsc, "name") == "meta_leveling_chest" then
				local chest_x, chest_y = EntityGetTransform(chest)
				-- removing tags since EntityKill has one frame delay, thus triggering chest rain anyway
				EntityRemoveTag(chest, "chest")
				EntityKill(chest)
				EntityLoad("data/entities/items/pickup/chest_leggy.xml", chest_x, chest_y)
				break
			end
		end
	end
	chests = EntityGetWithTag("chest")
end

local AddFlagPersistent_ML_Old = AddFlagPersistent

---@param key string
AddFlagPersistent = function(key)
	local values = {
		misc_chest_rain = 50,
		misc_util_rain = 100,
		misc_sun_effect = 1000,
		misc_darksun_effect = 1000,
		misc_greed_rain = 100,
		misc_worm_rain = 150,
		misc_monk_bots = 300,
		misc_fish_rain = 200,
		misc_mimic_potion_rain = 200,
	}
	if values[key] then MLP:QuestCompleted(values[key]) end

	AddFlagPersistent_ML_Old(key)
end
