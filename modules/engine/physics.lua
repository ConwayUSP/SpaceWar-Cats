World = {}
World.__index = World

World.world = {}

local function beginContact(a, b, coll)
  print("Colisão")
  local objA = a:getUserData()
  local objB = b:getUserData()

  if objA.onHit then
    objA:onHit(objA)
  end

  if objB.onHit then
    objB:onHit(objB)
  end
end

local function endContact()
  
end

function World:load()
  self.world = love.physics.newWorld(0, 0)
  self.world:setCallbacks(beginContact, endContact)
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