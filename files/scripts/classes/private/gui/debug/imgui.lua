if not load_imgui then return end
local required_version = "1.24.0" -- 1.24.0 suppors vfs images now

local imgui_xml_img_viewer = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui/debug/xml_img_viewer.lua") --- @type imgui_xml_img_viewer

--- @class ml_debug
--- @field rewards? boolean
--- @field deck? boolean
--- @field numbers table
--- @field misc? boolean
--- @field gui gui
local debug = {
	imgui = load_imgui({ version = required_version, mod = "Meta Leveling" }), --- @type ImGui
	scale = 3,
	rewards = false,
	rewards_search = "",
	numbers = {
		show = false,
		level = 1,
		experience = 0,
	},
	misc = false,
	deck = false,
}

debug.xml_viewer = imgui_xml_img_viewer:new(debug.imgui)
debug.child_flags = bit.bor(
	debug.imgui.WindowFlags.NoBackground,
	debug.imgui.WindowFlags.NoScrollbar,
	debug.imgui.WindowFlags.NoScrollWithMouse,
	debug.imgui.WindowFlags.NoSavedSettings
)
debug.main_flags = bit.bor(debug.imgui.WindowFlags.NoDocking, debug.imgui.WindowFlags.AlwaysAutoResize, debug.imgui.WindowFlags.NoResize)

local modules = {
	"mods/meta_leveling/files/scripts/classes/private/gui/debug/imgui_ui_lib.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/debug/imgui_helper.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/debug/imgui_rewards.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/debug/imgui_deck.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/debug/imgui_misc.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/debug/imgui_icons.lua",
	"mods/meta_leveling/files/scripts/classes/private/gui/debug/imgui_numbers.lua",
}

for _, module_name in ipairs(modules) do
	local module = dofile_once(module_name)
	if not module then error("couldn't load " .. module_name) end
	for k, v in pairs(module) do
		debug[k] = v
	end
end

--- Close itself
--- @private
--- :)
function debug:close()
	ModSettingSet("meta_leveling.debug_window", false)
end

--- Draws child windows
--- @private
--- :)
function debug:draw_children()
	if self.rewards then
		local rewards_show
		rewards_show, self.rewards = self.imgui.Begin("ML Rewards", self.rewards)
		if rewards_show then
			self.imgui.PushFont(self.imgui.GetNoitaFont1_4x())
			self:draw_rewards()
			self.imgui.PopFont()
			self.imgui.End()
		end
	end
	if self.deck then
		local deck_show
		deck_show, self.deck = self.imgui.Begin("ML Deck", self.deck)
		if deck_show then
			self:draw_deck()
			self.imgui.End()
		end
	end
	if self.numbers.show then
		local numbers_show
		numbers_show, self.numbers.show = self.imgui.Begin("ML Numbers", self.numbers.show)
		if numbers_show then
			self:draw_numbers()
			self.imgui.End()
		end
	end
	if self.misc then
		local misc_show
		misc_show, self.misc = self.imgui.Begin("Misc", self.misc)
		if misc_show then
			self:draw_misc()
			self.imgui.End()
		end
	end
end

--- Draws debug window
function debug:draw()
	if not self.gui then
		self.gui = GuiCreate()
		self:fetch_current()
	end
	local show, open = self.imgui.Begin("Meta Leveling", true, self.main_flags)
	if show then
		self.imgui.Text("Welcome to Meta Leveling Debug")
		if self.imgui.Button("Rewards") then self.rewards = not self.rewards end
		if self.imgui.Button("Deck") then self.deck = not self.deck end
		if self.imgui.Button("Numbers") then self.numbers.show = not self.numbers.show end
		if self.imgui.Button("Misc") then self.misc = not self.misc end
		self.imgui.End()
	end

	self:draw_children()

	if not open then
		self:close()
		GuiDestroy(self.gui)
	end
end

return debug
