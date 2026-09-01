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

function Enemy.new(name, spawnPos, move, weapon, customShot, config, initialAlpha)
  local enemy = setmetatable({}, Enemy)

  enemy.size = config.size or 30                               
  enemy.hp = config.hp or 100
  enemy.shootsUntilCd = config.shootsUntilCd or 1
  enemy.cd = config.cd or 1
  enemy.fireRate = config.fireRate or 1
  enemy.hb = config.hb or {
    type = "circle",
    radius = enemy.size
  }

  enemy.name = name
  enemy.move = move                               -- função de movimento do inimigo
  enemy.initialPos = vec(spawnPos.x, spawnPos.y)  -- posição inicial
  enemy.weapon = weapon
  enemy.customShot = customShot
  enemy.body = love.physics.newBody(Physics.world, enemy.initialPos.x, enemy.initialPos.y, "dynamic")
  enemy.shape = getRightHitbox(enemy.hb)
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
  enemy.currentShot = nil
  enemy.state = FLYING
  enemy.alpha = initialAlpha or 1

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
  if self.isDead then
    return
  end

  self.timer = self.timer + dt
  
  if self.move then
    self:move(dt)
  end
end

function Enemy:updateShooting(dt)
  if not self.weapon or self.isDead then
      return
  end

  local x, y = self.body:getPosition()

  -- passa a atirar somente se estiver 50px distante da borda direita da tela
  if x > VIRTUAL_WIDTH - 50 then
    return
  end

  -- cooldown
  if self.cooldownTimer > 0 then
    self.cooldownTimer = self.cooldownTimer - dt

    if self.cooldownTimer <= 0 then
      self.cooldownTimer = 0
      self.shoots = 0
      self.shootTimer = 0
    end

    return
  end

  -- existe um ataque em andamento?
  if self.currentShot then
    local finished = self.currentShot(dt)

    if finished then
      self.currentShot = nil
    end

    return
  end

  -- controla a cadência de disparo
  self.shootTimer = self.shootTimer + dt

  if self.shootTimer < (1 / self.fireRate) then
    return
  end

  if self.shoots >= self.shootsUntilCd then
    self.cooldownTimer = self.cd
    return
  end

  x = x - self.size / 2

  local origin = vec(x, y)
  local direction = math.rad(180)

  if self.customShot then
    self.currentShot = self.customShot(self.weapon, self,origin, direction)
  else
    self.weapon:shoot(self, origin, direction)
  end

  self.shootTimer = 0
  self.shoots = self.shoots + 1

  if self.shoots >= self.shootsUntilCd then
    self.cooldownTimer = self.cd
  end
end

function Enemy:die()
  self:destroy()
  local r = math.random(1, 3)
  soundManager:play("morte" .. r, true)
end

function Enemy:destroy()
  if self.isDead then
    return
  end
  self.isDead = true
  self.body:destroy()
  if self.weapon then
    self.weapon:destroy()
    runStats:add(TEK, 1)
  end
end

function Enemy:takeDamage(damage)
  if self.isDead then
    return
  end

  runStats:add(TDD, damage)
  self.hp = self.hp - damage
  self.damagedTimer = 0.1
  if self.hp <= 0 then
    self:die()
  end
end

function Enemy:draw()
  if self.isDead then
    return
  end
  -- love.graphics.setColor(1, 1, 1, 1)

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
    applyColorShader(drawFunc)
  else
    drawFunc()
  end
  
  debugRender(self)
  love.graphics.setColor(1, 1, 1, 1)
end