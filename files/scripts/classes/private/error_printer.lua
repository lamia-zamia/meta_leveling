---@class ml_error_printer
local err = {}


---Logs an error message with an optional custom text.
---@param text? string
function err:print(text)
	print("\27[31m[Meta Leveling Error]\27[0m")
	print("[Meta Leveling]: error - " .. (text or "unknown error"))
end

return err