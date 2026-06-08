--[[
module = {
	x=emitterPositionX, y=emitterPositionY,
	[1] = {
		system=particleSystem1,
		kickStartSteps=steps1, kickStartDt=dt1, emitAtStart=count1,
		blendMode=blendMode1, shader=shader1,
		texturePreset=preset1, texturePath=path1,
		shaderPath=path1, shaderFilename=filename1,
		x=emitterOffsetX, y=emitterOffsetY
	},
	[2] = {
		system=particleSystem2,
		...
	},
	...
}
]]
local LG        = love.graphics
local particles = {}

local image1 = LG.newImage("assets/sprites/particles/lightBlur.png")
image1:setFilter("linear", "linear")

local ps = LG.newParticleSystem(image1, 44)
ps:setColors(1, 0, 0, 0, 0.78984375, 0.26266479492188, 0, 0.60546875, 0.7765625, 0, 1, 0.7703125, 0.0078125, 0, 1, 0.70859375)
ps:setDirection(3.1415927410126)
ps:setEmissionArea("none", 0, 0, 0, false)
ps:setEmissionRate(20)
ps:setEmitterLifetime(-1)
ps:setInsertMode("top")
ps:setLinearAcceleration(-0.051036551594734, 0, 0, 0)
ps:setLinearDamping(0.00020414621394593, 0.00020414621394593)
ps:setOffset(8, 8)
ps:setParticleLifetime(0.38794111013412, 1.0853943824768)
ps:setRadialAcceleration(0, 0)
ps:setRelativeRotation(false)
ps:setRotation(0, 0)
ps:setSizes(1.0, 0.1)
ps:setSizeVariation(0)
ps:setSpeed(90, 100)
ps:setSpin(0, 0)
ps:setSpinVariation(0)
ps:setSpread(math.rad(30))
ps:setTangentialAcceleration(0, 0)
table.insert(particles, {system=ps})

return particles
