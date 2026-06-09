----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")

----------------------------------------
-- Estado do Menu
----------------------------------------

local MenuState = {}
MenuState.__index = MenuState

MenuState.sprites = {}
MenuState.texts = {}

MenuState.sounds = {}
MenuState.timer = 0

function MenuState:load()
	local width, height = VIRTUAL_WIDTH, VIRTUAL_HEIGHT

	Physics:load()
	planet:load()
	p1:load()
	SoundSFX:loadAll(soundManager)
	
	-- texts
	self.texts.play = TextPhysical.new(
		"PLAY",
		32,
		{ 1, 1, 1, 1 },
		{ width / 2, height / 2 },
		0,
		true,
		math.huge,
		nil,
		nil,
		function(text)
			text.fixture:destroy()
			SetGameCtx(CTX.BATTLE)
		end
	)

	love.mouse.setCursor(cursors.crosshair)
	UIManager:changeScene(nil)
end

function MenuState:update(dt)
	Physics:update(dt)
  p1:update(dt)
	pProjectiles:update(dt)
	planet:update(dt)
	particleManager:update(dt)
	updateTexts(self.texts, dt)

	cleanUpTexts(self.texts)
end

function MenuState:draw()
	planet:draw()
  p1:draw()
	pProjectiles:draw()
	particleManager:draw()

	drawTexts(self.texts)

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function MenuState:keypressed(key, scancode, isrepeat)
	p1:keypressed(key, scancode, isrepeat)

	if key == "return" then
		SetGameCtx(CTX.BATTLE)
	end
end

function MenuState:mousepressed( x, y, button, istouch, presses )
	p1:mousepressed(x, y, button, istouch, presses)
end

return MenuState
