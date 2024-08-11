---@class (exact) ml_player
---@field id entity_id|nil
---@field x number
---@field y number
---@field mLastDamageFrame number last frame when received damage
---@field mButtonLastFrameFire number last frame when we shoot
---@field max_hp number max hp
---@field hp number
---@field absent_hp_percent number
---@field air_in_lungs number
---@field air_in_lungs_max number
---@field drowning boolean
local player = {
	id = nil,
	x = 0,
	y = 0,
	mLastDamageFrame = -120,
	mButtonLastFrameFire = -2,
	max_hp = 4,
	hp = 4,
	absent_hp_percent = 0,
	air_in_lungs = 5,
	air_in_lungs_max = 5,
	drowning = false,
}

---returns player id
---@return entity_id? player_id
function player:get_id()
	return EntityGetWithTag("player_unit")[1]
end

---checks player id and return false if player is not found
---@return boolean
function player:validate()
	if not EntityGetIsAlive(self.id) then self.id = self:get_id() end
	if EntityGetIsAlive(self.id) then return true
	else return false end
end

---returns player x, y
---@return number x, number y
function player:get_pos()
	if not self:validate() then return 0, 0 end
	local x, y = EntityGetTransform(self.id)
	return x, y
end

---return first wand in inventory
---@return entity_id?
function player:get_first_wand()
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
function player:get_hold_wand(look_for_first)
	if not self:validate() then return end
	local inventory2_comp = EntityGetFirstComponentIncludingDisabled(self.id, "Inventory2Component")
	if inventory2_comp then
		local active_item = ComponentGetValue2(inventory2_comp, "mActiveItem")
		if EntityHasTag(active_item, "wand") then return active_item end
	end
	if look_for_first then
		return self:get_first_wand()
	else
		return nil
	end
end

---returns player's component id of name
---@param name component_type
---@return component_id?
function player:get_component_by_name(name)
	if not self:validate() then return nil end
	return EntityGetFirstComponentIncludingDisabled(self.id, name)
end

---add lua component if absent
---@param value LuaComponent
function player:add_lua_component_if_none(value, file)
	if not self:validate() then return end
	local components = EntityGetComponentIncludingDisabled(self.id, "LuaComponent") or {}
	for _, component in ipairs(components) do
		if ComponentGetValue2(component, value) == file then return end
	end
	local comp = EntityAddComponent2(self.id, "LuaComponent")
	ComponentSetValue2(comp, value, file)
end

---get specific LuaComponent id
---@param value LuaComponent
function player:get_lua_component(value, file)
	if not self:validate() then return end
	local components = EntityGetComponentIncludingDisabled(self.id, "LuaComponent") or {}
	for _, component in ipairs(components) do
		if ComponentGetValue2(component, value) == file then return component end
	end
	return nil
end

---@return component_id?
function player:get_damagemodel()
	return self:get_component_by_name("DamageModelComponent")
end

---return player's DamageModelComponent field value
---@param field DamageModelComponent
---@return any|nil
function player:get_damagemodel_value(field)
	local component = self:get_damagemodel()
	if not component then return nil end
	return ComponentGetValue2(component, field)
end

---@param field DamageModelComponent
---@param default number
function player:get_damagemodel_value_number(field, default)
	local value = self:get_damagemodel_value(field)
	if type(value) == "number" then return value
	else return default end
end

---@param field ControlsComponent
---@return any|nil
function player:get_controlscomponent_value(field)
	local component = self:get_component_by_name("ControlsComponent")
	if not component then return nil end
	return ComponentGetValue2(component, field)
end

---@return number
function player:get_mButtonLastFrameFire()
	local value = self:get_controlscomponent_value("mButtonLastFrameFire")
	if type(value) == "number" then return value
	else return -2 end
end

function player:update()
	if self:validate() then
		self.x, self.y = self:get_pos()
		self.mLastDamageFrame = self:get_damagemodel_value_number("mLastDamageFrame", -120)
		self.mButtonLastFrameFire = self:get_mButtonLastFrameFire()
		self.max_hp = self:get_damagemodel_value_number("max_hp", 4)
		self.hp = self:get_damagemodel_value_number("hp", 4)
		self.absent_hp_percent = 1 - self.hp / self.max_hp
		self.air_in_lungs_max = self:get_damagemodel_value_number("air_in_lungs_max", 5)
		self.air_in_lungs = self:get_damagemodel_value_number("air_in_lungs", 5)
		self.drowning = self.air_in_lungs ~= self.air_in_lungs_max
	end
end

return player