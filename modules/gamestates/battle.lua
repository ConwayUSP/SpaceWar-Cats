----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.entities.enemy")
require("modules.engine.uiManager")
require("modules.constructor.scenes")

----------------------------------------
-- Estado do Battle
----------------------------------------
local isPaused = false

local BattleState = {}
BattleState.__index = BattleState

BattleState.sprites = {}
BattleState.texts = {}

BattleState.titleFont = nil
BattleState.promptFont = nil
BattleState.sounds = {}
BattleState.timer = 0
BattleState.transitionTimer = 0
BattleState.transitioningCd = 1

function BattleState:load()
	self.isTransitioning = false
	self.transitionTimer = 0
	if not isPaused then
		waveManager:startWave()
	end
	soundManager:pause("ambience")
	soundManager:play("battle", false, true)
	love.mouse.setCursor(cursors.crosshair)
	isPaused = false
end

function BattleState:update(dt)
	if self.isTransitioning then
		self.transitionTimer = self.transitionTimer + dt
		if self.transitionTimer >= self.transitioningCd then
			self.isTransitioning = false
			self.transitionTimer = 0
			SetGameCtx(CTX.UPGRADES)
			return
		end
	end

	dt = self.isTransitioning and dt * 0.5 or dt

	Physics:update(dt)
	p1:update(dt)

	enemyManager:update(dt)
	waveManager:update(dt)
	particleManager:update(dt)
	pProjectiles:update(dt)
	eProjectiles:update(dt)
	planet:update(dt)
end

function BattleState:startTransition()
	self.isTransitioning = true
	self.transitionTimer = 0
	soundManager:play("end_wave")
	soundManager:pause("battle")
end

function BattleState:draw()
	planet:draw()
	p1:draw()
	enemyManager:draw()
	pProjectiles:draw()
	eProjectiles:draw()
	particleManager:draw()

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function BattleState:keypressed(key, scancode, isrepeat)
	p1:keypressed(key, scancode, isrepeat)

	if key == "p" or key == "escape" and not isrepeat then
		isPaused = true
		SetGameCtx(CTX.PAUSE)
	end
end

function BattleState:mousepressed(x, y, button, istouch, presses)
	p1:mousepressed(x, y, button, istouch, presses)
end

return BattleState
