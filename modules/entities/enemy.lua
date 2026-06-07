----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.system.render")
require("modules.system.shaders")
require("table")

----------------------------------------
-- Classe Enemy
----------------------------------------

Enemy = {}
Enemy.__index = Enemy
Enemy.type = "Enemy"

function Enemy.new(name, spawnPos, move, weapon, customShot, config)
  local enemy = setmetatable({}, Enemy)

  enemy.size = config.size or 30                               
  enemy.hp = config.hp or 100
  enemy.shootsUntilCd = config.shootsUntilCd or 1
  enemy.cd = config.cd or 1
  enemy.fireRate = config.fireRate or 1

  enemy.name = name
  enemy.move = move                               -- função de movimento do inimigo
  enemy.initialPos = vec(spawnPos.x, spawnPos.y)  -- posição inicial
  enemy.weapon = weapon
  enemy.customShot = customShot
  enemy.body = love.physics.newBody(Physics.world, enemy.initialPos.x, enemy.initialPos.y, "dynamic")
  enemy.shape = love.physics.newCircleShape(enemy.size * 1.3)
  enemy.fixture = love.physics.newFixture(enemy.body, enemy.shape)
  enemy.fixture:setUserData(enemy)
  enemy.fixture:setFilterData(
    CATEGORY.ENEMY, 
    CATEGORY.PLAYER_BULLET + CATEGORY.PLAYER + CATEGORY.PLANET,
    0
  )
  enemy.fixture:setSensor(true)

  enemy.shootTimer = 0
  enemy.cooldownTimer = 0
  enemy.damagedTimer = 0
  enemy.timer = 0
  enemy.shoots = 0
  enemy.state = FLYING

  enemyManager:add(enemy)

  return enemy
end

function Enemy:addAnimations(flyingConfig)
	----------------- FLYING -----------------
	local path = pngPathFormat({ "assets", "animations", "enemies", self.name, FLYING })
	addAnimation(self, path, FLYING, flyingConfig)
end

function Enemy:update(dt)
  self:updateMotion(dt)
  self:updateShooting(dt)
  self:updateState(dt)
end

function Enemy:updateState(dt)
  if self.damagedTimer > 0 then
    self.damagedTimer = self.damagedTimer - dt
  end

  self.animations[self.state]:update(dt)
end

function Enemy:updateMotion(dt)
  self.timer = self.timer + dt
  
  if self.move then
    self:move(dt)
  end
end

function Enemy:updateShooting(dt)
  if not self.weapon then
    return
  end
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
    local x, y = self.body:getPosition()
    x = x - self.size/2
    if self.customShot then
      self.customShot(self.weapon, self, vec(x, y), math.rad(180))
    else
      local origin = vec(x, y)
      self.weapon:shot(self, origin, math.rad(180))
    end
    
    self.shootTimer = 0
    self.shoots = self.shoots + 1

    if self.shoots >= self.shootsUntilCd then
      self.cooldownTimer = self.cd
    end
  end
end

function Enemy:die()
  if self.isDead then
    return
  end

  self.isDead = true
  self.body:destroy()
  if self.weapon then
    self.weapon:destroy()
  end
end

function Enemy:takeDamage(damage)
  self.hp = self.hp - damage
  self.damagedTimer = 0.1
  if self.hp <= 0 and not self.isDead then
    self:die()
  end
end

function Enemy:draw()
  -- if self.isDead then
  --   return
  -- end

  love.graphics.setColor(1, 1, 1, 1)

  local x, y = self.body:getPosition()
  local drawFunc = function()
    local animation = self.animations[self.state]
    local quad = animation.frames[animation.currFrame]
    local offset = {
      x = animation.frameDim.width / 2,
      y = animation.frameDim.height / 2,
    }
    love.graphics.draw(self.spriteSheets[self.state], quad, x, y, 0, 1, 1, offset.x, offset.y)
  end
  
  if self.damagedTimer > 0 then
    applyWhiteShader(drawFunc)
  else
    drawFunc()
  end
  
  debugRender(self)

  love.graphics.setColor(1, 1, 1, 1)
end