---@class (exact) ml_player
---@field id entity_id|nil
---@field x number
---@field y number
local player = {
	id = nil,
	x = 0,
	y = 0
}

function player:validate()
	if not self.id then self.id = self:get_id() end
	if self.id then return true
	else return false end
end

---returns player id
---@return entity_id? player_id
function player:get_id()
	local player_id = EntityGetWithTag("player_unit")[1]
	if EntityGetIsAlive(player_id) then
		return player_id
	else
		return nil
	end
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

return player