----------------------------------------
-- Importações de Módulos
----------------------------------------

require("table")

require("modules.engine.animation")
require("modules.engine.physics")
require("modules.engine.projectileManager")
require("modules.entities.projectile")
require("modules.entities.spaceship")
require("modules.utils.vec")
require("modules.system.render")
require("modules.system.shots")
require("modules.utils.states")
require("modules.constructor.projectile")

local planet = require("modules.entities.planet")

----------------------------------------
-- Player
----------------------------------------

local Player = {}

Player.__index = Player
Player.type = "Player"

----------------------------------------
-- Load
----------------------------------------

function Player:load()
  self.initialPos = vec(70, VIRTUAL_HEIGHT / 2)

  self.body = love.physics.newBody(Physics.world, self.initialPos.x, self.initialPos.y, "dynamic")

  self.body:setFixedRotation(true)

  self.boostOffset = vec(-10, 0)

  self.boostParticle = newBoostParticle(addVec(self.initialPos, self.boostOffset))

  self.boostParticle:play()

  self.firerateTimer = 0

  self.respawnCd = 1
  self.respawnTimer = 0

  self.invulrabilityTimer = 0
  self.invulnerabilityCd = 2

  self.canShoot = true

  self.hp = 1
  self.maxHp = 1

  self.isDead = false
  self.isDefeated = false

  self.state = FLYING

  -- Nave inicial
  self:setSpaceship(Spaceship.new())
end

----------------------------------------
-- Spaceship
----------------------------------------

function Player:setSpaceship(spaceship)
  self.spaceship = spaceship

  self.maxHp = spaceship.maxHp
  self.hp = self.maxHp

  self:newHitbox()

  self.firerateTimer = 0
  self.canShoot = true
end

----------------------------------------
-- Reset
----------------------------------------

function Player:reset()
  self:resetStats()

  self.body:setPosition(self.initialPos.x, self.initialPos.y)

  self.body:setLinearVelocity(0, 0)

  self.isDead = false
  self.isDefeated = false

  self.respawnTimer = 0
  self.invulrabilityTimer = 0

  self.firerateTimer = 0
  self.canShoot = true

  self.boostParticle = newBoostParticle(addVec(self.initialPos, self.boostOffset))

  self.boostParticle:play()
end

function Player:resetStats()
  self.spaceship:reset()

  self.maxHp = self.spaceship.maxHp
  self.hp = self.maxHp

  self:newHitbox()
end

----------------------------------------
-- Hitbox
----------------------------------------

function Player:newHitbox()
  self.shape = love.physics.newCircleShape(self.spaceship.size)

  if self.fixture then
    self.fixture:destroy()
  end

  self.fixture = love.physics.newFixture(self.body, self.shape)

  self.fixture:setUserData(self)

  self.fixture:setFilterData(
    CATEGORY.PLAYER,
    CATEGORY.ENEMY_BULLET + CATEGORY.ENEMY + CATEGORY.TEXT,
    0
  )

  self.fixture:setSensor(true)
end

----------------------------------------
-- Update
----------------------------------------

function Player:update(dt)
  if self.isDead then
    self:updateDead(dt)
    return
  end

  self:updateState(dt)
  self:updateMotion(dt)
  self:updateShooting(dt)
  self:updateParticles(dt)
end

function Player:updateParticles(dt)
  local position = addVec(vec(self.body:getPosition()), self.boostOffset)

  self.boostParticle:moveTo(position.x, position.y)
end

function Player:updateDead(dt)
  if self.isDefeated then
    return
  end

  self.respawnTimer = self.respawnTimer + dt
  if self.respawnTimer >= self.respawnCd then
    self.isDead = false
    self.respawnTimer = 0
    self.invulrabilityTimer = self.invulnerabilityCd
    self.boostParticle:play()
  end
end

function Player:updateState(dt)
  local mouseX, mouseY = screenToGamePosition(love.mouse.getPosition())
  mouseX = math.max(mouseX, 200)
  local x, y = self.body:getPosition()
  self.angle = math.atan2(mouseY - y, mouseX - x)

  if self.invulrabilityTimer > 0 then
    self.invulrabilityTimer = self.invulrabilityTimer - dt
  end

  local animation = self.spaceship.animations[self.state]
  if animation then
    animation:update(dt)
  end
end

function Player:updateShooting(dt)
  if GameCtx == CTX.UPGRADES then
    return
  end

  self.firerateTimer = self.firerateTimer + dt
  if self.firerateTimer >= (1 / self.spaceship.firerate) then
    self.canShoot = true
  end

  if love.keyboard.isDown("space") or love.mouse.isDown(1) then
    self:shoot()
  end
end

function Player:updateMotion(dt)
  if self.isDead then
    return
  end
  
  local _, mouseY = screenToGamePosition(love.mouse.getPosition())
  local limit = 20
  local y = clamp(self.body:getY(), limit, VIRTUAL_HEIGHT - limit)
  mouseY = clamp(mouseY, limit, VIRTUAL_HEIGHT - limit)

  local error = mouseY - y
  local vy = error * 2

  self.body:setLinearVelocity(0, vy)
end

----------------------------------------
-- Vida / Morte
----------------------------------------

function Player:defeat()
  self:die()
  self.isDefeated = true
end

function Player:die()
  if self.isDead then
    return
  end

  local x, y = self.body:getPosition()
  newExplosionParticle(vec(x, y))

  planet:takeDamage(25)
  self.isDead = true
  self.body:setPosition(self.initialPos.x, self.initialPos.y)
  self.body:setLinearVelocity(0, 0)
  self.boostParticle:stop()

  SoundManager:play("morte3")
end

function Player:takeDamage(damage)
  if self.invulrabilityTimer > 0 then
    return
  end

  self.hp = self.hp - damage
  if self.hp <= 0 and not self.isDead then
    self:die()
  end
end

----------------------------------------
-- Tiro
----------------------------------------

function Player:shoot()
  if not self.canShoot or self.isDead then
    return
  end

  local x, y = self.body:getPosition()
  local origin = addVec(vec(x, y), polarToVec(self.angle, 25))
  local spaceship = self.spaceship

  if spaceship.customShot then
    spaceship.customShot(spaceship.weapon, self, origin, self.angle)
  else
    spaceship.weapon:shot(self, origin, self.angle)
  end
  
  self.canShoot = false
  self.firerateTimer = 0
end

----------------------------------------
-- Input
----------------------------------------

function Player:keypressed(key, scancode, isrepeat)
  if key == "space" then
    self:shoot()
  end
end

function Player:mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    self:shoot()
  end
end

----------------------------------------
-- Renderização
----------------------------------------

function Player:draw()
  if self.isDead then
    return
  end

  if self.invulrabilityTimer > 0 and self.invulrabilityTimer % 0.2 < 0.1
  then
    love.graphics.setColor(1, 1, 1, 0.5)
  else
    love.graphics.setColor(1, 1, 1, 1)
  end

  local x, y = self.body:getPosition()

  local spaceship = self.spaceship

  local animation = spaceship.animations[self.state]

  local quad = animation.frames[animation.currFrame]

  local offset = {
    x = animation.frameDim.width / 2 - 4,
    y = animation.frameDim.height / 2
  }

  love.graphics.draw(spaceship.spriteSheets[self.state], quad, x, y, self.angle, spaceship.scale, spaceship.scale, offset.x, offset.y)

  debugRender(self)

  love.graphics.setColor(1, 1, 1, 1)
end

return Player