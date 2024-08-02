dofile_once("data/scripts/lib/mod_settings.lua")

local whitebox = "data/debug/whitebox.png"
local slider_offset = {}
local mod_id = "meta_leveling"
mod_settings_version = 1

local function set_setting(setting_name, value)
	ModSettingSet(setting_name, value)
	ModSettingSetNextValue(setting_name, value, false)
end

local function get_settings_cat_index(id)
	for i, setting in ipairs(mod_settings) do
		if setting.category_id and setting.category_id == id then
			return i
		end
	end
end

local function get_setting_index(table, setting_id)
	for i, setting in ipairs(table) do
		if setting.id and setting.id == setting_id then
			return i
		end
	end
end

local function CalculateSliderOffset(gui, category_id)
	local index = get_settings_cat_index(category_id)
	if not index then return 0 end
	local max_width = 10
	for _, setting in ipairs(mod_settings[index].settings) do
		if setting.ui_name then
			local name_length = GuiGetTextDimensions(gui, setting.ui_name)
			if name_length > max_width then max_width = name_length end
		end
	end
	return max_width + 10
end

local function GetSliderOffset(gui, category_id)
	return slider_offset[category_id] or CalculateSliderOffset(gui, category_id)
end

local function get_cat_and_setting_index(cat_id, set_id)
	local cat_index = get_settings_cat_index(cat_id)
	local set_index = get_setting_index(mod_settings[cat_index].settings, set_id)
	return {
		cat = cat_index,
		set = set_index
	}
end

local function mod_setting_number_float(mod_id, gui, in_main_menu, im_id, setting)
	GuiLayoutBeginHorizontal(gui, 0, 0, false, 0, 0)
	GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)
	local w = GuiGetTextDimensions(gui, setting.ui_name)
	local value = tonumber(ModSettingGetNextValue(mod_setting_get_id(mod_id, setting))) or setting.value_default
	local multiplier = setting.value_display_multiplier or 1
	local value_new = GuiSlider(gui, im_id, GetSliderOffset(gui, setting.parent) - w, 0, "", value, setting.value_min,
		setting.value_max, setting.value_default, multiplier, " ", 64)
	GuiColorSetForNextWidget(gui, 0.81, 0.81, 0.81, 1)
	local format = setting.format or ""
	GuiText(gui, 3, 0, tostring(math.floor(value * multiplier)) .. format)
	GuiLayoutEnd(gui)
	if value ~= value_new then
		ModSettingSetNextValue(mod_setting_get_id(mod_id, setting), value_new, false)
		mod_setting_handle_change_callback(mod_id, gui, in_main_menu, setting, value, value_new)
	end

	mod_setting_tooltip(mod_id, gui, in_main_menu, setting)
end

local function mod_setting_number_integer(mod_id, gui, in_main_menu, im_id, setting)
	GuiLayoutBeginHorizontal(gui, 0, 0, false, 0, 0)
	GuiText(gui, mod_setting_group_x_offset, 0, setting.ui_name)
	local w = GuiGetTextDimensions(gui, setting.ui_name)
	local value = tonumber(ModSettingGetNextValue(mod_setting_get_id(mod_id, setting))) or setting.value_default
	local multiplier = setting.value_display_multiplier or 1
	local value_new = GuiSlider(gui, im_id, GetSliderOffset(gui, setting.parent) - w, 0, "", value, setting.value_min,
		setting.value_max, setting.value_default, multiplier, " ", 64)
	GuiColorSetForNextWidget(gui, 0.81, 0.81, 0.81, 1)
	GuiText(gui, 3, 0, tostring(math.floor(value * multiplier)))
	GuiLayoutEnd(gui)
	value_new = math.floor(value_new + 0.5)
	if value ~= value_new then
		ModSettingSetNextValue(mod_setting_get_id(mod_id, setting), value_new, false)
		mod_setting_handle_change_callback(mod_id, gui, in_main_menu, setting, value, value_new)
	end

	mod_setting_tooltip(mod_id, gui, in_main_menu, setting)
end

local function YellowIfHovered(gui, hovered)
	if hovered then GuiColorSetForNextWidget(gui, 1, 1, 0.7, 1) end
end

local function display_fake_button(mod_id, gui, in_main_menu, id, setting, text, value, set_value)
	local _, _, _, x, y, w = GuiGetPreviousWidgetInfo(gui)
	local width, height = GuiGetTextDimensions(gui, text)
	GuiImageNinePiece(gui, id, x + w, y, width, height, 0)
	local clicked, _, hovered = GuiGetPreviousWidgetInfo(gui)
	if value == set_value then
		GuiColorSetForNextWidget(gui, 0.7, 0.7, 0.7, 1)
	else
		YellowIfHovered(gui, hovered)
		if clicked then
			GamePlaySound("ui", "ui/button_click", 0, 0)
			ModSettingSetNextValue(mod_setting_get_id(mod_id, setting), set_value, false)
			mod_setting_handle_change_callback(mod_id, gui, in_main_menu, setting, value, not value)
		end
	end
	GuiText(gui, 0, 0, text)
end

local function GetThicknessLimit(value)
	local max = 4
	local position = value or ModSettingGetNextValue("meta_leveling.exp_bar_position")
	if position == "under_health" then
		max = 2
	end
	return max
end

local function SetThicknessLimit(mod_id, gui, in_main_menu, setting, old_value, new_value)
	local max = GetThicknessLimit(new_value)
	local index = get_cat_and_setting_index("exp_bar_cat", "exp_bar_thickness")
	mod_settings[index.cat].settings[index.set].value_max = max
end

local function GuiImageNoLayout(gui, id, x, y, img, alpha, scale_x, scale_y)
	local _, _, _, _, _, pw, ph = GuiGetPreviousWidgetInfo(gui)
	GuiImage(gui, id, x, y - ph, img, alpha, scale_x, scale_y)
	_, _, _, _, _, pw, ph = GuiGetPreviousWidgetInfo(gui)
	GuiText(gui, -pw, -ph, " ")
end

local function DrawBarColor(gui, id, x, y, width, height)
	local r = tonumber(ModSettingGetNextValue("meta_leveling.exp_bar_red")) or 1
	local g = tonumber(ModSettingGetNextValue("meta_leveling.exp_bar_green")) or 1
	local b = tonumber(ModSettingGetNextValue("meta_leveling.exp_bar_blue")) or 1
	GuiColorSetForNextWidget(gui, r, g, b, 1)
	GuiZSetForNextWidget(gui, 3)
	GuiImageNoLayout(gui, id, x, y, whitebox, 1, width, height)
end

local function DrawOutline(gui, id, x, y, width, height)
	GuiColorSetForNextWidget(gui, 0.4752, 0.2768, 0.2215, 1)
	GuiZSetForNextWidget(gui, 4)
	GuiImageNoLayout(gui, id, x, y, whitebox, 0.85, width, height)
end

local function Draw9PieceBox(gui, id, width, height)
	local _, _, _, x, y, w, h = GuiGetPreviousWidgetInfo(gui)
	GuiText(gui, 0 - w, 0 - h, "")
	GuiZSetForNextWidget(gui, 5)
	GuiImageNinePiece(gui, id, x - w, y - h, width, height, 1)
	GuiText(gui, 0, 0, " ")
end

local function DrawBarPosition(mod_id, gui, in_main_menu, im_id, setting)
	local gui_id = im_id
	local function id()
		gui_id = gui_id + 1
		return gui_id
	end
	local x = 110 + GetSliderOffset(gui, "exp_bar_cat")
	local _, _, _, _, _, _, h = GuiGetPreviousWidgetInfo(gui)
	local thickness = tonumber(ModSettingGetNextValue("meta_leveling.exp_bar_thickness")) * 0.7
	local position = ModSettingGetNextValue("meta_leveling.exp_bar_position")
	local width = 2.1
	local y_offset = 0 - h - 4 - 26 - 3
	GuiText(gui, x - 10, 26, " ")
	Draw9PieceBox(gui, id(), 66, 37.25)
	DrawOutline(gui, id(), x - 1, 3, width, 0.32) --outline
	_, _, _, _, _, _, h = GuiGetPreviousWidgetInfo(gui)
	GuiColorSetForNextWidget(gui, 0.53, 0.75, 0.1, 1)
	GuiImageNoLayout(gui, id(), x, 1, whitebox, 1, width - 0.1, 0.22) --hp bar

	y_offset = y_offset - h
	if position == "under_health" then
		DrawOutline(gui, id(), x - 1, 4.25, width, thickness / 10 + 0.05)
		DrawBarColor(gui, id(), x, 1, width - 0.1, thickness / 10 - 0.05)
		y_offset = y_offset - 5.35
	elseif position == "on_top" then
		DrawOutline(gui, id(), x - 1, -5, width, -(thickness / 10) - 0.05)
		DrawBarColor(gui, id(), x, -1, width - 0.1, -thickness / 10 + 0.05)
		y_offset = y_offset + 6
	elseif position == "on_left" then
		local x_side = 2
		DrawOutline(gui, id(), x - x_side, -1, -(thickness / 10) - 0.05, width / 2)
		DrawBarColor(gui, id(), x - x_side - 1, 1, -thickness / 10 + 0.05, width / 2 - 0.1)
	elseif position == "on_right" then
		local x_side = 42
		DrawOutline(gui, id(), x + x_side, -1, (thickness / 10) + 0.05, width / 2)
		DrawBarColor(gui, id(), x + x_side + 1, 1, thickness / 10 - 0.05, width / 2 - 0.1)
	end
	GuiText(gui, x, y_offset, " ")
end

local function BarPositinUI(mod_id, gui, in_main_menu, im_id, setting)
	local gui_id = im_id
	local function id()
		gui_id = gui_id + 1
		return gui_id
	end
	local value = ModSettingGetNextValue(mod_setting_get_id(mod_id, setting))
	GuiLayoutBeginHorizontal(gui, mod_setting_group_x_offset, 0, true)
	GuiText(gui, 0, 0, setting.ui_name .. ": ")
	for _, values in ipairs(setting.values) do
		display_fake_button(mod_id, gui, in_main_menu, id(), setting, "[" .. values[2] .. "]", value, values[1])
	end
	GuiLayoutEnd(gui)
end

local function OnClicks(setting_name, value, default)
	if InputIsMouseButtonJustDown(1) then
		GamePlaySound("ui", "ui/button_click", 0, 0)
		set_setting(setting_name, value)
	end
	if InputIsMouseButtonJustDown(2) then
		GamePlaySound("ui", "ui/button_click", 0, 0)
		set_setting(setting_name, default)
	end
end

local function toggle_checkbox_boolean(gui, id, setting, text, default)
	default = default or false
	local setting_name = tostring("meta_leveling." .. setting)
	local _, _, _, prev_x, y, prev_w = GuiGetPreviousWidgetInfo(gui)
	local x = prev_x + prev_w + 1
	local value = ModSettingGet(setting_name)
	local offset_w = GuiGetTextDimensions(gui, text) + 8

	GuiZSetForNextWidget(gui, -1)
	GuiImageNinePiece(gui, id(), x + 2, y, offset_w, 10, 0) --hover box
	local _, _, hovered = GuiGetPreviousWidgetInfo(gui)
	GuiZSetForNextWidget(gui, 1)
	GuiImageNinePiece(gui, id(), x + 2, y + 2, 6, 6) --check box

	GuiText(gui, 4, 0, "")
	if value then
		GuiColorSetForNextWidget(gui, 0, 0.8, 0, 1)
		GuiText(gui, 0, 0, "V")
		GuiText(gui, 0, 0, " ")
		YellowIfHovered(gui, hovered)
	else
		GuiColorSetForNextWidget(gui, 0.8, 0, 0, 1)
		GuiText(gui, 0, 0, "X")
		GuiText(gui, 0, 0, " ")
		YellowIfHovered(gui, hovered)
	end
	GuiText(gui, 0, 0, text)
	if hovered then
		OnClicks(setting_name, not value, default)
	end
end

local function DrawLevelUpSetting(mod_id, gui, in_main_menu, im_id, setting)
	local gui_id = im_id
	local function id()
		gui_id = gui_id + 1
		return gui_id
	end
	GuiLayoutBeginHorizontal(gui, 0, 0, true, 0, 0)
	GuiText(gui, mod_setting_group_x_offset, 0, "On level up: ")
	toggle_checkbox_boolean(gui, id, "session_exp_play_sound", "Play sound", true)
	toggle_checkbox_boolean(gui, id, "session_exp_play_fx", "Play FX", true)
	toggle_checkbox_boolean(gui, id, "session_exp_animate_bar", "Animate bar", true)
	GuiLayoutEnd(gui)
end

mod_settings =
{
	{
		category_id = "exp_bar_cat",
		ui_name = "Experience bar",
		ui_description = "Settings for experience bar",
		foldable = true,
		_folded = true,
		settings =
		{
			{
				ui_fn = DrawBarPosition,
				not_setting = true,
			},
			{
				id = "exp_bar_position",
				ui_name = "Position",
				ui_description = "Position of experience bar",
				value_default = "under_health",
				values = { { "under_health", "under health" }, { "on_left", "on left" }, { "on_right", "on right" }, { "on_top", "on top" } },
				scope = MOD_SETTING_SCOPE_RUNTIME,
				change_fn = SetThicknessLimit,
				ui_fn = BarPositinUI,
			},
			{
				id = "exp_bar_thickness",
				ui_name = "Bar thickness",
				ui_description = "How thick the bar is",
				value_default = 2,
				value_min = 1,
				value_max = GetThicknessLimit(),
				scope = MOD_SETTING_SCOPE_RUNTIME,
				ui_fn = mod_setting_number_integer,
				parent = "exp_bar_cat",
			},
			{
				id = "exp_bar_red",
				ui_name = "Red amount",
				value_default = 0,
				value_min = 0,
				value_max = 1,
				value_display_multiplier = 255,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				ui_fn = mod_setting_number_float,
				parent = "exp_bar_cat",
			},
			{
				id = "exp_bar_green",
				ui_name = "Green amount",
				value_default = 0.5,
				value_min = 0,
				value_max = 1,
				value_display_multiplier = 255,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				ui_fn = mod_setting_number_float,
				parent = "exp_bar_cat",
			},
			{
				id = "exp_bar_blue",
				ui_name = "Blue amount",
				value_default = 0,
				value_min = 0,
				value_max = 1,
				value_display_multiplier = 255,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				ui_fn = mod_setting_number_float,
				parent = "exp_bar_cat",
			},
		},
	},
	{
		category_id = "gameplay_cat",
		ui_name = "Gameplay",
		ui_description = "In-game relating settings",
		foldable = true,
		_folded = true,
		settings =
		{
			{
				id = "session_exp_play_sound",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				hidden = true,
			},
			{
				id = "session_exp_play_fx",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				hidden = true,
			},
			{
				id = "session_exp_animate_bar",
				value_default = true,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				hidden = true,
			},
			{
				ui_fn = DrawLevelUpSetting,
				not_setting = true,
			},
			{
				id = "session_exp_multiplier",
				ui_name = "EXP multiplier",
				value_default = 1,
				value_min = 0.1,
				value_max = 3,
				scope = MOD_SETTING_SCOPE_RUNTIME,
				value_display_multiplier = 100,
				ui_fn = mod_setting_number_float,
				parent = "gameplay_cat",
				format = "%"
			},
		},
	},
}

function ModSettingsUpdate(init_scope)
	local old_version = mod_settings_get_version(mod_id)
	mod_settings_update(mod_id, mod_settings, init_scope)
end

function ModSettingsGuiCount()
	return mod_settings_gui_count(mod_id, mod_settings)
end

function ModSettingsGui(gui, in_main_menu)
	mod_settings_gui(mod_id, mod_settings, gui, in_main_menu)
end
