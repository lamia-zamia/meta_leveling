---@class (exact) ml_gun_parser
---@field trigger_hit_world string[]
---@field trigger_timer string[]
---@field trigger_death string[]
---@field heal_spells table
---@field drill_spells string[]
---@field spells_no_spawn table
---@field locked_spells table
---@field glimmers string[]
local guns = {
	trigger_hit_world = {},
	trigger_timer = {},
	trigger_death = {},
	heal_spells = dofile_once("mods/meta_leveling/files/scripts/compatibility/heal_spell_list.lua"),
	drill_spells = { "DIGGER", "POWERDIGGER" },
	spells_no_spawn = {},
	locked_spells = {},
	glimmers = {},
}

---List of actions to ignore
local ignore_list = {
	"RANDOM_PROJECTILE"
}

---Temporary variable for passing action types
local buffer = {
	xml_file = nil,
	type = nil
}

---Inserts action into according table
---@param key string
---@param action_id string
local function guns_insert(key, action_id)
	guns[key][#guns[key] + 1] = action_id
end

---Checks if action should be ignored
---@private
---@param action_id string
---@return boolean
local function ignore_action(action_id)
	for _, action in ipairs(ignore_list) do
		if action_id == action then return true end
	end
	return false
end

--	i was trying to parse healing spells, but it's too complicated, maybe later
--[[
---@type nxml
local nxml = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/nxml.lua")

---Analize projectile component
---@param tree element
local function analize_xml_projectile_component(action_id, tree)
	for projectile_component in tree:each_of("ProjectileComponent") do
		for element in projectile_component:each_of("damage_by_type") do
			local heal_dmg = tonumber(element.attr.healing)
			if heal_dmg then guns_insert("heal_spells", action_id) end
		end
	end
end

---Analize projectiles xml
---@param xml_file string
local function analize_xml(action_id, xml_file)
	local xml = nxml.parse(ModTextFileGetContent(xml_file))
	analize_xml_projectile_component(action_id, xml)
	for base in xml:each_of("Base") do
		analize_xml_projectile_component(action_id, base)
	end
end
]]

---Parse action
---@private
---@param action action
local function parse_action(action)
	if action.spawn_probability == "0" then guns.spells_no_spawn[action.id] = true end
	local flag = action.spawn_requires_flag
	if flag and not HasFlagPersistent(flag) then guns.locked_spells[action.id] = flag end
	if action.id:find("COLOUR") then guns_insert("glimmers", action.id) end
	if ignore_action(action.id) then return end
	if action.type == 0 then
		local success, err = pcall(action.action)
		if success then
			if buffer.type then guns_insert(buffer.type, action.id) end
			-- if buffer.xml_file then analize_xml(action.id, buffer.xml_file) end
		elseif ModSettingGet("meta_leveling.show_debug") then
			print("[Gun Parser Error] during parsing action " .. action.id)
			print(err)
		end
		-- shot_effects = { recoil_knockback = 0 } --copi, why?
		buffer = {
			-- xml_file = nil,
			type = nil
		}
	end
end

---Overwrites some functions
local function overwrite_functions()
	function BeginProjectile(entity_filename)
		-- buffer.xml_file = entity_filename
	end

	function BeginTriggerTimer()
		buffer.type = "trigger_timer"
	end

	function BeginTriggerDeath()
		buffer.type = "trigger_death"
	end

	function BeginTriggerHitWorld()
		buffer.type = "trigger_hit_world"
	end

	function add_projectile(entity_filename)
		BeginProjectile(entity_filename)
	end

	function add_projectile_trigger_timer(entity_filename)
		BeginProjectile(entity_filename)
		BeginTriggerTimer()
	end

	function add_projectile_trigger_hit_world(entity_filename)
		BeginProjectile(entity_filename)
		BeginTriggerHitWorld()
	end

	function add_projectile_trigger_death(entity_filename)
		BeginProjectile(entity_filename)
		BeginTriggerDeath()
	end
end

---Shadows functions so they won't do anything
local function shadow_functions()
	local nilfn = function() end
	local functions_to_shadow = {
		"EndProjectile",
		"StartReload",
		"EntityLoad",
		"EntityAddChild",
		"EntityAddRandomStains",
		"RegisterGunAction",
		"SetProjectileConfigs",
		"EndTrigger",
		"OnActionPlayed",
		"ComponentGetValue2",
		"GameGetGameEffectCount",
		"GetUpdatedEntityID",
		"GameScreenshake",
		"GamePlaySound",
		"GamePrint",
		"GamePrintImportant",
		"EntityGetTransform",
		"EntityGetAllChildren",
		"dofile_once",
		"EntityGetRootEntity"
	}

	for _, fn in ipairs(functions_to_shadow) do
		_G[fn] = nilfn
	end
end

---Sandbox
function guns:parse_actions()
	local __G = {}
	for key, value in pairs(_G) do
		__G[key] = value
	end
	-- ###############################################################
	-- #################		SANDBOX START		##################
	-- ###############################################################

	dofile("data/scripts/gun/gunaction_generated.lua")
	dofile("data/scripts/gun/gun_generated.lua")
	dofile("data/scripts/gun/gunshoteffects_generated.lua")
	dofile("data/scripts/gun/gun.lua")

	shadow_functions()
	overwrite_functions()

	root_shot = create_shot(1) ---@diagnostic disable-line: undefined-global
	c = root_shot.state

	shot_effects = { recoil_knockback = 0 }


	for _, action in ipairs(actions) do ---@diagnostic disable-line: undefined-global
		parse_action(action)
	end

	buffer = nil
	-- ###############################################################
	-- #################		SANDBOX END			##################
	-- ###############################################################
	for key, value in pairs(_G) do
		if __G[key] ~= value then
			_G[key] = __G[key]
		end
	end
	__G = nil
end

---check if player can have this spell
---@param action_id string
---@return boolean
function guns:spell_is_valid(action_id)
	if self.spells_no_spawn[action_id] then return false end
	if self.locked_spells[action_id] and not HasFlagPersistent(self.locked_spells[action_id]) then
		return false
	end
	return true
end

---returns a valid spell from list
---@param list string[]
---@return string action_id
function guns:get_random_from_list(list)
	local length = #list
	local index = Random(1, length)
	for _ = 1, length do
		if self:spell_is_valid(list[index]) then return list[index] end
		index = index % length + 1
	end
	return "OCARINA_A"
end

---return random spells of level
---@param level number
---@return string action_id
function guns:get_random_spell(level)
	if level > 6 then level = 10 end
	for i = 1, 1000 do
		local action_id = GetRandomAction(ML.player.x, ML.player.y, level, i)
		if self:spell_is_valid(action_id) then
			return action_id
		end
	end
	return "OCARINA_A"
end

---return random typed spells of level
---@param level number
---@param type number
---@return string action_id
function guns:get_random_typed_spell(level, type)
	if level > 6 then level = 10 end
	for i = 1, 1000 do
		local action_id = GetRandomActionWithType(ML.player.x, ML.player.y, level, type, i)
		if self:spell_is_valid(action_id) then
			return action_id
		end
	end
	return "OCARINA_A"
end

return guns
