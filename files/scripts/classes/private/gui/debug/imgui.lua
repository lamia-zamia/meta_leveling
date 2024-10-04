if not load_imgui then return end
local required_version = "1.24.0" -- 1.24.0 suppors vfs images now

local imgui = load_imgui({ version = required_version, mod = "Meta Leveling" }) ---@type ImGui
local imgui_xml_img_viewer = dofile_once("mods/meta_leveling/files/scripts/classes/private/gui/debug/xml_img_viewer.lua") ---@type imgui_xml_img_viewer
local xml_viewer = imgui_xml_img_viewer:new(imgui)
local UI_lib = dofile_once("mods/meta_leveling/files/scripts/lib/ui_lib.lua") ---@type UI_class
local UI = UI_lib:New() ---@class UI_class

---@class ml_debug
---@field rewards? boolean
---@field deck? boolean
---@field numbers table
---@field misc? boolean
---@field gui gui
local debug = {
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
	child_flags = bit.bor(
		imgui.WindowFlags.NoBackground,
		imgui.WindowFlags.NoScrollbar,
		imgui.WindowFlags.NoScrollWithMouse,
		imgui.WindowFlags.NoSavedSettings
	),
	main_flags = bit.bor(
		imgui.WindowFlags.NoDocking,
		imgui.WindowFlags.AlwaysAutoResize,
		imgui.WindowFlags.NoResize
	)
}

---Render icon in real gui
---@private
---@param reward ml_single_reward_data
function debug:draw_icon_in_game(reward)
	local function draw(x, y)
		UI:Draw9Piece(x - 1, y - 1, -5000, 18, 18, "mods/meta_leveling/files/gfx/ui/ui_9piece_reward.png")
		UI:SetZ(-6000)
		local r, g, b, a = unpack(reward.border_color)
		UI:Color(r, g, b)
		UI:Image(x - 4, y - 4, "mods/meta_leveling/files/gfx/ui/reward_glow.png", a)
		UI:SetZ(-7000)
		UI:Image(x, y, reward.ui_icon)
	end
	local x = 610
	local y = 330
	UI:StartFrame()
	UI:Draw9Piece(x - 41, y - 6, -3000, 28, 28)
	draw(x, y)
	draw(x - 35, y)
end

---Close itself
---@private
---:)
function debug:close()
	ModSettingSet("meta_leveling.debug_window", false)
end

---Draws image or xml
---@private
---@param size number
---@param icon string
function debug:draw_reward_icon(size, icon)
	if icon:find("%.xml$") then
		if xml_viewer:can_display_xml(icon) then
			local offset = xml_viewer:get_offset()
			if offset then
				local pos_x, pos_y = imgui:GetCursorPos()
				imgui.SetCursorPos(pos_x - offset.x * self.scale, pos_y - offset.y * self.scale)
			end
			xml_viewer:show("default", size * self.scale, size * self.scale)
		else
			imgui.Text(xml_viewer:error_message())
		end
	else
		local img = imgui.LoadImage(icon)
		if img then
			imgui.Image(img, size * self.scale, size * self.scale)
		end
	end
end

---Draw a 9-slice sprite in ImGui with scaling support
---@private
---@param image any -- ImGui texture identifier (e.g., from imgui.LoadImage)
---@param width number -- Total width of the final drawn piece
---@param height number -- Total height of the final drawn piece
function debug:ImGui9Piece(image, width, height)
	local img = imgui.LoadImage(image)
	if not img then return end
	local image_size = img.height
	local patch = image_size / 3

	width = width * self.scale
	height = height * self.scale
	local scaled_patch = patch * self.scale
	local pos_x, pos_y = imgui.GetCursorPos()
	-- Calculate UV coordinates for the 9 segments of the image
	local uv = {
		top_left = { 0, 0, patch / image_size, patch / image_size },
		top_right = { (image_size - patch) / image_size, 0, 1, patch / image_size },
		bottom_left = { 0, (image_size - patch) / image_size, patch / image_size, 1 },
		bottom_right = { (image_size - patch) / image_size, (image_size - patch) / image_size, 1, 1 },
		top = { patch / image_size, 0, (image_size - patch) / image_size, patch / image_size },
		bottom = { patch / image_size, (image_size - patch) / image_size, (image_size - patch) / image_size, 1 },
		left = { 0, patch / image_size, patch / image_size, (image_size - patch) / image_size },
		right = { (image_size - patch) / image_size, patch / image_size, 1, (image_size - patch) / image_size },
		center = { patch / image_size, patch / image_size, (image_size - patch) / image_size, (image_size - patch) / image_size },
	}

	-- Render corners with scaling
	imgui.SetCursorPos(pos_x, pos_y)
	imgui.Image(img, scaled_patch, scaled_patch, uv.top_left[1], uv.top_left[2], uv.top_left[3], uv.top_left[4]) -- Top-left

	imgui.SetCursorPos(pos_x + width - scaled_patch, pos_y)
	imgui.Image(img, scaled_patch, scaled_patch, uv.top_right[1], uv.top_right[2], uv.top_right[3], uv.top_right[4]) -- Top-right

	imgui.SetCursorPos(pos_x, pos_y + height - scaled_patch)
	imgui.Image(img, scaled_patch, scaled_patch, uv.bottom_left[1], uv.bottom_left[2], uv.bottom_left[3],
		uv.bottom_left[4]) -- Bottom-left

	imgui.SetCursorPos(pos_x + width - scaled_patch, pos_y + height - scaled_patch)
	imgui.Image(img, scaled_patch, scaled_patch, uv.bottom_right[1], uv.bottom_right[2], uv.bottom_right[3],
		uv.bottom_right[4]) -- Bottom-right

	-- Render borders with scaling
	imgui.SetCursorPos(pos_x + scaled_patch, pos_y)
	imgui.Image(img, width - 2 * scaled_patch, scaled_patch, uv.top[1], uv.top[2], uv.top[3], uv.top[4]) -- Top border

	imgui.SetCursorPos(pos_x + scaled_patch, pos_y + height - scaled_patch)
	imgui.Image(img, width - 2 * scaled_patch, scaled_patch, uv.bottom[1], uv.bottom[2], uv.bottom[3], uv.bottom[4]) -- Bottom border

	imgui.SetCursorPos(pos_x, pos_y + scaled_patch)
	imgui.Image(img, scaled_patch, height - 2 * scaled_patch, uv.left[1], uv.left[2], uv.left[3], uv.left[4]) -- Left border

	imgui.SetCursorPos(pos_x + width - scaled_patch, pos_y + scaled_patch)
	imgui.Image(img, scaled_patch, height - 2 * scaled_patch, uv.right[1], uv.right[2], uv.right[3], uv.right[4]) -- Right border

	-- Render center with scaling
	imgui.SetCursorPos(pos_x + scaled_patch, pos_y + scaled_patch)
	imgui.Image(img, width - 2 * scaled_patch, height - 2 * scaled_patch, uv.center[1], uv.center[2], uv.center[3],
		uv.center[4])
end

---Draws icon with borders
---@private
---@param reward ml_single_reward_data
---@param id number window id
---@return boolean
function debug:draw_reward_full_icon(reward, id)
	local size = 16
	local margin = 8
	local cursor_offset = margin / 2 * self.scale
	local box_size = size + margin
	local pos_x, pos_y = imgui.GetCursorPos()

	local border_img = imgui.LoadImage("mods/meta_leveling/files/gfx/ui/reward_glow.png")
	local border_img_size = box_size * self.scale
	local r, g, b, a = unpack(reward.border_color)
	imgui.Image(border_img, border_img_size, border_img_size, 0, 0, 1, 1, r, g, b, a)
	imgui.SetCursorPos(pos_x + cursor_offset, pos_y + cursor_offset)
	if imgui.BeginChild(reward.id .. id, size * self.scale, size * self.scale, 0, self.child_flags) then ---@diagnostic disable-line: param-type-mismatch
		self:draw_reward_icon(size, reward.ui_icon)
		imgui.EndChild()
	end
	imgui.SetCursorPos(pos_x, pos_y)
	local hovered = imgui.IsItemHovered()
	local border = hovered and "mods/meta_leveling/files/gfx/ui/ui_9piece_reward_highlight.png" or
		"mods/meta_leveling/files/gfx/ui/ui_9piece_reward.png"
	self:ImGui9Piece(border, box_size, box_size)
	return hovered
end

---Draws text in gray
---@private
---@param text any
function debug:gray_text(text)
	imgui.PushStyleColor(0, 0.6, 0.6, 0.6)
	imgui.Text(tostring(text))
	imgui.PopStyleColor()
end

---Draws text in gray and white
---@private
---@param gray any
---@param normal any
---@param addition? any
function debug:gray_normal_text(gray, normal, addition)
	self:gray_text(gray)
	imgui.SameLine()
	imgui.Text(tostring(normal))
	if addition then
		imgui.SameLine()
		self:gray_text(tostring(addition))
	end
end

---Draws tooltip for reward
---@private
---@param reward ml_single_reward_data
function debug:reward_description(reward)
	self:gray_normal_text("id: ", reward.id --[[@as string]])
	self:gray_normal_text("name: ", ML.rewards_deck.FormatString(UI:Locale(reward.ui_name)),
		" (" .. reward.ui_name .. ")")
	if reward.description then
		self:gray_normal_text("desk: ", ML.rewards_deck:UnpackDescription(reward.description, reward.description_var))
	end
	if reward.description2 then
		self:gray_normal_text("desk2: ", ML.rewards_deck:UnpackDescription(reward.description2, reward.description2_var))
	end
	self:gray_normal_text("prob: ", ML.rewards_deck:get_probability(reward.probability)) ---@diagnostic disable-line: invisible
	if reward.max < 1280 then
		self:gray_normal_text("max: ", reward.max)
	end
	if reward.limit_before then
		self:gray_normal_text("not before: ", reward.limit_before)
	end
	if reward.custom_check then
		self:gray_normal_text("custom check: ", reward.custom_check())
	end
	if reward.min_level > 1 then
		self:gray_normal_text("min level: ", reward.min_level)
	end
end

---Draws reward menu
---@private
---:)
function debug:draw_rewards()
	local interval = 30 * self.scale
	local width = imgui.GetWindowWidth()
	_, self.rewards_search = imgui.InputText("search", self.rewards_search)
	imgui.SameLine()
	if imgui.Button("clear") then
		self.rewards_search = ""
	end
	for i, reward in ipairs(ML.rewards_deck.ordered_rewards_data) do
		if self.rewards_search ~= "" and not string.find(reward.id, self.rewards_search) then ---@diagnostic disable-line: param-type-mismatch
			goto continue
		end
		local pos_x, pos_y = imgui.GetCursorPos()
		if pos_x + interval * 2 >= width then
			pos_y = pos_y + interval
			pos_x = 8
		else
			pos_x = pos_x + interval
		end
		if self:draw_reward_full_icon(reward, i) then
			self:draw_icon_in_game(reward)
			if imgui.BeginTooltip() then
				self:reward_description(reward)
				imgui.EndTooltip()
			end
			if imgui.IsMouseClicked(imgui.MouseButton.Left) then
				ML.rewards_deck:pick_reward(reward.id)
			end
		end
		imgui.SetCursorPos(pos_x, pos_y)
		::continue::
	end
	xml_viewer:advance_frame()
end

---Draws deck
---@private
function debug:draw_deck()
	if #ML.rewards_deck.list == 0 then ML.rewards_deck:refresh_reward_order() end ---@diagnostic disable-line: invisible
	local list = ML.rewards_deck.list ---@diagnostic disable-line: invisible
	local current_index = MLP.get:global_number(MLP.const.globals.draw_index, 1)
	imgui.Text("Deck, current index: " .. current_index .. ", total number: " .. #list)

	local interval = 30 * self.scale
	local width = imgui.GetWindowWidth()

	for i, reward_id in ipairs(list) do
		local reward = ML.rewards_deck.reward_data[reward_id]
		local pos_x, pos_y = imgui.GetCursorPos()
		if pos_x + interval * 2 >= width then
			pos_y = pos_y + interval
			pos_x = 8
		else
			pos_x = pos_x + interval
		end
		if self:draw_reward_full_icon(reward, i) then
			-- self:draw_icon_in_game(reward)
			if imgui.BeginTooltip() then
				self:reward_description(reward)
				imgui.EndTooltip()
			end
		end
		imgui.SetCursorPos(pos_x, pos_y)
	end
	xml_viewer:advance_frame()
end

---Gets current data
---@private
---:)
function debug:fetch_current()
	self.numbers.level = ML:get_level()
	self.numbers.experience = MLP.exp:current()
	self.numbers.meta = MLP.points:get_current_currency()
end

---Draws number menu
---@private
---:)
function debug:draw_numbers()
	if imgui.Button("Reset to current") then
		self:fetch_current()
	end
	_, self.numbers.level = imgui.InputInt("level", self.numbers.level, 1, 10)
	if imgui.IsItemDeactivatedAfterEdit() then
		MLP.set:global_number(MLP.const.globals.current_exp, ML.level_curve[self.numbers.level - 1])
		MLP.set:global_number(MLP.const.globals.current_level, self.numbers.level - 1)
		ML:level_up()
		self:fetch_current()
	end
	_, self.numbers.experience = imgui.InputFloat("experience", self.numbers.experience, 10, 1000)
	if imgui.IsItemDeactivatedAfterEdit() then
		MLP.set:global_number(MLP.const.globals.current_exp, self.numbers.experience)
		self:fetch_current()
	end
	_, self.numbers.meta = imgui.InputFloat("meta points", self.numbers.meta, 1, 10)
	if imgui.IsItemDeactivatedAfterEdit() then
		MLP.points:set_meta_points(self.numbers.meta)
		self:fetch_current()
	end
end

function debug:add_orb()
	local orb_e = EntityCreateNew()
	EntityAddComponent2(orb_e, "OrbComponent", {
		orb_id = GameGetOrbCountThisRun() + 50
	})
	EntityAddComponent2(orb_e, "ItemComponent", {
		enable_orb_hacks = true
	})
	GamePickUpInventoryItem(ML.player.id, orb_e, false)
end

---Draws some trash
---@private
---:)
function debug:draw_misc()
	if imgui.Button("Add orbs") then
		self:add_orb()
	end
	if imgui.Button("Pick Sampo") then
		local sampo_e = EntityLoad("data/entities/animals/boss_centipede/sampo.xml", 10000, 10000)
		GamePickUpInventoryItem(ML.player.id, sampo_e, false)
	end
	if imgui.Button("KYS") then
		local gsc_id = ML.player:get_component_by_name("GameStatsComponent")
		if gsc_id then
			ComponentSetValue2(gsc_id, "extra_death_msg", "Killed by debug")
		end
		EntityKill(ML.player.id)
	end
	imgui.Text("Meta points")
	imgui.Text("Speed bonus: " ..
		string.format("%.2f", MLP.points:CalculateMetaPointsSpeedBonus()) ..
		", minutes: " .. string.format("%.2f", GameGetFrameNum() / 60 / 60))
	imgui.Text("Pacifist bonus: " .. MLP.points:CalculateMetaPointsPacifistBonus())
	imgui.Text("Orb bonus: " .. MLP.points:CalculateMetaPointsOrbs())
	imgui.Text("Damage bonus: " .. MLP.points:CalculateMetaPointsDamageTaken())
	imgui.Text("Fungal shift bonus: " .. MLP.points:CalculateMetaPointsFungalShift())
	imgui.Text("Streak bonus: " ..
		MLP.points:CalculateMetaPointsWinStreakBonus() .. ", streak: " .. ModSettingGet("meta_leveling.streak_count"))
	imgui.Text("You will be rewarded for " .. MLP:CalculateMetaPointsOnSampo() .. " points")
end

---Draws child windows
---@private
---:)
function debug:draw_childs()
	if self.rewards then
		local rewards_show
		rewards_show, self.rewards = imgui.Begin("ML Rewards", self.rewards)
		if rewards_show then
			imgui.PushFont(imgui.GetNoitaFont1_4x())
			self:draw_rewards()
			imgui.PopFont()
			imgui.End()
		end
	end
	if self.deck then
		local deck_show
		deck_show, self.deck = imgui.Begin("ML Deck", self.deck)
		if deck_show then
			self:draw_deck()
			imgui.End()
		end
	end
	if self.numbers.show then
		local numbers_show
		numbers_show, self.numbers.show = imgui.Begin("ML Numbers", self.numbers.show)
		if numbers_show then
			self:draw_numbers()
			imgui.End()
		end
	end
	if self.misc then
		local misc_show
		misc_show, self.misc = imgui.Begin("Misc", self.misc)
		if misc_show then
			self:draw_misc()
			imgui.End()
		end
	end
end

---Draws debug window
function debug:draw()
	if not self.gui then
		self.gui = GuiCreate()
		self:fetch_current()
	end
	local show, open = imgui.Begin("Meta Leveling", true, self.main_flags)
	if show then
		imgui.Text("Welcome to Meta Leveling Debug")
		if imgui.Button("Rewards") then
			self.rewards = not self.rewards
		end
		if imgui.Button("Deck") then
			self.deck = not self.deck
		end
		if imgui.Button("Numbers") then
			self.numbers.show = not self.numbers.show
		end
		if imgui.Button("Misc") then
			self.misc = not self.misc
		end
		imgui.End()
	end

	self:draw_childs()

	if not open then
		self:close()
		GuiDestroy(self.gui)
	end
end

return debug


-- I figured out a way.
-- For the top-left corner I use ImGui::GetCursorScreenPos().
-- For the bot-right corner I use ImGui::GetWindowPos() + ImGui::GetWindowSize().
-- Since the bot-right corner gets too close to the border, I substract a small offset: ImGui::GetWindowPos() + ImGui::GetWindowSize() - (5, 5). Note this is not true code, just pseudocode.
