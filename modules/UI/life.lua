----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.animation")
require("modules.utils.vec")
require("modules.engine.physics")
require("modules.engine.projectileManager")
require("modules.system.render")
require("modules.entities.projectile")
require("modules.utils.states")

----------------------------------------
-- Entidade LifeBarBg
----------------------------------------

local LifeBarBg = {}
LifeBarBg.__index = LifeBarBg
LifeBarBg.type = "LifeBarBg"

function LifeBarBg:load(pos)
  self.pos = vec(pos.x, pos.y)

  local path = pngPathFormat({ "assets", "animations", "life", "back" })
  addAnimation(self, path, INTACT, newAnimSetting(1, { width = VIRTUAL_WIDTH, height = 64 }, 0.1, false))
end

function LifeBarBg:update(dt)
  self.animations[INTACT]:update(dt)
end

----------------------------------------
-- Renderização
----------------------------------------

function LifeBarBg:draw(scale)
  local animation = self.animations[INTACT]
	local quad = animation.frames[animation.currFrame]
  local offset = {
		x = animation.frameDim.width / 2,
		y = animation.frameDim.height / 2,
	}
  love.graphics.draw(self.spriteSheets[INTACT], quad, self.pos.x, self.pos.y, 0, scale, scale, offset.x, offset.y)
end

----------------------------------------
-- Entidade LifeBarFront
----------------------------------------

local LifeBarFront = {}
LifeBarFront.__index = LifeBarFront
LifeBarFront.type = "LifeBarFront"

function LifeBarFront:load(pos)
  self.pos = vec(pos.x, pos.y)
  self.frontTarget = 1
  self.backTarget = 1
  self.percent = 1

  local path = pngPathFormat({ "assets", "animations", "life", "front" })
  addAnimation(self, path, INTACT, newAnimSetting(1, { width = VIRTUAL_WIDTH, height = 64 }, 0.1, false))
end

function LifeBarFront:update(dt)
  local oldPercent = self.percent
  self.percent = math.max(0, (planet.hp / planet.maxHp))

  if oldPercent ~= self.percent then
    if self.percent < oldPercent  then
      self.frontTarget = self.percent
    else
      self.backTarget = self.percent
    end
  end

  if math.abs(self.frontTarget - self.percent) > 0.00005 then
    self.frontTarget = lerp(self.frontTarget, self.percent, 4 * dt)
  end

  if math.abs(self.backTarget - self.percent) > 0.00005 then
    self.backTarget = lerp(self.backTarget, self.percent, 4 * dt)
  end

end

function LifeBarFront:draw(scale)
  scale = scale or 1.0
  local animation = self.animations[INTACT]
	local quad = animation.frames[animation.currFrame]
  local offset = {
		x = animation.frameDim.width / 2,
		y = animation.frameDim.height / 2,
	}
  local drawFunc = function () 
    love.graphics.draw(self.spriteSheets[INTACT], quad, self.pos.x, self.pos.y, 0, scale, scale, offset.x, offset.y) 
  end
  local startX = SCREEN_WIDTH * (1 - scale) / 2
  local endX = SCREEN_WIDTH - startX
  local width = endX - startX
  
  love.graphics.setScissor(startX, 0, self.backTarget * width, VIRTUAL_HEIGHT)
  applyColorShader(drawFunc)
  love.graphics.setScissor()

  love.graphics.setScissor(startX, 0, self.frontTarget * width, VIRTUAL_HEIGHT)
  drawFunc()
  love.graphics.setScissor()
end


----------------------------------------
-- Classe LifeBarWrapper
----------------------------------------

LifeBarWrapper = {}
LifeBarWrapper.__index = LifeBarWrapper
LifeBarWrapper.type = "LifeBarWrapper"

function LifeBarWrapper.new()
  local self = setmetatable({}, LifeBarWrapper)
  self.lifeBar = LifeBarBg
  self.lifeBarFront = LifeBarFront
  self.pos = vec(VIRTUAL_WIDTH / 2, 27)

  -- self.text = Text.new(
  --   "EARTH LIFE",
  --   24,
  --   { 1, 1, 1, 0.8 },
  --   vec(self.pos.x, self.pos.y + 30),
  --   0,
  --   true,
  --   math.huge,
  --   nil,
  --   nil
  -- )

  self.lifeBarFront:load(self.pos)
  self.lifeBar:load(self.pos)
  return self
end

function LifeBarWrapper:update(dt)
  self.lifeBar:update(dt)
  self.lifeBarFront:update(dt)
  updateTexts({ self.text }, dt)
end

function LifeBarWrapper:draw()
  love.graphics.setColor(1, 1, 1, 0.5)

  self.lifeBar:draw(0.8)
  self.lifeBarFront:draw(0.8)
  drawTexts({ self.text })

  love.graphics.setColor(1, 1, 1, 1)
end