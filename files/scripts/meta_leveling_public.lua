---@class MetaLevelingPublic
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
		self.font:popup_exp(entity, self.exp:format(exp), exp)
	end

	self.exp:add(exp)
end

---@param exp number number of exp to add BEFORE applying multiplier
---@param quest? string quest name
function MLP:QuestCompleted(exp, quest)
	local message = GameTextGetTranslatedOrNot("$ml_quest_done")
	local gained = GameTextGetTranslatedOrNot("$ml_gained_xp")
	local player_id = EntityGetWithTag("player_unit")[1]
	if quest then
		quest = ": " .. quest
	else
		quest = ""
	end
	MLP:AddExpGlobal(exp, player_id, message .. quest .. ", " .. gained .. ": ")
end

---Calculates bonus points for orbs
---@private
---@return number
function MLP:CalculateMetaPointsOrbs()
	---Points for basic win, orbs and NG
	local newgame_n = tonumber(SessionNumbersGetValue("NEW_GAME_PLUS_COUNT"))
	local orb_count = GameGetOrbCountThisRun()
	local exponent = orb_count + newgame_n ^ 0.5
	return 1.15 ^ exponent
end

---Calculates bonus points for speedruns
---@private
---@return number
function MLP:CalculateMetaPointsSpeedBonus()
	local minutes = GameGetFrameNum() / 60 / 60
	if minutes <= 5 then
		return 20
	else
		return math.max(4 - minutes / 5, 0)
	end
end

---Calculates points for pacifist run
---@private
---@return number
function MLP:CalculateMetaPointsPacifistBonus()
	local kills = tonumber(StatsGetValue("enemies_killed"))
	if kills == 0 then
		return 50
	else
		return math.max(5 - kills / 10, 0)
	end
end

---Returns a number of points you will get for using a sampo
---@return number
function MLP:CalculateMetaPointsOnSampo()
	local points = 0
	points = points + self:CalculateMetaPointsOrbs()
	points = points + self:CalculateMetaPointsSpeedBonus()
	points = points + self:CalculateMetaPointsPacifistBonus()
	return math.floor(points)
end

return MLP
