----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")

----------------------------------------
-- Estado do Menu
----------------------------------------

local MenuState = {}
MenuState.__index = MenuState

MenuState.sprites = {}
MenuState.texts = {}

MenuState.titleFont = nil
MenuState.promptFont = nil
MenuState.sounds = {}
MenuState.timer = 0

function MenuState:load()
	local width, height = love.graphics.getDimensions()

	-- sprites
	-- self.sprites.bg = love.graphics.newImage("assets/UI/menu/menu_bg.png")

	-- texto do prompt
	self.texts.prompt = Text.new(
		"PLAY",
		65,
		{ 1, 1, 1, 1 },
		{ width / 2, height / 2 },
		0,
		true,
		math.huge,
		function(text, dt)
			text.time = (text.time or 0) + dt
			local alpha = 0.5 + 0.5 * math.sin(text.time * 4)
			text.color[4] = alpha
		end
	)
end

function MenuState:update(dt)
  p1:update(dt)
	self.texts.prompt:update(self.timer > 0 and 6 * dt or dt)

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

	for _, text in pairs(self.texts) do
		text:draw()
	end

	-- reset de cor
	love.graphics.setColor(1, 1, 1, 1)
end

function MenuState:keypressed(key, scancode, isrepeat)

end

return MenuState
