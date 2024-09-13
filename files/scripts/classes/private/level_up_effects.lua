---@class ml_level_up_effects
---@field private color integer ARGB
---@field private play_sound boolean
---@field private play_fx boolean
---@field private last_level number
local LUE = {
	color = 0,
	play_sound = true,
	play_fx = true,
}

---Returns emitter image depending on the level
---@private
---@param level number
---@return string path
function LUE:decide_emitter_image(level)
	local index = math.floor(level / 10) + 1
	return "mods/meta_leveling/files/gfx/emitters/levelup_" .. math.min(index, 8) .. ".png"
end

---Creates emitter
---@private
---@param level number
function LUE:create_emitter(level)
	local component = {
		emitted_material_name = "spark_green",
		image_animation_file = self:decide_emitter_image(level),
		emit_cosmetic_particles = true,
		emission_interval_min_frames = 1,
		emission_interval_max_frames = 3,
		fade_based_on_lifetime = true,
		friction = 20,
		collide_with_gas_and_fire = false,
		collide_with_grid = false,
		attractor_force = 25,
		image_animation_speed = 3,
		image_animation_loop = false,
		lifetime_min = 1,
		lifetime_max = 2,
		color = self.color,
	}
	local entity = EntityCreateNew()
	EntityAddComponent2(entity, "LifetimeComponent", { lifetime = 260 })
	local comp = EntityAddComponent2(entity, "ParticleEmitterComponent", component)
	ComponentSetValue2(comp, "gravity", 0, 0)
	EntitySetTransform(entity, ML.player.x, ML.player.y)
end

---Play level-up effects
---@private
---@param level number
function LUE:level_up_fx(level)
	if self.play_sound then
		GamePlaySound(MLP.const.sound_banks.event_cues, "event_cues/wand/create", ML.player.x, ML.player.y)
	end
	if self.play_fx then
		self:create_emitter(level)
	end
end

---Gets and normalize color
---@private
---@return integer 
function LUE:determine_color()
	local h, s, v = ML.colors:rgb2hsv(MLP.get:exp_color())
	v = math.min(math.max(0.3, v), 0.5) --normalize brightness
	local r, g, b = ML.colors:hsv2rgb(h, s, v)
	return bit.bor(
		bit.band(r * 255 --[[@as number]], 0xFF),
		bit.lshift(bit.band(g * 255 --[[@as number]], 0xFF), 8),
		bit.lshift(bit.band(b * 255 --[[@as number]], 0xFF), 16),
		bit.lshift(bit.band(255, 0xFF), 24)
	)
end

---Set settings
function LUE:update_settings()
	self.color = self:determine_color()
	self.play_sound = MLP.get:mod_setting_boolean("session_exp_play_sound", true)
	self.play_fx = MLP.get:mod_setting_boolean("session_exp_play_fx", true)
end

---Init fx
function LUE:init()
	self.last_level = MLP.get:global_number(MLP.const.globals.fx_played, 1)
	self:update_settings()
end

---Check and play effects
function LUE:update()
	if not self.last_level then return end
	local max_level = ML:get_level() + ML.pending_levels
	if max_level > self.last_level then
		self.last_level = max_level
		MLP.set:global_number(MLP.const.globals.fx_played, max_level)
		self:level_up_fx(max_level)
	end
end

return LUE
