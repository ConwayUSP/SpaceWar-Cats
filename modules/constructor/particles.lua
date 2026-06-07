----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.entities.particle")

----------------------------------------
-- Construtor de Partículas
----------------------------------------

function newExplosionParticle(pos)
  local animConfig = newAnimSetting(10, { width = 32, height = 32 }, 0.01, false, 1)
  local explosion = ParticleAnim.new("explosion", pos, animConfig)
  return explosion
end

function newBoostParticle(pos)
  local boost = require("modules.constructor.particles.boost")
  local p = Particle.new(boost, pos)
  return p
end