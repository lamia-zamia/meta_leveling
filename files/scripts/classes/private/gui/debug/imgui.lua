if not load_imgui then return end
local required_version = "1.24.0" -- 1.24.0 suppors vfs images now

local imgui = load_imgui({ version = required_version, mod = "Meta Leveling" }) ---@type ImGui
local imgui_xml_img_viewer = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui/debug/xml_img_viewer.lua") ---@type imgui_xml_img_viewer
local xml_viewer = imgui_xml_img_viewer:new(imgui)

---@class ml_debug
local debug = {
	icon_size = 16 * 4
}
debug.orderedPairs = dofile_once("mods/meta_leveling/files/scripts/classes/private/ordered_pairs.lua")

function debug:close()
	ModSettingSet("meta_leveling.debug_window", false)
end

---@param icon string
function debug:draw_reward_pic(icon)
	if icon:find("%.xml$") then
		if xml_viewer:can_display_xml(icon) then
			xml_viewer:show("default", self.icon_size, self.icon_size)
		end
	else
		local img = imgui.LoadImage(icon)
		if img then
			imgui.Image(img, self.icon_size, self.icon_size)
		end
	end
end

function debug:main_window()
	imgui.Text("text")
	---@type ml_single_reward_data
	for _, reward in self:orderedPairs(ML.rewards_deck.reward_data) do
		self:draw_reward_pic(reward.ui_icon)
	end
end

function debug:draw()
	local show, open = imgui.Begin("Meta Leveling Menu", true)
	if not show then return end
	self:main_window()
	xml_viewer:advance_frame()
	imgui.End()
	if not open then self:close() end
end

return debug
