---@diagnostic disable: missing-global-doc, lowercase-global

local meta = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua")

function on_open()
	local entity_item = GetUpdatedEntityID()
	local _, y = EntityGetTransform(entity_item)

	local base = y / 150 + (y / 500) ^ 2
	local exp = math.ceil(base / 15) * 10
	meta:QuestCompleted(exp)
end

function item_pickup(entity_item, entity_who_picked, name)
	on_open()
end

function physics_body_modified(is_destroyed)
	on_open()
end
