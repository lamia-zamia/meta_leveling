---@diagnostic disable: undefined-global

local EZWand = dofile_once("mods/meta_leveling/files/lib/EZWand.lua")
local transformations = dofile_once("mods/meta_leveling/files/scripts/session_level/rewards_scripts/player_transformations.lua")

local sound_banks = {
	event_cues = "data/audio/Desktop/event_cues.bank",
	ui = "data/audio/Desktop/ui.bank",
}

---@class noita_sound
---@field bank string
---@field event string
local sounds = {
	heart = {
		bank = sound_banks.event_cues,
		event = "event_cues/heart/create"
	},
	chest = {
		bank = sound_banks.event_cues,
		event = "event_cues/chest/create"
	},
	click = {
		bank = sound_banks.ui,
		event = "ui/button_click"
	},
	refresh = {
		bank = sound_banks.event_cues,
		event = "event_cues/spell_refresh/create"
	},
	shop_item = {
		bank = sound_banks.event_cues,
		event = "event_cues/shop_item/create"
	},
	perk = {
		bank = sound_banks.event_cues,
		event = "event_cues/perk/create"
	}
}

---@class (exact) single_reward
---@field id string id of reward
---@field ui_name string name to display in game
---@field fn function function to run on pick
---@field group_id? string id of group if part of group
---@field description? string description
---@field ui_icon? string path to icon
---@field probability? number should be between 0 and 1
---@field max? number max number of reward that you can pick
---@field custom_check? function custom check to perform before adding to reward deck, should return boolean
---@field limit_before? string don't spawn this reward before this reward was hit it's max
---@field var0? any variable to replace $0 in name/description
---@field var1? any variable to replace $1 in name/description
---@field var2? any variable to replace $2 in name/description
---@field sound? noita_sound see sounds
---@field no_sound? boolean if set to true no sound will be played
---@field min_level? number if set will not appear before this level

local files = {
	shot_damage = "mods/meta_leveling/files/scripts/attach_scripts/shot_damage.lua",
	mana_regen = "mods/meta_leveling/files/scripts/attach_scripts/increased_mana_regen.lua"
}

---@class ML_utils
---@field sounds noita_sound
local utils = {
	locked_spells = {},
	spells_no_spawn = {},
	sound_banks = sound_banks,
	sounds = sounds,
	EZWand = EZWand,
	files = files,
	transformations = transformations
}

---get global valuess of META_LEVELING_
---@return number
---@param key string
---@param default number
function utils:get_global_number(key, default)
	return tonumber(GlobalsGetValue("META_LEVELING_" .. key, tostring(default))) or default
end

---set global valuess of META_LEVELING_
---@param key string
---@param value number
function utils:set_global_number(key, value)
	GlobalsSetValue("META_LEVELING_" .. key, tostring(value))
end

---add value to global
---@param key string
---@param value number
---@param default? number
function utils:add_to_global_number(key, value, default)
	default = default or 0
	local old = self:get_global_number(key, default)
	self:set_global_number(key, old + value)
end

---function to gather spells info in order to validate them later
---@private
---@method
function utils:gather_action_info()
	dofile_once("data/scripts/gun/gun_actions.lua")
	for _, action in ipairs(actions) do
		if action.spawn_probability == "0" then
			self.spells_no_spawn[action.id] = action.spawn_probability
		end
		if action.spawn_requires_flag then
			self.locked_spells[action.id] = action.spawn_requires_flag
		end
	end
end

function utils:weighted_random(pool)
	local poolsize = 0
	for _, item in ipairs(pool) do
		poolsize = poolsize + item.weight
	end
	self:random_seed()
	local selection = Random(1, poolsize)
	for _, item in ipairs(pool) do
		selection = selection - item.weight
		if (selection <= 0) then
			return item.id
		end
	end
end

---returns player id
---@return entity_id player_id
function utils:get_player_id()
	return EntityGetWithTag("player_unit")[1]
end

---returns player x, y
---@return number x, number y
function utils:get_player_pos()
	local x, y = EntityGetTransform(self:get_player_id())
	return x, y
end

---returns player's component id of name
---@param name string
---@return component_id?
function utils:get_player_component_by_name(name)
	return EntityGetFirstComponent(self:get_player_id(), name)
end

---add value to value_name of component
---@param component component_id
---@param value_name string
---@param value number
function utils:add_value_to_component(component, value_name, value)
	local current = tonumber(ComponentGetValue2(component, value_name))
	ComponentSetValue2(component, value_name, current + value)
end

---multiply value of value_name in component
---@param component component_id
---@param value_name string
---@param multiplier number
function utils:multiply_value_in_component(component, value_name, multiplier)
	local current = tonumber(ComponentGetValue2(component, value_name))
	ComponentSetValue2(component, value_name, current * multiplier)
end

---add value to value_name of component object
---@param component component_id
---@param object string 
---@param value_name string
---@param value number
function utils:add_value_to_component_object(component, object, value_name, value)
	local current = ComponentObjectGetValue2(component, object, value_name)
	ComponentObjectSetValue2(component, object, value_name, current + value)
end

---multiply value of value_name in component object
---@param component component_id
---@param object string 
---@param value_name string
---@param multiplier number
function utils:multiply_value_in_component_object(component, object, value_name, multiplier)
	local current = ComponentObjectGetValue2(component, object, value_name)
	ComponentObjectSetValue2(component, object, value_name, current * multiplier)
end

---get reward_id picked count
---@param reward_id string
---@return number
function utils:get_reward_picked_count(reward_id)
	return tonumber(GlobalsGetValue("META_LEVELING_" .. reward_id:upper() .. "_PICKUP_COUNT", "0")) or 0
end

---returns true if reward_id was picked more then number
---@param reward_id string
---@param number string
---@return boolean
function utils:check_for_picked_count(reward_id, number)
	if self:get_reward_picked_count(reward_id) < number then
		return false
	else
		return true
	end
end

---returns number of perk picked up
---@param perk_id string
---@return number
function utils:get_perk_pickup_count(perk_id)
	local flag = "PERK_PICKED_" .. perk_id .. "_PICKUP_COUNT"
	return tonumber(GlobalsGetValue(flag, "0")) or 0
end

---give player perk using vanilla's mechanic
---@param perk_id string
function utils:grant_perk(perk_id)
	dofile_once("data/scripts/perks/perk.lua")
	perk_pickup(0, self:get_player_id(), perk_id, true, false, true)
end

---return world state component id
---@return component_id?
function utils:get_world_state_component()
	local world_entity_id = GameGetWorldStateEntity()
	return EntityGetFirstComponent(world_entity_id, "WorldStateComponent")
end

---check if player can have this spell
---@param action_id string
---@return boolean
function utils:check_if_spell_is_invalid(action_id)
	if self.spells_no_spawn[action_id] then return true end
	if self.locked_spells[action_id] and not HasFlagPersistent(self.locked_spells[action_id]) then
		return true
	end
	return false
end

---return random spells of level
---@param level number
---@return string action_id
function utils:get_random_spell(level)
	if level > 6 then level = 10 end
	local action_id = "OCARINA_A" --placeholder
	while (self:check_if_spell_is_invalid(action_id)) do
		local pos_x, pos_y = self:get_player_pos()
		action_id = GetRandomAction(pos_x, pos_y, level, GameGetFrameNum())
	end
	return action_id
end

---return random spells of level
---@param level number
---@param type number
---@return string action_id
function utils:get_random_typed_spell(level, type)
	if level > 6 then level = 10 end
	local action_id = "OCARINA_A" --placeholder
	while (self:check_if_spell_is_invalid(action_id)) do
		local pos_x, pos_y = self:get_player_pos()
		action_id = GetRandomActionWithType(pos_x, pos_y, level, type, GameGetFrameNum())
	end
	return action_id
end

---return number from mod settings
---@param id string id of setting
---@param default? number default number or 0
---@return number
function utils:get_mod_setting_number(id, default)
	default = default or 0
	return tonumber(ModSettingGet("meta_leveling." .. id)) or default
end

---return number from mod settings
---@param id string id of setting
---@param default? boolean default value or false
---@return boolean
function utils:get_mod_setting_boolean(id, default)
	default = default or false
	local value = ModSettingGet("meta_leveling." .. id)
	if type(value) == "boolean" then return value
	else return default end
end

function utils:spawn_spell(action_id)
	local pos_x, pos_y = self:get_player_pos()
	CreateItemActionEntity(action_id, pos_x, pos_y)
end

function utils:random_seed()
	local pos_x, pos_y = self:get_player_pos()
	SetRandomSeed(pos_x, pos_y + GameGetFrameNum())
end

---return first wand in inventory
---@return entity_id?
function utils:get_first_wand()
	local entity_id = EntityGetWithName("inventory_quick")
	if entity_id then
		local childs = EntityGetAllChildren(entity_id)
		if not childs then return nil end
		for _, child in ipairs(childs) do
			if EntityHasTag(child, "wand") then return child end
		end
	end
	return nil
end

---return hold wand or optionally a first wand
---@param look_for_first boolean? look for first or not, default false
---@return entity_id?
function utils:get_hold_wand(look_for_first)
	local inventory2_comp = EntityGetFirstComponentIncludingDisabled(self:get_player_id(), "Inventory2Component")
	if inventory2_comp then
		local active_item = ComponentGetValue2(inventory2_comp, "mActiveItem")
		if EntityHasTag(active_item, "wand") then return active_item end
	end
	if look_for_first then return self:get_first_wand()
	else return nil end
end

function utils:add_lua_component_if_none(value, file)
	local player = self:get_player_id()
	local components = EntityGetComponentIncludingDisabled(player, "LuaComponent") or {}
	for _, component in ipairs(components) do
		if ComponentGetValue2(component, value) == file then return end
	end
	local comp = EntityAddComponent2(player, "LuaComponent")
	ComponentSetValue2(comp, value, file)
end

function utils:force_fungal_shift()
	dofile_once("data/scripts/magic/fungal_shift.lua")
	local pos_x, pos_y = self:get_player_pos()
	fungal_shift(self:get_player_id(), pos_x, pos_y, true)
end

function utils:load_entity_to_player(file)
	local x, y = self:get_player_pos()
	EntityLoad(file, x, y)
end

utils:gather_action_info()

return utils
