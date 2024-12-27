local modify_perk_descriptions = {}
for i = 1, #perk_list do
	if perk_list[i].meta_leveling_hardmode then
		modify_perk_descriptions[#modify_perk_descriptions + 1] = perk_list[i].ui_description:gsub("%$", "")
	end
end

local function is_in_modify_description_pool(line)
	for i = 1, #modify_perk_descriptions do
		if line:find(modify_perk_descriptions[i]) then return true end
	end
	return false
end

---returns translation key at column
---@param line string line to parse
---@param column number target column
---@param iteration? number current column
---@return string
local function csv_get_value(line, column, iteration)
	iteration = iteration or 1
	local pattern = ""
	if line:sub(1, 1) == '"' then
		pattern = '%b""'
	else
		pattern = "(.-),"
	end
	if iteration == column then
		return line:match(pattern)
	else
		return csv_get_value(line:gsub(pattern, "", 1), column, iteration + 1)
	end
end

local game_translation_file = "data/translations/common.csv"
local translation_content = ModTextFileGetContent(game_translation_file)
local warning_text = {
	"",
	"This perk does not grant immunity at all.",
	"Этот перк не предоставляет иммунитет вообще.",
	"Este beneficio no otorga inmunidad en absoluto.",
	"Este perk não concede imunidade de forma alguma.",
	"Dieser Vorteil gewährt überhaupt keine Immunität.",
	"Ce perk n'accorde aucune immunité.",
	"Questo vantaggio non concede alcuna immunità.",
	"Ten perk nie zapewnia żadnej odporności.",
	"此效果完全不提供免疫。",
	"このパークはまったく免疫を提供しません。",
	"이 특전은 면역을 전혀 제공하지 않습니다.",
}

local new_content = ""
for line in translation_content:gmatch(".-\n") do
	if is_in_modify_description_pool(line) then
		local new_line = csv_get_value(line, 1)
		for i = 2, 12 do
			local value = csv_get_value(line, i)
			if value ~= "" then
				if value:find('^"') then
					value = value:sub(1, -2) .. "\\n" .. warning_text[i] .. '"'
				else
					value = value .. "\\n" .. warning_text[i]
				end
			end
			new_line = new_line .. "," .. value
		end
		new_content = new_content .. new_line .. ",,,,,,,,,,\n"
	end
end
local translation = translation_content .. "\n" .. new_content
ModTextFileSetContent(game_translation_file, translation:gsub("\r", ""):gsub("\n\n+", "\n"))
