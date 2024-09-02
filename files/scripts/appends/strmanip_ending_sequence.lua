local file = "data/entities/animals/boss_centipede/ending/sampo_start_ending_sequence.lua"
local content = ModTextFileGetContent(file)
local append = "dofile_once(\"mods/meta_leveling/files/scripts/appends/ending_sequence_append.lua\")"
ModTextFileSetContent(file, append .. "\n" .. content)