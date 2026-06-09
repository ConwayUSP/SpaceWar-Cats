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
      table.insert(Physics.delayedFunctions, function() 
        local dmg = pProjectile:onHit(target)
        runStats:add(TDD, dmg)
      end)
    elseif target.type == "Text" then
      table.insert(Physics.delayedFunctions, function() 
        target:onHit()
        pProjectile:destroy()
        local r = math.random(1, 3)
        soundManager:play("morte" .. r, true)
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
      table.insert(Physics.delayedFunctions, function() 
        eProjectile:onHit(target)
      end)
    -- elseif target.type == "Planet" then
    --   table.insert(Physics.delayedFunctions, function() 
    --     target:takeDamage(eProjectile.dmg)
    --     eProjectile:destroy()
    --   end)
    end
  end

  -- ENEMY vs (PLAYER or PLANET)
  local enemy = (objA.type == "Enemy") and objA or ((objB.type == "Enemy") and objB or nil)

  if enemy then
    local target = (objA == enemy) and objB or objA
    if target.type == "Planet" then
      table.insert(Physics.delayedFunctions, function() 
        local dmg = 20
        runStats:add(TDT, dmg)
        target:takeDamage(dmg)
        enemy:die()
      end)
    elseif target.type == "Player" then
      table.insert(Physics.delayedFunctions, function() 
        local x, y = target.body:getPosition()
        newExplosionParticle(vec(x, y))
        
        target:takeDamage(math.huge)
        enemy:takeDamage(math.huge)
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

function getRightHitbox(hb)
  if hb.type == "circle" then
    return love.physics.newCircleShape(hb.radius)
  elseif hb.type == "rectangle" then
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