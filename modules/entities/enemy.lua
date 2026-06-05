----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.system.render")
require("table")

----------------------------------------
-- Classe Enemy
----------------------------------------

Enemy = {}
Enemy.__index = Enemy
Enemy.type = "Enemy"

function Enemy.new(name, hp, spawnPos, size, move, weapon, customShot, fireRate, shootsUntilCd, cd)
  local enemy = setmetatable({}, Enemy)
  enemy.name = name
  enemy.hp = hp                                   -- pontos de vida do inimigo
  enemy.move = move                               -- função de movimento do inimigo
  enemy.size = size                               -- tamanho do inimigo
  enemy.initialPos = vec(spawnPos.x, spawnPos.y)  -- posição inicial
  enemy.weapon = weapon
  enemy.customShot = customShot
  enemy.shootsUntilCd = shootsUntilCd or 1
  enemy.cd = cd or 1
  enemy.body = love.physics.newBody(Physics.world, enemy.initialPos.x, enemy.initialPos.y, "dynamic")
  enemy.shape = love.physics.newCircleShape(enemy.size * 1.3)
  enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
  enemy.fixture:setUserData(enemy)
  enemy.fixture:setFilterData(
    CATEGORY.ENEMY, 
    CATEGORY.PLAYER_BULLET + CATEGORY.PLAYER,
    0
  )
  enemy.fixture:setSensor(true)

  enemy.fireRate = fireRate or 1
  enemy.shootTimer = 0
  enemy.cooldownTimer = 0
  enemy.timer = 0
  enemy.shoots = 0
  enemy.image = love.graphics.newImage(pngPathFormat({ "assets", "sprites", "enemies", enemy.name }))
  enemy.image:setFilter("nearest", "nearest")

  enemyManager:add(enemy)

  return enemy
end

function Enemy:update(dt)
  self:updateMotion(dt)
  self:updateShooting(dt)
end

function Enemy:updateMotion(dt)
  self.timer = self.timer + dt
  if self.move then
    self:move(dt)
  end
end

function Enemy:updateShooting(dt)
  if self.cooldownTimer > 0 then
    self.cooldownTimer = self.cooldownTimer - dt
    if self.cooldownTimer <= 0 then
      self.cooldownTimer = 0
      self.shoots = 0
      self.shootTimer = 0
    end
    return
  end

  self.shootTimer = self.shootTimer + dt
  if self.shootTimer >= (1 / self.fireRate) and 
     self.shoots < self.shootsUntilCd 
  then
    if self.customShot then
      self:customShot()
    else
      local x, y = self.body:getPosition()
      local origin = vec(x, y)
      self.weapon:shot(origin)
    end
    
    self.shootTimer = 0
    self.shoots = self.shoots + 1

    if self.shoots >= self.shootsUntilCd then
      self.cooldownTimer = self.cd
    end
  end
end

function Enemy:die()
  self.isDead = true
  self.body:destroy()
end

function Enemy:takeDamage(damage)
  self.hp = self.hp - damage
  if self.hp <= 0 then
    self:die()
  end
end

function Enemy:draw()
  local x, y = self.body:getPosition()
  love.graphics.draw(self.image, x, y, 0, 1, 1, self.image:getWidth() / 2, self.image:getHeight() / 2)
  debugRender(self)
end