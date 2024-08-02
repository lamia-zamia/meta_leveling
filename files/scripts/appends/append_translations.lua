local game_translation_file = "data/translations/common.csv"
local mod_translation_file = "mods/meta_leveling/files/translation/translations.csv"
local translations = ModTextFileGetContent(game_translation_file)
local new_translations = ModTextFileGetContent(mod_translation_file)
translations = translations .. "\n" .. new_translations .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent(game_translation_file, translations)