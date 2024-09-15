local entity = GetUpdatedEntityID()

local emitter = EntityGetFirstComponent(entity, "ParticleEmitterComponent")
if not emitter then return end

local anim_time = ComponentGetValue2(emitter, "m_image_based_animation_time")
if anim_time < 0 then
	local x, y = EntityGetTransform(entity)
	GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/wand/create", x, y)

	ComponentSetValue2(emitter, "attractor_force", 40)

	local loop = EntityGetFirstComponent(entity, "AudioLoopComponent")
	if loop then ComponentSetValue2(loop, "volume_autofade_speed", 0.01) end

	local this = GetUpdatedComponentID()
	EntityRemoveComponent(entity, this)
end