---@class (exact) ML_get
---@field private const ml_const
local ML_get = {
	const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua"),
}

---returs exp red, green, blue color
---@return number red, number blue, number green
function ML_get:exp_color()
	local r = MLP.get:mod_setting_number("exp_bar_red", 0)
	local g = MLP.get:mod_setting_number("exp_bar_green", 128)
	local b = MLP.get:mod_setting_number("exp_bar_blue", 0)
	return r, g, b
end

---get global valuess of META_LEVELING_
---@return number
---@param key string
---@param default number
function ML_get:global_number(key, default)
	return tonumber(GlobalsGetValue(self.const.globals_prefix .. key:upper(), tostring(default))) or default
end

---return number from mod settings
---@param id string id of setting
---@param default? number default number or 0
---@return number
function ML_get:mod_setting_number(id, default)
	default = default or 0
	return tonumber(ModSettingGet("meta_leveling." .. id)) or default
end

---return number from mod settings
---@param id string id of setting
---@param default? boolean default value or false
---@return boolean
function ML_get:mod_setting_boolean(id, default)
	default = default or false
	local value = ModSettingGet("meta_leveling." .. id)
	if type(value) == "boolean" then
		return value
	else
		return default
	end
end

---@param entity entity_id
---@return boolean
function ML_get:entity_has_player_tag(entity)
	for _, tag in ipairs(self.const.player_tags) do
		if EntityHasTag(entity, tag) then return true end
	end
	return false
end

---@param entity entity_id
---@return string
function ML_get:herd_id(entity)
	local genome_comp = EntityGetFirstComponentIncludingDisabled(entity, "GenomeDataComponent")
	if not genome_comp then return "" end
	local herd_id = ComponentGetValue2(genome_comp, "herd_id")
	if not herd_id then return "" end
	return HerdIdToString(herd_id)
end

---@param entity entity_id
---@return boolean
function ML_get:is_player_herd(entity)
	return self:herd_id(entity) == "player"
end

---@param entity entity_id
---@param effect game_effect
---@return boolean
function ML_get:entity_has_effect(entity, effect)
	if entity == 0 then return false end
	local comp = GameGetGameEffect(entity, effect)
	if not comp or comp == 0 then return false end
	return true
end

---returns true if entity is related to player (tag, herd, charm)
---@param entity entity_id
---@return boolean
function ML_get:entity_is_player_related(entity)
	if not EntityGetIsAlive(entity) then return false end
	if self:entity_has_player_tag(entity) or self:is_player_herd(entity) or self:entity_has_effect(entity, "CHARM") then return true end
	return false
end

---return first wand in inventory
---@return entity_id?
function ML_get:first_wand()
	local entity_id = EntityGetWithName("inventory_quick")
	if entity_id then
		local children = EntityGetAllChildren(entity_id)
		if not children then return nil end
		for _, child in ipairs(children) do
			if EntityHasTag(child, "wand") then return child end
		end
	end
	return nil
end

---return hold wand or optionally a first wand
---@param look_for_first boolean? look for first or not, default false
---@return entity_id?
function ML_get:hold_wand(look_for_first)
	local player_id = EntityGetWithTag("player_unit")[1]
	if not player_id then return end
	local inventory2_comp = EntityGetFirstComponentIncludingDisabled(player_id, "Inventory2Component")
	if inventory2_comp then
		local active_item = ComponentGetValue2(inventory2_comp, "mActiveItem")
		if EntityHasTag(active_item, "wand") then return active_item end
	end
	if look_for_first then
		return self:first_wand()
	else
		return nil
	end
end

return ML_get
