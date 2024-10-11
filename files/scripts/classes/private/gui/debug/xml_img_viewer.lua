local nxml = dofile_once("mods/meta_leveling/files/scripts/lib/nxml.lua")        --- @type nxml

local required_fields = { "frame_count", "frame_width", "frame_height", "name" } -- Fields that must be present in each RectAnimation

--- @class imgui_xml_img_viewer
--- @field private __index imgui_xml_img_viewer -- Metatable index
--- @field private imgui ImGui -- Reference to ImGui instance
--- @field private data { [string]: imgui_xml_img_viewer_content } -- Table containing animation data indexed by file path
--- @field private path string -- Current XML file path being viewed
--- @field private frame number -- Current frame number for animations
local xml_viewer = {
	data = setmetatable({}, { __mode = "k" }), -- Data is weak-keyed to allow garbage collection
	frame = 0                               -- Initializes frame counter
}
xml_viewer.__index = xml_viewer

--- Create a new instance of imgui_xml_img_viewer
--- @param imgui ImGui -- ImGui instance used for rendering
--- @return imgui_xml_img_viewer
--- @nodiscard
function xml_viewer:new(imgui)
	local o = setmetatable({}, self)
	o.imgui = imgui
	return o
end

--- Defines the structure of animation data within the viewer
--- @class (exact) imgui_xml_img_viewer_content_animation
--- @field frame_count number -- Number of frames in the animation
--- @field frame_width number -- Width of each animation frame
--- @field frame_height number -- Height of each animation frame
--- @field pos_x number -- X position of the animation in the spritesheet
--- @field pos_y number -- Y position of the animation in the spritesheet
--- @field frame_wait number -- Time to wait between frames (in seconds)

--- Defines the structure for the content of the XML viewer
--- @class (exact) imgui_xml_img_viewer_content
--- @field valid boolean -- Indicates if the XML data is valid
--- @field error? string -- Error message if XML is invalid
--- @field xml_content string -- Raw content of the XML file
--- @field spritesheet_path string -- Path to the spritesheet image
--- @field sprite_offset? { x: number, y: number}
--- @field default_animation string -- The default animation to display
--- @field animation_list string[] -- List of animation names found in the XML
--- @field animation { [string]: imgui_xml_img_viewer_content_animation } -- Table of animations, keyed by name

--- Marks the XML path as invalid and stores an error message
--- @param message string
--- @private -- Error message to display
function xml_viewer:xml_set_invalid(message)
	self.data[self.path] = { --- @diagnostic disable-line: missing-fields
		valid = false,
		error = message
	}
end

--- Verifies that the required fields and attributes exist in the XML
--- @private
--- @param xml element -- XML root element
--- @return boolean -- Returns true if verification passes, false otherwise
function xml_viewer:verify_xml(xml)
	-- Ensure the 'filename' attribute exists in the root element
	if not xml.attr.filename then
		self:xml_set_invalid("Couldn't find filename in " .. self.path)
		return false
	end

	local filename = xml.attr.filename
	-- Check if the spritesheet image exists
	if not ModImageDoesExist(filename) then
		self:xml_set_invalid("Image file " .. filename .. " is not found")
		return false
	end

	-- Ensure 'default_animation' attribute is present
	local default_animation = xml.attr.default_animation
	if not default_animation then
		self:xml_set_invalid("There is no default_animation")
		return false
	end

	-- Verify each RectAnimation element has the required fields
	local anim_count = 0
	for rect_animation in xml:each_of("RectAnimation") do
		anim_count = anim_count + 1
		for _, key in ipairs(required_fields) do
			if not rect_animation.attr[key] then
				self:xml_set_invalid("Missing key " .. key .. " in rectAnimation")
				return false
			end
		end
		-- Ensure frame_wait is not too low (minimum: 0.01 seconds)
		if rect_animation.attr.frame_wait and tonumber(rect_animation.attr.frame_wait) < 0.01 then
			self:xml_set_invalid("frame_wait is too low, min: 0.01")
			return false
		end
	end
	-- Ensure at least one RectAnimation exists
	if anim_count == 0 then
		self:xml_set_invalid("Couldn't find any RectAnimation")
		return false
	end

	return true
end

--- Sets sprite offset value if any
--- @param element element
--- @return { x: number, y: number}?
function xml_viewer:set_offset(element)
	local x = element.attr.offset_x or nil
	local y = element.attr.offset_y or nil
	if x or y then
		return {
			x = x or 0,
			y = y or 0
		}
	end
	return nil
end

--- Returns sprite offset if any
--- @return { x: number, y: number}?
function xml_viewer:get_offset()
	return self.data[self.path].sprite_offset
end

--- Initialization and validation of the XML file
--- @private
--- @return boolean -- Returns true if initialization succeeds
function xml_viewer:init_xml()
	-- Check if the path is valid and is an XML file
	if not self.path or not ModDoesFileExist(self.path) or not self.path:find("%.xml$") then
		self:xml_set_invalid(self.path .. " is invalid")
		return false
	end
	local content = ModTextFileGetContent(self.path)

	-- Parse the XML content and handle errors
	local success, xml = pcall(nxml.parse, content)
	if not success then
		self:xml_set_invalid("Invalid xml, error: " .. xml)
		return false
	end

	-- Validate the XML structure
	if not self:verify_xml(xml) then return false end

	-- Parse the XML and populate viewer data
	local animation_list, animation = self:parse(xml)
	self.data[self.path] = {
		animation_list = animation_list,
		animation = animation,
		spritesheet_path = xml.attr.filename,
		default_animation = xml.attr.default_animation,
		xml_content = content,
		sprite_offset = self:set_offset(xml),
		valid = true
	}
	return true
end

--- Sets the content of the XML file
--- @param path string path to xml file
--- @param content string content of xml path
function xml_viewer:set_content(path, content)
	self.path = path
	ModTextFileSetContent(path, content)
end

--- Checks if the XML can be displayed and initializes it if necessary
--- @param path string -- path to xml file
--- @param force_init? boolean -- Optional flag to bypass the cache
--- @return boolean can_display -- Returns true if XML can be displayed
--- @nodiscard
function xml_viewer:can_display_xml(path, force_init)
	self.path = path
	if force_init or not self.data[self.path] then return self:init_xml() end
	return self.data[self.path].valid
end

--- Parses the XML and extracts animation data
--- @private
--- @param xml element -- XML root element
--- @return string[] animation_list, { [string]: imgui_xml_img_viewer_content_animation }
function xml_viewer:parse(xml)
	local contents = {}
	local animation_list = {}
	-- Iterate over all RectAnimation elements in the XML
	for rect_animation in xml:each_of("RectAnimation") do
		local attr = rect_animation.attr
		local name = attr.name -- Get animation name
		animation_list[#animation_list + 1] = name
		-- Extract animation attributes and store them
		contents[name] = {
			frame_count = tonumber(attr.frame_count),
			frame_width = tonumber(attr.frame_width),
			frame_height = tonumber(attr.frame_height),
			pos_x = tonumber(attr.pos_x) or 0,
			pos_y = tonumber(attr.pos_y) or 0,
			frame_wait = tonumber(attr.frame_wait) or 0.01
		}
	end
	return animation_list, contents
end

--- Returns the current frame for the given animation
--- @private
--- @param anim imgui_xml_img_viewer_content_animation
--- @return number
function xml_viewer:get_frame(anim)
	return math.floor(self.frame / anim.frame_wait / 60) % anim.frame_count
end

--- Displays the current frame of the animation
--- @param animation? string -- Optional animation name to display
--- @param width? number -- Optional width of the image
--- @param height? number -- Optional height of the image
--- @param frame? number -- Optional frame to display
function xml_viewer:show(animation, width, height, frame)
	local data = self.data[self.path]
	animation = animation or data.default_animation
	local anim = data.animation[animation]

	-- Set default width and height if not provided
	width = width or anim.frame_width
	height = height or anim.frame_height

	-- Load the spritesheet image
	local img = self.imgui.LoadImage(data.spritesheet_path)
	if img then
		-- Get the current frame to display
		local current_frame = frame or self:get_frame(anim)
		local frame_column = current_frame % anim.frame_count
		local frame_row = math.floor(current_frame / anim.frame_count)

		-- Calculate UV coordinates for the image
		local uv0_x = (anim.pos_x + frame_column * anim.frame_width) / img.width
		local uv0_y = (anim.pos_y + frame_row * anim.frame_height) / img.height
		local uv1_x = uv0_x + anim.frame_width / img.width
		local uv1_y = uv0_y + anim.frame_height / img.height

		-- Display the image using ImGui
		self.imgui.Image(img, width, height, uv0_x, uv0_y, uv1_x, uv1_y)
	end
end

--- Returns a list of animations in the XML
--- @return string[]
function xml_viewer:get_animation_list()
	return self.data[self.path].animation_list
end

--- Returns the default animation name
--- @return string
function xml_viewer:get_default_animation()
	return self.data[self.path].default_animation
end

--- Returns the width and height of the specified animation
--- @param animation string
--- @return number width, number height
function xml_viewer:get_animation_size(animation)
	local anim = self.data[self.path].animation[animation]
	return anim.frame_width, anim.frame_height
end

--- Sets the current XML path for the viewer
--- @param path string
function xml_viewer:set_path(path)
	self.path = path
end

--- Returns the error message if the XML is invalid
--- @return string
function xml_viewer:error_message()
	return self.data[self.path].error or ""
end

--- Returns the number of frames in the specified animation
--- @param animation string
--- @return number
function xml_viewer:get_frame_count(animation)
	return self.data[self.path].animation[animation].frame_count
end

--- Advances the frame counter for animations
function xml_viewer:advance_frame()
	self.frame = self.frame + 1
end

return xml_viewer
