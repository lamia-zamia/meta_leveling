local UI_class = dofile_once("mods/meta_leveling/files/scripts/utilities/lib/ui_lib.lua")

---@class EB.const.anim
local anim_const = {
	max_alpha = 0.75,
	step = 0.01,
}

---@class EB.const
local const = {
	filler_clamp = 0.95,
	anim = anim_const
}

---@class EB.data.anim
local anim_data = {
	alpha = 0,
	direction = 1,
}

---@class EB.data
local data = {
	anim = anim_data,
	sound_played_level = {},
	play_sound = true,
	play_fx = true,
	animate_bar = true,
	health_length = 42,
	max_health = 4,
	perc = {
		x = 0,
		y = 0,
		show = true
	},
	tooltip_force = true,
}

---@class EB.bar
local bar = {
	red = 1,
	green = 1,
	blue = 1,
	thickness = 2,
	x = 0,
	y = 0,
	scale_x = 0,
	scale_y = 0,
}


---@class (exact) experience_bar:UI_class
---@field const EB.const
---@field data EB.data
---@field bar EB.bar
---@field DrawBarFunction function?
local EB = UI_class:new()
EB.const = const
EB.data = data
EB.bar = bar
EB.DrawBarFunction = nil

return EB