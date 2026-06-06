----------------------------------------
-- Importações de Módulos
----------------------------------------
require("modules.utils.utils")
require("modules.entities.enemy")
require("modules.constructor.projectile")
require("modules.system.shots")

----------------------------------------
-- INIMIGO 1
----------------------------------------
local function moveBasic(self, dt)
    self.body:setLinearVelocity(0, 10000*math.cos(self.timer * 4)*dt)
end

function newBasicEnemy(x, y)
    local projConfig = {
        speed = 40000,
        damage = 20,
        size = 2,
    }
    local proj = Projectile.new("project1", moveDirection, nil, eProjectiles, projConfig)
    local config = {
        hp = 100,
        hbSize = 10,
        fireRate = 2,
        shootsUntilCd = 5,
        cd = 2
    }
    local customShot = defaultCircularAttackFunc(-1, 1, math.rad(10))
    local enemy = Enemy.new("enemy1", vec(x, y), moveBasic, proj, customShot, config)
    return enemy
end

----------------------------------------
-- INIMIGO 2
----------------------------------------
local function moveFast(self, dt)
    self.body:setLinearVelocity(0, 10000*math.cos(self.timer * 10)*dt)
end

function newFastEnemy(x, y)
    local projConfig = {
        speed = 30000,
        damage = 30,
        size = 2
    }
    local proj = Projectile.new("project2", moveDirection, nil, eProjectiles, projConfig)
    local config = {
        hp = 150,
        hbSize = 12,
        fireRate = 3,
        shootsUntilCd = 5,
        cd = 3
    }
    local enemy = Enemy.new("enemy2", vec(x, y), moveFast, proj, nil, config)
    return enemy
end