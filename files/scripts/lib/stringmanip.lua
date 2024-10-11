--- @class StringManip
--- @field file string file path
--- @field content string file content
--- @field private __index StringManip
local SM = {}
SM.__index = SM

--- Creates a new StringManip instance and loads the file content.
--- @param file string The file path to read and manipulate.
--- @return StringManip StringManip A new instance of the StringManip class.
function SM:new(file)
	local success, content_or_err = pcall(ModTextFileGetContent, file)
	if success and content_or_err then
		local o = setmetatable({}, self)
		o.file = file
		o.content = content_or_err
		return o
	else
		error("couldn't read " .. file .. ", error: " .. content_or_err)
	end
end

--- Appends dofile_once(file) before the current file content.
--- @param file string The file path to dofile_once
function SM:AppendDofileOnceBefore(file)
	local text = "dofile_once(\"" .. file .. "\")"
	self:AppendBefore(text)
end

--- Appends dofile(file) before the current file content.
--- @param file string The file path to dofile
function SM:AppendDofileBefore(file)
	local text = "dofile(\"" .. file .. "\")"
	self:AppendBefore(text)
end

--- Appends content before the current file content.
--- @param text string The text to append before the existing content.
function SM:AppendBefore(text)
	self.content = text .. "\n" .. self.content
end

--- Replaces occurrences of a pattern in the file content.
--- @param pattern string The pattern to search for.
--- @param replacement string The replacement text.
--- @param n? number How many times to replace
function SM:Replace(pattern, replacement, n)
	self.content = self.content:gsub(pattern, replacement, n)
end

--- Inserts text before a specific line containing a search string.
--- @param searchString string The string to search for in each line.
--- @param textToInsert string The text to insert before the matching line.
function SM:InsertBeforeLine(searchString, textToInsert)
	local lines = {}
	for line in self.content:gmatch("[^\r\n]+") do
		if line:find(searchString, 1, true) then
			lines[#lines + 1] = textToInsert
		end
		lines[#lines + 1] = line
	end
	self.content = table.concat(lines, "\n")
end

--- Inserts text after a specific line containing a search string.
--- @param searchString string The string to search for in each line.
--- @param textToInsert string The text to insert after the matching line.
function SM:InsertAfterLine(searchString, textToInsert)
	local lines = {}
	for line in self.content:gmatch("[^\r\n]+") do
		lines[#lines + 1] = line
		if line:find(searchString, 1, true) then
			lines[#lines + 1] = textToInsert
		end
	end
	self.content = table.concat(lines, "\n")
end

--- Writes the manipulated content back to the file.
function SM:Write()
	ModTextFileSetContent(self.file, self.content:gsub("\r", ""))
end

--- Destroys the current instance by clearing its fields.
function SM:Destroy()
	self.file = nil
	self.content = nil
	setmetatable(self, nil)
end

--- Writes the manipulated content back to the file and destroys the current instance by clearing its fields.
function SM:WriteAndClose()
	self:Write()
	self:Destroy()
end

return SM
