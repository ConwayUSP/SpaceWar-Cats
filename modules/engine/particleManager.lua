----------------------------------------
-- Importações de Módulos
----------------------------------------


----------------------------------------
-- Entidade ParticleManager
----------------------------------------

local ParticleManager = {}
ParticleManager.__index = ParticleManager
ParticleManager.type = "ParticleManager"

function ParticleManager:load()
  self.active = true
  self.particlesAnim = {}
  self.particlesText = {}
  self.particles = {}
end

function ParticleManager:toggle()
  self.active = not self.active
end

function ParticleManager:isActive()
  return self.active
end

function ParticleManager:update(dt)
  for i = #self.particlesAnim, 1, -1 do
    local particle = self.particlesAnim[i]
    if particle.active then
      particle:update(dt)
    else
      self:remove(particle)
    end
  end

  for _, particle in pairs(self.particles) do
    particle:update(dt)
  end

  for i = #self.particlesText, 1, -1 do
    local particle = self.particlesText[i]
    if particle.text.isOver then
      table.remove(self.particlesText, i)
    else
      particle:update(dt)
    end
  end
end

function ParticleManager:addAnim(particleAnim)
  if not self.active then
    return
  end
  table.insert(self.particlesAnim, particleAnim)
end

function ParticleManager:add(particle)
  if not self.active then
    return
  end
  table.insert(self.particles, particle)
end

function ParticleManager:addText(particleText)
  if not self.active then
    return
  end
  table.insert(self.particlesText, particleText)
end

function ParticleManager:remove(particleAnim)
  local idx = tableIndexOf(self.particlesAnim, particleAnim)
  if idx then
    table.remove(self.particlesAnim, idx)
  end
end

function ParticleManager:reset()
  self.particlesAnim = {}
  self.particlesText = {}
  self.particles = {}
end

----------------------------------------
-- Renderização
----------------------------------------

function ParticleManager:draw()
  if not self.active then
    return
  end

  for _, particle in ipairs(self.particlesAnim) do
    particle:draw()
  end

  for _, particle in pairs(self.particles) do
    particle:draw()
  end

  for _, particle in pairs(self.particlesText) do
    particle:draw()
  end
end

return ParticleManager