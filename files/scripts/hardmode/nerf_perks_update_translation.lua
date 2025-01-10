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

--- Returns the value at the specified column in a CSV line
---@param line string The CSV line to parse
---@param column number The target column to extract
---@return string The value at the specified column, or nil if not found
local function csv_get_value(line, column)
	local current_column = 1
	local start_index = 1
	local in_quotes = false

	for i = 1, #line do
		local char = line:sub(i, i)

		-- Handle quoted fields
		if char == '"' and not in_quotes then
			in_quotes = true
		elseif char == '"' and in_quotes then
			in_quotes = false
		elseif char == "," and not in_quotes then
			-- End of a field
			if current_column == column then return line:sub(start_index, i - 1) end
			current_column = current_column + 1
			start_index = i + 1
		end
	end

	-- Handle the last field
	if current_column == column then return line:sub(start_index) end

	return "parse_error" -- Column not found
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
