--- @type ml_error_printer
local err = dofile_once("mods/meta_leveling/files/scripts/classes/private/error_printer.lua")

--- @class (exact) ml_gun_parser
--- @field trigger_hit_world string[]
--- @field trigger_timer string[]
--- @field trigger_death string[]
--- @field heal_spells table
--- @field drill_spells string[]
--- @field spells_no_spawn table
--- @field locked_spells table
--- @field glimmers string[]
--- @field actions_data table
local guns = {
	trigger_hit_world = {},
	trigger_timer = {},
	trigger_death = {},
	heal_spells = dofile_once("mods/meta_leveling/files/scripts/compatibility/heal_spell_list.lua"),
	drill_spells = { "DIGGER", "POWERDIGGER" },
	spells_no_spawn = {},
	locked_spells = {},
	glimmers = {},
	actions_data = {
		types = {},
		icons = {}
	}
}

--- List of actions to ignore
local ignore_list = {
	"RANDOM_PROJECTILE"
}

--- Temporary variable for passing action types
local buffer = {
	xml_file = nil,
	type = nil
}

--- Inserts action into according table
--- @param key string
--- @param action_id string
local function guns_insert(key, action_id)
	guns[key][#guns[key] + 1] = action_id
end

--- Checks if action should be ignored
--- @private
--- @param action_id string
--- @return boolean
local function ignore_action(action_id)
	for i = 1, #ignore_list do
		if action_id == ignore_list[i] then return true end
	end
	return false
end

--- Categorizes action based on the numbers in their string fields.
--- @param action action
local function categorizeAction(action)
	local action_id = action.id
	if not action.spawn_level then
		if ModIsEnabled("component-explorer") then
			err:print("[Gun Parser Error] There is no spawn_level for " .. action_id)
		end
		return
	end
	local action_type = action.type
	local pattern_low = action.type == 4 and ",[1-3]," or ",[0-2],"
	local pattern_mid = action.type == 4 and ",[4-6]," or ",[3-5],"
	local pattern_high = ",[67],"
	local spawn_level = "," .. action.spawn_level .. ","
	local action_data = guns.actions_data.types[action_type]
	if spawn_level:find(pattern_low) then
		action_data.low[#action_data.low + 1] = action_id
	end
	if spawn_level:find(pattern_high) or spawn_level:find(",10,") then
		action_data.high[#action_data.high + 1] = action_id
	end
	if spawn_level:find(pattern_mid) then
		action_data.mid[#action_data.mid + 1] = action_id
	end
end

--- Parse action
--- @private
--- @param action action
local function parse_action(action)
	local action_id = action.id
	guns.actions_data.icons[action_id] = action.sprite
	if action.spawn_probability == "0" then
		guns.spells_no_spawn[action_id] = true
		return
	end
	local flag = action.spawn_requires_flag
	if flag and not HasFlagPersistent(flag) then
		-- if flag then -- HasFlagPersistent breaks with EW at this stage
		guns.locked_spells[action_id] = flag
		return
	end
	if action_id:find("COLOUR") then
		guns_insert("glimmers", action_id)
		return
	end
	if ignore_action(action.id) then return end
	if action.type == 0 then
		local success, error = pcall(action.action)
		if success then
			if buffer.type then
				guns_insert(buffer.type, action_id)
				buffer = { type = nil }
				return
			end
		elseif ModIsEnabled("component-explorer") then
			err:print("[Gun Parser Error] during parsing action " .. action_id)
			print(error)
		end
	end
	categorizeAction(action)
end

--- Overwrites some functions
local function overwrite_functions()
	--- @param entity_filename string
	function BeginProjectile(entity_filename)
		-- buffer.xml_file = entity_filename
	end

	--- Timer
	function BeginTriggerTimer()
		buffer.type = "trigger_timer"
	end

	--- On death
	function BeginTriggerDeath()
		buffer.type = "trigger_death"
	end

	--- Regular trigger
	function BeginTriggerHitWorld()
		buffer.type = "trigger_hit_world"
	end

	--- @param entity_filename string
	function add_projectile(entity_filename)
		BeginProjectile(entity_filename)
	end

	--- @param entity_filename string
	function add_projectile_trigger_timer(entity_filename)
		BeginProjectile(entity_filename)
		BeginTriggerTimer()
	end

	--- @param entity_filename string
	function add_projectile_trigger_hit_world(entity_filename)
		BeginProjectile(entity_filename)
		BeginTriggerHitWorld()
	end

	--- @param entity_filename string
	function add_projectile_trigger_death(entity_filename)
		BeginProjectile(entity_filename)
		BeginTriggerDeath()
	end

	--- @param ... any
	--- @return number, number
	function EntityGetTransform(...)
		return 0, 0
	end
end

--- Shadows functions so they won't do anything
local function shadow_functions()
	local nil_fn = function() end
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
		-- "EntityGetTransform",
		"EntityGetAllChildren",
		"dofile_once",
		"EntityGetRootEntity",
		"GlobalsGetValue",
		"tonumber"
	}

	for i = 1, #functions_to_shadow do
		_G[functions_to_shadow[i]] = nil_fn
	end
end

--- Sandbox
function guns:parse_actions()
	for i = 0, 7 do
		self.actions_data.types[i] = {
			low = {},
			mid = {},
			high = {}
		}
	end

	--- @type ML_sandbox
	local sandbox = dofile_once("mods/meta_leveling/files/scripts/classes/private/sandbox.lua")
	sandbox:start_sandbox()
	-- ###############################################################
	-- #################		SANDBOX START		##################
	-- ###############################################################
	dofile_once = dofile
	dofile("data/scripts/gun/gunaction_generated.lua")
	dofile("data/scripts/gun/gun_generated.lua")
	dofile("data/scripts/gun/gunshoteffects_generated.lua")
	dofile("data/scripts/gun/gun.lua")
	shadow_functions()
	overwrite_functions()

	root_shot = create_shot(1) --- @diagnostic disable-line: undefined-global
	c = root_shot.state

	shot_effects = { recoil_knockback = 0 }

	for i = 1, #actions do --- @diagnostic disable-line: undefined-global
		parse_action(actions[i])
	end

	buffer = nil
	-- ###############################################################
	-- #################		SANDBOX END			##################
	-- ###############################################################
	sandbox:end_sandbox()
end

--- check if player can have this spell
--- @param action_id string
--- @return boolean
function guns:spell_is_valid(action_id)
	if self.spells_no_spawn[action_id] then return false end
	if self.locked_spells[action_id] and not HasFlagPersistent(self.locked_spells[action_id]) then
		return false
	end
	return true
end

--- returns a valid spell from list
--- @param list string[]
--- @return string action_id
function guns:get_random_from_list(list)
	local length = #list
	local index = Random(1, length)
	for _ = 1, length do
		if self:spell_is_valid(list[index]) then return list[index] end
		index = index % length + 1
	end
	return "OCARINA_A"
end

--- return random spells of level
--- @param level number
--- @return string action_id
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

--- return random typed spells of level
--- @param level number
--- @param type number
--- @return string action_id
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
