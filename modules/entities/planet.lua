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
  self.healTimer = 0

  self.cureTimer = 1

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
	addAnimation(self, path, INTACT, newAnimSetting(50, { width = 180, height = 180 }, 0.1, true, 1))
	----------------- DESTROYED -----------------
  path = pngPathFormat({ "assets", "animations", "planet", DESTROYED })
	addAnimation(self, path, DESTROYED, newAnimSetting(50, { width = 180, height = 180 }, 0.1, true, 1))
end

function Planet:update(dt)
  self.animations[self.state]:update(dt)
  if self.damagedTimer > 0 then
    self.damagedTimer = self.damagedTimer - dt
  end
  if self.healTimer > 0 then
    self.healTimer = self.healTimer - dt
  end
  if self.regen > 0 and self.cureTimer > 0 then
    self.cureTimer = self.cureTimer - dt
    if self.cureTimer <= 0 and not self.isDead then
      self.cureTimer = 1
      self:heal(self.regen)
    end
  end
end

function Planet:die()
  self.isDead = true
  self.state = DESTROYED
  self.fixture:setFilterData(0, 0, 0)

  p1:defeat()
  runStats:set(RET, love.timer.getTime())
  runStats:set(TRT, runStats:get(RET) - runStats:get(RST))
  
  SetGameCtx(CTX.DEATH_SCREEN)
end

function Planet:takeDamage(damage)
  if self.isDead then 
    return 
  end

  runStats:add(TDT, damage)
  self.hp = math.max(0, self.hp - damage)
  self.damagedTimer = 0.1
  if self.hp <= 0 then
    self:die()
    camera:shake(4, 0.5)
  else
    camera:shake(damage / 100, 0.08)
  end
end

function Planet:heal(amount)
  if self.isDead or self.hp >= self.maxHp then 
    return 
  end

  self.healTimer = 0.1
  self.hp = math.min(self.hp + amount, self.maxHp)
end

----------------------------------------
-- Renderização
----------------------------------------

function Planet:draw()
  love.graphics.setColor(1, 1, 1)

  local animation = self.animations[self.state]
	local quad = animation.frames[animation.currFrame]
  local offset = {
		x = animation.frameDim.width / 2 + 72,
		y = animation.frameDim.height / 2,
	}

  local drawFunc = function ()
    local k = 2.5
    love.graphics.draw(self.spriteSheets[self.state], quad, self.pos.x, self.pos.y, 0, k, k, offset.x, offset.y)
  end

  if self.damagedTimer > 0 then
    applyColorShader(drawFunc)
  elseif self.healTimer > 0 then
    applyColorShader(drawFunc, { 0.565, 0.941, 0.486, 1.0 })
  else
    drawFunc()
  end

  debugRender(self)
end

return Planet