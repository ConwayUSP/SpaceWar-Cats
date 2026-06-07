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
  self.particles = {}
end

function ParticleManager:update(dt)
  for _, particle in ipairs(self.particles) do
    particle:update(dt)
  end
end

function ParticleManager:add(particle)
  table.insert(self.particles, particle)
end

function ParticleManager:remove(particle)
  local idx = tableIndexOf(self.particles, particle)
  if idx then
    table.remove(self.particles, idx)
  end
end

----------------------------------------
-- Renderização
----------------------------------------

function ParticleManager:draw()
  for _, particle in ipairs(self.particles) do
    particle:draw()
  end
end

return ParticleManager