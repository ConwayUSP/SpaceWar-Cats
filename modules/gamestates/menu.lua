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
	local width, height = love.graphics.getDimensions()

	-- sprites
	-- self.sprites.bg = love.graphics.newImage("assets/UI/menu/menu_bg.png")

	World:load()
	p1:load()

	-- texts
	self.texts.play = TextPhysical.new(
		"PLAY",
		65,
		{ 1, 1, 1, 1 },
		{ width / 2, height / 2 },
		-- { 50, height / 2 - 200 },
		0,
		true,
		math.huge,
		nil,
		nil,
		function(text)
			SetGameCtx(CTX.BATTLE)
			text.fixture:destroy()
		end
	)
end

function MenuState:update(dt)
	World.world:update(dt)
  p1:update(dt)
	updateTexts(self.texts, dt)

	cleanUpTexts(self.texts)
end

function MenuState:draw()
	local screenW, screenH = love.graphics.getWidth(), love.graphics.getHeight()

	-- background
	-- local bg = self.sprites.bg
	-- local bgW, bgH = bg:getWidth(), bg:getHeight()
	-- local scale = math.max(screenW / bgW, screenH / bgH)
	-- local drawX = (screenW - bgW * scale) / 2
	-- local drawY = (screenH - bgH * scale) / 2
	-- love.graphics.draw(bg, drawX, drawY, 0, scale, scale)

  p1:draw()
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

return MenuState
