----------------------------------------
-- Classe Explosion
----------------------------------------

Explosion = {}
Explosion.__index = Explosion
Explosion.type = "Explosion"

function Explosion.new(pos, radius, damage, duration)
  local explosion = setmetatable({}, Explosion)

  ----------------------------------------
  -- Configuração
  ----------------------------------------

  explosion.radius = radius
  explosion.damage = damage
  explosion.duration = duration

  explosion.timer = 0
  explosion.active = true

  explosion.position = vec(pos.x, pos.y)

  -- Guarda os inimigos que já foram atingidos
  -- por esta explosão.
  explosion.hitEnemies = {}

  ----------------------------------------
  -- Física
  ----------------------------------------

  explosion.body = love.physics.newBody(Physics.world, explosion.position.x, explosion.position.y, "static")
  explosion.shape = love.physics.newCircleShape(radius)
  explosion.fixture = love.physics.newFixture(explosion.body, explosion.shape)
  explosion.fixture:setUserData(explosion)

  -- A explosão só detecta inimigos.
  explosion.fixture:setFilterData(
    CATEGORY.EXPLOSION,
    CATEGORY.ENEMY,
    0
  )

  -- Não queremos colisão física.
  explosion.fixture:setSensor(true)

  ----------------------------------------
  -- Animação
  ----------------------------------------

  local animationConfig = newAnimSetting(10, { width = 32, height = 32 }, 0.05, false, -1)
  local path = pngPathFormat({"assets", "animations", EXPLOSION})

  addAnimation(explosion, path, EXPLOSION, animationConfig)

  return explosion
end


----------------------------------------
-- Update
----------------------------------------

function Explosion:update(dt)

  if not self.active then
    return
  end

  self.timer = self.timer + dt

  if self.timer >= self.duration then
    self.active = false
  end

  self.animations[EXPLOSION]:update(dt)
end


----------------------------------------
-- Draw
----------------------------------------

function Explosion:draw()
  if not self.active then
    return
  end

  local x, y = self.body:getPosition()
  local animation = self.animations[EXPLOSION]
  local quad = animation.frames[animation.currFrame]
  local offset = {
    x = animation.frameDim.width / 2,
    y = animation.frameDim.height / 2,
  }

  love.graphics.draw(self.spriteSheets[EXPLOSION], quad, x, y, 0, 3, 3, offset.x, offset.y)

  debugRender(self)
end


----------------------------------------
-- Collision
----------------------------------------

function Explosion:onCollision(other)

  if not self.active then
    return
  end

  if other.type ~= "Enemy" then
    return
  end

  -- Uma explosão causa dano apenas uma vez
  -- em cada inimigo.
  if self.hitEnemies[other] then
    return
  end

  self.hitEnemies[other] = true
  other:takeDamage(self.damage, self:getHitPosition(other))

end

function Explosion:getHitPosition(target)

  local x, y = target.body:getPosition()

  local dx = x - self.position.x
  local dy = y - self.position.y

  local distance = math.sqrt(dx * dx + dy * dy)

  if distance == 0 then
    return vec(self.position.x, self.position.y)
  end

  return vec(self.position.x + dx / distance * self.radius, self.position.y + dy / distance * self.radius)
end

function Explosion:destroy()
  if self.fixture then
    self.fixture:destroy()
    self.fixture = nil
  end

  if self.body then
      self.body:destroy()
    self.body = nil
  end
end