Physics = {}
Physics.__index = Physics
Physics.type = "Physics"

Physics.world = {}
Physics.delayedFunctions = {}

local function beginContact(a, b, coll)
  local objA = a:getUserData()
  local objB = b:getUserData()

  -- PLAYER_BULLET vs (ENEMY or TEXT)
  local pProjectile = (objA.type == "ShotEvent" and objA.category == CATEGORY.PLAYER_BULLET) and objA 
                  or ((objB.type == "ShotEvent" and objB.category == CATEGORY.PLAYER_BULLET) and objB or nil)

  if pProjectile then
    local target = (objA == pProjectile) and objB or objA
    if target.type == "Enemy" then
      table.insert(Physics.delayedFunctions, function() pProjectile:onHit(target) end)
    elseif target.type == "Text" then
      table.insert(Physics.delayedFunctions, function() 
        target:onHit()
        pProjectile:destroy()
      end)
    end

    return
  end

  -- ENEMY_BULLET vs (PLAYER or PLANET)
  local eProjectile = (objA.type == "ShotEvent" and objA.category == CATEGORY.ENEMY_BULLET) and objA 
                  or ((objB.type == "ShotEvent" and objB.category == CATEGORY.ENEMY_BULLET) and objB or nil)

  if eProjectile then
    local target = (objA == eProjectile) and objB or objA
    if target.type == "Player" then
      table.insert(Physics.delayedFunctions, function() eProjectile:onHit(target) end)
    elseif target.type == "Planet" then
      table.insert(Physics.delayedFunctions, function() 
        target:takeDamage(eProjectile.dmg)
        eProjectile:destroy()
      end)
    end
  end

  -- ENEMY vs PLANET
  local enemy = (objA.type == "Enemy") and objA or ((objB.type == "Enemy") and objB or nil)

  if enemy then
    local target = (objA == enemy) and objB or objA
    if target.type == "Planet" then
      table.insert(Physics.delayedFunctions, function() 
        target:takeDamage(20)
        enemy:die()
      end)
    end
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