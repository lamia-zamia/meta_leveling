---@class ML_sandbox
local sandbox = {
	old = {},
	dofile = {},
}

function sandbox:start_sandbox()
	for key, value in pairs(_G) do
		self.old[key] = value
	end
	self.dofile = {}
	for k, v in pairs(__loadonce) do
		self.dofile[k] = v
	end
end

function sandbox:end_sandbox()
	for key, value in pairs(_G) do
		if self.old[key] ~= value then _G[key] = self.old[key] end
	end
	__loadonce = {} ---@diagnostic disable-line: name-style-check
	for k, v in pairs(self.dofile) do
		__loadonce[k] = v
	end
end

return sandbox
