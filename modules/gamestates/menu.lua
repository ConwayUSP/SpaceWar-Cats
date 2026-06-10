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
	
	if not self.texts.play then
		self.texts.play = TextPhysical.new(
			"PLAY",
			48,
			{ 1, 1, 1, 1 },
			vec(width / 2, height / 2),
			0,
			true,
			math.huge,
			nil,
			nil,
			function(text)
				text.fixture:destroy()
				runStats:set(RST, love.timer.getTime())
				SetGameCtx(CTX.BATTLE)
			end
		)
	end
	soundManager:play("ambience", false, true)
	soundManager:pause("battle")

	love.mouse.setCursor(cursors.crosshair)
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

	love.graphics.setColor(1, 1, 1, 1)
end

function MenuState:keypressed(key, scancode, isrepeat)
	p1:keypressed(key, scancode, isrepeat)

	if key == "p" or key == "escape" and not isrepeat then
		SetGameCtx(CTX.PAUSE)
	end
end

function MenuState:mousepressed( x, y, button, istouch, presses )
	p1:mousepressed(x, y, button, istouch, presses)
end

return MenuState
