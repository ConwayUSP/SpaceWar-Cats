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
-- Entidade Planet
----------------------------------------

local Planet = {}
Planet.__index = Planet
Planet.type = "Planet"

local baseConfigs = {
  maxHp = 500,
  regen = 0.0
}

function Planet:load()
  self.width = 20
  self.pos = vec(self.width / 2, VIRTUAL_HEIGHT / 2)

  self.body = love.physics.newBody(Physics.world, self.pos.x, self.pos.y, "dynamic")
  self.body:setFixedRotation(true)
  self.shape = love.physics.newRectangleShape(20, VIRTUAL_HEIGHT)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setSensor(true)

  self.damagedTimer = 0

  self:reset()
  self:addAnimations()

end

function Planet:reset()
  self.maxHp = baseConfigs.maxHp
  self.regen = baseConfigs.regen
  self.hp = self.maxHp
  self.state = INTACT
  self.isDead = false
  self.fixture:setFilterData(
    CATEGORY.PLANET, 
    CATEGORY.ENEMY, 
    0
  )
end

function Planet:addAnimations()
	----------------- INTACT -----------------
	local path = pngPathFormat({ "assets", "animations", "planet", INTACT })
	addAnimation(self, path, INTACT, newAnimSetting(1, { width = 100, height = VIRTUAL_HEIGHT }, 0.1, false))
	----------------- DESTROYED -----------------
  path = pngPathFormat({ "assets", "animations", "planet", DESTROYED })
	addAnimation(self, path, DESTROYED, newAnimSetting(1, { width = 100, height = VIRTUAL_HEIGHT }, 0.1, false))
end

function Planet:update(dt)
  self.animations[self.state]:update(dt)
  if self.damagedTimer > 0 then
    self.damagedTimer = self.damagedTimer - dt
  end
end

function Planet:die()
  self.isDead = true
  self.state = DESTROYED
  self.fixture:setFilterData(0, 0, 0)
end

function Planet:takeDamage(damage)
  self.hp = self.hp - damage
  self.damagedTimer = 0.1
  if self.hp <= 0 and not self.isDead then
    self:die()
  end
end

----------------------------------------
-- Renderização
----------------------------------------

function Planet:draw()
  love.graphics.setColor(1, 1, 1)

  local animation = self.animations[self.state]
	local quad = animation.frames[animation.currFrame]
  local offset = {
		x = animation.frameDim.width / 2,
		y = animation.frameDim.height / 2,
	}

  local drawFunc = function ()
    love.graphics.draw(self.spriteSheets[self.state], quad, self.pos.x, self.pos.y, 0, VIRTUAL_SCALE, VIRTUAL_SCALE, offset.x, offset.y)
  end

  if self.damagedTimer > 0 then
    applyWhiteShader(drawFunc)
  else
    drawFunc()
  end

  debugRender(self)
end

return Planet