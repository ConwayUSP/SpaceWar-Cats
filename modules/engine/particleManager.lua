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
  self.particlesAnim = {}
  self.particles = {}
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
end

function ParticleManager:addAnim(particleAnim)
  table.insert(self.particlesAnim, particleAnim)
end

function ParticleManager:add(particle)
  table.insert(self.particles, particle)
end

function ParticleManager:remove(particleAnim)
  local idx = tableIndexOf(self.particlesAnim, particleAnim)
  if idx then
    table.remove(self.particlesAnim, idx)
  end
end

----------------------------------------
-- Renderização
----------------------------------------

function ParticleManager:draw()
  for _, particle in ipairs(self.particlesAnim) do
    particle:draw()
  end

  for _, particle in pairs(self.particles) do
    particle:draw()
  end
end

return ParticleManager