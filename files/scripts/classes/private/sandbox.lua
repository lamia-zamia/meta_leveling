--- @class ML_sandbox
local sandbox = {
	old = {}
}

function sandbox:start_sandbox()
	for key, value in pairs(_G) do
		self.old[key] = value
	end
end

function sandbox:end_sandbox()
	for key, value in pairs(_G) do
		if self.old[key] ~= value then
			_G[key] = self.old[key]
		end
	end
end

return sandbox
