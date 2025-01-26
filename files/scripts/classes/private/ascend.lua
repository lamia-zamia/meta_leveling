--- @class ml_ascend
--- @field private get ML_get
--- @field private set ML_set
--- @field private const ml_const
--- @field private exp ML_experience
local ascend = {
	get = dofile_once("mods/meta_leveling/files/scripts/classes/public/get.lua"),
	set = dofile_once("mods/meta_leveling/files/scripts/classes/public/set.lua"),
	const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua"),
	exp = dofile_once("mods/meta_leveling/files/scripts/classes/public/exp.lua"),
}

--- Returns required level for ascension
--- @return number
function ascend:get_required_level()
	return 80 + self.get:global_number("ASCEND", 0) * 10
end

--- Checks if you still can ascend this run
--- @return boolean
function ascend:is_available()
	return self.get:global_number("ASCEND", 0) < self.get:mod_setting_number("progress_ascension")
end

--- Checks if you can ascend
--- @return boolean
function ascend:can_ascend()
	local level = self.get:global_number(self.const.globals.current_level, 1)
	local required_level = self:get_required_level()
	return level >= required_level
end

--- Sets globals
--- @private
function ascend:set_globals()
	self.set:global_number(self.const.globals.current_exp, 0)
	self.set:global_number(self.const.globals.current_level, 1)
	self.set:global_number(self.const.globals.exp_on_levelup, 0)
	self.set:global_number(self.const.globals.fx_played, 1)

	GlobalsSetValue("TEMPLE_SPAWN_GUARDIAN", "0")
	GlobalsSetValue("STEVARI_DEATHS", "0")

	if ModSettingGet("meta_leveling.hardmode_enabled") then
		GlobalsSetValue("BOSS_MEAT_DEAD", "0")
	else
		GlobalsSetValue("TEMPLE_PERK_REROLL_COUNT", "0")
	end

	local ascend_count = self.get:global_number("ASCEND", 0)
	self.set:global_number("ASCEND", ascend_count + 1)
end

--- Ascend
function ascend:ascend()
	local player = EntityGetWithTag("player_unit")[1]
	if not player then return end

	self:set_globals()

	local map = SessionNumbersGetValue("BIOME_MAP")
	local map_script = SessionNumbersGetValue("BIOME_MAP_PIXEL_SCENES")
	local start_x = tonumber(MagicNumbersGetValue("DESIGN_PLAYER_START_POS_X")) or 227
	local start_y = tonumber(MagicNumbersGetValue("DESIGN_PLAYER_START_POS_Y")) or -85

	EntitySetTransform(player, start_x, start_y)
	BiomeMapLoad_KeepPlayer(map, map_script)
end

return ascend
