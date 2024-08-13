dofile_once("data/scripts/lib/mod_settings.lua")

local mod_id = "meta_leveling"
mod_settings_version = 1
local T = {}
local D = {}
-- ###########################################
-- ############		Helpers		##############
-- ###########################################

local U = {
	whitebox = "data/debug/whitebox.png",
	empty = "data/debug/empty.png",
	offset = 0,
	max_y = 300,
	min_y = 50,
}
do --helpers
	function U.setting_handle_callback(setting)
		if setting.change_fn then setting.change_fn(setting) end
	end

	---@param setting_name setting_id
	---@param value setting_value
	function U.set_setting(setting_name, value)
		ModSettingSet("meta_leveling." .. setting_name, value)
		ModSettingSetNextValue("meta_leveling." .. setting_name, value, false)
	end

	---@param setting_name setting_id
	---@return setting_value?
	function U.get_setting(setting_name)
		return ModSettingGet("meta_leveling." .. setting_name)
	end

	---@param setting_name setting_id
	---@return setting_value?
	function U.get_setting_next(setting_name)
		return ModSettingGetNextValue("meta_leveling." .. setting_name)
	end

	---@param id setting_id
	---@return number?
	function U.get_settings_cat_index(id)
		for i, setting in ipairs(mod_settings) do
			if setting.category_id and setting.category_id == id then
				return i
			end
		end
	end

	---@param table mod_settings
	---@param setting_id setting_id
	---@return number?
	function U.get_setting_index(table, setting_id)
		for i, setting in ipairs(table) do
			if setting.id and setting.id == setting_id then
				return i
			end
		end
	end

	---@param cat_id mod_category_id
	---@param set_id setting_id
	---@return { cat: number, set: number }
	function U.get_cat_and_setting_index(cat_id, set_id)
		local cat_index = U.get_settings_cat_index(cat_id)
		local set_index = U.get_setting_index(mod_settings[cat_index].settings, set_id)
		return {
			cat = cat_index,
			set = set_index
		}
	end

	---@param gui gui
	---@param array mod_settings_global|mod_settings
	---@return number
	function U.calculate_elements_offset(gui, array)
		local max_width = 10
		for _, setting in ipairs(array) do
			if setting.category_id then
				cat_max_width = U.calculate_elements_offset(gui, setting.settings)
				max_width = math.max(max_width, cat_max_width)
			end
			if setting.ui_name then
				local name_length = GuiGetTextDimensions(gui, setting.ui_name)
				max_width = math.max(max_width, name_length)
			end
		end
		return max_width + 3
	end

	---@param value? string
	---@return number
	function U.get_thickness_limit(value)
		local max = 4
		local position = value or U.get_setting_next("exp_bar_position")
		if position == "under_health" then
			max = 2
		end
		return max
	end

	function U.set_thickness_limit(setting)
		local value = tostring(U.get_setting_next("exp_bar_position"))
		local max = U.get_thickness_limit(value)
		local index = U.get_cat_and_setting_index("exp_bar_cat", "exp_bar_thickness")
		mod_settings[index.cat].settings[index.set].value_max = max
	end

	---@param all boolean reset all
	function U.set_default(all)
		all = all or false
		for setting, value in pairs(D) do
			if U.get_setting(setting) == nil or all then
				U.set_setting(setting, value)
			end
		end
	end
end
-- ###########################################
-- ##########		GUI Helpers		##########
-- ###########################################

local G = {

}
do --gui helpers
	---@param gui gui
	---@param hovered boolean
	function G.yellow_if_hovered(gui, hovered)
		if hovered then GuiColorSetForNextWidget(gui, 1, 1, 0.7, 1) end
	end

	---@param gui gui
	---@param id fun(): number
	---@param setting mod_setting
	---@param value setting_value
	---@param set_value setting_value
	function G.display_fake_button(gui, id, setting, value, set_value)
		local _, _, _, x, y, w = GuiGetPreviousWidgetInfo(gui)
		local text = "[" .. T[set_value] .. "]"
		local width, height = GuiGetTextDimensions(gui, text)
		GuiImageNinePiece(gui, id(), x + w, y, width, height, 0)
		local clicked, _, hovered = GuiGetPreviousWidgetInfo(gui)
		if value == set_value then
			GuiColorSetForNextWidget(gui, 0.7, 0.7, 0.7, 1)
		else
			G.yellow_if_hovered(gui, hovered)
			if clicked then
				GamePlaySound("ui", "ui/button_click", 0, 0)
				U.set_setting(setting.id, set_value)
				U.setting_handle_callback(setting)
			end
		end
		GuiText(gui, 0, 0, text)
	end

	---@param setting_name setting_id
	---@param value setting_value
	---@param default setting_value
	function G.on_clicks(setting_name, value, default)
		if InputIsMouseButtonJustDown(1) then
			GamePlaySound("ui", "ui/button_click", 0, 0)
			U.set_setting(setting_name, value)
		end
		if InputIsMouseButtonJustDown(2) then
			GamePlaySound("ui", "ui/button_click", 0, 0)
			U.set_setting(setting_name, default)
		end
	end

	---@param gui gui
	---@param id fun(): number
	---@param setting_name setting_id
	function G.toggle_checkbox_boolean(gui, id, setting_name)
		local text = T[setting_name]
		local _, _, _, prev_x, y, prev_w = GuiGetPreviousWidgetInfo(gui)
		local x = prev_x + prev_w + 1
		local value = U.get_setting_next(setting_name)
		local offset_w = GuiGetTextDimensions(gui, text) + 8

		GuiZSetForNextWidget(gui, -1)
		GuiImageNinePiece(gui, id(), x + 2, y, offset_w, 10, 10, U.empty, U.empty) --hover box
		local _, _, hovered = GuiGetPreviousWidgetInfo(gui)
		GuiZSetForNextWidget(gui, 1)
		GuiImageNinePiece(gui, id(), x + 2, y + 2, 6, 6) --check box

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
		G.tooltip(gui, setting_name)
		if hovered then
			G.on_clicks(setting_name, not value, D[setting_name])
		end
	end

	---@param gui gui
	---@param id number
	---@param setting mod_setting_number
	---@return number, number
	function G.mod_setting_number(gui, id, setting)
		GuiLayoutBeginHorizontal(gui, 0, 0, false, 0, 0)
		GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)
		local w = GuiGetTextDimensions(gui, setting.ui_name)
		local value = tonumber(ModSettingGetNextValue(mod_setting_get_id(mod_id, setting))) or setting.value_default
		local multiplier = setting.value_display_multiplier or 1
		local value_new = GuiSlider(gui, id, U.offset - w, 0, "", value, setting
			.value_min,
			setting.value_max, setting.value_default, multiplier, " ", 64)
		GuiColorSetForNextWidget(gui, 0.81, 0.81, 0.81, 1)
		local format = setting.format or ""
		GuiText(gui, 3, 0, tostring(math.floor(value * multiplier)) .. format)
		GuiLayoutEnd(gui)
		G.tooltip(gui, setting.id, setting.scope)
		return value, value_new
	end

	---@param gui gui
	---@param setting_name setting_id
	---@param scope? mod_setting_scopes
	function G.tooltip(gui, setting_name, scope)
		local description = T[setting_name .. "_d"]
		local value = U.get_setting_next(setting_name)
		local value_now = U.get_setting(setting_name)

		if value ~= value_now then
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

		if description then
			GuiTooltip(gui, description, "")
		end
	end

	---@param gui gui
	---@param id fun():number
	---@param x number
	---@param y number
	---@param width number
	---@param height number
	---@param fn fun(gui:gui, id:function, width:number, height:number, ...:any)
	---@param ... any
	function G.ImageClip(gui, id, x, y, width, height, fn, ...)
		GuiText(gui, x, y, " ")
		local _, _, _, _, prev_y = GuiGetPreviousWidgetInfo(gui)
		if prev_y + height > U.max_y then
			height = U.max_y - prev_y - 1
		end
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
		fn(gui, id, width, height, ...)
		GuiEndScrollContainer(gui)
	end

	function G.draw_outline(gui, id, width, height)
		GuiColorSetForNextWidget(gui, 0.4752, 0.2768, 0.2215, 1)
		GuiZSetForNextWidget(gui, 4)
		GuiImage(gui, id(), 0, 0, U.whitebox, 0.85, width / 20, height / 20)
	end

	function G.draw_bar_color(gui, id, width, height, health)
		if health then
			GuiColorSetForNextWidget(gui, 0.53, 0.75, 0.1, 1)
		else
			local r = tonumber(U.get_setting_next("exp_bar_red")) or D.exp_bar_red
			local g = tonumber(U.get_setting_next("exp_bar_green")) or D.exp_bar_green
			local b = tonumber(U.get_setting_next("exp_bar_blue")) or D.exp_bar_blue
			GuiColorSetForNextWidget(gui, r, g, b, 1)
		end
		GuiZSetForNextWidget(gui, 3)
		GuiImage(gui, id(), 0, 0, U.whitebox, 1, width / 20, height / 20)
	end
end
-- ###########################################
-- ########		Settings GUI		##########
-- ###########################################

local S = {

}
do -- Settings GUI
	function S.draw_bar_position(_, gui, in_main_menu, im_id, setting)
		local gui_id = im_id
		local function id()
			gui_id = gui_id + 1
			return gui_id
		end
		GuiOptionsAdd(gui, GUI_OPTION.Layout_NextSameLine)

		local thickness = 1 + tonumber(U.get_setting_next("exp_bar_thickness")) or D.exp_bar_thickness
		local position = U.get_setting_next("exp_bar_position")
		local x = mod_setting_group_x_offset + U.offset + 92
		local y = 8
		GuiText(gui, x, y + 5, " ")
		local _, _, _, x_no_layout, y_no_layout = GuiGetPreviousWidgetInfo(gui)

		GuiZSetForNextWidget(gui, 5)
		GuiImageNinePiece(gui, id(), x_no_layout, y_no_layout, 74, 38)
		G.ImageClip(gui, id, x + 15, y + 14, 44, 7, G.draw_outline)
		G.ImageClip(gui, id, x + 16, y + 15, 42, 5, G.draw_bar_color, true)

		if position == "under_health" then
			G.ImageClip(gui, id, x + 15, y + 20.5, 44, thickness + 1, G.draw_outline)
			G.ImageClip(gui, id, x + 16, y + 20.5, 42, thickness, G.draw_bar_color)
		elseif position == "on_top" then
			G.ImageClip(gui, id, x + 15, y + 7, 44, thickness + 2, G.draw_outline)
			G.ImageClip(gui, id, x + 16, y + 8, 42, thickness, G.draw_bar_color)
		elseif position == "on_left" then
			G.ImageClip(gui, id, x + 2, y + 14, thickness + 2, 29.25, G.draw_outline)
			G.ImageClip(gui, id, x + 3, y + 15, thickness, 27.25, G.draw_bar_color)
		else
			G.ImageClip(gui, id, x + 66, y + 14, thickness + 2, 29.25, G.draw_outline)
			G.ImageClip(gui, id, x + 67, y + 15, thickness, 27.25, G.draw_bar_color)
		end

		if U.get_setting_next("exp_bar_show_perc") then GuiText(gui, x + 66, y + 5, "%") end
		GuiOptionsRemove(gui, GUI_OPTION.Layout_NextSameLine)
	end

	---@param setting mod_setting_number
	function S.mod_setting_number_float(_, gui, in_main_menu, im_id, setting)
		local value, value_new = G.mod_setting_number(gui, im_id, setting)
		if value ~= value_new then
			U.set_setting(setting.id, value_new)
		end
	end

	---@param setting mod_setting_number
	function S.mod_setting_number_integer(_, gui, in_main_menu, im_id, setting)
		local value, value_new = G.mod_setting_number(gui, im_id, setting)
		value_new = math.floor(value_new + 0.5)
		if value ~= value_new then
			U.set_setting(setting.id, value_new)
		end
	end

	function S.mod_setting_better_string(_, gui, in_main_menu, im_id, setting)
		local gui_id = im_id
		local function id()
			gui_id = gui_id + 1
			return gui_id
		end
		local value = U.get_setting_next(setting.id)
		if not value then return end
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
		GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)
		GuiLayoutBeginHorizontal(gui, U.offset, 0, true, 0, 0)
		GuiText(gui, 7, 0, "")
		for _, button in ipairs(setting.buttons) do
			G.display_fake_button(gui, id, setting, value, button)
		end
		GuiLayoutEnd(gui)
	end

	function S.mod_setting_better_boolean(_, gui, in_main_menu, im_id, setting)
		local gui_id = im_id
		local function id()
			gui_id = gui_id + 1
			return gui_id
		end
		GuiOptionsAddForNextWidget(gui, GUI_OPTION.Layout_NextSameLine)
		GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)
		GuiLayoutBeginHorizontal(gui, U.offset, 0, true, 0, 0)
		GuiText(gui, 7, 0, "")
		for _, setting_id in ipairs(setting.checkboxes) do
			G.toggle_checkbox_boolean(gui, id, setting_id)
		end
		GuiLayoutEnd(gui)
	end
end

-- ###########################################
-- ########		Translations		##########
-- ###########################################

local translations =
{
	["English"] = {
		exp_bar_cat = "HUD", --cat
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
		hud_reminder_in_inventory = "Reminder in inventory",
		gameplay_cat = "Gameplay", --cat
		gameplay_cat_d = "In-game relating settings",
		session_exp_on_level_up = "On level up",
		session_exp_play_sound = "Play sound",
		session_exp_play_fx = "Play FX",
		session_exp_animate_bar = "Animate bar",
		session_exp_on_kills = "On kills",
		session_exp_popup = "Show experience",
		session_exp_log = "Create log",
		session_exp_multiplier = "EXP multiplier",
		session_exp_ui_close = "Close UI on",
		session_exp_close_ui_on_shot = "Shot",
		session_exp_close_ui_on_damage = "Receiving damage",
		session_exp_close_ui_on_pause = "Pause",
	},
	["русский"] = {
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
		hud_reminder_in_inventory = "Напоминание",
		gameplay_cat = "Геймплей", --cat
		gameplay_cat_d = "Настройки связанные с геймплеем",
		session_exp_on_level_up = "Новый уровень",
		session_exp_play_sound = "Звук",
		session_exp_play_fx = "Эффекты",
		session_exp_animate_bar = "Анимации",
		session_exp_on_kills = "При убийствах",
		session_exp_popup = "Показывать опыт",
		session_exp_log = "Логировать",
		session_exp_multiplier = "Множитель опыта",
		session_exp_ui_close = "Закрыть меню при",
		session_exp_close_ui_on_shot = "Выстреле",
		session_exp_close_ui_on_damage = "Получении урона",
		session_exp_close_ui_on_pause = "Паузе",
	}
}

local mt = {
	__index = function(t, k)
		local currentLang = GameTextGetTranslatedOrNot("$current_language")
		if not translations[currentLang] then
			currentLang = "English"
		end
		return translations[currentLang][k]
	end
}
setmetatable(T, mt)

-- ###########################################
-- #########		Settings		##########
-- ###########################################

---@class ml_settings_default
D = {
	exp_bar_position = "under_health",
	exp_bar_thickness = 2,
	exp_bar_red = 0,
	exp_bar_green = 0.5,
	exp_bar_blue = 0,
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
}

local function build_settings()
	---@type mod_settings_global
	local settings = {
		{
			category_id = "exp_bar_cat",
			ui_name = T.exp_bar_cat,
			ui_description = T.exp_bar_cat_d,
			foldable = true,
			_folded = true,
			settings =
			{
				{
					ui_fn = S.draw_bar_position,
					not_setting = true,
				},
				{
					id = "exp_bar_position",
					ui_name = T.exp_bar_position,
					ui_description = T.exp_bar_position_d,
					value_default = D.exp_bar_position,
					buttons = { "under_health", "on_left", "on_right", "on_top" },
					scope = MOD_SETTING_SCOPE_RUNTIME,
					change_fn = U.set_thickness_limit,
					ui_fn = S.mod_setting_better_string,
				},
				{
					id = "exp_bar_thickness",
					ui_name = T.exp_bar_thickness,
					ui_description = T.exp_bar_thickness_d,
					value_default = D.exp_bar_thickness,
					value_min = 1,
					value_max = U.get_thickness_limit(),
					scope = MOD_SETTING_SCOPE_RUNTIME,
					ui_fn = S.mod_setting_number_integer,
					parent = "exp_bar_cat",
				},
				{
					id = "exp_bar_red",
					ui_name = T.exp_bar_red,
					value_default = D.exp_bar_red,
					value_min = 0,
					value_max = 1,
					value_display_multiplier = 255,
					scope = MOD_SETTING_SCOPE_RUNTIME,
					ui_fn = S.mod_setting_number_float,
					parent = "exp_bar_cat",
				},
				{
					id = "exp_bar_green",
					ui_name = T.exp_bar_green,
					value_default = D.exp_bar_green,
					value_min = 0,
					value_max = 1,
					value_display_multiplier = 255,
					scope = MOD_SETTING_SCOPE_RUNTIME,
					ui_fn = S.mod_setting_number_float,
					parent = "exp_bar_cat",
				},
				{
					id = "exp_bar_blue",
					ui_name = T.exp_bar_blue,
					value_default = D.exp_bar_blue,
					value_min = 0,
					value_max = 1,
					value_display_multiplier = 255,
					scope = MOD_SETTING_SCOPE_RUNTIME,
					ui_fn = S.mod_setting_number_float,
					parent = "exp_bar_cat",
				},
				{
					not_setting = true,
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.exp_bar_misc,
					checkboxes = { "exp_bar_show_perc", "session_exp_animate_bar", "hud_reminder_in_inventory" },
				}
			},
		},
		{
			category_id = "gameplay_cat",
			ui_name = T.gameplay_cat,
			ui_description = T.gameplay_cat_d,
			foldable = true,
			_folded = true,
			settings =
			{
				{
					not_setting = true,
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.session_exp_on_level_up,
					checkboxes = { "session_exp_play_sound", "session_exp_play_fx" },
				},
				{
					not_setting = true,
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.session_exp_on_kills,
					checkboxes = { "session_exp_popup", "session_exp_log" }
				},
				{
					not_setting = true,
					ui_fn = S.mod_setting_better_boolean,
					ui_name = T.session_exp_ui_close,
					checkboxes = { "session_exp_close_ui_on_pause", "session_exp_close_ui_on_shot", "session_exp_close_ui_on_damage" }
				},
				{
					id = "session_exp_multiplier",
					ui_name = T.session_exp_multiplier,
					value_default = D.session_exp_multiplier,
					value_min = 0.1,
					value_max = 3,
					scope = MOD_SETTING_SCOPE_RUNTIME,
					value_display_multiplier = 100,
					ui_fn = S.mod_setting_number_float,
					parent = "gameplay_cat",
					format = "%"
				},
			},
		},
	}
	U.offset = 0
	return settings
end

-- ###########################################
-- #############		Meh		##############
-- ###########################################

function ModSettingsUpdate(init_scope)
	-- local old_version = mod_settings_get_version(mod_id)
	U.set_default(false)
	local current_language = GameTextGetTranslatedOrNot("$current_language")
	if current_language ~= current_language_last_frame then
		mod_settings = build_settings()
	end
	current_language_last_frame = current_language
	mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
	return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
	if U.offset == 0 then U.offset = U.calculate_elements_offset(gui, mod_settings) end
	mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end

---@type mod_settings_global
mod_settings = build_settings()
