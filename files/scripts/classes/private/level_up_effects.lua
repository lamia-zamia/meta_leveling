---@class (exact) ml_level_up_effects
---@field private color integer ARGB
---@field private play_sound boolean
---@field private play_fx boolean
---@field private create_particles boolean
---@field private last_level number
---@field private particle_step number
local LUE = {
	color = 0,
	play_sound = true,
	play_fx = true,
	create_particles = true,
	particle_step = 0
}

---Returns emitter image depending on the level
---@private
---@param level number
---@param index number
---@return string path
function LUE:decide_emitter_image(level, index)
	return "mods/meta_leveling/files/gfx/emitters/levelup_" .. math.min(index, 8) .. ".png"
end

---Creates emitter
---@private
---@param level number
function LUE:create_emitter(level)
	local index = math.floor(level / 10) + 1
	local component = {
		emitted_material_name = "spark_green",
		image_animation_file = self:decide_emitter_image(level, index),
		emit_cosmetic_particles = true,
		emission_interval_min_frames = 1,
		emission_interval_max_frames = 3,
		fade_based_on_lifetime = true,
		friction = 20,
		collide_with_gas_and_fire = false,
		collide_with_grid = false,
		attractor_force = 25 + math.min(index, 5) * 5,
		image_animation_speed = 3 + math.min(5, index),
		image_animation_loop = false,
		lifetime_min = 1,
		lifetime_max = 2,
		color = self.color,
	}
	local entity = EntityCreateNew()
	EntityAddComponent2(entity, "LifetimeComponent", { lifetime = 260 })
	local comp = EntityAddComponent2(entity, "ParticleEmitterComponent", component)
	ComponentSetValue2(comp, "gravity", 0, 0)
	if self.play_sound then
		EntityAddComponent2(entity, "LuaComponent", {
			script_source_file = "mods/meta_leveling/files/scripts/attach_scripts/level_up_effect.lua"
		})
		EntityAddComponent2(entity, "AudioLoopComponent", {
			file = "data/audio/Desktop/misc.bank",
			event_name = "misc/teleport_emitter_loop",
			auto_play = true,
		})
	end
	EntitySetTransform(entity, ML.player.x, ML.player.y - 20)
end

---Creates particle undel player
---@private
---@param pending number
function LUE:reminder_particle(pending)
	self.particle_step = self.particle_step + pending / 10
	if self.particle_step >= 1 then
		GameCreateCosmeticParticle("spark_green", ML.player.x, ML.player.y + 3, math.floor(self.particle_step),
			10, 5, self.color, 0.5, 1, ---@diagnostic disable-line: param-type-mismatch
			true, false, false,
			true, 0, -30)
		self.particle_step = 0
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
	self.create_particles = MLP.get:mod_setting_boolean("session_exp_foot_particle", true)
end

---Init fx
function LUE:init()
	self.last_level = MLP.get:global_number(MLP.const.globals.fx_played, 1)
	self:update_settings()
end

---Check and play effects
function LUE:update()
	if not self.last_level then return end
	local pending = ML.pending_levels
	local max_level = ML:get_level() + pending
	if max_level > self.last_level then
		self.last_level = max_level
		MLP.set:global_number(MLP.const.globals.fx_played, max_level)
		if self.play_fx then
			self:create_emitter(max_level)
		elseif self.play_sound then
			GamePlaySound(MLP.const.sound_banks.event_cues, "event_cues/wand/create", ML.player.x, ML.player.y)
		end
	end
	if pending > 0 and self.create_particles then
		self:reminder_particle(pending)
	end
end

return LUE
