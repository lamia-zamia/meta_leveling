local function ReplaceFunction(file, search, replace)
	local content = ModTextFileGetContent(file)
	local new = content:gsub(search, replace)
	ModTextFileSetContent(file, new)
end

local function ReplaceFunctionGetFromFile(file, search, replace)
	local content = ModTextFileGetContent(file)
	local new = content:gsub(search, ModTextFileGetContent(replace))
	ModTextFileSetContent(file, new)
end

return {
	replace_by_string = ReplaceFunction,
	replace_by_file = ReplaceFunctionGetFromFile
}
