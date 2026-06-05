----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")
require("modules.utils.utils")
require("table")

----------------------------------------
-- Classe Enemy
----------------------------------------


---@class Enemy
---@field hp number
---@field move function
---@field shotAtk number
---@field shotPattern function
---@field pos Vec


local Enemy = {}
Enemy.__index = Enemy

---@param hp number
---@param spawnPos Vec
---@param move function
---@param shotPattern function
---@return Enemy
function Enemy.new(hp, spawnPos, move, shotPattern, shotAtk)
	---@type Enemy
	local enemy = setmetatable({}, Enemy)

	enemy.hp = hp -- pontos de vida do inimigo
	enemy.move = move -- função de movimento do inimigo
	enemy.shotPattern = shotPattern -- função que determina o padrão dos tiros
  enemy.shotAtk = shotAtk -- valor do dano do tiro
  enemy.pos = vec(spawnPos.x, spawnPos.y) -- posição inicial
  


	return enemy
end

function Enemy:die()
  self.isDead = true
end

function Enemy:shoot()

end

function Enemy:takeDamage(damage)
	self.hp = self.hp - damage
	if self.hp <= 0 then
		self:die()
	end
end

function Enemy:draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.circle("fill", self.pos.x, self.pos.y, 20)
end

return Enemy