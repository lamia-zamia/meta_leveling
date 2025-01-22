local add = {
	["data/entities/props/temple_statue_01.xml"] = 1,
	["data/entities/props/temple_statue_02.xml"] = 1,
}

for k, v in pairs(add) do
	CustomExpEntities[k] = v
end
