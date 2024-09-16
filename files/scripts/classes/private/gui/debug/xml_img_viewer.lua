---@type nxml
local nxml = dofile_once("mods/meta_leveling/files/scripts/lib/nxml.lua")

local required_fields = { "frame_count", "frame_width", "frame_height", "name" }

---@class imgui_xml_img_viewer
---@field private __index imgui_xml_img_viewer
---@field private imgui ImGui
---@field private data imgui_xml_img_viewer_data
---@field private path string
local xml_viewer = {
	data = setmetatable({}, { __mode = "k" }),
}
xml_viewer.__index = xml_viewer

---New instance of viewer
---@param imgui ImGui
---@return imgui_xml_img_viewer
---@nodiscard
function xml_viewer:new(imgui)
	local o = setmetatable({}, self)
	o.imgui = imgui
	return o
end

---@class imgui_xml_img_viewer_content_animation
---@field frame_count number
---@field frame_width number
---@field frame_height number
---@field pos_x number
---@field pos_y number
---@field frame_wait number

---@class imgui_xml_img_viewer_content_animations
---@field [string] imgui_xml_img_viewer_content_animation

---@class (exact) imgui_xml_img_viewer_content
---@field valid boolean
---@field error? string
---@field xml_content string
---@field spritesheet_path string
---@field default_animation string
---@field frame number
---@field animation_list string[]
---@field animation imgui_xml_img_viewer_content_animations

---@class imgui_xml_img_viewer_data
---@field [string] imgui_xml_img_viewer_content

---Mark path as invalid
---@param message string
---@private
function xml_viewer:xml_set_invalid(message)
	self.data[self.path] = { ---@diagnostic disable-line: missing-fields
		valid = false,
		error = message
	}
end

---@param xml element
---@return boolean
function xml_viewer:verify_xml(xml)
	if not xml.attr.filename then
		self:xml_set_invalid("Couldn't find filename in " .. self.path)
		return false
	end
	local filename = xml.attr.filename
	if not ModImageDoesExist(filename) then
		self:xml_set_invalid("Image file " .. filename .. " is not found")
		return false
	end
	local default_animation = xml.attr.default_animation
	if not default_animation then
		self:xml_set_invalid("There is no default_animation")
		return false
	end

	local anim_count = 0
	for rectAnimation in xml:each_of("RectAnimation") do
		anim_count = anim_count + 1
		for _, key in ipairs(required_fields) do
			if not rectAnimation.attr[key] then
				self:xml_set_invalid("Missing key " .. key .. " in rectAnimation")
				return false
			end
		end
		if tonumber(rectAnimation.attr.frame_wait) < 0.01 then
			self:xml_set_invalid("frame_wait is too low, min: 0.01")
			return false
		end
	end
	if anim_count == 0 then
		self:xml_set_invalid("Couldn't find any RectAnimation")
		return false
	end

	return true
end

---Basic checks and init
---@private
---@return boolean
function xml_viewer:init_xml()
	if not self.path or not ModDoesFileExist(self.path) or not self.path:find("%.xml$") then
		self:xml_set_invalid(self.path .. " is invalid")
		return false
	end
	local content = ModTextFileGetContent(self.path)

	local success, xml = pcall(nxml.parse, content)
	if not success then
		self:xml_set_invalid("Invalid xml, error: " .. xml)
		return false
	end

	if not self:verify_xml(xml) then return false end

	local animation_list, animation = self:parse(xml)
	self.data[self.path] = {
		animation_list = animation_list,
		animation = animation,
		spritesheet_path = xml.attr.filename,
		default_animation = xml.attr.default_animation,
		xml_content = content,
		frame = 0,
		valid = true
	}
	return true
end

---Checks and parses data for displaying from file
---@param path string path to xml file
---@param content string content of xml path
function xml_viewer:set_content(path, content)
	self.path = path
	ModTextFileSetContent(path, content)
end

---Checks and parses data for displaying from file
---@param path string path to xml file
---@param no_cache? boolean default `nil`, set to `true` to ignore cache
---@return boolean can_display if true
---@nodiscard
function xml_viewer:can_display_xml(path, no_cache)
	self.path = path
	if no_cache or not self.data[self.path] then return self:init_xml() end
	return self.data[self.path].valid
end

---Parse xml file and return animation data
---@private
---@param xml element
---@return string[] animation_list, imgui_xml_img_viewer_content_animations animation
function xml_viewer:parse(xml)
	local contents = {}
	local animation_list = {}
	for rectAnimation in xml:each_of("RectAnimation") do
		local attr = rectAnimation.attr
		local name = attr.name
		animation_list[#animation_list + 1] = name
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

---Returns frame to display
---@private
---@param anim imgui_xml_img_viewer_content_animation
---@return number
function xml_viewer:get_frame(anim)
	self.data[self.path].frame = self.data[self.path].frame + 1
	return math.floor(self.data[self.path].frame / anim.frame_wait / 60) % anim.frame_count
end

---Shows image from xml file
---@param animation? string animation name
---@param width? number
---@param height? number
---@param frame? number
function xml_viewer:show(animation, width, height, frame)
	local data = self.data[self.path]
	animation = animation or data.default_animation
	local anim = data.animation[animation]
	width = width or anim.frame_width
	height = height or anim.frame_height
	local img = self.imgui.LoadImage(data.spritesheet_path)
	if img then
		local current_frame = frame or self:get_frame(anim)
		local frame_column = current_frame % anim.frame_count
		local frame_row = math.floor(current_frame / anim.frame_count)

		local uv0_x = (anim.pos_x + frame_column * anim.frame_width) / img.width
		local uv0_y = (anim.pos_y + frame_row * anim.frame_height) / img.height
		local uv1_x = uv0_x + anim.frame_width / img.width
		local uv1_y = uv0_y + anim.frame_height / img.height

		self.imgui.Image(img, width, height, uv0_x, uv0_y, uv1_x, uv1_y)
	end
end

---Returns list of animation
---@return string[]
function xml_viewer:get_animation_list()
	return self.data[self.path].animation_list
end

---Returns default animation name
---@return string
function xml_viewer:get_default_animation()
	return self.data[self.path].default_animation
end

---Returns width and height of animation
---@param animation string
---@return number width, number height
function xml_viewer:get_animation_size(animation)
	local anim = self.data[self.path].animation[animation]
	return anim.frame_width, anim.frame_height
end

---Set path for next calls
---@param path string
function xml_viewer:set_path(path)
	self.path = path
end

---Returns error message if any
---@return string
function xml_viewer:error_message()
	return self.data[self.path].error or ""
end

---Returns frame amount in animation
---@param animation string
---@return number
function xml_viewer:get_frame_count(animation)
	return self.data[self.path].animation[animation].frame_count
end

return xml_viewer
