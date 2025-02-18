--- @class ml_temp_tinkering_gui:UI_class
local gui = dofile("mods/meta_leveling/files/scripts/lib/ui_lib.lua")
gui.buttons.img = "mods/meta_leveling/files/gfx/ui/ui_9piece_button.png"
gui.buttons.img_hl = "mods/meta_leveling/files/gfx/ui/ui_9piece_button_highlight.png"
gui.tooltip_img = "mods/meta_leveling/files/gfx/ui/ui_9piece_tp.png"
gui.picked = {}
gui.picked_count = 0
gui.lifetime = 99999

local helper_lib = dofile_once("mods/meta_leveling/files/entities/gui/gui_entity_helper.lua") ---@type ML_gui_entity_helper

---Renders tooltip content
---@private
function gui:ExtraGuiTooltip()
	self:Text(0, 0, self:Locale("$ml_tinkering_leftclick"))
	self:Text(0, 0, self:Locale("$ml_notification_close"))
	self:ColorGray()
	self:Text(0, 0, self:Locale("$ml_notification_close_time ") .. self.lifetime)
end

local helper = helper_lib:new(gui, "data/ui_gfx/perk_icons/edit_wands_everywhere.png", gui.ExtraGuiTooltip)

--- Draws gui
--- @return boolean
function gui:Draw()
	self:StartFrame()
	self.lifetime = helper:get_duration()
	if self.lifetime < 0 then return true end
	self.player = EntityGetWithTag("player_unit")[1]
	if not self.player then return false end
	self.dim.x, self.dim.y = GuiGetScreenDimensions(self.gui)
	if helper.opened then
		local duration = tonumber(ModSettingGet("meta_leveling.progress_tinker_at_start")) or 0
		local effect_entity = EntityCreateNew("META_LEVELING_BUFF_EDIT_WANDS_EVERYWHERE")
		EntityLoadToEntity("data/entities/misc/effect_edit_wands_everywhere.xml", effect_entity)
		local effect_component = EntityGetFirstComponent(effect_entity, "GameEffectComponent")
		if effect_component then ComponentSetValue2(effect_component, "frames", duration * 3600) end
		EntityAddComponent2(effect_entity, "UIIconComponent", {
			icon_sprite_file = "mods/meta_leveling/files/gfx/ui/icons/tinker.png",
			name = "$perk_edit_wands_everywhere",
			description = "[Meta Leveling]\n" .. "$perkdesc_edit_wands_everywhere",
			is_perk = false,
		})
		EntityAddChild(self.player, effect_entity)
		helper:set_closed()
		return true
	else
		return helper:draw_notification()
	end
end

return gui
