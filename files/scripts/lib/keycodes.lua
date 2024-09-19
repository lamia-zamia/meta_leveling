---@enum mouse_keys
local mouse = {
	lc = 1,
	rc = 2,
	mc = 3,
	wheel_up = 4,
	wheel_down = 5,
}

---@enum keyboard_keys
local keyboard = {
	space = 44,
	enter = 40,
	escape = 41,
	lshift = 225,
}

---@class keycodes
local keycodes = {
	mouse = mouse,
	keyboard = keyboard
}

return keycodes
