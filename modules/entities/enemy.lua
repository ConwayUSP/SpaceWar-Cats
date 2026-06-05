----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")
require("modules.utils.utils")
require("table")

----------------------------------------
-- Classe Enemy
----------------------------------------


local Enemy = {}
Enemy.__index = Enemy


function Enemy.new(hp, spawnPos, move, drawSprite, shotPattern, fireRate)
  local enemy = setmetatable({}, Enemy)
  enemy.hp = hp                           -- pontos de vida do inimigo
  enemy.move = move                       -- função de movimento do inimigo
  enemy.pos = vec(spawnPos.x, spawnPos.y) -- posição inicial
  enemy.drawSprite = drawSprite
  enemy.shotPattern = shotPattern
  enemy.fireRate = fireRate or 1
  enemy.shootTimer = 0
  return enemy
end

function Enemy:update(dt)
  if self.move then
    self.move(self, dt)
  end

  if self.fireRate > 0 then
    self.shootTimer = self.shootTimer + dt

    if self.shootTimer >= (1 / self.fireRate) then

      if self.shotPattern then
        self.shotPattern(self)
      end
      self.shootTimer = 0
    end
  end
end

function Enemy:die()
  self.isDead = true
end

function Enemy:takeDamage(damage)
  self.hp = self.hp - damage
  if self.hp <= 0 then
    self:die()
  end
end

function Enemy:draw()
  if self.drawSprite then
    self.drawSprite(self)
  end
end

return Enemy
