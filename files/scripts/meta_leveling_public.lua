---@class (exact) MetaLevelingPublic
---@field const ml_const
---@field get ML_get
---@field set ML_set
---@field exp ML_experience
---@field font ML_font
---@field points ML_points
local MLP = {
	const = dofile_once("mods/meta_leveling/files/scripts/classes/public/const.lua"),
	get = dofile_once("mods/meta_leveling/files/scripts/classes/public/get.lua"),
	set = dofile_once("mods/meta_leveling/files/scripts/classes/public/set.lua"),
	exp = dofile_once("mods/meta_leveling/files/scripts/classes/public/exp.lua"),
	font = dofile_once("mods/meta_leveling/files/scripts/classes/public/font.lua"),
	points = dofile_once("mods/meta_leveling/files/scripts/classes/public/meta_points.lua"),
}

---@param exp number number of exp to add BEFORE applying multiplier
---@param entity? entity_id entity id from which to popup exp
---@param message? string message to log, exp value will be added to the end
function MLP:AddExpGlobal(exp, entity, message)
	exp = self.exp:apply_multiplier(exp)
	if message and self.get:mod_setting_boolean("session_exp_log") then
		message = message .. exp
		GamePrint(message)
	end
	if entity and EntityGetIsAlive(entity) and self.get:mod_setting_boolean("session_exp_popup") then
		self.font:popup_exp(entity,	self.exp:format(exp), exp)
	end

	self.exp:add(exp)
end

return MLP

