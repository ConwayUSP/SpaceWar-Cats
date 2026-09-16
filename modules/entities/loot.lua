----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.engine.animation")
require("modules.utils.utils")
require("modules.engine.physics")
require("modules.system.render")
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

  loot.hb = config.hb or {
    type = CIRCLE,
    radius = loot.size
  }

  loot.body = love.physics.newBody(Physics.world, pos.x, pos.y, "dynamic")
  loot.shape = getRightHitbox(loot.hb)
  loot.fixture = love.physics.newFixture(loot.body, loot.shape)
  loot.fixture:setUserData(loot)
  
  loot.fixture:setFilterData(
    CATEGORY.LOOT or 16, 
    CATEGORY.PLAYER,
    0
  )
  loot.fixture:setSensor(true)

  -- Efeito visual de dispersão inicial ao dropar
  local angle = math.rad(math.random(0, 360))
  local speed = math.random(20, 60)
  loot.body:setLinearVelocity(math.cos(angle) * speed, math.sin(angle) * speed)
  loot.body:setLinearDamping(2)

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

function Loot:collect()
    self.active = false
    if self.effect then
      self:effect()
    end

  self:destroy()
end

function Loot:updateMotion(dt) 

  self.timer = self.timer + dt
  
  if self.move then
    self:move(dt)
  end
end

function Loot:destroy()
  if not self.active then
    self.body:destroy()
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