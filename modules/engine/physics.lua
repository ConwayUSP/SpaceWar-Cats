Physics = {}
Physics.__index = Physics
Physics.type = "Physics"

Physics.world = {}
Physics.delayedFunctions = {}

local function beginContact(a, b, coll)
  local objA = a:getUserData()
  local objB = b:getUserData()

  if not objA or not objB then
    return
  end

  if objA.onCollision then
    objA:onCollision(objB)
  end

  if objB.onCollision then
    objB:onCollision(objA)
  end
end

function Physics:load()
  self.world = love.physics.newWorld(0, 0)
  self.world:setCallbacks(beginContact, nil)
end

function Physics:update(dt)
  self.world:update(dt)
  for _, func in ipairs(self.delayedFunctions) do
    func()
  end
  self.delayedFunctions = {}
end

function getRightHitbox(hb)
  if hb.type == CIRCLE then
    return love.physics.newCircleShape(hb.radius)
  elseif hb.type == RECTANGLE then
    return love.physics.newRectangleShape(hb.width, hb.height)
  end
end

----------------------------------------
-- Categorias
----------------------------------------

CATEGORY = {}
CATEGORY.PLAYER        = 1
CATEGORY.PLAYER_BULLET = 2
CATEGORY.ENEMY         = 4
CATEGORY.ENEMY_BULLET  = 8
CATEGORY.TEXT          = 16
CATEGORY.PLANET        = 32
CATEGORY.EXPLOSION     = 64