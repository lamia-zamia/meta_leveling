local file_list = {
	"mods/meta_leveling/files/scripts/meta_leveling.lua",
	"mods/meta_leveling/files/scripts/meta_leveling_public.lua",
	"data/scripts/perks/perk.lua"
}
local white_pixel = "mods/meta_leveling/vfs/white.png"

--it's done to load these files into RAM so the game doesn't call for them from system each time
for _, file in ipairs(file_list) do
	ModTextFileSetContent(file, ModTextFileGetContent(file))
end

--whitebox
if ModImageMakeEditable ~= nil then
	local custom_img_id = ModImageMakeEditable(white_pixel, 1, 1)
	ModImageSetPixel(custom_img_id, 0, 0, -1) --white
end
