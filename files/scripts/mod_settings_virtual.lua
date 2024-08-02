local settings_list = {
	"meta_leveling.currency", --amount of meta progression
}

for _, setting in ipairs(settings_list) do
	if ModSettingGet(setting) == nil then
		ModSettingSet(setting, 0)
	end
end
