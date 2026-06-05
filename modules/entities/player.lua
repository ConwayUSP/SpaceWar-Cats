----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.animation")
require("modules.utils.vec")
require("modules.engine.physics")

----------------------------------------
-- Entidade Player
----------------------------------------

Player = {}
Player.__index = Player

function Player:load()
  self.initialPos = vec(50, love.graphics.getHeight() / 2)

  self.size = { width = 20, height = 20 }
  self.body = love.physics.newBody(World.world, self.initialPos.x, self.initialPos.y, "dynamic")
  self.body:setFixedRotation(true)
  self.shape = love.physics.newRectangleShape(self.size.width, self.size.height)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setFilterData(
    CATEGORY.PLAYER, 
    CATEGORY.ENEMY_BULLET + CATEGORY.ENEMY + CATEGORY.TEXT, 
    0
  )
  self.fixture:setSensor(true)

end

function Player:update(dt)
 self:updateMotion(dt)
end

function Player:updateMotion(dt)
  local _, mouseY = love.mouse.getPosition()
  local y = self.body:getY()

  local error = mouseY - y
  local vy = error * 200 * dt

  self.body:setLinearVelocity(0, vy)
end

function Player:takeDamage(amount)

end

function Player:keypressed(key, scancode, isrepeat)
  
end

----------------------------------------
-- Renderização
----------------------------------------

function Player:draw()
  local x, y = self.body:getPosition()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", x, y, 20)

  if debugMode then
      love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("line", x - self.size.width/2, y - self.size.height/2, self.size.width, self.size.height)
  end
end

return Player