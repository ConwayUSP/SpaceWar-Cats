----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.text")
require("modules.utils.utils")
require("modules.engine.physics")

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
  
end

function BattleState:update(dt)
  World.world:update(dt)
  p1:update(dt)

	updateTexts(self.texts, dt)
	cleanUpTexts(self.texts)
end

function BattleState:draw()
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

return BattleState