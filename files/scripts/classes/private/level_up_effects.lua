---@class (exact) ml_level_up_effects
---@field private color1 integer ARGB
---@field private color_core integer ARGB
---@field private color_inv integer ARGB
---@field private play_sound boolean
---@field private play_fx boolean
---@field private create_particles boolean
---@field private last_level number
---@field private particle_step number
local LUE = {
	color1 = 0,
	color_core = 0,
	color_inv = 0,
	play_sound = true,
	play_fx = true,
	create_particles = true,
	particle_step = 0,
}

---Returns a emitter component variable
---@private
---@param entity entity_id
---@param image string
---@param speed number
---@param attractor number
---@param lifetime_min number
---@param lifetime_max number
---@param color integer
function LUE:add_attractor_component(entity, image, speed, attractor, lifetime_min, lifetime_max, color)
	local component = {
		emitted_material_name = "spark_green",
		image_animation_file = image,
		emit_cosmetic_particles = true,
		emission_interval_min_frames = 1,
		emission_interval_max_frames = 3,
		fade_based_on_lifetime = true,
		friction = 20,
		collide_with_gas_and_fire = false,
		collide_with_grid = false,
		attractor_force = attractor,
		image_animation_speed = speed,
		image_animation_loop = false,
		lifetime_min = lifetime_min,
		lifetime_max = lifetime_max,
		color = color,
	}
	local comp = EntityAddComponent2(entity, "ParticleEmitterComponent", component)
	ComponentSetValue2(comp, "gravity", 0, 0)
end

---Returns emitter image depending on the level
---@private
---@param level number
---@param index number
---@return string path
function LUE:decide_emitter_image(level, index)
	return "mods/meta_leveling/files/gfx/emitters/levelup_" .. math.min(index, 8) .. ".png"
end

---Creates emitter core
---@private
---@param color integer
function LUE:create_emitter_core(color)
	local entity = EntityCreateNew()
	EntityAddComponent2(entity, "LifetimeComponent", { lifetime = 260 })
	self:add_attractor_component(entity, "mods/meta_leveling/files/gfx/emitters/levelup_core.png", 5, 0, 2, 2, color)
	EntitySetTransform(entity, ML.player.x, ML.player.y - 30)
end

---Creates emitter
---@private
---@param level number
function LUE:create_emitter(level)
	local index = math.floor(level / 10) + 1
	local entity = EntityCreateNew()
	EntityAddComponent2(entity, "LifetimeComponent", { lifetime = 260 })
	self:add_attractor_component(entity, self:decide_emitter_image(level, index), 3 + math.min(5, index), 0.1, 1, 2, self.color1)
	EntityAddComponent2(entity, "LuaComponent", {
		script_source_file = "mods/meta_leveling/files/scripts/attach_scripts/level_up_effect.lua",
	})
	if self.play_sound then
		local audio = EntityAddComponent2(entity, "AudioLoopComponent", {
			file = "data/audio/Desktop/misc.bank",
			event_name = "misc/teleport_emitter_loop",
			auto_play = true,
		})
		ComponentSetValue2(audio, "m_volume", 0.7)
	end
	EntitySetTransform(entity, ML.player.x, ML.player.y - 30)
end

---Creates particle undel player
---@private
---@param pending number
function LUE:reminder_particle(pending)
	self.particle_step = self.particle_step + pending / 10
	if self.particle_step >= 1 then
		GameCreateCosmeticParticle(
			"spark_green",
			ML.player.x,
			ML.player.y + 3,
			math.floor(self.particle_step),
			10,
			5,
			self.color1,
			0.5,
			1, ---@diagnostic disable-line: param-type-mismatch
			true,
			false,
			false,
			true,
			0,
			-30
		)
		self.particle_step = 0
	end
end

---Combines rgb to abgr
---@private
---@param r number
---@param g number
---@param b number
---@return integer
function LUE:rgb_to_abgr(r, g, b)
	return bit.bor(
		bit.band(r * 255 --[[@as number]], 0xFF),
		bit.lshift(bit.band(g * 255 --[[@as number]], 0xFF), 8),
		bit.lshift(bit.band(b * 255 --[[@as number]], 0xFF), 16),
		bit.lshift(bit.band(255, 0xFF), 24)
	)
end

---Gets and normalize color
---@private
---@return integer, integer, integer
---@nodiscard
function LUE:determine_color()
	local r, g, b = MLP.get:exp_color()
	local h, s, v = ML.colors:rgb2hsv(r, g, b)
	v = math.min(math.max(0.3, v), 0.5) --normalize brightness
	local ih, is, _ = ML.colors:rgb2hsv(1 - r, 1 - g, 1 - b)

	local color = self:rgb_to_abgr(ML.colors:hsv2rgb(h, s, v - 0.2 --[[@as colors_value]]))
	local color_core = self:rgb_to_abgr(ML.colors:hsv2rgb(h, s, v + 0.2 --[[@as colors_value]]))
	local color_i = self:rgb_to_abgr(ML.colors:hsv2rgb(ih, is, 0.3 --[[@as colors_value]]))
	return color, color_core, color_i
end

---Set settings
function LUE:update_settings()
	self.color1, self.color_core, self.color_inv = self:determine_color()
	self.play_sound = MLP.get:mod_setting_boolean("session_exp_play_sound", true)
	self.play_fx = MLP.get:mod_setting_boolean("session_exp_play_fx", true)
	self.create_particles = MLP.get:mod_setting_boolean("session_exp_foot_particle", true)
end

---Init fx
function LUE:init()
	self:update_settings()
end

---Check and play effects
function LUE:update()
	if not ML.player.id then return end
	local pending = ML.pending_levels
	local max_level = ML:get_level() + pending
	if max_level > MLP.get:global_number(MLP.const.globals.fx_played, 1) then
		MLP.set:global_number(MLP.const.globals.fx_played, max_level)
		MLP.set:global_number(MLP.const.globals.fx_played, max_level)
		local _, exp_inverted = ML:get_percentage()
		if exp_inverted then
			self:create_emitter_core(self.color_inv)
		else
			if self.play_fx then
				self:create_emitter_core(self.color_core)
				self:create_emitter(max_level)
			elseif self.play_sound then
				GamePlaySound(MLP.const.sound_banks.event_cues, "event_cues/wand/create", ML.player.x, ML.player.y)
			end
		end
	end
	if pending > 0 and self.create_particles then self:reminder_particle(pending) end
end

return LUE
