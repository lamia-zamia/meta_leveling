local const_increment = 3

---Level curve for experience, level_curve[level] = experience
---@class ml_level_curve:table
---@field [number] number amount of experience needed
local levels = {
	[0] = 0,
	[1] = const_increment
}

local function make_number_round(number)
	return number > 100 and math.ceil(number / 10) * 10 or math.ceil(number)
end

local function next_level(level)
	local new_exp = (level + const_increment) * 1.1
	return make_number_round(new_exp)
end

for i = 1, 1000 do
	levels[#levels + 1] = next_level(levels[i])
end

---because fuck you that's why
for i = 1, 20 do
	levels[#levels + 1] = levels[#levels] * 10 ^ i
end

return levels
