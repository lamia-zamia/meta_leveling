local game_translation_file = "data/translations/common.csv"
local mod_translation_files = {
	"mods/meta_leveling/files/translation/translation_ui.csv",
	"mods/meta_leveling/files/translation/translation_rewards.csv",
	"mods/meta_leveling/files/translation/translation_meta.csv",
	"mods/meta_leveling/files/translation/translation_general.csv",
}

-- Read game translations
local translations = ModTextFileGetContent(game_translation_file)

-- Read mod translations
local ml_translation_contents = {}
for i = 1, #mod_translation_files do
	ml_translation_contents[#ml_translation_contents + 1] = ModTextFileGetContent(mod_translation_files[i])
end
local ml_translation = table.concat(ml_translation_contents, "\n")
ml_translation_contents = nil

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

--- Apply custom language translations
---@param csv_column number
---@return string
local function apply_to_custom_language(csv_column)
	local result = {}
	for line in ml_translation:gmatch("[^\r\n]+") do
		local locale_key = csv_get_value(line, 1)
		local custom_language = csv_get_value(line, csv_column)
		local english = csv_get_value(line, 2)
		result[#result + 1] = string.format('%s,"%s","%s",,,,,,,,,,', locale_key, custom_language, english)
	end
	return table.concat(result, "\n")
end

-- Check if custom language is active
local current_language = GameTextGetTranslatedOrNot("$current_language")
local custom_languages = {
	{
		translated = {
			"русский(Neonomi)",
			"русский(Сообщество)",
		},
		csv_column = 3,
	},
}

local append_translation = ml_translation
for _, language in ipairs(custom_languages) do
	for _, language_translated in ipairs(language.translated) do
		if current_language == language_translated then append_translation = apply_to_custom_language(language.csv_column) end
	end
end

-- Finalize and set translations
translations = translations .. "\n" .. append_translation .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")

ModTextFileSetContent(game_translation_file, translations)
