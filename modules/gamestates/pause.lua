----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")

----------------------------------------
-- Estado do Pause
----------------------------------------

local PauseState = {}
PauseState.__index = PauseState

PauseState.sprites = {}
PauseState.texts = {}

PauseState.sounds = {}
PauseState.timer = 0

function PauseState:load()
	local width, height = VIRTUAL_WIDTH, VIRTUAL_HEIGHT

	
	-- texts
	self.texts.play = TextPhysical.new(
		"RESUME",
		32,
		{ 1, 1, 1, 1 },
		{ width / 2, height / 5 },
		0,
		true,
		math.huge,
		nil
	)

	love.mouse.setCursor(cursors.crosshair)
	UIManager:changeScene(nil)
end

function PauseState:update(dt)
	self.timer = self.timer + dt
	updateTexts(self.texts, dt)
	cleanUpTexts(self.texts)
end

function PauseState:draw()
	planet:draw()
	p1:draw()
	enemyManager:draw()
	pProjectiles:draw()
	eProjectiles:draw()
	particleManager:draw()
	drawTexts(self.texts)

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function PauseState:keypressed(key, scancode, isrepeat)
	if key == "p" and self.timer > 1  then
		SetGameCtx(CTX.BATTLE)
		self.timer = 0
	end
end

function PauseState:mousepressed( x, y, button, istouch, presses )

end

return PauseState