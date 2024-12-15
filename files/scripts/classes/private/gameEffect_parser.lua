---@class (exact) ML_gameEffect
---@field id string id of status, in capital
---@field ui_name string ui name
---@field ui_description string ui description
---@field ui_icon string ui icon
---@field effect_entity string xml of status entity
---@field is_harmful? boolean

---@class (exact) ML_gameEffect_parser
---@field list ML_gameEffect[]
local status = {
	list = {},
}

local force_load = { "BERSERK" }
local force_ignore = { "TRIP", "HP_REGENERATION", "NIGHTVISION", "MOVEMENT_FASTER_2X" }

---Checks if effect should be ignored in any case
---@param effect_id string
---@return boolean
local function is_ignored(effect_id)
	for i = 1, #force_ignore do
		if effect_id == force_ignore[i] then return true end
	end
	return false
end

---Checks if effect should be loaded in any case
---@param effect_id string
---@return boolean
local function is_forced(effect_id)
	for i = 1, #force_load do
		if effect_id == force_load[i] then return true end
	end
	return false
end

---parses status
---@param status_effect ML_gameEffect
local function parse_status(status_effect)
	local id = status_effect.id
	if is_ignored(id) then return end
	if status_effect.is_harmful and not is_forced(id) then return end
	status.list[id] = {
		id = id,
		ui_name = status_effect.ui_name,
		ui_description = status_effect.ui_description,
		ui_icon = status_effect.ui_icon,
		effect_entity = status_effect.effect_entity,
	}
end

---Parse status file
function status:parse()
	---@type ML_sandbox
	local sandbox = dofile("mods/meta_leveling/files/scripts/classes/private/sandbox.lua")
	sandbox:start_sandbox()

	dofile("data/scripts/status_effects/status_list.lua")
	for i = 1, #status_effects do ---@diagnostic disable-line: undefined-global
		parse_status(status_effects[i]) ---@diagnostic disable-line: undefined-global
	end

	sandbox:end_sandbox()
end

---Extends current status effect
---@param entity_id entity_id
---@param duration_to_add number in frames
function status:extend_effect(entity_id, duration_to_add)
	local component_id = EntityGetFirstComponent(entity_id, "GameEffectComponent")
	if not component_id then return end
	local current_duration = ComponentGetValue2(component_id, "frames")
	ComponentSetValue2(component_id, "frames", current_duration + duration_to_add)
end

---Adds new status effect to entity
---@param entity entity_id
---@param effect ML_gameEffect
---@param duration number in frames
function status:add_effect(entity, effect, duration)
	local id = effect.id
	if not id then return end

	local effect_entity = EntityCreateNew("META_LEVELING_BUFF_" .. id)
	EntityLoadToEntity(effect.effect_entity, effect_entity)
	local effect_component = EntityGetFirstComponent(effect_entity, "GameEffectComponent")
	if effect_component then ComponentSetValue2(effect_component, "frames", duration) end
	EntityAddComponent2(effect_entity, "UIIconComponent", {
		icon_sprite_file = effect.ui_icon,
		name = effect.ui_name or "",
		description = "[Meta Leveling]\n" .. (effect.ui_description or ""),
		is_perk = false,
	})
	EntityAddChild(entity, effect_entity)
end

---Apply status to player, extend current if already have or add new
---@param effect game_effect|ML_gameEffect
---@param duration number in frames
function status:apply_status_to_player(effect, duration)
	local player_id = EntityGetWithTag("player_unit")[1]
	if not player_id then return end
	local effect_data = self.list[effect] or effect ---@type ML_gameEffect
	local effect_id = effect_data.id ---@type game_effect
	local entity_name = "META_LEVELING_BUFF_" .. effect_id
	local entity_id = EntityGetWithName(entity_name)
	local multiplier = 1 + (ModSettingGet("meta_leveling.progress_longer_buff") or 0) / 10
	if entity_id == 0 then
		self:add_effect(player_id, effect_data, duration * multiplier)
	else
		self:extend_effect(entity_id, duration * multiplier)
	end
end

status:parse()

return status
