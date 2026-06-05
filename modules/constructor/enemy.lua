----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.enemy")
require("modules.constructor.projectile")


----------------------------------------
-- INIMIGO 1
----------------------------------------
local function moveBasic(self, dt)
    self.body:setLinearVelocity(0, 10000*math.cos(self.timer * 4)*dt)
end


function newBasicEnemy(x, y)
    local proj = Projectile.new("project1", 15, moveLeft, nil, 50000, eProjectiles)
    local enemy = Enemy.new("enemy1", 100, vec(x, y), 30, moveBasic, proj, nil, 4, 10, 1.5)
    return enemy
end

----------------------------------------
-- INIMIGO 2
----------------------------------------
local function moveFast(self, dt)
    self.body:setLinearVelocity(0, 10000*math.cos(self.timer * 10)*dt)
end

function newFastEnemy(x, y)
    local proj = Projectile.new("project2", 30, moveLeft, nil, 30000, eProjectiles)
    local enemy = Enemy.new("enemy2", 50, vec(x, y), 40, moveFast, proj, nil, 3, 5, 3)
    return enemy
end