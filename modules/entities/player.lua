----------------------------------------
-- Importações de Módulos
----------------------------------------

require("table")

require("modules.constructor.projectile")
require("modules.constructor.spaceship")
require("modules.engine.animation")
require("modules.engine.physics")
require("modules.engine.projectileManager")
require("modules.entities.projectile")
require("modules.entities.spaceship")
require("modules.utils.states")
require("modules.utils.vec")
require("modules.system.render")
require("modules.system.shots")

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

  self.respawnCd = 1
  self.respawnTimer = 0

  self.invulrabilityTimer = 0
  self.invulnerabilityCd = 2

  self.isDead = false
  self.isDefeated = false

  self.state = FLYING
  self.movementTouchId = nil
  self.touchPosition = nil

  -- Nave inicial
  self:setSpaceship(defaultSpaceship())
  -- self:setSpaceship(bomberSpaceship())
  -- self:setSpaceship(plasmaSpaceship())
end

----------------------------------------
-- Spaceship
----------------------------------------

function Player:setSpaceship(spaceship)
  self.spaceship = spaceship

  self:refreshHitbox()
end

----------------------------------------
-- Reset
----------------------------------------

function Player:reset()
  self.spaceship:reset()
  self:refreshHitbox()

  self.body:setPosition(self.initialPos.x, self.initialPos.y)
  self.body:setLinearVelocity(0, 0)

  self.isDead = false
  self.isDefeated = false

  self.respawnTimer = 0
  self.invulrabilityTimer = 0
  self.movementTouchId = nil
  self.touchPosition = nil

  self.boostParticle = newBoostParticle(addVec(self.initialPos, self.boostOffset))
  self.boostParticle:play()
end

----------------------------------------
-- Hitbox
----------------------------------------

function Player:refreshHitbox()
  self.shape = love.physics.newCircleShape(self.spaceship.stats:get(SIZE))

  if self.fixture then
    self.fixture:destroy()
  end

  self.fixture = love.physics.newFixture(self.body, self.shape)

  self.fixture:setUserData(self)

  self.fixture:setFilterData(
    CATEGORY.PLAYER,
    CATEGORY.ENEMY_BULLET + CATEGORY.ENEMY + CATEGORY.TEXT + CATEGORY.LOOT,
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
  self.spaceship:update(dt, self.state)
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
  local x, y = self.body:getPosition()
  local targetX, targetY

  if self.touchPosition then
    targetX, targetY = self.touchPosition.x, self.touchPosition.y
  elseif not checkMobile() then
    targetX, targetY = screenToGamePosition(love.mouse.getPosition())
  else
    targetX, targetY = VIRTUAL_WIDTH, y
  end

  targetX = math.max(targetX, 200)
  self.angle = math.atan2(targetY - y, targetX - x)

  if self.invulrabilityTimer > 0 then
    self.invulrabilityTimer = self.invulrabilityTimer - dt
  end
end

function Player:updateShooting(dt)
  if GameCtx == CTX.UPGRADES then
    return
  end

  if love.keyboard.isDown("space") or
    (love.mouse.isDown(1) and not checkMobile())
  then
    self:beginShoot()
  end
end

function Player:updateMotion(dt)
  if self.isDead then
    return
  end

  local targetY
  if self.touchPosition then
    targetY = self.touchPosition.y
  elseif not checkMobile() then
    _, targetY = screenToGamePosition(love.mouse.getPosition())
  else
    self.body:setLinearVelocity(0, 0)
    return
  end

  local limit = 20
  local y = clamp(self.body:getY(), limit, VIRTUAL_HEIGHT - limit)
  targetY = clamp(targetY, limit, VIRTUAL_HEIGHT - limit)

  local error = targetY - y
  local vy = error * self.spaceship.stats:get("speed")

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

  local died = self.spaceship:takeDamage(damage)

  if died then
    self:die()
  end
end

function Player:getHp()
  return self.spaceship.hp
end

----------------------------------------
-- Tiro
----------------------------------------


function Player:beginShoot()
  if self.isDead then
    return
  end

  self.spaceship:beginShoot(self)
end

function Player:releaseShoot()
  if self.isDead then
    return
  end

  self.spaceship:releaseShoot(self)
end

function Player:activateSuper()
  if self.isDead then
    return false
  end

  return self.spaceship:activateSuper()
end

----------------------------------------
-- Input
----------------------------------------

function Player:keypressed(key, scancode, isrepeat)
  if key == "space" then
    self:beginShoot()
  end

  if key == "c" then
    self:activateSuper()
  end
end

function Player:keyreleased(key, scancode)
  if key == "space" then
    self:releaseShoot()
  end
end

function Player:mousepressed(x, y, button, istouch, presses)
  if checkMobile() then return end
  
  if button == 1 then
    self:beginShoot()
  end
end

function Player:mousereleased(x, y, button, istouch, presses)
  if checkMobile() then return end

  if button == 1 then
    self:releaseShoot()
  end
end

function Player:touchpressed(id, x, y)
  if self.movementTouchId ~= nil then
    return false
  end

  local gameX, gameY = screenToGamePosition(x, y)
  if gameX <= VIRTUAL_WIDTH / 2 then
    return false
  end

  self.movementTouchId = id
  self.touchPosition = vec(gameX, gameY)
  return true
end

function Player:touchmoved(id, x, y)
  if self.movementTouchId ~= id then
    return false
  end

  local gameX, gameY = screenToGamePosition(x, y)
  self.touchPosition.x = gameX
  self.touchPosition.y = gameY
  return true
end

function Player:touchreleased(id)
  if self.movementTouchId ~= id then
    return false
  end

  self:cancelTouches()
  return true
end

function Player:cancelTouches()
  self.movementTouchId = nil
  self.touchPosition = nil

  if self.body then
    self.body:setLinearVelocity(0, 0)
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
  self.spaceship:draw(x, y, self.angle, self.state)

  debugRender(self)

  love.graphics.setColor(1, 1, 1, 1)
end

return Player
