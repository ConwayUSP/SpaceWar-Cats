----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.entities.enemy")
-- require("modules.constructor.enemy")
-- require("modules.constructor.wave")

----------------------------------------
-- Estado do Battle
----------------------------------------

local BattleState = {}
BattleState.__index = BattleState

BattleState.sprites = {}
BattleState.texts = {}

BattleState.titleFont = nil
BattleState.promptFont = nil
BattleState.sounds = {}
BattleState.timer = 0

function BattleState:load()
	local width, height = VIRTUAL_WIDTH, VIRTUAL_HEIGHT
end

function BattleState:update(dt)
  Physics:update(dt)
  p1:update(dt)
	
	enemyManager:update(dt)
	waveManager:update(dt)
	pProjectiles:update(dt)
	eProjectiles:update(dt)

	updateTexts(self.texts, dt)
	cleanUpTexts(self.texts)
end

function BattleState:draw()
  p1:draw()
	enemyManager:draw()
	pProjectiles:draw()
	eProjectiles:draw()

  drawTexts(self.texts)

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function BattleState:keypressed(key, scancode, isrepeat)
	p1:keypressed(key, scancode, isrepeat)
end

function BattleState:mousepressed( x, y, button, istouch, presses )
	p1:mousepressed(x, y, button, istouch, presses)
end

return BattleState