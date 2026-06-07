----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.particleManager")

----------------------------------------
-- Entidade Particle
----------------------------------------

Particle = {}
Particle.__index = Particle
Particle.type = "Particle"

function Particle.new(name, pos, animation)
  local self = setmetatable({}, Particle)
  self.name = name
  self.pos = vec(pos.x, pos.y)
  self.active = true
  self.state = INTACT
  self:addAnimations(animation)

  particleManager:add(self)
  return self
end

function Particle:addAnimations(animConfig)
	----------------- INTACT -----------------
	local path = pngPathFormat({ "assets", "animations", "particles", self.name, INTACT })
	addAnimation(self, path, INTACT, animConfig)
  self.animations[INTACT].onFinish = function()
    self.active = false
    -- particleManager:remove(self)
  end
end

function Particle:update(dt)
  if not self.active then
    return
  end

  self.animations[self.state]:update(dt)
end

----------------------------------------
-- Renderização
----------------------------------------

function Particle:draw()
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