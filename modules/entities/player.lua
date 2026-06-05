----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.animation")
require("modules.utils.vec")
require("modules.engine.physics")
require("modules.engine.projectileManager")
require("modules.system.render")
require("modules.entities.projectile")

----------------------------------------
-- Entidade Player
----------------------------------------

local Player = {}
Player.__index = Player
Player.type = "Player"

function Player:load()
  self.initialPos = vec(50, VIRTUAL_HEIGHT / 2)
  self.size = 20
  self.attack = Projectile.new("playerProj", 40, moveRight, nil, 80000, pProjectiles)

  self.body = love.physics.newBody(Physics.world, self.initialPos.x, self.initialPos.y, "dynamic")
  self.body:setFixedRotation(true)
  self.shape = love.physics.newCircleShape(self.size * 0.7)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setFilterData(
    CATEGORY.PLAYER, 
    CATEGORY.ENEMY_BULLET + CATEGORY.ENEMY + CATEGORY.TEXT, 
    0
  )
  self.fixture:setSensor(true)

  self.firerate = 3
  self.firerateTimer = 0
  self.canShoot = true
  self.hp = 100
  self.isDead = false

end

function Player:update(dt)
  if self.isDead then
    return
  end
  self:updateMotion(dt)
  self:updateShooting(dt)
end

function Player:updateShooting(dt)
  self.firerateTimer = self.firerateTimer + dt
  if self.firerateTimer >= (1 / self.firerate) then
    self.canShoot = true
  end

  if love.keyboard.isDown("space") then
    self:shoot()
  end

  if love.mouse.isDown(1) then
    self:shoot()
  end
end

function Player:updateMotion(dt)
  local _, mouseY = screenToGamePosition(love.mouse.getPosition())
  local y = self.body:getY()

  local error = mouseY - y
  local vy = error * 200 * dt

  self.body:setLinearVelocity(0, vy)
end

function Player:die()
  self.isDead = true
  self.body:destroy()
end

function Player:takeDamage(damage)
  self.hp = self.hp - damage
  if self.hp <= 0 then
    self:die()
  end
end

function Player:shoot()
  if not self.canShoot or self.isDead then
    return
  end

  local x, y = self.body:getPosition()
  self.attack:shot(vec(x, y))

  self.canShoot = false
  self.firerateTimer = 0
end

----------------------------------------
-- Handlers de Input
----------------------------------------

function Player:keypressed(key, scancode, isrepeat)
  if key == "space" then
    self:shoot()
  end
end

function Player:mousepressed( x, y, button, istouch, presses )
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

  local x, y = self.body:getPosition()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", x, y, 20)
  debugRender(self)
end

return Player