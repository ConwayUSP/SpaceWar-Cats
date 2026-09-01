----------------------------------------
-- Importações de Módulos
----------------------------------------

require("table")

require("modules.engine.animation")
require("modules.system.shots")
require("modules.entities.projectile")
require("modules.utils.states")
require("modules.constructor.projectile")

----------------------------------------
-- Entidade Spaceship
----------------------------------------

Spaceship = {}

Spaceship.__index = Spaceship
Spaceship.type = "Spaceship"

----------------------------------------
-- Utilitários
----------------------------------------

local function copyTable(original)
  local copy = {}

  for key, value in pairs(original) do
    if type(value) == "table" then
      copy[key] = copyTable(value)
    else
      copy[key] = value
    end
  end

  return copy
end

----------------------------------------
-- Construtor
----------------------------------------

function Spaceship.new(config)
  local self = setmetatable({}, Spaceship)

  self.config = config

  self.name = self.config.name

  self.speed = self.config.speed
  self.damage = self.config.damage
  self.size = self.config.size
  self.scale = self.config.scale

  self.maxHp = self.config.maxHp

  self.criticalChance = self.config.criticalChance
  self.criticalMultiplier = self.config.criticalMultiplier

  self.hb = copyTable(self.config.hb)

  self.firerateTimer = 0
  self.firerate = self.config.firerate
  self.planetRegen = self.config.planetRegen

  self.weapon = nil
  self.customShot = nil

  self.animations = {}
  self.spriteSheets = {}

  self:resetStats()
  self:addAnimations()

  return self
end

----------------------------------------
-- Update
----------------------------------------

function Spaceship:update(dt)
  self:updateWeapon(dt)
end

function Spaceship:updateWeapon(dt)
  self.weapon:update(dt)
end

function Spaceship:updateShooting(dt)
  self.firerateTimer = self.firerateTimer + dt

  if self.firerateTimer >= (1 / self.firerate) then
    self.canShoot = true
  end
end

----------------------------------------
-- Shoot
----------------------------------------

function Spaceship:shoot(player)
  if not self.weapon or not self.canShoot then
    return
  end

  local x, y = player.body:getPosition()
  local origin = addVec(vec(x, y), polarToVec(player.angle, 25))
  
  if self.weapon:press(player, origin, player.angle) then
    self.canShoot = false
    self.firerateTimer = 0
  end
end

function Spaceship:getCooldownPercent()
  return math.min(1, self.firerateTimer / (1 / self.firerate))
end

----------------------------------------
-- Reset
----------------------------------------

function Spaceship:reset()
  self:resetStats()
end

function Spaceship:resetStats()
  self.speed = self.config.speed
  self.damage = self.config.damage
  self.size = self.config.size
  self.scale = self.config.scale

  self.maxHp = self.config.maxHp

  self.criticalChance = self.config.criticalChance
  self.criticalMultiplier = self.config.criticalMultiplier

  self.hb = copyTable(self.config.hb)

  self.firerate = self.config.firerate
  self.planetRegen = self.config.planetRegen

  self:attWeapon()

  self.customShot = self.config.customShot
  self.canShoot = true
  self.firerateTimer = math.huge
end

----------------------------------------
-- Arma
----------------------------------------

function Spaceship:attWeapon(newStats)
  newStats = newStats or {}

  local weaponStats = {
    speed = newStats.speed or self.speed,
    damage = newStats.damage or self.damage,
    hb = newStats.hb or self.hb,
    criticalChance = newStats.criticalChance or self.criticalChance,
    criticalMultiplier = newStats.criticalMultiplier or self.criticalMultiplier,
    scale = newStats.scale or self.config.weapon.scale,
    charge = newStats.charge or self.config.weapon.charge
  }

  if self.weapon then
    self.weapon:changeStats(weaponStats)
  else
    self.weapon = Projectile.new(self.config.weapon.name, moveDirection, nil, pProjectiles, weaponStats)
  end
end

----------------------------------------
-- Animações
----------------------------------------

function Spaceship:addAnimations()
  local animation = self.config.animation

  local path = pngPathFormat({ animation.folder, animation.state })

  addAnimation(self, path, animation.state, newAnimSetting(animation.frames, { width = animation.frameWidth, height = animation.frameHeight}, animation.frameDuration, animation.loop, animation.scale))
end