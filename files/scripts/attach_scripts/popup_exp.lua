local entity = GetUpdatedEntityID()
local x, y, _, scale_x, scale_y = EntityGetTransform(entity)
local scale_increment = 0.01

SetRandomSeed(x, y)
local x_offset = Randomf(0.0, 0.1)
EntitySetTransform(entity, x - x_offset, y - 0.3, 0, scale_x + scale_increment, scale_y + scale_increment)
