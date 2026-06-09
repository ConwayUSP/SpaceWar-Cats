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

function newAscendingTextParticle(pos, text, color)
  local p = ParticleText.new(pos, {
    content = text,
    fontSize = 10,
    color = color or {1, 1, 1, 1},
    lifetime = 1.5,
    customUpdate = function(self, dt)
      self.pos[2] = self.pos[2] - 30 * dt
      self.color[4] = math.max(0, self.color[4] - 0.6 * dt)
    end,
    centerOffset = true

  })
  return p
end