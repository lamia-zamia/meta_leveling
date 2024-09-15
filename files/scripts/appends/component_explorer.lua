local menu_extensions = dofile_once("mods/component-explorer/menu_extensions.lua")
menu_extensions.list[#menu_extensions.list+1] = {
    category = "Meta Leveling",
    name = "Debug",
    is_enabled = function()
        return not not ModSettingGet("meta_leveling.debug_window")
    end,
    set_enabled = function(enabled)
        ModSettingSet("meta_leveling.debug_window", enabled)
    end,
    -- These are optional. Please be careful with adding new shortcuts since
    -- it's easy to step on someone else's toes with this.
    -- shortcut = "CTRL+SHIFT+N",
    -- check_shortcut = function()
    --     return imgui.IsKeyPressed(imgui.Key.N)
    -- end
}