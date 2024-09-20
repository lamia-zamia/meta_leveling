local MLP = dofile_once("mods/meta_leveling/files/scripts/meta_leveling_public.lua") ---@type MetaLevelingPublic
local points = MLP:CalculateMetaPointsOnSampo()
MLP.points:modify_current_currency(points)
