----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.animation")
require("modules.utils.vec")

----------------------------------------
-- Entidade Player
----------------------------------------

Player = {}
Player.__index = Player

Player.pos = vec(50, love.graphics.getHeight() / 2)

function Player:update(dt)
 self:updateMotion(dt)
end

function Player:updateMotion(dt)
  local mouseX, mouseY = love.mouse.getPosition()

  self.pos.y = lerp(self.pos.y, mouseY, 2*dt)
end

function Player:takeDamage(amount)

end

function Player:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self.pos.x, self.pos.y, 20)
end

return Player