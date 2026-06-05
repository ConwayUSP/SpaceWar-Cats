Physics = {}
Physics.__index = Physics
Physics.type = "Physics"

Physics.world = {}
Physics.delayedFunctions = {}

local function beginContact(a, b, coll)
  local objA = a:getUserData()
  local objB = b:getUserData()

  -- TEXT vs PLAYER_BULLET
  local textObj = objA.type == "Text" and objA or (objB.type == "Text" and objB or nil)
  if textObj and textObj.onHit then
    table.insert(Physics.delayedFunctions, function() textObj:onHit() end)
    local proj = (objA == textObj) and objB or objA
    if proj.type == "ShotEvent" then
      proj:destroy()
    end

    return
  end

  -- PLAYER_BULLET vs ENEMY
  local pProjectile = (objA.type == "ShotEvent" and objA.category == CATEGORY.PLAYER_BULLET) and objA 
                  or ((objB.type == "ShotEvent" and objB.category == CATEGORY.PLAYER_BULLET) and objB or nil)

  if pProjectile then
    local target = (objA == pProjectile) and objB or objA
    if target.type == "Enemy" then
      table.insert(Physics.delayedFunctions, function() pProjectile:onHit(target) end)
    end

    return
  end

  local eProjectile = (objA.type == "ShotEvent" and objA.category == CATEGORY.ENEMY_BULLET) and objA 
                  or ((objB.type == "ShotEvent" and objB.category == CATEGORY.ENEMY_BULLET) and objB or nil)

  if eProjectile then
    local target = (objA == eProjectile) and objB or objA
    if target.type == "Player" then
      table.insert(Physics.delayedFunctions, function() eProjectile:onHit(target) end)
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