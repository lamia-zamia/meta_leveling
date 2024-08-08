local entities = {}

local bases = {
	"data/entities/base_humanoid.xml",
	"data/entities/base_helpless_animal.xml",
}
ML.utils:merge_tables(entities, bases)

local bosses = {
	"data/entities/animals/boss_dragon.xml",
	"data/entities/animals/boss_fish/fish_giga.xml",
	"data/entities/animals/maggot_tiny/maggot_tiny.xml",
}
ML.utils:merge_tables(entities, bosses)

local nests = {
	"data/entities/buildings/flynest.xml",
	"data/entities/buildings/firebugnest.xml",
	"data/entities/buildings/spidernest.xml",
}
ML.utils:merge_tables(entities, nests)

local wtf_are_these = {
	"data/entities/animals/shooterflower.xml",
	"data/entities/animals/worm.xml",
	"data/entities/animals/worm_big.xml",
	-- "data/entities/animals/lukki/lukki_creepy_long.xml",
	-- "data/entities/animals/lukki/lukki_creepy.xml",
	-- "data/entities/animals/lukki/lukki_dark.xml",
	-- "data/entities/animals/lukki/lukki_longleg.xml",
	-- "data/entities/animals/lukki/lukki_tiny.xml",
	-- "data/entities/animals/lukki/lukki.xml",
}
ML.utils:merge_tables(entities, wtf_are_these)

return entities
