----------------------------------------
-- Importações de Módulos
----------------------------------------
require("table")
require("modules.engine.animation")
require("modules.utils.vec")
require("modules.engine.physics")
require("modules.engine.projectileManager")
require("modules.system.render")
require("modules.system.shots")
require("modules.entities.projectile")
require("modules.utils.states")
require("modules.constructor.projectile")

----------------------------------------
-- Entidade Player
----------------------------------------

local Player = {}
Player.__index = Player
Player.type = "Player"

function Player:load()
  self.initialPos = vec(50, VIRTUAL_HEIGHT / 2)
  self.size = 7
  self.weapon = Projectile.new("blaster-tune", moveDirection, nil, pProjectiles, {
    speed = 40000,
    damage = 40,
    size = 4,
    hb = {
      type = "rectangle",
      width = 10,
      height = 5
    }
  })
  self.customShot = nil
  -- self.customShot = defaultCircularAttackFunc(-1, 1, math.rad(5))

  self.body = love.physics.newBody(Physics.world, self.initialPos.x, self.initialPos.y, "dynamic")
  self.body:setFixedRotation(true)
  self.shape = love.physics.newCircleShape(self.size * 0.7)
  self.fixture = love.physics.newFixture(self.body, self.shape)
  self.fixture:setUserData(self)
  self.fixture:setFilterData(
    CATEGORY.PLAYER, 
    CATEGORY.ENEMY_BULLET + CATEGORY.ENEMY + CATEGORY.TEXT, 
    0
  )
  self.fixture:setSensor(true)

  self.firerate = 3
  self.firerateTimer = 0
  self.respawnCd = 1
  self.respawnTimer = 0
  self.invulrabilityTimer = 0
  self.invulnerabilityCd = 2
  self.canShoot = true
  self.maxHp = 1
  self.hp = self.maxHp
  self.isDead = false
  self.state = FLYING

  self:addAnimations()

end

function Player:addAnimations()
	----------------- FLYING -----------------
	local path = pngPathFormat({ "assets", "animations", "player", FLYING })
	addAnimation(self, path, FLYING, newAnimSetting(4, { width = 32, height = 32 }, 0.1, true, 1))
end

function Player:update(dt)
  if self.isDead then
    self:updateDead(dt)
    return
  end

  self:updateMotion(dt)
  self:updateShooting(dt)
  self:updateState(dt)
end

function Player:updateDead(dt)
  self.respawnTimer = self.respawnTimer + dt
  if self.respawnTimer >= self.respawnCd then
    self.isDead = false
    self.respawnTimer = 0
    self.invulrabilityTimer = self.invulnerabilityCd
  end
end

function Player:updateState(dt)
  local mouseX, mouseY = screenToGamePosition(love.mouse.getPosition())
  mouseX = math.max(mouseX, 200)
  local x, y = self.body:getPosition()
  self.angle = math.atan2(mouseY - y, mouseX - x)

  if self.invulrabilityTimer > 0 then
    self.invulrabilityTimer = self.invulrabilityTimer - dt
  end

  self.animations[self.state]:update(dt)
end

function Player:updateShooting(dt)
  if GameCtx == CTX.UPGRADES then
    return
  end

  self.firerateTimer = self.firerateTimer + dt
  if self.firerateTimer >= (1 / self.firerate) then
    self.canShoot = true
  end

  if love.keyboard.isDown("space") then
    self:shoot()
  end

  if love.mouse.isDown(1) then
    self:shoot()
  end
end

function Player:updateMotion(dt)
  local _, mouseY = screenToGamePosition(love.mouse.getPosition())
  local limit = 20
  local y = clamp(self.body:getY(), limit, VIRTUAL_HEIGHT - limit)
  mouseY = clamp(mouseY, limit, VIRTUAL_HEIGHT - limit)

  local error = mouseY - y
  local vy = error * 200 * dt

  self.body:setLinearVelocity(0, vy)
end

function Player:die()
  self.isDead = true
  self.body:setPosition(self.initialPos.x, self.initialPos.y)
  -- self.body:destroy()
  -- self.weapon:destroy()
end

function Player:takeDamage(damage)
  if self.invulrabilityTimer > 0 then
    return
  end

  self.hp = self.hp - damage
  if self.hp <= 0 and not self.isDead then
    self:die()
  end
end

function Player:shoot()
  if not self.canShoot or self.isDead then
    return
  end

  local x, y = self.body:getPosition()
  local origin = addVec(vec(x, y), polarToVec(self.angle, 25))
  if self.customShot then
    self.customShot(self.weapon, self, origin, self.angle)
  else
    self.weapon:shot(self, origin, self.angle)
  end

  self.canShoot = false
  self.firerateTimer = 0
end

----------------------------------------
-- Handlers de Input
----------------------------------------

function Player:keypressed(key, scancode, isrepeat)
  if key == "space" then
    self:shoot()
  end
end

function Player:mousepressed( x, y, button, istouch, presses )
  if button == 1 then
    self:shoot()
  end
end


----------------------------------------
-- Renderização
----------------------------------------

function Player:draw()
  if self.isDead then
    return
  end

  if self.invulrabilityTimer > 0 and self.invulrabilityTimer % 0.2 < 0.1 then
    love.graphics.setColor(1, 1, 1, 0.5)
  else
    love.graphics.setColor(1, 1, 1, 1)
  end

  local x, y = self.body:getPosition()
  local animation = self.animations[self.state]
	local quad = animation.frames[animation.currFrame]
  local offset = {
		x = animation.frameDim.width / 2 - 4,
		y = animation.frameDim.height / 2,
	}
  love.graphics.draw(self.spriteSheets[self.state], quad, x, y, self.angle, VIRTUAL_SCALE, VIRTUAL_SCALE, offset.x, offset.y)
  -- love.graphics.circle("fill", x, y, 20)

  debugRender(self)
  love.graphics.setColor(1, 1, 1, 1)
end

return Player