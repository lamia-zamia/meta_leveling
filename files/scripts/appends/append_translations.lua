local game_translation_file = "data/translations/common.csv"
local mod_translation_file = "mods/meta_leveling/files/translation/translations.csv"
local translations = ModTextFileGetContent(game_translation_file)
local ml_translation = ModTextFileGetContent(mod_translation_file)
local append_translation = nil
local current_language = GameTextGetTranslatedOrNot("$current_language")
local custom_languages = {
	{
		translated = {
			"русский(Neonomi)",
			"русский(Сообщество)",
		},
		csv_column = 3
	}
}

---returns translation key at column
---@param line string line to parse
---@param column number target column
---@param iteration? number current column
---@return string
local function csv_get_value(line, column, iteration)
	iteration = iteration or 1
	local pattern = ""
	if line:sub(1, 1) == "\"" then
		pattern = "%b\"\""
	else
		pattern = "(.-),"
	end
	if iteration == column then
		return line:match(pattern)
	else
		return csv_get_value(line:gsub(pattern, "", 1), column, iteration + 1)
	end
end

---modify csv to have column number as english
---@param csv_column number
local function apply_to_custom_language(csv_column)
	append_translation = ""
	for line in ml_translation:gmatch(".-\n") do
		local locale_key = csv_get_value(line, 1)
		local custom_language = csv_get_value(line, csv_column)
		local english = csv_get_value(line, 2)
		append_translation = append_translation .. locale_key .. "," .. custom_language .. "," .. english .. ",,,,,,,,,,\n"
	end
end

---check if language at init is modded
for _, language in ipairs(custom_languages) do
	for _, language_translated in ipairs(language.translated) do
		if current_language == language_translated then
			apply_to_custom_language(language.csv_column)
		end
	end
end
append_translation = append_translation or ml_translation

translations = translations .. "\n" .. append_translation .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")

ModTextFileSetContent(game_translation_file, translations)