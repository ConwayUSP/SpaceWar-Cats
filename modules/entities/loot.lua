----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.system.render")
require("modules.utils.vec")
require("modules.utils.screen")
require("table")

----------------------------------------
-- Classe Loot
----------------------------------------

Loot = {}
Loot.__index = Loot
Loot.type = "Loot"

function Loot.new(name, move, pos, config, effect)
  local loot = setmetatable({}, Loot)

  config = config or {}
  loot.name = name
  loot.move = move            
  loot.effect = effect
  loot.size = config.size or 8
  loot.lifetime = config.lifetime or 10000          -- Tempo até despawnar em segundos
  loot.timer = 0
  loot.active = true
  loot.state = FLYING

  loot.activationRadius = config.activationRadius or 30
  loot.magnetAcceleration = config.magnetAcceleration or 950
  loot.magnetMaxSpeed = config.magnetMaxSpeed or 720
  loot.magnetSteering = config.magnetSteering or 24
  loot.isAttracted = false

  loot.hb = config.hb or {
    type = CIRCLE,
    radius = loot.size
  }

  loot.body = love.physics.newBody(Physics.world, pos.x, pos.y, "dynamic")
  loot.shape = getRightHitbox(loot.hb)
  loot.fixture = love.physics.newFixture(loot.body, loot.shape)
  loot.fixture:setUserData(loot)
  
  loot.fixture:setFilterData(
    CATEGORY.LOOT, 
    CATEGORY.PLAYER,
    0
  )
  loot.fixture:setSensor(true)

  -- O loot nasce parado e continua exibindo sua animação até ser ativado.
  loot.body:setLinearVelocity(0, 0)

  lootManager:add(loot)

  return loot
end

function Loot:addAnimations(flyingConfig)
	----------------- FLYING -----------------
	local path = pngPathFormat({ "assets", "animations", "loots", self.name, FLYING })
	addAnimation(self, path, FLYING, flyingConfig)
end

function Loot:update(dt)
  if not self.active then return end

  self.timer = self.timer + dt

  -- Despawn se exceder o tempo de vida
  if self.timer >= self.lifetime then
    self.active = false
    self:destroy()
    return
  end
  self:updateMotion(dt)
  self.animations[self.state]:update(dt)
end

function Loot:collect(target)
  self.active = false
  if target and target.type == "Player" then
    target:onLootCollected()
  end

  if self.effect then
    self:effect()
  end

  self:destroy()
end

function Loot:getInputPosition()
  if p1.touchPosition then
    return p1.touchPosition
  end

  if not checkMobile() then
    return vec(screenToGamePosition(love.mouse.getPosition()))
  end
end

function Loot:updateMotion(dt) 
  if self.move then
    self:move(dt)
  end

  if p1.isDead then
    return
  end

  local lootPosition = vec(self.body:getPosition())
  if not self.isAttracted then
    local inputPosition = self:getInputPosition()
    if not inputPosition or dist(lootPosition, inputPosition) > self.activationRadius then
      self.body:setLinearVelocity(0, 0)
      return
    end

    self.isAttracted = true
  end

  local playerPosition = vec(p1.body:getPosition())
  local direction = subVec(playerPosition, lootPosition)

  if nullVec(direction) then
    return
  end

  -- O homing forte mantém o loot apontado ao jogador, como se fosse sugado por ele.
  local currentVelocity = vec(self.body:getLinearVelocity())
  local speed = math.min(self.magnetMaxSpeed, lenVec(currentVelocity) + self.magnetAcceleration * dt)
  local targetVelocity = scaleVec(normalize(direction), speed)
  local nextVelocity = steerVec(currentVelocity, targetVelocity, self.magnetSteering * dt)

  self.body:setLinearVelocity(nextVelocity.x, nextVelocity.y)
end

function Loot:destroy()
  self.active = false

  if self.body then
    self.body:destroy()
    self.body = nil
  end
end

function Loot:draw()
  if not self.active then return end

  local x, y = self.body:getPosition()
  local drawFunc = function()
    local animation = self.animations[self.state]
    local quad = animation.frames[animation.currFrame]
    local offset = {
      x = animation.frameDim.width / 2,
      y = animation.frameDim.height / 2,
    }
    love.graphics.draw(self.spriteSheets[self.state], quad, x, y, 0, 1, 1, offset.x, offset.y)
  end
  drawFunc()
  debugRender(self)

  love.graphics.setColor(1, 1, 1, 1)
end

function Loot:onCollision(target)
  if target.type == "Player" then
    table.insert(Physics.delayedFunctions, function()
      self:collect(target)
    end)
  end
end
