local disable_perks = {
	"PROTECTION_EXPLOSION",
	"PROTECTION_FIRE",
	"PROTECTION_RADIOACTIVITY",
	"PROTECTION_MELEE",
	"PROTECTION_ELECTRICITY",
	"EDIT_WANDS_EVERYWHERE",
	"REMOVE_FOG_OF_WAR",
	"PERKS_LOTTERY",
	"EXTRA_PERK",
}

local function is_in_disable_pool(perk_id)
	for i = 1, #disable_perks do
		if perk_id == disable_perks[i] then return true end
	end
	return false
end

for i = 1, #perk_list do
	local perk = perk_list[i]
	local perk_id = perk.id
	if is_in_disable_pool(perk_id) then perk.not_in_default_perk_pool = true end
	if perk.game_effect and perk.game_effect:find("^PROTECTION_") then perk.game_effect = nil end
	if perk.game_effect2 and perk.game_effect2:find("^PROTECTION_") then perk.game_effect2 = nil end
end
