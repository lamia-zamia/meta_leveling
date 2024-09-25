local UI_class = dofile_once("mods/meta_leveling/files/scripts/lib/ui_lib.lua") ---@type UI_class

---@class LU.const
local const = {
	ui_9piece = "mods/meta_leveling/files/gfx/ui/ui_9piece.png",
	ui_9piece_gray = "mods/meta_leveling/files/gfx/ui/ui_9piece_gray.png",
	ui_9p_reward = "mods/meta_leveling/files/gfx/ui/ui_9piece_reward.png",
	ui_9p_reward_hl = "mods/meta_leveling/files/gfx/ui/ui_9piece_reward_highlight.png",
	ui_9p_button = "mods/meta_leveling/files/gfx/ui/ui_9piece_button.png",
	ui_9p_button_hl = "mods/meta_leveling/files/gfx/ui/ui_9piece_button_highlight.png",
	ui_9p_button_important = "mods/meta_leveling/files/gfx/ui/ui_9piece_button_important.png",
	height = 180,
	width = 320,
	sprite_offset = 20,
	reward_box_size = 24,
	z = -1000,
}

---@class LU.data
---@field reward_list? ml_reward_id[]
local data = {
	mLastDamageFrame = -120,
	mButtonLastFrameFire = -2,
	reward_list = nil,
	DrawWindow = nil,
	x = 0,
	y = 0,
	CloseOnShot = false,
	CloseOnDamage = false,
	SkipMenuOnPending = true,
	hotkey = 0,
	on_death = true,
	credits_frame = 0
}

---@class LU.anim
local anim = {
	rewards = {
		reset = false,
		frame = 0,
	},
	header = {
		reset = false,
		frame = 0,
	},
	window = {
		reset = false,
		frame = 0
	}
}

---@class level_ui:UI_class
---@field private const LU.const
---@field private data LU.data
---@field private anim LU.anim
---@field private DrawWindow function?
local LU = UI_class:New()
LU.buttons.img = const.ui_9p_button
LU.buttons.img_hl = const.ui_9p_button_hl
LU.scroll.scroll_img = "mods/meta_leveling/files/gfx/ui/ui_9piece_scrollbar.png"
LU.scroll.scroll_img_hl = "mods/meta_leveling/files/gfx/ui/ui_9piece_scrollbar_hl.png"
LU.scroll.width = const.width
LU.const = const
LU.data = data
LU.anim = anim
LU.DrawWindow = nil

return LU