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

local defaultConfigs = {
  name = "default",

  -- Player / nave
  size = 5,
  scale = 1,
  maxHp = 1,

  -- Movimento
  speed = 600,

  -- Arma / projétil
  damage = 40,
  criticalChance = 0.10,
  criticalMultiplier = 1.5,

  hb = {
    type = "rectangle",
    width = 10,
    height = 5
  },

  firerate = 3,

  -- Outros atributos da nave
  planetRegen = 0.0,

  -- Arte
  animation = {
    folder = "assets/animations/player",
    state = FLYING,
    frameWidth = 32,
    frameHeight = 32,
    frameDuration = 0.1,
    frames = 4,
    loop = true,
    scale = 1
  },

  -- Arma
  weapon = {
    name = "blaster-tune",
    scale = 1
  }
}

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

local function mergeTables(base, override)
  local result = copyTable(base)

  for key, value in pairs(override or {}) do
    if type(value) == "table" and type(result[key]) == "table" then
      result[key] = mergeTables(result[key], value)
    else
      result[key] = value
    end
  end

  return result
end

----------------------------------------
-- Construtor
----------------------------------------

function Spaceship.new(config)
  local self = setmetatable({}, Spaceship)

  self.config = mergeTables(defaultConfigs, config)

  self.name = self.config.name

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

  self.weapon = nil
  self.customShot = nil

  self.animations = {}
  self.spriteSheets = {}

  self:resetStats()
  self:addAnimations()

  return self
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
    scale = newStats.scale or self.config.weapon.scale
  }

  if self.weapon then
    self.weapon:changeStats(weaponStats)
  else
    self.weapon = Projectile.new(
      self.config.weapon.name,
      moveDirection,
      nil,
      pProjectiles,
      weaponStats
    )
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