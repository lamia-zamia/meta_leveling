dofile_once("data/scripts/lib/mod_settings.lua")

local mod_id = "meta_leveling"
local mod_prfx = mod_id .. "."
local T = {}
local D = {}
local current_language_last_frame = nil
local in_main_menu = false

local mod_id_hash = 0
for c in mod_id:gmatch(".") do
	mod_id_hash = mod_id_hash + c:byte()
end

local gui_id = mod_id_hash * 1000
local function id()
	gui_id = gui_id + 1
	return gui_id
end

local const = {
	colors = {
		bg = {
			alpha = 0.7098039215686275,
			red = 0.47513812154696133,
			green = 0.2762430939226519,
			blue = 0.22099447513812157,
		},
		border = {
			alpha = 0.8509803921568627,
			red = 0.47465437788018433,
			green = 0.2764976958525346,
			blue = 0.22119815668202766,
		},
	},
	keycodes_file = "data/scripts/debug/keycodes.lua",
}

-- ###########################################
-- ############		Helpers		##############
-- ###########################################

local U = {
	whitebox = "data/debug/whitebox.png",
	empty = "data/debug/empty.png",
	offset = 0,
	max_y = 300,
	min_y = 50,
	keycodes = {},
	waiting_for_input = false,
}
do -- helpers
	--- Checks for winstreak flag and either resets or adds
	function U.check_for_winstreak()
		local win_flag_id = mod_prfx .. "streak_win"
		local streak_id = mod_prfx .. "streak_count"
		if ModSettingGet(win_flag_id) then
			local current = ModSettingGet(streak_id)
			ModSettingSet(streak_id, current + 1)
			ModSettingRemove(win_flag_id)
		else
			ModSettingSet(streak_id, 0)
		end
	end

	--- @param setting_name setting_id
	--- @param value setting_value
	function U.set_setting(setting_name, value)
		ModSettingSetNextValue(mod_prfx .. setting_name, value, false)
	end

	--- @param setting_name setting_id
	--- @param value setting_value
	function U.set_setting_force(setting_name, value)
		ModSettingSetNextValue(mod_prfx .. setting_name, value, false)
		ModSettingSet(mod_prfx .. setting_name, value)
	end

	--- @param setting_name setting_id
	--- @return setting_value?
	function U.get_setting(setting_name)
		return ModSettingGet(mod_prfx .. setting_name)
	end

	--- @param setting_name setting_id
	--- @return setting_value?
	function U.get_setting_next(setting_name)
		return ModSettingGetNextValue(mod_prfx .. setting_name)
	end

	--- @param array mod_settings_global|mod_settings
	--- @param gui gui
	--- @return number
	function U.calculate_elements_offset_get_max(array, gui)
		local max_width = 10
		for _, setting in ipairs(array) do
			if setting.category_id then
				local cat_max_width = U.calculate_elements_offset_get_max(setting.settings, gui)
				max_width = math.max(max_width, cat_max_width)
			end
			if setting.ui_name then
				local name_length = GuiGetTextDimensions(gui, setting.ui_name)
				max_width = math.max(max_width, name_length)
			end
		end
		return max_width
	end

	--- @param array mod_settings_global|mod_settings
	--- @return number
	function U.calculate_elements_offset(array)
		local gui = GuiCreate()
		GuiStartFrame(gui)
		local max_width = U.calculate_elements_offset_get_max(array, gui)
		GuiDestroy(gui)
		return max_width + 3
	end

	--- @param all boolean reset all
	function U.set_default(all)
		for setting, value in pairs(D) do
			if U.get_setting_next(setting) == nil or all then U.set_setting_force(setting, value) end
		end
	end

	--- gather keycodes from game file
	function U.gather_key_codes()
		U.keycodes = {}
		U.keycodes[0] = GameTextGetTranslatedOrNot("$menuoptions_configurecontrols_action_unbound")
		local keycodes_all = ModTextFileGetContent(const.keycodes_file)
		for line in keycodes_all:gmatch("Key_.-\n") do
			local _, key, code = line:match("(Key_)(.+) = (%d+)")
			U.keycodes[code] = key:upper()
		end
	end

	--- Resets settings
	function U.reset_settings()
		U.set_default(true)
	end

	--- Resets progress
	function U.reset_progress()
		local count = ModSettingGetCount()
		local progress_list = {}
		for i = 0, count do
			local setting_id = ModSettingGetAtIndex(i)
			if setting_id and setting_id:find("^meta_leveling%.reward_picked_") then progress_list[#progress_list + 1] = setting_id end
		end
		for i = 1, #progress_list do
			ModSettingRemove(progress_list[i])
		end
	end

	--- Resets meta
	function U.reset_meta()
		local count = ModSettingGetCount()
		local meta_list = {}
		for i = 0, count do
			local setting_id = ModSettingGetAtIndex(i)
			if setting_id and setting_id:find("^meta_leveling%.progress_") then meta_list[#meta_list + 1] = setting_id end
		end
		for i = 1, #meta_list do
			local setting_id = meta_list[i]
			ModSettingSet(setting_id, 0)
			ModSettingSetNextValue(setting_id, 0, false)
			ModSettingRemove(setting_id)
		end
		ModSettingRemove("meta_leveling.currency_progress")
	end

	--- Updates setting scope
	--- @param setting_id setting_id
	function U.mod_setting_update(setting_id)
		local next_value = U.get_setting_next(setting_id)
		if next_value ~= nil then ModSettingSet(mod_prfx .. setting_id, next_value) end
	end

	--- Checks mod settings
	--- @param setting mod_settings
	--- @param init_scope mod_setting_scopes
	function U.mod_setting_check(setting, init_scope)
		if setting.scope == nil or setting.scope >= init_scope then
			if setting.checkboxes then
				for i = 1, #setting.checkboxes do
					U.mod_setting_update(setting.checkboxes[i])
				end
			else
				U.mod_setting_update(setting.id)
			end
		end
	end

	--- Updates setting scope
	--- @param settings mod_settings_global
	--- @param init_scope mod_setting_scopes
	function U.mod_settings_update(settings, init_scope)
		for _, setting in ipairs(settings) do
			if setting.category_id then
				U.mod_settings_update(setting.settings, init_scope)
			elseif setting.id and not setting.not_setting then
				U.mod_setting_check(setting, init_scope)
			end
		end
	end
end
-- ###########################################
-- ##########		GUI Helpers		##########
-- ###########################################

local G = {}
do -- gui helpers
	function G.button_options(gui)
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.ClickCancelsDoubleClick)
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.ForceFocusable)
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.HandleDoubleClickAsClick)
	end

	--- @param gui gui
	--- @param hovered boolean
	function G.yellow_if_hovered(gui, hovered)
		if hovered then GuiColorSetForNextWidget(gui, 1, 1, 0.7, 1) end
	end

	--- @param gui gui
	--- @param x_pos number
	--- @param text string
	--- @param color? table
	--- @return boolean
	--- @nodiscard
	function G.button(gui, x_pos, text, color)
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
		GuiText(gui, x_pos, 0, "")
		local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
		text = "[" .. text .. "]"
		local width, height = GuiGetTextDimensions(gui, text)
		G.button_options(gui)
		GuiImageNinePiece(gui, id(), x, y, width, height, 0)
		local clicked, _, hovered = GuiGetPreviousWidgetInfo(gui)
		if color then
			local r, g, b = unpack(color)
			GuiColorSetForNextWidget(gui, r, g, b, 1)
		end
		G.yellow_if_hovered(gui, hovered)
		GuiText(gui, x_pos, 0, text)
		return clicked
	end

	--- @param gui gui
	--- @param setting_name setting_id
	--- @param setting_scope mod_setting_scopes
	--- @return boolean, boolean
	function G.toggle_checkbox_boolean(gui, setting_name, setting_scope)
		local text = T[setting_name]
		local _, _, _, prev_x, y, prev_w = GuiGetPreviousWidgetInfo(gui)
		local x = prev_x + prev_w + 1
		local value = U.get_setting_next(setting_name) ---@cast value boolean
		local offset_w = GuiGetTextDimensions(gui, text) + 8

		GuiZSetForNextWidget(gui, -1)
		G.button_options(gui)
		GuiImageNinePiece(gui, id(), x + 2, y, offset_w, 10, 10, U.empty, U.empty) -- hover box
		G.tooltip(gui, setting_name, setting_scope)
		local _, _, hovered = GuiGetPreviousWidgetInfo(gui)
		GuiZSetForNextWidget(gui, 1)
		GuiImageNinePiece(gui, id(), x + 2, y + 2, 6, 6) -- check box

		GuiText(gui, 4, 0, "")
		if value then
			GuiColorSetForNextWidget(gui, 0, 0.8, 0, 1)
			GuiText(gui, 0, 0, "V")
			GuiText(gui, 0, 0, " ")
			G.yellow_if_hovered(gui, hovered)
		else
			GuiColorSetForNextWidget(gui, 0.8, 0, 0, 1)
			GuiText(gui, 0, 0, "X")
			GuiText(gui, 0, 0, " ")
			G.yellow_if_hovered(gui, hovered)
		end
		GuiText(gui, 0, 0, text)
		return hovered, value
	end

	--- @param gui gui
	--- @param setting mod_setting_better_number
	--- @return number, number
	function G.mod_setting_number(gui, setting)
		GuiLayoutBeginHorizontal(gui, 0, 0, false, 0, 0)
		GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)
		local _, _, _, x_start, y_start = GuiGetPreviousWidgetInfo(gui)
		local w = GuiGetTextDimensions(gui, setting.ui_name)
		local default = D[setting.id]
		local value = tonumber(ModSettingGetNextValue(mod_setting_get_id(mod_id, setting))) or default
		local multiplier = setting.value_display_multiplier or 1
		local value_new = GuiSlider(gui, id(), U.offset - w, 0, "", value, setting.value_min, setting.value_max, default, multiplier, " ", 64)
		if setting.value_snap then value_new = math.floor(value_new / setting.value_snap + 0.5) * setting.value_snap end
		GuiColorSetForNextWidget(gui, 0.81, 0.81, 0.81, 1)
		local format = setting.format or ""
		local display_value = value * multiplier
		local text = display_value < 1 and string.format("%.2f%s", display_value, format) or string.format("%.0f%s", display_value, format)
		GuiText(gui, 3, 0, text)
		GuiLayoutEnd(gui)
		local _, _, _, x_end, _, t_w = GuiGetPreviousWidgetInfo(gui)
		GuiImageNinePiece(gui, id(), x_start, y_start, x_end - x_start + t_w, 8, 0, U.empty, U.empty)
		G.tooltip(gui, setting.id, setting.scope)
		return value, value_new
	end

	--- @param gui gui
	--- @param setting_name setting_id
	--- @param scope? mod_setting_scopes
	function G.tooltip(gui, setting_name, scope)
		local description = T[setting_name .. "_d"]
		local value = U.get_setting_next(setting_name)
		local value_now = U.get_setting(setting_name)

		if value ~= value_now and not in_main_menu then
			if scope == MOD_SETTING_SCOPE_RUNTIME_RESTART then
				if description then
					GuiTooltip(gui, description, "$menu_modsettings_changes_restart")
				else
					GuiTooltip(gui, "$menu_modsettings_changes_restart", "")
				end
				return
			elseif scope == MOD_SETTING_SCOPE_NEW_GAME then
				if description then
					GuiTooltip(gui, description, "$menu_modsettings_changes_worldgen")
				else
					GuiTooltip(gui, "$menu_modsettings_changes_worldgen", "")
				end
				return
			end
		end

		if description then GuiTooltip(gui, description, "") end
	end

	--- @param gui gui
	--- @param x number
	--- @param y number
	--- @param width number
	--- @param height number
	--- @param fn fun(gui:gui, width:number, height:number, ...:any)
	--- @param ... any
	function G.ImageClip(gui, x, y, width, height, fn, ...)
		GuiText(gui, x, y, " ")
		local _, _, _, _, prev_y = GuiGetPreviousWidgetInfo(gui)
		if prev_y + height > U.max_y then height = U.max_y - prev_y - 1 end
		if prev_y < U.min_y then
			height = prev_y - U.min_y + height
			y = y + U.min_y - prev_y
		end
		if height < 0 then return end
		GuiAnimateBegin(gui)
		GuiAnimateAlphaFadeIn(gui, id(), 0, 0, true)
		GuiBeginAutoBox(gui)

		GuiZSetForNextWidget(gui, 1000)
		GuiBeginScrollContainer(gui, id(), x, y, width, height, false, 0, 0)
		GuiEndAutoBoxNinePiece(gui)
		GuiAnimateEnd(gui)
		fn(gui, width, height, ...)
		GuiEndScrollContainer(gui)
	end

	--- EXP BAR BULLSHIT

	--- Draw borders
	--- @param gui gui
	--- @param width number
	--- @param height number
	function G.draw_outline(gui, width, height)
		GuiColorSetForNextWidget(gui, const.colors.border.red, const.colors.border.green, const.colors.border.blue, 1)
		GuiZSetForNextWidget(gui, 4)
		GuiImage(gui, id(), 0, 0, U.whitebox, const.colors.border.alpha, width / 20, height / 20)
	end

	--- Draw bar
	--- @param gui gui
	--- @param width number
	--- @param height number
	--- @param z number
	--- @param r number
	--- @param g number
	--- @param b number
	--- @param a number
	function G.draw_bar_color(gui, width, height, z, r, g, b, a)
		GuiColorSetForNextWidget(gui, r, g, b, 1)
		GuiZSetForNextWidget(gui, z)
		GuiImage(gui, id(), 0, 0, U.whitebox, a, width / 20, height / 20)
	end
end
-- ###########################################
-- ########		Settings GUI		##########
-- ###########################################

local S = {}
do -- Settings GUI
	--- Draws experience bar
	function S.draw_bar_position(_, gui, _, _, _)
		GuiOptionsAdd(gui, GUI_OPTION.Layout_NextSameLine)

		local thickness = 1 + tonumber(U.get_setting_next("exp_bar_thickness")) or D.exp_bar_thickness
		local position = U.get_setting_next("exp_bar_position")
		local x = mod_setting_group_x_offset + U.offset + 92
		local y = 8
		local r = tonumber(U.get_setting_next("exp_bar_red")) or D.exp_bar_red
		local g = tonumber(U.get_setting_next("exp_bar_green")) or D.exp_bar_green
		local b = tonumber(U.get_setting_next("exp_bar_blue")) or D.exp_bar_blue
		local no_bg = U.get_setting_next("exp_bar_default_bg")
		local bg_red = no_bg and const.colors.bg.red or r * 0.6
		local bg_green = no_bg and const.colors.bg.green or g * 0.6
		local bg_blue = no_bg and const.colors.bg.blue or b * 0.6
		local bg_alpha = no_bg and const.colors.bg.alpha or 1

		GuiText(gui, x, y + 5, " ")
		local _, _, _, x_no_layout, y_no_layout = GuiGetPreviousWidgetInfo(gui)

		GuiZSetForNextWidget(gui, 5)
		GuiImageNinePiece(gui, id(), x_no_layout, y_no_layout, 74, 38)

		--- Draw health
		G.ImageClip(gui, x + 15, y + 14, 44, 7, G.draw_outline)
		G.ImageClip(gui, x + 16, y + 15, 42, 5, G.draw_bar_color, 3, 0.53, 0.75, 0.1, 1)

		if position == "under_health" then
			G.ImageClip(gui, x + 15, y + 20.5, 44, thickness + 1, G.draw_outline)
			G.ImageClip(gui, x + 16, y + 20.5, 15, thickness, G.draw_bar_color, 2, r, g, b, 1)
			G.ImageClip(gui, x + 16, y + 20.5, 42, thickness, G.draw_bar_color, 3, bg_red, bg_green, bg_blue, bg_alpha)
		elseif position == "on_top" then
			G.ImageClip(gui, x + 15, y + 7, 44, thickness + 2, G.draw_outline)
			G.ImageClip(gui, x + 16, y + 8, 15, thickness, G.draw_bar_color, 2, r, g, b, 1)
			G.ImageClip(gui, x + 16, y + 8, 42, thickness, G.draw_bar_color, 3, bg_red, bg_green, bg_blue, bg_alpha)
		elseif position == "on_left" then
			G.ImageClip(gui, x + 2, y + 14, thickness + 2, 29.25, G.draw_outline)
			G.ImageClip(gui, x + 3, y + 32, thickness, 10.25, G.draw_bar_color, 2, r, g, b, 1)
			G.ImageClip(gui, x + 3, y + 15, thickness, 27.25, G.draw_bar_color, 3, bg_red, bg_green, bg_blue, bg_alpha)
		else
			G.ImageClip(gui, x + 66, y + 14, thickness + 2, 29.25, G.draw_outline)
			G.ImageClip(gui, x + 67, y + 32, thickness, 10.25, G.draw_bar_color, 2, r, g, b, 1)
			G.ImageClip(gui, x + 67, y + 15, thickness, 27.25, G.draw_bar_color, 3, bg_red, bg_green, bg_blue, bg_alpha)
		end

		if U.get_setting_next("exp_bar_show_perc") then GuiText(gui, x + 66, y + 5, "%") end
		GuiOptionsRemove(gui, GUI_OPTION.Layout_NextSameLine)
	end

	--- @param setting mod_setting_better_number
	--- @param gui gui
	function S.draw_bar_thickness(_, gui, _, _, setting)
		local position = U.get_setting_next("exp_bar_position")
		if position == "under_health" then
			setting.value_max = 2
			if U.get_setting_next(setting.id) > 2 then U.set_setting_force(setting.id, 2) end
		else
			setting.value_max = 4
		end
		local value, value_new = G.mod_setting_number(gui, setting)
		value_new = math.floor(value_new + 0.5)
		if value ~= value_new then U.set_setting_force(setting.id, value_new) end
	end

	--- @param setting mod_setting_better_number
	--- @param gui gui
	function S.mod_setting_number_float(_, gui, _, _, setting)
		local value, value_new = G.mod_setting_number(gui, setting)
		if value ~= value_new then U.set_setting(setting.id, value_new) end
	end

	--- @param setting mod_setting_better_number
	--- @param gui gui
	function S.mod_setting_number_integer(_, gui, _, _, setting)
		local value, value_new = G.mod_setting_number(gui, setting)
		value_new = math.floor(value_new + 0.5)
		if value ~= value_new then U.set_setting(setting.id, value_new) end
	end

	function S.mod_setting_better_string(_, gui, _, _, setting)
		local value = tostring(U.get_setting_next(setting.id))
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
		GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)
		GuiLayoutBeginHorizontal(gui, U.offset, 0, true, 0, 0)
		GuiText(gui, 8, 0, "")
		for _, button in ipairs(setting.buttons) do
			local color = value == button and { 0.7, 0.7, 0.7 } or nil
			if G.button(gui, 0, T[button], color) then U.set_setting(setting.id, button) end
		end
		GuiLayoutEnd(gui)
	end

	function S.mod_setting_better_boolean(_, gui, _, _, setting)
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
		GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)
		G.tooltip(gui, setting.id)
		GuiLayoutBeginHorizontal(gui, U.offset, 0, true, 0, 0)
		GuiText(gui, 7, 0, "")
		for _, setting_id in ipairs(setting.checkboxes) do
			local hovered, value = G.toggle_checkbox_boolean(gui, setting_id, setting.scope)
			if hovered then
				if InputIsMouseButtonJustDown(1) then U.set_setting(setting_id, not value) end
				if InputIsMouseButtonJustDown(2) then
					GamePlaySound("ui", "ui/button_click", 0, 0)
					U.set_setting(setting_id, D[setting_id])
				end
			end
		end
		GuiLayoutEnd(gui)
	end

	function S.get_input(_, gui, _, _, setting)
		local current_key = "[" .. U.keycodes[U.get_setting_next("open_ui_hotkey")] .. "]"
		if U.waiting_for_input then
			current_key = GameTextGetTranslatedOrNot("$menuoptions_configurecontrols_pressakey")
			for code, _ in pairs(U.keycodes) do
				if InputIsKeyJustDown(code) then
					U.set_setting_force("open_ui_hotkey", code)
					U.waiting_for_input = false
				end
			end
		end

		GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
		GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)

		GuiLayoutBeginHorizontal(gui, U.offset, 0, true, 0, 0)
		GuiText(gui, 8, 0, "")
		local _, _, _, x, y = GuiGetPreviousWidgetInfo(gui)
		local w, h = GuiGetTextDimensions(gui, current_key)
		G.button_options(gui)
		GuiImageNinePiece(gui, id(), x, y, w, h, 0)
		local _, _, hovered = GuiGetPreviousWidgetInfo(gui)
		if hovered then
			GuiColorSetForNextWidget(gui, 1, 1, 0.7, 1)
			GuiTooltip(gui, T.open_ui_hotkey_d, GameTextGetTranslatedOrNot("$menuoptions_reset_keyboard"))
			if InputIsMouseButtonJustDown(1) then U.waiting_for_input = true end
			if InputIsMouseButtonJustDown(2) then
				GamePlaySound("ui", "ui/button_click", 0, 0)
				U.set_setting_force("open_ui_hotkey", 0)
				U.waiting_for_input = false
			end
		end
		GuiText(gui, 0, 0, current_key)

		GuiLayoutEnd(gui)
	end

	function S.reset_stuff(_, gui, _, _, setting)
		local fn = U[setting.id]
		if not fn then
			GuiText(gui, mod_setting_group_x_offset, 0, "ERR")
			return
		end
		if G.button(gui, mod_setting_group_x_offset, T.reset_cat, { 1, 0.4, 0.4 }) then fn() end
	end

	function S.hardmode(_, gui, _, _, _)
		GuiColorSetForNextWidget(gui, 0.7, 0.7, 0.7, 1)
		GuiText(gui, mod_setting_group_x_offset - 2, 0, "This is fairly experimental, but should be working.")
		GuiColorSetForNextWidget(gui, 0.7, 0.7, 0.7, 1)
		GuiText(gui, mod_setting_group_x_offset - 2, 0, "All the next settings applies on new game only.")
	end
end

-- ###########################################
-- ########		Translations		##########
-- ###########################################

local translations = {
	["English"] = {
		show_debug = "Show debug button",
		exp_bar_cat = "HUD", -- cat
		exp_bar_cat_d = "Settings for experience bar and misc",
		exp_bar_position = "Position",
		exp_bar_position_d = "Position of experience bar",
		under_health = "under health",
		on_left = "on left",
		on_right = "on right",
		on_top = "on top",
		exp_bar_thickness = "Bar thickness",
		exp_bar_red = "Red amount",
		exp_bar_green = "Green amount",
		exp_bar_blue = "Blue amount",
		exp_bar_misc = "Misc",
		exp_bar_show_perc = "Show percent",
		exp_bar_show_perc_d = "Shows current xp percentage and pending levels",
		session_exp_animate_bar = "Animate bar",
		session_exp_animate_bar_d = "Animate bar when there are pending levels",
		hud_reminder_in_inventory = "Reminder in inventory",
		hud_reminder_in_inventory_d = "Notifies you about pending levels in inventory",
		ui_cat = "UI", -- cat
		ui_cat_d = "Settings related to UI",
		open_ui_hotkey = "Hotkey",
		open_ui_hotkey_d = "Key for quick access to UI",
		level_up_ui = "Rewards",
		level_up_ui_d = "Settings related to reward picking UI",
		session_exp_ui_open_auto = "Level-up when available",
		session_exp_ui_open_auto_d = "Automatically open level-up menu when you open UI",
		show_new_text = "Show new rewards",
		show_new_text_d = "Adds an indication that a reward is new for you",
		session_exp_ui_close = "Close UI on",
		session_exp_ui_close_d = "You can force open UI by right clicking",
		session_exp_close_ui_on_pause = "Pause",
		session_exp_close_ui_on_pause_d = "Close UI on pause",
		session_exp_close_ui_on_shot = "Shot",
		session_exp_close_ui_on_shot_d = "Close UI when you shot",
		session_exp_close_ui_on_damage = "Receiving damage",
		session_exp_close_ui_on_damage_d = "Close UI when you receive damage",
		session_exp_ui_open = "Misc",
		show_ui_on_death = "Show menu on death",
		show_ui_on_death_d = "Shows open menu button on death screen",
		gameplay_cat = "Gameplay", -- cat
		gameplay_cat_d = "In-game related settings",
		session_exp_on_level_up = "On level up",
		session_exp_play_sound = "Play sound",
		session_exp_play_sound_d = "Play sound when you got new level",
		session_exp_play_fx = "Play FX",
		session_exp_play_fx_d = "Show effects when you got new level",
		session_exp_foot_particle = "Particles",
		session_exp_foot_particle_d = "Create particles when you have pending levels",
		session_exp_on_kills = "On kills",
		session_exp_on_kills_d = "When you kill something",
		session_exp_popup = "Show experience",
		session_exp_popup_d = "Show XP amount above killed entity",
		session_exp_log = "Create log",
		session_exp_log_d = "Writes the name of killed entity and amount of XP",
		session_exp_multiplier = "EXP multiplier",
		session_exp_multiplier_d = "If you find default to be unsatisfying",
		reset_cat = "Reset",
		reset_cat_d = "Reset various stuff",
		reset_settings = "Reset settings",
		reset_settings_d = "Sets all settings to default",
		reset_progress = "Reset progress",
		reset_progress_d = "Resets history of picked rewards",
		reset_meta = "Reset meta",
		reset_meta_d = "Resets meta point and all of it's progress",
		exp_bar_visual = "Bar visual",
		exp_bar_default_bg = "Don't color background",
		exp_bar_default_bg_d = "Use vanilla background color for exp bar",
		meta_point_per_level = "Meta points per",
		meta_point_per_level_d = "After what level to start meta points",
		levels = "levels",
		hardmode = "Hardmode", --cat
		hardmode_d = "Settings related to hardmode",
		hardmode_enabled = "Enabled",
		hardmode_level_curve = "Level curve",
		hardmode_level_curve_d = "How much harder it is to get more levels",
		hardmode_nerf = "Nerf",
		hardmode_nerf_d = "Nerf these things since this mod has analogues",
		hardmode_nerf_perks = "Perks",
		hardmode_nerf_perks_d = "Remove and rework some perks",
		hardmode_nerf_rewards = "Rewards",
		hardmode_nerf_rewards_d = "Nerf rewards",
		ignore_holiday = "Ignore Holiday",
		ignore_holiday_d = "Remove Holiday decorations from UI",
	},
	["русский"] = {
		show_debug = "Show debug button",
		exp_bar_cat = "HUD",
		exp_bar_cat_d = "Настройки для полосы опыта и прочее",
		exp_bar_position = "Позиция",
		exp_bar_position_d = "Позиция полоски опыта",
		under_health = "под здоровьем",
		on_left = "слева",
		on_right = "справа",
		on_top = "сверху",
		exp_bar_thickness = "Толщина полоски",
		exp_bar_red = "Красный",
		exp_bar_green = "Зелёный",
		exp_bar_blue = "Синий",
		exp_bar_misc = "Прочее",
		exp_bar_show_perc = "Процент",
		exp_bar_show_perc_d = "Показывает текущий процент опыта и доступные уровни",
		session_exp_animate_bar = "Анимации",
		session_exp_animate_bar_d = "Анимировать бар при доступных уровнях",
		hud_reminder_in_inventory = "Напоминание",
		hud_reminder_in_inventory_d = "Напоминать о доступных уровнях в инвентаре",
		ui_cat = "UI", -- cat
		ui_cat_d = "Настройки связанные с интерфейсом",
		open_ui_hotkey = "Горячая клавиша",
		open_ui_hotkey_d = "Клавиша для быстрого открытия меню",
		level_up_ui = "Награды",
		level_up_ui_d = "Настройки связанные с интерфейсом выбора наград",
		session_exp_ui_open_auto = "Сразу открывать меню",
		session_exp_ui_open_auto_d = "Автоматически открывать меню повышение уровня\nкогда вы открываете интерфейс",
		show_new_text = "Показывать новые награды",
		show_new_text_d = "Добавляет индикацию что награда не была выбрана ранее",
		session_exp_ui_close = "Закрыть меню при",
		session_exp_close_ui_on_pause = "Паузе",
		session_exp_close_ui_on_pause_d = "Закрывать интерфейс при паузе",
		session_exp_close_ui_on_shot = "Выстреле",
		session_exp_close_ui_on_shot_d = "Закрывать интерфейс при выстреле",
		session_exp_close_ui_on_damage = "Получении урона",
		session_exp_close_ui_on_damage_d = "Закрывать интерфейс при получении урона",
		session_exp_ui_open = "Прочее",
		show_ui_on_death = "Меню при смерти",
		show_ui_on_death_d = "Показывать кнопку открытия меню после смерти",
		gameplay_cat = "Геймплей", -- cat
		gameplay_cat_d = "Настройки связанные с геймплеем",
		session_exp_on_level_up = "Новый уровень",
		session_exp_play_sound = "Звук",
		session_exp_play_sound_d = "Проигрывать звук когда вы повышаете уровень",
		session_exp_play_fx = "Эффекты",
		session_exp_play_fx_d = "Показывать эффекты при повышении уровня",
		session_exp_foot_particle = "Частицы",
		session_exp_foot_particle_d = "Создавать частицы когда доступен новый уровень",
		session_exp_on_kills = "При убийствах",
		session_exp_on_kills_d = "Когда вы убиваете что-то",
		session_exp_popup = "Показывать опыт",
		session_exp_popup_d = "Показывать кол-во опыта над убитым",
		session_exp_log = "Логировать",
		session_exp_log_d = "Писать имя убитого и кол-во опыта",
		session_exp_multiplier = "Множитель опыта",
		session_exp_multiplier_d = "Если вас не устраивает по умолчанию",
		reset_cat = "Сброс",
		reset_cat_d = "Сброс разных вещей",
		reset_settings = "Сброс настроек",
		reset_settings_d = "Сбрасывает все настройки по умолчанию",
		reset_progress = "Сброс прогресса",
		reset_progress_d = "Сбросить историю выбранных наград",
		reset_meta = "Сброс меты",
		reset_meta_d = "Сбрасывает очки меты и весь его прогресс",
		exp_bar_visual = "Вид полосы",
		exp_bar_default_bg = "Не красить фон",
		exp_bar_default_bg_d = "Использовать стандартный фон для полосы опыта",
		meta_point_per_level = "Очки меты каждые",
		meta_point_per_level_d = "После какого уровня начинать давать мета очки",
		levels = "уровней",
		hardmode = "Хардмод", --cat
		hardmode_d = "Настройки связанные с хардмодом",
		hardmode_enabled = "Включено",
		hardmode_level_curve = "Кривая уровня",
		hardmode_level_curve_d = "Насколько сложнее получать следующие уровни",
		hardmode_nerf = "Нерфы",
		hardmode_nerf_d = "Занерфить следующее поскольку этот мод имеет аналоги",
		hardmode_nerf_perks = "Перки",
		hardmode_nerf_perks_d = "Убирает и перерабатывает некоторые перки",
		hardmode_nerf_rewards = "Награды",
		hardmode_nerf_rewards_d = "Занерфить награды",
		ignore_holiday = "Выкл праздники",
		ignore_holiday_d = "Убрать праздничные украшения из UI",
	},
}
T = translations["English"]

-- ###########################################
-- #########		Settings		##########
-- ###########################################

--- @class ml_settings_default
D = {
	exp_bar_position = "under_health",
	exp_bar_thickness = 2,
	exp_bar_red = 0,
	exp_bar_green = 0.5,
	exp_bar_blue = 0,
	exp_bar_default_bg = false,
	session_exp_play_sound = true,
	session_exp_play_fx = true,
	session_exp_animate_bar = true,
	hud_reminder_in_inventory = true,
	exp_bar_show_perc = true,
	session_exp_log = false,
	session_exp_multiplier = 1,
	session_exp_close_ui_on_shot = true,
	session_exp_close_ui_on_damage = true,
	session_exp_close_ui_on_pause = true,
	session_exp_popup = true,
	session_exp_ui_open_auto = true,
	show_new_text = false,
	open_ui_hotkey = 0,
	session_exp_foot_particle = true,
	show_ui_on_death = true,
	meta_point_per_level = 50,
	hardmode_enabled = false,
	hardmode_level_curve = 0.1,
	hardmode_nerf_perks = true,
	hardmode_nerf_rewards = true,
	ignore_holiday = false,
}

local function build_settings()
	--- @type mod_settings_global
	local settings = {
		{
			category_id = "exp_bar_cat",
			ui_name = T.exp_bar_cat,
			ui_description = T.exp_bar_cat_d,
			foldable = true,
			_folded = true,
			settings = {
				{
					ui_fn = S.draw_bar_position,
					not_setting = true,
				},
				{
					id = "exp_bar_position",
					ui_name = T.exp_bar_position,
					ui_description = T.exp_bar_position_d,
					buttons = { "under_health", "on_left", "on_right", "on_top" },
					ui_fn = S.mod_setting_better_string,
				},
				{
					not_setting = true,
					id = "exp_bar_thickness",
					ui_name = T.exp_bar_thickness,
					ui_description = T.exp_bar_thickness_d,
					value_min = 1,
					ui_fn = S.draw_bar_thickness,
				},
				{
					id = "exp_bar_red",
					ui_name = T.exp_bar_red,
					value_min = 0,
					value_max = 1,
					value_display_multiplier = 255,
					ui_fn = S.mod_setting_number_float,
				},
				{
					id = "exp_bar_green",
					ui_name = T.exp_bar_green,
					value_min = 0,
					value_max = 1,
					value_display_multiplier = 255,
					ui_fn = S.mod_setting_number_float,
				},
				{
					id = "exp_bar_blue",
					ui_name = T.exp_bar_blue,
					value_min = 0,
					value_max = 1,
					value_display_multiplier = 255,
					ui_fn = S.mod_setting_number_float,
				},
				{
					id = "exp_bar_visual",
					ui_name = T.exp_bar_visual,
					ui_fn = S.mod_setting_better_boolean,
					checkboxes = { "session_exp_animate_bar", "exp_bar_default_bg" },
				},
				{
					id = "exp_bar_misc",
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.exp_bar_misc,
					checkboxes = { "exp_bar_show_perc", "hud_reminder_in_inventory" },
				},
			},
		},
		{
			category_id = "ui_cat",
			ui_name = T.ui_cat,
			ui_description = T.ui_cat_d,
			foldable = true,
			_folded = true,
			settings = {
				{
					not_setting = true,
					id = "open_ui_hotkey",
					ui_fn = S.get_input,
					ui_name = T.open_ui_hotkey,
				},
				{
					id = "level_up_ui",
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.level_up_ui,
					checkboxes = { "session_exp_ui_open_auto", "show_new_text" },
				},
				{
					id = "session_exp_ui_close",
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.session_exp_ui_close,
					checkboxes = { "session_exp_close_ui_on_pause", "session_exp_close_ui_on_shot", "session_exp_close_ui_on_damage" },
				},
				{
					id = "session_exp_ui_open",
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.session_exp_ui_open,
					checkboxes = { "show_ui_on_death", "ignore_holiday" },
				},
			},
		},
		{
			category_id = "gameplay_cat",
			ui_name = T.gameplay_cat,
			ui_description = T.gameplay_cat_d,
			foldable = true,
			_folded = true,
			settings = {
				{
					id = "session_exp_on_level_up",
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.session_exp_on_level_up,
					checkboxes = { "session_exp_play_sound", "session_exp_play_fx", "session_exp_foot_particle" },
				},
				{
					id = "session_exp_on_kills",
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.session_exp_on_kills,
					checkboxes = { "session_exp_popup", "session_exp_log" },
				},
				{
					id = "session_exp_multiplier",
					ui_name = T.session_exp_multiplier,
					value_min = 0.05,
					value_max = 3,
					value_display_multiplier = 100,
					value_snap = 0.05,
					ui_fn = S.mod_setting_number_float,
					format = "%",
				},
				{
					id = "meta_point_per_level",
					ui_name = T.meta_point_per_level,
					value_min = 10,
					value_max = 50,
					value_snap = 5,
					ui_fn = S.mod_setting_number_integer,
					format = " " .. T.levels,
				},
			},
		},
		{
			category_id = "hardmode_cat",
			ui_name = T.hardmode,
			ui_description = T.hardmode_d,
			foldable = true,
			_folded = true,
			settings = {
				{
					not_setting = true,
					id = "hardmode_settings",
					ui_fn = S.hardmode,
					ui_name = T.hardmode,
				},
				{
					id = "hardmode",
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.hardmode,
					checkboxes = { "hardmode_enabled" },
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "hardmode_level_curve",
					ui_fn = S.mod_setting_number_float,
					ui_name = T.hardmode_level_curve,
					value_min = 0.01,
					value_max = 0.1,
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
				{
					id = "hardmode_nerf",
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.hardmode_nerf,
					checkboxes = { "hardmode_nerf_perks", "hardmode_nerf_rewards" },
					scope = MOD_SETTING_SCOPE_NEW_GAME,
				},
			},
		},
		{
			category_id = "reset_cat",
			ui_name = T.reset_cat,
			ui_description = T.reset_cat_d,
			foldable = true,
			_folded = true,
			settings = {
				{
					category_id = "reset_settings",
					ui_name = T.reset_settings,
					ui_description = T.reset_settings_d,
					foldable = true,
					_folded = true,
					settings = {
						{
							not_setting = true,
							id = "reset_settings",
							ui_fn = S.reset_stuff,
							ui_name = T.reset_settings,
						},
					},
				},
				{
					category_id = "reset_progress",
					ui_name = T.reset_progress,
					ui_description = T.reset_progress_d,
					foldable = true,
					_folded = true,
					settings = {
						{
							not_setting = true,
							id = "reset_progress",
							ui_fn = S.reset_stuff,
							ui_name = T.reset_progress,
						},
					},
				},
				{
					category_id = "reset_meta",
					ui_name = T.reset_meta,
					ui_description = T.reset_meta_d,
					foldable = true,
					_folded = true,
					settings = {
						{
							not_setting = true,
							id = "reset_meta",
							ui_fn = S.reset_stuff,
							ui_name = T.reset_meta,
						},
					},
				},
			},
		},
	}
	U.offset = U.calculate_elements_offset(settings)
	return settings
end

-- ###########################################
-- #############		Meh		##############
-- ###########################################

--- @param init_scope mod_setting_scopes
function ModSettingsUpdate(init_scope)
	if init_scope == 0 then -- On new game
		U.check_for_winstreak()
	end
	U.set_default(false)
	U.waiting_for_input = false
	U.mod_settings_update(mod_settings, init_scope)
	local current_language = GameTextGetTranslatedOrNot("$current_language")
	if current_language ~= current_language_last_frame then
		T = translations[current_language]
		mod_settings = build_settings()
	end
	current_language_last_frame = current_language
end

--- @return number
function ModSettingsGuiCount()
	return mod_settings_gui_count(mod_id, mod_settings)
end

--- @param gui gui
--- @param _in_main_menu boolean
function ModSettingsGui(gui, _in_main_menu)
	gui_id = mod_id_hash * 1000
	in_main_menu = _in_main_menu
	GuiIdPushString(gui, mod_prfx)
	mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
	GuiIdPop(gui)
end

U.gather_key_codes()

--- @type mod_settings_global
mod_settings = build_settings()
