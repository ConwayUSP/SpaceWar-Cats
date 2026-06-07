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

function LifeBarBg:load()
  self.pos = vec(VIRTUAL_WIDTH / 2, 20)
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
  love.graphics.setColor(1, 1, 1, 0.5)
  local animation = self.animations[self.state]
	local quad = animation.frames[animation.currFrame]
  local offset = {
		x = animation.frameDim.width / 2,
		y = animation.frameDim.height / 2,
	}
  love.graphics.draw(self.spriteSheets[self.state], quad, self.pos.x, self.pos.y, 0, VIRTUAL_SCALE, VIRTUAL_SCALE, offset.x, offset.y)

  love.graphics.setColor(1, 1, 1, 1)
end

----------------------------------------
-- Entidade LifeBarFront
----------------------------------------

local LifeBarFront = {}
LifeBarFront.__index = LifeBarFront
LifeBarFront.type = "LifeBarFront"

function LifeBarFront:load()
  self.pos = vec(VIRTUAL_WIDTH / 2, 20)
  self.state = INTACT
  self.target = 1

  local path = pngPathFormat({ "assets", "sprites", "life", "front" })
  self.image = love.graphics.newImage(path)
  self.image:setFilter("nearest", "nearest")
end

function LifeBarFront:update(dt)
  self.target = lerp(self.target, math.max(0, (planet.hp / planet.maxHp)), 4 * dt)
end

function LifeBarFront:draw()
  love.graphics.setColor(1, 1, 1, 0.5)
  love.graphics.setScissor(0, 0, self.target * SCREEN_WIDTH, VIRTUAL_HEIGHT)
  local offset = {
    x = self.image:getWidth() / 2,
    y = self.image:getHeight() / 2,
  }
  love.graphics.draw(self.image, self.pos.x, self.pos.y, 0, VIRTUAL_SCALE, VIRTUAL_SCALE, offset.x, offset.y)
  love.graphics.setScissor()
  love.graphics.setColor(1, 1, 1, 1)
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
  self.text = Text.new(
    "EARTH LIFE",
    14,
    { 1, 1, 1, 0.8 },
    { VIRTUAL_WIDTH / 2, 12 },
    0,
    true,
    math.huge,
    nil,
    nil
  )

  self.lifeBarFront:load()
  self.lifeBar:load()
  return self
end

function LifeBarWrapper:update(dt)
  self.lifeBar:update(dt)
  self.lifeBarFront:update(dt)
  updateTexts({ self.text }, dt)
end

function LifeBarWrapper:draw()
  self.lifeBar:draw()
  self.lifeBarFront:draw()
  drawTexts({ self.text })
end