----------------------------------------
-- Importações de Módulos
----------------------------------------

require("table")

require("modules.engine.animation")
require("modules.system.shots")
require("modules.entities.projectile")
require("modules.utils.states")
require("modules.constructor.projectile")

local StatBlock = require("modules.utils.stats")

----------------------------------------
-- Entidade Spaceship
----------------------------------------

Spaceship = {}
Spaceship.__index = Spaceship
Spaceship.type = "Spaceship"

----------------------------------------
-- Construtor
----------------------------------------

function Spaceship.new(config)
  local self = setmetatable({}, Spaceship)

  self.config = config
  self.name = config.name
  self.animation = config.animation
  self.customHit = config.customHit

  -- Propriedades "de nave", upgradeáveis via self:upgrade(...)
  self.stats = StatBlock.new({
    maxHp = config.maxHp,
    size = config.size,
    scale = config.scale,
    speed = config.speed,
    planetRegen = 0,
  })

  self.animations = {}
  self.spriteSheets = {}

  self.weapon = Projectile.new(config.weapon.name, moveDirection, self.customHit, pProjectiles, config.weapon)

  self:reset()
  self:addAnimations()

  return self
end

----------------------------------------
-- Update
----------------------------------------

function Spaceship:update(dt, state)
  self.weapon:update(dt)

  local animation = self.animations[state]
  if animation then
    animation:update(dt)
  end
end

----------------------------------------
-- Vida
----------------------------------------

function Spaceship:takeDamage(damage)
  self.hp = self.hp - damage
  return self.hp <= 0
end

function Spaceship:heal(amount)
  self.hp = math.min(self.hp + amount, self.stats:get("maxHp"))
end

----------------------------------------
-- Tiro
----------------------------------------

function Spaceship:shoot(player)
  local x, y = player.body:getPosition()
  local origin = addVec(vec(x, y), polarToVec(player.angle, 25))

  self.weapon:tryShoot(player, origin, player.angle)
end

function Spaceship:getCooldownPercent()
  return self.weapon:getCooldownPercent()
end

----------------------------------------
-- Upgrades
----------------------------------------

function Spaceship:upgrade(key, value, mode)
  self.stats:upgrade(key, value, mode)
end

function Spaceship:upgradeWeapon(key, value, mode)
  self.weapon:upgrade(key, value, mode)
end

----------------------------------------
-- Reset
----------------------------------------

function Spaceship:reset()
  self.stats:reset()
  self.hp = self.stats:get("maxHp")

  self.weapon:reset()
end

----------------------------------------
-- Animações
----------------------------------------

function Spaceship:addAnimations()
  local animation = self.animation

  local path = pngPathFormat({ animation.folder, animation.state })

  addAnimation(self, path, animation.state, newAnimSetting(animation.frames, { width = animation.frameWidth, height = animation.frameHeight }, animation.frameDuration, animation.loop, animation.scale))
end

----------------------------------------
-- Draw
----------------------------------------

function Spaceship:draw(x, y, angle, state)
  local animation = self.animations[state]
  if not animation then
    return
  end

  local quad = animation.frames[animation.currFrame]
  local scale = self.stats:get(SCALE)
  local offset = {
    x = animation.frameDim.width / 2 - 4,
    y = animation.frameDim.height / 2
  }

  love.graphics.draw(self.spriteSheets[state], quad, x, y, angle, scale, scale, offset.x, offset.y)
end