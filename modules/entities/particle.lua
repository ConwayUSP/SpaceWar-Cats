----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.particleManager")

----------------------------------------
-- Entidade ParticleAnim
----------------------------------------

ParticleAnim = {}
ParticleAnim.__index = ParticleAnim
ParticleAnim.type = "ParticleAnim"

function ParticleAnim.new(name, pos, animation)
  local self = setmetatable({}, ParticleAnim)
  self.name = name
  self.pos = vec(pos.x, pos.y)
  self.active = true
  self.state = INTACT
  self:addAnimations(animation)

  particleManager:addAnim(self)
  return self
end

function ParticleAnim:addAnimations(animConfig)
	----------------- INTACT -----------------
	local path = pngPathFormat({ "assets", "animations", "particles", self.name, INTACT })
	addAnimation(self, path, INTACT, animConfig)
  self.animations[INTACT].onFinish = function()
    self.active = false
  end
end

function ParticleAnim:update(dt)
  if not self.active then
    return
  end

  self.animations[self.state]:update(dt)
end

----------------------------------------
-- Renderização
----------------------------------------

function ParticleAnim:draw()
  if not self.active then
    return
  end

  love.graphics.setColor(1, 1, 1)

  local animation = self.animations[self.state]
	local quad = animation.frames[animation.currFrame]
  local offset = {
		x = animation.frameDim.width / 2,
		y = animation.frameDim.height / 2,
	}
  love.graphics.draw(self.spriteSheets[self.state], quad, self.pos.x, self.pos.y, 0, VIRTUAL_SCALE, VIRTUAL_SCALE, offset.x, offset.y)

  love.graphics.setColor(1, 1, 1)
end

----------------------------------------
-- Entidade Particle
----------------------------------------

Particle = {}
Particle.__index = Particle
Particle.type = "Particle"

function Particle.new(module, pos)
  local self = setmetatable({}, Particle)

  self.module = module
  self.active = true
  self.initialPos = vec(pos.x, pos.y)

  self:setPosition(pos.x, pos.y)
  particleManager:add(self)

  return self
end

function Particle:update(dt)
  for _, emitter in ipairs(self.module) do
    emitter.system:update(dt)
  end
end

function Particle:setPosition(x, y)
  for _, emitter in ipairs(self.module) do
    emitter.system:setPosition(x, y)
  end
end

function Particle:moveTo(x, y)
  for _, emitter in ipairs(self.module) do
    emitter.system:moveTo(x, y)
  end
end

function Particle:stop()
  for _, emitter in ipairs(self.module) do
    emitter.system:stop()
  end
end

function Particle:play()
  for _, emitter in ipairs(self.module) do
    emitter.system:start()
  end
end

function Particle:draw()
  for _, emitter in ipairs(self.module) do
    love.graphics.draw(emitter.system)
  end
end

----------------------------------------
-- Entidade ParticleText
----------------------------------------

ParticleText = {}
ParticleText.__index = ParticleText
ParticleText.type = "ParticleText"

function ParticleText.new(pos, textConfig)
  local self = setmetatable({}, ParticleText)

  self.initialPos = vec(pos.x, pos.y)
  self.text = Text.new(
    textConfig.content,
    textConfig.size,
    textConfig.color,
    vec(self.initialPos.x, self.initialPos.y),
    textConfig.rotation,
    textConfig.centered,
    textConfig.lifetime,
    textConfig.customUpdate
  )
  self.active = true

  particleManager:addText(self)

  return self
end

function ParticleText:update(dt)
  self.text:update(dt)
end

function ParticleText:draw()
  self.text:draw()
end