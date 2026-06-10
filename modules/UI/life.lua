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
  self.state = INTACT

  self:addAnimations()
end

function LifeBarBg:addAnimations()
	----------------- INTACT -----------------
	local path = pngPathFormat({ "assets", "animations", "life", INTACT })
	addAnimation(self, path, INTACT, newAnimSetting(1, { width = VIRTUAL_WIDTH, height = 48 }, 0.1, false))
end

function LifeBarBg:update(dt)
  self.animations[self.state]:update(dt)
end

----------------------------------------
-- Renderização
----------------------------------------

function LifeBarBg:draw()
  local animation = self.animations[self.state]
	local quad = animation.frames[animation.currFrame]
  local offset = {
		x = animation.frameDim.width / 2,
		y = animation.frameDim.height / 2,
	}
  love.graphics.draw(self.spriteSheets[self.state], quad, self.pos.x, self.pos.y, 0, VIRTUAL_SCALE, VIRTUAL_SCALE, offset.x, offset.y)
end

----------------------------------------
-- Entidade LifeBarFront
----------------------------------------

local LifeBarFront = {}
LifeBarFront.__index = LifeBarFront
LifeBarFront.type = "LifeBarFront"

function LifeBarFront:load(pos)
  self.pos = vec(pos.x, pos.y)
  self.state = INTACT
  self.frontTarget = 1
  self.backTarget = 1
  self.percent = 1

  local path = pngPathFormat({ "assets", "sprites", "life", "front" })
  self.image = love.graphics.newImage(path)
  self.image:setFilter("nearest", "nearest")
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

function LifeBarFront:draw()
  local offset = {
    x = self.image:getWidth() / 2,
    y = self.image:getHeight() / 2,
  }

  love.graphics.setScissor(0, 0, self.backTarget * SCREEN_WIDTH, VIRTUAL_HEIGHT)
  local drawFunc = function () love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, VIRTUAL_SCALE, VIRTUAL_SCALE, offset.x, offset.y) end
  applyColorShader(drawFunc)
  love.graphics.setScissor()

  love.graphics.setScissor(0, 0, self.frontTarget * SCREEN_WIDTH, VIRTUAL_HEIGHT)
  love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, VIRTUAL_SCALE, VIRTUAL_SCALE, offset.x, offset.y)
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

  self.text = Text.new(
    "EARTH LIFE",
    14,
    { 1, 1, 1, 0.8 },
    vec(self.pos.x, self.pos.y - 8),
    0,
    true,
    math.huge,
    nil,
    nil
  )

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
  self.lifeBar:draw()
  self.lifeBarFront:draw()
  drawTexts({ self.text })
  love.graphics.setColor(1, 1, 1, 1)
end