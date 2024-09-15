--[[ WIP, imgui doesn't support vfs images
if not load_imgui then return end

---@type ImGui
local imgui = load_imgui({ version = "1.7.0", mod = "Meta Leveling" })

local debug = {}

debug.orderedPairs = dofile_once("mods/meta_leveling/files/scripts/classes/private/ordered_pairs.lua")

function debug:close()
	ModSettingSet("meta_leveling.debug_window", false)
end

function debug:main_window()
	imgui.Text("text")
	for _, reward in self:orderedPairs(ML.rewards_deck.reward_data) do
		local img = imgui.LoadImage(reward.ui_icon)
		if img then
			imgui.Image(img, 64, 64)
		else
			print(reward.ui_icon)
		end
	end
end

function debug:draw()
	local show, open = imgui.Begin("Meta Leveling Menu", true, imgui.WindowFlags.MenuBar)
	if not show then return end
	self:main_window()
	imgui.End()
	if not open then self:close() end
end

return debug
]]
